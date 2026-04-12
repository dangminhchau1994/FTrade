import type { VercelRequest, VercelResponse } from "@vercel/node";
import { FieldValue } from "firebase-admin/firestore";
import { db, messaging } from "../../lib/firebase-admin";
import { generateBriefWithAI } from "../../lib/ai-client";
import { fetchMarketNews } from "../../lib/news-fetcher";
import type { MorningBrief } from "../../lib/types";

function todayVN(): string {
  const vn = new Date(Date.now() + 7 * 60 * 60 * 1000);
  return vn.toISOString().slice(0, 10);
}

async function getSystemPrompt(): Promise<string | undefined> {
  try {
    const doc = await db.collection("system_config").doc("openai_prompt").get();
    return doc.exists ? (doc.data()?.prompt as string) : undefined;
  } catch {
    return undefined;
  }
}

async function runGeneration(): Promise<void> {
  const date = todayVN();
  const briefRef = db.collection("morning_briefs").doc(date);

  const existing = await briefRef.get();
  if (existing.exists && existing.data()?.status === "success") {
    console.log(`Brief ${date} already exists, skipping.`);
    return;
  }

  console.log(`Generating Morning Brief for ${date}`);

  const isDryRun = process.env.DRY_RUN === "true";
  const [newsContext, systemPromptOverride] = await Promise.all([
    isDryRun ? Promise.resolve("[DRY RUN - no news fetch]") : fetchMarketNews(),
    getSystemPrompt(),
  ]);

  const backoffs = [1000, 4000, 16000];

  for (let attempt = 0; attempt <= 3; attempt++) {
    try {
      const { brief, tokens, costUsd } = await generateBriefWithAI(newsContext, systemPromptOverride);

      const doc: MorningBrief = {
        date,
        summary: brief.summary,
        sectors: brief.sectors,
        createdAt: FieldValue.serverTimestamp() as unknown as Date,
        status: "success",
        costUsd,
        promptTokens: tokens.prompt,
        completionTokens: tokens.completion,
      };

      await briefRef.set(doc);

      await db.collection("api_costs").add({
        timestamp: FieldValue.serverTimestamp(),
        function: "generateMorningBrief",
        promptTokens: tokens.prompt,
        completionTokens: tokens.completion,
        costUsd,
        briefDate: date,
      });

      console.log(`Brief ${date} generated. Cost: $${costUsd.toFixed(4)}`);
      return;

    } catch (err) {
      console.error(`Generation attempt ${attempt + 1} failed:`, err);

      if (attempt >= 3) {
        await briefRef.set({
          date, status: "failed",
          createdAt: FieldValue.serverTimestamp(),
          error: String(err),
        }, { merge: true });

        // Notify admin (best-effort)
        try {
          await messaging.send({
            topic: "admin-alerts",
            notification: { title: "FTrade: Brief generation failed", body: `${date}: ${String(err).slice(0, 100)}` },
          });
        } catch { /* ignore */ }

        throw err;
      }

      await new Promise((r) => setTimeout(r, backoffs[attempt]));
    }
  }
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  // Vercel cron requests include this header automatically
  const isVercelCron = !!req.headers["x-vercel-cron-signature"];
  const isManualWithSecret = req.headers.authorization === `Bearer ${process.env.CRON_SECRET}`;

  if (!isVercelCron && !isManualWithSecret) {
    res.status(401).json({ success: false, error: "Unauthorized" });
    return;
  }

  try {
    await runGeneration();
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, error: String(err) });
  }
}
