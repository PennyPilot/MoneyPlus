import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/data_point.dart';
import '../../../config/chart_theme.dart';
import '../../../config/chart_constants.dart';
import '../utils/chart_calculator.dart';
import '../utils/chart_formatter.dart';

/// Builder for chart axis titles and labels.
///
/// This class follows the Single Responsibility Principle by focusing
/// solely on creating axis titles and labels.
class TitlesBuilder {
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

  /// Builds all axis titles configuration.
  FlTitlesData build() {
    return FlTitlesData(
      leftTitles: _buildLeftTitles(),
      bottomTitles: _buildBottomTitles(),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  /// Builds Y-axis (left) titles showing amount values.
  AxisTitles _buildLeftTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: _calculator.calculateGridInterval(),
        reservedSize: ChartConstants.leftAxisReservedSize,
        getTitlesWidget: _buildLeftTitleWidget,
      ),
    );
  }

  /// Creates a single Y-axis label widget.
  Widget _buildLeftTitleWidget(double value, TitleMeta meta) {
    return Text(
      ChartFormatter.formatAmount(value),
      style: ChartTheme.getAxisLabelStyle(_context).copyWith(
        color: ChartTheme.getTextSecondary(_context),
      ),
    );
  }

  /// Builds X-axis (bottom) titles showing dates.
  AxisTitles _buildBottomTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: ChartConstants.bottomAxisReservedSize,
        interval: ChartConstants.axisInterval,
        getTitlesWidget: _buildBottomTitleWidget,
      ),
    );
  }

  /// Creates a single X-axis label widget.
  Widget _buildBottomTitleWidget(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= _data.length) {
      return const SizedBox.shrink();
    }

    final date = _data[index].date;
    return Padding(
      padding: const EdgeInsets.only(
        top: ChartConstants.bottomAxisPaddingTop,
      ),
      child: Text(
        ChartFormatter.formatDate(date),
        style: ChartTheme.getAxisLabelStyle(_context).copyWith(
          color: ChartTheme.getTextSecondary(_context),
        ),
      ),
    );
  }
}