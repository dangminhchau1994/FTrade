import type { VercelRequest, VercelResponse } from "@vercel/node";
import { FieldValue } from "firebase-admin/firestore";
import { db, auth } from "../lib/firebase-admin";
import type { FeedbackEntry, ApiResponse } from "../lib/types";

async function verifyAuth(authHeader: string | undefined): Promise<string | null> {
  if (!authHeader?.startsWith("Bearer ")) return null;
  try {
    const decoded = await auth.verifyIdToken(authHeader.slice(7));
    return decoded.uid;
  } catch {
    return null;
  }
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  const uid = await verifyAuth(req.headers.authorization);
  if (!uid) {
    const r: ApiResponse<null> = { success: false, error: { code: "UNAUTHENTICATED", message: "Missing or invalid auth token" } };
    res.status(401).json(r);
    return;
  }

  if (req.method === "POST") {
    const { briefDate, sectorId, isAccurate } = req.body ?? {};

    if (!briefDate || !sectorId || typeof isAccurate !== "boolean") {
      res.status(400).json({ success: false, error: { code: "INVALID_ARGUMENT", message: "briefDate, sectorId, isAccurate required" } });
      return;
    }
    if (!/^\d{4}-\d{2}-\d{2}$/.test(briefDate)) {
      res.status(400).json({ success: false, error: { code: "INVALID_ARGUMENT", message: "briefDate must be yyyy-MM-dd" } });
      return;
    }

    const briefDoc = await db.collection("morning_briefs").doc(briefDate).get();
    if (!briefDoc.exists) {
      res.status(404).json({ success: false, error: { code: "NOT_FOUND", message: `No brief found for ${briefDate}` } });
      return;
    }

    const docId = `${briefDate}_${sectorId}_${uid}`;
    const entry: FeedbackEntry = {
      briefDate, sectorId, isAccurate, uid,
      createdAt: FieldValue.serverTimestamp() as unknown as Date,
    };
    await db.collection("feedback").doc(docId).set(entry, { merge: true });

    const r: ApiResponse<{ id: string }> = { success: true, data: { id: docId } };
    res.json(r);

  } else if (req.method === "GET") {
    const dateParam = req.query.date as string | undefined;
    const snap = dateParam
      ? await db.collection("feedback").where("uid", "==", uid).where("briefDate", "==", dateParam).get()
      : await db.collection("feedback").where("uid", "==", uid).orderBy("createdAt", "desc").limit(50).get();

    const feedbacks = snap.docs.map((d) => {
      const data = d.data();
      return { briefDate: data.briefDate, sectorId: data.sectorId, isAccurate: data.isAccurate };
    });

    const r: ApiResponse<typeof feedbacks> = { success: true, data: feedbacks };
    res.json(r);

  } else {
    res.status(405).json({ success: false, error: { code: "METHOD_NOT_ALLOWED", message: "Use POST or GET" } });
  }
}
