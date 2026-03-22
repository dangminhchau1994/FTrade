import 'dart:async';

import 'package:logger/logger.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/mqtt_service.dart';
import '../../domain/entities/realtime_market_data.dart';
import '../proto/stock_data.pb.dart';

final _logger = Logger();

const _maxCacheSize = 500;

/// Datasource realtime dùng MQTT + protobuf (SSI price-streaming)
class MarketRealtimeDatasource {
  MqttService? _mqtt;
  StreamSubscription? _messageSub;
  StreamSubscription? _statusSub;

  final Set<String> _topics = {};
  final Map<String, RealtimeMarketData> _cache = {};

  final _dataController = StreamController<RealtimeMarketData>.broadcast();
  final _statusController = StreamController<MqttConnectionStatus>.broadcast();

  Stream<RealtimeMarketData> get dataStream => _dataController.stream;
  Stream<MqttConnectionStatus> get statusStream => _statusController.stream;
  MqttConnectionStatus get status =>
      _mqtt?.status ?? MqttConnectionStatus.disconnected;

  Stream<RealtimeMarketData> stockStream(String symbol) =>
      _dataController.stream.where((d) => d.symbol == symbol.toUpperCase());

  Future<void> connect() async {
    if (_mqtt != null) return;

    _mqtt = MqttService(
      url: ApiConstants.ssiMqttUrl,
      username: ApiConstants.ssiMqttUsername,
      password: ApiConstants.ssiMqttPassword,
    );

    _statusSub = _mqtt!.statusStream.listen((s) {
      if (!_statusController.isClosed) _statusController.add(s);

      if (s == MqttConnectionStatus.connected) {
        _messageSub?.cancel();
        _messageSub = _mqtt!.messageStream.listen(_handleMessage);

        for (final topic in _topics) {
          _mqtt!.subscribe(topic);
        }
        if (_topics.isNotEmpty) {
          _logger.i('MQTT re-subscribed ${_topics.length} topics');
        }
      }
    });

    _messageSub = _mqtt!.messageStream.listen(_handleMessage);
    await _mqtt!.connect();
  }

  void subscribeAll() {
    _addTopic('s/+/MAIN');
    _logger.i('MQTT subscribed: s/+/MAIN');
  }

  void subscribeStock(String symbol) {
    _addTopic('s/${symbol.toUpperCase()}/MAIN');
  }

  void _addTopic(String topic) {
    _topics.add(topic);
    _mqtt?.subscribe(topic);
  }

  Future<void> disconnect() async {
    await _statusSub?.cancel();
    _statusSub = null;
    await _messageSub?.cancel();
    _messageSub = null;
    await _mqtt?.disconnect();
    _mqtt = null;
    _topics.clear();
    _cache.clear();
  }

  Future<void> dispose() async {
    await _statusSub?.cancel();
    _statusSub = null;
    await _messageSub?.cancel();
    _messageSub = null;
    await _mqtt?.dispose();
    _mqtt = null;
    if (!_dataController.isClosed) await _dataController.close();
    if (!_statusController.isClosed) await _statusController.close();
    _topics.clear();
    _cache.clear();
  }

  void _handleMessage(MqttReceivedMessage<MqttMessage> msg) {
    try {
      final bytes = mqttPayloadBytes(msg);
      final proto = StockData.fromBuffer(bytes);
      final data = _toEntity(proto);
      if (data == null) return;

      final old = _cache[data.symbol];
      if (old == data) return;

      if (_cache.length >= _maxCacheSize && !_cache.containsKey(data.symbol)) {
        _cache.remove(_cache.keys.first);
      }

      _cache[data.symbol] = data;
      if (!_dataController.isClosed) _dataController.add(data);
    } catch (e) {
      _logger.e('Proto decode error on ${msg.topic}: $e');
    }
  }

  // ── Proto → domain entity ──────────────────────────────────────────────────

  static RealtimeMarketData? _toEntity(StockData p) {
    if (p.symbol.isEmpty) return null;

    return RealtimeMarketData(
      symbol: p.symbol.toUpperCase(),
      matchedPrice: p.matchedPrice.toDouble(),
      matchedVolume: p.matchedVolume,
      change: _zigzag(p.priceChange).toDouble(),
      changePercent: _zigzag(p.priceChangePercent) / 100.0,
      totalVolume: p.totalVolume.toInt(),
      totalValue: p.totalValue.toDouble(),
      open: p.openPrice.toDouble(),
      high: p.highPrice.toDouble(),
      low: p.lowPrice.toDouble(),
      ceiling: p.ceiling.toDouble(),
      floor: p.floor.toDouble(),
      refPrice: p.refPrice.toDouble(),
      bid1Price: p.best1Bid.toDouble(),
      bid1Volume: p.best1BidVol,
      bid2Price: p.best2Bid.toDouble(),
      bid2Volume: p.best2BidVol,
      bid3Price: p.best3Bid.toDouble(),
      bid3Volume: p.best3BidVol,
      ask1Price: p.best1Offer.toDouble(),
      ask1Volume: p.best1OfferVol,
      ask2Price: p.best2Offer.toDouble(),
      ask2Volume: p.best2OfferVol,
      ask3Price: p.best3Offer.toDouble(),
      ask3Volume: p.best3OfferVol,
      foreignBuyVolume: p.buyForeignQtty.toInt(),
      foreignSellVolume: p.sellForeignQtty.toInt(),
      session: _parseSession(p.session),
      updatedAt: DateTime.now(),
    );
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

  static int _zigzag(int n) => (n >> 1) ^ -(n & 1);
}
