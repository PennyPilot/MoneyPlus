import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/data_point.dart';
import '../../../config/chart_theme.dart';
import '../../../config/chart_constants.dart';
import '../utils/chart_formatter.dart';

/// Touch callback function type for handling touch events.
typedef TouchCallback = void Function(int?);

/// Handler for chart touch interactions and tooltips.
///
/// This class follows the Single Responsibility Principle by focusing
/// solely on touch interaction and tooltip display.
class TouchHandler {
  final BuildContext _context;
  final List<DataPoint> _data;
  final String _currency;
  final TouchCallback _onTouch;

  const TouchHandler({
    required BuildContext context,
    required List<DataPoint> data,
    required String currency,
    required TouchCallback onTouch,
  })  : _context = context,
        _data = data,
        _currency = currency,
        _onTouch = onTouch;

  /// Builds touch interaction configuration.
  LineTouchData build() {
    return LineTouchData(
      enabled: true,
      touchTooltipData: _buildTooltipData(),
      touchCallback: _handleTouch,
      handleBuiltInTouches: true,
      getTouchedSpotIndicator: _buildSpotIndicator,
    );
  }

  /// Configures tooltip appearance and content.
  LineTouchTooltipData _buildTooltipData() {
    return LineTouchTooltipData(
      getTooltipColor: (_) => ChartTheme.getTooltipBackground(_context),
      tooltipBorderRadius: BorderRadius.circular(ChartConstants.tooltipRadius),
      tooltipPadding: const EdgeInsets.symmetric(
        horizontal: ChartConstants.tooltipPaddingHorizontal,
        vertical: ChartConstants.tooltipPaddingVertical,
      ),
      tooltipMargin: ChartConstants.tooltipMargin,
      tooltipBorder: BorderSide(
        color: ChartTheme.getTooltipBorder(_context),
        width: ChartConstants.tooltipBorderWidth,
      ),
      fitInsideHorizontally: true,
      fitInsideVertically: true,
      maxContentWidth: ChartConstants.tooltipMaxContentWidth,
      getTooltipItems: _buildTooltipItems,
    );
  }

  /// Creates tooltip content for touched spots.
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
        '${ChartFormatter.formatDate(date)}\n',
        textStyle,
        textAlign: TextAlign.left,
        children: [
          TextSpan(
            text: '${ChartFormatter.formatFullAmount(amount)} $_currency',
            style: textStyle,
          ),
        ],
      );
    }).toList();
  }

  /// Builds transparent indicators (we don't show vertical lines).
  List<TouchedSpotIndicatorData> _buildSpotIndicator(
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

  /// Handles touch events and updates touched index.
  void _handleTouch(FlTouchEvent event, LineTouchResponse? touchResponse) {
    // Clear touch on tap up, pan end, or long press end
    if (event is FlTapUpEvent ||
        event is FlPanEndEvent ||
        event is FlLongPressEnd) {
      _onTouch(null);
      return;
    }

    // Clear touch if no valid response
    if (touchResponse == null ||
        touchResponse.lineBarSpots == null ||
        touchResponse.lineBarSpots!.isEmpty) {
      _onTouch(null);
      return;
    }

    // Update touched spot
    _onTouch(touchResponse.lineBarSpots!.first.spotIndex);
  }
}