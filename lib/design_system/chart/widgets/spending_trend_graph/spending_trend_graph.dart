import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../models/data_point.dart';
import '../../config/chart_theme.dart';
import '../../config/chart_constants.dart';
import 'components/line_builder.dart';
import 'components/grid_builder.dart';
import 'components/titles_builder.dart';
import 'components/touch_handler.dart';
import 'utils/chart_calculator.dart';

/// A widget that displays a spending trend line chart.
///
/// This widget follows clean code principles:
/// - Uses localization for all text
/// - Integrates with app theme system
/// - Extracts all magic numbers to constants
/// - Implements horizontal scrolling for long data sets
/// - Follows Single Responsibility Principle
class SpendingTrendGraph extends StatefulWidget {
  final List<DataPoint> data;
  final String? title;
  final String currency;

  const SpendingTrendGraph({
    super.key,
    required this.data,
    this.title,
    required this.currency,
  });

  @override
  State<SpendingTrendGraph> createState() => _SpendingTrendGraphState();
}

class _SpendingTrendGraphState extends State<SpendingTrendGraph> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ChartConstants.containerPadding),
      decoration: _buildContainerDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context),
          const SizedBox(height: ChartConstants.titleSpacing),
          _buildChartContent(context),
        ],
      ),
    );
  }

  /// Builds the container decoration with theme-aware colors.
  BoxDecoration _buildContainerDecoration(BuildContext context) {
    return BoxDecoration(
      color: ChartTheme.getSurfaceColor(context),
      borderRadius: BorderRadius.circular(ChartConstants.borderRadius),
      boxShadow: ChartTheme.getChartShadow(context),
    );
  }

  /// Builds the chart title using localized text.
  Widget _buildTitle(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final titleText = widget.title ?? localizations?.spendingTrend ?? 'Spending Trend';

    return Text(
      titleText,
      style: ChartTheme.getTitleStyle(context),
    );
  }

  /// Builds the chart content with optional horizontal scrolling.
  Widget _buildChartContent(BuildContext context) {
    if (widget.data.isEmpty) {
      return _buildEmptyState(context);
    }

    return _shouldEnableScrolling()
        ? _buildScrollableChart(context)
        : _buildStaticChart(context);
  }

  /// Determines if horizontal scrolling should be enabled.
  ///
  /// Scrolling is enabled when data points exceed the threshold.
  bool _shouldEnableScrolling() {
    return widget.data.length > ChartConstants.maxDataPointsBeforeScroll;
  }

  /// Builds a scrollable chart for large data sets.
  Widget _buildScrollableChart(BuildContext context) {
    final chartWidth = _calculateChartWidth();

    return SizedBox(
      height: ChartConstants.chartHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: chartWidth,
          height: ChartConstants.chartHeight,
          child: _buildChart(context),
        ),
      ),
    );
  }

  /// Builds a static (non-scrollable) chart.
  Widget _buildStaticChart(BuildContext context) {
    return SizedBox(
      height: ChartConstants.chartHeight,
      child: _buildChart(context),
    );
  }

  /// Calculates the width needed for scrollable chart.
  ///
  /// Ensures minimum width per data point for readability.
  double _calculateChartWidth() {
    return widget.data.length * ChartConstants.minWidthPerDataPoint;
  }

  /// Builds the empty state when no data is available.
  Widget _buildEmptyState(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return SizedBox(
      height: ChartConstants.chartHeight,
      child: Center(
        child: Text(
          localizations?.noDataAvailable ?? 'No data available',
          style: ChartTheme.getEmptyStateStyle(context).copyWith(
            color: ChartTheme.getTextSecondary(context),
          ),
        ),
      ),
    );
  }

  /// Builds the actual line chart.
  Widget _buildChart(BuildContext context) {
    return LineChart(_buildChartData(context));
  }

  /// Builds the chart data configuration.
  ///
  /// Delegates to specialized builder classes following SRP.
  LineChartData _buildChartData(BuildContext context) {
    final calculator = ChartCalculator(widget.data);

    final lineBuilder = LineBuilder(
      context: context,
      data: widget.data,
      touchedIndex: _touchedIndex,
    );

    final gridBuilder = GridBuilder(
      context: context,
      calculator: calculator,
    );

    final titlesBuilder = TitlesBuilder(
      context: context,
      data: widget.data,
      calculator: calculator,
    );

    final touchHandler = TouchHandler(
      context: context,
      data: widget.data,
      currency: widget.currency,
      onTouch: _updateTouchedIndex,
    );

    return LineChartData(
      lineTouchData: touchHandler.build(),
      gridData: gridBuilder.build(),
      titlesData: titlesBuilder.build(),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: calculator.calculateMaxX(),
      minY: calculator.calculateMinY(),
      maxY: calculator.calculateMaxY(),
      lineBarsData: [lineBuilder.build()],
    );
  }

  /// Updates the touched index and triggers rebuild.
  void _updateTouchedIndex(int? index) {
    if (mounted) {
      setState(() {
        _touchedIndex = index;
      });
    }
  }
}