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
        _AnimatedProgressBar(
          value: income,
          maxValue: maxValue,
          color: const Color(0xFF00BFA5),
          icon: Icons.account_balance_wallet,
        ),
        const SizedBox(height: 8),
        // Expenses Bar
        _AnimatedProgressBar(
          value: expenses,
          maxValue: maxValue,
          color: const Color(0xFFE91E63),
          icon: Icons.receipt_long,
        ),
      ],
    );
  }
}

class _AnimatedProgressBar extends StatelessWidget {
  final double value;
  final double maxValue;
  final Color color;
  final IconData icon;

  const _AnimatedProgressBar({
    required this.value,
    required this.maxValue,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (value / maxValue).clamp(0.0, 1.0);

    return Stack(
      children: [
        // Background
        Container(
          height: 32,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        // Progress
        FractionallySizedBox(
          widthFactor: percentage,
          child: Container(
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, color: Colors.white, size: 16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
