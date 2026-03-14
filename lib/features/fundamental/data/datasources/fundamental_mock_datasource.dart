import '../../domain/entities/financial_statement.dart';
import '../../domain/entities/industry_comparison.dart';

class FundamentalMockDatasource {
  Future<List<FinancialStatement>> getIncomeStatements(String symbol) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final base = _baseRevenue(symbol);
    return [
      _incomeStatement(symbol, 'Q4/2024', base),
      _incomeStatement(symbol, 'Q3/2024', base * 0.95),
      _incomeStatement(symbol, 'Q2/2024', base * 0.92),
      _incomeStatement(symbol, 'Q1/2024', base * 0.88),
    ];
  }

  Future<List<FinancialStatement>> getBalanceSheets(String symbol) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final base = _baseAssets(symbol);
    return [
      _balanceSheet(symbol, 'Q4/2024', base),
      _balanceSheet(symbol, 'Q3/2024', base * 0.98),
      _balanceSheet(symbol, 'Q2/2024', base * 0.95),
      _balanceSheet(symbol, 'Q1/2024', base * 0.93),
    ];
  }

  Future<List<FinancialStatement>> getCashFlows(String symbol) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final base = _baseRevenue(symbol) * 0.15;
    return [
      _cashFlow(symbol, 'Q4/2024', base),
      _cashFlow(symbol, 'Q3/2024', base * 0.9),
      _cashFlow(symbol, 'Q2/2024', base * 0.85),
      _cashFlow(symbol, 'Q1/2024', base * 0.8),
    ];
  }

  Future<List<IndustryComparison>> getIndustryComparison(String symbol) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final industry = _industryOf(symbol);
    return _industryPeers[industry]!.map((peer) {
      return peer.copyWith(isTarget: peer.symbol == symbol);
    }).toList();
  }

  double _baseRevenue(String symbol) {
    const map = {
      'FPT': 15000e9, 'VNM': 15500e9, 'HPG': 35000e9,
      'TCB': 8000e9, 'VCB': 12000e9, 'MBB': 7000e9,
    };
    return map[symbol] ?? 10000e9;
  }

  double _baseAssets(String symbol) {
    const map = {
      'FPT': 65000e9, 'VNM': 50000e9, 'HPG': 150000e9,
      'TCB': 800000e9, 'VCB': 1800000e9, 'MBB': 700000e9,
    };
    return map[symbol] ?? 80000e9;
  }

  String _industryOf(String symbol) {
    const map = {
      'FPT': 'tech', 'CMG': 'tech', 'CTR': 'tech', 'ELC': 'tech',
      'VNM': 'consumer', 'MSN': 'consumer', 'SAB': 'consumer',
      'HPG': 'steel', 'NKG': 'steel', 'HSG': 'steel',
      'TCB': 'bank', 'VCB': 'bank', 'MBB': 'bank', 'ACB': 'bank',
    };
    return map[symbol] ?? 'general';
  }

  FinancialStatement _incomeStatement(String symbol, String period, double revenue) {
    return FinancialStatement(
      symbol: symbol,
      period: period,
      type: StatementType.incomeStatement,
      items: {
        'Doanh thu thuần': revenue,
        'Giá vốn hàng bán': -revenue * 0.65,
        'Lợi nhuận gộp': revenue * 0.35,
        'Chi phí bán hàng': -revenue * 0.08,
        'Chi phí quản lý': -revenue * 0.05,
        'Chi phí tài chính': -revenue * 0.03,
        'Lợi nhuận từ HĐKD': revenue * 0.19,
        'Lợi nhuận trước thuế': revenue * 0.18,
        'Lợi nhuận sau thuế': revenue * 0.145,
      },
    );
  }

  FinancialStatement _balanceSheet(String symbol, String period, double totalAssets) {
    return FinancialStatement(
      symbol: symbol,
      period: period,
      type: StatementType.balanceSheet,
      items: {
        'Tổng tài sản': totalAssets,
        'Tài sản ngắn hạn': totalAssets * 0.4,
        'Tài sản dài hạn': totalAssets * 0.6,
        'Tiền và tương đương tiền': totalAssets * 0.08,
        'Hàng tồn kho': totalAssets * 0.15,
        'Nợ phải trả': totalAssets * 0.55,
        'Nợ ngắn hạn': totalAssets * 0.3,
        'Nợ dài hạn': totalAssets * 0.25,
        'Vốn chủ sở hữu': totalAssets * 0.45,
      },
    );
  }

  FinancialStatement _cashFlow(String symbol, String period, double operating) {
    return FinancialStatement(
      symbol: symbol,
      period: period,
      type: StatementType.cashFlow,
      items: {
        'Lưu chuyển tiền từ HĐKD': operating,
        'Lưu chuyển tiền từ HĐĐT': -operating * 0.6,
        'Lưu chuyển tiền từ HĐTC': -operating * 0.2,
        'Tăng/giảm tiền thuần': operating * 0.2,
      },
    );
  }

  static final _industryPeers = {
    'tech': [
      IndustryComparison(symbol: 'FPT', companyName: 'FPT Corporation', industry: 'Công nghệ', pe: 22.5, pb: 4.8, roe: 21.3, roa: 8.5, debtToEquity: 0.45, marketCap: 155000, isTarget: false),
      IndustryComparison(symbol: 'CMG', companyName: 'CMC Corporation', industry: 'Công nghệ', pe: 18.2, pb: 2.1, roe: 15.6, roa: 6.2, debtToEquity: 0.55, marketCap: 8500, isTarget: false),
      IndustryComparison(symbol: 'CTR', companyName: 'Viettel Construction', industry: 'Công nghệ', pe: 12.8, pb: 2.5, roe: 19.5, roa: 7.8, debtToEquity: 0.62, marketCap: 12000, isTarget: false),
      IndustryComparison(symbol: 'ELC', companyName: 'Elcom Corporation', industry: 'Công nghệ', pe: 15.3, pb: 1.8, roe: 12.1, roa: 5.5, debtToEquity: 0.38, marketCap: 3500, isTarget: false),
    ],
    'consumer': [
      IndustryComparison(symbol: 'VNM', companyName: 'Vinamilk', industry: 'Tiêu dùng', pe: 16.5, pb: 4.2, roe: 25.4, roa: 18.2, debtToEquity: 0.22, marketCap: 175000, isTarget: false),
      IndustryComparison(symbol: 'MSN', companyName: 'Masan Group', industry: 'Tiêu dùng', pe: 25.8, pb: 3.5, roe: 13.6, roa: 4.8, debtToEquity: 1.15, marketCap: 92000, isTarget: false),
      IndustryComparison(symbol: 'SAB', companyName: 'Sabeco', industry: 'Tiêu dùng', pe: 28.3, pb: 6.8, roe: 24.1, roa: 16.5, debtToEquity: 0.18, marketCap: 105000, isTarget: false),
    ],
    'steel': [
      IndustryComparison(symbol: 'HPG', companyName: 'Hòa Phát Group', industry: 'Thép', pe: 10.2, pb: 1.4, roe: 13.8, roa: 5.2, debtToEquity: 0.85, marketCap: 120000, isTarget: false),
      IndustryComparison(symbol: 'NKG', companyName: 'Nam Kim Steel', industry: 'Thép', pe: 8.5, pb: 1.1, roe: 12.9, roa: 4.8, debtToEquity: 1.2, marketCap: 8000, isTarget: false),
      IndustryComparison(symbol: 'HSG', companyName: 'Hoa Sen Group', industry: 'Thép', pe: 9.8, pb: 1.0, roe: 10.2, roa: 3.5, debtToEquity: 1.45, marketCap: 9500, isTarget: false),
    ],
    'bank': [
      IndustryComparison(symbol: 'VCB', companyName: 'Vietcombank', industry: 'Ngân hàng', pe: 14.5, pb: 3.2, roe: 22.1, roa: 1.8, debtToEquity: 11.5, marketCap: 480000, isTarget: false),
      IndustryComparison(symbol: 'TCB', companyName: 'Techcombank', industry: 'Ngân hàng', pe: 9.8, pb: 1.5, roe: 17.8, roa: 2.5, debtToEquity: 6.2, marketCap: 125000, isTarget: false),
      IndustryComparison(symbol: 'MBB', companyName: 'MB Bank', industry: 'Ngân hàng', pe: 7.5, pb: 1.3, roe: 20.5, roa: 2.1, debtToEquity: 8.8, marketCap: 95000, isTarget: false),
      IndustryComparison(symbol: 'ACB', companyName: 'Asia Commercial Bank', industry: 'Ngân hàng', pe: 8.2, pb: 1.6, roe: 23.5, roa: 2.3, debtToEquity: 9.2, marketCap: 85000, isTarget: false),
    ],
    'general': [
      IndustryComparison(symbol: 'VIC', companyName: 'Vingroup', industry: 'Đa ngành', pe: 45.2, pb: 2.8, roe: 6.2, roa: 1.5, debtToEquity: 2.8, marketCap: 210000, isTarget: false),
      IndustryComparison(symbol: 'VHM', companyName: 'Vinhomes', industry: 'Đa ngành', pe: 12.5, pb: 2.1, roe: 16.8, roa: 8.2, debtToEquity: 0.95, marketCap: 180000, isTarget: false),
    ],
  };
}
