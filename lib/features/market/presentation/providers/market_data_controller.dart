import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/market_realtime_datasource.dart';
import '../../domain/entities/realtime_market_data.dart';
import '../../../../core/network/mqtt_service.dart';

/// Provider cho MarketRealtimeDatasource singleton
final marketRealtimeDatasourceProvider =
    Provider<MarketRealtimeDatasource>((ref) {
  final datasource = MarketRealtimeDatasource();
  ref.onDispose(() => datasource.dispose());
  return datasource;
});

/// Trạng thái kết nối MQTT
final marketConnectionStatusProvider =
    StreamProvider<MqttConnectionStatus>((ref) {
  final datasource = ref.watch(marketRealtimeDatasourceProvider);
  return datasource.statusStream;
});

/// Controller quản lý realtime market data
class MarketDataController extends StateNotifier<MarketDataState> {
  final MarketRealtimeDatasource _datasource;
  StreamSubscription<RealtimeMarketData>? _subscription;

  MarketDataController(this._datasource) : super(const MarketDataState());

  /// Kết nối & subscribe tất cả sàn
  Future<void> connect() async {
    if (state.isConnected) return;

    state = state.copyWith(isConnecting: true);

    try {
      await _datasource.connect();
      _datasource.subscribeAll();
      _listenData();
      state = state.copyWith(isConnected: true, isConnecting: false);
    } catch (e) {
      state = state.copyWith(isConnecting: false, error: e.toString());
    }
  }

  /// Ngắt kết nối
  Future<void> disconnect() async {
    _subscription?.cancel();
    _subscription = null;
    await _datasource.disconnect();
    state = const MarketDataState();
  }

  void _listenData() {
    _subscription?.cancel();
    _subscription = _datasource.dataStream.listen((data) {
      final updated = Map<String, RealtimeMarketData>.from(state.stocks);
      updated[data.symbol] = data;
      state = state.copyWith(stocks: updated, lastUpdated: DateTime.now());
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

/// State cho MarketDataController
class MarketDataState {
  final Map<String, RealtimeMarketData> stocks;
  final bool isConnected;
  final bool isConnecting;
  final String? error;
  final DateTime? lastUpdated;

  const MarketDataState({
    this.stocks = const {},
    this.isConnected = false,
    this.isConnecting = false,
    this.error,
    this.lastUpdated,
  });

  MarketDataState copyWith({
    Map<String, RealtimeMarketData>? stocks,
    bool? isConnected,
    bool? isConnecting,
    String? error,
    DateTime? lastUpdated,
  }) {
    return MarketDataState(
      stocks: stocks ?? this.stocks,
      isConnected: isConnected ?? this.isConnected,
      isConnecting: isConnecting ?? this.isConnecting,
      error: error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Provider cho MarketDataController
final marketDataControllerProvider =
    StateNotifierProvider<MarketDataController, MarketDataState>((ref) {
  final datasource = ref.watch(marketRealtimeDatasourceProvider);
  final controller = MarketDataController(datasource);
  ref.onDispose(() => controller.disconnect());
  return controller;
});

/// Realtime data cho 1 mã cụ thể (từ state cache)
final realtimeStockProvider =
    Provider.family<RealtimeMarketData?, String>((ref, symbol) {
  final state = ref.watch(marketDataControllerProvider);
  return state.stocks[symbol.toUpperCase()];
});

/// Stream provider cho 1 mã cụ thể
final realtimeStockStreamProvider =
    StreamProvider.family<RealtimeMarketData, String>((ref, symbol) {
  final datasource = ref.watch(marketRealtimeDatasourceProvider);
  return datasource.stockStream(symbol);
});
