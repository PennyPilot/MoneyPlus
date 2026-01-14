import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/data_point.dart';
import '../../../config/chart_theme.dart';
import '../utils/chart_formatter.dart';

class TouchHandler {
  final List<DataPoint> data;
  final String currency;
  final Function(int?) onTouch;

  const TouchHandler({
    required this.data,
    required this.currency,
    required this.onTouch,
  });

  LineTouchData build() {
    return LineTouchData(
      enabled: true,
      touchTooltipData: _buildTooltipData(),
      touchCallback: _handleTouch,
      handleBuiltInTouches: true,
      getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
        return spotIndexes.map((index) {
          return TouchedSpotIndicatorData(
            FlLine(
              color: Colors.transparent,
              strokeWidth: 0,
            ),
            FlDotData(show: false),
          );
        }).toList();
      },
    );
  }

  LineTouchTooltipData _buildTooltipData() {
    return LineTouchTooltipData(
      getTooltipColor: (LineBarSpot touchedSpot) => ChartTheme.tooltipBackground,
      tooltipBorderRadius: BorderRadius.circular(ChartTheme.tooltipRadius),
      tooltipPadding: const EdgeInsets.symmetric(
        horizontal: ChartTheme.tooltipPaddingHorizontal,
        vertical: ChartTheme.tooltipPaddingVertical,
      ),
      tooltipMargin: 12,
      tooltipBorder: BorderSide(
        color: ChartTheme.tooltipBorder,
        width: ChartTheme.tooltipBorderWidth,
      ),
      fitInsideHorizontally: true,
      fitInsideVertically: true,
      maxContentWidth: 200,
      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
        return touchedBarSpots.map((barSpot) {
          final index = barSpot.spotIndex;
          if (index < 0 || index >= data.length) {
            return null;
          }

          final date = data[index].date;
          final amount = barSpot.y;

          return LineTooltipItem(
            '${ChartFormatter.formatDate(date)}\n',
            ChartTheme.tooltipTextStyle,
            textAlign: TextAlign.left,
            children: [
              TextSpan(
                text: '${ChartFormatter.formatFullAmount(amount)} $currency',
                style: ChartTheme.tooltipTextStyle,
              ),
            ],
          );
        }).toList();
      },
    );
  }

  void _handleTouch(FlTouchEvent event, LineTouchResponse? touchResponse) {
    if (event is FlTapUpEvent ||
        event is FlPanEndEvent ||
        event is FlLongPressEnd) {
      onTouch(null);
      return;
    }

    if (touchResponse == null ||
        touchResponse.lineBarSpots == null ||
        touchResponse.lineBarSpots!.isEmpty) {
      onTouch(null);
      return;
    }

    onTouch(touchResponse.lineBarSpots!.first.spotIndex);
  }
}