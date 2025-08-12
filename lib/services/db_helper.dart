import 'package:cungacash/models/budget.dart';
import 'package:cungacash/models/transaction.dart' as model;
import 'package:cungacash/models/saving_goal.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class DBHelper {
  static Database? _database;

  // Initialize and get the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  // Insert a new user with a unique ID
  Future<int> insertUser(Map<String, dynamic> user) async {
    try {
      final db = await database; // Ensure database instance is retrieved

      // Ensure user_id is unique if not provided
      if (!user.containsKey('id') || user['id'] == null || user['id'].isEmpty) {
        user['id'] = Uuid().v4();
      }

      return await db.insert('users', user);
    } catch (e) {
      print(" Error inserting user: $e");
      return -1;
    }
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'expense_tracker.db');

    return await openDatabase(
      path,
      version: 2, //Increment version to trigger onUpgrade
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE users (
          id TEXT PRIMARY KEY,
          email TEXT UNIQUE,
          password TEXT,
          first_name TEXT,
          last_name TEXT,
          created_on TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE transactions (
          id TEXT PRIMARY KEY,
          user_id TEXT,
          type TEXT CHECK(type IN ('income', 'expense')),
          category TEXT,
          amount REAL NOT NULL CHECK(amount > 0),
          date TEXT NOT NULL,
          description TEXT,
          saving_goal_id TEXT,
          FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
          FOREIGN KEY (saving_goal_id) REFERENCES saving_goals (id) ON DELETE SET NULL
        )
      ''');


  await db.execute('''
  CREATE TABLE budgets(
    id TEXT PRIMARY KEY,
    user_id TEXT,
    name TEXT,
    category TEXT,
    amount REAL,
    remaining REAL,  --  Add this line
    start_date TEXT,
    end_date TEXT,
    period TEXT,
    is_active INTEGER,
    FOREIGN KEY (user_id) REFERENCES users (id)
  )
''');

        // Ensurint that saving_goals table is created
        await createGoalTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Create budgets table if upgrading from version 1
          await db.execute('''
      CREATE TABLE budgets(
        id TEXT PRIMARY KEY,
        user_id TEXT,
        name TEXT,
        category TEXT,
        amount REAL,
        remaining REAL,  --  Add this line
        start_date TEXT,
        end_date TEXT,
        period TEXT,
        is_active INTEGER,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
        }
        // Handle migration for existing databases
        if (oldVersion == 1 && newVersion == 2) {
          await db.execute('''
          ALTER TABLE transactions 
          ADD COLUMN saving_goal_id TEXT 
          REFERENCES saving_goals(id) ON DELETE SET NULL
        ''');
        }
      },
    );
  }

  // Get user by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> users = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      print(" Querying DB for email: $email");
      print(" Database returned: $users");

      if (users.isNotEmpty) return users.first;
      return null;
    } catch (e) {
      print(" Error fetching user by email: $e");
      return null;
    }
  }

  Future<void> createGoalTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS saving_goals (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      targetAmount REAL,
      savedAmount REAL,
      deadline TEXT
    )
  ''');
  }

  Future<int> insertSavingGoal(SavingGoal goal) async {
    final db = await database;
    return await db.insert('saving_goals', goal.toMap());
  }

  Future<List<SavingGoal>> getSavingGoals() async {
    final db = await database;
    final maps = await db.query('saving_goals');
    return maps.map((map) => SavingGoal.fromMap(map)).toList();
  }

  Future<int> deleteSavingGoal(int id) async {
    final db = await database;
    return await db.delete('saving_goals', where: 'id = ?', whereArgs: [id]);
  }


  Future<int> updateSavingGoal(SavingGoal goal) async {
    final db = await database;
    return await db.update(
      'saving_goals',
      goal.toMap(),
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

// Get transactions linked to a specific saving goal
  Future<List<model.Transaction>> getTransactionsForGoal(int goalId) async {
    final db = await database;
    final maps = await db.query(
      'transactions',
      where: 'saving_goal_id = ?',
      whereArgs: [goalId.toString()],
      orderBy: 'date DESC',
    );
    return maps.map((map) => model.Transaction.fromMap(map)).toList();
  }

// Calculate total contributed to a goal
  Future<double> getTotalContributedToGoal(int goalId) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT SUM(amount) as total 
    FROM transactions 
    WHERE saving_goal_id = ? AND type = 'income'
  ''', [goalId.toString()]);

    return (result.first['total'] as double?) ?? 0.0;
  }

// Create a new budget
  Future<void> createBudget(Budget budget) async {
    final db = await database;
    await db.insert(
      'budgets',
      budget.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Get all budgets for a user
  Future<List<Budget>> getBudgetsForUser(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'budgets',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Budget.fromMap(maps[i]);
    });
  }

// Update a budget
  Future<void> updateBudget(Budget budget) async {
    final db = await database;
    await db.update(
      'budgets',
      budget.toMap(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

// Delete a budget
  Future<void> deleteBudget(String id) async {
    final db = await database;
    await db.delete(
      'budgets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, double>> getBudgetRemaining(String userId, String category,
      {DateTime? startDate, DateTime? endDate}) async {
    final db = await database;

    try {
      print('=== Budget Calculation Debug ===');
      print('User ID: $userId');
      print('Category: $category');
      print('Start Date: $startDate');
      print('End Date: $endDate');

      // Get the budget for this category
      List<Map<String, dynamic>> budgetMaps;

      // First try to find budget with exact category match
      budgetMaps = await db.query(
        'budgets',
        where: 'user_id = ? AND category = ? AND is_active = 1',
        whereArgs: [userId, category],
      );

      // If no specific category budget found and category is not 'all', try 'all' budget
      if (budgetMaps.isEmpty && category != 'all') {
        budgetMaps = await db.query(
          'budgets',
          where: 'user_id = ? AND category = ? AND is_active = 1',
          whereArgs: [userId, 'all'],
        );
        print('No specific budget found, trying "all" budget');
      }

      if (budgetMaps.isEmpty) {
        print('No budget found for category: $category');
        return {
          'budget': 0.0,
          'spent': 0.0,
          'remaining': 0.0,
          'percentage': 0.0,
        };
      }

      // Get the budget amount
      final budgetAmount = (budgetMaps.first['amount'] as num).toDouble();
      print('Budget Amount: $budgetAmount');

      // Use provided date range or budget's date range
      DateTime effectiveStartDate, effectiveEndDate;

      if (startDate != null && endDate != null) {
        effectiveStartDate = startDate;
        effectiveEndDate = endDate;
      } else {
        // Use the budget's date range
        final budgetData = budgetMaps.first;
        effectiveStartDate = DateTime.parse(budgetData['start_date']);
        effectiveEndDate = DateTime.parse(budgetData['end_date']);
      }

      print(
          'Effective Date Range: ${effectiveStartDate.toIso8601String()} to ${effectiveEndDate.toIso8601String()}');

      // Build the transaction query
      String whereClause = 'user_id = ? AND type = ?';
      List<dynamic> whereArgs = [userId, 'expense'];

      // Add category filter
      if (category != 'all') {
        whereClause += ' AND category = ?';
        whereArgs.add(category);
      }

      // Add date range filter - comparing ISO8601 strings
      whereClause += ' AND date >= ? AND date <= ?';
      whereArgs.add(effectiveStartDate.toIso8601String());
      whereArgs.add(effectiveEndDate.toIso8601String());

      print('Transaction Query WHERE: $whereClause');
      print('Transaction Query ARGS: $whereArgs');

      // Get matching transactions
      final List<Map<String, dynamic>> transactions = await db.query(
        'transactions',
        where: whereClause,
        whereArgs: whereArgs,
      );

      print('Found ${transactions.length} matching transactions');

      // Calculate total spent
      double totalSpent = 0.0;
      for (final transaction in transactions) {
        final amount = (transaction['amount'] as num).toDouble();
        totalSpent += amount;
        print(
            'Transaction: ${transaction['category']} - ${transaction['description']} - $amount');
      }

      final double remaining = budgetAmount - totalSpent;
      final double percentage =
          budgetAmount > 0 ? (totalSpent / budgetAmount) * 100 : 0.0;

      print('Final Calculation:');
      print('  Budget: $budgetAmount');
      print('  Spent: $totalSpent');
      print('  Remaining: $remaining');
      print('  Percentage: ${percentage.toStringAsFixed(1)}%');
      print('=== End Debug ===');

      return {
        'budget': budgetAmount,
        'spent': totalSpent,
        'remaining': remaining,
        'percentage': percentage,
      };
    } catch (e) {
      print('Error in getBudgetRemaining: $e');
      print('Stack trace: ${StackTrace.current}');
      return {
        'budget': 0.0,
        'spent': 0.0,
        'remaining': 0.0,
        'percentage': 0.0,
      };
    }
  }

// Also update your getActiveBudgetsForCategory method:
  Future<List<Budget>> getActiveBudgetsForCategory(
      String userId, String category) async {
    final db = await database;

    try {
      List<Map<String, dynamic>> maps;

      // Get budgets for the specific category
      maps = await db.query(
        'budgets',
        where: 'user_id = ? AND category = ? AND is_active = 1',
        whereArgs: [userId, category],
      );

      // If no specific category budget found and not looking for 'all', try 'all' budget
      if (maps.isEmpty && category != 'all') {
        maps = await db.query(
          'budgets',
          where: 'user_id = ? AND category = ? AND is_active = 1',
          whereArgs: [userId, 'all'],
        );
      }

      print('Found ${maps.length} active budgets for category: $category');
      for (var map in maps) {
        print(
            '  Budget: ${map['name']} - Amount: ${map['amount']} - Category: ${map['category']}');
      }

      return List.generate(maps.length, (i) => Budget.fromMap(maps[i]));
    } catch (e) {
      print('Error in getActiveBudgetsForCategory: $e');
      return [];
    }
  }

// Method to debug transaction storage format
  Future<void> debugTransactions(String userId) async {
    final db = await database;

    print('=== Transaction Debug ===');
    final transactions = await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 5,
    );

    print('Found ${transactions.length} transactions (showing first 5):');
    for (var transaction in transactions) {
      print('Transaction: ${transaction.toString()}');
    }
    print('=== End Transaction Debug ===');
  }

// Method to debug budget storage format
  Future<void> debugBudgets(String userId) async {
    final db = await database;

    print('=== Budget Debug ===');
    final budgets = await db.query(
      'budgets',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    print('Found ${budgets.length} budgets:');
    for (var budget in budgets) {
      print('Budget: ${budget.toString()}');
    }
    print('=== End Budget Debug ===');
  }

// Get overall budget status for all categories
  Future<List<Map<String, dynamic>>> getAllBudgetStatus(String userId) async {
    final db = await database;
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);

    // Get all categories with active budgets
    final List<Map<String, dynamic>> categoryMaps = await db.rawQuery('''
    SELECT DISTINCT category FROM budgets
    WHERE user_id = ? AND is_active = 1
  ''', [userId]);

    final List<Map<String, dynamic>> results = [];

    // For each category, get the budget status
    for (var categoryMap in categoryMaps) {
      final String category = categoryMap['category'];
      if (category == 'all') continue; // Skip overall budget in this list

      final status = await getBudgetRemaining(userId, category,
          startDate: start, endDate: end);
      results.add({
        'category': category,
        'budget': status['budget'],
        'spent': status['spent'],
        'remaining': status['remaining'],
        'percentage': status['percentage'],
      });
    }

    return results;
  }

// Check if user is over budget in any category

  Future<List<String>> getDistinctCategories(String userId) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT DISTINCT category FROM transactions WHERE user_id = ?',
        [userId],
      );
      return result.map((row) => row['category'] as String).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }


  // Insert transaction with proper user_id
  Future<int> insertTransaction(Map<String, dynamic> transaction) async {
    try {
      final db = await database;
      
      // Ensure transaction has a unique ID and user_id
      if (!transaction.containsKey('id') || transaction['id'] == null || transaction['id'].isEmpty) {
        transaction['id'] = Uuid().v4();
      }
      
      // Validate that user_id is provided
      if (!transaction.containsKey('user_id') || transaction['user_id'] == null || transaction['user_id'].isEmpty) {
        print("Error: Transaction must have a user_id");
        return -1;
      }

      print("Inserting transaction for user: ${transaction['user_id']}");
      return await db.insert('transactions', transaction);
    } catch (e) {
      print("Error inserting transaction: $e");
      return -1;
    }
  }

  /// Get transactions for a specific user ONLY
  Future<List<Map<String, dynamic>>> getTransactionsForUser(String userId) async {
    try {
      final db = await database;
      print("🔍 Getting transactions for user: $userId");
      
      final List<Map<String, dynamic>> transactions = await db.query(
        'transactions',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'date DESC',
      );

      print("✅ Found ${transactions.length} transactions for user $userId");
      return transactions;
    } catch (e) {
      print("❌ Error getting transactions for user: $e");
      return [];
    }
  }

  /// Get transactions by category for a specific user
  Future<List<Map<String, dynamic>>> getTransactionsByCategory(String userId, String category) async {
    try {
      final db = await database;
      print("🔍 Getting $category transactions for user: $userId");
      
      final List<Map<String, dynamic>> transactions = await db.query(
        'transactions',
        where: 'user_id = ? AND category = ?',
        whereArgs: [userId, category],
        orderBy: 'date DESC',
      );

      print("✅ Found ${transactions.length} $category transactions for user $userId");
      return transactions;
    } catch (e) {
      print("❌ Error getting transactions by category: $e");
      return [];
    }
  }

  /// Get transactions by type (income/expense) for a specific user
  Future<List<Map<String, dynamic>>> getTransactionsByType(String userId, String type) async {
    try {
      final db = await database;
      print("🔍 Getting $type transactions for user: $userId");
      
      final List<Map<String, dynamic>> transactions = await db.query(
        'transactions',
        where: 'user_id = ? AND type = ?',
        whereArgs: [userId, type],
        orderBy: 'date DESC',
      );

      print("✅ Found ${transactions.length} $type transactions for user $userId");
      return transactions;
    } catch (e) {
      print("❌ Error getting transactions by type: $e");
      return [];
    }
  }

  /// Get recent transactions for a specific user
  Future<List<Map<String, dynamic>>> getRecentTransactions(String userId, {int limit = 10}) async {
    try {
      final db = await database;
      print("🔍 Getting recent $limit transactions for user: $userId");
      
      final List<Map<String, dynamic>> transactions = await db.query(
        'transactions',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'date DESC',
        limit: limit,
      );

      print("✅ Found ${transactions.length} recent transactions for user $userId");
      return transactions;
    } catch (e) {
      print("❌ Error getting recent transactions: $e");
      return [];
    }
  }

  /// Get transactions within date range for a specific user
  Future<List<Map<String, dynamic>>> getTransactionsInDateRange(
    String userId, 
    DateTime startDate, 
    DateTime endDate
  ) async {
    try {
      final db = await database;
      print("🔍 Getting transactions for user $userId between ${startDate.toIso8601String()} and ${endDate.toIso8601String()}");
      
      final List<Map<String, dynamic>> transactions = await db.query(
        'transactions',
        where: 'user_id = ? AND date >= ? AND date <= ?',
        whereArgs: [userId, startDate.toIso8601String(), endDate.toIso8601String()],
        orderBy: 'date DESC',
      );

      print("✅ Found ${transactions.length} transactions in date range for user $userId");
      return transactions;
    } catch (e) {
      print("❌ Error getting transactions in date range: $e");
      return [];
    }
  }

  /// Update transaction (ensure user owns it)
  Future<int> updateTransaction(String userId, Map<String, dynamic> transaction) async {
    try {
      final db = await database;
      
      // Verify the transaction belongs to the user
      final existing = await db.query(
        'transactions',
        where: 'id = ? AND user_id = ?',
        whereArgs: [transaction['id'], userId],
      );

      if (existing.isEmpty) {
        print("❌ Transaction not found or doesn't belong to user");
        return 0;
      }

      print("✅ Updating transaction ${transaction['id']} for user: $userId");
      return await db.update(
        'transactions',
        transaction,
        where: 'id = ? AND user_id = ?',
        whereArgs: [transaction['id'], userId],
      );
    } catch (e) {
      print("❌ Error updating transaction: $e");
      return 0;
    }
  }

  /// Delete transaction (ensure user owns it)
  Future<int> deleteTransaction(String userId, String transactionId) async {
    try {
      final db = await database;
      
      print("✅ Deleting transaction $transactionId for user: $userId");
      return await db.delete(
        'transactions',
        where: 'id = ? AND user_id = ?',
        whereArgs: [transactionId, userId],
      );
    } catch (e) {
      print("❌ Error deleting transaction: $e");
      return 0;
    }
  }

  /// Get user's total balance
  Future<double> getUserBalance(String userId) async {
    try {
      final db = await database;
      
      // Get total income
      final incomeResult = await db.rawQuery('''
        SELECT SUM(amount) as total 
        FROM transactions 
        WHERE user_id = ? AND type = 'income'
      ''', [userId]);
      
      // Get total expenses
      final expenseResult = await db.rawQuery('''
        SELECT SUM(amount) as total 
        FROM transactions 
        WHERE user_id = ? AND type = 'expense'
      ''', [userId]);

      final double totalIncome = (incomeResult.first['total'] as double?) ?? 0.0;
      final double totalExpense = (expenseResult.first['total'] as double?) ?? 0.0;
      final double balance = totalIncome - totalExpense;

      print("✅ User $userId balance: Income: $totalIncome, Expenses: $totalExpense, Balance: $balance");
      return balance;
    } catch (e) {
      print("❌ Error getting user balance: $e");
      return 0.0;
    }
  }

  /// Get user's monthly summary
  Future<Map<String, double>> getUserMonthlySummary(String userId, {DateTime? month}) async {
    try {
      final db = await database;
      final targetMonth = month ?? DateTime.now();
      final startDate = DateTime(targetMonth.year, targetMonth.month, 1);
      final endDate = DateTime(targetMonth.year, targetMonth.month + 1, 0);

      print("🔍 Getting monthly summary for user $userId for ${targetMonth.year}-${targetMonth.month}");

      // Get monthly income
      final incomeResult = await db.rawQuery('''
        SELECT SUM(amount) as total 
        FROM transactions 
        WHERE user_id = ? AND type = 'income' AND date >= ? AND date <= ?
      ''', [userId, startDate.toIso8601String(), endDate.toIso8601String()]);

      // Get monthly expenses
      final expenseResult = await db.rawQuery('''
        SELECT SUM(amount) as total 
        FROM transactions 
        WHERE user_id = ? AND type = 'expense' AND date >= ? AND date <= ?
      ''', [userId, startDate.toIso8601String(), endDate.toIso8601String()]);

      final double income = (incomeResult.first['total'] as double?) ?? 0.0;
      final double expenses = (expenseResult.first['total'] as double?) ?? 0.0;
      final double balance = income - expenses;

      print("✅ Monthly summary for user $userId: Income: $income, Expenses: $expenses, Balance: $balance");

      return {
        'income': income,
        'expenses': expenses,
        'balance': balance,
      };
    } catch (e) {
      print("❌ Error getting monthly summary: $e");
      return {
        'income': 0.0,
        'expenses': 0.0,
        'balance': 0.0,
      };
    }
  }

  /// Debug method to check user data isolation
  Future<void> debugUserData(String userId) async {
    try {
      final db = await database;
      
      print("=== USER DATA DEBUG FOR: $userId ===");
      
      // Check user exists
      final user = await getUserByEmail(""); // We'll need email to check
      print("User exists: ${user != null}");
      
      // Check transactions
      final transactions = await db.query(
        'transactions',
        where: 'user_id = ?',
        whereArgs: [userId],
      );
      print("User's transactions: ${transactions.length}");
      
      // Check budgets
      final budgets = await db.query(
        'budgets',
        where: 'user_id = ?',
        whereArgs: [userId],
      );
      print("User's budgets: ${budgets.length}");
      
      // Check saving goals
      final goals = await db.query(
        'saving_goals',
        // Note: saving_goals might not have user_id field - check your schema
      );
      print("Total saving goals: ${goals.length}");
      
      print("=== END USER DATA DEBUG ===");
    } catch (e) {
      print("❌ Error in debug: $e");
    }
  }

  /// Get user by ID (not email)
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> users = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (users.isNotEmpty) {
        print("✅ Found user by ID: $userId");
        return users.first;
      } else {
        print("❌ User not found by ID: $userId");
        return null;
      }
    } catch (e) {
      print("❌ Error fetching user by ID: $e");
      return null;
    }
  }
}
