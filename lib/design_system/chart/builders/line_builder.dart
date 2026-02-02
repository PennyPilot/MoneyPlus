import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../theme/chart_theme.dart';
import 'package:moneyplus/design_system/chart/models/data_point.dart';

class LineBuilder {

  static const double lineWidth = 2.0;
  static const double dotRadius = 0.0;
  static const double touchedDotRadius = 2.0;
  static const double dotStrokeWidth = 0.0;
  static const double touchedDotStrokeWidth = 2.0;

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

  LineChartBarData build() {
    return LineChartBarData(
      spots: _createSpots(),
      isCurved: true,
      color: ChartTheme.getPrimaryColor(_context),
      barWidth: lineWidth,
      isStrokeCapRound: true,
      dotData: _buildDotData(),
      belowBarData: _buildBelowBarData(),
    );
  }

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

  FlDotData _buildDotData() {
    return FlDotData(
      show: true,
      getDotPainter: (spot, percent, barData, index) {
        final isTouched = index == _touchedIndex;
        final radius = isTouched ? touchedDotRadius : dotRadius;
        final strokeWidth = isTouched ? touchedDotStrokeWidth : dotStrokeWidth;

        return FlDotCirclePainter(
          radius: radius,
          color: ChartTheme.getPrimaryColor(_context),
          strokeWidth: strokeWidth,
          strokeColor: ChartTheme.getPrimaryColor(_context),
        );
      },
    );
  }

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
