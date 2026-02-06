import 'package:flutter/material.dart';

class ProgressBarSection extends StatelessWidget {
  final double income;
  final double expenses;
  final double maxValue;

  const ProgressBarSection({
    super.key,
    required this.income,
    required this.expenses,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Income Bar
        _GradientProgressBar(
          value: income,
          maxValue: maxValue,
          gradientColors: const [Color(0xFF0496AD), Color(0xFF097C8E)],
          shadowColor: const Color(0xFF0496AD),
        ),
        const SizedBox(height: 8),
        // Expenses Bar
        _GradientProgressBar(
          value: expenses,
          maxValue: maxValue,
          gradientColors: const [Color(0xFFDC143C), Color(0xFFA01A35)],
          shadowColor: const Color(0xFFDC143C),
        ),
      ],
    );
  }
}

class _GradientProgressBar extends StatelessWidget {
  final double value;
  final double maxValue;
  final List<Color> gradientColors;
  final Color shadowColor;

  const _GradientProgressBar({
    required this.value,
    required this.maxValue,
    required this.gradientColors,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (value / maxValue).clamp(0.0, 1.0);

    return SizedBox(
      height: 20,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final progressWidth = totalWidth * percentage;

          return Stack(
            children: [
              // Background Track (Group 72) - Border only, no fill
              Container(
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0x1A1F1F1F), // #1F1F1F 10%
                    width: 1,
                  ),
                ),
              ),

              // Progress Bar (Rectangle 144)
              if (progressWidth > 0)
                Container(
                  width: progressWidth.clamp(20.0, totalWidth),
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: gradientColors,
                    ),
                    border: Border.all(
                      color: const Color(0x1A1F1F1F), // #1F1F1F 10%
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor.withOpacity(0.12), // 12% opacity
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                        spreadRadius: 0,
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