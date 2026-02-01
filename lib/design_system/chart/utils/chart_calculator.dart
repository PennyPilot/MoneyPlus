import 'dart:math' as math;
import 'package:moneyplus/design_system/chart/models/data_point.dart';

class ChartCalculator {

  static const int desiredGridLines = 7;
  static const double topPaddingPercentage = 0.2;
  static const double bottomPaddingPercentage = 0.0;
  static const List<double> niceNumbers = [1.0, 2.0, 2.5, 5.0, 10.0];
  static const double precisionTolerance = 0.001;
  static const double defaultAxisInterval = 1.0;

  final List<DataPoint> _data;

  const ChartCalculator(this._data);

  /// The maximum Y value for the chart.
  ///
  /// Adds top padding and rounds to the nearest grid interval for clean display.
  double get maxY {
    if (_data.isEmpty) return 100;

    final maxAmount = _getMaxAmount();
    final paddedMax = maxAmount * (1 + topPaddingPercentage);
    final interval = gridInterval;

    return (paddedMax / interval).ceil() * interval;
  }

  /// The minimum Y value for the chart.
  ///
  /// Applies bottom padding but ensures value is never negative.
  double get minY {
    if (_data.isEmpty) return 0;

    final minAmount = _getMinAmount();
    final paddedMin = minAmount * (1 - bottomPaddingPercentage);
    final interval = gridInterval;

    final snappedMin = (paddedMin / interval).floor() * interval;
    return math.max(0, snappedMin);
  }

  /// The maximum X value based on data point count.
  double get maxX {
    return _data.isEmpty ? 0 : (_data.length - 1).toDouble();
  }

  /// The optimal grid interval for Y axis.
  ///
  /// Uses "nice numbers" to create visually pleasing intervals.
  double get gridInterval {
    if (_data.isEmpty) return defaultAxisInterval;

    final maxAmount = _getMaxAmount();
    final range = maxAmount * (1 + topPaddingPercentage);
    final rawInterval = range / desiredGridLines;

    return _roundToNiceInterval(rawInterval);
  }

  double _getMaxAmount() {
    return _data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
  }

  double _getMinAmount() {
    return _data.map((e) => e.amount).reduce((a, b) => a < b ? a : b);
  }

  /// Rounds a raw interval to a "nice" number for better readability.
  ///
  /// Examples: 3.7 → 5.0, 0.12 → 0.2, 23 → 25
  double _roundToNiceInterval(double rawInterval) {
    if (rawInterval <= 0) return defaultAxisInterval;

    final magnitude = math.pow(10, (math.log(rawInterval) / math.ln10).floor());
    final normalized = rawInterval / magnitude;
    final niceNumber = _getNiceNumber(normalized);

    return niceNumber * magnitude;
  }

  /// Selects the smallest nice number that is greater than or equal to the value.
  double _getNiceNumber(double value) {
    for (final nice in niceNumbers) {
      if (value <= nice) {
        return nice;
      }
    }
    return niceNumbers.last;
  }
}
