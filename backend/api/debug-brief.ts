import type { VercelRequest, VercelResponse } from "@vercel/node";
import { FieldValue } from "firebase-admin/firestore";
import { db } from "../lib/firebase-admin";
import { generateBriefWithAI } from "../lib/ai-client";
import { fetchMarketNews } from "../lib/news-fetcher";

function todayVN(): string {
  const vn = new Date(Date.now() + 7 * 60 * 60 * 1000);
  return vn.toISOString().slice(0, 10);
}

export default async function handler(_req: VercelRequest, res: VercelResponse) {
  const steps: string[] = [];
  try {
    // Step 1: Firestore read
    const date = todayVN();
    steps.push(`step1: todayVN=${date}`);
    const briefRef = db.collection("morning_briefs").doc(date);
    const existing = await briefRef.get();
    steps.push(`step2: briefRef.get() ok, exists=${existing.exists}`);

    // Step 2: System prompt
    const spDoc = await db.collection("system_config").doc("openai_prompt").get();
    steps.push(`step3: system_config read ok, exists=${spDoc.exists}`);

    // Step 3: AI (DRY_RUN)
    const brief = await generateBriefWithAI("[debug]");
    steps.push(`step4: generateBriefWithAI ok`);

    // Step 4: Write brief
    await briefRef.set({
      date, summary: brief.brief.summary, sectors: brief.brief.sectors,
      createdAt: FieldValue.serverTimestamp(),
      status: "success", costUsd: 0, promptTokens: 0, completionTokens: 0,
    });
    steps.push(`step5: briefRef.set() ok`);

    res.json({ success: true, steps });
  } catch (err) {
    res.status(500).json({ success: false, steps, error: String(err), stack: err instanceof Error ? err.stack?.slice(0, 500) : undefined });
  }
}
