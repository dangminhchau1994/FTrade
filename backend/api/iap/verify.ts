import type { VercelRequest, VercelResponse } from "@vercel/node";
import { FieldValue } from "firebase-admin/firestore";
import { db, auth } from "../../lib/firebase-admin";
import axios from "axios";
import type { ApiResponse } from "../../lib/types";

const APPLE_PROD_URL = "https://buy.itunes.apple.com/verifyReceipt";
const APPLE_SANDBOX_URL = "https://sandbox.itunes.apple.com/verifyReceipt";

async function verifyApple(receiptData: string): Promise<boolean> {
  const secret = process.env.APPLE_SHARED_SECRET ?? "";
  const body = { "receipt-data": receiptData, password: secret, "exclude-old-transactions": true };
  try {
    let resp = await axios.post(APPLE_PROD_URL, body, { timeout: 10000 });
    // status 21007 = sandbox receipt sent to production, retry with sandbox
    if (resp.data.status === 21007) {
      resp = await axios.post(APPLE_SANDBOX_URL, body, { timeout: 10000 });
    }
    if (resp.data.status !== 0) return false;
    const latest: any[] = resp.data.latest_receipt_info ?? [];
    const now = Date.now();
    return latest.some((r) => parseInt(r.expires_date_ms ?? "0") > now);
  } catch (err) {
    console.warn("Apple verify error:", err instanceof Error ? err.message : err);
    return false;
  }
}

async function verifyGoogle(purchaseToken: string, productId: string): Promise<boolean> {
  try {
    const serviceAccount = JSON.parse(process.env.GOOGLE_PLAY_SERVICE_ACCOUNT ?? "{}");
    // Get access token via service account JWT
    const jwt = await import("jsonwebtoken");
    const now = Math.floor(Date.now() / 1000);
    const token = jwt.sign(
      { iss: serviceAccount.client_email, sub: serviceAccount.client_email,
        aud: "https://oauth2.googleapis.com/token", iat: now, exp: now + 3600,
        scope: "https://www.googleapis.com/auth/androidpublisher" },
      serviceAccount.private_key,
      { algorithm: "RS256" }
    );
    const tokenResp = await axios.post("https://oauth2.googleapis.com/token",
      `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${token}`,
      { headers: { "Content-Type": "application/x-www-form-urlencoded" }, timeout: 10000 }
    );
    const accessToken = tokenResp.data.access_token as string;
    const url = `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/com.ftrade.ftrade/purchases/subscriptions/${productId}/tokens/${purchaseToken}`;
    const resp = await axios.get(url, { headers: { Authorization: `Bearer ${accessToken}` }, timeout: 10000 });
    const expiry = parseInt(resp.data.expiryTimeMillis ?? "0");
    return expiry > Date.now();
  } catch (err) {
    console.warn("Google verify error:", err instanceof Error ? err.message : err);
    return false;
  }
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  if (req.method !== "POST") {
    res.status(405).json({ success: false, error: { code: "METHOD_NOT_ALLOWED" } });
    return;
  }

  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith("Bearer ")) {
    res.status(401).json({ success: false, error: { code: "UNAUTHENTICATED" } });
    return;
  }

  let uid: string;
  try {
    const decoded = await auth.verifyIdToken(authHeader.slice(7));
    uid = decoded.uid;
  } catch {
    res.status(401).json({ success: false, error: { code: "UNAUTHENTICATED" } });
    return;
  }

  const { platform, receiptData, purchaseToken, productId } = req.body ?? {};

  if (!platform || !productId) {
    res.status(400).json({ success: false, error: { code: "INVALID_ARGUMENT", message: "platform và productId là bắt buộc" } });
    return;
  }

  let isValid = false;
  if (platform === "ios") {
    if (!receiptData) { res.status(400).json({ success: false, error: { code: "INVALID_ARGUMENT", message: "receiptData required for iOS" } }); return; }
    isValid = await verifyApple(receiptData as string);
  } else if (platform === "android") {
    if (!purchaseToken) { res.status(400).json({ success: false, error: { code: "INVALID_ARGUMENT", message: "purchaseToken required for Android" } }); return; }
    isValid = await verifyGoogle(purchaseToken as string, productId as string);
  } else {
    res.status(400).json({ success: false, error: { code: "INVALID_ARGUMENT", message: "platform phải là ios hoặc android" } });
    return;
  }

  if (!isValid) {
    const r: ApiResponse<null> = { success: false, error: { code: "VERIFICATION_FAILED", message: "Không thể xác minh thanh toán. Vui lòng thử lại." } };
    res.status(400).json(r);
    return;
  }

  await db.collection("users").doc(uid).update({
    tier: "premium",
    premiumSince: FieldValue.serverTimestamp(),
    premiumPlatform: platform,
    premiumProductId: productId,
  });

  const r: ApiResponse<{ tier: string }> = { success: true, data: { tier: "premium" } };
  res.json(r);
}
