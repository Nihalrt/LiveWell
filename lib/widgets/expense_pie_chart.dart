// lib/widgets/expense_pie_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpensePieChart extends StatelessWidget {
  final Map<String, double> data;
  const ExpensePieChart({ super.key, required this.data });

  @override
  Widget build(BuildContext context) {
    final total = data.values.reduce((a, b) => a + b);
    final sections = data.entries.map((e) {
      final percent = (e.value / total) * 100;
      return PieChartSectionData(
        value: e.value,
        title: '${percent.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
      );
    }).toList();

    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 30,
        sections: sections,
      ),
    );
  }
}
