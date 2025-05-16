import 'package:flutter/material.dart';
import 'results_page.dart';

class SalaryInputPage extends StatefulWidget {
  const SalaryInputPage({super.key});

  @override
  State<SalaryInputPage> createState() => _SalaryInputPageState();
}

class _SalaryInputPageState extends State<SalaryInputPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for basic info
  final _locationController = TextEditingController();
  final _salaryController   = TextEditingController();

  // Controllers for expense categories
  final _housingController      = TextEditingController();
  final _utilitiesController    = TextEditingController();
  final _foodController         = TextEditingController();
  final _transportController    = TextEditingController();
  final _insuranceController    = TextEditingController();
  final _otherController        = TextEditingController();

  // Controllers for household & age
  final _householdController    = TextEditingController();
  String? _selectedAgeBracket;
  final List<String> _ageBrackets = [
    'Under 30',
    '30–49',
    '50+',
  ];

  @override
  void dispose() {
    // Dispose all controllers
    _locationController.dispose();
    _salaryController.dispose();
    _housingController.dispose();
    _utilitiesController.dispose();
    _foodController.dispose();
    _transportController.dispose();
    _insuranceController.dispose();
    _otherController.dispose();
    _householdController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    // Build a map of expenses
    final expenses = <String, double>{
      'Housing':   double.parse(_housingController.text),
      'Utilities': double.parse(_utilitiesController.text),
      'Food':      double.parse(_foodController.text),
      'Transport': double.parse(_transportController.text),
      'Insurance': double.parse(_insuranceController.text),
      'Other':     double.parse(_otherController.text),
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsPage(
          location:      _locationController.text.trim(),
          salary:        double.parse(_salaryController.text),
          expensesMap:   expenses,
          householdSize: int.parse(_householdController.text),
          ageBracket:    _selectedAgeBracket!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Budget')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView(
              children: [
                // Desired Location
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Desired Location',
                    hintText: 'e.g. Vancouver, BC',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                  (v == null || v.trim().isEmpty)
                      ? 'Enter where you want to live'
                      : null,
                ),
                const SizedBox(height: 16),

                // Monthly Salary
                TextFormField(
                  controller: _salaryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monthly Salary',
                    prefixText: '\$',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your salary';
                    if (double.tryParse(v) == null) return 'Enter a number';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Expense Breakdown Header
                const Text(
                  'Monthly Expenses Breakdown',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Housing
                _buildExpenseField('Housing (Rent/Mortgage)', _housingController),
                const SizedBox(height: 12),

                // Utilities
                _buildExpenseField('Utilities', _utilitiesController),
                const SizedBox(height: 12),

                // Groceries & Dining
                _buildExpenseField('Groceries & Dining', _foodController),
                const SizedBox(height: 12),

                // Transportation
                _buildExpenseField('Transportation', _transportController),
                const SizedBox(height: 12),

                // Insurance & Healthcare
                _buildExpenseField('Insurance & Healthcare', _insuranceController),
                const SizedBox(height: 12),

                // Other Recurring
                _buildExpenseField('Other Recurring', _otherController),
                const SizedBox(height: 24),

                // Household Size
                TextFormField(
                  controller: _householdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Household Size',
                    hintText: 'Number of people',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter household size';
                    if (int.tryParse(v) == null) return 'Enter a whole number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Age Bracket
                DropdownButtonFormField<String>(
                  value: _selectedAgeBracket,
                  items: _ageBrackets
                      .map((age) => DropdownMenuItem(value: age, child: Text(age)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedAgeBracket = val),
                  decoration: const InputDecoration(
                    labelText: 'Age Bracket',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                  v == null ? 'Select your age bracket' : null,
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onSubmit,
                    child: const Text('Check Feasibility'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper to reduce repetition
  Widget _buildExpenseField(
      String label,
      TextEditingController controller,
      ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixText: '\$',
        border: const OutlineInputBorder(),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Enter $label';
        if (double.tryParse(v) == null) return 'Enter a number';
        return null;
      },
    );
  }
}
