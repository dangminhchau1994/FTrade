---
stepsCompleted: ['step-01-init', 'step-02-discovery', 'step-02b-vision', 'step-02c-executive-summary', 'step-03-success', 'step-04-journeys', 'step-05-domain', 'step-06-innovation', 'step-07-project-type', 'step-08-scoping', 'step-09-functional', 'step-10-nonfunctional', 'step-11-polish']
inputDocuments: ['docs/product-brief-ftrade.md', 'docs/product-brief-ftrade-distillate.md']
workflowType: 'prd'
documentCounts:
  briefs: 1
  research: 1
  brainstorming: 0
  projectDocs: 0
classification:
  projectType: mobile_app
  domain: fintech
  complexity: high
  projectContext: brownfield
---

# Product Requirements Document - FTrade

**Author:** Chau
**Date:** 2026-03-29

## Executive Summary

FTrade là ứng dụng mobile (Flutter, iOS + Android) phân tích chứng khoán Việt Nam tích hợp AI, nhắm đến nhà đầu tư cá nhân mới (1-3 năm kinh nghiệm). Ứng dụng giải quyết vấn đề cốt lõi: NĐT retail tại Việt Nam bị quá tải dữ liệu nhưng thiếu diễn giải — phải dùng 3-5 app (SSI iBoard, Simplize, CafeF, FireAnt, Facebook) mà vẫn không tự tin ra quyết định.

FTrade dùng Claude API (Anthropic) để biến dữ liệu thị trường thành insight hành động bằng tiếng Việt dễ hiểu. Vision dài hạn: **"Bloomberg cho nhà đầu tư cá nhân Việt Nam"**. Thị trường mục tiêu: 10+ triệu tài khoản chứng khoán, 5+ triệu NĐT mới từ 2020. Business model: freemium subscription (~99-199K VND/tháng), chiến lược "try before buy" — tất cả AI features có ở Free tier nhưng giới hạn usage.

Brownfield project: Phase 1-2 hoàn tất (market data realtime qua MQTT, news feed, TA/FA engine, watchlist, price alerts). PRD này focus vào **Phase 3: tích hợp AI**.

### What Makes This Special

Không app nào tại VN sử dụng LLM để phân tích chứng khoán bằng tiếng Việt. Đối thủ (SSI, TCBS, VPS, Simplize, FireAnt) mạnh về hiển thị dữ liệu nhưng yếu về diễn giải. FTrade là app đầu tiên thực hiện flow tự động: phát hiện sự kiện vĩ mô → phân tích tác động ngành → gợi ý mã đáng chú ý → tự động tạo watchlist — tất cả do AI xử lý.

Core insight: vấn đề không phải thiếu dữ liệu mà thiếu context. **"Mọi app cho xem giá. FTrade cho biết nó có ý nghĩa gì."**

## Project Classification

| | |
|---|---|
| **Project Type** | Mobile App (Flutter cross-platform iOS + Android) |
| **Domain** | Fintech (Stock analysis & AI intelligence) |
| **Complexity** | High (regulated domain, realtime data, AI integration, legal risks) |
| **Project Context** | Brownfield (Phase 1-2 complete, PRD covers Phase 3 AI integration) |

## Success Criteria

### User Success

- NĐT mở app buổi sáng → đọc Morning Brief → **hiểu thị trường hôm nay trong vòng 2 phút**
- AI dự báo nhóm ngành đáng chú ý → nhóm đó **thực sự biến động đúng hướng** → NĐT tin tưởng app
- NĐT không còn phải mở 3-5 app khác để nắm tình hình thị trường
- Free user cảm thấy giá trị đủ lớn để upgrade Premium khi bị limit

### Business Success

| Metric | 6 tháng | 12 tháng |
|---|---|---|
| Downloads | 10,000 | 50,000 |
| DAU | 2,000 | 10,000 |
| Paid subscribers | 200 | 2,000 |
| Retention D7 | > 30% | > 40% |
| Free → Paid conversion | > 5% | > 8% |

### Technical Success

- **Tốc độ**: Morning Brief tạo xong **trước 8h sáng** mỗi ngày (trước giờ mở sàn 9h)
- **Độ chính xác**: AI phân tích tác động ngành đúng hướng **≥ 60%** trong 30 ngày đầu, cải thiện qua feedback loop
- **Uptime**: API Claude + app backend available **≥ 99%** trong giờ giao dịch (9h-15h)
- **Cost**: Chi phí AI ≤ $3/paid user/tháng, free tier ≤ $0.5/user/tháng

### Measurable Outcomes

- **Morning Brief engagement**: ≥ 70% DAU đọc Morning Brief mỗi ngày
- **Watchlist adoption**: ≥ 40% user có ít nhất 1 AI-created watchlist
- **Share rate**: ≥ 10% user share AI Insight ít nhất 1 lần/tuần
- **Accuracy tracking**: Log mọi dự báo ngành → so sánh với biến động thực tế → báo cáo weekly

## Project Scoping & Phased Development

### MVP Strategy

**MVP Approach:** Problem-solving MVP — chứng minh AI có thể tóm tắt tin tức + phân tích tác động ngành chính xác và hữu ích. 1 feature làm tốt, không nhiều features làm nửa vời.

**Resource Requirements:** 1 solo developer (founder) + Claude API + backend proxy nhẹ (Firebase Functions hoặc Supabase Edge Functions).

### MVP Feature Set (Phase 1 — AI Morning Brief)

**Core User Journey Supported:** Journey 1 (Minh — đọc Morning Brief buổi sáng)

| # | Capability | Mô tả |
|---|---|---|
| 1 | Backend cron job | Chạy 7h sáng: collect news → gọi Claude API → tạo brief → cache |
| 2 | Claude API proxy | Backend service proxy Claude calls, không gọi từ app |
| 3 | Morning Brief screen | Hiển thị brief: tin tóm tắt + nhóm ngành + mã đáng chú ý |
| 4 | Sector grouping | Phân nhóm ngành (Dầu khí, Ngân hàng, BĐS, CNTT...) với mã thuộc nhóm |
| 5 | Free/Premium gating | Free: 1 nhóm ngành/ngày. Premium: tất cả |
| 6 | Push notification | FCM: "Morning Brief hôm nay đã sẵn sàng" |
| 7 | Disclaimer | Hiển thị dưới mỗi phân tích: "Thông tin tham khảo, không phải tư vấn đầu tư" |
| 8 | Offline cache | Cache brief cuối cùng, hiển thị khi offline kèm timestamp |
| 9 | Feedback button | "Chính xác / Không chính xác" cho mỗi dự báo ngành |

**Đã có sẵn (Phase 1-2):** Market data realtime (MQTT), news feed (Vietstock RSS), watchlist + price alerts, TA/FA engine, dark/light theme

### Phase 2 — Growth

| # | Feature | Phụ thuộc |
|---|---|---|
| 1 | Smart Watchlist | Morning Brief (cần sector analysis) |
| 2 | Contextual Alerts | Corporate events data (đã có) |
| 3 | Plain-language Analysis | FA engine (đã có) + Claude API (MVP) |
| 4 | Share AI Insight | Morning Brief (MVP) |
| 5 | Subscription IAP | Free/Premium gating (MVP) |
| 6 | Referral system | User accounts |

### Phase 3 — Expansion

| # | Feature | Phụ thuộc |
|---|---|---|
| 1 | AI chatbot hỏi đáp tự do | Claude API + toàn bộ data layer |
| 2 | Stock screener ngôn ngữ tự nhiên | Claude API + FA/TA data |
| 3 | Personalized portfolio analysis | User accounts + Premium |
| 4 | B2B2C API cho CTCK | Stable AI engine + API layer |

## User Journeys

### Journey 1: Minh — NĐT mới đọc Morning Brief (Happy Path)

**Minh, 28 tuổi, nhân viên văn phòng, đầu tư 8 tháng.** Mỗi sáng mở CafeF đọc tin, vào SSI iBoard xem giá, lướt Facebook group hỏi "hôm nay nên chú ý gì" — mất 30 phút mà vẫn không biết nên làm gì.

**Opening Scene:** 7h45 sáng, Minh mở FTrade. App hiển thị Morning Brief: *"Iran tuyên bố phong tỏa eo biển Hormuz. Giá dầu thế giới tăng 4.2% qua đêm. Nhóm Dầu khí VN có thể hưởng lợi: PVD (+3.2% phiên trước khi có tin tương tự), PVS, BSR."*

**Rising Action:** Minh bấm vào nhóm "Dầu khí" → thấy danh sách mã kèm giải thích ngắn. Muốn xem thêm nhóm Ngân hàng nhưng đang dùng Free → app hiển thị "Nâng cấp Premium để xem tất cả nhóm ngành".

**Climax:** 10h sáng, Minh check lại → PVD thực sự tăng 2.8%, PVS tăng 1.5%. Morning Brief đã đúng. *"App này nghĩ hộ mình thật."*

**Resolution:** Sau 1 tuần dùng Free, bị limit 1 nhóm ngành/ngày không đủ → upgrade Premium 99K/tháng. Không còn mở CafeF hay hỏi Facebook nữa.

### Journey 2: Lan — NĐT mới gặp Morning Brief sai (Edge Case)

**Lan, 35 tuổi, kế toán, đầu tư 1 năm.** Cẩn thận, hay kiểm chứng thông tin.

**Opening Scene:** Lan đọc Morning Brief: *"FED có thể tăng lãi suất → nhóm BĐS chịu áp lực giảm"*.

**Rising Action:** Cuối phiên, nhóm BĐS lại tăng 1.5% do tin quy hoạch mới. AI dự báo sai hướng.

**Climax:** Lan bấm nút "Phản hồi" → "Không chính xác" kèm ghi chú. App hiển thị disclaimer: *"FTrade cung cấp phân tích tham khảo, không phải tư vấn đầu tư."*

**Resolution:** Lan vẫn tiếp tục dùng vì AI đúng ~60-70% là tốt hơn tự đọc tin. Feedback giúp cải thiện model. Lan đánh giá cao sự minh bạch.

### Journey 3: Chau (Founder/Admin) — Giám sát AI quality & chi phí

**Chau, founder FTrade, monitor hệ thống hàng ngày.**

**Opening Scene:** 7h sáng, Morning Brief cron job chạy. Notification: "Brief đã tạo xong, cost: $0.04, 5 nhóm ngành".

**Rising Action:** Admin dashboard → accuracy log tuần qua: 65% đúng hướng. API cost tháng: $120 cho 2,000 DAU. Conversion rate: 6%.

**Climax:** Accuracy nhóm BĐS chỉ 40% → adjust system prompt thêm context chính sách quy hoạch VN.

**Resolution:** Tuần sau accuracy BĐS cải thiện lên 55%. Tiếp tục iterate.

### Journey Requirements Summary

| Journey | Capabilities cần có |
|---|---|
| **Minh (happy path)** | Morning Brief screen, sector grouping, stock list per sector, free/premium gating, upgrade flow |
| **Lan (edge case)** | Feedback mechanism, disclaimer UI, accuracy transparency, error handling |
| **Chau (admin)** | Admin dashboard, accuracy tracking, cost monitoring, system prompt management, cron job monitoring |

## Domain-Specific Requirements

### Compliance & Regulatory

- **Luật Chứng khoán 2019 + Nghị định 158/2020/NĐ-CP**: FTrade KHÔNG phải app tư vấn đầu tư. Mọi output AI kèm disclaimer: *"Thông tin tham khảo, không phải khuyến nghị mua/bán"*
- **Ngôn ngữ AI**: Tránh "nên mua", "khuyến nghị", "đề xuất mua/bán". Thay bằng "đáng chú ý", "có thể bị ảnh hưởng", "NĐT nên tự đánh giá"
- **Tham vấn luật sư** trước public launch để xác nhận ranh giới "cung cấp thông tin" vs "tư vấn đầu tư"
- **Điều khoản sử dụng**: User đồng ý ToS trước khi dùng AI features, nêu rõ giới hạn trách nhiệm

### Technical Constraints

- **Data accuracy**: Đang dùng unofficial API (SSI MQTT, Vietstock scraping) — không có SLA:
  - Hiển thị timestamp dữ liệu (khi nào cập nhật lần cuối)
  - Cảnh báo khi dữ liệu delay > 5 phút
  - Backup datasource plan khi source chính bị block
- **AI safety**: Claude API response validate trước khi hiển thị:
  - Không chứa khuyến nghị mua/bán trực tiếp
  - Không mention giá mục tiêu cụ thể
  - Luôn kèm disclaimer
- **Data privacy**: Không thu thập portfolio thật ở MVP. Free tier không cần đăng ký tài khoản
- **API key security**: Claude API key qua backend proxy, không embed trong app

### Integration Requirements

- **Claude API (Anthropic)**: Backend service gọi Claude → trả kết quả cho app. Không gọi trực tiếp từ mobile
- **News sources**: Vietstock RSS (hiện tại). Thêm sources post-MVP
- **Market data**: SSI MQTT (realtime), VNDirect REST (historical). Khi có revenue → mua FiinGroup/StoxPlus data feed
- **Payment**: In-app purchase (App Store / Google Play) cho subscription

## Innovation & Novel Patterns

### Detected Innovation Areas

1. **LLM-powered stock analysis bằng tiếng Việt (First-in-market)**: Không đối thủ nào tại VN dùng LLM cho phân tích chứng khoán. SSI, TCBS, Simplize đều rule-based hoặc thuần data display.

2. **Event-driven auto-watchlist**: Flow tự động end-to-end: sự kiện vĩ mô → phân tích tác động ngành → tạo watchlist → thêm mã phản ứng mạnh nhất. Chưa app nào (kể cả global retail) làm được bằng AI.

3. **"Try before buy" AI**: Freemium AI features — user trải nghiệm trước khi trả tiền, khác hầu hết AI products đặt paywall trước.

### Market Context

- **Global**: Bloomberg GPT, Finchat.io nhắm B2B/professional, giá hàng trăm USD/tháng, tiếng Anh only
- **VN**: Hoàn toàn trống. Vietnamese NLP cho tài chính chưa được khai thác
- **Timing**: Claude hỗ trợ tiếng Việt tốt. Thị trường VN sắp nâng hạng → wave NĐT mới → demand tăng

### Validation Approach

- Pilot test 50-100 user thật trước public launch (2-4 tuần)
- Accuracy tracking: log mọi dự báo → so sánh biến động thực tế → báo cáo weekly
- User feedback loop: nút "Chính xác / Không chính xác" dưới mỗi phân tích

## Mobile App Specific Requirements

### Platform Requirements

| | iOS | Android |
|---|---|---|
| **Min version** | iOS 14+ | Android 8.0 (API 26)+ |
| **Framework** | Flutter (Dart) | Flutter (Dart) |
| **Distribution** | App Store | Google Play |
| **In-app purchase** | StoreKit 2 | Google Play Billing |

### Offline Mode

- **Morning Brief**: Cache brief cuối cùng → hiển thị khi offline kèm label *"Cập nhật lúc [timestamp]"*
- **Watchlist**: Hiển thị danh sách mã đã lưu (Hive local), giá cuối cùng được cache
- **News**: Hiển thị tin đã cache, không load thêm
- **Market data**: Hiển thị giá cuối cùng, badge "Offline"
- **AI features**: Không khả dụng offline → thông báo "Cần kết nối internet để sử dụng AI"

### Push Notification Strategy

| Notification | Trigger | Thời gian |
|---|---|---|
| Morning Brief ready | Cron job tạo brief xong | ~7h30 sáng |
| Contextual Alert | Chốt quyền, cổ tức, GD nội bộ bất thường | Realtime |
| Price Alert | Giá vượt ngưỡng user đặt | Realtime (đã có) |
| Premium upsell | Free user đạt limit | Khi bị limit |

Firebase Cloud Messaging (FCM) cho cả iOS + Android. User bật/tắt từng loại trong Settings.

### Device Permissions

| Permission | Mục đích | Bắt buộc? |
|---|---|---|
| Internet | Core functionality | Có |
| Push Notifications | Morning Brief, alerts | Không (hỏi khi onboard) |
| Background refresh | MQTT connection, price monitoring | Có |
| Biometrics | Bảo vệ app (post-MVP) | Không |

### Store Compliance

- **App Store / Google Play**: Không claim "tư vấn đầu tư". Category: Finance → Stock Market. Disclaimer trong app description. Privacy Policy page bắt buộc.
- **In-app purchase**: Subscription qua IAP (Apple/Google lấy 15-30% commission) → factor vào pricing
- **Content**: AI output comply content policy (không misleading financial advice)
- **Data sources**: Không mention unofficial API trong store listing

### Implementation Considerations

- **State management**: Riverpod (đã dùng Phase 1-2)
- **Backend proxy**: Firebase Functions hoặc Supabase Edge Functions để proxy Claude API
- **Caching**: Hive (local), HTTP cache cho Morning Brief (4h TTL)
- **Deep linking**: Share links cho viral (Share AI Insight → link mở app/store)
- **App size**: Target < 50MB
- **Crash monitoring**: Firebase Crashlytics

## Functional Requirements

### AI Morning Brief

- **FR1**: User can xem AI Morning Brief tóm tắt 3-5 tin quan trọng nhất hôm nay
- **FR2**: User can xem phân tích tác động của từng tin đến nhóm ngành cụ thể
- **FR3**: User can xem danh sách mã đáng chú ý trong mỗi nhóm ngành được phân tích
- **FR4**: System tự động tạo Morning Brief mỗi ngày trước 8h sáng
- **FR5**: System cache Morning Brief và hiển thị brief cuối cùng khi user offline
- **FR6**: User can xem timestamp cập nhật của Morning Brief

### Feedback & Accuracy

- **FR7**: User can đánh giá mỗi dự báo ngành là "Chính xác" hoặc "Không chính xác"
- **FR8**: Admin can xem accuracy rate tổng hợp theo tuần và theo nhóm ngành
- **FR9**: System log mọi dự báo ngành và so sánh với biến động thực tế

### Free/Premium Gating

- **FR10**: Free user can xem 1 nhóm ngành/ngày trong Morning Brief
- **FR11**: Premium user can xem tất cả nhóm ngành trong Morning Brief
- **FR12**: User can nâng cấp từ Free lên Premium qua in-app purchase
- **FR13**: System hiển thị upgrade prompt khi Free user đạt giới hạn

### Notifications

- **FR14**: User nhận push notification khi Morning Brief đã sẵn sàng
- **FR15**: User can bật/tắt từng loại notification trong Settings
- **FR16**: User nhận push notification khi price alert triggered (đã có Phase 2)

### Compliance & Disclaimer

- **FR17**: System hiển thị disclaimer dưới mỗi phân tích AI
- **FR18**: AI output không chứa ngôn ngữ khuyến nghị mua/bán trực tiếp
- **FR19**: User phải đồng ý Terms of Service trước khi sử dụng AI features lần đầu
- **FR20**: System validate AI response trước khi hiển thị (filter ngôn ngữ tư vấn)

### Admin & Monitoring

- **FR21**: Admin can xem API cost tổng hợp theo ngày/tháng
- **FR22**: Admin can xem accuracy tracking theo nhóm ngành
- **FR23**: Admin can chỉnh sửa system prompt cho Claude API
- **FR24**: Admin nhận notification khi cron job hoàn thành hoặc thất bại
- **FR25**: Admin can xem conversion rate free→paid

### Data & Connectivity

- **FR26**: System hiển thị trạng thái kết nối (online/offline)
- **FR27**: System cảnh báo khi dữ liệu delay > 5 phút
- **FR28**: System cache market data, news, và Morning Brief cho offline access

### Existing Capabilities (Phase 1-2)

- **FR29**: User can xem giá cổ phiếu realtime
- **FR30**: User can xem tin tức thị trường
- **FR31**: User can tạo và quản lý watchlist
- **FR32**: User can đặt price alerts
- **FR33**: User can xem biểu đồ TA (MACD, RSI, MA)
- **FR34**: User can xem phân tích FA (Piotroski, Altman Z, DuPont)
- **FR35**: User can chuyển đổi dark/light theme

## Non-Functional Requirements

### Performance

- **NFR1**: Morning Brief cron job hoàn thành trong **30 phút** (7h → 7h30)
- **NFR2**: Morning Brief screen load trong **< 2 giây** (warm cache)
- **NFR3**: Market data realtime (MQTT) delay **< 3 giây** so với source
- **NFR4**: Push notification gửi trong **< 1 phút** sau khi brief sẵn sàng
- **NFR5**: App cold start **< 4 giây** trên thiết bị mid-range

### Security

- **NFR6**: Claude API key lưu trên backend, **không** embed trong app binary
- **NFR7**: App ↔ backend communication qua **HTTPS/TLS 1.2+**
- **NFR8**: Payment qua Apple/Google IAP — app **không lưu** thông tin thanh toán
- **NFR9**: Admin dashboard yêu cầu **authentication**
- **NFR10**: API rate limiting: **100 requests/phút/user**

### Scalability

- **NFR11**: Backend hỗ trợ **10,000 concurrent users** đọc Morning Brief
- **NFR12**: Morning Brief là **shared content** (tạo 1 lần, serve tất cả) — không scale linearly theo user
- **NFR13**: Cache layer (CDN/edge cache) cho Morning Brief — backend chỉ bị hit khi cache miss
- **NFR14**: Database feedback/accuracy hỗ trợ **1M+ records**

### Reliability

- **NFR15**: Available **≥ 99%** trong giờ giao dịch (9h-15h, T2-T6)
- **NFR16**: Morning Brief cron có **retry** — Claude API fail → retry 3 lần, exponential backoff
- **NFR17**: Morning Brief thất bại → hiển thị **brief ngày trước** kèm thông báo
- **NFR18**: MQTT **auto-reconnect** với exponential backoff (đã có Phase 2)
- **NFR19**: Crash rate **< 1%** sessions (Firebase Crashlytics)

## Risk Matrix

| Rủi ro | Xác suất | Tác động | Giải pháp |
|---|---|---|---|
| AI gợi ý sai → user mất tiền → kiện | Trung bình | Cao | Disclaimer bắt buộc, ToS, ngôn ngữ trung lập, tham vấn luật sư |
| SSI/Vietstock block API | Cao | Cao | Cache aggressive, backup sources, kế hoạch mua data chính thức |
| Claude API outage giờ cao điểm | Thấp | Cao | Cache Morning Brief, fallback brief cũ + thông báo |
| Apple/Google reject app | Thấp | Rất cao | Không mention unofficial data trong listing, chuẩn bị data feed chính thức |
| Chi phí API vượt revenue | Trung bình | Cao | Shared brief, aggressive caching, rate limiting, monitor cost daily |
| Claude thiếu local context VN | Trung bình | Trung bình | System prompt với VN market context, sector mapping, feedback loop |
| Đối thủ copy nhanh | Trung bình | Trung bình | First-mover advantage, iterate nhanh, build user trust trước |
| NĐT mới không tin AI | Trung bình | Trung bình | Hiển thị accuracy rate, disclaimer rõ, feedback mechanism |
| AI hallucinate số liệu | Thấp | Cao | Validate output against real data, không cho AI tự generate số |
| Solo developer bottleneck | Cao | Trung bình | MVP chỉ 1 feature, managed services (Firebase/Supabase) |

---

*FTrade cung cấp thông tin và phân tích tham khảo, không phải tư vấn đầu tư. Mọi quyết định đầu tư là trách nhiệm của người dùng.*
