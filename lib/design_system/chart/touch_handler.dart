import 'package:fl_chart/fl_chart.dart';
import 'builders/tooltip_builder.dart';

typedef TouchCallback = void Function(int?);

class TouchHandler {

  final ChartTooltipBuilder _tooltipBuilder;
  final TouchCallback _onTouch;

  const TouchHandler({
    required ChartTooltipBuilder tooltipProvider,
    required TouchCallback onTouch,
  }) : _tooltipBuilder = tooltipProvider,
       _onTouch = onTouch;

  LineTouchData build() {
    return LineTouchData(
      enabled: true,
      touchTooltipData: _tooltipBuilder.buildTooltipData(),
      touchCallback: _handleTouch,
      handleBuiltInTouches: true,
      getTouchedSpotIndicator: _tooltipBuilder.buildSpotIndicators,
    );
  }

  void _handleTouch(FlTouchEvent event, LineTouchResponse? touchResponse) {
    if (event is FlTapUpEvent ||
        event is FlPanEndEvent ||
        event is FlLongPressEnd) {
      _onTouch(null);
      return;
    }

    if (touchResponse == null ||
        touchResponse.lineBarSpots == null ||
        touchResponse.lineBarSpots!.isEmpty) {
      _onTouch(null);
      return;
    }

    _onTouch(touchResponse.lineBarSpots!.first.spotIndex);
  }
}
