import 'chart_mock_datasource.dart';

class IndicatorCalculator {
  IndicatorCalculator._();

  static Map<String, List<double?>> calculate(List<ChartPoint> data) {
    final closes = data.map((p) => p.close).toList();
    return {
      'rsi': _calculateRSI(closes, 14),
      'macdLine': _calculateMACD(closes)['macdLine']!,
      'signalLine': _calculateMACD(closes)['signalLine']!,
      'macdHistogram': _calculateMACD(closes)['histogram']!,
      'ma5': _calculateMA(closes, 5),
      'ma10': _calculateMA(closes, 10),
      'ma20': _calculateMA(closes, 20),
      'ma50': _calculateMA(closes, 50),
    };
  }

  static List<double?> _calculateMA(List<double> closes, int period) {
    final result = <double?>[];
    for (var i = 0; i < closes.length; i++) {
      if (i < period - 1) {
        result.add(null);
      } else {
        var sum = 0.0;
        for (var j = i - period + 1; j <= i; j++) {
          sum += closes[j];
        }
        result.add(sum / period);
      }
    }
    return result;
  }

  static List<double?> _calculateRSI(List<double> closes, int period) {
    if (closes.length < period + 1) {
      return List.filled(closes.length, null);
    }

    final result = <double?>[];
    var avgGain = 0.0;
    var avgLoss = 0.0;

    // First pass: calculate initial average gain/loss
    for (var i = 1; i <= period; i++) {
      final change = closes[i] - closes[i - 1];
      if (change > 0) {
        avgGain += change;
      } else {
        avgLoss += change.abs();
      }
    }
    avgGain /= period;
    avgLoss /= period;

    // Fill nulls for first period entries
    for (var i = 0; i < period; i++) {
      result.add(null);
    }

    // First RSI value
    if (avgLoss == 0) {
      result.add(100.0);
    } else {
      final rs = avgGain / avgLoss;
      result.add(100 - (100 / (1 + rs)));
    }

    // Subsequent RSI values using Wilder's smoothing
    for (var i = period + 1; i < closes.length; i++) {
      final change = closes[i] - closes[i - 1];
      final gain = change > 0 ? change : 0.0;
      final loss = change < 0 ? change.abs() : 0.0;

      avgGain = (avgGain * (period - 1) + gain) / period;
      avgLoss = (avgLoss * (period - 1) + loss) / period;

      if (avgLoss == 0) {
        result.add(100.0);
      } else {
        final rs = avgGain / avgLoss;
        result.add(100 - (100 / (1 + rs)));
      }
    }

    return result;
  }

  static Map<String, List<double?>> _calculateMACD(List<double> closes) {
    final ema12 = _calculateEMA(closes, 12);
    final ema26 = _calculateEMA(closes, 26);

    final macdLine = <double?>[];
    for (var i = 0; i < closes.length; i++) {
      if (ema12[i] != null && ema26[i] != null) {
        macdLine.add(ema12[i]! - ema26[i]!);
      } else {
        macdLine.add(null);
      }
    }

    // Signal line = 9-period EMA of MACD line
    final nonNullMacd = macdLine.whereType<double>().toList();
    final signalRaw = _calculateEMA(nonNullMacd, 9);

    final signalLine = <double?>[];
    final histogram = <double?>[];
    var signalIdx = 0;

    for (var i = 0; i < closes.length; i++) {
      if (macdLine[i] == null) {
        signalLine.add(null);
        histogram.add(null);
      } else {
        if (signalIdx < signalRaw.length && signalRaw[signalIdx] != null) {
          signalLine.add(signalRaw[signalIdx]);
          histogram.add(macdLine[i]! - signalRaw[signalIdx]!);
        } else {
          signalLine.add(null);
          histogram.add(null);
        }
        signalIdx++;
      }
    }

    return {
      'macdLine': macdLine,
      'signalLine': signalLine,
      'histogram': histogram,
    };
  }

  static List<double?> _calculateEMA(List<double> data, int period) {
    if (data.length < period) {
      return List.filled(data.length, null);
    }

    final result = <double?>[];
    final multiplier = 2.0 / (period + 1);

    // Fill nulls before first EMA
    for (var i = 0; i < period - 1; i++) {
      result.add(null);
    }

    // First EMA = SMA
    var sum = 0.0;
    for (var i = 0; i < period; i++) {
      sum += data[i];
    }
    var ema = sum / period;
    result.add(ema);

    // Subsequent EMAs
    for (var i = period; i < data.length; i++) {
      ema = (data[i] - ema) * multiplier + ema;
      result.add(ema);
    }

    return result;
  }
}
