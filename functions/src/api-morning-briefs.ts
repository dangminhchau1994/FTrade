import * as admin from "firebase-admin";
import { onRequest } from "firebase-functions/v2/https";
import { MorningBrief, ApiResponse } from "./types";

const db = () => admin.firestore();

function todayDateString(): string {
  const d = new Date();
  const vn = new Date(d.getTime() + 7 * 60 * 60 * 1000);
  return vn.toISOString().slice(0, 10);
}

async function getLatestBrief(targetDate?: string): Promise<MorningBrief | null> {
  if (targetDate) {
    const doc = await db().collection("morning_briefs").doc(targetDate).get();
    if (doc.exists && doc.data()?.status === "success") {
      return doc.data() as MorningBrief;
    }
    return null;
  }

  // Get today first, fallback to most recent
  const today = todayDateString();
  const todayDoc = await db().collection("morning_briefs").doc(today).get();
  if (todayDoc.exists && todayDoc.data()?.status === "success") {
    return todayDoc.data() as MorningBrief;
  }

  // Fallback: most recent successful brief
  const snap = await db()
    .collection("morning_briefs")
    .where("status", "==", "success")
    .orderBy("date", "desc")
    .limit(1)
    .get();

  if (snap.empty) return null;

  const data = snap.docs[0].data() as MorningBrief;
  data.isFallback = true;
  data.fallbackReason = snap.docs[0].id === today
    ? "Brief hôm nay đang được tạo"
    : `Chưa có bản tin hôm nay — hiển thị bản tin ${snap.docs[0].id}`;
  return data;
}

export const morningBriefs = onRequest(
  { region: "asia-southeast1", cors: true },
  async (req, res) => {
    // Auth check — skip strict verification in emulator
    const isEmulator = process.env.FUNCTIONS_EMULATOR === "true";
    const authHeader = req.headers.authorization;

    if (!isEmulator) {
      if (!authHeader?.startsWith("Bearer ")) {
        const r: ApiResponse<null> = { success: false, error: { code: "UNAUTHENTICATED", message: "Missing auth token" } };
        res.status(401).json(r);
        return;
      }
      try {
        await admin.auth().verifyIdToken(authHeader.slice(7));
      } catch {
        const r: ApiResponse<null> = { success: false, error: { code: "UNAUTHENTICATED", message: "Invalid token" } };
        res.status(401).json(r);
        return;
      }
    } else {
      console.log("[morningBriefs] Emulator mode — skipping strict auth");
    }

    // Rate limit header (simple — real rate limiting via middleware)
    res.setHeader("Cache-Control", "public, max-age=3600, s-maxage=14400");

    // Support both path param and query param for date
    const pathDate = req.path.split("/").filter(Boolean)[0];
    const queryDate = req.query.date as string | undefined;
    const raw = queryDate || pathDate;
    const targetDate = raw && /^\d{4}-\d{2}-\d{2}$/.test(raw) ? raw : undefined;

    console.log(`[morningBriefs] path=${req.path}, query.date=${queryDate}, targetDate=${targetDate}`);

    const brief = await getLatestBrief(targetDate);

    if (!brief) {
      const r: ApiResponse<null> = {
        success: false,
        error: { code: "NOT_FOUND", message: "Chưa có bản tin nào" },
      };
      res.status(404).json(r);
      return;
    }

    // Convert Firestore Timestamp to ISO string for client
    const ts = brief.createdAt as any;
    const createdAtIso: string = ts?.toDate
      ? ts.toDate().toISOString()
      : ts instanceof Date
        ? ts.toISOString()
        : new Date().toISOString();
    const serialized = { ...brief, createdAt: createdAtIso };

    const r: ApiResponse<typeof serialized> = { success: true, data: serialized };
    res.json(r);
  }
);
