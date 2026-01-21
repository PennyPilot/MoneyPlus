import 'dart:math' as math;
import '../../../config/chart_constants.dart';
import '../../../models/data_point.dart';

/// Calculator for chart dimensions and grid intervals.
///
/// This class follows the Single Responsibility Principle by focusing
/// solely on mathematical calculations for chart rendering.
class ChartCalculator {
  final List<DataPoint> _data;

  const ChartCalculator(this._data);

  /// Calculates the maximum Y value for the chart.
  ///
  /// Adds top padding and rounds to the nearest grid interval for clean display.
  double calculateMaxY() {
    if (_data.isEmpty) return 100;

    final maxAmount = _getMaxAmount();
    final paddedMax = maxAmount * (1 + ChartConstants.topPaddingPercentage);
    final interval = calculateGridInterval();

    return (paddedMax / interval).ceil() * interval;
  }

  /// Calculates the minimum Y value for the chart.
  ///
  /// Applies bottom padding but ensures value is never negative.
  double calculateMinY() {
    if (_data.isEmpty) return 0;

    final minAmount = _getMinAmount();
    final paddedMin = minAmount * (1 - ChartConstants.bottomPaddingPercentage);

    return math.max(0, paddedMin);
  }

  /// Calculates the maximum X value based on data point count.
  double calculateMaxX() {
    return _data.isEmpty ? 0 : (_data.length - 1).toDouble();
  }

  /// Calculates the optimal grid interval for Y axis.
  ///
  /// Uses "nice numbers" to create visually pleasing intervals.
  double calculateGridInterval() {
    if (_data.isEmpty) return ChartConstants.axisInterval;

    final maxAmount = _getMaxAmount();
    final range = maxAmount * (1 + ChartConstants.topPaddingPercentage);
    final rawInterval = range / ChartConstants.desiredGridLines;

    return _roundToNiceInterval(rawInterval);
  }

  /// Generates all Y axis tick values at the calculated interval.
  List<double> getYAxisValues() {
    final interval = calculateGridInterval();
    final max = calculateMaxY();
    final min = calculateMinY();
    final values = <double>[];

    double value = min;
    while (value <= max + (interval * ChartConstants.precisionTolerance)) {
      values.add(value);
      value += interval;
    }

    return values;
  }

  /// Finds the maximum amount in the data set.
  double _getMaxAmount() {
    return _data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
  }

  /// Finds the minimum amount in the data set.
  double _getMinAmount() {
    return _data.map((e) => e.amount).reduce((a, b) => a < b ? a : b);
  }

  /// Rounds a raw interval to a "nice" number for better readability.
  ///
  /// Examples: 3.7 → 5.0, 0.12 → 0.2, 23 → 25
  double _roundToNiceInterval(double rawInterval) {
    if (rawInterval <= 0) return ChartConstants.axisInterval;

    final magnitude = math.pow(10, (math.log(rawInterval) / math.ln10).floor());
    final normalized = rawInterval / magnitude;
    final niceNumber = _getNiceNumber(normalized);

    return niceNumber * magnitude;
  }

  /// Selects the smallest nice number that is greater than or equal to the value.
  double _getNiceNumber(double value) {
    for (final nice in ChartConstants.niceNumbers) {
      if (value <= nice) {
        return nice;
      }
    }
    return ChartConstants.niceNumbers.last;
  }
}