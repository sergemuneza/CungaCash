import 'package:flutter/material.dart';

class SettingsModel {
  final String languageCode;
  final String currency;
  final ThemeMode themeMode;

  SettingsModel({
    required this.languageCode,
    required this.currency,
    required this.themeMode,
  });

  Map<String, dynamic> toMap() {
    return {
      'languageCode': languageCode,
      'currency': currency,
      'themeMode': themeMode.index,
    };
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      languageCode: map['languageCode'] ?? 'en',
      currency: map['currency'] ?? 'Frw',
      themeMode: ThemeMode.values[map['themeMode'] ?? 0],
    );
  }
}
