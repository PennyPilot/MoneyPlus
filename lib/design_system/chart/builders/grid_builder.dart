import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../theme/chart_theme.dart';
import '../utils/chart_calculator.dart';

class GridBuilder {

  static const double strokeWidth = 1.0;
  static const double dashWidth = 4.0;
  static const double dashSpace = 4.0;

  final BuildContext _context;
  final ChartCalculator _calculator;

  const GridBuilder({
    required BuildContext context,
    required ChartCalculator calculator,
  })  : _context = context,
        _calculator = calculator;

  FlGridData build() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: _calculator.gridInterval,
      getDrawingHorizontalLine: _buildHorizontalLine,
    );
  }

  FlLine _buildHorizontalLine(double value) {
    return FlLine(
      color: ChartTheme.getGridLineColor(_context),
      strokeWidth: strokeWidth,
      dashArray: [
        dashWidth.toInt(),
        dashSpace.toInt(),
      ],
    );
  }
}
