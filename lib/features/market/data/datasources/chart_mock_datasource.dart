import 'dart:math';

class ChartPoint {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;

  ChartPoint({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });
}

class ChartMockDatasource {
  static List<ChartPoint> generate({
    required String period,
    double basePrice = 130000,
  }) {
    final random = Random(42);
    final int count;
    final Duration interval;

    switch (period) {
      case '1D':
        count = 60;
        interval = const Duration(minutes: 5);
      case '1W':
        count = 35;
        interval = const Duration(hours: 4);
      case '1M':
        count = 22;
        interval = const Duration(days: 1);
      case '3M':
        count = 66;
        interval = const Duration(days: 1);
      case '1Y':
        count = 52;
        interval = const Duration(days: 7);
      default:
        count = 22;
        interval = const Duration(days: 1);
    }

    final points = <ChartPoint>[];
    var price = basePrice;
    var now = DateTime.now();

    for (var i = count - 1; i >= 0; i--) {
      final date = now.subtract(interval * i);
      final change = (random.nextDouble() - 0.48) * basePrice * 0.03;
      final open = price;
      price = price + change;
      final close = price;
      final high = max(open, close) + random.nextDouble() * basePrice * 0.01;
      final low = min(open, close) - random.nextDouble() * basePrice * 0.01;
      final volume = 15000000 + random.nextInt(30000000);

      points.add(ChartPoint(
        date: date,
        open: open,
        high: high,
        low: low,
        close: close,
        volume: volume,
      ));
    }

    return points;
  }
}
