# FTrade - Progress Tracker

## Phase 1: Nền tảng dữ liệu ✅ DONE

### 2026-03-14 - Khởi tạo dự án
- [x] Setup Flutter project, cấu trúc thư mục
- [x] Viết README documentation
- [x] Tích hợp live market data APIs (giá, khối lượng)
- [x] Tích hợp news APIs (tin tức thị trường)
- [x] Thay toàn bộ mock data bằng API thật
- [x] Thu thập thông tin cổ tức, chốt quyền (Vietstock Finance API)
- [x] Lịch sự kiện doanh nghiệp (dividend, AGM, rights issue)

### 2026-03-16 - WebSocket realtime & UI wiring
- [x] WebSocket module (auto-reconnect, heartbeat, status stream)
- [x] RealtimeMarketData model (giá, KL, change, bid/ask 3 bước, ATO/ATC, NN)
- [x] MarketDataController (Riverpod StateNotifier)
- [x] Wire realtime vào StockListTile (tự động overlay tất cả screens)
- [x] Wire realtime vào StockDetailScreen (bid/ask table, Live badge)
- [x] Auto-connect WebSocket khi app start, pause/resume lifecycle
- [x] SSI WebSocket constants trong ApiConstants
- [x] Gắn handler cho 7 empty buttons:
  - HomeScreen: notification → watchlist, "Xem tất cả" → market/news
  - NewsScreen: filter theo mã CP (bottom sheet)
  - NewsDetailScreen: share (copy link), bookmark (Hive storage)
  - StockDetailScreen: share (copy thông tin CP)
- [x] StockFormat extension (giá nghìn đồng: 149800 → "149.80", change: "9.80 / 7.00%")
- [x] Màu sắc chuẩn TTCK VN (tím=trần, xanh lá=tăng, vàng=TC, đỏ=giảm, xanh dương=sàn)
  - AppTheme.stockColor() dựa trên ceiling/floor/refPrice
  - Áp dụng cho StockDetailScreen, StockListTile, StockChangeText

### 2026-03-17 - Fix BCTC & Industry Comparison APIs
- [x] Fix BCTC API: VNDirect /financial_statements hoạt động, phát hiện đúng mapping:
  - modelType 1=BS (BCĐKT), 2=IS (BCKQKD), 3=CF (LCTT) — cũ mapping ngược
  - reportType QUARTER = quý đơn lẻ hợp nhất, QUARTER2 = công ty mẹ
  - itemCode theo mã số chuẩn VAS (Thông tư 200): 21001=DT thuần, 22100=Giá vốn, 23003=LNST...
  - Giá trị đơn vị: đồng (không nhân 1e6 như code cũ)
- [x] Fix Industry Comparison: đổi /ratios/latest (404) → /ratios, dùng q= syntax thay filter=/where=
- [x] Thêm ApiConstants.financialStatements endpoint

### 2026-03-20 - MQTT Migration (đang làm)
- [x] Phát hiện SSI đổi endpoint: wgateway-iboard.ssi.com.vn → NXDOMAIN (domain chết)
- [x] Reverse engineer JS bundle iboard.ssi.com.vn → tìm ra endpoint mới: wss://price-streaming.ssi.com.vn/mqtt
- [x] Xác nhận endpoint public (không cần auth), protocol MQTT 3.1.1, username/password: mqtt-ssi/mqtt-ssi
- [x] Reverse engineer StockData protobuf schema (72 fields, từ JS bundle)
  - Topic format: s/{symbol}/MAIN, wildcard: s/+/MAIN
  - Prices: int32 raw VND, priceChange/Percent: sint32 zigzag encoded
- [x] Thêm mqtt_client ^10.3.0 vào pubspec.yaml
- [x] Viết MqttService (mqtt_service.dart): fix _disposed/reconnect flags, memory leak, auto re-subscribe
- [x] Update ApiConstants: ssiMqttUrl, ssiMqttUsername, ssiMqttPassword
- [x] Viết proto/stock_data.proto (72 fields reverse-engineered từ JS bundle)
- [x] Generate Dart code từ protoc (stock_data.pb.dart)
- [x] Rewrite MarketRealtimeDatasource dùng MQTT + StockData.fromBuffer()
  - Fix lifecycle bug (_mqtt != null guard thay vì _initialized flag)
  - Fix memory leak (giữ _statusSub ref)
  - Fix re-subscribe sau reconnect (_topics Set)
  - Fix dedup (so sánh Freezed equality trước khi emit)
  - Fix cache size limit (max 500 entries)
- [x] Update MarketDataController (đổi WebSocketStatus → MqttConnectionStatus)

### 2026-03-21 - Fix chỉ số cơ bản & industry comparison
- [x] Fix P/E, P/B, EPS, Vốn hóa không hiển thị: đổi filter=/where= → q= syntax
- [x] Fix multi-itemCode không hoạt động: fetch riêng từng ratio song song
- [x] EPS = Price / P/E (itemCode 51009 không có data, tính ngược từ P/E realtime)
- [x] Fix Industry Comparison thiếu ROE, ROA, D/E:
  - Tính từ financial_statements (data đến 2025-12-31)
  - ROE = TTM LNST / Vốn CSH, ROA = TTM LNST / Tổng TS, D/E = Nợ / Vốn CSH
  - Fetch BS (12700, 13000, 14000) + IS (23003) song song per chunk

---

## Phase 2: Phân tích & cảnh báo ✅ DONE

### 2026-03-22 - Watchlist + cảnh báo giá
- [x] PriceAlert model (Hive persistent storage)
- [x] PriceAlertNotifier (add/remove/toggle, persisted)
- [x] NotificationService (flutter_local_notifications, iOS+Android)
- [x] PriceAlertMonitor: subscribe MQTT stream → fire notification khi giá chạm ngưỡng
- [x] Auto-disable alert sau khi triggered
- [x] AddAlertDialog widget (set target price, above/below)
- [x] Wire monitor vào main.dart (auto-start on app launch)

### 2026-03-22 - Phát hiện dòng tiền bất thường
- [x] VolumeAnomaly entity (symbol, todayVol, avgVol20d, ratio, price, changePercent)
- [x] getVolumeAnomalies() trong MoneyFlowApiDatasource:
  - Lấy top 200 cổ phiếu KL cao nhất ngày GD gần nhất
  - Batch fetch 21 phiên lịch sử cho top 50
  - Tính ratio = todayVol / avg20d, lọc ratio >= 2
- [x] volumeAnomaliesProvider (FutureProvider)
- [x] VolumeAnomalyList widget (ratio badge, KL hôm nay vs TB, changePercent)
- [x] Tab "KL bất thường" trong MoneyFlowScreen (tab thứ 4)

### 2026-03-22 - Realtime chỉ số thị trường + Trang detail chỉ số
- [x] Fix format chỉ số: FormatUtils.indexValue() (#,##0.00 — không chia 1000)
- [x] IndexRealtimeDatasource: CafeF SignalR hub (wss://realtime.cafef.vn/hub/priceshub)
  - skipNegotiation=true, JoinChannel(symbol), sự kiện RealtimePrice
  - Auto-reconnect với exponential backoff
- [x] RealtimeIndexData entity (symbol, value, change, changePercent, advances, declines, unchanged)
- [x] MarketDataController: song song MQTT (stocks) + CafeF WS (indices)
- [x] realtimeMarketIndicesProvider: merge REST + realtime overlay
- [x] IndexDetailScreen (/index/:symbol):
  - Header: giá realtime, thay đổi, Live badge
  - Biểu đồ lịch sử (SSI iboard API) — 5 periods: 1M/3M/6M/1Y/5Y
  - Breadth bar (tăng/giảm/đứng)
  - Top 5 tăng / Top 5 giảm (theo sàn: HOSE/HNX/UPCOM)
- [x] Route /index/:symbol đăng ký trong AppRouter
- [x] Card chỉ số tại HomeScreen có thể tap để vào IndexDetailScreen

### 2026-03-22 - Phân tích TA
- [x] ChartApiDatasource: fetch OHLCV từ VNDirect (5 periods: 1D/1W/1M/3M/1Y)
- [x] IndicatorCalculator: MA5/10/20/50, RSI(14), MACD(12,26,9) với EMA Wilder's smoothing
- [x] StockChart widget:
  - Price line chart + gradient fill
  - Volume bar chart
  - MA overlay lines (toggle chips)
  - RSI panel (overbought 70 / oversold 30 lines)
  - MACD panel (histogram + signal line)
  - Period selector
- [x] Wire vào StockDetailScreen

### 2026-03-24 - Bugfix Phase 2
- [x] Fix typo `'volume '` (trailing space) trong market_api_datasource.dart → parse volume thất bại
- [x] Fix index mapping `'UPC-Index'` → `'UPCOM'` để realtime UPCOM match REST data
- [x] Fix PriceAlert thiếu equality → auto-disable sau khi triggered không hoạt động
- [x] Fix alert monitor dùng `indexWhere()` thay `indexOf()` cho auto-disable chính xác
- [x] Thêm `clearTriggered()` method để alert có thể trigger lại khi user thêm lại

### 2026-03-25 - Bugfix MQTT proto noise
- [x] Fix log noise: proto decode error cho symbols như VNR (schema mismatch) — đổi log level từ debug → trace

### 2026-03-26 - Fix realtime (đang làm)
- [x] Phát hiện SSI MQTT dùng self-signed cert → Flutter bị reject SSL silently
- [x] Fix: thêm `onBadCertificate = (_) => true` trong MqttService
- [x] Phát hiện CafeF SignalR ngưng gửi RealtimePrice events (chỉ có RealtimeMarkertStatus=5)
- [x] Tìm nguồn thay thế: SSI iboard chart API (resolution=1, poll 15s)
  - Cần headers `Referer: iboard.ssi.com.vn`, `Origin: iboard.ssi.com.vn` (403 nếu thiếu)
  - VNINDEX, HNXINDEX, VN30, HNX30 hoạt động. UPCOMINDEX không có data.
- [x] Rewrite `IndexRealtimeDatasource`: đổi CafeF WS → SSI iboard poll (Dio)
- [x] Update `MarketDataController` provider: inject Dio vào IndexRealtimeDatasource
- [ ] CÒN LẠI: Thêm Referer header cho `ChartApiDatasource.getIndexChartData()` (cũng dùng SSI iboard, có thể bị 403)
- [ ] CÒN LẠI: Test thực tế trên device

## Phase 3: Nhận định thông minh (đang làm)

### 2026-04-02 - UX Design Specification hoàn thành
- [x] PRD (`docs/prd.md`) — 35 FRs, 19 NFRs, 3 user journeys
- [x] Architecture (`docs/architecture.md`)
- [x] Epics & Stories (`docs/epics.md`) — 6 epics, 22 stories
- [x] UX Design Spec (`docs/ux-design-specification.md`) — 939 dòng, 14 steps hoàn thành
  - Design system: Material 3 + Flutter
  - Direction 6 "Summary First": Hero AI Card + Index Strip + Sector Cards
  - 7 custom components: AiSummaryHeroCard, SectorCard, IndexStripRow, StockChipRow, FeedbackRow, AccuracyBadge, OfflineBanner
  - 3 user journey flows (Minh, Lan, Chau) với Mermaid diagrams
  - UX patterns: loading, feedback, navigation, paywall, offline
  - Responsive: Compact/Regular tiers, WCAG 2.1 AA
- [x] Design mockups (`docs/ux-design-directions.html`) — 6 directions interactive

### 2026-03-25 - FA Analysis engine
- [x] Entity `FaAnalysis` (Freezed): PiotroskiScore, AltmanZScore (Original + EM Z''), DuPontAnalysis, GrowthMetrics, ValuationResult (Graham/PEG/DCF/EV-EBITDA/FCF Yield), RiskMetrics
- [x] `FaCalculator` (pure static, isolate-safe)
- [x] `FaAnalysisDatasource`: cache 6h + Flutter `compute` isolate
- [x] Provider `faAnalysisProvider` (FutureProvider.family)
- [ ] `FaDashboardScreen` UI
- [ ] Wire route `/fa/:symbol` vào AppRouter
- [ ] Wire button "Phân tích FA" vào StockDetailScreen
- [ ] Nhận định vĩ mô & dự đoán rủi ro
- [ ] AI recommendation / Stock screener

### 2026-04-02 - Epic 1: Nền tảng Backend & Auth
- [x] Thêm Firebase packages: `firebase_core`, `firebase_auth`, `cloud_firestore`, `google_sign_in`
- [x] `AppUser` model (Freezed): uid, tier (free/premium), tosAccepted, email, displayName
- [x] `UserRepository`: getOrCreateUser, acceptTos, updateProfile, watchUser (Firestore stream)
- [x] `AuthService` provider: signInAnonymously, signInWithGoogle, signInWithEmail, linkAnonymous→real
- [x] `_ensureAnonymousAuth()` trong main.dart — auto anonymous auth khi app start
- [x] `ConnectivityBanner` widget — offline banner vàng, auto show/hide (Story 1.4)
- [x] Wire `ConnectivityBanner` vào `MaterialApp.builder`
- [x] `TosBottomSheet` — bottom sheet ToS, update Firestore khi accept (Story 1.3)
- [x] `MorningBriefScreen` placeholder — ToS guard: show bottom sheet nếu chưa accept (Story 1.3)
- [x] Route `/brief` thêm vào router, set làm `initialLocation`
- [x] `firebase_options.dart` đã có (project ftrade-209d5)
- [x] GitHub Actions CI/CD chạy cron generate brief + evaluate accuracy

### 2026-04-12 - Epic 2: AI Morning Brief ✅ DONE
- [x] Backend: `run-generate-brief.ts` — cron 7h VN, gpt-5.4, retry 3 lần, lưu Firestore
- [x] Backend: `api/morning-briefs.ts` — GET `/api/morning-briefs`, auth, fallback
- [x] Backend: `lib/news-fetcher.ts` — RSS Vietstock, top 15 tin
- [x] Backend: `lib/ai-client.ts` — gpt-5.4 ($2.50/$15.00 per 1M), forbidden phrases, cost tracking
- [x] Flutter: `MorningBrief` + `SectorAnalysis` models (Freezed)
- [x] Flutter: `MorningBriefDatasource` — fetch API + Hive cache 7 ngày
- [x] Flutter: `AiSummaryHeroCard`, `SectorCard`, `MorningBriefScreen` (Direction 6)
- [x] Fix CI: remove --esm flag, align với commonjs tsconfig
- [x] Upgrade model gpt-5.1 → gpt-5.4 (~$1.40/tháng)

### 2026-04-12 - Epic 3: Feedback & Accuracy ✅ DONE
- [x] Backend: `api/feedback.ts` — POST/GET feedback, auth, Firestore
- [x] Backend: `run-evaluate-accuracy.ts` — so sánh dự báo vs giá thực EOD
- [x] Flutter: `MorningBriefDatasource.submitFeedback()` + local Hive cache
- [x] Flutter: `feedbackProvider` (StateNotifier) per brief date
- [x] Flutter: `SectorCard` feedback row (👍👎) đã wire hoàn chỉnh

### 2026-04-12 - Epic 4: Push Notifications ✅ DONE
- [x] Backend: FCM multicast broadcast sau khi brief generate xong
- [x] Flutter: `firebase_messaging ^15.2.5` added
- [x] Flutter: `FcmService` — request permission, register token, handle tap → `/brief`
- [x] iOS: `Runner.entitlements` + Xcode build config wired
- [x] CÒN LẠI: Upload APNs key lên Firebase Console (cần renew Apple Dev membership $99/năm)

### 2026-04-12 - Epic 5: Premium & IAP ✅ DONE
- [x] Backend: `api/iap/verify.ts` — verify Apple receipt + Google Play token → update Firestore tier
- [x] Flutter: `in_app_purchase ^3.2.0` added
- [x] Flutter: `IapService` — load product, buy, restore, verify với backend
- [x] Flutter: `PaywallScreen` — dark UI, feature list, price từ Store, restore button
- [x] Flutter: Route `/paywall`, SectorCard locked tap → navigate paywall
- [x] Flutter: Graceful fallback khi IAP unavailable (simulator)
- [x] CÒN LẠI: Tạo subscription `ftrade_premium_monthly` trên App Store Connect + Google Play
- [x] CÒN LẠI: Thêm secrets `APPLE_SHARED_SECRET`, `GOOGLE_PLAY_SERVICE_ACCOUNT`

## Phase 4: Giao dịch (chưa bắt đầu)
- [ ] Tích hợp VNDirect API, vào lệnh tự động
