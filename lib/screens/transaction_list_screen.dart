//Transaction List Screen
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import 'edit_transaction_screen.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  String _selectedCategory = 'all';
  DateTime? _startDate;
  DateTime? _endDate;
  String _sortOption = 'newest_first';
  bool _isFilterExpanded = false;

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    List<Transaction> transactions = List.from(transactionProvider.transactions);

    //  Apply Filters
    if (_selectedCategory != 'all') {
      transactions = transactions.where((t) => t.category == _selectedCategory).toList();
    }
    if (_startDate != null && _endDate != null) {
      transactions = transactions.where((t) {
        DateTime tDate = t.date;
        return tDate.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
            tDate.isBefore(_endDate!.add(const Duration(days: 1)));
      }).toList();
    }

    // Apply Sorting
    switch (_sortOption) {
      case 'newest_first':
        transactions.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'oldest_first':
        transactions.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'highest_amount':
        transactions.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case 'lowest_amount':
        transactions.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("transaction_list".tr()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blueAccent, Colors.blue.shade700],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 100), // Account for transparent AppBar

            Card(
              margin: const EdgeInsets.all(12),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.filter_list, color: Colors.blueAccent),
                    title: Text(
                      "filters".tr(), 
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(_isFilterExpanded ? Icons.expand_less : Icons.expand_more),
                    onTap: () => setState(() => _isFilterExpanded = !_isFilterExpanded),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _isFilterExpanded ? null : 0,
                    child: _isFilterExpanded
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    
                                    // Container(
                                    //   width: double.infinity,
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(8),
                                    //     border: Border.all(color: Colors.grey.shade300),
                                    //   ),
                                    //   child: DropdownButtonFormField<String>(
                                    //     value: _selectedCategory,
                                    //     items: [
                                    //       'all',
                                    //       'groceries',
                                    //       'utilities',
                                    //       'entertainment',
                                    //       'salary',
                                    //       'transport',
                                    //       'food',
                                    //       'health',
                                    //       'other'
                                    //     ].map((category) => DropdownMenuItem<String>(
                                    //         value: category, 
                                    //         child: Text(category.tr())
                                    //     )).toList(),
                                    //     onChanged: (value) => setState(() => _selectedCategory = value.toString()),
                                    //     decoration: InputDecoration(
                                    //       labelText: "category".tr(),
                                    //       border: InputBorder.none,
                                    //       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    //     ),
                                    //   ),
                                    // ),
                                    const SizedBox(height: 12),
                                    // Sort By Dropdown
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      child: DropdownButtonFormField<String>(
                                        value: _sortOption,
                                        items: [
                                          'newest_first',
                                          'oldest_first',
                                          'highest_amount',
                                          'lowest_amount'
                                        ].map((option) => DropdownMenuItem<String>(
                                            value: option, 
                                            child: Text(option.tr())
                                        )).toList(),
                                        onChanged: (value) => setState(() => _sortOption = value.toString()),
                                        decoration: InputDecoration(
                                          labelText: "sort_by".tr(),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _selectDateRange(context),
                                    icon: const Icon(Icons.date_range, size: 20),
                                    label: Text(_startDate != null && _endDate != null
                                        ? "${DateFormat('MMM dd').format(_startDate!)} - ${DateFormat('MMM dd').format(_endDate!)}"
                                        : "select_date_range".tr()),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent.withOpacity(0.1),
                                      foregroundColor: Colors.blueAccent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                ),
                                if (_startDate != null || _selectedCategory != 'all')
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: TextButton.icon(
                                      onPressed: () => setState(() {
                                        _selectedCategory = 'all';
                                        _startDate = null;
                                        _endDate = null;
                                      }),
                                      icon: const Icon(Icons.clear, size: 18),
                                      label: Text("clear_filters".tr()),
                                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),

            // Add Transaction Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add-transaction');
                  },
                  icon: const Icon(Icons.add),
                  label: Text("add_transaction".tr()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ),

            // Transaction Count & Summary
            if (transactions.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${transactions.length} ${"transactions_found".tr()}",
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 8),

          
            Expanded(
              child: transactions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            "no_data".tr(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "add_first_transaction".tr(),
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        String formattedDate = DateFormat('MMM dd, yyyy').format(transaction.date);
                        bool isIncome = transaction.type.toLowerCase() == 'income';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isIncome ? Colors.green.shade50 : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _getCategoryIcon(transaction.category),
                                color: isIncome ? Colors.green.shade600 : Colors.red.shade600,
                                size: 24,
                              ),
                            ),
                            
                            title: Text(
                              transaction.category.tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${isIncome ? '+' : '-'}${transaction.amount.toStringAsFixed(0)} Frw",
                                  style: TextStyle(
                                    color: isIncome ? Colors.green.shade600 : Colors.red.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isIncome ? Colors.green.shade100 : Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    //  UPDATED: Translate transaction type
                                    transaction.type.tr(),
                                    style: TextStyle(
                                      color: isIncome ? Colors.green.shade700 : Colors.red.shade700,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditTransactionScreen(transaction: transaction),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  //  Get Category Icon
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'groceries':
        return Icons.shopping_cart;
      case 'utilities':
        return Icons.electrical_services;
      case 'entertainment':
        return Icons.movie;
      case 'salary':
        return Icons.attach_money;
      case 'transport':
        return Icons.directions_car;
      case 'food':
        return Icons.restaurant;
      case 'health':
        return Icons.local_hospital;
      default:
        return Icons.category;
    }
  }

  //  Select Date Range Function
  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  /// Fetch transactions when screen loads
  void _loadTransactions() async {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    await transactionProvider.fetchTransactions();
  }
}

// ✅ Extension to Capitalize First Letter (removed since we're using .tr() now)
extension StringCapitalizeExt on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}