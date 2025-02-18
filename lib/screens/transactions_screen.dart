// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/transaction_provider.dart';
// import '../models/transaction.dart';

// class TransactionsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final transactionProvider = Provider.of<TransactionProvider>(context);
//     final transactions = transactionProvider.transactions;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Transactions")),
//       body: transactions.isEmpty
//           ? Center(child: Text("No transactions added yet."))
//           : ListView.builder(
//               itemCount: transactions.length,
//               itemBuilder: (context, index) {
//                 final transaction = transactions[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   child: ListTile(
//                     leading: Icon(
//                       transaction.type == "income" ? Icons.arrow_downward : Icons.arrow_upward,
//                       color: transaction.type == "income" ? Colors.green : Colors.red,
//                     ),
//                     title: Text(transaction.category),
//                     subtitle: Text(transaction.description ?? ""),
//                     trailing: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text("\$${transaction.amount.toStringAsFixed(2)}",
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                         Text(transaction.date),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Navigator.pushNamed(context, '/add-transaction'),
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
