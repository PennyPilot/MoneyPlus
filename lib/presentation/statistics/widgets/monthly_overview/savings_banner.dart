import 'package:flutter/material.dart';

import '../../utils.dart';

class SavingsBanner extends StatelessWidget {
  final double savings;
  final String currency;

  const SavingsBanner({super.key,
    required this.savings,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5F2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF00BFA5),
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'You saved ${formatNumber(savings)} $currency this month',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF00897B),
            ),
          ),
        ],
      ),
    );
  }
}