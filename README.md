# FTrade

Tool phân tích thị trường chứng khoán Việt Nam - tổng hợp thông tin, phân tích kỹ thuật & cơ bản, theo dõi dòng tiền.

## Tính năng

### Tổng quan thị trường
- Dashboard chỉ số VN-Index, HNX-Index, UPCOM
- Market breadth (tăng/giảm/đứng giá)
- Top tăng giá, giảm giá, khối lượng giao dịch
- Tìm kiếm cổ phiếu

### Phân tích kỹ thuật (TA)
- Biểu đồ giá với 5 khung thời gian (1D, 1W, 1M, 3M, 1Y)
- RSI (14-period Wilder's) với ngưỡng 30/70
- MACD (12/26/9) - MACD line, Signal line, Histogram
- Moving Average: MA5, MA10, MA20, MA50
- Toggle indicator bằng FilterChip

### Phân tích cơ bản (FA)
- Báo cáo tài chính: KQKD, CĐKT, LCTT (4 quý)
- So sánh ngành: P/E, P/B, ROE, ROA, D/E, Vốn hóa
- Bảng dữ liệu sortable, scrollable

### Dòng tiền
- Tổng quan dòng tiền nước ngoài (mua/bán/ròng)
- Biểu đồ mua bán ròng 10 phiên gần nhất
- Top 10 mã mua ròng & bán ròng

### Doanh nghiệp
- Lịch cổ tức: GDKHQ, ngày thanh toán, tỷ lệ
- Sự kiện: ĐHCĐ, KQKD, phát hành, chốt quyền
- Giao dịch nội bộ & tự doanh CTCK

### Tin tức
- Tin tức thị trường & doanh nghiệp
- Liên kết mã cổ phiếu liên quan

### Watchlist & Cảnh báo
- Theo dõi danh sách cổ phiếu yêu thích
- Cảnh báo giá (vượt/dưới mức target)
- Lưu trữ cục bộ với Hive

## Tech Stack

- **Framework:** Flutter (cross-platform)
- **State Management:** Riverpod
- **Routing:** GoRouter
- **Data Models:** Freezed + JSON Serializable
- **Charts:** fl_chart
- **Local Storage:** Hive
- **HTTP Client:** Dio
- **Theme:** Material 3 (Dark/Light mode)

## Nguồn dữ liệu

- **Vietstock** - Dữ liệu thị trường
- **VNDirect** - Thông tin giao dịch

> Hiện tại sử dụng mock data. Tích hợp API thật trong các phase tiếp theo.

## Cấu trúc dự án

```
lib/
├── core/                    # Shared utilities
│   ├── constants/           # API & app constants
│   ├── error/               # Exception & failure handling
│   ├── network/             # Dio HTTP client
│   ├── router/              # GoRouter config
│   ├── storage/             # Hive initialization
│   ├── theme/               # Material 3 themes
│   ├── utils/               # Format utilities
│   └── widgets/             # Reusable widgets
└── features/                # Feature modules (Clean Architecture)
    ├── home/                # Dashboard
    ├── market/              # Market data & stock detail & TA charts
    ├── news/                # News feed
    ├── watchlist/           # Watchlist & price alerts
    ├── corporate/           # Dividends, events, insider trades
    ├── money_flow/          # Foreign flow & rankings
    ├── fundamental/         # Financial statements & industry comparison
    └── settings/            # App settings
```

## Chạy project

```bash
# Cài dependencies
flutter pub get

# Generate Freezed code
dart run build_runner build --delete-conflicting-outputs

# Chạy app
flutter run
```

## Roadmap

- [x] **Phase 1** - Nền tảng dữ liệu (tin tức, giá, khối lượng)
- [x] **Phase 2** - Phân tích & cảnh báo (TA indicators, watchlist, alerts)
- [ ] **Phase 3** - Nhận định thông minh (AI recommendation)
- [ ] **Phase 4** - Tích hợp VNDirect API, giao dịch tự động
