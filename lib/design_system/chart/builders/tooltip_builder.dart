import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../theme/chart_theme.dart';
import 'package:moneyplus/design_system/chart/models/data_point.dart';
import '../utils/amount_formatter.dart';
import '../utils/date_formatter.dart';

class ChartTooltipBuilder {
  static const double radius = 8.0;
  static const double paddingHorizontal = 5.5;
  static const double paddingVertical = 4.0;
  static const double margin = 12.0;
  static const double maxContentWidth = 200.0;
  static const double borderWidth = 0.5;

  final BuildContext _context;
  final List<DataPoint> _data;
  final String _currency;

  const ChartTooltipBuilder({
    required BuildContext context,
    required List<DataPoint> data,
    required String currency,
  }) : _context = context,
       _data = data,
       _currency = currency;

  LineTouchTooltipData buildTooltipData() {
    return LineTouchTooltipData(
      getTooltipColor: (_) => ChartTheme.getTooltipBackground(_context),
      tooltipBorderRadius: BorderRadius.only(
        bottomRight: Radius.circular(2),
        bottomLeft: Radius.circular(radius),
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      ),
      tooltipPadding: const EdgeInsets.symmetric(
        horizontal: paddingHorizontal,
        vertical: paddingVertical,
      ),
      tooltipHorizontalAlignment: .left,
      tooltipHorizontalOffset: 0,
      tooltipMargin: margin,
      fitInsideHorizontally: true,
      fitInsideVertically: true,
      maxContentWidth: maxContentWidth,
      getTooltipItems: _buildTooltipItems,
    );
  }

  List<LineTooltipItem?> _buildTooltipItems(List<LineBarSpot> touchedBarSpots) {
    return touchedBarSpots.map((barSpot) {
      final index = barSpot.spotIndex;
      if (index < 0 || index >= _data.length) {
        return null;
      }

      final date = _data[index].date;
      final amount = barSpot.y;
      final textStyle = ChartTheme.getTooltipTextStyle(_context);

      return LineTooltipItem(
        '${DateFormatter.format(date)}\n',
        textStyle,
        textAlign: TextAlign.left,
        children: [
          TextSpan(
            text: AmountFormatter.formatWithCurrency(amount, _currency),
            style: textStyle,
          ),
        ],
      );
    }).toList();
  }

  List<TouchedSpotIndicatorData> buildSpotIndicators(
    LineChartBarData barData,
    List<int> spotIndexes,
  ) {
    return spotIndexes.map((_) {
      return TouchedSpotIndicatorData(
        const FlLine(color: Colors.transparent, strokeWidth: 0),
        FlDotData(show: false),
      );
    }).toList();
  }
}
