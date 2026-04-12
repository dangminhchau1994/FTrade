import * as admin from "firebase-admin";

if (!admin.apps.length) {
  const raw = process.env.FIREBASE_SERVICE_ACCOUNT ?? "{}";
  let serviceAccount: object;
  try {
    serviceAccount = JSON.parse(raw);
  } catch {
    // Vercel may store actual newlines inside JSON string values — fix private key field
    const fixed = raw.replace(
      /("private_key"\s*:\s*")([\s\S]*?)(?="[\s,\n}])/,
      (_, prefix, key) => prefix + key.replace(/\n/g, "\\n")
    );
    serviceAccount = JSON.parse(fixed);
  }
  admin.initializeApp({ credential: admin.credential.cert(serviceAccount as admin.ServiceAccount) });
}

// Use REST transport instead of gRPC — more reliable in serverless environments
const firestore = admin.firestore();
firestore.settings({ preferRest: true });

export const db = firestore;
export const auth = admin.auth();
export const messaging = admin.messaging();
