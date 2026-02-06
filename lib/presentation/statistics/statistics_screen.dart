import 'package:flutter/material.dart';

import 'widgets/monthly_overview/monthly_overview.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: MonthlyOverview(
          income: 1500000,
          expenses: 850000,
          currency: 'IQD',
          maxValue: 2000000,
        ),
      ),
    );
  }
}