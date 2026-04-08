import * as admin from "firebase-admin";
import { FieldValue } from "firebase-admin/firestore";
import { onRequest } from "firebase-functions/v2/https";
import { FeedbackEntry, ApiResponse } from "./types";

const db = () => admin.firestore();

async function verifyAuth(authHeader: string | undefined): Promise<string | null> {
  const isEmulator = process.env.FUNCTIONS_EMULATOR === "true";
  if (isEmulator) {
    console.log("[feedback] Emulator mode — using anonymous uid");
    return "emulator-user";
  }
  if (!authHeader?.startsWith("Bearer ")) return null;
  try {
    const decoded = await admin.auth().verifyIdToken(authHeader.slice(7));
    return decoded.uid;
  } catch {
    return null;
  }
}

/**
 * POST /feedback — Submit feedback for a sector prediction
 * Body: { briefDate, sectorId, isAccurate }
 *
 * GET /feedback/:date — Get user's feedbacks for a specific brief date
 */
export const feedback = onRequest(
  { region: "asia-southeast1", cors: true },
  async (req, res) => {
    const uid = await verifyAuth(req.headers.authorization);
    if (!uid) {
      const r: ApiResponse<null> = {
        success: false,
        error: { code: "UNAUTHENTICATED", message: "Missing or invalid auth token" },
      };
      res.status(401).json(r);
      return;
    }

    if (req.method === "POST") {
      await handleSubmit(req, res, uid);
    } else if (req.method === "GET") {
      await handleGet(req, res, uid);
    } else {
      res.status(405).json({ success: false, error: { code: "METHOD_NOT_ALLOWED", message: "Use POST or GET" } });
    }
  }
);

async function handleSubmit(
  req: import("firebase-functions/v2/https").Request,
  res: import("express").Response,
  uid: string
) {
  const { briefDate, sectorId, isAccurate } = req.body ?? {};

  if (!briefDate || !sectorId || typeof isAccurate !== "boolean") {
    const r: ApiResponse<null> = {
      success: false,
      error: { code: "INVALID_ARGUMENT", message: "briefDate, sectorId, isAccurate required" },
    };
    res.status(400).json(r);
    return;
  }

  // Validate date format
  if (!/^\d{4}-\d{2}-\d{2}$/.test(briefDate)) {
    const r: ApiResponse<null> = {
      success: false,
      error: { code: "INVALID_ARGUMENT", message: "briefDate must be yyyy-MM-dd" },
    };
    res.status(400).json(r);
    return;
  }

  // Verify brief exists
  const briefDoc = await db().collection("morning_briefs").doc(briefDate).get();
  if (!briefDoc.exists) {
    const r: ApiResponse<null> = {
      success: false,
      error: { code: "NOT_FOUND", message: `No brief found for ${briefDate}` },
    };
    res.status(404).json(r);
    return;
  }

  // Upsert feedback (one per user per sector per date)
  const docId = `${briefDate}_${sectorId}_${uid}`;
  const entry: FeedbackEntry = {
    briefDate,
    sectorId,
    isAccurate,
    uid,
    createdAt: FieldValue.serverTimestamp() as unknown as FirebaseFirestore.Timestamp,
  };

  await db().collection("feedback").doc(docId).set(entry, { merge: true });

  const r: ApiResponse<{ id: string }> = { success: true, data: { id: docId } };
  res.json(r);
}

async function handleGet(
  req: import("firebase-functions/v2/https").Request,
  res: import("express").Response,
  uid: string
) {
  // Extract date from path: /feedback/2026-04-08 or just /feedback (returns today)
  const pathParts = req.path.split("/").filter(Boolean);
  const dateParam = pathParts.find((p) => /^\d{4}-\d{2}-\d{2}$/.test(p));

  const snap = dateParam
    ? await db()
        .collection("feedback")
        .where("uid", "==", uid)
        .where("briefDate", "==", dateParam)
        .get()
    : await db()
        .collection("feedback")
        .where("uid", "==", uid)
        .orderBy("createdAt", "desc")
        .limit(50)
        .get();

  const feedbacks = snap.docs.map((d) => {
    const data = d.data();
    return {
      briefDate: data.briefDate,
      sectorId: data.sectorId,
      isAccurate: data.isAccurate,
    };
  });

  const r: ApiResponse<typeof feedbacks> = { success: true, data: feedbacks };
  res.json(r);
}
