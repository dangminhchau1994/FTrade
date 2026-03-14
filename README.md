# FTrade

A Vietnamese stock market analysis tool — aggregating market data, technical & fundamental analysis, and money flow tracking.

## Features

### Market Overview
- Dashboard with VN-Index, HNX-Index, UPCOM indices
- Market breadth (advances/declines/unchanged)
- Top gainers, losers, and most active by volume
- Stock search

### Technical Analysis (TA)
- Price chart with 5 timeframes (1D, 1W, 1M, 3M, 1Y)
- RSI (14-period Wilder's) with 30/70 thresholds
- MACD (12/26/9) — MACD line, Signal line, Histogram
- Moving Averages: MA5, MA10, MA20, MA50
- Toggle indicators with FilterChip UI

### Fundamental Analysis (FA)
- Financial statements: Income Statement, Balance Sheet, Cash Flow (4 quarters)
- Industry comparison: P/E, P/B, ROE, ROA, D/E, Market Cap
- Sortable, scrollable data tables

### Money Flow
- Foreign investor flow summary (buy/sell/net)
- Net buy/sell bar chart for the last 10 sessions
- Top 10 net buyers & sellers ranking

### Corporate Data
- Dividend calendar: ex-date, payment date, ratio
- Events: AGM, earnings reports, rights issues
- Insider & proprietary trading activity

### News
- Market & corporate news feed
- Related stock symbol linking

### Watchlist & Alerts
- Track favorite stocks
- Price alerts (above/below target)
- Local persistence with Hive

## Tech Stack

- **Framework:** Flutter (cross-platform)
- **State Management:** Riverpod
- **Routing:** GoRouter
- **Data Models:** Freezed + JSON Serializable
- **Charts:** fl_chart
- **Local Storage:** Hive
- **HTTP Client:** Dio
- **Theme:** Material 3 (Dark/Light mode)

## Data Sources

- **Vietstock** — Market data
- **VNDirect** — Trading information

> Currently using mock data. Real API integration planned for upcoming phases.

## Project Structure

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
    ├── market/              # Market data, stock detail & TA charts
    ├── news/                # News feed
    ├── watchlist/           # Watchlist & price alerts
    ├── corporate/           # Dividends, events, insider trades
    ├── money_flow/          # Foreign flow & rankings
    ├── fundamental/         # Financial statements & industry comparison
    └── settings/            # App settings
```

## Getting Started

```bash
# Install dependencies
flutter pub get

# Generate Freezed code
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## Roadmap

- [x] **Phase 1** — Data foundation (news, price, volume)
- [x] **Phase 2** — Analysis & alerts (TA indicators, watchlist, alerts)
- [ ] **Phase 3** — Smart insights (AI recommendations)
- [ ] **Phase 4** — VNDirect API integration & auto-trading

## Contributors

- [@dangminhchau1994](https://github.com/dangminhchau1994)
