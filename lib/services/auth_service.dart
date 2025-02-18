// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class AuthService {
//   final _storage = const FlutterSecureStorage();

//   Future<void> saveUserCredentials(String email, String password) async {
//     await _storage.write(key: 'email', value: email);
//     await _storage.write(key: 'password', value: password);
//   }

//   Future<Map<String, String?>> getUserCredentials() async {
//     return {
//       'email': await _storage.read(key: 'email'),
//       'password': await _storage.read(key: 'password'),
//     };
//   }

//   Future<void> logout() async {
//     await _storage.deleteAll();
//   }
// }

// import 'package:crypto/crypto.dart';
// import 'package:expense_tracker/services/db_helper.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/db_helper.dart';

// class AuthService {
//   final DBHelper _dbHelper = DBHelper();

//   /// Hash password before storing
//   String _hashPassword(String password) {
//     return sha256.convert(utf8.encode(password)).toString();
//   }

//   /// Register new user
//   Future<void> registerUser(
//       String firstName, String lastName, String email, String password) async {
//     final hashedPassword = _hashPassword(password);

//     await DBHelper.insertUser({
//       'first_name': firstName,
//       'last_name': lastName,
//       'email': email,
//       'password': hashedPassword, // Store hashed password
//     });
//   }

//   /// Login user
//   Future<bool> loginUser(String email, String password) async {
//     final hashedPassword = _hashPassword(password);
//     final user = await DBHelper.getUserByEmail(email);

//     if (user != null && user['password'] == hashedPassword) {
//       await saveUserCredentials(email);
//       return true;
//     }
//     return false;
//   }

//   /// Save user credentials securely
//   Future<void> saveUserCredentials(String email) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('email', email);
//   }

//   /// Get saved user email
//   Future<Map<String, String>> getUserCredentials() async {
//     final prefs = await SharedPreferences.getInstance();
//     return {
//       'email': prefs.getString('email') ?? "",
//     };
//   }

//   /// Logout user
//   Future<void> logoutUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('email');
//   }

//   /// Get user details by email
//   Future<Map<String, dynamic>?> getUserDetails(String email) async {
//     return await DBHelper.getUserByEmail(email);
//   }
// }

/*import 'package:crypto/crypto.dart';
import 'package:expense_tracker/services/db_helper.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart'; // ✅ To generate unique user IDs

class AuthService {
  final DBHelper _dbHelper = DBHelper();
  final Uuid _uuid = Uuid(); // ✅ For generating unique user IDs

  /// Hash password before storing
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  /// Register new user
  Future<bool> registerUser(
      String firstName, String lastName, String email, String password) async {
    final hashedPassword = _hashPassword(password);

    try {
      // ✅ Check if email already exists
      final existingUser = await DBHelper.getUserByEmail(email);
      if (existingUser != null) {
        print("User already exists with this email.");
        return false; // Email is already taken
      }

      // ✅ Generate unique user ID
      String userId = _uuid.v4();

      await DBHelper.insertUser({
        'id': userId, // ✅ Ensure each user has a unique ID
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': hashedPassword, // Store hashed password
        'created_on': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print("Error registering user: $e");
      return false;
    }
  }

  /// Login user
  Future<bool> loginUser(String email, String password) async {
    final hashedPassword = _hashPassword(password);

    try {
      final user = await DBHelper.getUserByEmail(email);

      if (user != null && user['password'] == hashedPassword) {
        await saveUserCredentials(email);
        return true;
      }
      return false;
    } catch (e) {
      print("Error during login: $e");
      return false;
    }
  }

  /// Save user credentials securely
  Future<void> saveUserCredentials(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
    } catch (e) {
      print("Error saving user credentials: $e");
    }
  }

  /// Get saved user email
  Future<Map<String, String>> getUserCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {'email': prefs.getString('email') ?? ""};
    } catch (e) {
      print("Error getting user credentials: $e");
      return {'email': ""};
    }
  }

  /// Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    final credentials = await getUserCredentials();
    return credentials['email']!.isNotEmpty;
  }

  /// Logout user
  Future<void> logoutUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
    } catch (e) {
      print("Error logging out user: $e");
    }
  }

  /// Get user details by email
  Future<Map<String, dynamic>?> getUserDetails(String email) async {
    try {
      return await DBHelper.getUserByEmail(email);
    } catch (e) {
      print("Error getting user details: $e");
      return null;
    }
  }
}

*/

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:expense_tracker_pro/services/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart'; // To detect Web

class AuthService {
  final DBHelper _dbHelper = DBHelper();
  final Uuid _uuid = Uuid();

  /// Hash password before storing
  String _hashPassword(String password) {
    final hash = sha256.convert(utf8.encode(password)).toString();
    print("🔐 Hashing password: $password -> $hash");
    return hash;
  }

  /// Register user (Handles both Web and Mobile)
  Future<bool> registerUser(String firstName, String lastName, String email, String password) async {
    final hashedPassword = _hashPassword(password);

    try {
      if (kIsWeb) { // Handle Web using SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey(email)) {
          print("⚠️ User already exists in Web Storage");
          return false;
        }
        prefs.setString(email, hashedPassword);
        return true;
      } else {
        // Mobile (SQLite)
        final existingUser = await _dbHelper.getUserByEmail(email);
        if (existingUser != null) return false;
        return (await _dbHelper.insertUser({
          'id': _uuid.v4(),
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': hashedPassword,
          'created_on': DateTime.now().toIso8601String(),
        })) > 0;
      }
    } catch (e) {
      print("❌ Error registering user: $e");
      return false;
    }
  }

  /// Login user (Handles both Web and Mobile)
  Future<bool> loginUser(String email, String password) async {
    final hashedPassword = _hashPassword(password);

    try {
      if (kIsWeb) {  // Web-based authentication
        final prefs = await SharedPreferences.getInstance();
        String? storedPassword = prefs.getString(email);

        if (storedPassword != null && storedPassword == hashedPassword) {
          print("✅ Web Login Successful!");
          await saveUserCredentials(email);
          return true;
        }
        print("❌ Web: Invalid email or password");
        return false;
      } else {
        // Mobile authentication (SQLite)
        final user = await _dbHelper.getUserByEmail(email);
        print("🔍 Checking credentials for: $email");
        print("🔍 User found: $user");

        if (user != null && user['password'] == hashedPassword) {
          await saveUserCredentials(email);
          print("✅ Login Successful!");
          return true;
        }
        print("❌ Invalid email or password");
        return false;
      }
    } catch (e) {
      print("❌ Error during login: $e");
      return false;
    }
  }

  /// Save user credentials
  Future<void> saveUserCredentials(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
    } catch (e) {
      print("❌ Error saving user credentials: $e");
    }
  }

  /// Get user details by email
  Future<Map<String, dynamic>?> getUserDetails(String email) async {
    try {
      return await _dbHelper.getUserByEmail(email);
    } catch (e) {
      print("❌ Error getting user details: $e");
      return null;
    }
  }

  /// Logout user
  Future<void> logoutUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      print("✅ User logged out successfully");
    } catch (e) {
      print("❌ Error logging out user: $e");
    }
  }

  /// Get saved user credentials (for auto-login)
Future<Map<String, String>> getUserCredentials() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return {'email': prefs.getString('email') ?? ""};
  } catch (e) {
    print("❌ Error getting user credentials: $e");
    return {'email': ""};
  }
}

}
