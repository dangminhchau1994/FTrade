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

### Known Issues
- [ ] BCTC (KQKD, CĐKT, LCTT) API: KBS API chết, VNDirect /financial_statements trả 500, TCBS 404. Đang tìm API thay thế (Vietstock finance cần session cookie). fundamental_api_datasource.dart đã rewrite sang VNDirect nhưng chưa hoạt động.
- [ ] Industry comparison: rewrite sang VNDirect stocks API, cần test lại

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
