//budget_list_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cungacash/models/budget.dart';
import 'package:cungacash/services/db_helper.dart';
import 'package:cungacash/screens/budget/create_edit_budget_screen.dart';
import 'package:cungacash/screens/budget/budget_details_screen.dart';

class BudgetListScreen extends StatefulWidget {
  final String userId;

  const BudgetListScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _BudgetListScreenState createState() => _BudgetListScreenState();
}

class _BudgetListScreenState extends State<BudgetListScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Budget> _budgets = [];
  bool _isLoading = true;
  
  // prevent recreation on rebuild
  final Map<String, Future<Map<String, double>>> _budgetDataCache = {};

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  Future<void> _loadBudgets() async {
    setState(() => _isLoading = true);
    try {
      final budgets = await _dbHelper.getBudgetsForUser(widget.userId);
      setState(() {
        _budgets = budgets;
        _isLoading = false;
        // Clear cache when budgets are reloaded
        _budgetDataCache.clear();
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('error_loading_budgets'.tr(namedArgs: {'error': e.toString()})),
        ),
      );
    }
  }

  Future<void> _navigateToCreateEdit(Budget? budget) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditBudgetScreen(
          userId: widget.userId,
          budget: budget,
        ),
      ),
    );

    if (result == true) {
      _loadBudgets();
    }
  }

  Future<void> _confirmDelete(Budget budget) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_budget'.tr()),
        content: Text('delete_confirmation'.tr(namedArgs: {'name': budget.name})),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('delete'.tr()),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _dbHelper.deleteBudget(budget.id);
        _loadBudgets();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('budget_deleted'.tr())),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('error_deleting_budget'.tr(namedArgs: {'error': e.toString()})),
          ),
        );
      }
    }
  }

  Future<void> _viewBudgetDetails(Budget budget) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetDetailsScreen(
          userId: widget.userId,
          budget: budget,
        ),
      ),
    );

    // Refresh in case there were changes
    _loadBudgets();
  }

  String _getPeriodDisplay(Budget budget) {
    if (budget.period == 'custom') {
      return '${DateFormat('MMM dd').format(budget.startDate)} - ${DateFormat('MMM dd').format(budget.endDate)}';
    } else {
      return budget.period.substring(0, 1).toUpperCase() +
          budget.period.substring(1);
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

  Future<Map<String, double>> _getBudgetDataCached(Budget budget) {
    final cacheKey = '${budget.id}_${budget.category}_${budget.startDate}_${budget.endDate}';
    
    if (!_budgetDataCache.containsKey(cacheKey)) {
      _budgetDataCache[cacheKey] = _calculateBudgetData(budget);
    }
    
    return _budgetDataCache[cacheKey]!;
  }

  // Helper method to calculate budget data
  Future<Map<String, double>> _calculateBudgetData(Budget budget) async {
    try {
      return await _dbHelper.getBudgetRemaining(
        widget.userId,
        budget.category,
        startDate: budget.startDate,
        endDate: budget.endDate,
      );
    } catch (e) {
      print('Error calculating budget data: $e');
      return {
        'budget': budget.amount,
        'spent': 0.0,
        'remaining': budget.amount,
        'percentage': 0.0,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('your_budgets'.tr()),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _budgets.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.account_balance_wallet_outlined,
                          size: 70, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'no_budgets_yet'.tr(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'create_to_track'.tr(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _navigateToCreateEdit(null),
                        child: Text('create_first_budget'.tr()),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadBudgets,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _budgets.length,
                    itemBuilder: (context, index) {
                      final budget = _budgets[index];
                      return _buildBudgetCard(budget);
                    },
                  ),
                ),
      floatingActionButton: _budgets.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _navigateToCreateEdit(null),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildBudgetCard(Budget budget) {
    return FutureBuilder<Map<String, double>>(
      // ✅ FIXED: Use cached future instead of creating new one
      future: _getBudgetDataCached(budget),
      builder: (context, snapshot) {
        final isLoading = !snapshot.hasData;
        
        if (snapshot.hasError) {
          print('FutureBuilder error: ${snapshot.error}');
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    budget.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Error loading budget data',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        }
        
        final data = snapshot.data ??
            {'budget': budget.amount, 'spent': 0.0, 'remaining': budget.amount, 'percentage': 0.0};
        final percentage = data['percentage'] ?? 0.0;
        final spent = data['spent'] ?? 0.0;
        final remaining = data['remaining'] ?? budget.amount;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: () => _viewBudgetDetails(budget),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          budget.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _navigateToCreateEdit(budget);
                          } else if (value == 'delete') {
                            _confirmDelete(budget);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text('edit'.tr()),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('delete'.tr()),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.category,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        budget.category == 'all'
                            ? 'overall_budget'.tr()
                            : budget.category,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '| ${_getPeriodDisplay(budget)}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  isLoading
                      ? const LinearProgressIndicator()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LinearProgressIndicator(
                              value: percentage / 100,
                              color: _getBudgetColor(percentage),
                              backgroundColor: Colors.grey[300],
                              minHeight: 8,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'spent'.tr(namedArgs: {
                                    'amount': NumberFormat('#,##0').format(spent)
                                  }),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'remaining'.tr(namedArgs: {
                                    'amount': NumberFormat('#,##0').format(remaining)
                                  }),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${percentage.toStringAsFixed(1)}% used',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getBudgetColor(percentage),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}