import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/data_point.dart';
import '../../../config/chart_theme.dart';

class LineBuilder {
  final List<DataPoint> data;
  final int? touchedIndex;

  const LineBuilder({
    required this.data,
    this.touchedIndex,
  });

  LineChartBarData build() {
    return LineChartBarData(
      spots: _createSpots(),
      isCurved: true,
      color: ChartTheme.lineColor,
      barWidth: ChartTheme.lineWidth,
      isStrokeCapRound: true,
      dotData: _buildDotData(),
      belowBarData: _buildBelowBarData(),
    );
  }

  List<FlSpot> _createSpots() {
    return data
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
        final isTouched = index == touchedIndex;
        return FlDotCirclePainter(
          radius: isTouched
              ? ChartTheme.touchedDotRadius
              : ChartTheme.dotRadius,
          color: ChartTheme.lineColor,
          strokeWidth: isTouched
              ? ChartTheme.touchedDotStrokeWidth
              : ChartTheme.dotStrokeWidth,
          strokeColor: ChartTheme.lineColor,
        );
      },
    );
  }

  BarAreaData _buildBelowBarData() {
    return BarAreaData(
      show: true,
      gradient: LinearGradient(
        colors: [
          ChartTheme.gradientStart.withOpacity(ChartTheme.gradientStartOpacity),
          ChartTheme.gradientEnd.withOpacity(ChartTheme.gradientEndOpacity),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }
}