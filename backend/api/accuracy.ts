import type { VercelRequest, VercelResponse } from "@vercel/node";
import { db, auth } from "../lib/firebase-admin";
import type { AccuracyLog, AccuracySummary, ApiResponse } from "../lib/types";

function getWeekLabel(dateStr: string): string {
  const d = new Date(dateStr);
  const startOfYear = new Date(d.getFullYear(), 0, 1);
  const weekNum = Math.ceil(((d.getTime() - startOfYear.getTime()) / 86400000 + startOfYear.getDay() + 1) / 7);
  return `${d.getFullYear()}-W${weekNum.toString().padStart(2, "0")}`;
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  if (req.method !== "GET") {
    res.status(405).json({ success: false, error: { code: "METHOD_NOT_ALLOWED", message: "Use GET" } });
    return;
  }

  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith("Bearer ")) {
    res.status(401).json({ success: false, error: { code: "UNAUTHENTICATED", message: "Missing auth token" } });
    return;
  }
  try {
    await auth.verifyIdToken(authHeader.slice(7));
  } catch {
    res.status(401).json({ success: false, error: { code: "UNAUTHENTICATED", message: "Invalid token" } });
    return;
  }

  const weeks = Math.min(Math.max(parseInt(req.query.weeks as string) || 4, 1), 52);
  const cutoffDate = new Date();
  cutoffDate.setDate(cutoffDate.getDate() - weeks * 7);
  const cutoffStr = cutoffDate.toISOString().slice(0, 10);

  const snap = await db
    .collection("accuracy_logs")
    .where("briefDate", ">=", cutoffStr)
    .orderBy("briefDate", "desc")
    .get();

  const logs = snap.docs.map((d) => d.data() as AccuracyLog);
  const conclusive = logs.filter((l) => l.isCorrect !== null);

  const bySector: Record<string, { total: number; correct: number; rate: number }> = {};
  for (const log of conclusive) {
    if (!bySector[log.sectorId]) bySector[log.sectorId] = { total: 0, correct: 0, rate: 0 };
    bySector[log.sectorId].total++;
    if (log.isCorrect) bySector[log.sectorId].correct++;
  }
  for (const s of Object.values(bySector)) {
    s.rate = s.total > 0 ? Math.round((s.correct / s.total) * 100) : 0;
  }

  const weekMap = new Map<string, { correct: number; total: number }>();
  for (const log of conclusive) {
    const week = getWeekLabel(log.briefDate);
    const w = weekMap.get(week) ?? { correct: 0, total: 0 };
    w.total++;
    if (log.isCorrect) w.correct++;
    weekMap.set(week, w);
  }

  const weeklyTrend = Array.from(weekMap.entries())
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([week, w]) => ({ week, rate: w.total > 0 ? Math.round((w.correct / w.total) * 100) : 0, total: w.total }));

  const totalCorrect = conclusive.filter((l) => l.isCorrect).length;
  const summary: AccuracySummary = {
    totalPredictions: conclusive.length,
    correctPredictions: totalCorrect,
    accuracyRate: conclusive.length > 0 ? Math.round((totalCorrect / conclusive.length) * 100) : 0,
    bySector,
    weeklyTrend,
  };

  const r: ApiResponse<AccuracySummary> = { success: true, data: summary };
  res.json(r);
}
