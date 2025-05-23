// // lib/screens/budget/budget_list_screen.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:expense_tracker_pro/models/budget.dart';
// import 'package:expense_tracker_pro/services/db_helper.dart';
// import 'package:expense_tracker_pro/screens/budget/create_edit_budget_screen.dart';
// import 'package:expense_tracker_pro/screens/budget/budget_details_screen.dart';

// class BudgetListScreen extends StatefulWidget {
//   final String userId;

//   const BudgetListScreen({
//     Key? key,
//     required this.userId,
//   }) : super(key: key);

//   @override
//   _BudgetListScreenState createState() => _BudgetListScreenState();
// }

// class _BudgetListScreenState extends State<BudgetListScreen> {
//   final DBHelper _dbHelper = DBHelper();
//   List<Budget> _budgets = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadBudgets();
//   }

//   Future<void> _loadBudgets() async {
//     setState(() => _isLoading = true);
//     try {
//       final budgets = await _dbHelper.getBudgetsForUser(widget.userId);
//       setState(() {
//         _budgets = budgets;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading budgets: ${e.toString()}')),
//       );
//     }
//   }

//   Future<void> _navigateToCreateEdit(Budget? budget) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CreateEditBudgetScreen(
//           userId: widget.userId,
//           budget: budget,
//         ),
//       ),
//     );

//     if (result == true) {
//       _loadBudgets();
//     }
//   }

//   Future<void> _confirmDelete(Budget budget) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Budget'),
//         content: Text('Are you sure you want to delete "${budget.name}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('CANCEL'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('DELETE'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       try {
//         await _dbHelper.deleteBudget(budget.id);
//         _loadBudgets();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Budget deleted')),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error deleting budget: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   Future<void> _viewBudgetDetails(Budget budget) async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => BudgetDetailsScreen(
//           userId: widget.userId,
//           budget: budget,
//         ),
//       ),
//     );

//     // Refresh in case there were changes
//     _loadBudgets();
//   }

//   String _getPeriodDisplay(Budget budget) {
//     if (budget.period == 'custom') {
//       return '${DateFormat('MMM dd').format(budget.startDate)} - ${DateFormat('MMM dd').format(budget.endDate)}';
//     } else {
//       return budget.period.substring(0, 1).toUpperCase() + budget.period.substring(1);
//     }
//   }

//   Color _getBudgetColor(double percentage) {
//     if (percentage >= 100) {
//       return Colors.red;
//     } else if (percentage >= 75) {
//       return Colors.orange;
//     } else {
//       return Colors.green;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Budgets'),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _budgets.isEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.account_balance_wallet_outlined, size: 70, color: Colors.grey),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'No budgets yet',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         'Create a budget to track your spending',
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                       const SizedBox(height: 24),
//                       ElevatedButton(
//                         onPressed: () => _navigateToCreateEdit(null),
//                         child: const Text('Create First Budget'),
//                       ),
//                     ],
//                   ),
//                 )
//               : RefreshIndicator(
//                   onRefresh: _loadBudgets,
//                   child: ListView.builder(
//                     padding: const EdgeInsets.all(8.0),
//                     itemCount: _budgets.length,
//                     itemBuilder: (context, index) {
//                       final budget = _budgets[index];
//                       return _buildBudgetCard(budget);
//                     },
//                   ),
//                 ),
//       floatingActionButton: _budgets.isNotEmpty
//           ? FloatingActionButton(
//               onPressed: () => _navigateToCreateEdit(null),
//               child: const Icon(Icons.add),
//             )
//           : null,
//     );
//   }

//   Widget _buildBudgetCard(Budget budget) {
//     return FutureBuilder<Map<String, double>>(
//       future: _dbHelper.getBudgetRemaining(widget.userId, budget.category),
//       builder: (context, snapshot) {
//         final isLoading = !snapshot.hasData;
//         final data = snapshot.data ?? {'budget': 0.0, 'spent': 0.0, 'remaining': 0.0, 'percentage': 0.0};
//         final percentage = data['percentage'] ?? 0.0;
//         final spent = data['spent'] ?? 0.0;

//         return Card(
//           margin: const EdgeInsets.symmetric(vertical: 8.0),
//           child: InkWell(
//             onTap: () => _viewBudgetDetails(budget),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           budget.name,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       PopupMenuButton<String>(
//                         onSelected: (value) {
//                           if (value == 'edit') {
//                             _navigateToCreateEdit(budget);
//                           } else if (value == 'delete') {
//                             _confirmDelete(budget);
//                           }
//                         },
//                         itemBuilder: (context) => [
//                           const PopupMenuItem(
//                             value: 'edit',
//                             child: Text('Edit'),
//                           ),
//                           const PopupMenuItem(
//                             value: 'delete',
//                             child: Text('Delete'),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),

//                   Row(
//                     children: [
//                       Icon(
//                         Icons.category,
//                         size: 16,
//                         color: Colors.grey[600],
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         budget.category == 'all' ? 'Overall Budget' : budget.category,
//                         style: TextStyle(color: Colors.grey[600]),
//                       ),
//                                             const SizedBox(width: 8),
//                       Text(
//                         '| ${_getPeriodDisplay(budget)}',
//                         style: TextStyle(color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),

//                   isLoading
//                       ? const LinearProgressIndicator()
//                       : Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             LinearProgressIndicator(
//                               value: percentage / 100,
//                               color: _getBudgetColor(percentage),
//                               backgroundColor: Colors.grey[300],
//                               minHeight: 8,
//                             ),
//                             const SizedBox(height: 8),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Spent: ${spent.toStringAsFixed(0)} RWF',
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                                 Text(
//                                   '${percentage.toStringAsFixed(0)}%',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: _getBudgetColor(percentage),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
// lib/screens/budget/budget_list_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker_pro/models/budget.dart';
import 'package:expense_tracker_pro/services/db_helper.dart';
import 'package:expense_tracker_pro/screens/budget/create_edit_budget_screen.dart';
import 'package:expense_tracker_pro/screens/budget/budget_details_screen.dart';

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
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading budgets: ${e.toString()}')),
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
        title: const Text('Delete Budget'),
        content: Text('Are you sure you want to delete "${budget.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _dbHelper.deleteBudget(budget.id);
        _loadBudgets();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Budget deleted')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting budget: ${e.toString()}')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Budgets'),
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
                      const Text(
                        'No budgets yet',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Create a budget to track your spending',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _navigateToCreateEdit(null),
                        child: const Text('Create First Budget'),
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
      // ✅ FIXED: Pass the budget's date range
      future: _dbHelper.getBudgetRemaining(
        widget.userId,
        budget.category,
        startDate: budget.startDate, // Add budget's start date
        endDate: budget.endDate, // Add budget's end date
      ),
      builder: (context, snapshot) {
        final isLoading = !snapshot.hasData;
        final data = snapshot.data ??
            {'budget': 0.0, 'spent': 0.0, 'remaining': 0.0, 'percentage': 0.0};
        final percentage = data['percentage'] ?? 0.0;
        final spent = data['spent'] ?? 0.0;
        final remaining = data['remaining'] ?? 0.0;

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
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
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
                            ? 'Overall Budget'
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
                                  'Spent: ${NumberFormat('#,##0').format(spent)} RWF',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Remaining: ${NumberFormat('#,##0').format(remaining)} RWF',
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
