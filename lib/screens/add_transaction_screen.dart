import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = 'expense';
  String _selectedCategory = 'Groceries';
  DateTime _selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  void _submitTransaction() {
    if (!_formKey.currentState!.validate()) return;

    final transaction = Transaction(
      id: DateTime.now().toString(),
      userId: "user123", // Replace with actual user ID
      type: _selectedType,
      category: _selectedCategory,
      amount: double.parse(_amountController.text),
      date: _selectedDate, // ✅ Fixed: Now passing DateTime instead of String
      description: _descriptionController.text,
    );

    Provider.of<TransactionProvider>(context, listen: false).addTransaction(transaction);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Transaction added successfully!")),
    );

    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Transaction")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                value: _selectedType,
                items: ['income', 'expense'].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type.capitalize()));
                }).toList(),
                onChanged: (value) => setState(() => _selectedType = value.toString()),
                decoration: InputDecoration(labelText: "Transaction Type"),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty || double.tryParse(value) == null ? "Enter a valid amount" : null,
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField(
                value: _selectedCategory,
                items: ['Groceries', 'Utilities', 'Entertainment', 'Salary', 'Other'].map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value.toString()),
                decoration: InputDecoration(labelText: "Category"),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Text("Date: ${_selectedDate.toLocal()}".split(' ')[0]),
                  Spacer(),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text("Choose Date"),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submitTransaction,
                child: Text("Add Transaction"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}
