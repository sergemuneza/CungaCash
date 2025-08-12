
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cungacash/services/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart'; 

class AuthService {
  final DBHelper _dbHelper = DBHelper();
  final Uuid _uuid = Uuid();

  // Hash password before storing
  String _hashPassword(String password) {
    final hash = sha256.convert(utf8.encode(password)).toString();
    print("Hashing password: $password -> $hash");
    return hash;
  }

  // Register user (Handles both Web and Mobile)
  Future<bool> registerUser(String firstName, String lastName, String email, String password) async {
    final hashedPassword = _hashPassword(password);
    final userId = _uuid.v4();

    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();

        if (prefs.containsKey('user_$email')) {
          print("⚠️ User already exists in Web Storage");
          return false;
        }

        final userData = {
          'id': userId,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': hashedPassword,
          'created_on': DateTime.now().toIso8601String(),
        };

        await prefs.setString('user_$email', jsonEncode(userData));
        print(" Web user registered successfully");
        return true;

      } else {
        final existingUser = await _dbHelper.getUserByEmail(email);
        if (existingUser != null) {
          print(" User already exists in SQLite");
          return false;
        }

        final result = await _dbHelper.insertUser({
          'id': userId,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': hashedPassword,
          'created_on': DateTime.now().toIso8601String(),
        });

        print(" Mobile user registered successfully");
        return result > 0;
      }
    } catch (e) {
      print(" Error registering user: $e");
      return false;
    }
  }

  // Login user (Handles both Web and Mobile)
  Future<bool> loginUser(String email, String password) async {
    final hashedPassword = _hashPassword(password);

    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        String? userDataJson = prefs.getString('user_$email');

        if (userDataJson != null) {
          final userData = jsonDecode(userDataJson) as Map<String, dynamic>;
          if (userData['password'] == hashedPassword) {
            print(" Web Login Successful!");
            await saveUserCredentials(email, userData['id']);
            return true;
          }
        }
        print(" Web: Invalid email or password");
        return false;

      } else {
        final user = await _dbHelper.getUserByEmail(email);
        print("🔍 Checking credentials for: $email");
        print("🔍 User found: $user");

        if (user != null && user['password'] == hashedPassword) {
          await saveUserCredentials(email, user['id']);
          print("✅ Mobile Login Successful!");
          return true;
        }
        print("❌ Mobile: Invalid email or password");
        return false;
      }
    } catch (e) {
      print("❌ Error during login: $e");
      return false;
    }
  }

  /// Save user credentials (email + userId)
  Future<void> saveUserCredentials(String email, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('userId', userId);
      print("✅ User credentials saved (email & userId)");
    } catch (e) {
      print("❌ Error saving user credentials: $e");
    }
  }

  /// Get user details by email (Works for both Web and Mobile)
  Future<Map<String, dynamic>?> getUserDetails(String email) async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        String? userDataJson = prefs.getString('user_$email');

        if (userDataJson != null) {
          final userData = jsonDecode(userDataJson) as Map<String, dynamic>;
          print("✅ Web user details retrieved for: $email");
          print("✅ User ID: ${userData['id']}");
          return userData;
        } else {
          print("❌ Web user not found for email: $email");
          return null;
        }
      } else {
        final userData = await _dbHelper.getUserByEmail(email);
        if (userData != null) {
          print("✅ Mobile user details retrieved for: $email");
          print("✅ User ID: ${userData['id']}");
        } else {
          print("❌ Mobile user not found for email: $email");
        }
        return userData;
      }
    } catch (e) {
      print("❌ Error getting user details: $e");
      return null;
    }
  }

  /// Get current user ID from SharedPreferences
  Future<String?> getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      print("🔍 Retrieved UserId: $userId");
      return userId;
    } catch (e) {
      print("❌ Error getting current user ID: $e");
      return null;
    }
  }

  /// Logout user
  Future<void> logoutUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      await prefs.remove('userId');
      print("✅ User logged out successfully and cleared credentials");
    } catch (e) {
      print("❌ Error logging out user: $e");
    }
  }

  /// Get saved user credentials (for auto-login)
  Future<Map<String, String>> getUserCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? "";
      final userId = prefs.getString('userId') ?? "";
      print("🔍 Retrieved credentials - Email: $email, UserId: $userId");
      return {'email': email, 'userId': userId};
    } catch (e) {
      print("❌ Error getting user credentials: $e");
      return {'email': "", 'userId': ""};
    }
  }

  /// Check if user exists (useful for debugging)
  Future<bool> userExists(String email) async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        return prefs.containsKey('user_$email');
      } else {
        final user = await _dbHelper.getUserByEmail(email);
        return user != null;
      }
    } catch (e) {
      print("❌ Error checking if user exists: $e");
      return false;
    }
  }
}
