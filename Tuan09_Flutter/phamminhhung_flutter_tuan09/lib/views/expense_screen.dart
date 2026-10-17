import 'package:flutter/material.dart';
import '../controllers/expense_controller.dart';
import '../models/expense.dart';

class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final ExpenseController _controller = ExpenseController();
  final TextEditingController _contentCtrl = TextEditingController();
  final TextEditingController _amountCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final expenses = await _controller.fetchExpenses();
    setState(() {
      _expenses = expenses;
    });
  }

  void _addExpense() async {
    if (_contentCtrl.text.isEmpty || _amountCtrl.text.isEmpty) return;
    
    Expense newExpense = Expense(
      content: _contentCtrl.text,
      amount: double.tryParse(_amountCtrl.text) ?? 0.0,
      note: _noteCtrl.text,
    );
    
    await _controller.insertExpense(newExpense);
    _contentCtrl.clear();
    _amountCtrl.clear();
    _noteCtrl.clear();
    _loadExpenses(); // Refresh list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản lý chi tiêu')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(controller: _contentCtrl, decoration: InputDecoration(labelText: 'Nội dung chi tiêu')),
                TextField(controller: _amountCtrl, decoration: InputDecoration(labelText: 'Số tiền (VND)'), keyboardType: TextInputType.number),
                TextField(controller: _noteCtrl, decoration: InputDecoration(labelText: 'Ghi chú')),
                SizedBox(height: 10),
                ElevatedButton(onPressed: _addExpense, child: Text('Thêm chi tiêu')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final expense = _expenses[index];
                return Card(
                  child: ListTile(
                    title: Text(expense.content),
                    subtitle: Text('Ghi chú: ${expense.note}'),
                    trailing: Text('${expense.amount} đ', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}