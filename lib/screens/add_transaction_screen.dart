// // // import 'package:flutter/material.dart';
// // // import 'package:provider/provider.dart';
// // // import 'package:intl/intl.dart';
// // // import '../providers/transaction_provider.dart';
// // // import '../models/transaction.dart';

// // // class AddTransactionScreen extends StatefulWidget {
// // //   const AddTransactionScreen({super.key});

// // //   @override
// // //   _AddTransactionScreenState createState() => _AddTransactionScreenState();
// // // }

// // // class _AddTransactionScreenState extends State<AddTransactionScreen> {
// // //   final _amountController = TextEditingController();
// // //   final _descriptionController = TextEditingController();
// // //   String _selectedType = 'expense';
// // //   String _selectedCategory = 'Groceries';
// // //   DateTime _selectedDate = DateTime.now();
// // //   final _formKey = GlobalKey<FormState>();

// // //   void _submitTransaction() {
// // //     if (!_formKey.currentState!.validate()) return;

// // //     final transaction = Transaction(
// // //       id: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
// // //       userId: "user123", // TODO: Replace with actual logged-in user ID
// // //       type: _selectedType,
// // //       category: _selectedCategory,
// // //       amount: double.parse(_amountController.text),
// // //       date: _selectedDate, 
// // //       description: _descriptionController.text.trim(),
// // //     );

// // //     Provider.of<TransactionProvider>(context, listen: false).addTransaction(transaction);

// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       const SnackBar(content: Text("Transaction added successfully!")),
// // //     );

// // //     Navigator.pop(context);
// // //   }

// // //   Future<void> _selectDate(BuildContext context) async {
// // //     final picked = await showDatePicker(
// // //       context: context,
// // //       initialDate: _selectedDate,
// // //       firstDate: DateTime(2000),
// // //       lastDate: DateTime.now(),
// // //     );
// // //     if (picked != null && picked != _selectedDate) {
// // //       setState(() => _selectedDate = picked);
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text("Add Transaction")),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: Form(
// // //           key: _formKey,
// // //           child: ListView(
// // //             children: [
// // //               DropdownButtonFormField<String>(
// // //                 value: _selectedType,
// // //                 items: ['income', 'expense'].map((type) {
// // //                   return DropdownMenuItem(value: type, child: Text(type.capitalize()));
// // //                 }).toList(),
// // //                 onChanged: (value) => setState(() => _selectedType = value ?? _selectedType),
// // //                 decoration: const InputDecoration(labelText: "Transaction Type"),
// // //               ),
// // //               const SizedBox(height: 10),

// // //               TextFormField(
// // //                 controller: _amountController,
// // //                 decoration: const InputDecoration(labelText: "Amount"),
// // //                 keyboardType: TextInputType.number,
// // //                 validator: (value) {
// // //                   if (value == null || value.isEmpty) return "Amount is required";
// // //                   if (double.tryParse(value) == null) return "Enter a valid number";
// // //                   return null;
// // //                 },
// // //               ),
// // //               const SizedBox(height: 10),

// // //               DropdownButtonFormField<String>(
// // //                 value: _selectedCategory,
// // //                 items: ['Groceries', 'Utilities', 'Entertainment', 'Salary', 'Other'].map((category) {
// // //                   return DropdownMenuItem(value: category, child: Text(category));
// // //                 }).toList(),
// // //                 onChanged: (value) => setState(() => _selectedCategory = value ?? _selectedCategory),
// // //                 decoration: const InputDecoration(labelText: "Category"),
// // //               ),
// // //               const SizedBox(height: 10),

// // //               TextFormField(
// // //                 controller: _descriptionController,
// // //                 decoration: const InputDecoration(labelText: "Description"),
// // //                 maxLines: 2,
// // //               ),
// // //               const SizedBox(height: 10),

// // //               Row(
// // //                 children: [
// // //                   Text("Date: ${DateFormat.yMMMd().format(_selectedDate)}",
// // //                       style: const TextStyle(fontSize: 16)),
// // //                   const Spacer(),
// // //                   TextButton(
// // //                     onPressed: () => _selectDate(context),
// // //                     child: const Text("Choose Date"),
// // //                   ),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 20),

// // //               ElevatedButton(
// // //                 onPressed: _submitTransaction,
// // //                 child: const Text("Add Transaction"),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // extension StringExtension on String {
// // //   String capitalize() => "${this[0].toUpperCase()}${substring(1)}";
// // // }

// //----------------------
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import '../models/transaction.dart';
// // import '../providers/transaction_provider.dart';
// // import '../providers/saving_goal_provider.dart';
// // import '../models/saving_goal.dart';

// // class AddTransactionScreen extends StatefulWidget {
// //   const AddTransactionScreen({super.key});

// //   @override
// //   State<AddTransactionScreen> createState() => _AddTransactionScreenState();
// // }

// // class _AddTransactionScreenState extends State<AddTransactionScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final TextEditingController _amountController = TextEditingController();
// //   final TextEditingController _descriptionController = TextEditingController();
// //   String _selectedType = 'expense';
// //   String _selectedCategory = 'Food';
// //   DateTime _selectedDate = DateTime.now();

// //   // ✅ New state for optional goal link
// //   String? _selectedGoalId;

// //   void _submitTransaction() {
// //     if (!_formKey.currentState!.validate()) return;

// //     final transaction = Transaction(
// //       id: DateTime.now().millisecondsSinceEpoch.toString(),
// //       userId: "user123", // Replace with actual user logic
// //       type: _selectedType,
// //       category: _selectedCategory,
// //       amount: double.parse(_amountController.text),
// //       date: _selectedDate,
// //       description: _descriptionController.text.trim(),
// //       savingGoalId: _selectedGoalId, // ✅ include selected goal ID
// //     );

// //     final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
// //     final savingGoalProvider = Provider.of<SavingGoalProvider>(context, listen: false);

// //     transactionProvider.addTransaction(transaction);

// //     // ✅ If a goal is selected, update its progress
// //     if (_selectedGoalId != null) {
// //       savingGoalProvider.updateGoalProgress(_selectedGoalId!, transaction.amount);
// //     }

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text("Transaction added successfully!")),
// //     );

// //     Navigator.pop(context);
// //   }

// //   void _presentDatePicker() async {
// //     final pickedDate = await showDatePicker(
// //       context: context,
// //       initialDate: _selectedDate,
// //       firstDate: DateTime(2020),
// //       lastDate: DateTime.now(),
// //     );
// //     if (pickedDate != null) {
// //       setState(() {
// //         _selectedDate = pickedDate;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final goals = Provider.of<SavingGoalProvider>(context).savingGoals;

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Add Transaction'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: ListView(
// //             children: [
// //               // ✅ Type Selection
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: RadioListTile<String>(
// //                       title: const Text('Income'),
// //                       value: 'income',
// //                       groupValue: _selectedType,
// //                       onChanged: (value) {
// //                         setState(() => _selectedType = value!);
// //                       },
// //                     ),
// //                   ),
// //                   Expanded(
// //                     child: RadioListTile<String>(
// //                       title: const Text('Expense'),
// //                       value: 'expense',
// //                       groupValue: _selectedType,
// //                       onChanged: (value) {
// //                         setState(() => _selectedType = value!);
// //                       },
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 10),

// //               // ✅ Amount Field
// //               TextFormField(
// //                 controller: _amountController,
// //                 decoration: const InputDecoration(labelText: 'Amount'),
// //                 keyboardType: TextInputType.number,
// //                 validator: (value) {
// //                   if (value == null || double.tryParse(value) == null) {
// //                     return 'Enter a valid amount';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               const SizedBox(height: 10),

// //               // ✅ Category Selection
// //               DropdownButtonFormField<String>(
// //                 value: _selectedCategory,
// //                 items: const [
// //                   DropdownMenuItem(value: 'Food', child: Text('Food')),
// //                   DropdownMenuItem(value: 'Transport', child: Text('Transport')),
// //                   DropdownMenuItem(value: 'Bills', child: Text('Bills')),
// //                   DropdownMenuItem(value: 'Salary', child: Text('Salary')),
// //                   DropdownMenuItem(value: 'Other', child: Text('Other')),
// //                 ],
// //                 onChanged: (value) {
// //                   setState(() => _selectedCategory = value!);
// //                 },
// //                 decoration: const InputDecoration(labelText: 'Category'),
// //               ),
// //               const SizedBox(height: 10),

// //               // ✅ Description Field
// //               TextFormField(
// //                 controller: _descriptionController,
// //                 decoration: const InputDecoration(labelText: 'Description'),
// //               ),
// //               const SizedBox(height: 10),

// //               // ✅ Saving Goal Dropdown (optional)
// //               if (goals.isNotEmpty)
// //                 DropdownButtonFormField<String>(
// //                   value: _selectedGoalId,
// //                   items: goals.map((goal) {
// //                     return DropdownMenuItem(
// //                       value: goal.id,
// //                       child: Text(goal.title),
// //                     );
// //                   }).toList(),
// //                   onChanged: (value) {
// //                     setState(() => _selectedGoalId = value);
// //                   },
// //                   decoration: const InputDecoration(
// //                     labelText: 'Link to Saving Goal (optional)',
// //                   ),
// //                 ),
// //               if (goals.isNotEmpty) const SizedBox(height: 10),

// //               // ✅ Date Picker
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: Text(
// //                       'Date: ${_selectedDate.toLocal()}'.split(' ')[0],
// //                     ),
// //                   ),
// //                   TextButton(
// //                     onPressed: _presentDatePicker,
// //                     child: const Text('Choose Date'),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 20),

// //               // ✅ Submit Button
// //               ElevatedButton(
// //                 onPressed: _submitTransaction,
// //                 child: const Text('Add Transaction'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //--------------------------------
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:intl/intl.dart';
// // import '../providers/transaction_provider.dart';
// // import '../models/transaction.dart';

// // class AddTransactionScreen extends StatefulWidget {
// //   const AddTransactionScreen({super.key});

// //   @override
// //   _AddTransactionScreenState createState() => _AddTransactionScreenState();
// // }

// // class _AddTransactionScreenState extends State<AddTransactionScreen> {
// //   final _amountController = TextEditingController();
// //   final _descriptionController = TextEditingController();
// //   String _selectedType = 'expense';
// //   String _selectedCategory = 'Groceries';
// //   DateTime _selectedDate = DateTime.now();
// //   final _formKey = GlobalKey<FormState>();

// //   void _submitTransaction() {
// //     if (!_formKey.currentState!.validate()) return;

// //     final transaction = Transaction(
// //       id: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
// //       userId: "user123", // TODO: Replace with actual logged-in user ID
// //       type: _selectedType,
// //       category: _selectedCategory,
// //       amount: double.parse(_amountController.text),
// //       date: _selectedDate,
// //       description: _descriptionController.text.trim(),
// //     );

// //     Provider.of<TransactionProvider>(context, listen: false).addTransaction(transaction);

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text("Transaction added successfully!")),
// //     );

// //     Navigator.pop(context);
// //   }

// //   Future<void> _selectDate(BuildContext context) async {
// //     final picked = await showDatePicker(
// //       context: context,
// //       initialDate: _selectedDate,
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime.now(),
// //     );
// //     if (picked != null && picked != _selectedDate) {
// //       setState(() => _selectedDate = picked);
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _amountController.dispose();
// //     _descriptionController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Add Transaction")),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: ListView(
// //             children: [
// //               DropdownButtonFormField<String>(
// //                 value: _selectedType,
// //                 items: ['income', 'expense'].map((type) {
// //                   return DropdownMenuItem(value: type, child: Text(type.capitalize()));
// //                 }).toList(),
// //                 onChanged: (value) => setState(() => _selectedType = value ?? _selectedType),
// //                 decoration: const InputDecoration(labelText: "Transaction Type"),
// //               ),
// //               const SizedBox(height: 10),

// //               TextFormField(
// //                 controller: _amountController,
// //                 decoration: const InputDecoration(labelText: "Amount"),
// //                 keyboardType: TextInputType.number,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) return "Amount is required";
// //                   if (double.tryParse(value) == null) return "Enter a valid number";
// //                   return null;
// //                 },
// //               ),
// //               const SizedBox(height: 10),

// //               DropdownButtonFormField<String>(
// //                 value: _selectedCategory,
// //                 items: ['Groceries', 'Utilities', 'Entertainment', 'Salary', 'Other'].map((category) {
// //                   return DropdownMenuItem(value: category, child: Text(category));
// //                 }).toList(),
// //                 onChanged: (value) => setState(() => _selectedCategory = value ?? _selectedCategory),
// //                 decoration: const InputDecoration(labelText: "Category"),
// //               ),
// //               const SizedBox(height: 10),

// //               TextFormField(
// //                 controller: _descriptionController,
// //                 decoration: const InputDecoration(labelText: "Description"),
// //                 maxLines: 2,
// //               ),
// //               const SizedBox(height: 10),

// //               Row(
// //                 children: [
// //                   Text("Date: ${DateFormat.yMMMd().format(_selectedDate)}",
// //                       style: const TextStyle(fontSize: 16)),
// //                   const Spacer(),
// //                   TextButton(
// //                     onPressed: () => _selectDate(context),
// //                     child: const Text("Choose Date"),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 20),

// //               ElevatedButton(
// //                 onPressed: _submitTransaction,
// //                 child: const Text("Add Transaction"),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // extension StringExtension on String {
// //   String capitalize() => "${this[0].toUpperCase()}${substring(1)}";
// // }


// //-------------------------------------------

// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:intl/intl.dart';
// // import '../models/transaction.dart';
// // import '../providers/transaction_provider.dart';
// // import '../providers/saving_goal_provider.dart';
// // import '../models/saving_goal.dart';

// // class AddTransactionScreen extends StatefulWidget {
// //   const AddTransactionScreen({super.key});

// //   @override
// //   _AddTransactionScreenState createState() => _AddTransactionScreenState();
// // }

// // class _AddTransactionScreenState extends State<AddTransactionScreen> {
// //   final _amountController = TextEditingController();
// //   final _descriptionController = TextEditingController();
// //   String _selectedType = 'expense';
// //   String _selectedCategory = 'Groceries';
// //   DateTime _selectedDate = DateTime.now();
// //   final _formKey = GlobalKey<FormState>();

// //   // ✅ Added saving goal functionality
// //   int? _selectedGoalId;

// //   void _submitTransaction() {
// //     if (!_formKey.currentState!.validate()) return;

// //     final transaction = Transaction(
// //       id: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
// //       userId: "user123", // TODO: Replace with actual logged-in user ID
// //       type: _selectedType,
// //       category: _selectedCategory,
// //       amount: double.parse(_amountController.text),
// //       date: _selectedDate, 
// //       description: _descriptionController.text.trim(),
// //       savingGoalId: _selectedGoalId?.toString(), // ✅ Include goal ID if selected
// //     );

// //     final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
// //     final savingGoalProvider = Provider.of<SavingGoalProvider>(context, listen: false);

// //     transactionProvider.addTransaction(transaction);

// //     // ✅ Update saving goal progress if linked
// //     if (_selectedGoalId != null && _selectedType == 'income') {
// //       savingGoalProvider.updateGoalProgress(_selectedGoalId.toString(), transaction.amount);
// //     }

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text("Transaction added successfully!")),
// //     );

// //     Navigator.pop(context);
// //   }

// //   Future<void> _selectDate(BuildContext context) async {
// //     final picked = await showDatePicker(
// //       context: context,
// //       initialDate: _selectedDate,
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime.now(),
// //     );
// //     if (picked != null && picked != _selectedDate) {
// //       setState(() => _selectedDate = picked);
// //     }
// //   }

// //   // ✅ Update categories based on transaction type
// //   List<String> get _categories {
// //     if (_selectedType == 'income') {
// //       return ['Salary', 'Freelance', 'Business', 'Investment', 'Gift', 'Other'];
// //     } else {
// //       return ['Groceries', 'Utilities', 'Entertainment', 'Transport', 'Bills', 'Healthcare', 'Shopping', 'Other'];
// //     }
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     // ✅ Set default category based on initial type
// //     _updateCategoryForType();
// //   }

// //   void _updateCategoryForType() {
// //     // ✅ Set appropriate default category when type changes
// //     if (_selectedType == 'income' && !_categories.contains(_selectedCategory)) {
// //       _selectedCategory = 'Salary';
// //     } else if (_selectedType == 'expense' && !_categories.contains(_selectedCategory)) {
// //       _selectedCategory = 'Groceries';
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final goals = Provider.of<SavingGoalProvider>(context).savingGoals;

// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Add Transaction")),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: ListView(
// //             children: [
// //               // ✅ Transaction Type with better styling
// //               DropdownButtonFormField<String>(
// //                 value: _selectedType,
// //                 items: ['income', 'expense'].map((type) {
// //                   return DropdownMenuItem(
// //                     value: type, 
// //                     child: Row(
// //                       children: [
// //                         Icon(
// //                           type == 'income' ? Icons.trending_up : Icons.trending_down,
// //                           color: type == 'income' ? Colors.green : Colors.red,
// //                           size: 20,
// //                         ),
// //                         const SizedBox(width: 8),
// //                         Text(type.capitalize()),
// //                       ],
// //                     ),
// //                   );
// //                 }).toList(),
// //                 onChanged: (value) {
// //                   setState(() {
// //                     _selectedType = value ?? _selectedType;
// //                     _updateCategoryForType(); // ✅ Update category when type changes
// //                     _selectedGoalId = null; // ✅ Reset goal selection when type changes
// //                   });
// //                 },
// //                 decoration: const InputDecoration(
// //                   labelText: "Transaction Type",
// //                   border: OutlineInputBorder(),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),

// //               // ✅ Amount field with currency formatting
// //               TextFormField(
// //                 controller: _amountController,
// //                 decoration: const InputDecoration(
// //                   labelText: "Amount (RWF)",
// //                   border: OutlineInputBorder(),
// //                   prefixIcon: Icon(Icons.monetization_on),
// //                 ),
// //                 keyboardType: TextInputType.number,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) return "Amount is required";
// //                   if (double.tryParse(value) == null) return "Enter a valid number";
// //                   if (double.parse(value) <= 0) return "Amount must be greater than 0";
// //                   return null;
// //                 },
// //               ),
// //               const SizedBox(height: 16),

// //               // ✅ Dynamic category dropdown
// //               DropdownButtonFormField<String>(
// //                 value: _selectedCategory,
// //                 items: _categories.map((category) {
// //                   return DropdownMenuItem(value: category, child: Text(category));
// //                 }).toList(),
// //                 onChanged: (value) => setState(() => _selectedCategory = value ?? _selectedCategory),
// //                 decoration: const InputDecoration(
// //                   labelText: "Category",
// //                   border: OutlineInputBorder(),
// //                   prefixIcon: Icon(Icons.category),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),

// //               // ✅ Optional saving goal link (only for income)
// //               if (goals.isNotEmpty && _selectedType == 'income') ...[
// //                 DropdownButtonFormField<int>(
// //                   value: _selectedGoalId,
// //                   items: [
// //                     const DropdownMenuItem<int>(
// //                       value: null,
// //                       child: Text('None (optional)'),
// //                     ),
// //                     ...goals
// //                         .where((goal) => goal.id != null)
// //                         .map((goal) {
// //                       return DropdownMenuItem<int>(
// //                         value: goal.id!,
// //                         child: Text(goal.title),
// //                       );
// //                     }).toList(),
// //                   ],
// //                   onChanged: (value) {
// //                     setState(() => _selectedGoalId = value);
// //                   },
// //                   decoration: const InputDecoration(
// //                     labelText: 'Link to Saving Goal (optional)',
// //                     border: OutlineInputBorder(),
// //                     prefixIcon: Icon(Icons.savings),
// //                     hintText: 'Select a goal to contribute to',
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //               ],

// //               // ✅ Description with better styling
// //               TextFormField(
// //                 controller: _descriptionController,
// //                 decoration: const InputDecoration(
// //                   labelText: "Description",
// //                   border: OutlineInputBorder(),
// //                   prefixIcon: Icon(Icons.description),
// //                   hintText: "Enter transaction details",
// //                 ),
// //                 maxLines: 2,
// //               ),
// //               const SizedBox(height: 16),

// //               // ✅ Date selector with better UI
// //               Container(
// //                 padding: const EdgeInsets.all(16),
// //                 decoration: BoxDecoration(
// //                   border: Border.all(color: Colors.grey),
// //                   borderRadius: BorderRadius.circular(4),
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     const Icon(Icons.calendar_today, color: Colors.grey),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: Text(
// //                         "Date: ${DateFormat.yMMMd().format(_selectedDate)}",
// //                         style: const TextStyle(fontSize: 16),
// //                       ),
// //                     ),
// //                     TextButton.icon(
// //                       onPressed: () => _selectDate(context),
// //                       icon: const Icon(Icons.edit_calendar),
// //                       label: const Text("Change"),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 24),
              

// //               // ✅ Submit button with better styling
// //               ElevatedButton.icon(
// //                 onPressed: _submitTransaction,
// //                 icon: const Icon(Icons.add),
// //                 label: const Text("Add Transaction"),
// //                 style: ElevatedButton.styleFrom(
// //                   padding: const EdgeInsets.symmetric(vertical: 16),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ✅ String extension for capitalizing first letter
// // extension StringExtension on String {
// //   String capitalize() => "${this[0].toUpperCase()}${substring(1)}";
// // }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import '../models/transaction.dart';
// import '../providers/transaction_provider.dart';
// import '../providers/saving_goal_provider.dart';
// import '../models/saving_goal.dart';
// import '../providers/budget_provider.dart'; // ✅ Added

// class AddTransactionScreen extends StatefulWidget {
//   const AddTransactionScreen({super.key});

//   @override
//   _AddTransactionScreenState createState() => _AddTransactionScreenState();
// }

// class _AddTransactionScreenState extends State<AddTransactionScreen> {
//   final _amountController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   String _selectedType = 'expense';
//   String _selectedCategory = 'Groceries';
//   DateTime _selectedDate = DateTime.now();
//   final _formKey = GlobalKey<FormState>();
//   int? _selectedGoalId;

//   void _submitTransaction() {
//     if (!_formKey.currentState!.validate()) return;

//     final amount = double.parse(_amountController.text);
//     final transaction = Transaction(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       userId: "user123", // TODO: Replace with actual logged-in user ID
//       type: _selectedType,
//       category: _selectedCategory,
//       amount: amount,
//       date: _selectedDate,
//       description: _descriptionController.text.trim(),
//       savingGoalId: _selectedGoalId?.toString(),
//     );

//     final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
//     final savingGoalProvider = Provider.of<SavingGoalProvider>(context, listen: false);
//     final budgetProvider = Provider.of<BudgetProvider>(context, listen: false); // ✅

//     transactionProvider.addTransaction(transaction);

//     if (_selectedGoalId != null && _selectedType == 'income') {
//       savingGoalProvider.updateGoalProgress(_selectedGoalId.toString(), amount);
//     }

//     // ✅ Update budget only if it's an expense
//     if (_selectedType == 'expense') {
//       budgetProvider.updateRemainingBudget(amount);
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Transaction added successfully!")),
//     );

//     Navigator.pop(context);
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() => _selectedDate = picked);
//     }
//   }

//   List<String> get _categories {
//     if (_selectedType == 'income') {
//       return ['Salary', 'Freelance', 'Business', 'Investment', 'Gift', 'Other'];
//     } else {
//       return ['Groceries', 'Utilities', 'Entertainment', 'Transport', 'Bills', 'Healthcare', 'Shopping', 'Other'];
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _updateCategoryForType();
//   }

//   void _updateCategoryForType() {
//     if (_selectedType == 'income' && !_categories.contains(_selectedCategory)) {
//       _selectedCategory = 'Salary';
//     } else if (_selectedType == 'expense' && !_categories.contains(_selectedCategory)) {
//       _selectedCategory = 'Groceries';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final goals = Provider.of<SavingGoalProvider>(context).savingGoals;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Transaction")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               DropdownButtonFormField<String>(
//                 value: _selectedType,
//                 items: ['income', 'expense'].map((type) {
//                   return DropdownMenuItem(
//                     value: type,
//                     child: Row(
//                       children: [
//                         Icon(
//                           type == 'income' ? Icons.trending_up : Icons.trending_down,
//                           color: type == 'income' ? Colors.green : Colors.red,
//                           size: 20,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(type.capitalize()),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedType = value ?? _selectedType;
//                     _updateCategoryForType();
//                     _selectedGoalId = null;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: "Transaction Type",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               TextFormField(
//                 controller: _amountController,
//                 decoration: const InputDecoration(
//                   labelText: "Amount (RWF)",
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.monetization_on),
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return "Amount is required";
//                   if (double.tryParse(value) == null) return "Enter a valid number";
//                   if (double.parse(value) <= 0) return "Amount must be greater than 0";
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),

//               DropdownButtonFormField<String>(
//                 value: _selectedCategory,
//                 items: _categories.map((category) {
//                   return DropdownMenuItem(value: category, child: Text(category));
//                 }).toList(),
//                 onChanged: (value) => setState(() => _selectedCategory = value ?? _selectedCategory),
//                 decoration: const InputDecoration(
//                   labelText: "Category",
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.category),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               if (goals.isNotEmpty && _selectedType == 'income') ...[
//                 DropdownButtonFormField<int>(
//                   value: _selectedGoalId,
//                   items: [
//                     const DropdownMenuItem<int>(
//                       value: null,
//                       child: Text('None (optional)'),
//                     ),
//                     ...goals.where((goal) => goal.id != null).map((goal) {
//                       return DropdownMenuItem<int>(
//                         value: goal.id!,
//                         child: Text(goal.title),
//                       );
//                     }).toList(),
//                   ],
//                   onChanged: (value) {
//                     setState(() => _selectedGoalId = value);
//                   },
//                   decoration: const InputDecoration(
//                     labelText: 'Link to Saving Goal (optional)',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.savings),
//                     hintText: 'Select a goal to contribute to',
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//               ],

//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: "Description",
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.description),
//                   hintText: "Enter transaction details",
//                 ),
//                 maxLines: 2,
//               ),
//               const SizedBox(height: 16),

//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.calendar_today, color: Colors.grey),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         "Date: ${DateFormat.yMMMd().format(_selectedDate)}",
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ),
//                     TextButton.icon(
//                       onPressed: () => _selectDate(context),
//                       icon: const Icon(Icons.edit_calendar),
//                       label: const Text("Change"),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),

//               ElevatedButton.icon(
//                 onPressed: _submitTransaction,
//                 icon: const Icon(Icons.add),
//                 label: const Text("Add Transaction"),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ✅ Extension remains unchanged
// extension StringExtension on String {
//   String capitalize() => "${this[0].toUpperCase()}${substring(1)}";
// }

//......................................................................
import 'package:expense_tracker_pro/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../providers/saving_goal_provider.dart';
import '../models/saving_goal.dart';
import '../providers/budget_provider.dart';
import '../models/budget.dart';

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

  // void _submitTransaction() async { // ✅ Made async
  //   if (!_formKey.currentState!.validate()) return;

    void _submitTransaction() async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final userId = authProvider.currentUser?.id;

  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User not logged in')),
    );
    return;
  }

    final amount = double.parse(_amountController.text);
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId, // TODO: Replace with actual logged-in user ID
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

    transactionProvider.addTransaction(transaction);

    if (_selectedGoalId != null && _selectedType == 'income') {
      savingGoalProvider.updateGoalProgress(_selectedGoalId.toString(), amount);
    }

    // ✅ Update budget only if it's an expense
    if (_selectedType == 'expense') {
      // Find the budget that matches this transaction's category or an 'all' budget
      Budget? matchingBudget;
      
      // First try to find a budget specific to this category
      try {
        matchingBudget = budgetProvider.budgets.firstWhere(
          (budget) => budget.category == _selectedCategory && budget.isActive,
        );
      } catch (e) {
        // If no specific category budget found, try to find an 'all' budget
        try {
          matchingBudget = budgetProvider.budgets.firstWhere(
            (budget) => budget.category == 'all' && budget.isActive,
          );
        } catch (e) {
          // No matching budget found
          matchingBudget = null;
        }
      }
      
      if (matchingBudget != null) {
        // Calculate new remaining amount (subtract expense from current remaining)
        final newRemainingAmount = matchingBudget.remaining - amount;
        
        // Update the budget with the new remaining amount
        await budgetProvider.updateRemainingBudget(matchingBudget.id, newRemainingAmount);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Transaction added successfully!")),
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
    // ✅ Load budgets when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BudgetProvider>(context, listen: false).fetchBudgets();
    });
  }

  void _updateCategoryForType() {
    if (_selectedType == 'income' && !_categories.contains(_selectedCategory)) {
      _selectedCategory = 'Salary';
    } else if (_selectedType == 'expense' && !_categories.contains(_selectedCategory)) {
      _selectedCategory = 'Groceries';
    }
  }

  @override
  Widget build(BuildContext context) {
    final goals = Provider.of<SavingGoalProvider>(context).savingGoals;
    final budgets = Provider.of<BudgetProvider>(context).budgets;

    return Scaffold(
      appBar: AppBar(title: const Text("Add Transaction")),
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
                        Text(type.capitalize()),
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
                decoration: const InputDecoration(
                  labelText: "Transaction Type",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: "Amount (RWF)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monetization_on),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Amount is required";
                  if (double.tryParse(value) == null) return "Enter a valid number";
                  if (double.parse(value) <= 0) return "Amount must be greater than 0";
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value ?? _selectedCategory),
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Show budget info for expense transactions
              if (_selectedType == 'expense' && budgets.isNotEmpty) ...[
                Consumer<BudgetProvider>(
                  builder: (context, budgetProvider, child) {
                    // Find matching budget for the selected category
                    Budget? matchingBudget;
                    try {
                      matchingBudget = budgetProvider.budgets.firstWhere(
                        (budget) => budget.category == _selectedCategory && budget.isActive,
                      );
                    } catch (e) {
                      try {
                        matchingBudget = budgetProvider.budgets.firstWhere(
                          (budget) => budget.category == 'all' && budget.isActive,
                        );
                      } catch (e) {
                        matchingBudget = null;
                      }
                    }

                    if (matchingBudget != null) {
                      final remainingPercentage = (matchingBudget.remaining / matchingBudget.amount) * 100;
                      final isLowBudget = remainingPercentage < 20;
                      
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
                                Text(
                                  'Budget: ${matchingBudget.name}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isLowBudget ? Colors.red.shade700 : Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Remaining: RWF ${NumberFormat('#,##0.00').format(matchingBudget.remaining)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isLowBudget ? Colors.red.shade800 : Colors.blue.shade800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: remainingPercentage / 100,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isLowBudget ? Colors.red : Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${remainingPercentage.toStringAsFixed(1)}% remaining',
                              style: TextStyle(
                                fontSize: 12,
                                color: isLowBudget ? Colors.red.shade600 : Colors.blue.shade600,
                              ),
                            ),
                            if (isLowBudget) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.warning, color: Colors.red.shade600, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Low budget remaining!',
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
                                'No budget found for this category. Consider creating one!',
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
                  },
                ),
                const SizedBox(height: 16),
              ],

              if (goals.isNotEmpty && _selectedType == 'income') ...[
                DropdownButtonFormField<int>(
                  value: _selectedGoalId,
                  items: [
                    const DropdownMenuItem<int>(
                      value: null,
                      child: Text('None (optional)'),
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
                  decoration: const InputDecoration(
                    labelText: 'Link to Saving Goal (optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.savings),
                    hintText: 'Select a goal to contribute to',
                  ),
                ),
                const SizedBox(height: 16),
              ],

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  hintText: "Enter transaction details",
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
                        "Date: ${DateFormat.yMMMd().format(_selectedDate)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.edit_calendar),
                      label: const Text("Change"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _submitTransaction,
                icon: const Icon(Icons.add),
                label: const Text("Add Transaction"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ✅ Extension remains unchanged
extension StringExtension on String {
  String capitalize() => "${this[0].toUpperCase()}${substring(1)}";
}