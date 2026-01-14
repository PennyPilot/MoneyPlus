import 'package:flutter/material.dart';
import 'design_system/chart/models/data_point.dart';
import 'design_system/chart/widgets/spending_trend_graph/spending_trend_graph.dart';

class SpendingScreen extends StatelessWidget {
  const SpendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sampleData = _generateSampleData();

    return Scaffold(
      appBar: AppBar(title: const Text('Money Tracker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SpendingTrendGraph(
          data: sampleData,
          title: 'Spending Trend',
          currency: 'IDR',
        ),
      ),
    );
  }

  List<DataPoint> _generateSampleData() {
    return [
      DataPoint(date: DateTime(2023, 12, 1), amount: 50000),
      DataPoint(date: DateTime(2023, 12, 2), amount: 750),
      DataPoint(date: DateTime(2023, 12, 3), amount: 60),
      DataPoint(date: DateTime(2023, 12, 4), amount: 15),
      DataPoint(date: DateTime(2023, 12, 5), amount: 120),
      DataPoint(date: DateTime(2023, 12, 6), amount: 400),
      DataPoint(date: DateTime(2023, 12, 7), amount: 300),
      DataPoint(date: DateTime(2023, 12, 8), amount: 1000),
      DataPoint(date: DateTime(2023, 12, 4), amount: 15),
      DataPoint(date: DateTime(2023, 12, 5), amount: 12),
      DataPoint(date: DateTime(2023, 12, 6), amount: 40),
      DataPoint(date: DateTime(2023, 12, 7), amount: 30),

    ];
  }
}