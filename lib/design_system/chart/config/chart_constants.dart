/// Chart configuration constants
///
/// This class centralizes all magic numbers and configuration values
/// used throughout the chart package to follow DRY principle.
class ChartConstants {
  ChartConstants._();

  // Chart Dimensions
  static const double chartHeight = 200.0;
  static const double containerPadding = 16.0;
  static const double titleSpacing = 20.0;
  static const double borderRadius = 12.0;

  // Line Styling
  static const double lineWidth = 2.0;
  static const double dotRadius = 0.0;
  static const double touchedDotRadius = 4.0;
  static const double dotStrokeWidth = 0.0;
  static const double touchedDotStrokeWidth = 2.0;

  // Grid Configuration
  static const int desiredGridLines = 7;
  static const double gridStrokeWidth = 1.0;
  static const double dashWidth = 4.0;
  static const double dashSpace = 4.0;

  // Padding Percentages
  static const double topPaddingPercentage = 0.2;
  static const double bottomPaddingPercentage = 0.0;

  // Tooltip Configuration
  static const double tooltipRadius = 8.0;
  static const double tooltipPaddingHorizontal = 12.0;
  static const double tooltipPaddingVertical = 8.0;
  static const double tooltipBorderWidth = 0.5;
  static const double tooltipMargin = 12.0;
  static const double tooltipMaxContentWidth = 200.0;

  // Axis Title Configuration
  static const double leftAxisReservedSize = 50.0;
  static const double bottomAxisReservedSize = 30.0;
  static const double bottomAxisPaddingTop = 8.0;
  static const double axisInterval = 1.0;

  // Shadow Configuration
  static const double shadowSpreadRadius = 1.0;
  static const double shadowBlurRadius = 10.0;
  static const double shadowOpacity = 0.1;

  // Gradient Opacity
  static const double gradientStartOpacity = 0.32;
  static const double gradientEndOpacity = 0.0;

  // Formatting Thresholds
  static const double millionThreshold = 1000000.0;
  static const double thousandThreshold = 1000.0;

  // Nice Numbers for Grid Intervals
  static const List<double> niceNumbers = [1.0, 2.0, 2.5, 5.0, 10.0];

  // Scrolling Configuration
  static const double minWidthPerDataPoint = 50.0;
  static const int maxDataPointsBeforeScroll = 7;

  // Precision Tolerance
  static const double precisionTolerance = 0.001;
}
