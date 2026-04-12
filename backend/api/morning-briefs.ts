import type { VercelRequest, VercelResponse } from "@vercel/node";
import { db, auth } from "../lib/firebase-admin";
import type { MorningBrief, ApiResponse } from "../lib/types";

function todayVN(): string {
  const vn = new Date(Date.now() + 7 * 60 * 60 * 1000);
  return vn.toISOString().slice(0, 10);
}

async function getLatestBrief(targetDate?: string): Promise<MorningBrief | null> {
  if (targetDate) {
    const doc = await db.collection("morning_briefs").doc(targetDate).get();
    if (doc.exists && doc.data()?.status === "success") return doc.data() as MorningBrief;
    return null;
  }

  const today = todayVN();
  const todayDoc = await db.collection("morning_briefs").doc(today).get();
  if (todayDoc.exists && todayDoc.data()?.status === "success") {
    return todayDoc.data() as MorningBrief;
  }

  // Fallback: most recent successful brief
  const snap = await db
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

export default async function handler(req: VercelRequest, res: VercelResponse) {
  if (req.method !== "GET") {
    res.status(405).json({ success: false, error: { code: "METHOD_NOT_ALLOWED", message: "Use GET" } });
    return;
  }

  // Auth check
  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith("Bearer ")) {
    const r: ApiResponse<null> = { success: false, error: { code: "UNAUTHENTICATED", message: "Missing auth token" } };
    res.status(401).json(r);
    return;
  }
  try {
    await auth.verifyIdToken(authHeader.slice(7));
  } catch {
    const r: ApiResponse<null> = { success: false, error: { code: "UNAUTHENTICATED", message: "Invalid token" } };
    res.status(401).json(r);
    return;
  }

  res.setHeader("Cache-Control", "public, max-age=3600, s-maxage=14400");

  const queryDate = req.query.date as string | undefined;
  const targetDate = queryDate && /^\d{4}-\d{2}-\d{2}$/.test(queryDate) ? queryDate : undefined;

  const brief = await getLatestBrief(targetDate);
  if (!brief) {
    const r: ApiResponse<null> = { success: false, error: { code: "NOT_FOUND", message: "Chưa có bản tin nào" } };
    res.status(404).json(r);
    return;
  }

  // Convert Firestore Timestamp to ISO string
  const ts = brief.createdAt as any;
  const createdAtIso: string = ts?.toDate ? ts.toDate().toISOString() : new Date().toISOString();
  const serialized = { ...brief, createdAt: createdAtIso };

  const r: ApiResponse<typeof serialized> = { success: true, data: serialized };
  res.json(r);
}
