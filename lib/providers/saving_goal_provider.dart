// import 'package:flutter/material.dart';
// import 'package:collection/collection.dart'; // ✅ Added to use firstWhereOrNull
// import '../models/saving_goal.dart';

// class SavingGoalProvider with ChangeNotifier {
//   final List<SavingGoal> _goals = [];

//   List<SavingGoal> get savingGoals => List.unmodifiable(_goals);

//   void addGoal(SavingGoal goal) {
//     _goals.add(goal);
//     notifyListeners();
//   }

//   void updateGoalProgress(String goalId, double amount) {
//     final index = _goals.indexWhere((g) => g.id == goalId);
//     if (index != -1) {
//       final oldGoal = _goals[index];
//       final updatedGoal = SavingGoal(
//         id: oldGoal.id,
//         title: oldGoal.title,
//         targetAmount: oldGoal.targetAmount,
//         savedAmount: oldGoal.savedAmount + amount,
//         deadline: oldGoal.deadline,
//       );
//       _goals[index] = updatedGoal;
//       notifyListeners();
//     }
//   }

//   SavingGoal? getGoalById(String id) {
//     return _goals.firstWhereOrNull((g) => g.id == id); // ✅ Fix: no type mismatch
//   }
// }
import 'package:flutter/material.dart';
import '../models/saving_goal.dart';
import '../services/db_helper.dart';

class SavingGoalProvider extends ChangeNotifier {
  List<SavingGoal> _savingGoals = [];
  
  List<SavingGoal> get savingGoals => _savingGoals;

  Future<void> loadSavingGoals() async {
    try {
      _savingGoals = await DBHelper().getSavingGoals();
      notifyListeners();
    } catch (e) {
      print('❌ Error loading saving goals: $e');
    }
  }

  Future<void> addSavingGoal(SavingGoal goal) async {
    try {
      final id = await DBHelper().insertSavingGoal(goal);
      // Create a new goal with the generated ID
      final newGoal = SavingGoal(
        id: id,
        title: goal.title,
        targetAmount: goal.targetAmount,
        savedAmount: goal.savedAmount,
        deadline: goal.deadline,
      );
      _savingGoals.add(newGoal);
      notifyListeners();
    } catch (e) {
      print('❌ Error adding saving goal: $e');
    }
  }

  Future<void> deleteSavingGoal(int id) async {
    try {
      await DBHelper().deleteSavingGoal(id);
      _savingGoals.removeWhere((goal) => goal.id == id);
      notifyListeners();
    } catch (e) {
      print('❌ Error deleting saving goal: $e');
    }
  }

  // ✅ Update goal progress when linked transaction is added
  Future<void> updateGoalProgress(String goalId, double amount) async {
    try {
      final goalIdInt = int.parse(goalId);
      final goalIndex = _savingGoals.indexWhere((goal) => goal.id == goalIdInt);
      
      if (goalIndex != -1) {
        final currentGoal = _savingGoals[goalIndex];
        final newSavedAmount = currentGoal.savedAmount + amount;
        
        // Create updated goal
        final updatedGoal = SavingGoal(
          id: currentGoal.id,
          title: currentGoal.title,
          targetAmount: currentGoal.targetAmount,
          savedAmount: newSavedAmount,
          deadline: currentGoal.deadline,
        );
        
        // Update in database
        await DBHelper().updateSavingGoal(updatedGoal);
        
        // Update in memory
        _savingGoals[goalIndex] = updatedGoal;
        notifyListeners();
        
        print('✅ Updated goal ${currentGoal.title}: +$amount (Total: $newSavedAmount/${currentGoal.targetAmount})');
      }
    } catch (e) {
      print('❌ Error updating goal progress: $e');
    }
  }

  // ✅ Get progress percentage for a goal
  double getGoalProgress(int goalId) {
    final goal = _savingGoals.firstWhere(
      (g) => g.id == goalId,
      orElse: () => SavingGoal(
        id: null,
        title: '',
        targetAmount: 1,
        savedAmount: 0,
        deadline: DateTime.now(),
      ),
    );
    return goal.savedAmount / goal.targetAmount;
  }

  // ✅ Check if goal is completed
  bool isGoalCompleted(int goalId) {
    return getGoalProgress(goalId) >= 1.0;
  }

  // ✅ Get remaining amount for goal
  double getRemainingAmount(int goalId) {
    final goal = _savingGoals.firstWhere(
      (g) => g.id == goalId,
      orElse: () => SavingGoal(
        id: null,
        title: '',
        targetAmount: 0,
        savedAmount: 0,
        deadline: DateTime.now(),
      ),
    );
    return (goal.targetAmount - goal.savedAmount).clamp(0, double.infinity);
  }
}