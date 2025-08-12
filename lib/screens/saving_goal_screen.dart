//Saving Goal Screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/saving_goal.dart';
import '../providers/saving_goal_provider.dart';

class SavingGoalScreen extends StatefulWidget {
  @override
  _SavingGoalScreenState createState() => _SavingGoalScreenState();
}

class _SavingGoalScreenState extends State<SavingGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _targetAmountController = TextEditingController();
  DateTime? _selectedDeadline;

  @override
  void initState() {
    super.initState();
    // Load goals when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SavingGoalProvider>(context, listen: false).loadSavingGoals();
    });
  }

  Future<void> _addGoal() async {
    // Dismiss keyboard first
    FocusScope.of(context).unfocus();
    
    if (_formKey.currentState!.validate() && _selectedDeadline != null) {
      final goal = SavingGoal(
        title: _titleController.text,
        targetAmount: double.parse(_targetAmountController.text),
        savedAmount: 0.0,
        deadline: _selectedDeadline!,
      );

      await Provider.of<SavingGoalProvider>(context, listen: false).addSavingGoal(goal);
      
      _titleController.clear();
      _targetAmountController.clear();
      _selectedDeadline = null;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('saving_goal_added'.tr())),
      );
    }
  }

  Future<void> _deleteGoal(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_goal'.tr()),
        content: Text('confirm_delete_goal'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('delete'.tr(), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await Provider.of<SavingGoalProvider>(context, listen: false).deleteSavingGoal(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('goal_deleted'.tr())),
      );
    }
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDeadline = picked);
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  // Calculate days remaining until deadline
  int _getDaysRemaining(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);
    return difference.inDays;
  }

  // Get status color based on progress and deadline
  Color _getStatusColor(SavingGoal goal) {
    final progress = goal.savedAmount / goal.targetAmount;
    final daysRemaining = _getDaysRemaining(goal.deadline);
    
    if (progress >= 1.0) return Colors.green;
    if (daysRemaining < 0) return Colors.red;
    if (daysRemaining < 30) return Colors.orange;
    return Colors.blue;
  }

  // Get status text based on progress and deadline
  String _getStatusText(SavingGoal goal) {
    final progress = goal.savedAmount / goal.targetAmount;
    final daysRemaining = _getDaysRemaining(goal.deadline);
    
    if (progress >= 1.0) return 'completed'.tr();
    if (daysRemaining < 0) return 'overdue'.tr();
    return 'days_left'.tr(namedArgs: {'days': daysRemaining.toString()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr()),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Add Goal Form
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'create_new_goal'.tr(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'goal_title'.tr(),
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.flag),
                        ),
                        validator: (value) => value!.isEmpty ? 'enter_title'.tr() : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _targetAmountController,
                        decoration: InputDecoration(
                          labelText: 'target_amount'.tr(),
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.monetization_on),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return 'enter_target_amount'.tr();
                          if (double.tryParse(value) == null) return 'enter_valid_amount'.tr();
                          if (double.parse(value) <= 0) return 'positive_amount_required'.tr();
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
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
                                _selectedDeadline == null
                                    ? 'select_deadline'.tr()
                                    : 'deadline'.tr() + ': ${_formatDate(_selectedDeadline!)}',
                                style: TextStyle(
                                  color: _selectedDeadline == null ? Colors.grey : Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _pickDate,
                              child: Text('pick_date'.tr()),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _addGoal,
                        icon: const Icon(Icons.add),
                        label: Text('create_goal'.tr()),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Goals List
            Consumer<SavingGoalProvider>(
              builder: (context, goalProvider, child) {
                if (goalProvider.savingGoals.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          const Icon(Icons.savings_outlined, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            'no_goals_title'.tr(),
                            style: const TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          Text(
                            'no_goals_subtitle'.tr(),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: goalProvider.savingGoals.map((goal) {
                    final progress = goal.savedAmount / goal.targetAmount;
                    final daysRemaining = _getDaysRemaining(goal.deadline);
                    final statusColor = _getStatusColor(goal);
                    final progressPercentage = (progress * 100).clamp(0, 100);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      child: InkWell(
                        onTap: () {
                          // TODO: Navigate to goal details screen
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      goal.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: statusColor),
                                    ),
                                    child: Text(
                                      _getStatusText(goal),
                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteGoal(goal.id!),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'saved_vs_target'.tr(namedArgs: {
                                  'saved': NumberFormat('#,###').format(goal.savedAmount),
                                  'target': NumberFormat('#,###').format(goal.targetAmount),
                                }),
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: progress > 1 ? 1 : progress,
                                minHeight: 8,
                                backgroundColor: Colors.grey[300],
                                color: statusColor,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'progress_completed'.tr(namedArgs: {
                                      'progress': progressPercentage.toStringAsFixed(1)
                                    }),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'goal_deadline'.tr(namedArgs: {
                                      'date': _formatDate(goal.deadline)
                                    }),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
    );
  }
}