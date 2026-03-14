import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/vietstock_finance_client.dart';
import '../../domain/entities/corporate_event.dart';
import '../../domain/entities/dividend.dart';
import '../../domain/entities/insider_trade.dart';

class CorporateApiDatasource {
  CorporateApiDatasource(this._dio)
    : _vietstockClient = VietstockFinanceClient(_dio);

  final Dio _dio;
  final VietstockFinanceClient _vietstockClient;
  final _dateFormat = DateFormat('yyyy-MM-dd');

  final Map<int, List<int>> _eventChannelCache = {};
  final Map<String, Future<double>> _priceCache = {};

  static const _dividendEventTypeId = 1;
  static const _agmEventTypeId = 5;

  static const _cashDividendChannel = 13;
  static const _bonusShareChannel = 14;
  static const _stockDividendChannel = 15;
  static const _rightsIssueChannel = 16;
  static const _agmChannels = [34, 35, 36];

  Future<List<Dividend>> getDividends() async {
    final dividends = await _loadDividends();
    dividends.sort((a, b) => a.exDate.compareTo(b.exDate));
    return dividends;
  }

  Future<List<Dividend>> getDividendsBySymbol(String symbol) async {
    final normalized = symbol.toUpperCase();
    final dividends = await _loadDividends(symbol: normalized);
    dividends.sort((a, b) => a.exDate.compareTo(b.exDate));
    return dividends.where((item) => item.symbol == normalized).toList();
  }

  Future<List<CorporateEvent>> getUpcomingEvents() async {
    final events = await _loadCorporateEvents();
    events.sort((a, b) => a.eventDate.compareTo(b.eventDate));
    return events;
  }

  Future<List<CorporateEvent>> getEventsBySymbol(String symbol) async {
    final normalized = symbol.toUpperCase();
    final events = await _loadCorporateEvents(symbol: normalized);
    events.sort((a, b) => a.eventDate.compareTo(b.eventDate));
    return events.where((item) => item.symbol == normalized).toList();
  }

  Future<List<InsiderTrade>> getInsiderTrades() async {
    final trades = await _loadInsiderTrades();
    trades.sort((a, b) => b.tradeDate.compareTo(a.tradeDate));
    return trades;
  }

  Future<List<InsiderTrade>> getInsiderTradesBySymbol(String symbol) async {
    final normalized = symbol.toUpperCase();
    final trades = await _loadInsiderTrades(symbol: normalized);
    trades.sort((a, b) => b.tradeDate.compareTo(a.tradeDate));
    return trades.where((item) => item.symbol == normalized).toList();
  }

  Future<List<Dividend>> _loadDividends({String? symbol}) async {
    final channels = await _getChannelsForEventType(_dividendEventTypeId);
    final selectedChannels =
        channels
            .where(
              (channelId) =>
                  channelId == _cashDividendChannel ||
                  channelId == _bonusShareChannel ||
                  channelId == _stockDividendChannel,
            )
            .toList();

    final rows = await _fetchEventRowsForChannels(
      eventTypeId: _dividendEventTypeId,
      channelIds:
          selectedChannels.isEmpty
              ? const [
                _cashDividendChannel,
                _bonusShareChannel,
                _stockDividendChannel,
              ]
              : selectedChannels,
      fromDate: DateTime.now().subtract(const Duration(days: 30)),
      toDate: DateTime.now().add(const Duration(days: 365)),
      symbol: symbol,
      orderBy: 'GDKHQDate',
      orderDir: 'asc',
    );

    final mapped = <String, Dividend>{};
    for (final row in rows) {
      final dividend = _mapDividend(row);
      if (dividend == null) {
        continue;
      }
      mapped['${row['EventID']}'] = dividend;
    }

    return mapped.values.toList();
  }

  Future<List<CorporateEvent>> _loadCorporateEvents({String? symbol}) async {
    final dividendChannels = await _getChannelsForEventType(
      _dividendEventTypeId,
    );
    final agmChannels = await _getChannelsForEventType(_agmEventTypeId);

    final rows = await Future.wait([
      _fetchEventRowsForChannels(
        eventTypeId: _dividendEventTypeId,
        channelIds:
            dividendChannels
                    .where(
                      (channelId) =>
                          channelId == _cashDividendChannel ||
                          channelId == _bonusShareChannel ||
                          channelId == _stockDividendChannel ||
                          channelId == _rightsIssueChannel,
                    )
                    .toList()
                    .isEmpty
                ? const [
                  _cashDividendChannel,
                  _bonusShareChannel,
                  _stockDividendChannel,
                  _rightsIssueChannel,
                ]
                : dividendChannels
                    .where(
                      (channelId) =>
                          channelId == _cashDividendChannel ||
                          channelId == _bonusShareChannel ||
                          channelId == _stockDividendChannel ||
                          channelId == _rightsIssueChannel,
                    )
                    .toList(),
        fromDate: DateTime.now().subtract(const Duration(days: 7)),
        toDate: DateTime.now().add(const Duration(days: 365)),
        symbol: symbol,
        orderBy: 'GDKHQDate',
        orderDir: 'asc',
      ),
      _fetchEventRowsForChannels(
        eventTypeId: _agmEventTypeId,
        channelIds: agmChannels.isEmpty ? _agmChannels : agmChannels,
        fromDate: DateTime.now().subtract(const Duration(days: 7)),
        toDate: DateTime.now().add(const Duration(days: 365)),
        symbol: symbol,
        orderBy: 'Time',
        orderDir: 'asc',
      ),
    ]);

    final mapped = <String, CorporateEvent>{};
    for (final row in rows.expand((items) => items)) {
      final event = _mapCorporateEvent(row);
      if (event == null) {
        continue;
      }
      mapped[event.id] = event;
    }

    return mapped.values.toList();
  }

  Future<List<InsiderTrade>> _loadInsiderTrades({String? symbol}) async {
    final rows = await _fetchTransferRows(
      page: 1,
      pageSize: 30,
      symbol: symbol,
    );
    final mapped = await Future.wait(rows.map(_mapInsiderTrade));
    return mapped.whereType<InsiderTrade>().toList();
  }

  Future<List<int>> _getChannelsForEventType(int eventTypeId) async {
    final cached = _eventChannelCache[eventTypeId];
    if (cached != null) {
      return cached;
    }

    final data = await _vietstockClient.postForm(
      url: ApiConstants.vietstockEventTypes,
      referer: ApiConstants.vietstockCorporateEventsPage,
      data: {
        'id': eventTypeId,
        'languageID': 1,
        'page': 1,
        'pageSize': 50,
        'orderBy': 'Name',
        'orderDir': 'asc',
      },
    );

    final payload = data as List? ?? const [];
    final channelsPayload =
        payload.length > 1 ? payload[1] as List? ?? const [] : const [];
    final channels =
        channelsPayload
            .map((item) => _toInt((item as Map)['ChannelID']))
            .where((channelId) => channelId > 0)
            .toList();

    _eventChannelCache[eventTypeId] = channels;
    return channels;
  }

  Future<List<Map<String, dynamic>>> _fetchEventRowsForChannels({
    required int eventTypeId,
    required List<int> channelIds,
    required DateTime fromDate,
    required DateTime toDate,
    String? symbol,
    required String orderBy,
    required String orderDir,
  }) async {
    final rows = await Future.wait(
      channelIds.map(
        (channelId) => _fetchEventRows(
          eventTypeId: eventTypeId,
          channelId: channelId,
          fromDate: fromDate,
          toDate: toDate,
          symbol: symbol,
          orderBy: orderBy,
          orderDir: orderDir,
        ),
      ),
    );

    return rows.expand((items) => items).toList();
  }

  Future<List<Map<String, dynamic>>> _fetchEventRows({
    required int eventTypeId,
    required int channelId,
    required DateTime fromDate,
    required DateTime toDate,
    String? symbol,
    required String orderBy,
    required String orderDir,
  }) async {
    final data = await _vietstockClient.postForm(
      url: ApiConstants.vietstockEventData,
      referer: ApiConstants.vietstockCorporateEventsPage,
      data: {
        'eventTypeID': eventTypeId,
        'channelID': channelId,
        'code': symbol ?? '',
        'fDate': _dateFormat.format(fromDate),
        'tDate': _dateFormat.format(toDate),
        'page': 1,
        'pageSize': 200,
        'orderBy': orderBy,
        'orderDir': orderDir,
        'showEvent': 'True',
        'showColor': 'False',
        'showPopup': 'False',
        'showLatestNews': 'False',
      },
    );

    final payload = data as List? ?? const [];
    final rowsPayload =
        payload.isNotEmpty && payload.first is List
            ? payload.first as List
            : payload;

    return rowsPayload.map((item) {
      final row = Map<String, dynamic>.from(item as Map);
      row['__channelId'] = channelId;
      row['__eventTypeId'] = eventTypeId;
      return row;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _fetchTransferRows({
    required int page,
    required int pageSize,
    String? symbol,
  }) async {
    final data = await _vietstockClient.postForm(
      url: ApiConstants.vietstockTransferData,
      referer: ApiConstants.vietstockInsiderTradesPage,
      data: {
        'transferTypeID': 0,
        'stockCode': symbol ?? '',
        'fDate': _dateFormat.format(
          DateTime.now().subtract(const Duration(days: 180)),
        ),
        'tDate': _dateFormat.format(
          DateTime.now().add(const Duration(days: 1)),
        ),
        'page': page,
        'pageSize': pageSize,
        'orderBy': 'PublicDate',
        'orderDir': 'desc',
      },
    );

    final payload = data as List? ?? const [];
    return payload
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  Dividend? _mapDividend(Map<String, dynamic> row) {
    final symbol = (row['Code'] as String? ?? '').toUpperCase();
    final exDate = _parseVietstockDate(row['GDKHQDate']);
    if (symbol.isEmpty || exDate == null) {
      return null;
    }

    final channelId = _toInt(row['__channelId']);
    final note = _cleanText(row['Note']);
    final ratio =
        channelId == _cashDividendChannel ? 0.0 : _parseShareRatio(row);
    final cashAmount =
        channelId == _cashDividendChannel ? _parseCashAmount(row) : 0.0;

    return Dividend(
      symbol: symbol,
      exDate: exDate,
      recordDate: _parseVietstockDate(row['NDKCCDate']) ?? exDate,
      paymentDate: _parseVietstockDate(row['Time']) ?? exDate,
      ratio: ratio,
      cashAmount: cashAmount,
      note: note.isEmpty ? _displayTitle(row) : note,
    );
  }

  CorporateEvent? _mapCorporateEvent(Map<String, dynamic> row) {
    final symbol = (row['Code'] as String? ?? '').toUpperCase();
    if (symbol.isEmpty) {
      return null;
    }

    final channelId = _toInt(row['__channelId']);
    final type = _mapCorporateEventType(channelId);
    final eventDate = _resolveCorporateEventDate(row, channelId);
    if (type == null || eventDate == null) {
      return null;
    }

    return CorporateEvent(
      id: '${row['EventID']}',
      symbol: symbol,
      title: _displayTitle(row),
      type: type,
      eventDate: eventDate,
      description: _description(row),
    );
  }

  Future<InsiderTrade?> _mapInsiderTrade(Map<String, dynamic> row) async {
    final symbol = (row['StockCode'] as String? ?? '').toUpperCase();
    if (symbol.isEmpty) {
      return null;
    }

    final sellQuantity = _preferredQuantity(
      actual: _toInt(row['SellVolume']),
      registered: _toInt(row['RegisterSellVolume']),
    );
    final buyQuantity = _preferredQuantity(
      actual: _toInt(row['BuyVolume']),
      registered: _toInt(row['RegisterBuyVolume']),
    );

    final isSell = sellQuantity > buyQuantity;
    final quantity = isSell ? sellQuantity : buyQuantity;
    if (quantity == 0) {
      return null;
    }

    final tradeDate =
        _parseVietstockDate(row['DateActionTo']) ??
        _parseVietstockDate(row['DateSellExpected']) ??
        _parseVietstockDate(row['DateBuyExpected']) ??
        _parseVietstockDate(row['DateActionFrom']);
    if (tradeDate == null) {
      return null;
    }

    return InsiderTrade(
      symbol: symbol,
      traderName: _resolveTraderName(row),
      position: _resolvePosition(row),
      tradeType: isSell ? TradeType.sell : TradeType.buy,
      quantity: quantity,
      price: await _getClosePrice(symbol, tradeDate),
      tradeDate: tradeDate,
      reportDate: tradeDate,
      isProprietary: _isProprietary(row),
    );
  }

  Future<double> _getClosePrice(String symbol, DateTime date) {
    final cacheKey = '$symbol|${_dateFormat.format(date)}';
    return _priceCache.putIfAbsent(cacheKey, () async {
      try {
        final exactResponse = await _dio.get(
          ApiConstants.stockPrices,
          queryParameters: {
            'q': 'code:$symbol~date:${_dateFormat.format(date)}',
            'size': 1,
          },
        );

        final exactData = exactResponse.data['data'] as List? ?? const [];
        if (exactData.isNotEmpty) {
          return _toDouble((exactData.first as Map)['close']) * 1000;
        }

        final latestResponse = await _dio.get(
          ApiConstants.stockPrices,
          queryParameters: {
            'q': 'code:$symbol',
            'size': 1,
            'sort': 'date:desc',
          },
        );
        final latestData = latestResponse.data['data'] as List? ?? const [];
        if (latestData.isNotEmpty) {
          return _toDouble((latestData.first as Map)['close']) * 1000;
        }
      } catch (_) {
        return 0;
      }

      return 0;
    });
  }

  CorporateEventType? _mapCorporateEventType(int channelId) {
    if (channelId == _cashDividendChannel ||
        channelId == _bonusShareChannel ||
        channelId == _stockDividendChannel) {
      return CorporateEventType.dividend;
    }
    if (channelId == _rightsIssueChannel) {
      return CorporateEventType.rightsIssue;
    }
    if (_agmChannels.contains(channelId)) {
      return CorporateEventType.agm;
    }
    return null;
  }

  DateTime? _resolveCorporateEventDate(
    Map<String, dynamic> row,
    int channelId,
  ) {
    if (_agmChannels.contains(channelId)) {
      return _parseVietstockDate(row['Time']) ??
          _parseVietstockDate(row['FromDate']) ??
          _parseVietstockDate(row['GDKHQDate']);
    }
    return _parseVietstockDate(row['GDKHQDate']) ??
        _parseVietstockDate(row['DateOrder']) ??
        _parseVietstockDate(row['Time']);
  }

  String _resolveTraderName(Map<String, dynamic> row) {
    final names = [
      _cleanText(row['DTTHCD']),
      _cleanText(row['DTTHLQ']),
      _cleanText(row['NVTH']),
    ].where((item) => item.isNotEmpty);

    if (names.isNotEmpty) {
      return names.first;
    }

    final title = _displayTitle(row);
    final match = RegExp(
      r'người nội bộ (.+)$',
      caseSensitive: false,
    ).firstMatch(title);
    return match?.group(1)?.trim() ?? symbolFromRow(row);
  }

  String _resolvePosition(Map<String, dynamic> row) {
    final values = [
      _cleanText(row['PositionCD']),
      _cleanText(row['PositionCDEx']),
      _cleanText(row['RelationShipType']),
      _cleanText(row['ExtraPositionNLQ']),
      _cleanText(row['ExtraPositionNLQEx']),
      _cleanText(row['ExtraPositionNN']),
    ].where((item) => item.isNotEmpty);

    if (values.isNotEmpty) {
      return values.first;
    }

    return _isProprietary(row) ? 'Tự doanh CTCK' : 'Người nội bộ';
  }

  bool _isProprietary(Map<String, dynamic> row) {
    final fingerprint =
        [
          _cleanText(row['Title']),
          _cleanText(row['DTTHCD']),
          _cleanText(row['DTTHLQ']),
          _cleanText(row['PositionCD']),
        ].join(' ').toLowerCase();

    return fingerprint.contains('tự doanh') || fingerprint.contains('ctck');
  }

  int _preferredQuantity({required int actual, required int registered}) {
    return actual > 0 ? actual : registered;
  }

  double _parseShareRatio(Map<String, dynamic> row) {
    final rate = _cleanText(row['Rate']);
    if (rate.contains(':')) {
      final parts = rate.split(':');
      if (parts.length == 2) {
        final left = _parseLooseDouble(parts[0]);
        final right = _parseLooseDouble(parts[1]);
        if (left > 0 && right > 0) {
          return (right / left) * 100;
        }
      }
    }

    return _parseLooseDouble(rate);
  }

  double _parseCashAmount(Map<String, dynamic> row) {
    final note = '${_cleanText(row['Note'])} ${_cleanText(row['Title'])}';
    final match = RegExp(
      r'([\d.,]+)\s*đồng\s*\/\s*CP',
      caseSensitive: false,
    ).firstMatch(note);
    if (match != null) {
      return _parseLooseDouble(match.group(1));
    }

    final rateValue = _parseLooseDouble(row['Rate']);
    if (rateValue > 0 && rateValue <= 100) {
      return rateValue * 100;
    }

    return rateValue;
  }

  DateTime? _parseVietstockDate(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString();
    final match = RegExp(r'/Date\((\d+)\)/').firstMatch(text);
    if (match != null) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(match.group(1)!));
    }

    return DateTime.tryParse(text);
  }

  String _displayTitle(Map<String, dynamic> row) {
    final note = _cleanText(row['Note']);
    if (note.isNotEmpty) {
      return note;
    }

    final title = _cleanText(row['Title']);
    final symbol = symbolFromRow(row);
    return title.startsWith('$symbol: ')
        ? title.substring(symbol.length + 2)
        : title;
  }

  String? _description(Map<String, dynamic> row) {
    final content = _cleanText(row['Content']);
    if (content.isEmpty || content == '.') {
      return null;
    }
    return content;
  }

  String symbolFromRow(Map<String, dynamic> row) {
    return ((row['Code'] ?? row['StockCode']) as String? ?? '').toUpperCase();
  }

  String _cleanText(dynamic value) {
    final text = value?.toString() ?? '';
    final cleaned =
        text
            .replaceAll(RegExp(r'<[^>]+>'), ' ')
            .replaceAll('&nbsp;', ' ')
            .replaceAll('&amp;', '&')
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();

    return cleaned == 'Blank' ? '' : cleaned;
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

  double _parseLooseDouble(dynamic value) {
    var normalized = value?.toString().trim() ?? '';
    if (normalized.isEmpty) {
      return 0;
    }

    final hasComma = normalized.contains(',');
    final hasDot = normalized.contains('.');

    if (hasComma && hasDot) {
      if (normalized.lastIndexOf(',') > normalized.lastIndexOf('.')) {
        normalized = normalized.replaceAll('.', '').replaceAll(',', '.');
      } else {
        normalized = normalized.replaceAll(',', '');
      }
    } else if (hasComma) {
      if (RegExp(r',\d{1,2}$').hasMatch(normalized)) {
        normalized = normalized.replaceAll('.', '').replaceAll(',', '.');
      } else {
        normalized = normalized.replaceAll(',', '');
      }
    } else {
      normalized = normalized.replaceAll(',', '');
    }

    return double.tryParse(normalized) ?? 0;
  }
}
