import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/financial_statement.dart';
import '../../domain/entities/industry_comparison.dart';

/// Datasource BCTC & so sánh ngành - dùng VNDirect API
class FundamentalApiDatasource {
  FundamentalApiDatasource(this._dio);

  final Dio _dio;

  // VNDirect financial statements endpoint
  static const _financialStatementsUrl =
      '${ApiConstants.vndirectBase}/financial_statements';

  static const _incomeLineItems = {
    'Doanh thu thuần': 'NET_REVENUE',
    'Giá vốn hàng bán': 'COST_OF_GOODS_SOLD',
    'Lợi nhuận gộp': 'GROSS_PROFIT',
    'Chi phí bán hàng': 'SELLING_EXPENSES',
    'Chi phí quản lý': 'GENERAL_ADMIN_EXPENSES',
    'Chi phí tài chính': 'FINANCIAL_EXPENSES',
    'Lợi nhuận từ HĐKD': 'OPERATING_PROFIT',
    'Lợi nhuận trước thuế': 'PROFIT_BEFORE_TAX',
    'Lợi nhuận sau thuế': 'PROFIT_AFTER_TAX',
  };

  static const _balanceLineItems = {
    'Tổng tài sản': 'TOTAL_ASSETS',
    'Tài sản ngắn hạn': 'SHORT_TERM_ASSETS',
    'Tài sản dài hạn': 'LONG_TERM_ASSETS',
    'Tiền và tương đương tiền': 'CASH_AND_CASH_EQUIVALENTS',
    'Hàng tồn kho': 'INVENTORIES',
    'Nợ phải trả': 'TOTAL_LIABILITIES',
    'Nợ ngắn hạn': 'SHORT_TERM_LIABILITIES',
    'Nợ dài hạn': 'LONG_TERM_LIABILITIES',
    'Vốn chủ sở hữu': 'OWNER_EQUITY',
  };

  static const _cashFlowLineItems = {
    'Lưu chuyển tiền từ HĐKD': 'NET_CASH_FLOWS_FROM_OPERATING',
    'Lưu chuyển tiền từ HĐĐT': 'NET_CASH_FLOWS_FROM_INVESTING',
    'Lưu chuyển tiền từ HĐTC': 'NET_CASH_FLOWS_FROM_FINANCING',
    'Tăng/giảm tiền thuần': 'NET_CASH_FLOWS',
  };

  Future<List<FinancialStatement>> getIncomeStatements(String symbol) async {
    return _fetchStatements(
      symbol: symbol,
      reportType: 'IS',
      statementType: StatementType.incomeStatement,
      lineItems: _incomeLineItems,
    );
  }

  Future<List<FinancialStatement>> getBalanceSheets(String symbol) async {
    return _fetchStatements(
      symbol: symbol,
      reportType: 'BS',
      statementType: StatementType.balanceSheet,
      lineItems: _balanceLineItems,
    );
  }

  Future<List<FinancialStatement>> getCashFlows(String symbol) async {
    return _fetchStatements(
      symbol: symbol,
      reportType: 'CF',
      statementType: StatementType.cashFlow,
      lineItems: _cashFlowLineItems,
    );
  }

  Future<List<IndustryComparison>> getIndustryComparison(String symbol) async {
    final normalizedSymbol = symbol.toUpperCase();

    // Lấy thông tin ngành từ stock profile
    final stockInfo = await _fetchStockInfo(normalizedSymbol);
    final industryCode = stockInfo['industryCode'] as String? ?? '';
    final industryName = stockInfo['industry'] as String? ?? 'Khác';

    // Lấy danh sách cổ phiếu cùng ngành
    List<String> peerSymbols;
    if (industryCode.isNotEmpty) {
      peerSymbols = await _fetchIndustryPeers(industryCode);
    } else {
      peerSymbols = [normalizedSymbol];
    }

    // Đảm bảo symbol target nằm trong danh sách
    if (!peerSymbols.contains(normalizedSymbol)) {
      peerSymbols.add(normalizedSymbol);
    }

    // Lấy market cap để chọn top peers
    final marketCaps = await _fetchMarketCaps(peerSymbols);
    final selectedSymbols = _selectTopPeers(
      peerSymbols,
      normalizedSymbol,
      marketCaps,
    );

    // Lấy tên công ty và ratios
    final companyNames = await _fetchCompanyNames(selectedSymbols);
    final ratios = await _fetchRatios(selectedSymbols);

    return selectedSymbols.map((s) {
      final r = ratios[s] ?? const {};
      return IndustryComparison(
        symbol: s,
        companyName: companyNames[s] ?? s,
        industry: industryName,
        pe: _toDouble(r['pe']),
        pb: _toDouble(r['pb']),
        roe: _toDouble(r['roe']),
        roa: _toDouble(r['roa']),
        debtToEquity: _toDouble(r['debtToEquity']),
        marketCap: marketCaps[s] ?? 0,
        isTarget: s == normalizedSymbol,
      );
    }).toList()
      ..sort((a, b) => b.marketCap.compareTo(a.marketCap));
  }

  // --- Private: Financial Statements ---

  Future<List<FinancialStatement>> _fetchStatements({
    required String symbol,
    required String reportType,
    required StatementType statementType,
    required Map<String, String> lineItems,
  }) async {
    final itemCodes = lineItems.values.join(',');

    final response = await _dio.get(
      _financialStatementsUrl,
      queryParameters: {
        'q': 'code:${symbol.toUpperCase()}~reportType:$reportType~modelType:2',
        'sort': 'reportDate:desc',
        'size': 40,
        'filter': 'itemCode:$itemCodes',
      },
    );

    final data = response.data['data'] as List? ?? [];
    if (data.isEmpty) return [];

    // Group by reportDate
    final periodMap = <String, Map<String, double>>{};
    for (final row in data) {
      final item = row as Map<String, dynamic>;
      final reportDate = item['reportDate'] as String? ?? '';
      final fiscalDate = item['fiscalDate'] as String? ?? reportDate;
      final itemCode = item['itemCode'] as String? ?? '';
      final value = _toDouble(item['numericValue']) * 1e6; // API trả đơn vị triệu

      final period = _formatPeriod(fiscalDate, reportDate);
      periodMap.putIfAbsent(period, () => {});

      // Map itemCode → label tiếng Việt
      for (final entry in lineItems.entries) {
        if (entry.value == itemCode) {
          periodMap[period]![entry.key] = value;
          break;
        }
      }
    }

    // Sắp xếp theo thời gian mới nhất
    final sortedPeriods = periodMap.keys.toList()..sort((a, b) => b.compareTo(a));

    return sortedPeriods.take(8).map((period) {
      return FinancialStatement(
        symbol: symbol.toUpperCase(),
        period: period,
        type: statementType,
        items: periodMap[period]!,
      );
    }).toList();
  }

  String _formatPeriod(String fiscalDate, String reportDate) {
    // fiscalDate format: "YYYY-MM-DD"
    final date = fiscalDate.isNotEmpty ? fiscalDate : reportDate;
    if (date.length < 7) return date;

    final year = date.substring(0, 4);
    final month = int.tryParse(date.substring(5, 7)) ?? 0;

    final quarter = switch (month) {
      >= 1 && <= 3 => 'Q1',
      >= 4 && <= 6 => 'Q2',
      >= 7 && <= 9 => 'Q3',
      _ => 'Q4',
    };

    return '$quarter/$year';
  }

  // --- Private: Industry Comparison ---

  Future<Map<String, dynamic>> _fetchStockInfo(String symbol) async {
    try {
      final response = await _dio.get(
        ApiConstants.stocks,
        queryParameters: {
          'q': 'code:$symbol~type:STOCK',
          'size': 1,
        },
      );
      final data = response.data['data'] as List? ?? [];
      if (data.isNotEmpty) return Map<String, dynamic>.from(data.first as Map);
    } catch (_) {}
    return {};
  }

  Future<List<String>> _fetchIndustryPeers(String industryCode) async {
    try {
      final response = await _dio.get(
        ApiConstants.stocks,
        queryParameters: {
          'q': 'type:STOCK~status:listed~industryCode:$industryCode',
          'size': 100,
        },
      );
      final data = response.data['data'] as List? ?? [];
      return data
          .map((item) => ((item as Map)['code'] as String? ?? '').toUpperCase())
          .where((s) => s.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<Map<String, double>> _fetchMarketCaps(List<String> symbols) async {
    final caps = <String, double>{};
    for (final chunk in _chunk(symbols, 50)) {
      try {
        final response = await _dio.get(
          ApiConstants.ratios,
          queryParameters: {
            'filter': 'code:${chunk.join(",")}',
            'where': 'itemCode:${ApiConstants.ratioMarketCap}',
            'order': 'reportDate',
            'size': chunk.length,
          },
        );
        final data = response.data['data'] as List? ?? [];
        for (final item in data) {
          final row = item as Map<String, dynamic>;
          final code = (row['code'] as String? ?? '').toUpperCase();
          if (code.isNotEmpty) {
            caps[code] = _toDouble(row['value']) / 1e9;
          }
        }
      } catch (_) {}
    }
    return caps;
  }

  Future<Map<String, String>> _fetchCompanyNames(List<String> symbols) async {
    final names = <String, String>{};
    for (final chunk in _chunk(symbols, 50)) {
      try {
        final response = await _dio.get(
          ApiConstants.stocks,
          queryParameters: {
            'q': 'type:STOCK~status:listed~code:${chunk.join(",")}',
            'size': chunk.length,
          },
        );
        final data = response.data['data'] as List? ?? [];
        for (final item in data) {
          final row = item as Map<String, dynamic>;
          final code = (row['code'] as String? ?? '').toUpperCase();
          if (code.isNotEmpty) {
            names[code] = (row['companyName'] as String?) ?? code;
          }
        }
      } catch (_) {}
    }
    return names;
  }

  Future<Map<String, Map<String, double>>> _fetchRatios(
    List<String> symbols,
  ) async {
    final result = <String, Map<String, double>>{};
    final ratioCodes = [
      ApiConstants.ratioPE,
      ApiConstants.ratioPB,
    ];

    for (final chunk in _chunk(symbols, 20)) {
      try {
        final response = await _dio.get(
          ApiConstants.ratios,
          queryParameters: {
            'filter': 'code:${chunk.join(",")}',
            'where': 'itemCode:${ratioCodes.join(",")}',
            'order': 'reportDate',
            'size': chunk.length * ratioCodes.length,
          },
        );
        final data = response.data['data'] as List? ?? [];
        for (final item in data) {
          final row = item as Map<String, dynamic>;
          final code = (row['code'] as String? ?? '').toUpperCase();
          final itemCode = row['itemCode'] as String? ?? '';
          final value = _toDouble(row['value']);

          result.putIfAbsent(code, () => {});
          if (itemCode == ApiConstants.ratioPE) result[code]!['pe'] = value;
          if (itemCode == ApiConstants.ratioPB) result[code]!['pb'] = value;
        }
      } catch (_) {}
    }

    return result;
  }

  List<String> _selectTopPeers(
    List<String> symbols,
    String target,
    Map<String, double> marketCaps,
  ) {
    final sorted = [...symbols]
      ..sort((a, b) => (marketCaps[b] ?? 0).compareTo(marketCaps[a] ?? 0));

    final selected = sorted.take(10).toList();
    if (!selected.contains(target)) {
      if (selected.length >= 10) selected.removeLast();
      selected.add(target);
    }
    return selected;
  }

  Iterable<List<String>> _chunk(List<String> list, int size) sync* {
    for (var i = 0; i < list.length; i += size) {
      yield list.sublist(i, i + size > list.length ? list.length : i + size);
    }
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().replaceAll(',', '')) ?? 0;
  }
}
