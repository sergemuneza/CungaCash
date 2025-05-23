// lib/screens/budget/budget_details_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker_pro/models/budget.dart';
import 'package:expense_tracker_pro/services/db_helper.dart';

class BudgetDetailsScreen extends StatefulWidget {
  final String userId;
  final Budget budget;

  const BudgetDetailsScreen({
    Key? key,
    required this.userId,
    required this.budget,
  }) : super(key: key);

  @override
  State<BudgetDetailsScreen> createState() => _BudgetDetailsScreenState();
}

class _BudgetDetailsScreenState extends State<BudgetDetailsScreen> {
  final DBHelper _dbHelper = DBHelper();
  late Future<Map<String, double>> _budgetStats;

  // @override
  // void initState() {
  //   super.initState();
  //   _budgetStats = _dbHelper.getBudgetRemaining(widget.userId, widget.budget.category);
  // }

  //...........
  @override
void initState() {
  super.initState();
  // ✅ Pass the budget's actual date range
  _budgetStats = _dbHelper.getBudgetRemaining(
    widget.userId, 
    widget.budget.category,
    startDate: widget.budget.startDate,  // Use budget's start date
    endDate: widget.budget.endDate,      // Use budget's end date
  );
}

  String _getFormattedDateRange() {
    if (widget.budget.period == 'custom') {
      final start = DateFormat('MMM dd, yyyy').format(widget.budget.startDate);
      final end = DateFormat('MMM dd, yyyy').format(widget.budget.endDate);
      return '$start - $end';
    } else {
      return widget.budget.period[0].toUpperCase() + widget.budget.period.substring(1);
    }
  }

  Color _getStatusColor(double percent) {
    if (percent >= 100) {
      return Colors.red;
    } else if (percent >= 75) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.budget.name),
      ),
      body: FutureBuilder<Map<String, double>>(
        future: _budgetStats,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = snapshot.data!;
          final budgetAmount = stats['budget'] ?? 0.0;
          final spent = stats['spent'] ?? 0.0;
          final remaining = stats['remaining'] ?? 0.0;
          final percentage = stats['percentage'] ?? 0.0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category: ${widget.budget.category == 'all' ? 'Overall Budget' : widget.budget.category}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Period: ${_getFormattedDateRange()}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: (percentage / 100).clamp(0.0, 1.0),
                  minHeight: 10,
                  color: _getStatusColor(percentage),
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Spent: ${spent.toStringAsFixed(0)} RWF'),
                    Text('Remaining: ${remaining.toStringAsFixed(0)} RWF'),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Usage: ${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 16,
                    color: _getStatusColor(percentage),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 12),
                const Text(
                  'Tip:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  percentage >= 100
                      ? 'You have exceeded your budget. Try to review unnecessary expenses.'
                      : percentage >= 75
                          ? 'Be careful, you are close to reaching your budget limit.'
                          : 'You are doing well! Keep tracking your spending.',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
