import 'package:flutter/material.dart';
import 'services/gemini_service.dart';

class ResultsPage extends StatefulWidget {
  final String location;
  final double salary;
  final Map<String, double> expensesMap;
  final int householdSize;
  final String ageBracket;

  const ResultsPage({
    super.key,
    required this.location,
    required this.salary,
    required this.expensesMap,
    required this.householdSize,
    required this.ageBracket,
  });

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late Future<List<String>> _tipsFuture;

  double get _totalExpenses =>
      widget.expensesMap.values.fold(0.0, (sum, v) => sum + v);

  String get _feasibility {
    final ratio = _totalExpenses / widget.salary;
    if (ratio < 0.5) return 'Feasible';
    if (ratio < 0.8) return 'Marginal';
    return 'Not Feasible';
  }

  Color get _feasibilityColor {
    switch (_feasibility) {
      case 'Feasible':
        return Colors.green;
      case 'Marginal':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  @override
  void initState() {
    super.initState();
    GeminiService().listModels(); // debug
    _tipsFuture = GeminiService().getRecommendations(
      location: widget.location,
      salary: widget.salary,
      expenses: widget.expensesMap,
      householdSize: widget.householdSize,
      ageBracket: widget.ageBracket,
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Section
              _buildSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location', style: Theme.of(context).textTheme.labelLarge),
                    Text(widget.location, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Household Size: ${widget.householdSize}'),
                    Text('Age Bracket: ${widget.ageBracket}'),
                  ],
                ),
              ),

              // Salary & Feasibility
              _buildSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Monthly Salary', style: Theme.of(context).textTheme.labelLarge),
                    Text('\$${widget.salary.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Text('Total Expenses', style: Theme.of(context).textTheme.labelLarge),
                    Text('\$${_totalExpenses.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Center(
                      child: Chip(
                        label: Text(_feasibility,
                            style: const TextStyle(color: Colors.white)),
                        backgroundColor: _feasibilityColor,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),

              // Expense Breakdown
              _buildSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Expense Breakdown', style: Theme.of(context).textTheme.labelLarge),
                    const Divider(),
                    ...widget.expensesMap.entries.map((entry) {
                      final pct = _totalExpenses > 0
                          ? (entry.value / _totalExpenses * 100).toStringAsFixed(1)
                          : '0.0';
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key),
                            Text('\$${entry.value.toStringAsFixed(2)} ($pct%)'),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

              // AI Tips Section
              Text('Smart Tips & Recommendations',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),

              FutureBuilder<List<String>>(
                future: _tipsFuture,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return Text('Error: ${snap.error}',
                        style: const TextStyle(color: Colors.red));
                  }
                  final tips = snap.data!;
                  return Column(
                    children: tips.map((tip) {
                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.lightbulb, size: 20, color: Colors.teal),
                              const SizedBox(width: 8),
                              Expanded(child: Text(tip)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
