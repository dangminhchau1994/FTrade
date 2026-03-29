---
title: "Product Brief: FTrade"
status: "complete"
created: "2026-03-28"
updated: "2026-03-28"
inputs: [whiteboard brainstorm, competitive research, founder interview, review panel]
---

# Product Brief: FTrade

## Executive Summary

Hơn 10 triệu tài khoản chứng khoán đã được mở tại Việt Nam, trong đó hơn 5 triệu NĐT gia nhập từ năm 2020 -- phần lớn thiếu kiến thức tài chính chuyên sâu. Họ mở SSI iBoard để xem giá, lướt CafeF đọc tin, vào Simplize xem báo cáo tài chính, rồi lên Facebook hỏi "mã này có nên mua không?" -- dùng 3-5 app mà vẫn không biết nên làm gì.

**FTrade** là ứng dụng phân tích chứng khoán tích hợp AI đầu tiên tại Việt Nam, biến dữ liệu thị trường thành insight hành động bằng tiếng Việt. Thay vì hiển thị hàng trăm con số để NĐT tự giải thích, FTrade dùng AI (Claude) để tóm tắt tin tức, phát hiện cơ hội theo nhóm ngành, tự động tạo watchlist, và cảnh báo rủi ro -- tất cả trong một app duy nhất.

Vision: trở thành **"Bloomberg cho nhà đầu tư cá nhân Việt Nam"** -- nơi mọi NĐT, dù mới hay có kinh nghiệm, đều có một trợ lý tài chính AI riêng.

## The Problem

**Nhà đầu tư mới tại Việt Nam đang bị bỏ rơi.**

Một NĐT mới điển hình phải đối mặt với:

- **Quá tải thông tin, thiếu diễn giải**: App hiện tại (SSI, TCBS, VPS) hiển thị P/E, P/B, RSI, MACD... nhưng không giải thích ý nghĩa gì cho cổ phiếu cụ thể đó. "P/E = 15" -- tốt hay xấu? So với ngành thì sao?
- **Tin tức phân mảnh**: Mỗi ngày có hàng chục bài tin trên CafeF, VnExpress, Vietstock. NĐT mới không biết tin nào quan trọng, tin nào ảnh hưởng đến cổ phiếu mình đang giữ.
- **Không ai kết nối sự kiện vĩ mô với hành động**: Xung đột Iran có thể đẩy giá dầu lên -- nhưng NĐT mới không biết nên chú ý mã nào.
- **Thiếu cảnh báo thông minh**: App hiện tại chỉ báo "giá vượt MA50", không báo "cổ phiếu này sắp chốt quyền, cẩn thận mua vào lúc này".

Kết quả: NĐT mới mua bán theo đám đông, theo tin đồn Facebook, và phần lớn thua lỗ trong 1-2 năm đầu.

## The Solution

FTrade là **AI-powered market intelligence app** với trải nghiệm "mở app lên là hiểu ngay":

**1. AI Morning Brief** -- Mở app, AI tóm tắt ngay tin nóng hổi nhất hôm nay, phân tích tác động đến từng nhóm ngành. Ví dụ: *"Xung đột Iran leo thang -> nguồn cung dầu có thể bị hạn chế -> giá dầu tăng -> chú ý nhóm Dầu khí (PVD +3.2%, PVS +2.8%)"*. Morning Brief được tạo shared cho tất cả user (1 lần/ngày, cache 4h) để tối ưu chi phí API.

**2. Smart Watchlist** -- AI tự động tạo watchlist theo nhóm ngành khi phát hiện sự kiện quan trọng, thêm các mã có lịch sử phản ứng mạnh nhất với loại sự kiện đó.

**3. Contextual Alerts** -- Không chỉ báo giá, mà cảnh báo kèm ngữ cảnh: chốt quyền sắp tới, cổ tức, giao dịch nội bộ bất thường, dòng tiền ngoại đổ vào/rút ra.

**4. Plain-language Analysis** -- Mọi chỉ số tài chính, kỹ thuật đều được giải thích bằng tiếng Việt dễ hiểu, phù hợp NĐT mới. Ví dụ: *"P/E của FPT là 15, thấp hơn trung bình ngành CNTT là 20 -- cổ phiếu đang được định giá rẻ hơn so với ngành"*.

**5. Share AI Insight** -- User bấm chia sẻ → app tạo branded card (hình ảnh đẹp) với nội dung phân tích AI + logo FTrade + QR code tải app. Chia sẻ lên Facebook/Zalo group → kênh viral tự nhiên, chi phí gần bằng 0.

## What Makes This Different

| | SSI / TCBS / VPS | Simplize / FireAnt | FTrade |
|---|---|---|---|
| Dữ liệu realtime | Yes | Partial | Yes |
| Phân tích FA/TA | Raw numbers | Visualized | **AI-explained** |
| Tin tức | List headlines | N/A | **AI-summarized + linked to sectors** |
| Watchlist | Manual | Manual | **AI auto-created by events** |
| Alerts | Price-based | Price-based | **Context-aware** |
| Ngôn ngữ | Jargon-heavy | Semi-accessible | **Plain Vietnamese** |
| AI engine | None / Rule-based | None | **Claude API (LLM)** |

**Lợi thế cạnh tranh cốt lõi**: FTrade là app đầu tiên tại Việt Nam sử dụng LLM để phân tích chứng khoán bằng tiếng Việt. Không có đối thủ nào hiện tại có khả năng kết nối tin tức vĩ mô -> phân tích tác động ngành -> gợi ý mã đáng chú ý trong một flow tự động.

**Timing**: Thị trường Việt Nam sắp được nâng hạng lên Emerging Market (FTSE), hệ thống KRX triển khai -- sẽ thu hút thêm hàng triệu NĐT mới, đúng đối tượng FTrade hướng đến.

## Who This Serves

**Primary: NĐT cá nhân mới (1-3 năm kinh nghiệm)**

- 25-40 tuổi, có thu nhập trung bình-khá, đã mở tài khoản chứng khoán
- Biết cơ bản về cổ phiếu nhưng chưa biết cách phân tích
- Đang dùng 3-5 app khác nhau và vẫn cảm thấy thiếu tự tin khi ra quyết định
- Muốn đầu tư thông minh hơn nhưng không có thời gian nghiên cứu sâu

**"Aha moment"**: Mở app buổi sáng, thấy AI tóm tắt rằng xung đột Iran đang leo thang, giá dầu có thể tăng, và đã tự động tạo watchlist "Dầu khí" với các mã PVD, PVS, BSR kèm phân tích ngắn. NĐT nghĩ: *"Đây đúng là cái mình cần -- app nghĩ hộ mình."*

## Business Model & Unit Economics

**Business model**: Subscription freemium -- tất cả tính năng AI đều có ở Free tier nhưng bị giới hạn. Chiến lược "try before buy": user trải nghiệm AI trước, thấy giá trị rồi mới trả tiền.

| Tính năng | Free | Premium (~99-199K VND/tháng) |
|---|---|---|
| AI Morning Brief | 1 nhóm ngành/ngày | Tất cả ngành |
| Smart Watchlist | 1 watchlist, tối đa 5 mã | Không giới hạn |
| Contextual Alerts | 3 alerts | Không giới hạn |
| Plain-language Analysis | 3 mã/ngày | Không giới hạn |
| Share AI Insight | Có (watermark "FTrade Free") | Branded card đẹp |
| Personalized Analysis | Không | Phân tích theo portfolio cá nhân |
| Dữ liệu thị trường | Realtime | Realtime + priority access |

**Chi phí AI (Claude API):**
- Morning Brief tạo shared 1 lần/ngày cho tất cả user → ~$0.05/brief/ngày
- Free tier: limited requests → chi phí thấp, chấp nhận được cho acquisition
- Premium: ~$1-3/paid user/tháng (personalized analysis, unlimited requests)
- Break-even: cần conversion rate ~5-10% từ free sang paid

**Go-to-Market:**
- **Viral loop**: Share AI Insight cards lên Facebook/Zalo groups chứng khoán (F319, các group NĐT)
- **Content marketing**: AI-generated daily market summaries đăng lên social media
- **Referral**: Mời bạn → cả 2 được nâng limit Premium 7 ngày

## Success Criteria

| Metric | Target (6 tháng đầu) | Target (12 tháng) |
|---|---|---|
| Downloads | 10,000 | 50,000 |
| DAU (Daily Active Users) | 2,000 | 10,000 |
| Paid subscribers | 200 | 2,000 |
| Retention D7 | > 30% | > 40% |
| Free → Paid conversion | > 5% | > 8% |

## Scope

### MVP (Phase 1 Public Launch)
- AI Morning Brief (tóm tắt tin tức + phân tích tác động ngành)
- Smart Watchlist (AI tự động tạo & quản lý theo sự kiện)
- Contextual Alerts (cảnh báo kèm ngữ cảnh)
- Plain-language Analysis (giải thích chỉ số bằng tiếng Việt)
- Share AI Insight (branded card cho viral)
- Dữ liệu thị trường realtime (đã có)
- Tin tức aggregation (đã có)

### NOT in MVP
- Phân tích FA/TA chi tiết với AI (Phase 2)
- AI chatbot hỏi đáp tự do (Phase 3)
- Screener cổ phiếu bằng ngôn ngữ tự nhiên (Phase 3)
- B2B2C / White-label API cho CTCK (Phase 3)
- Kết nối giao dịch với sàn (out of scope -- FTrade là app phân tích, không phải app giao dịch)

## Risks & Mitigations

| Rủi ro | Mức độ | Giải pháp |
|---|---|---|
| **Pháp lý**: AI gợi ý mã có thể bị coi là tư vấn đầu tư trái phép | Cao | Định vị là "cung cấp thông tin & phân tích", thêm disclaimer rõ ràng, tránh ngôn ngữ khuyến nghị mua/bán. Tham vấn luật sư trước launch. |
| **Nguồn dữ liệu**: Đang dùng unofficial API (SSI, Vietstock), có thể bị block | Cao | Chấp nhận cho MVP. Khi có revenue, mua data feed chính thức (FiinGroup, StoxPlus). Xây backup datasource. |
| **Chất lượng AI**: Claude chưa được tối ưu cho thị trường VN | Trung bình | Pilot test 50-100 user trước public launch. Xây feedback loop. Dùng system prompt với context VN market. |
| **Chi phí API scale**: API cost tăng theo user | Trung bình | Shared Morning Brief, aggressive caching (4h), rate limiting cho free tier. |

## Vision

**Năm 1**: App phân tích chứng khoán AI #1 Việt Nam cho NĐT mới -- "mở app lên là hiểu ngay thị trường hôm nay".

**Năm 2**: Mở rộng sang NĐT trung cấp với AI chatbot, stock screener, portfolio analysis. Bắt đầu B2B2C: bán white-label AI analysis cho CTCK nhỏ/trung (MBS, KIS, KBSV) -- họ có user base lớn nhưng không có AI.

**Năm 3**: **Bloomberg cho NĐT cá nhân Việt Nam** -- nền tảng intelligence hoàn chỉnh với AI advisor cá nhân hóa, coverage mở rộng sang trái phiếu, phái sinh, quỹ mở.

---

*Lưu ý: FTrade cung cấp thông tin và phân tích tham khảo, không phải tư vấn đầu tư. Mọi quyết định đầu tư là trách nhiệm của người dùng.*
