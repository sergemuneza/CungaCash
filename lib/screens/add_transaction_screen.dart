//Add transaction Screen
import 'package:cungacash/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../providers/saving_goal_provider.dart';
import '../models/saving_goal.dart';
import '../providers/budget_provider.dart';
import '../models/budget.dart';
import '../services/db_helper.dart';

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
  int? _selectedGoalId;
  final DBHelper _dbHelper = DBHelper();
  List<Budget> _budgets = [];
  bool _budgetsLoading = false;

  void _submitTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('user_not_logged_in'.tr())),
      );
      return;
    }

    final amount = double.parse(_amountController.text);
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      type: _selectedType,
      category: _selectedCategory,
      amount: amount,
      date: _selectedDate,
      description: _descriptionController.text.trim(),
      savingGoalId: _selectedGoalId?.toString(),
    );

    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    final savingGoalProvider = Provider.of<SavingGoalProvider>(context, listen: false);
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);

    try {
      await transactionProvider.addTransaction(transaction);

      if (_selectedGoalId != null && _selectedType == 'income') {
        await savingGoalProvider.updateGoalProgress(_selectedGoalId.toString(), amount);
      }

      if (_selectedType == 'expense') {
        await budgetProvider.fetchBudgets();
        await _loadBudgets();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("transaction_added_success".tr())),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${"error_adding_transaction".tr()}: ${e.toString()}")),
      );
    }
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

  List<String> get _categories {
    if (_selectedType == 'income') {
      return ['Salary', 'Freelance', 'Business', 'Investment', 'Gift', 'Other'];
    } else {
      return ['Groceries', 'Utilities', 'Entertainment', 'Transport', 'Bills', 'Healthcare', 'Shopping', 'Other'];
    }
  }

  @override
  void initState() {
    super.initState();
    _updateCategoryForType();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBudgets();
      Provider.of<BudgetProvider>(context, listen: false).fetchBudgets();
    });
  }

  Future<void> _loadBudgets() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser?.id;
    
    if (userId == null) return;

    setState(() => _budgetsLoading = true);
    
    try {
      final budgets = await _dbHelper.getBudgetsForUser(userId);
      setState(() {
        _budgets = budgets;
        _budgetsLoading = false;
      });
    } catch (e) {
      setState(() => _budgetsLoading = false);
      print('Error loading budgets: $e');
    }
  }

  void _updateCategoryForType() {
    if (_selectedType == 'income' && !_categories.contains(_selectedCategory)) {
      _selectedCategory = 'Salary';
    } else if (_selectedType == 'expense' && !_categories.contains(_selectedCategory)) {
      _selectedCategory = 'Groceries';
    }
  }

  Future<Map<String, double>> _getBudgetData(Budget budget, String userId) async {
    return await _dbHelper.getBudgetRemaining(
      userId,
      budget.category,
      startDate: budget.startDate,
      endDate: budget.endDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final goals = Provider.of<SavingGoalProvider>(context).savingGoals;
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.currentUser?.id ?? '';

    return Scaffold(
      appBar: AppBar(title: Text("add_transaction".tr())),
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
                    child: Row(
                      children: [
                        Icon(
                          type == 'income' ? Icons.trending_up : Icons.trending_down,
                          color: type == 'income' ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(type.tr()),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value ?? _selectedType;
                    _updateCategoryForType();
                    _selectedGoalId = null;
                  });
                },
                decoration: InputDecoration(
                  labelText: "transaction_type".tr(),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: "amount_rwf".tr(),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.monetization_on),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "amount_required".tr();
                  if (double.tryParse(value) == null) return "amount_invalid".tr();
                  if (double.parse(value) <= 0) return "amount_greater_than_zero".tr();
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category, 
                    child: Text(category.toLowerCase().tr())
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value ?? _selectedCategory),
                decoration: InputDecoration(
                  labelText: "category".tr(),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 16),

              if (goals.isNotEmpty && _selectedType == 'income') ...[
                DropdownButtonFormField<int>(
                  value: _selectedGoalId,
                  items: [
                    DropdownMenuItem<int>(
                      value: null,
                      child: Text('none_optional'.tr()),
                    ),
                    ...goals.where((goal) => goal.id != null).map((goal) {
                      return DropdownMenuItem<int>(
                        value: goal.id!,
                        child: Text(goal.title),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedGoalId = value);
                  },
                  decoration: InputDecoration(
                    labelText: 'link_to_saving_goal_optional'.tr(),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.savings),
                    hintText: 'select_goal_to_contribute'.tr(),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "description".tr(),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.description),
                  hintText: "enter_transaction_details".tr(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.grey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "${"date".tr()}: ${DateFormat.yMMMd().format(_selectedDate)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.edit_calendar),
                      label: Text("change".tr()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _submitTransaction,
                icon: const Icon(Icons.add),
                label: Text("add_transaction".tr()),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              if (_selectedType == 'expense' && userId.isNotEmpty) ...[
                _buildBudgetInfoSection(userId),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetInfoSection(String userId) {
    if (_budgetsLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Row(
          children: [
            const CircularProgressIndicator(strokeWidth: 2),
            const SizedBox(width: 16),
            Text('loading_budget_info'.tr()),
          ],
        ),
      );
    }

    Budget? matchingBudget;
    
    try {
      matchingBudget = _budgets.firstWhere(
        (budget) => budget.category.toLowerCase() == _selectedCategory.toLowerCase() && budget.isActive,
      );
    } catch (e) {
      try {
        matchingBudget = _budgets.firstWhere(
          (budget) => budget.category.toLowerCase() == 'all' && budget.isActive,
        );
      } catch (e) {
        matchingBudget = null;
      }
    }

    if (matchingBudget != null) {
      return FutureBuilder<Map<String, double>>(
        future: _getBudgetData(matchingBudget, userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const CircularProgressIndicator(strokeWidth: 2),
                  const SizedBox(width: 16),
                  Text('loading_budget_info'.tr()),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'error_loading_budget_data'.tr(),
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data ?? {'budget': 0.0, 'spent': 0.0, 'remaining': 0.0, 'percentage': 0.0};
          final percentage = data['percentage'] ?? 0.0;
          final spent = data['spent'] ?? 0.0;
          final remaining = data['remaining'] ?? 0.0;
          final isLowBudget = percentage >= 80;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isLowBudget ? Colors.red.shade50 : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isLowBudget ? Colors.red.shade200 : Colors.blue.shade200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      color: isLowBudget ? Colors.red.shade700 : Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${"budget".tr()}: ${matchingBudget?.name}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isLowBudget ? Colors.red.shade700 : Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${"remaining".tr()}: ${NumberFormat('#,##0').format(remaining)} RWF',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isLowBudget ? Colors.red.shade800 : Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${"spent".tr()}: ${NumberFormat('#,##0').format(spent)} RWF',
                  style: TextStyle(
                    fontSize: 14,
                    color: isLowBudget ? Colors.red.shade600 : Colors.blue.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getBudgetColor(percentage),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${"percentage_used".tr()}: ${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: _getBudgetColor(percentage),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isLowBudget) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red.shade600, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        percentage >= 100 ? 'budget_exceeded'.tr() : 'budget_almost_reached'.tr(),
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.info, color: Colors.orange.shade700),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'no_budget_found_consider_creating'.tr(),
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Color _getBudgetColor(double percentage) {
    if (percentage >= 100) {
      return Colors.red;
    } else if (percentage >= 75) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}