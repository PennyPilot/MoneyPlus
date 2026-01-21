import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../config/chart_theme.dart';
import '../../../config/chart_constants.dart';
import '../utils/chart_calculator.dart';

/// Builder for chart grid lines.
///
/// This class follows the Single Responsibility Principle by focusing
/// solely on creating the grid appearance.
class GridBuilder {
  final BuildContext _context;
  final ChartCalculator _calculator;

  const GridBuilder({
    required BuildContext context,
    required ChartCalculator calculator,
  })  : _context = context,
        _calculator = calculator;

  /// Builds the grid data with horizontal dashed lines.
  FlGridData build() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: _calculator.calculateGridInterval(),
      getDrawingHorizontalLine: _buildHorizontalLine,
    );
  }

  /// Creates a single horizontal grid line with dashed styling.
  FlLine _buildHorizontalLine(double value) {
    return FlLine(
      color: ChartTheme.getGridLineColor(_context),
      strokeWidth: ChartConstants.gridStrokeWidth,
      dashArray: [
        ChartConstants.dashWidth.toInt(),
        ChartConstants.dashSpace.toInt(),
      ],
    );
  }
}