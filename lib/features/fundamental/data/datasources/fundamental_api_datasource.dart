import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/financial_statement.dart';
import '../../domain/entities/industry_comparison.dart';

/// Datasource BCTC & so sánh ngành - dùng VNDirect API
///
/// VNDirect financial_statements API:
/// - reportType: QUARTER = quý đơn lẻ (hợp nhất), ANNUAL = cả năm (hợp nhất)
///   QUARTER2/ANNUAL2 = công ty mẹ
/// - modelType: 1=BS (Cân đối kế toán), 2=IS (Kết quả kinh doanh), 3=CF (Lưu chuyển tiền tệ)
/// - itemCode theo mã số trên BCTC chuẩn VAS (Thông tư 200)
/// - Giá trị đơn vị: đồng
class FundamentalApiDatasource {
  FundamentalApiDatasource(this._dio);

  final Dio _dio;

  // IS - Income Statement (modelType 2)
  // itemCode theo mã số BCKQKD chuẩn VAS
  static const _incomeLineItems = {
    'Doanh thu thuần': 21001,
    'Giá vốn hàng bán': 22100,
    'Lợi nhuận gộp': 23100,
    'Chi phí tài chính': 22051,
    'Chi phí bán hàng': 22200,
    'Chi phí quản lý': 22500,
    'Lợi nhuận từ HĐKD': 23110,
    'Lợi nhuận trước thuế': 23800,
    'Lợi nhuận sau thuế': 23003,
  };

  // BS - Balance Sheet (modelType 1)
  // itemCode theo mã số BCĐKT chuẩn VAS
  static const _balanceLineItems = {
    'Tổng tài sản': 12700,
    'Tài sản ngắn hạn': 11000,
    'Tài sản dài hạn': 12000,
    'Tiền và tương đương tiền': 11100,
    'Hàng tồn kho': 11400,
    'Nợ phải trả': 13000,
    'Nợ ngắn hạn': 13100,
    'Nợ dài hạn': 13300,
    'Vốn chủ sở hữu': 14000,
  };

  // CF - Cash Flow (modelType 3)
  static const _cashFlowLineItems = {
    'Lưu chuyển tiền từ HĐKD': 32000,
    'Lưu chuyển tiền từ HĐĐT': 33000,
    'Lưu chuyển tiền từ HĐTC': 34000,
    'Tăng/giảm tiền thuần': 35000,
  };

  Future<List<FinancialStatement>> getIncomeStatements(String symbol) async {
    return _fetchStatements(
      symbol: symbol,
      modelType: 2,
      statementType: StatementType.incomeStatement,
      lineItems: _incomeLineItems,
    );
  }

  Future<List<FinancialStatement>> getBalanceSheets(String symbol) async {
    return _fetchStatements(
      symbol: symbol,
      modelType: 1,
      statementType: StatementType.balanceSheet,
      lineItems: _balanceLineItems,
    );
  }

  Future<List<FinancialStatement>> getCashFlows(String symbol) async {
    return _fetchStatements(
      symbol: symbol,
      modelType: 3,
      statementType: StatementType.cashFlow,
      lineItems: _cashFlowLineItems,
    );
  }

  Future<List<IndustryComparison>> getIndustryComparison(String symbol) async {
    final normalizedSymbol = symbol.toUpperCase();

    final stockInfo = await _fetchStockInfo(normalizedSymbol);
    final industryCode = stockInfo['industryCode'] as String? ?? '';
    final industryName = stockInfo['industry'] as String? ?? 'Khác';

    List<String> peerSymbols;
    if (industryCode.isNotEmpty) {
      peerSymbols = await _fetchIndustryPeers(industryCode);
    } else {
      peerSymbols = [normalizedSymbol];
    }

    if (!peerSymbols.contains(normalizedSymbol)) {
      peerSymbols.add(normalizedSymbol);
    }

    final marketCaps = await _fetchMarketCaps(peerSymbols);
    final selectedSymbols = _selectTopPeers(
      peerSymbols,
      normalizedSymbol,
      marketCaps,
    );

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
    required int modelType,
    required StatementType statementType,
    required Map<String, int> lineItems,
  }) async {
    final itemCodeFilter = lineItems.values.join(',');
    final upperSymbol = symbol.toUpperCase();

    // reportType=QUARTER → quý đơn lẻ, số liệu hợp nhất
    final response = await _dio.get(
      ApiConstants.financialStatements,
      queryParameters: {
        'q': 'code:$upperSymbol~reportType:QUARTER~modelType:$modelType',
        'filter': 'itemCode:$itemCodeFilter',
        'sort': 'fiscalDate:desc',
        'size': 500,
      },
    );

    final data = response.data['data'] as List? ?? [];
    if (data.isEmpty) return [];

    // Group by fiscalDate
    final periodMap = <String, Map<String, double>>{};
    for (final row in data) {
      final item = row as Map<String, dynamic>;
      final fiscalDate = item['fiscalDate'] as String? ?? '';
      final rawItemCode = item['itemCode'];
      final itemCode =
          rawItemCode is num ? rawItemCode.toInt() : int.tryParse('$rawItemCode') ?? 0;
      final value = _toDouble(item['numericValue']); // Đơn vị: đồng

      final period = _formatPeriod(fiscalDate);
      periodMap.putIfAbsent(period, () => {});

      for (final entry in lineItems.entries) {
        if (entry.value == itemCode) {
          periodMap[period]![entry.key] = value;
          break;
        }
      }
    }

    final sortedPeriods = periodMap.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return sortedPeriods.take(8).map((period) {
      return FinancialStatement(
        symbol: upperSymbol,
        period: period,
        type: statementType,
        items: periodMap[period]!,
      );
    }).toList();
  }

  String _formatPeriod(String fiscalDate) {
    if (fiscalDate.length < 7) return fiscalDate;

    final year = fiscalDate.substring(0, 4);
    final month = int.tryParse(fiscalDate.substring(5, 7)) ?? 0;

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
        final codes = chunk.join(',');
        final response = await _dio.get(
          ApiConstants.ratios,
          queryParameters: {
            'q': 'code:$codes~itemCode:${ApiConstants.ratioMarketCap}',
            'sort': 'reportDate:desc',
            'size': chunk.length,
          },
        );
        final data = response.data['data'] as List? ?? [];
        for (final item in data) {
          final row = item as Map<String, dynamic>;
          final code = (row['code'] as String? ?? '').toUpperCase();
          if (code.isNotEmpty && !caps.containsKey(code)) {
            caps[code] = _toDouble(row['value']) / 1e9; // Đổi sang tỷ đồng
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

    // ── PE, PB từ /ratios ─────────────────────────────────────────────────────
    for (final chunk in _chunk(symbols, 20)) {
      final codes = chunk.join(',');
      for (final ratioCode in [ApiConstants.ratioPE, ApiConstants.ratioPB]) {
        try {
          final response = await _dio.get(
            ApiConstants.ratios,
            queryParameters: {
              'q': 'code:$codes~itemCode:$ratioCode',
              'sort': 'reportDate:desc',
              'size': chunk.length,
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
    }

    // ── ROE, ROA, D/E tính từ financial_statements ────────────────────────────
    // ROE = TTM LNST / Vốn CSH
    // ROA = TTM LNST / Tổng tài sản
    // D/E = Nợ phải trả / Vốn CSH
    for (final chunk in _chunk(symbols, 20)) {
      final codes = chunk.join(',');

      // BS: Tổng tài sản (12700), Nợ phải trả (13000), Vốn CSH (14000)
      final bsFuture = _dio.get(
        ApiConstants.financialStatements,
        queryParameters: {
          'q': 'code:$codes~reportType:QUARTER~modelType:1~itemCode:12700,13000,14000',
          'sort': 'fiscalDate:desc',
          'size': chunk.length * 3,
        },
      );

      // IS: LNST (23003) — lấy 4 quý gần nhất để tính TTM
      final isFuture = _dio.get(
        ApiConstants.financialStatements,
        queryParameters: {
          'q': 'code:$codes~reportType:QUARTER~modelType:2~itemCode:23003',
          'sort': 'fiscalDate:desc',
          'size': chunk.length * 4,
        },
      );

      try {
        final responses = await Future.wait([bsFuture, isFuture]);

        // Parse BS — lấy giá trị mới nhất của mỗi itemCode
        final bsData = responses[0].data['data'] as List? ?? [];
        final bs = <String, Map<int, double>>{};
        for (final item in bsData) {
          final row = item as Map<String, dynamic>;
          final code = (row['code'] as String? ?? '').toUpperCase();
          final itemCode = (row['itemCode'] as num).toInt();
          final value = _toDouble(row['numericValue']);
          bs.putIfAbsent(code, () => {});
          bs[code]!.putIfAbsent(itemCode, () => value); // giữ giá trị mới nhất
        }

        // Parse IS — cộng dồn LNST 4 quý gần nhất (TTM)
        final isData = responses[1].data['data'] as List? ?? [];
        final lnstByCode = <String, List<double>>{};
        for (final item in isData) {
          final row = item as Map<String, dynamic>;
          final code = (row['code'] as String? ?? '').toUpperCase();
          final value = _toDouble(row['numericValue']);
          lnstByCode.putIfAbsent(code, () => []);
          if (lnstByCode[code]!.length < 4) lnstByCode[code]!.add(value);
        }

        for (final code in chunk) {
          final bsMap = bs[code] ?? {};
          final totalAssets = bsMap[12700] ?? 0;
          final totalDebt = bsMap[13000] ?? 0;
          final equity = bsMap[14000] ?? 0;
          final ttmLnst = lnstByCode[code]?.fold(0.0, (a, b) => a + b) ?? 0;

          result.putIfAbsent(code, () => {});
          if (equity > 0) {
            result[code]!['roe'] = ttmLnst / equity * 100; // %
            result[code]!['debtToEquity'] = totalDebt / equity;
          }
          if (totalAssets > 0) {
            result[code]!['roa'] = ttmLnst / totalAssets * 100; // %
          }
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
