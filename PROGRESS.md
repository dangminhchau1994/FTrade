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

## Phase 2: Phân tích & cảnh báo (chưa bắt đầu)
- [ ] Watchlist tự động + cảnh báo tín hiệu
- [ ] Phát hiện dòng tiền bất thường, GD nội bộ/tự doanh/cá mập
- [ ] Phân tích TA cơ bản

## Phase 3: Nhận định thông minh (chưa bắt đầu)
- [ ] Phân tích FA doanh nghiệp
- [ ] Nhận định vĩ mô & dự đoán rủi ro
- [ ] AI recommendation

## Phase 4: Giao dịch (chưa bắt đầu)
- [ ] Tích hợp VNDirect API, vào lệnh tự động
