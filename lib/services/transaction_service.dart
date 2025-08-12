import 'package:cungacash/services/db_helper.dart';
import 'package:cungacash/services/auth_service.dart';
import 'package:cungacash/models/transaction.dart' as model;

class TransactionService {
  final DBHelper _dbHelper = DBHelper();
  final AuthService _authService = AuthService();

  // Add a new transaction for the current user
  Future<bool> addTransaction({
    required String type, // 'income' or 'expense'
    required String category,
    required double amount,
    required DateTime date,
    String? description,
    String? savingGoalId,
  }) async {
    try {
      // Get current user ID
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        print(" No authenticated user found");
        return false;
      }

      final transactionData = {
        'user_id': userId,  
        'type': type,
        'category': category,
        'amount': amount,
        'date': date.toIso8601String(),
        'description': description ?? '',
        'saving_goal_id': savingGoalId,
      };

      print(" Adding transaction for user: $userId");
      print("   Type: $type, Category: $category, Amount: $amount");

      final result = await _dbHelper.insertTransaction(transactionData);
      return result > 0;
    } catch (e) {
      print(" Error adding transaction: $e");
      return false;
    }
  }

  // Get all transactions for the current user
  Future<List<model.Transaction>> getCurrentUserTransactions() async {
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        print(" No authenticated user found");
        return [];
      }

      print(" Getting transactions for current user: $userId");
      final transactionMaps = await _dbHelper.getTransactionsForUser(userId);
      
      return transactionMaps.map((map) => model.Transaction.fromMap(map)).toList();
    } catch (e) {
      print("Error getting current user transactions: $e");
      return [];
    }
  }

  // Get recent transactions for the current user
  Future<List<model.Transaction>> getRecentTransactions({int limit = 10}) async {
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        print("No authenticated user found");
        return [];
      }

      print(" Getting recent $limit transactions for user: $userId");
      final transactionMaps = await _dbHelper.getRecentTransactions(userId, limit: limit);
      
      return transactionMaps.map((map) => model.Transaction.fromMap(map)).toList();
    } catch (e) {
      print(" Error getting recent transactions: $e");
      return [];
    }
  }

  // Get transactions by category for current user
  Future<List<model.Transaction>> getTransactionsByCategory(String category) async {
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        print(" No authenticated user found");
        return [];
      }

      print(" Getting $category transactions for user: $userId");
      final transactionMaps = await _dbHelper.getTransactionsByCategory(userId, category);
      
      return transactionMaps.map((map) => model.Transaction.fromMap(map)).toList();
    } catch (e) {
      print(" Error getting transactions by category: $e");
      return [];
    }
  }

  // Get transactions by type (income/expense) for current user
  Future<List<model.Transaction>> getTransactionsByType(String type) async {
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        print("No authenticated user found");
        return [];
      }

      print(" Getting $type transactions for user: $userId");
      final transactionMaps = await _dbHelper.getTransactionsByType(userId, type);
      
      return transactionMaps.map((map) => model.Transaction.fromMap(map)).toList();
    } catch (e) {
      print("Error getting transactions by type: $e");
      return [];
    }
  }

  // Get current user's balance
  Future<double> getCurrentUserBalance() async {
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        print("No authenticated user found");
        return 0.0;
      }

      print("Getting balance for user: $userId");
      return await _dbHelper.getUserBalance(userId);
    } catch (e) {
      print("Error getting user balance: $e");
      return 0.0;
    }
  }

  // Get current user's monthly summary
  Future<Map<String, double>> getCurrentUserMonthlySummary({DateTime? month}) async {
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        print("No authenticated user found");
        return {'income': 0.0, 'expenses': 0.0, 'balance': 0.0};
      }

      print("🔍 Getting monthly summary for user: $userId");
      return await _dbHelper.getUserMonthlySummary(userId, month: month);
    } catch (e) {
      print("Error getting monthly summary: $e");
      return {'income': 0.0, 'expenses': 0.0, 'balance': 0.0};
    }
  }

  // Update transaction for current user
  Future<bool> updateTransaction(model.Transaction transaction) async {
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        print(" No authenticated user found");
        return false;
      }

      print(" Updating transaction for user: $userId");
      final result = await _dbHelper.updateTransaction(userId, transaction.toMap());
      return result > 0;
    } catch (e) {
      print(" Error updating transaction: $e");
      return false;
    }
  }

  // Delete transaction for current user
  Future<bool> deleteTransaction(String transactionId) async {
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        print(" No authenticated user found");
        return false;
      }

      print(" Deleting transaction for user: $userId");
      final result = await _dbHelper.deleteTransaction(userId, transactionId);
      return result > 0;
    } catch (e) {
      print(" Error deleting transaction: $e");
      return false;
    }
  }

  // Debug method to check user data isolation
  Future<void> debugCurrentUserData() async {
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        print(" No authenticated user found for debug");
        return;
      }

      await _dbHelper.debugUserData(userId);
    } catch (e) {
      print(" Error in debug: $e");
    }
  }
}