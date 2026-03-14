import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/financial_statement.dart';
import '../../domain/entities/industry_comparison.dart';

class FundamentalApiDatasource {
  FundamentalApiDatasource(this._dio);

  final Dio _dio;

  final Map<int, Future<List<String>>> _sectorSymbolsCache = {};
  final Map<String, Future<_IndustryContext?>> _industryCache = {};
  final Map<String, Future<_PeerMetrics>> _peerMetricCache = {};

  static const Map<String, List<String>> _incomeLinePatterns = {
    'Doanh thu thuần': ['Doanh thu thuần về bán hàng và cung cấp dịch vụ'],
    'Giá vốn hàng bán': ['Giá vốn hàng bán'],
    'Lợi nhuận gộp': ['Lợi nhuận gộp về bán hàng và cung cấp dịch vụ'],
    'Chi phí bán hàng': ['Chi phí bán hàng'],
    'Chi phí quản lý': ['Chi phí quản lý doanh nghiệp'],
    'Chi phí tài chính': ['Chi phí tài chính'],
    'Lợi nhuận từ HĐKD': ['Lợi nhuận thuần từ hoạt động kinh doanh'],
    'Lợi nhuận trước thuế': ['Tổng lợi nhuận kế toán trước thuế'],
    'Lợi nhuận sau thuế': ['Lợi nhuận sau thuế thu nhập doanh nghiệp'],
  };

  static const Map<String, List<String>> _balanceLinePatterns = {
    'Tổng tài sản': ['TỔNG CỘNG TÀI SẢN'],
    'Tài sản ngắn hạn': ['A. TÀI SẢN NGẮN HẠN'],
    'Tài sản dài hạn': ['B. TÀI SẢN DÀI HẠN'],
    'Tiền và tương đương tiền': ['Tiền và các khoản tương đương tiền'],
    'Hàng tồn kho': ['IV. Hàng tồn kho'],
    'Nợ phải trả': ['A. NỢ PHẢI TRẢ'],
    'Nợ ngắn hạn': ['I. Nợ ngắn hạn'],
    'Nợ dài hạn': ['II. Nợ dài hạn'],
    'Vốn chủ sở hữu': ['B. VỐN CHỦ SỞ HỮU'],
  };

  static const Map<String, List<String>> _cashFlowLinePatterns = {
    'Lưu chuyển tiền từ HĐKD': [
      'Lưu chuyển tiền thuần từ hoạt động kinh doanh',
    ],
    'Lưu chuyển tiền từ HĐĐT': ['Lưu chuyển tiền thuần từ hoạt động đầu tư'],
    'Lưu chuyển tiền từ HĐTC': ['Lưu chuyển tiền thuần từ hoạt động tài chính'],
    'Tăng/giảm tiền thuần': ['Lưu chuyển tiền thuần trong kỳ'],
  };

  static const _negativeIncomeLabels = {
    'Giá vốn hàng bán',
    'Chi phí bán hàng',
    'Chi phí quản lý',
    'Chi phí tài chính',
  };

  Future<List<FinancialStatement>> getIncomeStatements(String symbol) async {
    final data = await _fetchFinanceInfo(
      symbol: symbol,
      reportType: 'KQKD',
      periodType: 2,
    );

    final rows = _extractRows(data, 'Kết quả kinh doanh');
    return _buildStatements(
      symbol: symbol,
      type: StatementType.incomeStatement,
      periods: _extractPeriods(data['Head'] as List? ?? const []),
      rows: rows,
      linePatterns: _incomeLinePatterns,
      negativeLabels: _negativeIncomeLabels,
    );
  }

  Future<List<FinancialStatement>> getBalanceSheets(String symbol) async {
    final data = await _fetchFinanceInfo(
      symbol: symbol,
      reportType: 'CDKT',
      periodType: 2,
    );

    final rows = _extractRows(data, 'Cân đối kế toán');
    return _buildStatements(
      symbol: symbol,
      type: StatementType.balanceSheet,
      periods: _extractPeriods(data['Head'] as List? ?? const []),
      rows: rows,
      linePatterns: _balanceLinePatterns,
    );
  }

  Future<List<FinancialStatement>> getCashFlows(String symbol) async {
    final data = await _fetchFinanceInfo(
      symbol: symbol,
      reportType: 'LCTT',
      periodType: 1,
    );

    final content = data['Content'] as Map<String, dynamic>? ?? const {};
    final reportKey =
        content.containsKey('Lưu chuyển tiền tệ gián tiếp')
            ? 'Lưu chuyển tiền tệ gián tiếp'
            : 'Lưu chuyển tiền tệ trực tiếp';
    final rows = _extractRows(data, reportKey);

    return _buildStatements(
      symbol: symbol,
      type: StatementType.cashFlow,
      periods: _extractPeriods(data['Head'] as List? ?? const []),
      rows: rows,
      linePatterns: _cashFlowLinePatterns,
    );
  }

  Future<List<IndustryComparison>> getIndustryComparison(String symbol) async {
    final normalizedSymbol = symbol.toUpperCase();
    final industry = await _resolveIndustry(normalizedSymbol);
    final industryName = industry?.name ?? 'Khác';
    final sectorSymbols = industry?.symbols ?? [normalizedSymbol];
    final allSymbols = _dedupeSymbols([...sectorSymbols, normalizedSymbol]);

    final marketCaps = await _fetchMarketCaps(allSymbols);
    final selectedSymbols = _selectPeerSymbols(
      allSymbols,
      normalizedSymbol,
      marketCaps,
    );
    final companyNames = await _fetchCompanyNames(selectedSymbols);
    final metrics = await Future.wait(selectedSymbols.map(_getPeerMetrics));

    final comparisons = <IndustryComparison>[];
    for (var index = 0; index < selectedSymbols.length; index++) {
      final peerSymbol = selectedSymbols[index];
      final peerMetrics = metrics[index];
      comparisons.add(
        IndustryComparison(
          symbol: peerSymbol,
          companyName:
              companyNames[peerSymbol] ??
              companyNames[normalizedSymbol] ??
              peerSymbol,
          industry: industryName,
          pe: peerMetrics.pe,
          pb: peerMetrics.pb,
          roe: peerMetrics.roe,
          roa: peerMetrics.roa,
          debtToEquity: peerMetrics.debtToEquity,
          marketCap: marketCaps[peerSymbol] ?? 0,
          isTarget: peerSymbol == normalizedSymbol,
        ),
      );
    }

    comparisons.sort((a, b) => b.marketCap.compareTo(a.marketCap));
    return comparisons;
  }

  Future<Map<String, dynamic>> _fetchFinanceInfo({
    required String symbol,
    required String reportType,
    required int periodType,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': 1,
      'pageSize': 8,
      'type': reportType,
      'unit': 1000,
      'termtype': periodType,
    };

    if (reportType == 'LCTT') {
      queryParameters['code'] = symbol.toUpperCase();
      queryParameters['termType'] = periodType;
    } else {
      queryParameters['languageid'] = 1;
    }

    final response = await _dio.get(
      '${ApiConstants.kbsFinanceInfo}/${symbol.toUpperCase()}',
      queryParameters: queryParameters,
      options: Options(headers: {'User-Agent': 'Mozilla/5.0'}),
    );

    return Map<String, dynamic>.from(response.data as Map);
  }

  List<FinancialStatement> _buildStatements({
    required String symbol,
    required StatementType type,
    required List<String> periods,
    required List<Map<String, dynamic>> rows,
    required Map<String, List<String>> linePatterns,
    Set<String> negativeLabels = const {},
  }) {
    if (periods.isEmpty || rows.isEmpty) {
      return [];
    }

    return List.generate(periods.length, (index) {
      final columnKey = 'Value${index + 1}';
      final items = <String, double>{};

      for (final entry in linePatterns.entries) {
        var value = _extractStatementValue(rows, columnKey, entry.value);
        if (entry.key == 'Tài sản dài hạn' && value == 0) {
          value =
              (items['Tổng tài sản'] ?? 0) - (items['Tài sản ngắn hạn'] ?? 0);
        }
        if (negativeLabels.contains(entry.key)) {
          value = -value.abs();
        }
        items[entry.key] = value;
      }

      return FinancialStatement(
        symbol: symbol.toUpperCase(),
        period: periods[index],
        type: type,
        items: items,
      );
    });
  }

  List<Map<String, dynamic>> _extractRows(
    Map<String, dynamic> data,
    String key,
  ) {
    final content = data['Content'] as Map<String, dynamic>? ?? const {};
    final rows = content[key] as List? ?? const [];
    return rows.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  List<String> _extractPeriods(List heads) {
    return heads.map<String>((item) {
      final head = Map<String, dynamic>.from(item as Map);
      final year = head['YearPeriod']?.toString() ?? '';
      final termName = head['TermName']?.toString() ?? '';

      if (termName.contains('Quý')) {
        final quarter = termName.replaceAll('Quý', '').trim();
        return 'Q$quarter/$year';
      }
      return year;
    }).toList();
  }

  double _extractStatementValue(
    List<Map<String, dynamic>> rows,
    String columnKey,
    List<String> patterns,
  ) {
    for (final row in rows) {
      final name = (row['Name'] as String? ?? '').toLowerCase();
      if (!patterns.any((pattern) => name.contains(pattern.toLowerCase()))) {
        continue;
      }

      final raw = row[columnKey];
      return _toDouble(raw) * 1000;
    }

    return 0;
  }

  Future<_IndustryContext?> _resolveIndustry(String symbol) {
    return _industryCache.putIfAbsent(symbol, () async {
      final response = await _dio.get(
        ApiConstants.kbsSectorAll,
        options: Options(headers: {'User-Agent': 'Mozilla/5.0'}),
      );

      final sectors = response.data as List? ?? const [];
      for (final item in sectors) {
        final sector = Map<String, dynamic>.from(item as Map);
        final code = _toInt(sector['code']);
        final symbols = await _getSectorSymbols(code);
        if (!symbols.contains(symbol)) {
          continue;
        }

        return _IndustryContext(
          code: code,
          name: sector['name'] as String? ?? 'Khác',
          symbols: symbols,
        );
      }

      return null;
    });
  }

  Future<List<String>> _getSectorSymbols(int sectorCode) {
    return _sectorSymbolsCache.putIfAbsent(sectorCode, () async {
      final response = await _dio.get(
        ApiConstants.kbsSectorStock,
        queryParameters: {'code': sectorCode, 'l': 1},
        options: Options(headers: {'User-Agent': 'Mozilla/5.0'}),
      );

      final payload = response.data;
      if (payload is Map<String, dynamic> && payload['stocks'] is List) {
        return (payload['stocks'] as List)
            .map((item) => ((item as Map)['sb'] as String? ?? '').toUpperCase())
            .where((symbol) => symbol.isNotEmpty)
            .toList();
      }
      if (payload is Map<String, dynamic> && payload['data'] is List) {
        return (payload['data'] as List)
            .map((item) => item.toString().toUpperCase())
            .where((symbol) => symbol.isNotEmpty)
            .toList();
      }
      if (payload is List) {
        return payload
            .map((item) => item.toString().toUpperCase())
            .where((symbol) => symbol.isNotEmpty)
            .toList();
      }

      return <String>[];
    });
  }

  Future<Map<String, double>> _fetchMarketCaps(List<String> symbols) async {
    final marketCaps = <String, double>{};

    for (final chunk in _chunk(symbols, 50)) {
      final response = await _dio.get(
        ApiConstants.ratios,
        queryParameters: {
          'filter': 'code:${chunk.join(",")}',
          'where': 'itemCode:${ApiConstants.ratioMarketCap}',
          'order': 'reportDate',
          'size': chunk.length,
        },
      );

      final data = response.data['data'] as List? ?? const [];
      for (final item in data) {
        final row = Map<String, dynamic>.from(item as Map);
        final code = (row['code'] as String? ?? '').toUpperCase();
        if (code.isEmpty) {
          continue;
        }
        marketCaps[code] = _toDouble(row['value']) / 1e9;
      }
    }

    return marketCaps;
  }

  Future<Map<String, String>> _fetchCompanyNames(List<String> symbols) async {
    final companyNames = <String, String>{};

    for (final chunk in _chunk(symbols, 50)) {
      final response = await _dio.get(
        ApiConstants.stocks,
        queryParameters: {
          'q': 'type:STOCK~status:listed~code:${chunk.join(",")}',
          'size': chunk.length,
        },
      );

      final data = response.data['data'] as List? ?? const [];
      for (final item in data) {
        final row = Map<String, dynamic>.from(item as Map);
        final code = (row['code'] as String? ?? '').toUpperCase();
        if (code.isEmpty) {
          continue;
        }
        companyNames[code] =
            (row['companyNameEng'] as String?) ??
            (row['companyName'] as String?) ??
            code;
      }
    }

    return companyNames;
  }

  Future<_PeerMetrics> _getPeerMetrics(String symbol) {
    return _peerMetricCache.putIfAbsent(symbol, () async {
      final data = await _fetchFinanceInfo(
        symbol: symbol,
        reportType: 'CSTC',
        periodType: 1,
      );

      final rows = <Map<String, dynamic>>[];
      final content = data['Content'] as Map<String, dynamic>? ?? const {};
      for (final value in content.values) {
        final groupRows = value as List? ?? const [];
        rows.addAll(
          groupRows
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList(),
        );
      }

      return _PeerMetrics(
        pe: _extractRatio(rows, viPatterns: ['(P/E)'], enPatterns: ['P/E']),
        pb: _extractRatio(rows, viPatterns: ['(P/B)'], enPatterns: ['P/B']),
        roe: _extractRatio(rows, viPatterns: ['(ROEA)'], enPatterns: ['ROE']),
        roa: _extractRatio(rows, viPatterns: ['(ROAA)'], enPatterns: ['ROA']),
        debtToEquity: _extractRatio(
          rows,
          viPatterns: ['Tỷ số Nợ trên Vốn chủ sở hữu'],
          enPatterns: ['Liabilities to equity', 'Debt to equity'],
        ),
      );
    });
  }

  double _extractRatio(
    List<Map<String, dynamic>> rows, {
    required List<String> viPatterns,
    required List<String> enPatterns,
  }) {
    for (final row in rows) {
      final name = (row['Name'] as String? ?? '').toLowerCase();
      final nameEn = (row['NameEn'] as String? ?? '').toLowerCase();
      final matchesVi = viPatterns.any(
        (pattern) => name.contains(pattern.toLowerCase()),
      );
      final matchesEn = enPatterns.any(
        (pattern) => nameEn.contains(pattern.toLowerCase()),
      );

      if (!matchesVi && !matchesEn) {
        continue;
      }

      for (var index = 1; index <= 4; index++) {
        final raw = row['Value$index'];
        if (raw != null) {
          return _toDouble(raw);
        }
      }
    }

    return 0;
  }

  List<String> _selectPeerSymbols(
    List<String> symbols,
    String targetSymbol,
    Map<String, double> marketCaps,
  ) {
    final ordered = [...symbols]
      ..sort((a, b) => (marketCaps[b] ?? 0).compareTo(marketCaps[a] ?? 0));

    final selected = ordered.take(10).toList();
    if (!selected.contains(targetSymbol)) {
      if (selected.length == 10) {
        selected.removeLast();
      }
      selected.add(targetSymbol);
    }

    selected.sort((a, b) => (marketCaps[b] ?? 0).compareTo(marketCaps[a] ?? 0));
    return _dedupeSymbols(selected);
  }

  List<String> _dedupeSymbols(List<String> symbols) {
    final deduped = <String>[];
    final seen = <String>{};

    for (final symbol in symbols) {
      final value = symbol.trim().toUpperCase();
      if (value.isNotEmpty && seen.add(value)) {
        deduped.add(value);
      }
    }

    return deduped;
  }

  Iterable<List<String>> _chunk(List<String> symbols, int size) sync* {
    for (var index = 0; index < symbols.length; index += size) {
      final end = index + size < symbols.length ? index + size : symbols.length;
      yield symbols.sublist(index, end);
    }
  }

  int _toInt(dynamic value) {
    return _toDouble(value).round();
  }

  double _toDouble(dynamic value) {
    if (value == null) {
      return 0;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString().replaceAll(',', '')) ?? 0;
  }
}

class _IndustryContext {
  const _IndustryContext({
    required this.code,
    required this.name,
    required this.symbols,
  });

  final int code;
  final String name;
  final List<String> symbols;
}

class _PeerMetrics {
  const _PeerMetrics({
    required this.pe,
    required this.pb,
    required this.roe,
    required this.roa,
    required this.debtToEquity,
  });

  final double pe;
  final double pb;
  final double roe;
  final double roa;
  final double debtToEquity;
}
