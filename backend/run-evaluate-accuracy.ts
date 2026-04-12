import { FieldValue } from "firebase-admin/firestore";
import { db } from "./lib/firebase-admin";
import axios from "axios";
import type { MorningBrief, SectorAnalysis, AccuracyLog } from "./lib/types";
import { VN_SECTORS } from "./lib/types";

function todayVN(): string {
  const vn = new Date(Date.now() + 7 * 60 * 60 * 1000);
  return vn.toISOString().slice(0, 10);
}

const SECTOR_PROXY_SYMBOLS: Record<string, string[]> = {
  banking: ["VCB", "TCB", "MBB", "BID", "CTG"],
  real_estate: ["VHM", "VIC", "NVL", "KDH", "DXG"],
  technology: ["FPT", "CMG", "ELC"],
  energy: ["GAS", "PLX", "PVD", "PVS", "BSR"],
  consumer: ["MWG", "PNJ", "VRE", "MSN", "SAB"],
  steel_materials: ["HPG", "HSG", "NKG", "TLH"],
  agriculture: ["DPM", "DCM", "LTG", "PAN", "HAG"],
};

async function fetchEodChanges(symbols: string[]): Promise<Record<string, number>> {
  const result: Record<string, number> = {};
  try {
    const resp = await axios.get("https://finfo-api.vndirect.com.vn/v4/stock_prices", {
      params: { sort: "date", size: symbols.length, page: 1, q: `code:${symbols.join(",")}~date:${todayVN()}` },
      headers: { "User-Agent": "FTrade/1.0" },
      timeout: 15000,
    });
    for (const item of resp.data?.data ?? []) {
      if (item.code && typeof item.pctChange === "number") result[item.code] = item.pctChange;
    }
  } catch (err) {
    console.warn("fetchEodChanges failed:", err instanceof Error ? err.message : err);
  }
  return result;
}

function evaluatePrediction(impact: SectorAnalysis["impact"], actual: number): boolean | null {
  const t = 0.5;
  if (impact === "neutral") return Math.abs(actual) < t;
  if (Math.abs(actual) < t) return null;
  if (impact === "positive") return actual > 0;
  if (impact === "negative") return actual < 0;
  return null;
}

async function main() {
  const date = todayVN();
  console.log(`Evaluating accuracy for ${date}...`);

  const briefDoc = await db.collection("morning_briefs").doc(date).get();
  if (!briefDoc.exists) { console.log("No brief found, skipping."); process.exit(0); }

  const brief = briefDoc.data() as MorningBrief;
  if (brief.status !== "success" || !brief.sectors?.length) { console.log("Brief not successful, skipping."); process.exit(0); }

  const allSymbols = Object.values(SECTOR_PROXY_SYMBOLS).flat();
  const changes = await fetchEodChanges(allSymbols);
  const sectorNameMap = Object.fromEntries(VN_SECTORS.map((s) => [s.id, s.name]));
  const batch = db.batch();

  for (const sector of brief.sectors) {
    const valid = (SECTOR_PROXY_SYMBOLS[sector.sectorId] ?? []).map((s) => changes[s]).filter((c): c is number => c !== undefined);
    const actualChange = valid.length > 0 ? valid.reduce((a, b) => a + b, 0) / valid.length : null;
    const log: AccuracyLog = {
      briefDate: date, sectorId: sector.sectorId,
      sectorName: sectorNameMap[sector.sectorId] || sector.sectorName,
      predictedImpact: sector.impact, actualChangePercent: actualChange,
      isCorrect: actualChange !== null ? evaluatePrediction(sector.impact, actualChange) : null,
      evaluatedAt: FieldValue.serverTimestamp() as unknown as Date,
    };
    batch.set(db.collection("accuracy_logs").doc(`${date}_${sector.sectorId}`), log, { merge: true });
  }

  await batch.commit();
  console.log(`✅ Accuracy for ${date}: ${brief.sectors.length} sectors logged.`);
  process.exit(0);
}

main().catch((err) => { console.error(err); process.exit(1); });
