import * as admin from "firebase-admin";
import { FieldValue } from "firebase-admin/firestore";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { onRequest } from "firebase-functions/v2/https";
import { MorningBrief, SectorAnalysis, AccuracyLog, VN_SECTORS } from "./types";
import axios from "axios";

const db = () => admin.firestore();

function todayDateString(): string {
  const d = new Date();
  const vn = new Date(d.getTime() + 7 * 60 * 60 * 1000);
  return vn.toISOString().slice(0, 10);
}

// Map sector IDs to representative stock symbols for measuring actual performance
const SECTOR_PROXY_SYMBOLS: Record<string, string[]> = {
  banking: ["VCB", "TCB", "MBB", "BID", "CTG"],
  real_estate: ["VHM", "VIC", "NVL", "KDH", "DXG"],
  technology: ["FPT", "CMG", "ELC"],
  energy: ["GAS", "PLX", "PVD", "PVS", "BSR"],
  consumer: ["MWG", "PNJ", "VRE", "MSN", "SAB"],
  steel_materials: ["HPG", "HSG", "NKG", "TLH"],
  agriculture: ["DPM", "DCM", "LTG", "PAN", "HAG"],
};

/**
 * Fetch end-of-day change % for a list of symbols from VNDirect.
 * Returns map: symbol → changePercent
 */
async function fetchEodChanges(symbols: string[]): Promise<Record<string, number>> {
  const result: Record<string, number> = {};

  try {
    // VNDirect stock board API — public, no auth needed
    const url = "https://finfo-api.vndirect.com.vn/v4/stock_prices";
    const resp = await axios.get(url, {
      params: {
        sort: "date",
        size: symbols.length,
        page: 1,
        q: `code:${symbols.join(",")}~date:${todayDateString()}`,
      },
      headers: { "User-Agent": "FTrade/1.0" },
      timeout: 15000,
    });

    const data = resp.data?.data ?? [];
    for (const item of data) {
      if (item.code && typeof item.pctChange === "number") {
        result[item.code] = item.pctChange;
      }
    }
  } catch (err) {
    console.warn("fetchEodChanges failed:", err instanceof Error ? err.message : err);
  }

  return result;
}

/**
 * Calculate sector average change % from proxy symbols
 */
async function getSectorActualChanges(): Promise<Record<string, number | null>> {
  const allSymbols = Object.values(SECTOR_PROXY_SYMBOLS).flat();
  const changes = await fetchEodChanges(allSymbols);

  const sectorChanges: Record<string, number | null> = {};

  for (const [sectorId, symbols] of Object.entries(SECTOR_PROXY_SYMBOLS)) {
    const validChanges = symbols
      .map((s) => changes[s])
      .filter((c): c is number => c !== undefined);

    sectorChanges[sectorId] = validChanges.length > 0
      ? validChanges.reduce((a, b) => a + b, 0) / validChanges.length
      : null;
  }

  return sectorChanges;
}

/**
 * Evaluate if a prediction was correct.
 * positive prediction → actual change >= +0.5%
 * negative prediction → actual change <= -0.5%
 * neutral prediction → actual change between -0.5% and +0.5%
 * Returns null if actual change is between -0.5% and +0.5% (inconclusive for positive/negative)
 */
function evaluatePrediction(
  predictedImpact: SectorAnalysis["impact"],
  actualChangePercent: number
): boolean | null {
  const threshold = 0.5;

  if (predictedImpact === "neutral") {
    // Neutral is correct if market didn't move much
    return Math.abs(actualChangePercent) < threshold;
  }

  // If market barely moved, inconclusive for directional predictions
  if (Math.abs(actualChangePercent) < threshold) return null;

  if (predictedImpact === "positive") return actualChangePercent > 0;
  if (predictedImpact === "negative") return actualChangePercent < 0;

  return null;
}

/**
 * Core logic: evaluate today's brief against actual market data
 */
async function evaluateAccuracy(date: string): Promise<number> {
  const briefDoc = await db().collection("morning_briefs").doc(date).get();
  if (!briefDoc.exists) {
    console.log(`No brief found for ${date}, skipping accuracy evaluation`);
    return 0;
  }

  const brief = briefDoc.data() as MorningBrief;
  if (brief.status !== "success" || !brief.sectors?.length) {
    console.log(`Brief ${date} status=${brief.status}, skipping`);
    return 0;
  }

  const sectorChanges = await getSectorActualChanges();
  const batch = db().batch();
  let count = 0;

  const sectorNameMap = Object.fromEntries(VN_SECTORS.map((s) => [s.id, s.name]));

  for (const sector of brief.sectors) {
    const actualChange = sectorChanges[sector.sectorId] ?? null;

    const log: AccuracyLog = {
      briefDate: date,
      sectorId: sector.sectorId,
      sectorName: sectorNameMap[sector.sectorId] || sector.sectorName,
      predictedImpact: sector.impact,
      actualChangePercent: actualChange,
      isCorrect: actualChange !== null ? evaluatePrediction(sector.impact, actualChange) : null,
      evaluatedAt: FieldValue.serverTimestamp() as unknown as FirebaseFirestore.Timestamp,
    };

    const docId = `${date}_${sector.sectorId}`;
    batch.set(db().collection("accuracy_logs").doc(docId), log, { merge: true });
    count++;
  }

  await batch.commit();
  console.log(`Accuracy evaluation for ${date}: ${count} sectors logged`);
  return count;
}

/**
 * Scheduled: run daily at 15:30 VN time (08:30 UTC) after market close
 */
export const evaluateAccuracyScheduled = onSchedule(
  {
    schedule: "30 8 * * 1-5", // 15:30 VN time (UTC+7), Mon-Fri
    region: "asia-southeast1",
    timeZone: "Asia/Ho_Chi_Minh",
    retryCount: 2,
  },
  async () => {
    const date = todayDateString();
    console.log(`Running accuracy evaluation for ${date}`);
    await evaluateAccuracy(date);
  }
);

/**
 * Manual trigger for accuracy evaluation (for testing)
 */
export const triggerAccuracyEvaluation = onRequest(
  { region: "asia-southeast1", cors: true },
  async (req, res) => {
    const dateParam = req.query.date as string | undefined;
    const date = dateParam && /^\d{4}-\d{2}-\d{2}$/.test(dateParam)
      ? dateParam
      : todayDateString();

    console.log(`Manual accuracy evaluation for ${date}`);
    const count = await evaluateAccuracy(date);

    res.json({ success: true, data: { date, sectorsEvaluated: count } });
  }
);
