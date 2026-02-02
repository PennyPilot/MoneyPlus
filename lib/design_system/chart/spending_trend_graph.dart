import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/chart/touch_handler.dart';
import 'package:moneyplus/design_system/chart/models/data_point.dart';
import 'builders/grid_builder.dart';
import 'builders/line_builder.dart';
import 'builders/titles_builder.dart';
import 'builders/tooltip_builder.dart';
import 'theme/chart_theme.dart';
import 'utils/chart_calculator.dart';

class SpendingTrendGraph extends StatefulWidget {

  static const double chartHeight = 238.0;
  static const double containerPadding = 12.0;
  static const double titleSpacing = 16.0;
  static const double borderRadius = 12.0;
  static const double minWidthPerDataPoint = 50.0;
  static const int maxDataPointsBeforeScroll = 7;

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
      padding: const EdgeInsets.all(SpendingTrendGraph.containerPadding),
      decoration: _buildContainerDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context),
          const SizedBox(height: SpendingTrendGraph.titleSpacing),
          _buildChartContent(context),
        ],
      ),
    );
  }

  BoxDecoration _buildContainerDecoration(BuildContext context) {
    return BoxDecoration(
      color: ChartTheme.getSurfaceColor(context),
      borderRadius: BorderRadius.circular(SpendingTrendGraph.borderRadius),
      boxShadow: ChartTheme.getChartShadow(context),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final titleText =
        widget.title ?? localizations?.spendingTrend ?? '';

    return Text(
      titleText,
      style: ChartTheme.getTitleStyle(context),
    );
  }

  Widget _buildChartContent(BuildContext context) {
    if (widget.data.isEmpty) {
      return _buildEmptyState(context);
    }

    return _shouldEnableScrolling()
        ? _buildScrollableChart(context)
        : _buildStaticChart(context);
  }

  bool _shouldEnableScrolling() {
    return widget.data.length > SpendingTrendGraph.maxDataPointsBeforeScroll;
  }

  Widget _buildScrollableChart(BuildContext context) {
    final chartWidth = _calculateChartWidth();

    return SizedBox(
      height: SpendingTrendGraph.chartHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: chartWidth,
          height: SpendingTrendGraph.chartHeight,
          child: _buildChart(context),
        ),
      ),
    );
  }

  Widget _buildStaticChart(BuildContext context) {
    return SizedBox(
      height: SpendingTrendGraph.chartHeight,
      child: _buildChart(context),
    );
  }

  double _calculateChartWidth() {
    return widget.data.length * SpendingTrendGraph.minWidthPerDataPoint;
  }

  Widget _buildEmptyState(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return SizedBox(
      height: SpendingTrendGraph.chartHeight,
      child: Center(
        child: Text(
          localizations?.noDataAvailable ?? '',
          style: ChartTheme.getEmptyStateStyle(context).copyWith(
            color: ChartTheme.getTextSecondary(context),
          ),
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    return LineChart(_buildChartData(context));
  }

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

    final tooltipBuilder = ChartTooltipBuilder(
      context: context,
      data: widget.data,
      currency: widget.currency,
    );

    final touchHandler = TouchHandler(
      tooltipProvider: tooltipBuilder,
      onTouch: _updateTouchedIndex,
    );

    return LineChartData(
      lineTouchData: touchHandler.build(),
      gridData: gridBuilder.build(),
      titlesData: titlesBuilder.build(),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: calculator.maxX,
      minY: calculator.minY,
      maxY: calculator.maxY,
      lineBarsData: [lineBuilder.build()],
    );
  }

  void _updateTouchedIndex(int? index) {
    if (mounted) {
      setState(() {
        _touchedIndex = index;
      });
    }
  }
}