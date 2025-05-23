import 'package:expense_tracker_pro/models/budget.dart';
import 'package:expense_tracker_pro/models/transaction.dart' as model;
import 'package:expense_tracker_pro/models/saving_goal.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class DBHelper {
  static Database? _database;

  /// Initialize and get the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  /// Insert a new user with a unique ID
  Future<int> insertUser(Map<String, dynamic> user) async {
    try {
      final db = await database; // ✅ Ensure database instance is retrieved

      // Ensure user_id is unique if not provided
      if (!user.containsKey('id') || user['id'] == null || user['id'].isEmpty) {
        user['id'] = Uuid().v4();
      }

      return await db.insert('users', user);
    } catch (e) {
      print("❌ Error inserting user: $e");
      return -1;
    }
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'expense_tracker.db');

    return await openDatabase(
      path,
      version: 2, // ✅ Increment version to trigger onUpgrade
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

        //------------------------------------------------------------

// Add this to your DbHelper class's _createDb method to create the budgets table
        await db.execute('''
  CREATE TABLE budgets(
    id TEXT PRIMARY KEY,
    user_id TEXT,
    name TEXT,
    category TEXT,
    amount REAL,
    remaining REAL,  -- ✅ Add this line
    start_date TEXT,
    end_date TEXT,
    period TEXT,
    is_active INTEGER,
    FOREIGN KEY (user_id) REFERENCES users (id)
  )
''');

        //------------------------------------------------------------

        // ✅ Ensure saving_goals table is created
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
        remaining REAL,  -- ✅ Add this line
        start_date TEXT,
        end_date TEXT,
        period TEXT,
        is_active INTEGER,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
        }
        // ✅ Handle migration for existing databases
        if (oldVersion == 1 && newVersion == 2) {
          // Add the saving_goal_id column to existing transactions table
          await db.execute('''
          ALTER TABLE transactions 
          ADD COLUMN saving_goal_id TEXT 
          REFERENCES saving_goals(id) ON DELETE SET NULL
        ''');
        }
      },
    );
  }

  /// Get user by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> users = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      print("🔍 Querying DB for email: $email");
      print("🔍 Database returned: $users");

      if (users.isNotEmpty) return users.first;
      return null;
    } catch (e) {
      print("❌ Error fetching user by email: $e");
      return null;
    }
  }

  // In db_helper.dart:

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

//---------------------------
// Add these methods to your DBHelper class

  Future<int> updateSavingGoal(SavingGoal goal) async {
    final db = await database;
    return await db.update(
      'saving_goals',
      goal.toMap(),
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

// ✅ Get transactions linked to a specific saving goal
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

// ✅ Calculate total contributed to a goal
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

// // Get active budgets for a specific category
//   Future<List<Budget>> getActiveBudgetsForCategory(
//       String userId, String category) async {
//     final db = await database;
//     final now = DateTime.now().toIso8601String();

//     final List<Map<String, dynamic>> maps = await db.query(
//       'budgets',
//       where:
//           'user_id = ? AND (category = ? OR category = "all") AND is_active = 1 AND start_date <= ? AND end_date >= ?',
//       whereArgs: [userId, category, now, now],
//     );

//     return List.generate(maps.length, (i) {
//       return Budget.fromMap(maps[i]);
//     });
//   }
//....................
// Replace your existing getActiveBudgetsForCategory method with this:


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

// // Calculate budget remaining for a category
//   Future<Map<String, double>> getBudgetRemaining(String userId, String category,
//       {DateTime? startDate, DateTime? endDate}) async {
//     final db = await database;
//     final now = DateTime.now();
//     final start = startDate ?? DateTime(now.year, now.month, 1);
//     final end = endDate ?? DateTime(now.year, now.month + 1, 0);

//     // Get the budget for this category
//     final budgets = await getActiveBudgetsForCategory(userId, category);
//     if (budgets.isEmpty) {
//       return {
//         'budget': 0.0,
//         'spent': 0.0,
//         'remaining': 0.0,
//         'percentage': 0.0,
//       };
//     }

//     // Sum budgets if multiple apply (could be overall + category specific)
//     double totalBudget = 0.0;
//     for (var budget in budgets) {
//       totalBudget += budget.amount;
//     }

//     // Calculate spending for this period and category
//     final List<Map<String, dynamic>> spendingMaps = await db.rawQuery('''
//     SELECT SUM(amount) as total 
//     FROM transactions 
//     WHERE user_id = ? 
//     AND type = 'expense' 
//     AND category = ? 
//     AND date BETWEEN ? AND ?
//   ''', [userId, category, start.toIso8601String(), end.toIso8601String()]);

//     final double spent = spendingMaps.first['total'] != null
//         ? (spendingMaps.first['total'] as num).toDouble()
//         : 0.0;
//     final double remaining = totalBudget - spent;
//     final double percentage =
//         totalBudget > 0 ? (spent / totalBudget) * 100 : 0.0;

//     return {
//       'budget': totalBudget,
//       'spent': spent,
//       'remaining': remaining,
//       'percentage': percentage,
//     };
//   }
// Replace your existing getBudgetRemaining method with this updated version:

// Replace your existing getBudgetRemaining method with this corrected version:

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
    
    print('Effective Date Range: ${effectiveStartDate.toIso8601String()} to ${effectiveEndDate.toIso8601String()}');

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
      print('Transaction: ${transaction['category']} - ${transaction['description']} - $amount');
    }

    final double remaining = budgetAmount - totalSpent;
    final double percentage = budgetAmount > 0 ? (totalSpent / budgetAmount) * 100 : 0.0;

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
Future<List<Budget>> getActiveBudgetsForCategory(String userId, String category) async {
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
      print('  Budget: ${map['name']} - Amount: ${map['amount']} - Category: ${map['category']}');
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

// // Check if user is over budget in any category

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
}
