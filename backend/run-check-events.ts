/**
 * Contextual Alert cron — runs daily after market open.
 * 1. Fetch all upcoming corporate events from Vietstock (1 pass, no per-user calls)
 * 2. Load all users with FCM tokens and their watchlistSymbols from Firestore
 * 3. For each user, match events against their watchlist
 * 4. Send FCM push, record sent alert IDs to avoid duplicates
 */

import { db, messaging } from "./lib/firebase-admin";
import { fetchUpcomingEvents, UpcomingEvent } from "./lib/vietstock-client";
import { FieldValue } from "firebase-admin/firestore";

function todayVN(): string {
  return new Date(Date.now() + 7 * 3600_000).toISOString().slice(0, 10);
}

function alertId(uid: string, ev: UpcomingEvent): string {
  return `${uid}_${ev.symbol}_${ev.type}_${ev.eventDate.toISOString().slice(0, 10)}`;
}

function buildNotification(ev: UpcomingEvent): { title: string; body: string } {
  const dd = `${String(ev.eventDate.getDate()).padStart(2, "0")}/${String(ev.eventDate.getMonth() + 1).padStart(2, "0")}`;
  switch (ev.type) {
    case "dividend": {
      const amount = ev.cashAmount ? ` ${Math.round(ev.cashAmount).toLocaleString()}\u0111/CP` : "";
      return {
        title: `💰 Chốt quyền cổ tức ${ev.symbol}`,
        body: `${ev.symbol} chốt quyền${amount} ngày ${dd}`,
      };
    }
    case "rights":
      return {
        title: `📋 Quyền mua thêm ${ev.symbol}`,
        body: `${ev.symbol} chốt quyền mua thêm ngày ${dd}`,
      };
    case "agm":
      return {
        title: `🏛️ ĐHCĐ ${ev.symbol}`,
        body: `${ev.title || ev.symbol + " tổ chức ĐHCĐ"} ngày ${dd}`,
      };
    default:
      return {
        title: `🔔 Sự kiện ${ev.symbol}`,
        body: `${ev.title} · Ngày ${dd}`,
      };
  }
}

async function main() {
  console.log(`[check-events] ${todayVN()} — start`);

  // 1. Fetch all upcoming events from Vietstock (single pass)
  console.log("[check-events] Fetching upcoming corporate events...");
  const events = await fetchUpcomingEvents(3);
  console.log(`[check-events] Found ${events.length} upcoming events`);

  if (events.length === 0) {
    console.log("[check-events] No events in next 3 days, done.");
    return;
  }

  // Build a symbol → events map for quick lookup
  const eventsBySymbol = new Map<string, UpcomingEvent[]>();
  for (const ev of events) {
    const list = eventsBySymbol.get(ev.symbol) ?? [];
    list.push(ev);
    eventsBySymbol.set(ev.symbol, list);
  }

  // 2. Load all users with FCM tokens
  const snapshot = await db
    .collection("users")
    .where("fcmToken", "!=", null)
    .get();

  console.log(`[check-events] ${snapshot.size} users with FCM tokens`);

  let sent = 0;
  let skipped = 0;

  for (const doc of snapshot.docs) {
    const uid = doc.id;
    const data = doc.data();
    const fcmToken = data.fcmToken as string | undefined;
    const watchlistSymbols: string[] = data.watchlistSymbols ?? [];
    const sentAlerts: string[] = data.sentEventAlerts ?? [];
    const sentSet = new Set(sentAlerts);

    if (!fcmToken || watchlistSymbols.length === 0) continue;

    // 3. Find matching events for this user's watchlist
    const toSend: UpcomingEvent[] = [];
    for (const symbol of watchlistSymbols) {
      const symbolEvents = eventsBySymbol.get(symbol.toUpperCase()) ?? [];
      for (const ev of symbolEvents) {
        const id = alertId(uid, ev);
        if (!sentSet.has(id)) toSend.push(ev);
      }
    }

    if (toSend.length === 0) {
      skipped++;
      continue;
    }

    // 4. Send one FCM message per event (batch if many)
    const newAlertIds: string[] = [];
    for (const ev of toSend) {
      const { title, body } = buildNotification(ev);
      try {
        await messaging.send({
          token: fcmToken,
          notification: { title, body },
          data: {
            type: "contextual_alert",
            symbol: ev.symbol,
            eventType: ev.type,
          },
          apns: {
            payload: { aps: { sound: "default", badge: 1 } },
          },
          android: { priority: "high" },
        });
        newAlertIds.push(alertId(uid, ev));
        sent++;
        console.log(`[check-events] Sent to ${uid}: ${title}`);
      } catch (err) {
        console.error(`[check-events] FCM error for ${uid}:`, err);
      }
    }

    // 5. Persist sent alert IDs so we don't re-notify
    if (newAlertIds.length > 0) {
      await db.collection("users").doc(uid).update({
        sentEventAlerts: FieldValue.arrayUnion(...newAlertIds),
      });
    }
  }

  console.log(`[check-events] Done — sent: ${sent}, skipped: ${skipped} users`);
}

main().catch((err) => {
  console.error("[check-events] Fatal:", err);
  process.exit(1);
});
