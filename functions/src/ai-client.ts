import OpenAI from "openai";
import * as logger from "firebase-functions/logger";
import { FORBIDDEN_PHRASES, MorningBrief, VN_SECTORS } from "./types";

// Works with both local .env and Firebase Secrets (production)
const getApiKey = () => process.env.OPENAI_API_KEY ?? "";
const isDryRun = () => process.env.DRY_RUN === "true";

const MODEL = "gpt-4o-mini";

const FAKE_BRIEF = {
  summary: [
    "VNINDEX tăng nhẹ, dẫn dắt bởi nhóm ngân hàng và BĐS [DRY RUN]",
    "Dòng tiền ngoại mua ròng 120 tỷ đồng — tín hiệu tích cực",
    "Nhóm thép và phân bón chịu áp lực từ giá hàng hóa toàn cầu",
  ],
  sectors: [
    {
      sectorId: "banking", sectorName: "Ngân hàng",
      impact: "positive", impactSummary: "Tích cực — NIM cải thiện",
      analysis: "[DRY RUN] NIM các ngân hàng lớn tiếp tục cải thiện nhờ lãi suất huy động giảm. VCB dẫn dắt nhóm với tăng trưởng tín dụng Q1 đạt 4.2%. BID được nhiều CTCK khuyến nghị tích lũy.",
      stocks: [
        { symbol: "VCB", reason: "Tăng trưởng tín dụng vượt kế hoạch Q1" },
        { symbol: "BID", reason: "Nhiều CTCK nâng khuyến nghị" },
      ],
      disclaimer: "",
    },
    {
      sectorId: "real_estate", sectorName: "Bất động sản",
      impact: "positive", impactSummary: "Phục hồi — lãi suất hạ",
      analysis: "[DRY RUN] Lãi suất cho vay mua nhà giảm về 8.5% kích thích cầu ngắn hạn. VHM công bố mở bán dự án mới Q2. NVL dần ổn định nghĩa vụ trái phiếu đáo hạn.",
      stocks: [
        { symbol: "VHM", reason: "Mở bán dự án mới Q2" },
        { symbol: "NVL", reason: "Ổn định tình hình trái phiếu" },
      ],
      disclaimer: "",
    },
    {
      sectorId: "technology", sectorName: "Công nghệ",
      impact: "neutral", impactSummary: "Trung lập — chờ kết quả Q1",
      analysis: "[DRY RUN] Nhóm công nghệ giao dịch thận trọng trước khi kết quả Q1 được công bố. FPT duy trì tăng trưởng xuất khẩu IT ổn định sang Nhật Bản và Mỹ.",
      stocks: [
        { symbol: "FPT", reason: "Xuất khẩu IT tăng trưởng ổn định" },
      ],
      disclaimer: "",
    },
    {
      sectorId: "energy", sectorName: "Năng lượng & Dầu khí",
      impact: "negative", impactSummary: "Tiêu cực — giá dầu giảm",
      analysis: "[DRY RUN] Giá dầu Brent giảm 2.1% tạo áp lực lên nhóm dầu khí. GAS và PVD chịu ảnh hưởng trực tiếp từ giá dầu thế giới.",
      stocks: [
        { symbol: "GAS", reason: "Nhạy cảm với biến động giá dầu" },
        { symbol: "PVD", reason: "Ảnh hưởng từ giá dầu giảm" },
      ],
      disclaimer: "",
    },
    {
      sectorId: "consumer", sectorName: "Tiêu dùng & Bán lẻ",
      impact: "positive", impactSummary: "Tích cực — sức mua cải thiện",
      analysis: "[DRY RUN] Sức mua tiêu dùng cải thiện trong Q2 nhờ lạm phát hạ nhiệt. MWG phục hồi dần sau giai đoạn tái cơ cấu.",
      stocks: [
        { symbol: "MWG", reason: "Phục hồi sau tái cơ cấu" },
      ],
      disclaimer: "",
    },
  ],
};

function buildSystemPrompt(systemPromptOverride?: string): string {
  if (systemPromptOverride) return systemPromptOverride;
  return `Bạn là chuyên gia phân tích thị trường chứng khoán Việt Nam.
Nhiệm vụ: Tóm tắt tác động của tin tức hôm nay lên các nhóm ngành chứng khoán VN.

QUY TẮC NGÔN NGỮ BẮT BUỘC:
- Viết bằng tiếng Việt, ngắn gọn, dễ hiểu với NĐT cá nhân
- TUYỆT ĐỐI không dùng: "nên mua", "khuyến nghị", "đề xuất mua/bán", "giá mục tiêu"
- Chỉ mô tả tác động có thể xảy ra, không đưa ra lời khuyên đầu tư
- Mỗi phân tích nhóm ngành: 3-5 câu
- Mỗi mã cổ phiếu: 1-2 câu giải thích lý do đáng chú ý

NHÓM NGÀNH CẦN PHÂN TÍCH:
${VN_SECTORS.map((s) => `- ${s.name} (id: ${s.id})`).join("\n")}

ĐỊNH DẠNG OUTPUT (JSON thuần, không markdown):
{
  "summary": ["bullet 1", "bullet 2", "bullet 3"],
  "sectors": [
    {
      "sectorId": "banking",
      "sectorName": "Ngân hàng",
      "impact": "positive|negative|neutral",
      "impactSummary": "1 dòng tóm tắt",
      "analysis": "Phân tích 3-5 câu...",
      "stocks": [
        { "symbol": "VCB", "reason": "Lý do đáng chú ý..." }
      ]
    }
  ]
}`;
}

function containsForbiddenPhrases(text: string): boolean {
  const lower = text.toLowerCase();
  return FORBIDDEN_PHRASES.some((phrase) => lower.includes(phrase));
}

function injectDisclaimers(brief: Omit<MorningBrief, "date" | "createdAt" | "status">): void {
  const disclaimer = "Thông tin mang tính tham khảo, không phải tư vấn đầu tư. NĐT tự chịu trách nhiệm về quyết định của mình.";
  brief.sectors.forEach((sector) => {
    sector.disclaimer = disclaimer;
  });
}

export async function generateBriefWithAI(
  newsContext: string,
  systemPromptOverride?: string,
  retryCount = 0
): Promise<{
  brief: Omit<MorningBrief, "date" | "createdAt" | "status">;
  tokens: { prompt: number; completion: number };
  costUsd: number;
}> {
  if (isDryRun()) {
    logger.info("DRY_RUN mode: returning fake brief, no API call made");
    injectDisclaimers(FAKE_BRIEF as Omit<MorningBrief, "date" | "createdAt" | "status">);
    return {
      brief: FAKE_BRIEF as Omit<MorningBrief, "date" | "createdAt" | "status">,
      tokens: { prompt: 0, completion: 0 },
      costUsd: 0,
    };
  }

  const client = new OpenAI({ apiKey: getApiKey() });
  const systemPrompt = buildSystemPrompt(systemPromptOverride);

  const response = await client.chat.completions.create({
    model: MODEL,
    max_tokens: 4096,
    response_format: { type: "json_object" },
    messages: [
      { role: "system", content: systemPrompt },
      {
        role: "user",
        content: `Tin tức thị trường hôm nay:\n\n${newsContext}\n\nHãy phân tích tác động lên các nhóm ngành chứng khoán VN và trả về JSON theo định dạng yêu cầu.`,
      },
    ],
  });

  const rawText = response.choices[0]?.message?.content ?? "";

  // Validate no forbidden phrases
  if (containsForbiddenPhrases(rawText)) {
    if (retryCount < 3) {
      logger.warn(`Forbidden phrases detected, retry ${retryCount + 1}/3`);
      return generateBriefWithAI(
        newsContext,
        systemPrompt + "\n\nLƯU Ý QUAN TRỌNG: Tuyệt đối không dùng từ khuyến nghị mua/bán.",
        retryCount + 1
      );
    }
    throw new Error("AI output contains forbidden investment advice language after 3 retries");
  }

  const parsed = JSON.parse(rawText);
  injectDisclaimers(parsed);

  // Cost: gpt-4o-mini = $0.15/1M input, $0.60/1M output
  const promptTokens = response.usage?.prompt_tokens ?? 0;
  const completionTokens = response.usage?.completion_tokens ?? 0;
  const costUsd = (promptTokens * 0.15 + completionTokens * 0.60) / 1_000_000;

  return { brief: parsed, tokens: { prompt: promptTokens, completion: completionTokens }, costUsd };
}
