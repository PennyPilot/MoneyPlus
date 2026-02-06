import 'package:flutter/material.dart';
import '../../utils.dart';

class SummaryCard extends StatelessWidget {
  final Widget icon;
  final Color iconBackgroundColor;
  final String label;
  final double value;
  final String currency;
  final bool isPositive;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.label,
    required this.value,
    required this.currency,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${isPositive ? '+' : '-'}${formatNumber(value)} $currency',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: iconBackgroundColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
