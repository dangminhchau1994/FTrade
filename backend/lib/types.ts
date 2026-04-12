import type { Timestamp } from "firebase-admin/firestore";

export interface StockMention {
  symbol: string;
  reason: string;
}

export interface SectorAnalysis {
  sectorId: string;
  sectorName: string;
  impact: "positive" | "negative" | "neutral";
  impactSummary: string;
  analysis: string;
  stocks: StockMention[];
  disclaimer: string;
}

export interface MorningBrief {
  date: string; // yyyy-MM-dd
  summary: string[];
  sectors: SectorAnalysis[];
  createdAt: Timestamp | Date;
  status: "success" | "failed";
  isFallback?: boolean;
  fallbackReason?: string;
  costUsd?: number;
  promptTokens?: number;
  completionTokens?: number;
}

export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: { code: string; message: string };
}

export const VN_SECTORS = [
  { id: "banking", name: "Ngân hàng" },
  { id: "real_estate", name: "Bất động sản" },
  { id: "technology", name: "Công nghệ" },
  { id: "energy", name: "Năng lượng & Dầu khí" },
  { id: "consumer", name: "Tiêu dùng & Bán lẻ" },
  { id: "steel_materials", name: "Thép & Vật liệu" },
  { id: "agriculture", name: "Nông nghiệp & Thực phẩm" },
];

export const FORBIDDEN_PHRASES = [
  "nên mua",
  "khuyến nghị mua",
  "khuyến nghị bán",
  "đề xuất mua",
  "đề xuất bán",
  "mua vào",
  "bán ra",
  "giá mục tiêu",
  "target price",
  "buy recommendation",
  "sell recommendation",
];

// ── Epic 3: Feedback & Accuracy ──

export interface FeedbackEntry {
  briefDate: string;
  sectorId: string;
  isAccurate: boolean;
  uid: string;
  createdAt: Timestamp | Date;
}

export interface AccuracyLog {
  briefDate: string;
  sectorId: string;
  sectorName: string;
  predictedImpact: "positive" | "negative" | "neutral";
  actualChangePercent: number | null;
  isCorrect: boolean | null;
  evaluatedAt: Timestamp | Date;
}

export interface AccuracySummary {
  totalPredictions: number;
  correctPredictions: number;
  accuracyRate: number;
  bySector: Record<string, { total: number; correct: number; rate: number }>;
  weeklyTrend: Array<{ week: string; rate: number; total: number }>;
}
