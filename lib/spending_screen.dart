import 'package:flutter/material.dart';
import 'design_system/chart/models/data_point.dart';
import 'design_system/chart/spending_trend_graph.dart';

class SpendingScreen extends StatelessWidget {
  const SpendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final normalData = _generateNormalData();
    final longData = _generateLongData();

    return Scaffold(
      appBar: AppBar(title: const Text('Money Tracker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Normal chart (no scrolling) - uses localized title
            SpendingTrendGraph(
              data: normalData,
              currency: 'IDR',
            ),
            const SizedBox(height: 24),
            // Long chart (with scrolling)
            SpendingTrendGraph(
              data: longData,
              title: 'Long Data Chart (Scrollable)',
              currency: 'USD',
            ),
          ],
        ),
      ),
    );
  }

  /// Generates normal data (< 7 points, no scrolling)
  List<DataPoint> _generateNormalData() {
    return [
      DataPoint(date: DateTime(2023, 12, 1), amount: 50000),
      DataPoint(date: DateTime(2023, 12, 2), amount: 75000),
      DataPoint(date: DateTime(2023, 12, 3), amount: 60000),
      DataPoint(date: DateTime(2023, 12, 4), amount: 85000),
      DataPoint(date: DateTime(2023, 12, 5), amount: 120000),
      DataPoint(date: DateTime(2023, 12, 6), amount: 95000),
    ];
  }

  /// Generates long data (> 7 points, triggers scrolling)
  List<DataPoint> _generateLongData() {
    return List.generate(30, (index) {
      return DataPoint(
        date: DateTime(2023, 12, index + 1),
        amount: 50000 + (index * 10000) + (index.isEven ? 5000 : -3000),
      );
    });
  }
}