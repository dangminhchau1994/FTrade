import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../../core/network/mqtt_service.dart';
import '../../data/datasources/index_realtime_datasource.dart';
import '../../data/datasources/market_realtime_datasource.dart';
import '../../domain/entities/realtime_index_data.dart';
import '../../domain/entities/realtime_market_data.dart';

/// Provider cho MarketRealtimeDatasource singleton
final marketRealtimeDatasourceProvider =
    Provider<MarketRealtimeDatasource>((ref) {
  final datasource = MarketRealtimeDatasource();
  ref.onDispose(() => datasource.dispose());
  return datasource;
});

/// Provider cho IndexRealtimeDatasource singleton
final indexRealtimeDatasourceProvider =
    Provider<IndexRealtimeDatasource>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  final datasource = IndexRealtimeDatasource(dio);
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
  final IndexRealtimeDatasource _indexDatasource;
  StreamSubscription<RealtimeMarketData>? _stockSubscription;
  StreamSubscription<RealtimeIndexData>? _indexSubscription;

  MarketDataController(this._datasource, this._indexDatasource)
      : super(const MarketDataState());

  /// Kết nối MQTT (stocks) + VNDIRECT WebSocket (indices)
  Future<void> connect() async {
    if (state.isConnected) return;

    state = state.copyWith(isConnecting: true);

    try {
      await Future.wait([
        _datasource.connect(),
        _indexDatasource.connect(),
      ]);
      _datasource.subscribeAll();
      _listenData();
      state = state.copyWith(isConnected: true, isConnecting: false);
    } catch (e) {
      state = state.copyWith(isConnecting: false, error: e.toString());
    }
  }

  /// Ngắt kết nối
  Future<void> disconnect() async {
    _stockSubscription?.cancel();
    _stockSubscription = null;
    _indexSubscription?.cancel();
    _indexSubscription = null;
    await Future.wait([
      _datasource.disconnect(),
      _indexDatasource.disconnect(),
    ]);
    state = const MarketDataState();
  }

  void _listenData() {
    _stockSubscription?.cancel();
    _stockSubscription = _datasource.dataStream.listen((data) {
      final updated = Map<String, RealtimeMarketData>.from(state.stocks);
      updated[data.symbol] = data;
      state = state.copyWith(stocks: updated, lastUpdated: DateTime.now());
    });

    _indexSubscription?.cancel();
    _indexSubscription = _indexDatasource.stream.listen((data) {
      final updated = Map<String, RealtimeIndexData>.from(state.indices);
      updated[data.symbol] = data;
      state = state.copyWith(indices: updated, lastUpdated: DateTime.now());
    });
  }

  @override
  void dispose() {
    _stockSubscription?.cancel();
    _indexSubscription?.cancel();
    super.dispose();
  }
}

/// State cho MarketDataController
class MarketDataState {
  final Map<String, RealtimeMarketData> stocks;
  final Map<String, RealtimeIndexData> indices;
  final bool isConnected;
  final bool isConnecting;
  final String? error;
  final DateTime? lastUpdated;

  const MarketDataState({
    this.stocks = const {},
    this.indices = const {},
    this.isConnected = false,
    this.isConnecting = false,
    this.error,
    this.lastUpdated,
  });

  MarketDataState copyWith({
    Map<String, RealtimeMarketData>? stocks,
    Map<String, RealtimeIndexData>? indices,
    bool? isConnected,
    bool? isConnecting,
    String? error,
    DateTime? lastUpdated,
  }) {
    return MarketDataState(
      stocks: stocks ?? this.stocks,
      indices: indices ?? this.indices,
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
  final indexDatasource = ref.watch(indexRealtimeDatasourceProvider);
  final controller = MarketDataController(datasource, indexDatasource);
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
