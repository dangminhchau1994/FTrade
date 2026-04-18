import 'dart:async';

import 'package:logger/logger.dart';

import '../../../../core/network/socket_cluster_service.dart';
import '../../domain/entities/realtime_index_data.dart';

final _logger = Logger();

/// Realtime chỉ số thị trường từ MASVN SocketCluster.
///
/// Subscribe channel market.quote.{symbol} → nhận ic.up/dw/uc cho breadth data.
/// Chia sẻ cùng SocketClusterService với MarketRealtimeDatasource (1 WS connection).
class IndexRealtimeDatasource {
  final SocketClusterService _socket;

  StreamSubscription? _publishSub;
  bool _disposed = false;

  final _controller = StreamController<RealtimeIndexData>.broadcast();
  Stream<RealtimeIndexData> get stream => _controller.stream;

  // MASVN symbol → FTrade display symbol
  static const _indexMap = {
    'VN-INDEX': 'VNINDEX',
    'VN30': 'VN30',
    'HNXIndex': 'HNXINDEX',
    'HNX30': 'HNX30',
    'HNXUpcomIndex': 'UPCOMINDEX',
  };

  IndexRealtimeDatasource(this._socket);

  Future<void> connect() async {
    if (_disposed || _publishSub != null) return;

    _publishSub = _socket.publishStream.listen((event) {
      _handlePublish(event.$1, event.$2);
    });

    // Subscribe channels (socket.connect() called by MarketRealtimeDatasource)
    for (final sym in _indexMap.keys) {
      _socket.subscribe('market.quote.$sym');
    }
    _logger.i('IndexRealtime: subscribed ${_indexMap.length} index channels');
  }

  Future<void> disconnect() async {
    await _publishSub?.cancel();
    _publishSub = null;
  }

  Future<void> dispose() async {
    _disposed = true;
    await disconnect();
    if (!_controller.isClosed) await _controller.close();
  }

  static const _prefix = 'market.quote.';

  void _handlePublish(String channel, dynamic data) {
    if (!channel.startsWith(_prefix)) return;
    final rawSymbol = channel.substring(_prefix.length);
    final displaySymbol = _indexMap[rawSymbol];
    if (displaySymbol == null) return;
    if (data is! Map) return;

    try {
      final c = (data['c'] as num?)?.toDouble() ?? 0.0;
      final ch = (data['ch'] as num?)?.toDouble() ?? 0.0;
      final r = (data['r'] as num?)?.toDouble() ?? 0.0;
      if (c == 0) return;

      final ic = data['ic'];
      final advances = ic is Map ? (ic['up'] as num?)?.toInt() : null;
      final declines = ic is Map ? (ic['dw'] as num?)?.toInt() : null;
      final unchanged = ic is Map ? (ic['uc'] as num?)?.toInt() : null;

      final indexData = RealtimeIndexData(
        symbol: displaySymbol,
        value: c,
        change: ch,
        changePercent: r,
        advances: advances,
        declines: declines,
        unchanged: unchanged,
        updatedAt: DateTime.now(),
      );

      if (!_controller.isClosed) _controller.add(indexData);
    } catch (e) {
      _logger.d('IndexRealtime parse error for $rawSymbol: $e');
    }
  }
}
