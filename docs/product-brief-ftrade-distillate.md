---
title: "Product Brief Distillate: FTrade"
type: llm-distillate
source: "product-brief-ftrade.md"
created: "2026-03-28"
purpose: "Token-efficient context for downstream PRD creation"
---

# FTrade Detail Pack

## Rejected Ideas
- **Auto-trading / kết nối sàn**: Bỏ hoàn toàn. FTrade là app phân tích, không phải app giao dịch. Founder đã quyết định rõ.
- **Emerging Market Tracker dashboard**: Founder cho rằng không cần thiết, bỏ khỏi scope.
- **AI features chỉ cho Premium**: Bỏ. Tất cả AI features phải có ở Free tier (giới hạn usage), chiến lược "try before buy".

## Requirements Hints
- **AI Morning Brief phải là shared** (tạo 1 lần/ngày cho tất cả user, cache 4h) để kiểm soát API cost. Không tạo riêng từng user.
- **Smart Watchlist logic**: Khi phát hiện sự kiện vĩ mô quan trọng → xác định nhóm ngành bị ảnh hưởng → tạo watchlist tên nhóm ngành → thêm các mã có lịch sử phản ứng mạnh nhất. Ví dụ cụ thể founder đưa ra: xung đột Iran → dầu tăng → watchlist "Dầu khí" → PVD, PVS, BSR.
- **Plain-language explanation**: Mọi chỉ số (P/E, RSI, MACD, Piotroski, Altman Z...) phải kèm giải thích context-aware bằng tiếng Việt. Ví dụ: "P/E = 15, thấp hơn ngành CNTT (20) → định giá rẻ hơn ngành".
- **Share AI Insight**: Tạo branded image card (không phải text link). Free có watermark, Premium card đẹp hơn.
- **Referral**: Mời bạn → cả 2 được nâng limit Premium 7 ngày.

## Technical Context
- **Platform**: Flutter mobile app (iOS + Android)
- **AI backend**: Claude API (Anthropic) -- không phải GPT/OpenAI
- **Architecture**: Clean Architecture + Riverpod + Freezed + fpdart Either
- **Realtime**: SSI MQTT (wss://price-streaming.ssi.com.vn/mqtt) với 72-field protobuf schema
- **REST APIs**: VNDirect (stocks, ratios, financials), Vietstock (news, corporate events, money flow)
- **Storage**: Hive (local NoSQL), 6h cache cho FA analysis
- **Đã build xong (Phase 1-2)**: Market data realtime, news feed, corporate events, dividends, insider trading, foreign flow, volume anomaly, TA charts (MACD/RSI/MA), FA engine (Piotroski/Altman Z/DuPont/DCF/EV-EBITDA/FCF), watchlist, price alerts, dark/light theme
- **Chưa có**: Claude API integration (chưa có dòng code nào gọi Claude), AI Morning Brief, Smart Watchlist AI, Plain-language Analysis
- **Phase 3 cần pivot**: Đang đi hướng FA dashboard (tính toán thuần túy) → cần ưu tiên AI Morning Brief trước

## Detailed User Scenarios
- **Morning routine**: NĐT mở app 7h30 sáng → thấy AI Morning Brief tóm tắt 3-5 tin quan trọng nhất → mỗi tin kèm phân tích tác động ngành → bấm vào nhóm ngành → thấy Smart Watchlist đã được tạo sẵn với các mã liên quan
- **Discovery**: NĐT xem 1 mã cổ phiếu → thấy P/E, RSI, MACD... nhưng kèm giải thích tiếng Việt → hiểu ngay cổ phiếu này đang đắt/rẻ, overbought/oversold
- **Viral sharing**: NĐT thấy insight hay → bấm Share → tạo hình card đẹp → đăng lên group Facebook F319 → bạn bè thấy → tải app qua QR code
- **Alert flow**: App cảnh báo "VNM sắp chốt quyền cổ tức ngày 15/4, tỷ lệ 15%" → NĐT biết nên giữ hay bán trước

## Competitive Intelligence
- **Không ai dùng LLM tại VN**: SSI (rule-based alerts), TCBS ("Robot Investing" = robo-advisor questionnaire), VPS (chatbot hỗ trợ), Simplize (rules-based scoring), FireAnt (basic stats)
- **Khoảng trống lớn nhất**: Không ai tóm tắt tin tức AI bằng tiếng Việt, không ai giải thích chỉ số tài chính context-aware, không ai kết nối sự kiện vĩ mô → ngành → mã
- **Thị trường**: ~10-12 triệu tài khoản (2026), 5M+ NĐT mới từ 2020, penetration ~9-10% (còn nhiều room tăng trưởng)
- **NĐT phải dùng 3-5 app**: iBoard (giá), Simplize (FA), CafeF (tin), FireAnt (chart), Facebook (hỏi ý kiến)

## Free vs Premium Tier Limits
| Feature | Free | Premium |
|---|---|---|
| AI Morning Brief | 1 nhóm ngành/ngày | Tất cả ngành |
| Smart Watchlist | 1 watchlist, 5 mã | Không giới hạn |
| Contextual Alerts | 3 alerts | Không giới hạn |
| Plain-language Analysis | 3 mã/ngày | Không giới hạn |
| Share AI Insight | Watermark "FTrade Free" | Branded card đẹp |
| Personalized Analysis | Không | Có |

## Open Questions
- **Pháp lý**: Cần tham vấn luật sư về ranh giới "cung cấp thông tin" vs "tư vấn đầu tư". Chưa có kết luận.
- **Data chính thức**: Khi nào chuyển từ unofficial API sang mua data feed? Ngân sách bao nhiêu?
- **Pricing chính xác**: 99K hay 199K VND/tháng? Có gói năm không? Cần A/B test.
- **AI quality benchmark**: Cần pilot test để đo chất lượng Claude phân tích thị trường VN. Chưa có data.
- **B2B2C timeline**: Khi nào bắt đầu tiếp cận CTCK? Cần MVP ổn định trước?
