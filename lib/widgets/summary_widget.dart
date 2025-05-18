// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/transaction_provider.dart';

// class SummaryWidget extends StatelessWidget {
//   const SummaryWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final transactions = Provider.of<TransactionProvider>(context).transactions;

//     double totalIncome = transactions
//         .where((txn) => txn.type == "income")
//         .fold(0, (sum, txn) => sum + txn.amount);

//     double totalExpense = transactions
//         .where((txn) => txn.type == "expense")
//         .fold(0, (sum, txn) => sum + txn.amount);

//     return Card(
//       elevation: 3,
//       margin: const EdgeInsets.all(16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Financial Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             Text("💰 Total Income: \$${totalIncome.toStringAsFixed(2)}",
//                 style: TextStyle(fontSize: 16, color: Colors.green)),
//             Text("💸 Total Expenses: \$${totalExpense.toStringAsFixed(2)}",
//                 style: TextStyle(fontSize: 16, color: Colors.red)),
//             Divider(),
//             Text("💲 Balance: \$${(totalIncome - totalExpense).toStringAsFixed(2)}",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/transaction_provider.dart';

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<TransactionProvider>(context).transactions;

    double totalIncome = transactions
        .where((txn) => txn.type == "income")
        .fold(0, (sum, txn) => sum + txn.amount);

    double totalExpense = transactions
        .where((txn) => txn.type == "expense")
        .fold(0, (sum, txn) => sum + txn.amount);

    double balance = totalIncome - totalExpense;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("financial_summary".tr(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("💰 ${'total_income'.tr()}: \$${totalIncome.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16, color: Colors.green)),
            Text("💸 ${'total_expenses'.tr()}: \$${totalExpense.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16, color: Colors.red)),
            const Divider(),
            Text("💲 ${'balance'.tr()}: \$${balance.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
