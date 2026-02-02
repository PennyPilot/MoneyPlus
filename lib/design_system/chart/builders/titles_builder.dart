import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../theme/chart_theme.dart';
import '../utils/amount_formatter.dart';
import '../utils/chart_calculator.dart';
import 'package:moneyplus/design_system/chart/models/data_point.dart';
import '../utils/date_formatter.dart';

class TitlesBuilder {

  static const double leftAxisReservedSize = 40.0;
  static const double bottomAxisReservedSize = 30.0;
  static const double bottomAxisPaddingTop = 16.0;
  static const double axisInterval = 1.0;

  final BuildContext _context;
  final List<DataPoint> _data;
  final ChartCalculator _calculator;

  const TitlesBuilder({
    required BuildContext context,
    required List<DataPoint> data,
    required ChartCalculator calculator,
  })  : _context = context,
        _data = data,
        _calculator = calculator;

  FlTitlesData build() {
    return FlTitlesData(
      leftTitles: _buildLeftTitles(),
      bottomTitles: _buildBottomTitles(),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 12, // Reserve space for half of the top label height
          getTitlesWidget: _buildEmptyTitleWidget,
        ),
      ),
    );
  }

  AxisTitles _buildLeftTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: _calculator.gridInterval,
        reservedSize: leftAxisReservedSize,
        getTitlesWidget: _buildLeftTitleWidget,
      ),
    );
  }

  Widget _buildLeftTitleWidget(double value, TitleMeta meta) {
    return Text(
      AmountFormatter.formatCompact(value),
      style: ChartTheme.getAxisLabelStyle(_context).copyWith(
        color: ChartTheme.getTextSecondary(_context),
      ),
    );
  }

  AxisTitles _buildBottomTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: bottomAxisReservedSize,
        interval: axisInterval,
        getTitlesWidget: _buildBottomTitleWidget,
      ),
    );
  }

  Widget _buildBottomTitleWidget(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= _data.length) {
      return const SizedBox.shrink();
    }

    final date = _data[index].date;
    return Padding(
      padding: const EdgeInsets.only(
        top: bottomAxisPaddingTop,
      ),
      child: Text(
        DateFormatter.format(date),
        style: ChartTheme.getAxisLabelStyle(_context).copyWith(
          color: ChartTheme.getTextSecondary(_context),
        ),
      ),
    );
  }
  static Widget _buildEmptyTitleWidget(double value, TitleMeta meta) {
    return const SizedBox.shrink();
  }
}
