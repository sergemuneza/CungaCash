// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/saving_goal.dart';
// import '../services/db_helper.dart';

// class SavingGoalScreen extends StatefulWidget {
//   @override
//   _SavingGoalScreenState createState() => _SavingGoalScreenState();
// }

// class _SavingGoalScreenState extends State<SavingGoalScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _targetAmountController = TextEditingController();
//   DateTime? _selectedDeadline;
//   List<SavingGoal> _goals = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchGoals();
//   }

//   Future<void> _fetchGoals() async {
//     final goals = await DBHelper().getSavingGoals();
//     setState(() => _goals = goals);
//   }

//   // Future<void> _addGoal() async {
//   //   if (_formKey.currentState!.validate() && _selectedDeadline != null) {
//   //     final goal = SavingGoal(
//   //       title: _titleController.text,
//   //       targetAmount: double.parse(_targetAmountController.text),
//   //       savedAmount: 0.0,
//   //       deadline: _selectedDeadline!, id: '',
//   //     );

//   //     await DBHelper().insertSavingGoal(goal);
//   //     _titleController.clear();
//   //     _targetAmountController.clear();
//   //     _selectedDeadline = null;
//   //     _fetchGoals();
//   //   }
//   // }
//   Future<void> _addGoal() async {
//   if (_formKey.currentState!.validate() && _selectedDeadline != null) {
//     final goal = SavingGoal(
//       // Remove the id parameter entirely for new goals
//       title: _titleController.text,
//       targetAmount: double.parse(_targetAmountController.text),
//       savedAmount: 0.0,
//       deadline: _selectedDeadline!,
//     );

//     await DBHelper().insertSavingGoal(goal);
//     _titleController.clear();
//     _targetAmountController.clear();
//     _selectedDeadline = null;
//     _fetchGoals();
//   }
// }

//   Future<void> _deleteGoal(int id) async {
//     await DBHelper().deleteSavingGoal(id);
//     _fetchGoals();
//   }

//   void _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now().add(Duration(days: 30)),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() => _selectedDeadline = picked);
//     }
//   }

//   String _formatDate(DateTime date) {
//     return DateFormat('yyyy-MM-dd').format(date);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Savings Goals")),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(children: [
//           Form(
//             key: _formKey,
//             child: Column(children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(labelText: 'Goal Title'),
//                 validator: (value) => value!.isEmpty ? 'Enter a title' : null,
//               ),
//               TextFormField(
//                 controller: _targetAmountController,
//                 decoration: InputDecoration(labelText: 'Target Amount (RWF)'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Enter target amount' : null,
//               ),
//               SizedBox(height: 10),
//               Row(children: [
//                 Expanded(
//                   child: Text(_selectedDeadline == null
//                       ? 'No deadline chosen'
//                       : 'Deadline: ${_formatDate(_selectedDeadline!)}'),
//                 ),
//                 TextButton(
//                   onPressed: _pickDate,
//                   child: Text('Pick Deadline'),
//                 ),
//               ]),
//               ElevatedButton(
//                 onPressed: _addGoal,
//                 child: Text('Add Goal'),
//               ),
//             ]),
//           ),
//           Divider(height: 30),
//           ..._goals.map((goal) {
//             final progress = goal.savedAmount / goal.targetAmount;
//             return Card(
//               child: ListTile(
//                 title: Text(goal.title),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Target: RWF ${goal.targetAmount.toStringAsFixed(0)} | Saved: RWF ${goal.savedAmount.toStringAsFixed(0)}',
//                     ),
//                     SizedBox(height: 4),
//                     LinearProgressIndicator(
//                       value: progress > 1 ? 1 : progress,
//                       minHeight: 8,
//                       backgroundColor: Colors.grey[300],
//                       color: Colors.green,
//                     ),
//                     SizedBox(height: 4),
//                     Text('Deadline: ${_formatDate(goal.deadline)}'),
//                   ],
//                 ),
//                 trailing: IconButton(
//                   icon: Icon(Icons.delete, color: Colors.red),
//                   onPressed: () => _deleteGoal(goal.id as int),
//                 ),
//               ),
//             );
//           }).toList(),
//         ]),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
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
        const SnackBar(content: Text('Saving goal added successfully!')),
      );
    }
  }

  Future<void> _deleteGoal(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Goal'),
        content: const Text('Are you sure you want to delete this saving goal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await Provider.of<SavingGoalProvider>(context, listen: false).deleteSavingGoal(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving goal deleted')),
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

  // ✅ Calculate days remaining until deadline
  int _getDaysRemaining(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);
    return difference.inDays;
  }

  // ✅ Get status color based on progress and deadline
  Color _getStatusColor(SavingGoal goal) {
    final progress = goal.savedAmount / goal.targetAmount;
    final daysRemaining = _getDaysRemaining(goal.deadline);
    
    if (progress >= 1.0) return Colors.green;
    if (daysRemaining < 0) return Colors.red;
    if (daysRemaining < 30) return Colors.orange;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Savings Goals"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ✅ Add Goal Form
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
                        'Create New Goal',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Goal Title',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.flag),
                        ),
                        validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _targetAmountController,
                        decoration: const InputDecoration(
                          labelText: 'Target Amount (RWF)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.monetization_on),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return 'Enter target amount';
                          if (double.tryParse(value) == null) return 'Enter valid amount';
                          if (double.parse(value) <= 0) return 'Amount must be positive';
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
                                    ? 'Select deadline'
                                    : 'Deadline: ${_formatDate(_selectedDeadline!)}',
                                style: TextStyle(
                                  color: _selectedDeadline == null ? Colors.grey : Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _pickDate,
                              child: const Text('Pick Date'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _addGoal,
                        icon: const Icon(Icons.add),
                        label: const Text('Create Goal'),
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
            
            // ✅ Goals List
            Consumer<SavingGoalProvider>(
              builder: (context, goalProvider, child) {
                if (goalProvider.savingGoals.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.savings_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No saving goals yet',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          Text(
                            'Create your first goal above',
                            style: TextStyle(color: Colors.grey),
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
                                      progress >= 1.0
                                          ? 'Completed'
                                          : daysRemaining < 0
                                              ? 'Overdue'
                                              : '$daysRemaining days left',
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
                                'RWF ${NumberFormat('#,###').format(goal.savedAmount)} / RWF ${NumberFormat('#,###').format(goal.targetAmount)}',
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
                                    '${progressPercentage.toStringAsFixed(1)}% completed',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Deadline: ${_formatDate(goal.deadline)}',
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