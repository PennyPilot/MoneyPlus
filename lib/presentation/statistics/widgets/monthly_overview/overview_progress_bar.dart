import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/constants/design_constants.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import '../../../../domain/entity/monthly_overview.dart';

class OverviewProgressBar extends StatelessWidget {
  final MonthlyOverview overview;

  const OverviewProgressBar({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProgressBar(
          percentage: overview.incomePercentage,
          gradientColors: GradientColors.incomeGradient,
          shadowColor: GradientColors.incomeStart,
        ),
        const SizedBox(height: DesignConstants.spacingSmall),
        _ProgressBar(
          percentage: overview.expensePercentage,
          gradientColors: GradientColors.expenseGradient,
          shadowColor: GradientColors.expenseStart,
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double percentage;
  final List<Color> gradientColors;
  final Color shadowColor;

  const _ProgressBar({
    required this.percentage,
    required this.gradientColors,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final strokeColor = context.colors.stroke;

    return SizedBox(
      height: DesignConstants.progressBarHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final progressWidth = totalWidth * percentage;

          return Stack(
            children: [

              Container(
                height: DesignConstants.progressBarHeight,
                decoration: BoxDecoration(
                  color: strokeColor.withAlpha(DesignConstants.strokeAlpha),
                  borderRadius: BorderRadius.circular(
                    DesignConstants.radiusXLarge,
                  ),
                  border: Border.all(
                    color: strokeColor.withAlpha(DesignConstants.strokeAlpha),
                    width: DesignConstants.progressBarBackgroundBorderWidth,
                  ),
                ),
              ),

              if (progressWidth > 0)
                Container(
                  width: progressWidth.clamp(
                    DesignConstants.progressBarMinWidth,
                    totalWidth,
                  ),
                  height: DesignConstants.progressBarHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      DesignConstants.radiusXLarge,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: gradientColors,
                    ),
                    border: Border.all(
                      color: strokeColor.withAlpha(DesignConstants.strokeAlpha),
                      width: DesignConstants.progressBarBorderWidth,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor.withOpacity(
                          DesignConstants.progressBarShadowOpacity,
                        ),
                        offset: DesignConstants.progressBarShadowOffset,
                        blurRadius: DesignConstants.progressBarShadowBlur,
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
