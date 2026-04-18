import 'dart:async';

import 'package:logger/logger.dart';

import '../../../../core/network/socket_cluster_service.dart';
import '../../domain/entities/realtime_market_data.dart';

final _logger = Logger();
const _maxCacheSize = 500;

/// Realtime datasource cho stock data qua MASVN SocketCluster WebSocket.
///
/// Channel: market.quote.{SYMBOL} → SymbolData JSON (msgpack)
/// Prices  : raw VND integers (e.g. 149800 = 149,800đ)
/// r field : change percent already in % units (e.g. 2.5 = 2.5%)
class MarketRealtimeDatasource {
  final SocketClusterService _socket;

  StreamSubscription? _publishSub;
  StreamSubscription? _statusSub;

  final Set<String> _subscribedSymbols = {};
  final Map<String, RealtimeMarketData> _cache = {};

  final _dataCtrl = StreamController<RealtimeMarketData>.broadcast();
  final _statusCtrl = StreamController<SocketConnectionStatus>.broadcast();

  Stream<RealtimeMarketData> get dataStream => _dataCtrl.stream;
  Stream<SocketConnectionStatus> get statusStream => _statusCtrl.stream;
  SocketConnectionStatus get status => _socket.status;
  int get messageCount => _socket.messageCount;
  DateTime? get lastMessageAt => _socket.lastMessageAt;
  String? get lastError => _socket.lastError;

  Stream<RealtimeMarketData> stockStream(String symbol) =>
      _dataCtrl.stream.where((d) => d.symbol == symbol.toUpperCase());

  MarketRealtimeDatasource(this._socket);

  Future<void> connect() async {
    if (_publishSub != null) return;

    _statusSub = _socket.statusStream.listen((s) {
      if (!_statusCtrl.isClosed) _statusCtrl.add(s);
    });

    _publishSub = _socket.publishStream.listen((event) {
      _handlePublish(event.$1, event.$2);
    });

    await _socket.connect();
  }

  /// Subscribe to MASVN index channels so home screen gets index data immediately.
  void subscribeAll() {
    for (final sym in _masvnIndexSymbols) {
      _doSubscribe(sym);
    }
    _logger.i(
      'SocketCluster: subscribed ${_masvnIndexSymbols.length} index channels',
    );
  }

  /// Idempotent per-symbol subscription — called lazily by UI providers.
  void subscribeStock(String symbol) {
    _doSubscribe(symbol.toUpperCase());
  }

  void _doSubscribe(String symbol) {
    if (_subscribedSymbols.contains(symbol)) return;
    _subscribedSymbols.add(symbol);
    _socket.subscribe('market.quote.$symbol');
  }

  Future<void> disconnect() async {
    await _statusSub?.cancel();
    _statusSub = null;
    await _publishSub?.cancel();
    _publishSub = null;
    _subscribedSymbols.clear();
    _cache.clear();
  }

  Future<void> dispose() async {
    await _statusSub?.cancel();
    _statusSub = null;
    await _publishSub?.cancel();
    _publishSub = null;
    if (!_dataCtrl.isClosed) await _dataCtrl.close();
    if (!_statusCtrl.isClosed) await _statusCtrl.close();
    _subscribedSymbols.clear();
    _cache.clear();
  }

  // MASVN index symbols and their FTrade display names
  static const _masvnIndexSymbols = [
    'VN-INDEX',
    'VN30',
    'HNXIndex',
    'HNX30',
    'HNXUpcomIndex',
  ];

  static const _indexSymbolMap = {
    'VN-INDEX': 'VNINDEX',
    'HNXIndex': 'HNXINDEX',
    'HNXUpcomIndex': 'UPCOMINDEX',
  };

  static const _channelPrefix = 'market.quote.';

  void _handlePublish(String channel, dynamic data) {
    if (!channel.startsWith(_channelPrefix)) return;
    if (data is! Map) return;

    try {
      final rawSymbol = channel.substring(_channelPrefix.length);
      final entity = _toEntity(rawSymbol, data);
      if (entity == null) return;

      final old = _cache[entity.symbol];
      if (old == entity) return;

      if (_cache.length >= _maxCacheSize &&
          !_cache.containsKey(entity.symbol)) {
        _cache.remove(_cache.keys.first);
      }
      _cache[entity.symbol] = entity;

      if (!_dataCtrl.isClosed) _dataCtrl.add(entity);
    } catch (_) {}
  }

  static RealtimeMarketData? _toEntity(String rawSymbol, Map data) {
    final displaySymbol =
        _indexSymbolMap[rawSymbol] ?? rawSymbol.toUpperCase();

    final c = _n(data['c']);
    final refPrice = _n(data['re']);
    if (c == 0 && refPrice == 0) return null;

    final bb = _parseBidOfferList(data['bb']);
    final bo = _parseBidOfferList(data['bo']);

    return RealtimeMarketData(
      symbol: displaySymbol,
      matchedPrice: c,
      matchedVolume: _i(data['mv']),
      change: _n(data['ch']),
      changePercent: _n(data['r']),
      totalVolume: _i(data['vo']),
      totalValue: _n(data['va']),
      open: _n(data['o']),
      high: _n(data['h']),
      low: _n(data['l']),
      ceiling: _n(data['ce']),
      floor: _n(data['fl']),
      refPrice: refPrice,
      bid1Price: bb.isNotEmpty ? bb[0].$1 : 0,
      bid1Volume: bb.isNotEmpty ? bb[0].$2 : 0,
      bid2Price: bb.length > 1 ? bb[1].$1 : 0,
      bid2Volume: bb.length > 1 ? bb[1].$2 : 0,
      bid3Price: bb.length > 2 ? bb[2].$1 : 0,
      bid3Volume: bb.length > 2 ? bb[2].$2 : 0,
      ask1Price: bo.isNotEmpty ? bo[0].$1 : 0,
      ask1Volume: bo.isNotEmpty ? bo[0].$2 : 0,
      ask2Price: bo.length > 1 ? bo[1].$1 : 0,
      ask2Volume: bo.length > 1 ? bo[1].$2 : 0,
      ask3Price: bo.length > 2 ? bo[2].$1 : 0,
      ask3Volume: bo.length > 2 ? bo[2].$2 : 0,
      foreignBuyVolume: _i(data['frBvo']),
      foreignSellVolume: _i(data['frSvo']),
      session: _parseSession(data['ss']?.toString() ?? ''),
      updatedAt: DateTime.now(),
    );
  }

  static double _n(dynamic v) =>
      v == null ? 0.0 : (v as num).toDouble();
  static int _i(dynamic v) =>
      v == null ? 0 : (v as num).toInt();

  static List<(double price, int vol)> _parseBidOfferList(dynamic list) {
    if (list is! List) return [];
    return list.map<(double, int)>((e) {
      if (e is! Map) return (0.0, 0);
      return (_n(e['p']), _i(e['v']));
    }).toList();
  }

  static TradingSession _parseSession(String session) {
    return switch (session.toUpperCase()) {
      'ATO' => TradingSession.ato,
      'ATC' => TradingSession.atc,
      'LO' || 'CONTINUOUS' => TradingSession.continuous,
      'PT' || 'PUT_THROUGH' => TradingSession.putThrough,
      'C' || 'CLOSE' || 'CLOSED' => TradingSession.closed,
      'O' || 'PRE_OPEN' => TradingSession.preOpen,
      _ => TradingSession.unknown,
    };
  }
}
