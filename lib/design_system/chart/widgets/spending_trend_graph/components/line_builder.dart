import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/data_point.dart';
import '../../../config/chart_theme.dart';
import '../../../config/chart_constants.dart';

/// Builder for chart line visualization.
///
/// This class follows the Single Responsibility Principle by focusing
/// solely on creating the line chart appearance.
class LineBuilder {
  final BuildContext _context;
  final List<DataPoint> _data;
  final int? _touchedIndex;

  const LineBuilder({
    required BuildContext context,
    required List<DataPoint> data,
    int? touchedIndex,
  })  : _context = context,
        _data = data,
        _touchedIndex = touchedIndex;

  /// Builds the line chart bar data with all styling.
  LineChartBarData build() {
    return LineChartBarData(
      spots: _createSpots(),
      isCurved: true,
      color: ChartTheme.getPrimaryColor(_context),
      barWidth: ChartConstants.lineWidth,
      isStrokeCapRound: true,
      dotData: _buildDotData(),
      belowBarData: _buildBelowBarData(),
    );
  }

  /// Converts data points to chart spots.
  List<FlSpot> _createSpots() {
    return _data
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              entry.value.amount,
            ))
        .toList();
  }

  /// Configures dot styling with touch interaction.
  FlDotData _buildDotData() {
    return FlDotData(
      show: true,
      getDotPainter: (spot, percent, barData, index) {
        final isTouched = index == _touchedIndex;
        final radius = isTouched
            ? ChartConstants.touchedDotRadius
            : ChartConstants.dotRadius;
        final strokeWidth = isTouched
            ? ChartConstants.touchedDotStrokeWidth
            : ChartConstants.dotStrokeWidth;

        return FlDotCirclePainter(
          radius: radius,
          color: ChartTheme.getPrimaryColor(_context),
          strokeWidth: strokeWidth,
          strokeColor: ChartTheme.getPrimaryColor(_context),
        );
      },
    );
  }

  /// Configures gradient area below the line.
  BarAreaData _buildBelowBarData() {
    return BarAreaData(
      show: true,
      gradient: LinearGradient(
        colors: [
          ChartTheme.getGradientStartColor(_context),
          ChartTheme.getGradientEndColor(_context),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }
}