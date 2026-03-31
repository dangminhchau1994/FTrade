---
stepsCompleted: ['step-01-validate-prerequisites', 'step-02-design-epics', 'step-03-create-stories', 'step-04-final-validation']
inputDocuments: ['docs/prd.md', 'docs/architecture.md']
---

# FTrade Phase 3 - Epic Breakdown

## Tổng quan

Tài liệu này phân rã các yêu cầu từ PRD và Architecture thành các epic và story có thể triển khai cho FTrade Phase 3 (Tích hợp AI).

**Bối cảnh:** Phase 1-2 đã hoàn tất (market data, news, watchlist, alerts, TA/FA engine). PRD Phase 3 tập trung vào AI Morning Brief MVP.

## Danh mục yêu cầu

### Yêu cầu chức năng (Functional Requirements)

**AI Morning Brief (FR1-FR6):**
- FR1: User có thể xem AI Morning Brief tóm tắt 3-5 tin quan trọng nhất hôm nay
- FR2: User có thể xem phân tích tác động của từng tin đến nhóm ngành cụ thể
- FR3: User có thể xem danh sách mã đáng chú ý trong mỗi nhóm ngành được phân tích
- FR4: System tự động tạo Morning Brief mỗi ngày trước 8h sáng
- FR5: System cache Morning Brief và hiển thị brief cuối cùng khi user offline
- FR6: User có thể xem timestamp cập nhật của Morning Brief

**Phản hồi & Độ chính xác (FR7-FR9):**
- FR7: User có thể đánh giá mỗi dự báo ngành là "Chính xác" hoặc "Không chính xác"
- FR8: Admin có thể xem accuracy rate tổng hợp theo tuần và theo nhóm ngành
- FR9: System log mọi dự báo ngành và so sánh với biến động thực tế

**Phân quyền Free/Premium (FR10-FR13):**
- FR10: Free user chỉ xem được 1 nhóm ngành/ngày trong Morning Brief
- FR11: Premium user xem được tất cả nhóm ngành trong Morning Brief
- FR12: User có thể nâng cấp từ Free lên Premium qua in-app purchase
- FR13: System hiển thị upgrade prompt khi Free user đạt giới hạn

**Thông báo (FR14-FR16):**
- FR14: User nhận push notification khi Morning Brief đã sẵn sàng
- FR15: User có thể bật/tắt từng loại notification trong Settings
- FR16: User nhận push notification khi price alert triggered (đã có Phase 2)

**Tuân thủ pháp lý (FR17-FR20):**
- FR17: System hiển thị disclaimer dưới mỗi phân tích AI
- FR18: AI output không chứa ngôn ngữ khuyến nghị mua/bán trực tiếp
- FR19: User phải đồng ý Terms of Service trước khi sử dụng AI features lần đầu
- FR20: System validate AI response trước khi hiển thị (filter ngôn ngữ tư vấn)

**Quản trị & Giám sát (FR21-FR25):**
- FR21: Admin có thể xem API cost tổng hợp theo ngày/tháng
- FR22: Admin có thể xem accuracy tracking theo nhóm ngành
- FR23: Admin có thể chỉnh sửa system prompt cho Claude API
- FR24: Admin nhận notification khi cron job hoàn thành hoặc thất bại
- FR25: Admin có thể xem conversion rate free→paid

**Dữ liệu & Kết nối (FR26-FR28):**
- FR26: System hiển thị trạng thái kết nối (online/offline)
- FR27: System cảnh báo khi dữ liệu delay > 5 phút
- FR28: System cache market data, news, và Morning Brief cho offline access

**Đã hoàn tất Phase 1-2 (FR29-FR35) - DONE:**
- FR29: User xem giá cổ phiếu realtime
- FR30: User xem tin tức thị trường
- FR31: User tạo và quản lý watchlist
- FR32: User đặt price alerts
- FR33: User xem biểu đồ TA (MACD, RSI, MA)
- FR34: User xem phân tích FA (Piotroski, Altman Z, DuPont)
- FR35: User chuyển đổi dark/light theme

### Yêu cầu phi chức năng (Non-Functional Requirements)

**Hiệu năng:**
- NFR1: Morning Brief cron job hoàn thành trong 30 phút (7h → 7h30)
- NFR2: Morning Brief screen load trong < 2 giây (warm cache)
- NFR3: Market data realtime (MQTT) delay < 3 giây so với source
- NFR4: Push notification gửi trong < 1 phút sau khi brief sẵn sàng
- NFR5: App cold start < 4 giây trên thiết bị mid-range

**Bảo mật:**
- NFR6: Claude API key lưu trên backend, không embed trong app binary
- NFR7: App ↔ backend communication qua HTTPS/TLS 1.2+
- NFR8: Payment qua Apple/Google IAP — app không lưu thông tin thanh toán
- NFR9: Admin dashboard yêu cầu authentication
- NFR10: API rate limiting: 100 requests/phút/user

**Khả năng mở rộng:**
- NFR11: Backend hỗ trợ 10,000 concurrent users đọc Morning Brief
- NFR12: Morning Brief là shared content (tạo 1 lần, serve tất cả)
- NFR13: Cache layer (CDN/edge cache) cho Morning Brief
- NFR14: Database feedback/accuracy hỗ trợ 1M+ records

**Độ tin cậy:**
- NFR15: Available ≥ 99% trong giờ giao dịch (9h-15h, T2-T6)
- NFR16: Morning Brief cron có retry — Claude API fail → retry 3 lần, exponential backoff
- NFR17: Morning Brief thất bại → hiển thị brief ngày trước kèm thông báo
- NFR18: MQTT auto-reconnect với exponential backoff (đã có Phase 2)
- NFR19: Crash rate < 1% sessions (Firebase Crashlytics)

### Yêu cầu bổ sung từ Architecture

- Firebase project setup: 2 môi trường (dev + prod) qua project aliases
- Firestore collections: morning_briefs, feedback, accuracy_logs, users, api_costs, system_config
- Firebase Auth: Anonymous (free) → email/Google sign-in (premium)
- Claude API proxy: @anthropic-ai/sdk wrapper trong Firebase Functions
- AI output validation pipeline: regex check "nên mua", "khuyến nghị", "đề xuất mua/bán"
- CDN caching: Firebase Hosting, 4h TTL cho Morning Brief
- CI/CD: GitHub Actions → firebase deploy --only functions
- IAP receipt verification server-side (Apple/Google)
- Rate limiting middleware: 100 requests/phút/user
- Structured error JSON format: { success, data/error }
- Thứ tự triển khai: Firebase setup → Claude proxy → Cron → Flutter UI → FCM → IAP → Feedback → Admin

### Yêu cầu UX Design

Chưa có tài liệu UX Design riêng. UX sẽ được thiết kế inline trong quá trình triển khai.

### Bản đồ phủ yêu cầu (FR Coverage Map)

| FR | Epic | Mô tả |
|---|---|---|
| FR1 | Epic 2 | Xem Morning Brief tóm tắt 3-5 tin |
| FR2 | Epic 2 | Phân tích tác động tin → nhóm ngành |
| FR3 | Epic 2 | Danh sách mã đáng chú ý theo ngành |
| FR4 | Epic 2 | Tự động tạo brief trước 8h sáng |
| FR5 | Epic 2 | Cache brief cho offline |
| FR6 | Epic 2 | Timestamp cập nhật brief |
| FR7 | Epic 3 | Đánh giá dự báo chính xác/không |
| FR8 | Epic 3 | Admin xem accuracy rate |
| FR9 | Epic 3 | Log dự báo vs biến động thực tế |
| FR10 | Epic 5 | Free: 1 nhóm ngành/ngày |
| FR11 | Epic 5 | Premium: tất cả nhóm ngành |
| FR12 | Epic 5 | Nâng cấp Premium qua IAP |
| FR13 | Epic 5 | Upgrade prompt khi đạt giới hạn |
| FR14 | Epic 4 | Push notification brief sẵn sàng |
| FR15 | Epic 4 | Bật/tắt từng loại notification |
| FR17 | Epic 2 | Disclaimer dưới phân tích AI |
| FR18 | Epic 2 | AI không khuyến nghị mua/bán |
| FR19 | Epic 1 | Đồng ý ToS trước khi dùng AI |
| FR20 | Epic 2 | Validate AI response |
| FR21 | Epic 6 | Admin xem API cost |
| FR22 | Epic 6 | Admin xem accuracy tracking |
| FR23 | Epic 6 | Admin chỉnh system prompt |
| FR24 | Epic 6 | Admin notification cron job |
| FR25 | Epic 6 | Admin xem conversion rate |
| FR26 | Epic 1 | Trạng thái kết nối online/offline |
| FR27 | Epic 4 | Cảnh báo dữ liệu delay > 5 phút |
| FR28 | Epic 2 | Cache cho offline access |
| FR29-35 | — | Đã hoàn tất Phase 1-2 |

## Danh sách Epic

### Epic 1: Nền tảng Backend & Xác thực người dùng
User có thể đăng nhập app (anonymous hoặc email/Google), đồng ý Terms of Service, và xem trạng thái kết nối. Epic này thiết lập nền tảng Firebase (Functions, Firestore, Auth, CI/CD) cho toàn bộ Phase 3.
**FRs:** FR19, FR26
**NFRs liên quan:** NFR6, NFR7, NFR9, NFR10, NFR15

### Epic 2: AI Morning Brief — Trải nghiệm cốt lõi
User có thể đọc bản tin AI Morning Brief mỗi sáng — tóm tắt 3-5 tin quan trọng, phân tích tác động đến nhóm ngành, danh sách mã đáng chú ý — kèm disclaimer pháp lý. Hỗ trợ offline cache và hiển thị timestamp cập nhật.
**FRs:** FR1, FR2, FR3, FR4, FR5, FR6, FR17, FR18, FR20, FR28
**NFRs liên quan:** NFR1, NFR2, NFR11, NFR12, NFR13, NFR16, NFR17

### Epic 3: Phản hồi & Theo dõi độ chính xác
User có thể đánh giá mỗi dự báo ngành là "Chính xác" hoặc "Không chính xác". System tự động log dự báo và so sánh với biến động thực tế để cải thiện chất lượng AI.
**FRs:** FR7, FR8, FR9
**NFRs liên quan:** NFR14

### Epic 4: Thông báo đẩy (Push Notifications)
User nhận push notification khi Morning Brief sẵn sàng mỗi sáng. User có thể bật/tắt từng loại thông báo trong Settings. System cảnh báo khi dữ liệu bị delay.
**FRs:** FR14, FR15, FR27
**NFRs liên quan:** NFR4

### Epic 5: Đăng ký Premium & In-App Purchase
Free user bị giới hạn 1 nhóm ngành/ngày trong Morning Brief. User có thể nâng cấp Premium qua in-app purchase để mở khóa tất cả nhóm ngành. System hiển thị upgrade prompt khi đạt giới hạn.
**FRs:** FR10, FR11, FR12, FR13
**NFRs liên quan:** NFR8

### Epic 6: Quản trị & Giám sát hệ thống
Admin có thể xem API cost theo ngày/tháng, accuracy tracking theo nhóm ngành, conversion rate free→paid. Admin có thể chỉnh sửa system prompt cho Claude API và nhận notification khi cron job hoàn thành/thất bại.
**FRs:** FR21, FR22, FR23, FR24, FR25
**NFRs liên quan:** NFR9

---

## Epic 1: Nền tảng Backend & Xác thực người dùng

User có thể đăng nhập app (anonymous hoặc email/Google), đồng ý Terms of Service, và xem trạng thái kết nối. Epic này thiết lập nền tảng Firebase cho toàn bộ Phase 3.

### Story 1.1: Setup Firebase project & Anonymous Auth

As a user,
I want mở app và tự động có identity,
So that tôi có thể sử dụng các tính năng của app mà không cần đăng ký.

**Acceptance Criteria:**

**Given** user mở app lần đầu
**When** app khởi động
**Then** Firebase Auth tạo anonymous account tự động
**And** Firestore document `users/{uid}` được tạo với tier: "free", tosAccepted: false

**Given** developer push code lên branch main
**When** GitHub Actions chạy
**Then** Firebase Functions được deploy tự động lên môi trường dev/prod

**Given** backend nhận request
**When** request không có Firebase Auth token
**Then** trả về HTTP 401 với error JSON: { success: false, error: { code: "UNAUTHENTICATED" } }

**Given** backend nhận request từ authenticated user
**When** user gửi > 100 requests/phút
**Then** trả về HTTP 429 rate limit error

### Story 1.2: Đăng nhập Email/Google

As a user,
I want đăng nhập bằng email hoặc Google account,
So that tôi có thể nâng cấp Premium và đồng bộ dữ liệu sau này.

**Acceptance Criteria:**

**Given** user đang dùng anonymous account
**When** user chọn "Đăng nhập" và nhập email/password hoặc chọn Google Sign-In
**Then** anonymous account được link với email/Google credential
**And** Firestore document `users/{uid}` được cập nhật (email, displayName)
**And** uid giữ nguyên (không tạo account mới)

**Given** user đã đăng nhập
**When** user mở app lại
**Then** session được restore tự động, không cần đăng nhập lại

**Given** đăng nhập thất bại (sai password, network error)
**When** user thử đăng nhập
**Then** hiển thị thông báo lỗi rõ ràng bằng tiếng Việt

### Story 1.3: Đồng ý Terms of Service (FR19)

As a user,
I want đọc và đồng ý điều khoản sử dụng trước khi dùng AI features,
So that tôi hiểu rõ giới hạn trách nhiệm của app.

**Acceptance Criteria:**

**Given** user chưa đồng ý ToS (tosAccepted: false)
**When** user truy cập Morning Brief lần đầu
**Then** hiển thị bottom sheet ToS với nội dung: "FTrade cung cấp thông tin tham khảo, không phải tư vấn đầu tư..."
**And** nút "Tôi đồng ý" và "Hủy"

**Given** user bấm "Tôi đồng ý"
**When** ToS bottom sheet đang hiển thị
**Then** Firestore cập nhật tosAccepted: true, tosAcceptedAt: timestamp
**And** user được chuyển đến Morning Brief screen

**Given** user bấm "Hủy"
**When** ToS bottom sheet đang hiển thị
**Then** quay lại màn hình trước, không truy cập được AI features

### Story 1.4: Hiển thị trạng thái kết nối (FR26)

As a user,
I want biết app đang online hay offline,
So that tôi biết dữ liệu có đang cập nhật hay không.

**Acceptance Criteria:**

**Given** device mất kết nối internet
**When** connectivity thay đổi
**Then** hiển thị banner "Đang offline — dữ liệu có thể không cập nhật" phía trên cùng app
**And** banner có màu vàng/cam dễ nhận biết

**Given** device khôi phục kết nối
**When** connectivity thay đổi từ offline → online
**Then** banner biến mất sau 2 giây
**And** dữ liệu tự động refresh

---

## Epic 2: AI Morning Brief — Trải nghiệm cốt lõi

User có thể đọc bản tin AI Morning Brief mỗi sáng — tóm tắt tin, phân tích ngành, mã đáng chú ý — kèm disclaimer pháp lý và offline cache.

### Story 2.1: Claude API proxy & AI output validation (FR18, FR20)

As a developer,
I want backend proxy gọi Claude API và validate output,
So that API key được bảo mật và AI không tạo ra ngôn ngữ khuyến nghị đầu tư.

**Acceptance Criteria:**

**Given** Firebase Function `claude-client.ts` được deploy
**When** function gọi Claude API
**Then** sử dụng @anthropic-ai/sdk với API key từ environment config (không hardcode)
**And** system prompt chứa context thị trường VN, danh sách nhóm ngành, quy tắc ngôn ngữ

**Given** Claude API trả về response
**When** output chứa "nên mua", "khuyến nghị", "đề xuất mua/bán", hoặc giá mục tiêu cụ thể
**Then** response bị reject, retry với adjusted prompt (thêm nhắc nhở không tư vấn)
**And** log violation vào `api_costs` collection

**Given** Claude API trả về response hợp lệ
**When** validate-output.ts kiểm tra
**Then** response được đánh dấu validated: true
**And** disclaimer text được inject vào mỗi sector analysis

### Story 2.2: Cron job tạo Morning Brief hàng ngày (FR4)

As a user,
I want Morning Brief được tạo tự động mỗi sáng trước 8h,
So that tôi có bản tin sẵn sàng khi mở app.

**Acceptance Criteria:**

**Given** Cloud Scheduler trigger lúc 7h sáng (GMT+7)
**When** function `generateMorningBrief` được gọi
**Then** thu thập tin tức từ Vietstock RSS (3-5 tin nổi bật nhất)
**And** gọi Claude API phân tích tác động đến nhóm ngành
**And** validate output (Story 2.1)
**And** lưu vào Firestore `morning_briefs/{date}` với đầy đủ sectors, stocks, summary
**And** log chi phí API vào `api_costs` collection

**Given** Claude API fail
**When** retry đã hết 3 lần (backoff 1s, 4s, 16s)
**Then** lưu status: "failed" vào Firestore
**And** gửi notification cho admin (FR24)
**And** app sẽ hiển thị brief ngày trước (NFR17)

**Given** cron job hoàn tất thành công
**When** brief được lưu vào Firestore
**Then** brief được cache qua Firebase Hosting CDN (TTL 4h)
**And** tổng thời gian < 30 phút (NFR1)

### Story 2.3: REST endpoint phục vụ Morning Brief

As a user,
I want app lấy được Morning Brief từ backend,
So that tôi đọc bản tin nhanh chóng.

**Acceptance Criteria:**

**Given** user gọi GET `/api/morning-briefs`
**When** brief hôm nay tồn tại
**Then** trả về JSON: { success: true, data: { date, summary, sectors: [...], createdAt } }
**And** response từ CDN cache (không hit Firestore nếu cache còn valid)
**And** load time < 2 giây (NFR2)

**Given** user gọi GET `/api/morning-briefs/:date`
**When** date hợp lệ và brief tồn tại
**Then** trả về brief của ngày đó

**Given** brief hôm nay chưa được tạo (trước 7h30 hoặc cron fail)
**When** user gọi GET `/api/morning-briefs`
**Then** trả về brief ngày gần nhất kèm field: `isFallback: true`
**And** response chứa `fallbackReason: "Brief hôm nay chưa sẵn sàng"`

### Story 2.4: Màn hình Morning Brief (FR1, FR2, FR3, FR6, FR17)

As a user,
I want đọc Morning Brief trên app với giao diện rõ ràng,
So that tôi hiểu thị trường hôm nay trong 2 phút.

**Acceptance Criteria:**

**Given** user mở tab/screen Morning Brief
**When** brief hôm nay đã sẵn sàng
**Then** hiển thị:
- Header: "Bản tin sáng" + timestamp cập nhật (FR6) + "Live" badge nếu hôm nay
- Phần tóm tắt: 3-5 tin quan trọng nhất (FR1)
- Danh sách nhóm ngành (expandable cards): tên ngành + tóm tắt tác động (FR2)
- Trong mỗi card ngành: danh sách mã đáng chú ý kèm giải thích ngắn (FR3)
- Disclaimer cuối mỗi phân tích: "Thông tin tham khảo, không phải tư vấn đầu tư" (FR17)

**Given** user tap vào mã cổ phiếu trong danh sách
**When** mã hợp lệ
**Then** navigate đến StockDetailScreen (đã có Phase 1-2)

**Given** brief đang loading
**When** user mở Morning Brief screen
**Then** hiển thị shimmer/skeleton loading

**Given** brief là fallback (ngày cũ)
**When** hiển thị brief
**Then** hiển thị banner cảnh báo: "Bản tin ngày [date], chưa có bản tin mới"

### Story 2.5: Offline cache Morning Brief (FR5, FR28)

As a user,
I want đọc Morning Brief khi không có internet,
So that tôi vẫn nắm được tình hình thị trường khi offline.

**Acceptance Criteria:**

**Given** app fetch Morning Brief thành công
**When** response trả về
**Then** lưu brief vào Hive box `morning_brief_cache`
**And** giữ tối đa 7 brief gần nhất

**Given** device offline
**When** user mở Morning Brief screen
**Then** hiển thị brief cuối cùng từ Hive cache
**And** hiển thị label: "Cập nhật lúc [timestamp]" và banner offline
**And** nút "Thử lại" để refresh khi có mạng

**Given** device từ offline → online
**When** user đang xem cached brief
**Then** tự động fetch brief mới và cập nhật UI

---

## Epic 3: Phản hồi & Theo dõi độ chính xác

User có thể đánh giá dự báo ngành và system tự động theo dõi accuracy.

### Story 3.1: Nút phản hồi dự báo ngành (FR7)

As a user,
I want đánh giá mỗi dự báo ngành là chính xác hay không,
So that AI có thể cải thiện chất lượng phân tích.

**Acceptance Criteria:**

**Given** user đang xem Morning Brief
**When** user scroll đến cuối mỗi sector card
**Then** hiển thị 2 nút: "Chính xác ✓" và "Không chính xác ✗"

**Given** user bấm "Chính xác" hoặc "Không chính xác"
**When** user đã đăng nhập (authenticated)
**Then** gửi POST `/api/feedback` với: { briefDate, sectorId, isAccurate }
**And** lưu vào Firestore `feedback` collection
**And** nút chuyển sang trạng thái "Đã đánh giá" (disabled, có icon check)
**And** hiển thị "Cảm ơn phản hồi của bạn!"

**Given** user đã đánh giá 1 sector
**When** user mở lại Morning Brief cùng ngày
**Then** nút phản hồi hiển thị trạng thái đã chọn trước đó (persisted)

### Story 3.2: Tự động log & so sánh dự báo vs thực tế (FR9)

As a system,
I want tự động so sánh dự báo AI với biến động thực tế,
So that accuracy rate được tính toán khách quan.

**Acceptance Criteria:**

**Given** Morning Brief chứa dự báo hướng đi cho mỗi nhóm ngành (ví dụ: "Dầu khí có thể tăng")
**When** phiên giao dịch kết thúc (15h hàng ngày)
**Then** cron job chạy: lấy biến động thực tế của nhóm ngành (từ SSI/VNDirect)
**And** so sánh predicted direction vs actual change %
**And** lưu vào Firestore `accuracy_logs/{date}_{sectorId}`

**Given** dự báo "nhóm ngành X có thể tăng/giảm"
**When** thực tế nhóm đó biến động cùng hướng ≥ 0.5%
**Then** đánh dấu isCorrect: true

**Given** biến động thực tế < 0.5% (đi ngang)
**When** so sánh accuracy
**Then** đánh dấu isCorrect: null (không đủ biến động để đánh giá)

### Story 3.3: Admin xem accuracy rate (FR8)

As an admin,
I want xem tỷ lệ chính xác tổng hợp,
So that tôi biết AI quality và cần adjust system prompt ở đâu.

**Acceptance Criteria:**

**Given** admin gọi GET `/admin/accuracy`
**When** có dữ liệu accuracy_logs
**Then** trả về: accuracy rate tuần qua (%), accuracy theo từng nhóm ngành, top 3 ngành chính xác nhất, top 3 ngành kém nhất

**Given** admin gọi GET `/admin/accuracy?weeks=4`
**When** có dữ liệu
**Then** trả về accuracy trend 4 tuần gần nhất

**Given** admin chưa đăng nhập hoặc không có role admin
**When** gọi `/admin/*` endpoints
**Then** trả về HTTP 403 Forbidden

---

## Epic 4: Thông báo đẩy (Push Notifications)

User nhận push notification khi Morning Brief sẵn sàng và quản lý notification preferences.

### Story 4.1: FCM setup & notification Morning Brief sẵn sàng (FR14)

As a user,
I want nhận push notification khi Morning Brief mới đã sẵn sàng,
So that tôi không cần mở app để kiểm tra.

**Acceptance Criteria:**

**Given** user mở app lần đầu
**When** app khởi động
**Then** request notification permission (iOS/Android)
**And** nếu user cho phép: đăng ký FCM token qua POST `/api/user/register-fcm`
**And** lưu fcmToken vào Firestore `users/{uid}`

**Given** cron job tạo Morning Brief thành công
**When** brief được lưu vào Firestore
**Then** Firebase Function gửi FCM notification đến tất cả user có fcmToken
**And** notification title: "Bản tin sáng đã sẵn sàng"
**And** notification body: tóm tắt 1 dòng (ví dụ: "Dầu khí tăng mạnh, BĐS chịu áp lực...")
**And** gửi trong < 1 phút sau khi brief sẵn sàng (NFR4)

**Given** user tap vào notification
**When** app mở
**Then** navigate thẳng đến Morning Brief screen

### Story 4.2: Quản lý notification preferences (FR15)

As a user,
I want bật/tắt từng loại notification,
So that tôi chỉ nhận thông báo tôi quan tâm.

**Acceptance Criteria:**

**Given** user mở Settings screen
**When** scroll đến phần "Thông báo"
**Then** hiển thị toggle cho từng loại:
- Morning Brief (mặc định: bật)
- Cảnh báo giá (mặc định: bật, đã có Phase 2)
- Cảnh báo dữ liệu delay (mặc định: tắt)

**Given** user tắt toggle "Morning Brief"
**When** toggle chuyển OFF
**Then** cập nhật Firestore `users/{uid}.notificationPrefs.morningBrief: false`
**And** user không nhận FCM notification cho Morning Brief nữa

**Given** user bật lại toggle
**When** toggle chuyển ON
**Then** cập nhật Firestore và user nhận notification trở lại

### Story 4.3: Cảnh báo dữ liệu delay (FR27)

As a user,
I want được cảnh báo khi dữ liệu bị delay,
So that tôi biết giá hiện tại có thể không chính xác.

**Acceptance Criteria:**

**Given** MQTT connection hoạt động nhưng không nhận data mới > 5 phút (trong giờ giao dịch 9h-15h)
**When** system detect delay
**Then** hiển thị banner cảnh báo: "Dữ liệu có thể bị delay. Cập nhật cuối: [timestamp]"
**And** banner màu vàng, hiển thị trên các screen có dữ liệu giá

**Given** data bắt đầu cập nhật lại
**When** nhận message MQTT mới
**Then** banner biến mất sau 3 giây

**Given** user đã tắt notification "Cảnh báo dữ liệu delay" trong Settings
**When** data bị delay
**Then** không gửi push notification, nhưng vẫn hiển thị banner trong app

---

## Epic 5: Đăng ký Premium & In-App Purchase

Free user bị giới hạn, có thể nâng cấp Premium qua IAP.

### Story 5.1: Logic phân quyền Free/Premium (FR10, FR11)

As a user,
I want app tự động áp dụng quyền hạn theo tier của tôi,
So that tôi trải nghiệm đúng tính năng Free hoặc Premium.

**Acceptance Criteria:**

**Given** user có tier: "free"
**When** user xem Morning Brief
**Then** chỉ hiển thị 1 nhóm ngành đầu tiên (expanded)
**And** các nhóm ngành còn lại hiển thị title nhưng nội dung bị blur/lock
**And** icon khóa trên mỗi nhóm bị lock

**Given** user có tier: "premium"
**When** user xem Morning Brief
**Then** hiển thị tất cả nhóm ngành, tất cả mở rộng được

**Given** user vừa mua Premium (tier thay đổi)
**When** quay lại Morning Brief
**Then** tất cả nhóm ngành unlock ngay lập tức (không cần restart app)

### Story 5.2: Tích hợp In-App Purchase (FR12)

As a user,
I want mua Premium subscription qua App Store/Google Play,
So that tôi mở khóa tất cả tính năng AI.

**Acceptance Criteria:**

**Given** user bấm "Nâng cấp Premium"
**When** paywall screen hiển thị
**Then** hiển thị: giá subscription (99K-199K VND/tháng), danh sách tính năng Premium, nút "Đăng ký"
**And** tuân thủ Apple/Google IAP guidelines

**Given** user hoàn tất thanh toán trên App Store/Google Play
**When** app nhận receipt
**Then** gửi receipt đến POST `/api/iap/verify`
**And** backend verify receipt với Apple/Google servers
**And** cập nhật Firestore `users/{uid}.tier: "premium"`, `premiumSince: timestamp`
**And** hiển thị "Chúc mừng! Bạn đã là Premium member"

**Given** subscription hết hạn (không gia hạn)
**When** backend kiểm tra định kỳ
**Then** cập nhật tier về "free"
**And** user bị giới hạn lại 1 nhóm ngành/ngày

**Given** verify receipt thất bại
**When** backend nhận receipt không hợp lệ
**Then** không upgrade tier
**And** trả về error: "Không thể xác minh thanh toán. Vui lòng thử lại."

### Story 5.3: Upgrade prompt khi đạt giới hạn (FR13)

As a free user,
I want thấy lời mời nâng cấp khi bị giới hạn,
So that tôi biết cách mở khóa tính năng.

**Acceptance Criteria:**

**Given** free user tap vào nhóm ngành bị lock trong Morning Brief
**When** nội dung bị blur
**Then** hiển thị overlay: "Nâng cấp Premium để xem tất cả nhóm ngành"
**And** nút "Xem gói Premium" → navigate đến paywall screen
**And** nút "Để sau" → đóng overlay

**Given** free user đã xem upgrade prompt 3 lần trong ngày
**When** tap vào nhóm ngành bị lock lần thứ 4+
**Then** vẫn hiển thị prompt nhưng không push notification thêm (tránh spam)

---

## Epic 6: Quản trị & Giám sát hệ thống

Admin có thể monitor cost, accuracy, system prompt, và cron job.

### Story 6.1: Theo dõi API cost (FR21)

As an admin,
I want xem chi phí Claude API theo ngày/tháng,
So that tôi kiểm soát budget và phát hiện bất thường.

**Acceptance Criteria:**

**Given** mỗi lần gọi Claude API
**When** response trả về
**Then** log vào Firestore `api_costs`: { timestamp, function, inputTokens, outputTokens, costUsd }

**Given** admin gọi GET `/admin/costs`
**When** không có query params
**Then** trả về: tổng cost tháng hiện tại, cost trung bình/ngày, cost hôm nay, số lần gọi API

**Given** admin gọi GET `/admin/costs?month=2026-03`
**When** tháng hợp lệ
**Then** trả về cost breakdown theo ngày trong tháng đó

### Story 6.2: Quản lý system prompt (FR23)

As an admin,
I want chỉnh sửa system prompt cho Claude API,
So that tôi cải thiện chất lượng phân tích AI.

**Acceptance Criteria:**

**Given** admin gọi GET `/admin/system-prompt`
**When** authenticated với role admin
**Then** trả về system prompt hiện tại từ Firestore `system_config/system_prompt`

**Given** admin gọi PUT `/admin/system-prompt` với body mới
**When** body chứa trường `prompt` (string, ≤ 10,000 ký tự)
**Then** cập nhật Firestore `system_config/system_prompt`
**And** lưu version cũ vào `system_config/system_prompt_history` (append)
**And** trả về { success: true, updatedAt: timestamp }

**Given** prompt mới được lưu
**When** cron job chạy lần tiếp theo
**Then** sử dụng system prompt mới

### Story 6.3: Giám sát cron job & notification admin (FR24)

As an admin,
I want nhận thông báo khi cron job thành công hoặc thất bại,
So that tôi phản ứng kịp thời khi có sự cố.

**Acceptance Criteria:**

**Given** cron job `generateMorningBrief` hoàn thành thành công
**When** brief được lưu vào Firestore
**Then** gửi notification cho admin (email hoặc FCM): "Morning Brief [date] đã tạo xong. Cost: $X.XX. Sectors: N"

**Given** cron job thất bại sau 3 lần retry
**When** tất cả retry đều fail
**Then** gửi notification khẩn cho admin: "CẢNH BÁO: Morning Brief [date] thất bại. Lỗi: [error message]"
**And** log error chi tiết vào Cloud Logging

**Given** admin gọi GET `/admin/cron-status`
**When** authenticated
**Then** trả về: status cron job gần nhất, lịch sử 7 ngày (date, status, duration, cost, error nếu có)

### Story 6.4: Xem conversion rate & accuracy tracking (FR22, FR25)

As an admin,
I want xem conversion rate và accuracy tracking,
So that tôi đánh giá hiệu quả sản phẩm.

**Acceptance Criteria:**

**Given** admin gọi GET `/admin/conversion`
**When** authenticated với role admin
**Then** trả về: tổng free users, tổng premium users, conversion rate (%), trend 4 tuần

**Given** admin gọi GET `/admin/accuracy`
**When** có dữ liệu accuracy_logs
**Then** trả về: accuracy rate tổng, accuracy theo từng nhóm ngành, trend tuần, top/bottom ngành

**Given** admin gọi GET `/admin/dashboard`
**When** authenticated
**Then** trả về tổng hợp: cost summary + accuracy summary + conversion summary (aggregated view)
