//edit transaction screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';

class EditTransactionScreen extends StatefulWidget {
  final Transaction transaction;

  const EditTransactionScreen({super.key, required this.transaction});

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late String _selectedType;
  late String _selectedCategory;
  late DateTime _selectedDate;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.transaction.amount.toString());
    _descriptionController = TextEditingController(text: widget.transaction.description);
    _selectedType = widget.transaction.type;
    _selectedCategory = widget.transaction.category;
    _selectedDate = widget.transaction.date;
  }

  void _updateTransaction() {
    if (!_formKey.currentState!.validate()) return;

    final updatedTransaction = Transaction(
      id: widget.transaction.id,
      userId: widget.transaction.userId,
      type: _selectedType,
      category: _selectedCategory,
      amount: double.parse(_amountController.text),
      date: _selectedDate,
      description: _descriptionController.text.trim(),
    );

    Provider.of<TransactionProvider>(context, listen: false).updateTransaction(updatedTransaction);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("updated_success".tr())),
    );

    Navigator.pop(context);
  }

  void _confirmUpdate() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("confirm_update".tr()),
        content: Text("update_question".tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("cancel".tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _updateTransaction();
            },
            child: Text("update".tr()),
          ),
        ],
      ),
    );
  }

  void _deleteTransaction() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("confirm_delete".tr()),
        content: Text("delete_question".tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("cancel".tr()),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TransactionProvider>(context, listen: false)
                  .deleteTransaction(widget.transaction.id);

              Navigator.pop(ctx);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("deleted_success".tr())),
              );
            },
            child: Text("delete".tr(), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("edit_transaction".tr())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: ['income', 'expense'].map((type) {
                  return DropdownMenuItem(
                    value: type, 
                    child: Text(type.tr())
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedType = value ?? _selectedType),
                decoration: InputDecoration(labelText: "transaction_type".tr()),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: "amount".tr()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "amount_required".tr();
                  if (double.tryParse(value) == null) return "amount_invalid".tr();
                  return null;
                },
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ['groceries', 'utilities', 'entertainment', 'salary', 'other', 'gift', 'business', 'transport', 'healthcare', 'freelance' , 'Shopping' , 'Bills','Investment'].map((category) {
                  return DropdownMenuItem(
                    value: category.toLowerCase() == 'groceries' ? 'Groceries' :
                           category.toLowerCase() == 'utilities' ? 'Utilities' :
                           category.toLowerCase() == 'entertainment' ? 'Entertainment' :
                           category.toLowerCase() == 'salary' ? 'Salary' :
                           category.toLowerCase() == 'other' ? 'Other' :
                           category.toLowerCase() == 'gift' ? 'Gift' :
                           category.toLowerCase() == 'business' ? 'Business' :
                           category.toLowerCase() == 'transport' ? 'Transport' :
                           category.toLowerCase() == 'healthcare' ? 'Healthcare' :
                           category.toLowerCase() == 'freelance' ? 'Freelance' : category,
                    child: Text(category.tr())
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value ?? _selectedCategory),
                decoration: InputDecoration(labelText: "category".tr()),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "description".tr()),
                maxLines: 2,
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Text("${"date".tr()}: ${DateFormat.yMMMd().format(_selectedDate)}",
                      style: const TextStyle(fontSize: 16)),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text("choose_date".tr()),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _confirmUpdate,
                child: Text("update_transaction".tr()),
              ),
              const SizedBox(height: 10),

              TextButton(
                onPressed: _deleteTransaction,
                child: Text("delete_transaction".tr(), style: const TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}