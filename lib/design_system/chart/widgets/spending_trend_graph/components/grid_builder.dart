import 'package:fl_chart/fl_chart.dart';
import '../../../config/chart_theme.dart';
import '../utils/chart_calculator.dart';

class GridBuilder {
  final ChartCalculator calculator;

  const GridBuilder(this.calculator);

  FlGridData build() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: calculator.calculateGridInterval(),
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: ChartTheme.gridLineColor,
          strokeWidth: 1,
          dashArray: [
            ChartTheme.dashWidth.toInt(),
            ChartTheme.dashSpace.toInt(),
          ],
        );
      },
    );
  }
}