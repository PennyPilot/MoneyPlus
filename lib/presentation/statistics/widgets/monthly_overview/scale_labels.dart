import 'package:flutter/material.dart';

class ScaleLabels extends StatelessWidget {
  final double maxValue;

  const ScaleLabels({super.key, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    final labels = [
      '0',
      '15K',
      '50K',
      '150K',
      '300K',
      '600K',
      '1M',
      '1M500K',
      '2M',
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels.map((label) {
        return Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
        );
      }).toList(),
    );
  }
}
