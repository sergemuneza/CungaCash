// import 'package:flutter/foundation.dart';
// import '../services/auth_service.dart';

// class AuthProvider with ChangeNotifier {
//   String? _userEmail;
//   String? _firstName;
//   bool _isAuthenticated = false;

//   String? get userEmail => _userEmail;
//   String? get firstName => _firstName;
//   bool get isAuthenticated => _isAuthenticated;

//   get user => null;

//   /// Login user
//   Future<bool> login(String email, String password) async {
//     final authService = AuthService();
//     bool isSuccess = await authService.loginUser(email, password);

//     if (isSuccess) {
//       final user = await authService.getUserDetails(email);
//       if (user != null) {
//         _userEmail = email;
//         _firstName = user['first_name'];
//         _isAuthenticated = true;
//         notifyListeners();
//       }
//     }
//     return isSuccess;
//   }

//   /// Logout user
//   Future<void> logout() async {
//     await AuthService().logoutUser();
//     _userEmail = null;
//     _firstName = null;
//     _isAuthenticated = false;
//     notifyListeners();
//   }

//   /// Check if user is already logged in
// Future<void> checkAuthStatus() async {
//   final authService = AuthService();
//   final savedCredentials = await authService.getUserCredentials();

//   if (savedCredentials['email'] != null && savedCredentials['email']!.isNotEmpty) {
//     final user = await authService.getUserDetails(savedCredentials['email']!);

//     if (user != null) {
//       _userEmail = savedCredentials['email'];
//       _firstName = user['first_name'];
//       _isAuthenticated = true;
//       notifyListeners();
//       return;
//     }
//   }
//   _clearUserData(); // Reset state if user is not logged in
// }

// /// Clears user session
// void _clearUserData() {
//   _userEmail = null;
//   _firstName = null;
//   _isAuthenticated = false;
//   notifyListeners();
// }

// }

import 'package:flutter/material.dart';
import '../models/user.dart'; // Adjust the path if needed
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  /// Login user
  Future<bool> login(String email, String password) async {
    final authService = AuthService();
    final success = await authService.loginUser(email, password);

    if (success) {
      final userMap = await authService.getUserDetails(email);
      if (userMap != null) {
        _currentUser = User.fromMap(userMap);
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
    }

    return false;
  }

  /// Logout
  Future<void> logout() async {
    await AuthService().logoutUser();
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  /// Check login status on app launch
  Future<void> checkAuthStatus() async {
    final authService = AuthService();
    final credentials = await authService.getUserCredentials();

    final email = credentials['email'];
    if (email != null && email.isNotEmpty) {
      final userMap = await authService.getUserDetails(email);
      if (userMap != null) {
        _currentUser = User.fromMap(userMap);
        _isAuthenticated = true;
        notifyListeners();
        return;
      }
    }

    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
