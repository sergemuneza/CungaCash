//Financial Summary Screen 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import '../services/pdf_service.dart';

class FinancialSummaryScreen extends StatefulWidget {
  const FinancialSummaryScreen({super.key});

  @override
  _FinancialSummaryScreenState createState() => _FinancialSummaryScreenState();
}

class _FinancialSummaryScreenState extends State<FinancialSummaryScreen>
    with SingleTickerProviderStateMixin {
  DateTime selectedMonth = DateTime.now();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController, 
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutQuart),
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false).fetchTransactions();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    List<Transaction> monthlyTransactions = transactions.where((t) {
      return t.date.year == selectedMonth.year && t.date.month == selectedMonth.month;
    }).toList();

    double totalIncome = monthlyTransactions
        .where((t) => t.type == 'income')
        .fold(0, (sum, t) => sum + t.amount);

    double totalExpenses = monthlyTransactions
        .where((t) => t.type == 'expense')
        .fold(0, (sum, t) => sum + t.amount);

    double balance = totalIncome - totalExpenses;

    Map<String, double> categoryTotals = {};
    for (var transaction in monthlyTransactions.where((t) => t.type == 'expense')) {
      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(theme),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.05),
                        theme.colorScheme.surface,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildMonthPicker(),
                        const SizedBox(height: 24),
                        _buildEnhancedFinancialMetricsGrid(totalIncome, totalExpenses, balance),
                        const SizedBox(height: 24),
                        _buildDownloadSection(),
                        const SizedBox(height: 20),
                        _buildCompactExpenseBreakdownSection(categoryTotals),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 80,
      floating: false,
      pinned: true,
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          "monthly_financial_report".tr(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavigationButton(
            Icons.chevron_left_rounded,
            () {
              setState(() {
                selectedMonth = DateTime(selectedMonth.year, selectedMonth.month - 1, 1);
              });
            },
          ),
          Expanded(
            child: Text(
              DateFormat.yMMMM().format(selectedMonth),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          _buildNavigationButton(
            Icons.chevron_right_rounded,
            () {
              setState(() {
                selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 1);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onPressed,
        color: Theme.of(context).colorScheme.primary,
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(8),
        ),
      ),
    );
  }

  Widget _buildEnhancedFinancialMetricsGrid(double totalIncome, double totalExpenses, double balance) {
    return Column(
      children: [
        // Enhanced Balance Card - Most Prominent
        _buildEnhancedBalanceCard(balance),
        const SizedBox(height: 12),
        // Income and Expenses Row - Larger cards
        Row(
          children: [
            Expanded(
              child: _buildEnhancedMetricCard(
                "total_income".tr(),
                totalIncome,
                Icons.trending_up_rounded,
                const Color(0xFF10B981),
                const Color(0xFF10B981).withOpacity(0.1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildEnhancedMetricCard(
                "total_expenses".tr(),
                totalExpenses,
                Icons.trending_down_rounded,
                const Color(0xFFEF4444),
                const Color(0xFFEF4444).withOpacity(0.1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEnhancedMetricCard(String title, double value, IconData icon, Color color, Color backgroundColor) {
    String displayValue = "${value.toStringAsFixed(0)} Frw";

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            displayValue,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedBalanceCard(double balance) {
    Color balanceColor = balance >= 0 ? const Color(0xFF3B82F6) : const Color(0xFFF59E0B);
    String balanceText = balance >= 0 ? "positive_balance".tr() : "negative_balance".tr();
    IconData balanceIcon = balance >= 0 ? Icons.account_balance_wallet_rounded : Icons.warning_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            balanceColor.withOpacity(0.12),
            balanceColor.withOpacity(0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: balanceColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: balanceColor.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: -3,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: balanceColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(balanceIcon, color: balanceColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "balance".tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: balanceColor.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${balance.toStringAsFixed(0)} Frw",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: balanceColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: balanceColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              balanceText,
              style: TextStyle(
                color: balanceColor,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.15),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "generate_report".tr(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDownloadButton(),
        ],
      ),
    );
  }

  Widget _buildDownloadButton() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: -1,
          ),
        ],
      ),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.file_download_rounded, size: 16),
        label: Text(
          "download_pdf".tr(),
          style: const TextStyle(
            fontSize: 13, 
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () async {
          try {
            final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
            final transactions = transactionProvider.transactions;
            List<Transaction> monthlyTransactions = transactions.where((t) {
              return t.date.year == selectedMonth.year && t.date.month == selectedMonth.month;
            }).toList();

            final file = await PDFService.generateTransactionReport(monthlyTransactions);
            OpenFile.open(file.path);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${"failed_generate_report".tr()}: $e"),
                backgroundColor: const Color(0xFFEF4444),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildCompactExpenseBreakdownSection(Map<String, double> categoryTotals) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.pie_chart_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "expense_breakdown".tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          categoryTotals.isEmpty
              ? _buildEmptyExpensesState()
              : Column(
                  children: [
                    SizedBox(
                      height: 160,
                      child: PieChart(
                        PieChartData(
                          sections: categoryTotals.entries.map((entry) {
                            double percentage = (entry.value / categoryTotals.values.fold(0, (a, b) => a + b) * 100);
                            return PieChartSectionData(
                              value: entry.value,
                              title: percentage > 10 ? "${percentage.toStringAsFixed(0)}%" : "",
                              color: _getCategoryColor(entry.key),
                              radius: 50,
                              titleStyle: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          centerSpaceRadius: 30,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildCompactCategoryLegend(categoryTotals),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyExpensesState() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 32,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "no_expenses".tr(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            "No expenses recorded for this month",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactCategoryLegend(Map<String, double> categoryTotals) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categoryTotals.entries.map((entry) {
        String localizedCategory = _getLocalizedCategoryName(entry.key);
        Color categoryColor = _getCategoryColor(entry.key);
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: categoryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: categoryColor.withOpacity(0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: categoryColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                "$localizedCategory: ${entry.value.toStringAsFixed(0)} Frw",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: categoryColor.withOpacity(0.9),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getLocalizedCategoryName(String category) {
    switch (category.toLowerCase()) {
      case "groceries":
        return "groceries".tr();
      case "utilities":
        return "utilities".tr();
      case "entertainment":
        return "entertainment".tr();
      case "salary":
        return "salary".tr();
      case "transport":
        return "transport".tr();
      case "health":
        return "health".tr();
      default:
        return "other".tr();
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case "groceries":
        return const Color(0xFFFF8C42);
      case "utilities":
        return const Color(0xFF3B82F6);
      case "entertainment":
        return const Color(0xFF8B5CF6);
      case "salary":
        return const Color(0xFF10B981);
      case "transport":
        return const Color(0xFF06B6D4);
      case "health":
        return const Color(0xFFEC4899);
      default:
        return const Color(0xFF6B7280);
    }
  }
}