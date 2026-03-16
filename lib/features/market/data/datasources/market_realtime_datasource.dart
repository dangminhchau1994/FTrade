import 'dart:async';

import 'package:logger/logger.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/websocket_service.dart';
import '../../domain/entities/realtime_market_data.dart';

final _logger = Logger();

/// GraphQL subscription query cho stock realtime
const _subscriptionQuery = '''
subscription StockRealtime(\$exchange: String!) {
  stockRealtimeByList(exchange: \$exchange) {
    stockSymbol
    matchedPrice
    matchedVolume
    priceChange
    priceChangePercent
    totalVolume
    totalValue
    highest
    lowest
    ceiling
    floor
    refPrice
    best1Bid
    best1BidVol
    best2Bid
    best2BidVol
    best3Bid
    best3BidVol
    best1Offer
    best1OfferVol
    best2Offer
    best2OfferVol
    best3Offer
    best3OfferVol
    buyForeignQtty
    sellForeignQtty
    session
  }
}
''';

/// Datasource cho dữ liệu thị trường realtime qua WebSocket
class MarketRealtimeDatasource {
  late final WebSocketService _ws;
  bool _initialized = false;
  int _subscriptionId = 0;

  // Cache dữ liệu mới nhất theo symbol
  final Map<String, RealtimeMarketData> _cache = {};

  final _dataController =
      StreamController<RealtimeMarketData>.broadcast();

  /// Stream dữ liệu realtime (tất cả mã)
  Stream<RealtimeMarketData> get dataStream => _dataController.stream;

  /// Stream cho 1 mã cụ thể
  Stream<RealtimeMarketData> stockStream(String symbol) {
    return _dataController.stream
        .where((data) => data.symbol == symbol.toUpperCase());
  }

  /// Lấy data mới nhất từ cache
  RealtimeMarketData? getLatest(String symbol) =>
      _cache[symbol.toUpperCase()];

  /// Tất cả data trong cache
  Map<String, RealtimeMarketData> get allLatest =>
      Map.unmodifiable(_cache);

  /// Trạng thái kết nối
  Stream<WebSocketStatus> get statusStream => _ws.statusStream;
  WebSocketStatus get status => _ws.status;

  /// Khởi tạo & kết nối
  Future<void> connect() async {
    if (_initialized) return;

    _ws = WebSocketService(
      url: ApiConstants.ssiWebSocketUrl,
      protocols: {'Sec-WebSocket-Protocol': ApiConstants.ssiWebSocketProtocol},
    );

    // Lắng nghe messages
    _ws.messageStream.listen(_handleMessage);

    // Khi connected, gửi connection_init
    _ws.statusStream.listen((status) {
      if (status == WebSocketStatus.connected) {
        _sendConnectionInit();
      }
    });

    await _ws.connect();
    _initialized = true;
  }

  /// Subscribe realtime data cho 1 sàn (hose, hnx, upcom)
  void subscribeExchange(String exchange) {
    _subscriptionId++;
    final id = _subscriptionId.toString();

    _ws.send({
      'id': id,
      'type': 'subscribe',
      'payload': {
        'query': _subscriptionQuery,
        'variables': {'exchange': exchange},
      },
    });

    _logger.i('Subscribed to $exchange realtime (id: $id)');
  }

  /// Subscribe nhiều sàn cùng lúc
  void subscribeAll() {
    subscribeExchange('hose');
    subscribeExchange('hnx');
    subscribeExchange('upcom');
  }

  /// Ngắt kết nối
  Future<void> disconnect() async {
    _cache.clear();
    _initialized = false;
    await _ws.disconnect();
  }

  /// Dispose
  Future<void> dispose() async {
    await _ws.dispose();
    await _dataController.close();
    _cache.clear();
  }

  void _sendConnectionInit() {
    _ws.send({'type': 'connection_init'});
  }

  void _handleMessage(Map<String, dynamic> message) {
    final type = message['type'] as String?;

    switch (type) {
      case 'connection_ack':
        _logger.i('WebSocket connection acknowledged');
        break;

      case 'next':
        final payload = message['payload'] as Map<String, dynamic>?;
        final data = payload?['data'] as Map<String, dynamic>?;
        final stockData =
            data?['stockRealtimeByList'] as Map<String, dynamic>?;

        if (stockData != null) {
          final parsed = _parseStockData(stockData);
          if (parsed != null) {
            _cache[parsed.symbol] = parsed;
            if (!_dataController.isClosed) {
              _dataController.add(parsed);
            }
          }
        }
        break;

      case 'error':
        _logger.e('WebSocket subscription error: ${message['payload']}');
        break;

      case 'complete':
        _logger.i('Subscription ${message['id']} completed');
        break;

      case 'ka': // keep-alive
        break;

      default:
        _logger.d('WebSocket message: $type');
    }
  }

  RealtimeMarketData? _parseStockData(Map<String, dynamic> data) {
    final symbol = data['stockSymbol'] as String?;
    if (symbol == null || symbol.isEmpty) return null;

    return RealtimeMarketData(
      symbol: symbol.toUpperCase(),
      matchedPrice: _toDouble(data['matchedPrice']),
      matchedVolume: _toInt(data['matchedVolume']),
      change: _toDouble(data['priceChange']),
      changePercent: _toDouble(data['priceChangePercent']),
      totalVolume: _toInt(data['totalVolume']),
      totalValue: _toDouble(data['totalValue']),
      open: _toDouble(data['openPrice']),
      high: _toDouble(data['highest']),
      low: _toDouble(data['lowest']),
      ceiling: _toDouble(data['ceiling']),
      floor: _toDouble(data['floor']),
      refPrice: _toDouble(data['refPrice']),
      bid1Price: _toDouble(data['best1Bid']),
      bid1Volume: _toInt(data['best1BidVol']),
      bid2Price: _toDouble(data['best2Bid']),
      bid2Volume: _toInt(data['best2BidVol']),
      bid3Price: _toDouble(data['best3Bid']),
      bid3Volume: _toInt(data['best3BidVol']),
      ask1Price: _toDouble(data['best1Offer']),
      ask1Volume: _toInt(data['best1OfferVol']),
      ask2Price: _toDouble(data['best2Offer']),
      ask2Volume: _toInt(data['best2OfferVol']),
      ask3Price: _toDouble(data['best3Offer']),
      ask3Volume: _toInt(data['best3OfferVol']),
      foreignBuyVolume: _toInt(data['buyForeignQtty']),
      foreignSellVolume: _toInt(data['sellForeignQtty']),
      session: _parseSession(data['session'] as String?),
      updatedAt: DateTime.now(),
    );
  }

  static TradingSession _parseSession(String? session) {
    return switch (session?.toUpperCase()) {
      'ATO' => TradingSession.ato,
      'ATC' => TradingSession.atc,
      'LO' || 'CONTINUOUS' => TradingSession.continuous,
      'PT' || 'PUT_THROUGH' => TradingSession.putThrough,
      'C' || 'CLOSE' || 'CLOSED' => TradingSession.closed,
      'O' || 'PRE_OPEN' => TradingSession.preOpen,
      _ => TradingSession.unknown,
    };
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
