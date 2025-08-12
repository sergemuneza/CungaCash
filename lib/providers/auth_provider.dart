//Auth Provider
import 'package:flutter/material.dart';
import '../models/user.dart'; // Adjust the path if needed
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Login user
  Future<bool> login(String email, String password) async {
    try {
      _errorMessage = null;
      final authService = AuthService();
      final success = await authService.loginUser(email, password);

      if (success) {
        final userMap = await authService.getUserDetails(email);
        if (userMap != null) {
          _currentUser = User.fromMap(userMap);
          _isAuthenticated = true;
          print("AuthProvider: Login successful for ${_currentUser?.email}");
          notifyListeners();
          return true;
        } else {
          _errorMessage = "Failed to retrieve user details";
          print(" AuthProvider: Failed to get user details");
        }
      } else {
        _errorMessage = "Invalid email or password";
        print(" AuthProvider: Login failed - invalid credentials");
      }

      _isAuthenticated = false;
      _currentUser = null;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = "Login error: $e";
      print(" AuthProvider: Login error - $e");
      _isAuthenticated = false;
      _currentUser = null;
      notifyListeners();
      return false;
    }
  }

  /// Register user
  Future<bool> register(String firstName, String lastName, String email, String password) async {
    try {
      _errorMessage = null;
      final authService = AuthService();
      final success = await authService.registerUser(firstName, lastName, email, password);

      if (success) {
        print(" AuthProvider: Registration successful for $email");
        // Automatically log in after registration
        return await login(email, password);
      } else {
        _errorMessage = "Registration failed - user may already exist";
        print(" AuthProvider: Registration failed for $email");
      }

      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = "Registration error: $e";
      print(" AuthProvider: Registration error - $e");
      notifyListeners();
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await AuthService().logoutUser();
      _currentUser = null;
      _isAuthenticated = false;
      _errorMessage = null;
      print(" AuthProvider: Logout successful");
      notifyListeners();
    } catch (e) {
      print(" AuthProvider: Logout error - $e");
    }
  }

  /// Check login status on app launch
  Future<void> checkAuthStatus() async {
    try {
      print(" AuthProvider: Checking authentication status...");
      final authService = AuthService();
      final credentials = await authService.getUserCredentials();

      final email = credentials['email'];
      if (email != null && email.isNotEmpty) {
        print("🔍 AuthProvider: Found saved email: $email");
        final userMap = await authService.getUserDetails(email);
        if (userMap != null) {
          _currentUser = User.fromMap(userMap);
          _isAuthenticated = true;
          print(" AuthProvider: Auto-login successful for $email");
          notifyListeners();
          return;
        } else {
          print(" AuthProvider: User details not found for saved email");
        }
      } else {
        print(" AuthProvider: No saved email found");
      }

      _currentUser = null;
      _isAuthenticated = false;
      print(" AuthProvider: No valid authentication found");
      notifyListeners();
    } catch (e) {
      print(" AuthProvider: Error checking auth status - $e");
      _currentUser = null;
      _isAuthenticated = false;
      notifyListeners();
    }
  }
}