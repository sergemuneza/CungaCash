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

  /// Initialize the database
  // Future<Database> initDB() async {
  //   final path = join(await getDatabasesPath(), 'expense_tracker.db');

  //   return await openDatabase(
  //     path,
  //     version: 1,
  //     onCreate: (db, version) async {
  //       await db.execute('''
  //         CREATE TABLE users (
  //           id TEXT PRIMARY KEY,
  //           email TEXT UNIQUE,
  //           password TEXT,
  //           first_name TEXT,
  //           last_name TEXT,
  //           created_on TEXT
  //         )
  //       ''');

  //       await db.execute('''
  //         CREATE TABLE transactions (
  //           id TEXT PRIMARY KEY,
  //           user_id TEXT,
  //           type TEXT CHECK(type IN ('income', 'expense')),
  //           category TEXT,
  //           amount REAL NOT NULL CHECK(amount > 0),
  //           date TEXT NOT NULL,
  //           description TEXT,
  //           FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
  //         )
  //       ''');
  //             // ✅ Add this line to ensure your saving_goals table is created
  //     await createGoalTable(db);
  //     },
  //   );
  // }
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

      // ✅ Ensure saving_goals table is created
      await createGoalTable(db);
    },
    onUpgrade: (db, oldVersion, newVersion) async {
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
}

