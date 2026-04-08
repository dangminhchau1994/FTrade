import * as admin from "firebase-admin";
import { FieldValue } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { onRequest } from "firebase-functions/v2/https";
import { generateBriefWithAI } from "./ai-client";
import { fetchMarketNews } from "./news-fetcher";
import { MorningBrief } from "./types";

const db = () => admin.firestore();

function todayDateString(): string {
  const d = new Date();
  // GMT+7
  const vn = new Date(d.getTime() + 7 * 60 * 60 * 1000);
  return vn.toISOString().slice(0, 10);
}

async function getSystemPrompt(): Promise<string | undefined> {
  try {
    const doc = await db().collection("system_config").doc("claude_prompt").get();
    return doc.exists ? (doc.data()?.prompt as string) : undefined;
  } catch {
    return undefined;
  }
}

async function runGeneration(): Promise<void> {
  const date = todayDateString();
  const briefRef = db().collection("morning_briefs").doc(date);

  // Avoid re-generating if already exists and successful
  const existing = await briefRef.get();
  if (existing.exists && existing.data()?.status === "success") {
    logger.info(`Brief ${date} already exists, skipping.`);
    return;
  }

  logger.info(`Generating Morning Brief for ${date}`);

  const [newsContext, systemPromptOverride] = await Promise.all([
    fetchMarketNews(),
    getSystemPrompt(),
  ]);

  let retries = 0;
  const maxRetries = 3;
  const backoffs = [1000, 4000, 16000];

  while (retries <= maxRetries) {
    try {
      const { brief, tokens, costUsd } = await generateBriefWithAI(newsContext, systemPromptOverride);

      const doc: MorningBrief = {
        date,
        summary: brief.summary,
        sectors: brief.sectors,
        createdAt: FieldValue.serverTimestamp() as FirebaseFirestore.Timestamp,
        status: "success",
        costUsd,
        promptTokens: tokens.prompt,
        completionTokens: tokens.completion,
      };

      await briefRef.set(doc);

      // Log cost
      await db().collection("api_costs").add({
        timestamp: FieldValue.serverTimestamp(),
        function: "generateMorningBrief",
        promptTokens: tokens.prompt,
        completionTokens: tokens.completion,
        costUsd,
        briefDate: date,
      });

      logger.info(`Brief ${date} generated. Cost: $${costUsd.toFixed(4)}`);
      return;
    } catch (err) {
      retries++;
      logger.error(`Generation attempt ${retries} failed:`, err);

      if (retries > maxRetries) {
        await briefRef.set({
          date,
          status: "failed",
          createdAt: FieldValue.serverTimestamp(),
          error: String(err),
        }, { merge: true });

        // Notify admin via FCM (best-effort)
        try {
          await admin.messaging().send({
            topic: "admin-alerts",
            notification: { title: "FTrade: Brief generation failed", body: `${date}: ${String(err).slice(0, 100)}` },
          });
        } catch { /* ignore */ }

        throw err;
      }

      await new Promise((r) => setTimeout(r, backoffs[retries - 1]));
    }
  }
}

// Cron: 7h sáng GMT+7 = 0h UTC
export const generateMorningBriefScheduled = onSchedule(
  { schedule: "0 0 * * *", timeZone: "Asia/Ho_Chi_Minh", region: "asia-southeast1" },
  async () => {
    await runGeneration();
  }
);

// Manual trigger endpoint (admin only, for testing)
export const triggerMorningBrief = onRequest(
  { region: "asia-southeast1" },
  async (req, res) => {
    if (req.method !== "POST") { res.status(405).send("Method Not Allowed"); return; }
    try {
      await runGeneration();
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: String(err) });
    }
  }
);
