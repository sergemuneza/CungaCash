// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../models/settings_model.dart';

// // class SettingsProvider with ChangeNotifier {
// //   late SettingsModel _settings;

// //   SettingsModel get settings => _settings;

// //   SettingsProvider() {
// //     _loadSettings();
// //   }

// //   Future<void> _loadSettings() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final languageCode = prefs.getString('languageCode') ?? 'en';
// //     final currency = prefs.getString('currency') ?? 'Frw';
// //     final themeIndex = prefs.getInt('themeMode') ?? 0;

// //     _settings = SettingsModel(
// //       languageCode: languageCode,
// //       currency: currency,
// //       themeMode: ThemeMode.values[themeIndex],
// //     );

// //     notifyListeners();
// //   }

// //   Future<void> updateLanguage(String languageCode) async {
// //     _settings = SettingsModel(
// //       languageCode: languageCode,
// //       currency: _settings.currency,
// //       themeMode: _settings.themeMode,
// //     );
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString('languageCode', languageCode);
// //     notifyListeners();
// //   }

// //   Future<void> updateCurrency(String currency) async {
// //     _settings = SettingsModel(
// //       languageCode: _settings.languageCode,
// //       currency: currency,
// //       themeMode: _settings.themeMode,
// //     );
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString('currency', currency);
// //     notifyListeners();
// //   }

// //   Future<void> updateTheme(ThemeMode themeMode) async {
// //     _settings = SettingsModel(
// //       languageCode: _settings.languageCode,
// //       currency: _settings.currency,
// //       themeMode: themeMode,
// //     );
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setInt('themeMode', themeMode.index);
// //     notifyListeners();
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Settings {
//   final String languageCode;
//   final String currency;
//   final ThemeMode themeMode;
//   final bool enableNotifications;
//   final bool enableBiometrics;

//   Settings({
//     this.languageCode = 'en',
//     this.currency = 'Frw',
//     this.themeMode = ThemeMode.system,
//     this.enableNotifications = true,
//     this.enableBiometrics = false,
//   });

//   Settings copyWith({
//     String? languageCode,
//     String? currency,
//     ThemeMode? themeMode,
//     bool? enableNotifications,
//     bool? enableBiometrics,
//   }) {
//     return Settings(
//       languageCode: languageCode ?? this.languageCode,
//       currency: currency ?? this.currency,
//       themeMode: themeMode ?? this.themeMode,
//       enableNotifications: enableNotifications ?? this.enableNotifications,
//       enableBiometrics: enableBiometrics ?? this.enableBiometrics,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'languageCode': languageCode,
//       'currency': currency,
//       'themeMode': themeMode.index,
//       'enableNotifications': enableNotifications,
//       'enableBiometrics': enableBiometrics,
//     };
//   }

//   factory Settings.fromJson(Map<String, dynamic> json) {
//     return Settings(
//       languageCode: json['languageCode'] ?? 'en',
//       currency: json['currency'] ?? 'Frw',
//       themeMode: ThemeMode.values[json['themeMode'] ?? 0],
//       enableNotifications: json['enableNotifications'] ?? true,
//       enableBiometrics: json['enableBiometrics'] ?? false,
//     );
//   }
// }

// class SettingsProvider extends ChangeNotifier {
//   Settings _settings = Settings();
//   SharedPreferences? _prefs;

//   Settings get settings => _settings;

//   SettingsProvider() {
//     _loadSettings();
//   }

//   Future<void> _loadSettings() async {
//     try {
//       _prefs = await SharedPreferences.getInstance();
      
//       final settingsData = _prefs?.getString('app_settings');
//       if (settingsData != null) {
//         final Map<String, dynamic> settingsJson = {};
//         // Parse the settings data if it's stored as JSON
//         // For now, we'll load individual preferences
//         _settings = Settings(
//           languageCode: _prefs?.getString('language_code') ?? 'en',
//           currency: _prefs?.getString('currency') ?? 'Frw',
//           themeMode: ThemeMode.values[_prefs?.getInt('theme_mode') ?? 0],
//           enableNotifications: _prefs?.getBool('enable_notifications') ?? true,
//           enableBiometrics: _prefs?.getBool('enable_biometrics') ?? false,
//         );
//       }
//       notifyListeners();
//     } catch (e) {
//       print('Error loading settings: $e');
//     }
//   }

//   Future<void> _saveSettings() async {
//     try {
//       if (_prefs == null) {
//         _prefs = await SharedPreferences.getInstance();
//       }
      
//       await _prefs?.setString('language_code', _settings.languageCode);
//       await _prefs?.setString('currency', _settings.currency);
//       await _prefs?.setInt('theme_mode', _settings.themeMode.index);
//       await _prefs?.setBool('enable_notifications', _settings.enableNotifications);
//       await _prefs?.setBool('enable_biometrics', _settings.enableBiometrics);
      
//     } catch (e) {
//       print('Error saving settings: $e');
//     }
//   }

//   Future<void> updateLanguage(String languageCode) async {
//     _settings = _settings.copyWith(languageCode: languageCode);
//     await _saveSettings();
//     notifyListeners();
//   }

//   Future<void> updateCurrency(String currency) async {
//     _settings = _settings.copyWith(currency: currency);
//     await _saveSettings();
//     notifyListeners();
//   }

//   Future<void> updateTheme(ThemeMode themeMode) async {
//     _settings = _settings.copyWith(themeMode: themeMode);
//     await _saveSettings();
//     notifyListeners();
//   }

//   Future<void> updateNotifications(bool enable) async {
//     _settings = _settings.copyWith(enableNotifications: enable);
//     await _saveSettings();
//     notifyListeners();
//   }

//   Future<void> updateBiometrics(bool enable) async {
//     _settings = _settings.copyWith(enableBiometrics: enable);
//     await _saveSettings();
//     notifyListeners();
//   }

//   Future<void> resetSettings() async {
//     _settings = Settings();
//     await _saveSettings();
//     notifyListeners();
//   }

//   // Utility methods for formatting
//   String formatCurrency(double amount) {
//     switch (_settings.currency) {
//       case 'USD':
//         return '\$${amount.toStringAsFixed(2)}';
//       case 'Frw':
//         return '${amount.toStringAsFixed(0)} Frw';
//       default:
//         return '${amount.toStringAsFixed(2)} ${_settings.currency}';
//     }
//   }

//   String get currencySymbol {
//     switch (_settings.currency) {
//       case 'USD':
//         return '\$';
//       case 'Frw':
//         return 'Frw';
//       default:
//         return _settings.currency;
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  final String languageCode;
  final String currency;
  final ThemeMode themeMode;
  final bool enableNotifications;
  final bool enableBiometrics;

  Settings({
    this.languageCode = 'en',
    this.currency = 'Frw',
    this.themeMode = ThemeMode.light, // Set default to dark
    this.enableNotifications = true,
    this.enableBiometrics = false,
  });

  Settings copyWith({
    String? languageCode,
    String? currency,
    ThemeMode? themeMode,
    bool? enableNotifications,
    bool? enableBiometrics,
  }) {
    return Settings(
      languageCode: languageCode ?? this.languageCode,
      currency: currency ?? this.currency,
      themeMode: themeMode ?? this.themeMode,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableBiometrics: enableBiometrics ?? this.enableBiometrics,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languageCode': languageCode,
      'currency': currency,
      'themeMode': themeMode.index,
      'enableNotifications': enableNotifications,
      'enableBiometrics': enableBiometrics,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      languageCode: json['languageCode'] ?? 'en',
      currency: json['currency'] ?? 'Frw',
      themeMode: ThemeMode.values[json['themeMode'] ?? ThemeMode.light.index],
      enableNotifications: json['enableNotifications'] ?? true,
      enableBiometrics: json['enableBiometrics'] ?? false,
    );
  }
}

class SettingsProvider extends ChangeNotifier {
  Settings _settings = Settings(themeMode: ThemeMode.light); // Set default to dark
  SharedPreferences? _prefs;

  Settings get settings => _settings;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      _prefs = await SharedPreferences.getInstance();

      _settings = Settings(
        languageCode: _prefs?.getString('language_code') ?? 'en',
        currency: _prefs?.getString('currency') ?? 'Frw',
        themeMode: ThemeMode.values[_prefs?.getInt('theme_mode') ?? ThemeMode.light.index],
        enableNotifications: _prefs?.getBool('enable_notifications') ?? true,
        enableBiometrics: _prefs?.getBool('enable_biometrics') ?? false,
      );

      notifyListeners();
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      if (_prefs == null) {
        _prefs = await SharedPreferences.getInstance();
      }

      await _prefs?.setString('language_code', _settings.languageCode);
      await _prefs?.setString('currency', _settings.currency);
      await _prefs?.setInt('theme_mode', _settings.themeMode.index);
      await _prefs?.setBool('enable_notifications', _settings.enableNotifications);
      await _prefs?.setBool('enable_biometrics', _settings.enableBiometrics);
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  Future<void> updateLanguage(String languageCode) async {
    _settings = _settings.copyWith(languageCode: languageCode);
    await _saveSettings();
    notifyListeners();
  }

  Future<void> updateCurrency(String currency) async {
    _settings = _settings.copyWith(currency: currency);
    await _saveSettings();
    notifyListeners();
  }

  Future<void> updateTheme(ThemeMode themeMode) async {
    _settings = _settings.copyWith(themeMode: themeMode);
    await _saveSettings();
    notifyListeners();
  }

  Future<void> updateNotifications(bool enable) async {
    _settings = _settings.copyWith(enableNotifications: enable);
    await _saveSettings();
    notifyListeners();
  }

  Future<void> updateBiometrics(bool enable) async {
    _settings = _settings.copyWith(enableBiometrics: enable);
    await _saveSettings();
    notifyListeners();
  }

  Future<void> resetSettings() async {
    _settings = Settings(themeMode: ThemeMode.light); // Reset to default with dark mode
    await _saveSettings();
    notifyListeners();
  }

  // Utility methods for formatting
  String formatCurrency(double amount) {
    switch (_settings.currency) {
      case 'USD':
        return '\$${amount.toStringAsFixed(2)}';
      case 'Frw':
        return '${amount.toStringAsFixed(0)} Frw';
      default:
        return '${amount.toStringAsFixed(2)} ${_settings.currency}';
    }
  }

  String get currencySymbol {
    switch (_settings.currency) {
      case 'USD':
        return '\$';
      case 'Frw':
        return 'Frw';
      default:
        return _settings.currency;
    }
  }
}
