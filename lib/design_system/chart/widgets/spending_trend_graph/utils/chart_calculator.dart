import 'dart:math' as math;
import '../../../models/data_point.dart';

class ChartCalculator {
  final List<DataPoint> data;
  final int desiredGridLines;
  final double topPaddingPercentage;
  final double bottomPaddingPercentage;

  const ChartCalculator(
      this.data, {
        this.desiredGridLines = 7,
        this.topPaddingPercentage = 0.2,
        this.bottomPaddingPercentage = 0.0,
      });

  double calculateMaxY() {
    if (data.isEmpty) return 100;

    final maxAmount = _getMaxAmount();
    final paddedMax = maxAmount * (1 + topPaddingPercentage);
    final interval = calculateGridInterval();

    return (paddedMax / interval).ceil() * interval;
  }

  double calculateMinY() {
    if (data.isEmpty) return 0;

    final minAmount = _getMinAmount();
    final paddedMin = minAmount * (1 - bottomPaddingPercentage);

    return math.max(0, paddedMin);
  }

  double calculateMaxX() {
    return data.isEmpty ? 0 : (data.length - 1).toDouble();
  }

  double calculateGridInterval() {
    if (data.isEmpty) return 1;

    final maxAmount = _getMaxAmount();
    final range = maxAmount * (1 + topPaddingPercentage);
    final rawInterval = range / desiredGridLines;

    return _roundToNiceInterval(rawInterval);
  }

  List<double> getYAxisValues() {
    final interval = calculateGridInterval();
    final max = calculateMaxY();
    final min = calculateMinY();
    final values = <double>[];

    double value = min;
    while (value <= max + (interval * 0.001)) {
      values.add(value);
      value += interval;
    }

    return values;
  }

  double _getMaxAmount() {
    return data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
  }

  double _getMinAmount() {
    return data.map((e) => e.amount).reduce((a, b) => a < b ? a : b);
  }

  double _roundToNiceInterval(double rawInterval) {
    if (rawInterval <= 0) return 1;

    final magnitude = math.pow(10, (math.log(rawInterval) / math.ln10).floor());
    final normalized = rawInterval / magnitude;

    final niceNumber = _getNiceNumber(normalized);

    return niceNumber * magnitude;
  }

  double _getNiceNumber(double value) {
    const niceNumbers = [1.0, 2.0, 2.5, 5.0, 10.0];

    for (final nice in niceNumbers) {
      if (value <= nice) {
        return nice;
      }
    }

    return 10.0;
  }
}