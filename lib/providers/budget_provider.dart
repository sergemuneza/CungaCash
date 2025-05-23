// // import 'package:flutter/material.dart';
// // import '../services/db_helper.dart';
// // import '../models/budget.dart';

// // class BudgetProvider with ChangeNotifier {
// //   final List<Budget> _budgets = [];
// //   final DBHelper _dbHelper = DBHelper();

// //   List<Budget> get budgets => List.unmodifiable(_budgets);

// //   /// Fetch budgets from database
// //   Future<void> fetchBudgets() async {
// //     try {
// //       final db = await _dbHelper.database;
// //       final budgetList = await db.query('budgets');
// //       _budgets.clear();
// //       _budgets.addAll(budgetList.map((b) => Budget.fromMap(b)));
// //       notifyListeners();
// //     } catch (e) {
// //       print("❌ Error fetching budgets: $e");
// //     }
// //   }

// //   /// Add a new budget
// //   Future<void> addBudget(Budget budget) async {
// //     try {
// //       final db = await _dbHelper.database;
// //       await db.insert('budgets', budget.toMap());
// //       _budgets.add(budget);
// //       notifyListeners();
// //     } catch (e) {
// //       print("❌ Error adding budget: $e");
// //     }
// //   }

// //   /// Update a budget
// //   Future<void> updateBudget(Budget updatedBudget) async {
// //     try {
// //       final db = await _dbHelper.database;
// //       await db.update(
// //         'budgets',
// //         updatedBudget.toMap(),
// //         where: 'id = ?',
// //         whereArgs: [updatedBudget.id],
// //       );

// //       final index = _budgets.indexWhere((b) => b.id == updatedBudget.id);
// //       if (index != -1) {
// //         _budgets[index] = updatedBudget;
// //         notifyListeners();
// //       }
// //     } catch (e) {
// //       print("❌ Error updating budget: $e");
// //     }
// //   }

// //   /// Delete a budget
// //   Future<void> deleteBudget(int id) async {
// //     try {
// //       final db = await _dbHelper.database;
// //       await db.delete('budgets', where: 'id = ?', whereArgs: [id]);
// //       _budgets.removeWhere((b) => b.id == id);
// //       notifyListeners();
// //     } catch (e) {
// //       print("❌ Error deleting budget: $e");
// //     }
// //   }
// // }

// import 'package:flutter/material.dart';
// import '../services/db_helper.dart';
// import '../models/budget.dart';

// class BudgetProvider with ChangeNotifier {
//   final List<Budget> _budgets = [];
//   final DBHelper _dbHelper = DBHelper();

//   List<Budget> get budgets => List.unmodifiable(_budgets);

//   /// Fetch budgets from database
//   Future<void> fetchBudgets() async {
//     try {
//       final db = await _dbHelper.database;
//       final budgetList = await db.query('budgets');
//       _budgets.clear();
//       _budgets.addAll(budgetList.map((b) => Budget.fromMap(b)));
//       notifyListeners();
//     } catch (e) {
//       print("❌ Error fetching budgets: $e");
//     }
//   }

//   /// Add a new budget
//   Future<void> addBudget(Budget budget) async {
//     try {
//       final db = await _dbHelper.database;
//       await db.insert('budgets', budget.toMap());
//       _budgets.add(budget);
//       notifyListeners();
//     } catch (e) {
//       print("❌ Error adding budget: $e");
//     }
//   }

//   /// Update a budget
//   Future<void> updateBudget(Budget updatedBudget) async {
//     try {
//       final db = await _dbHelper.database;
//       await db.update(
//         'budgets',
//         updatedBudget.toMap(),
//         where: 'id = ?',
//         whereArgs: [updatedBudget.id],
//       );

//       final index = _budgets.indexWhere((b) => b.id == updatedBudget.id);
//       if (index != -1) {
//         _budgets[index] = updatedBudget;
//         notifyListeners();
//       }
//     } catch (e) {
//       print("❌ Error updating budget: $e");
//     }
//   }

//   /// Delete a budget
//   Future<void> deleteBudget(int id) async {
//     try {
//       final db = await _dbHelper.database;
//       await db.delete('budgets', where: 'id = ?', whereArgs: [id]);
//       _budgets.removeWhere((b) => b.id == id);
//       notifyListeners();
//     } catch (e) {
//       print("❌ Error deleting budget: $e");
//     }
//   }

//   /// Update remaining budget for a specific budget entry
//   Future<void> updateRemainingBudget(int budgetId, double remainingAmount) async {
//     try {
//       final db = await _dbHelper.database;
//       await db.update(
//         'budgets',
//         {'remaining': remainingAmount},
//         where: 'id = ?',
//         whereArgs: [budgetId],
//       );

//       final index = _budgets.indexWhere((b) => b.id == budgetId);
//       if (index != -1) {
//         _budgets[index].remaining = remainingAmount;
//         notifyListeners();
//       }
//     } catch (e) {
//       print("❌ Error updating remaining budget: $e");
//     }
//   }
// }
import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import '../models/budget.dart';

class BudgetProvider with ChangeNotifier {
  final List<Budget> _budgets = [];
  final DBHelper _dbHelper = DBHelper();

  List<Budget> get budgets => List.unmodifiable(_budgets);

  /// Fetch budgets from database
  Future<void> fetchBudgets() async {
    try {
      final db = await _dbHelper.database;
      final budgetList = await db.query('budgets');
      _budgets.clear();
      _budgets.addAll(budgetList.map((b) => Budget.fromMap(b)));
      notifyListeners();
    } catch (e) {
      print("❌ Error fetching budgets: $e");
    }
  }

  /// Add a new budget
  Future<void> addBudget(Budget budget) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('budgets', budget.toMap());
      _budgets.add(budget);
      notifyListeners();
    } catch (e) {
      print("❌ Error adding budget: $e");
    }
  }

  /// Update a budget
  Future<void> updateBudget(Budget updatedBudget) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'budgets',
        updatedBudget.toMap(),
        where: 'id = ?',
        whereArgs: [updatedBudget.id],
      );

      final index = _budgets.indexWhere((b) => b.id == updatedBudget.id);
      if (index != -1) {
        _budgets[index] = updatedBudget;
        notifyListeners();
      }
    } catch (e) {
      print("❌ Error updating budget: $e");
    }
  }

  /// Delete a budget
  Future<void> deleteBudget(String id) async { // ✅ Changed from int to String
    try {
      final db = await _dbHelper.database;
      await db.delete('budgets', where: 'id = ?', whereArgs: [id]);
      _budgets.removeWhere((b) => b.id == id);
      notifyListeners();
    } catch (e) {
      print("❌ Error deleting budget: $e");
    }
  }

  /// Update remaining budget for a specific budget entry
  Future<void> updateRemainingBudget(String budgetId, double remainingAmount) async { // ✅ Changed from int to String
    try {
      final db = await _dbHelper.database;
      await db.update(
        'budgets',
        {'remaining': remainingAmount},
        where: 'id = ?',
        whereArgs: [budgetId],
      );

      final index = _budgets.indexWhere((b) => b.id == budgetId);
      if (index != -1) {
        _budgets[index].remaining = remainingAmount;
        notifyListeners();
      }
    } catch (e) {
      print("❌ Error updating remaining budget: $e");
    }
  }

  /// Get budget by ID
  Budget? getBudgetById(String id) {
    try {
      return _budgets.firstWhere((budget) => budget.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get budgets by category
  List<Budget> getBudgetsByCategory(String category) {
    return _budgets.where((budget) => budget.category == category && budget.isActive).toList();
  }

  /// Get active budgets only
  List<Budget> get activeBudgets {
    return _budgets.where((budget) => budget.isActive).toList();
  }

  /// Check if a budget exists for a category
  bool hasBudgetForCategory(String category) {
    return _budgets.any((budget) => 
      (budget.category == category || budget.category == 'all') && 
      budget.isActive
    );
  }

  /// Get total budget amount across all active budgets
  double get totalBudgetAmount {
    return activeBudgets.fold(0.0, (sum, budget) => sum + budget.amount);
  }

  /// Get total remaining amount across all active budgets
  double get totalRemainingAmount {
    return activeBudgets.fold(0.0, (sum, budget) => sum + budget.remaining);
  }
  
}