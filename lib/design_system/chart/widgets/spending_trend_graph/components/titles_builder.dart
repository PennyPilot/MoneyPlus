import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/data_point.dart';
import '../../../config/chart_theme.dart';
import '../utils/chart_calculator.dart';
import '../utils/chart_formatter.dart';

class TitlesBuilder {
  final List<DataPoint> data;
  final ChartCalculator calculator;

  const TitlesBuilder({
    required this.data,
    required this.calculator,
  });

  FlTitlesData build() {
    return FlTitlesData(
      leftTitles: _buildLeftTitles(),
      bottomTitles: _buildBottomTitles(),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  AxisTitles _buildLeftTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: calculator.calculateGridInterval(),
        reservedSize: 50,
        getTitlesWidget: (value, meta) {
          return Text(
            ChartFormatter.formatAmount(value),
            style: ChartTheme.axisLabelStyle.copyWith(
              color: ChartTheme.textSecondary,
            ),
          );
        },
      ),
    );
  }

  AxisTitles _buildBottomTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        interval: 1,
        getTitlesWidget: (value, meta) {
          final index = value.toInt();
          if (index < 0 || index >= data.length) {
            return const SizedBox.shrink();
          }

          final date = data[index].date;
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              ChartFormatter.formatDate(date),
              style: ChartTheme.axisLabelStyle.copyWith(
                color: ChartTheme.textSecondary,
              ),
            ),
          );
        },
      ),
    );
  }
}