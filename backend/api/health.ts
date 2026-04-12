import type { VercelRequest, VercelResponse } from "@vercel/node";
import { db } from "../lib/firebase-admin";

export default async function handler(_req: VercelRequest, res: VercelResponse) {
  try {
    const snap = await db.collection("_health").doc("test").get();
    res.json({ success: true, exists: snap.exists });
  } catch (err) {
    res.json({
      success: false,
      error: String(err),
      stack: err instanceof Error ? err.stack?.slice(0, 1000) : undefined,
    });
  }
}
