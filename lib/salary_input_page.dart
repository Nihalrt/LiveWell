import 'package:flutter/material.dart';

class SalaryInputPage extends StatefulWidget {
  const SalaryInputPage({super.key});

  @override
  State<SalaryInputPage> createState() => _SalaryInputPageState();
}

class _SalaryInputPageState extends State<SalaryInputPage> {
  final _salaryController = TextEditingController();
  final _expenseController = TextEditingController();

  @override
  void dispose() {
    _salaryController.dispose();
    _expenseController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  // void _onSubmit(){
  //   final salary = double.tryParse(_salaryController.text);
  //   final expense = double.tryParse(_expenseController.text);
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text('inputs received'),
  //       content: Text('Salary: \$${salary.toStringAsFixed(2)}\n'
  //       'Expense: \$${expense.toStringAsFixed(2)}'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('OK')
  //         ),]
  //     ),
  //   );
  // }
}

