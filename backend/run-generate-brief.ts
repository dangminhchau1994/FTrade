import { FieldValue } from "firebase-admin/firestore";
import { db, messaging } from "./lib/firebase-admin";
import { generateBriefWithAI } from "./lib/ai-client";
import { fetchMarketNews } from "./lib/news-fetcher";
import type { MorningBrief } from "./lib/types";

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

async function main() {
  const date = todayVN();
  const briefRef = db.collection("morning_briefs").doc(date);

  const existing = await briefRef.get();
  if (existing.exists && existing.data()?.status === "success") {
    console.log(`Brief ${date} already exists, skipping.`);
    process.exit(0);
  }

  console.log(`Generating Morning Brief for ${date}...`);

  const [newsContext, systemPromptOverride] = await Promise.all([
    fetchMarketNews(),
    getSystemPrompt(),
  ]);

  const backoffs = [2000, 8000, 30000];

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

      console.log(`✅ Brief ${date} generated. Cost: $${costUsd.toFixed(4)}`);
      process.exit(0);
    } catch (err) {
      console.error(`Attempt ${attempt + 1} failed:`, err);
      if (attempt >= 3) {
        await briefRef.set({ date, status: "failed", createdAt: FieldValue.serverTimestamp(), error: String(err) }, { merge: true });
        try {
          await messaging.send({
            topic: "admin-alerts",
            notification: { title: "FTrade: Brief failed", body: `${date}: ${String(err).slice(0, 100)}` },
          });
        } catch { /* ignore */ }
        process.exit(1);
      }
      await new Promise((r) => setTimeout(r, backoffs[attempt]));
    }
  }
}

main().catch((err) => { console.error(err); process.exit(1); });
