import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/data_point.dart';
import '../../config/chart_theme.dart';
import 'components/line_builder.dart';
import 'components/grid_builder.dart';
import 'components/titles_builder.dart';
import 'components/touch_handler.dart';
import 'utils/chart_calculator.dart';

class SpendingTrendGraph extends StatefulWidget {
  final List<DataPoint> data;
  final String title;
  final String currency;

  const SpendingTrendGraph({
    super.key,
    required this.data,
    this.title = 'Spending Trend',
    this.currency = 'IDR',
  });

  @override
  State<SpendingTrendGraph> createState() => _SpendingTrendGraphState();
}

class _SpendingTrendGraphState extends State<SpendingTrendGraph> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ChartTheme.containerPadding),
      decoration: _buildContainerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: ChartTheme.titleSpacing),
          _buildChart(),
        ],
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(ChartTheme.borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 10,
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.title,
      style: ChartTheme.titleStyle,
    );
  }

  Widget _buildChart() {
    if (widget.data.isEmpty) {
      return _buildEmptyState();
    }

    return SizedBox(
      height: ChartTheme.chartHeight,
      child: LineChart(
        _buildChartData(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: ChartTheme.chartHeight,
      child: Center(
        child: Text(
          'No data available',
          style: ChartTheme.axisLabelStyle.copyWith(
            color: ChartTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  LineChartData _buildChartData() {
    final calculator = ChartCalculator(widget.data);

    final lineBuilder = LineBuilder(
      data: widget.data,
      touchedIndex: _touchedIndex,
    );

    final gridBuilder = GridBuilder(calculator);

    final titlesBuilder = TitlesBuilder(
      data: widget.data,
      calculator: calculator,
    );

    final touchHandler = TouchHandler(
      data: widget.data,
      currency: widget.currency,
      onTouch: (index) {
        if (mounted) {
          setState(() {
            _touchedIndex = index;
          });
        }
      },
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
}