// // lib/screens/monthly_report_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/transaction_provider.dart';

// class MonthlyReportScreen extends StatelessWidget {
//   final int month;
//   final int year;

//   MonthlyReportScreen({required this.month, required this.year});

//   @override
//   Widget build(BuildContext context) {
//     final transactionProvider = Provider.of<TransactionProvider>(context);
//     final transactions = transactionProvider.getTransactionsByMonth(month, year);

//     double totalIncome = 0;
//     double totalExpense = 0;
//     for (var txn in transactions) {
//       if (txn.type == 'income') {
//         totalIncome += txn.amount;
//       } else {
//         totalExpense += txn.amount;
//       }
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text('Monthly Report - $month/$year')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Total Income: \$${totalIncome.toStringAsFixed(2)}'),
//             Text('Total Expenses: \$${totalExpense.toStringAsFixed(2)}'),
//             Text('Balance: \$${(totalIncome - totalExpense).toStringAsFixed(2)}'),
//           ],
//         ),
//       ),
//     );
//   }
// }
