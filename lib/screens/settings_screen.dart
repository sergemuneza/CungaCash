// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:easy_localization/easy_localization.dart';
// import '../providers/settings_provider.dart';

// class SettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final settingsProvider = Provider.of<SettingsProvider>(context);
//     final settings = settingsProvider.settings;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('settings').tr(),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             title: Text('language').tr(),
//             trailing: DropdownButton<String>(
//               value: settings.languageCode,
//               items: [
//                 DropdownMenuItem(
//                   child: Text('English'),
//                   value: 'en',
//                 ),
//                 DropdownMenuItem(
//                   child: Text('Kinyarwanda'),
//                   value: 'rw',
//                 ),
//               ],
//               onChanged: (value) {
//                 if (value != null) {
//                   context.setLocale(Locale(value));
//                   settingsProvider.updateLanguage(value);
//                 }
//               },
//             ),
//           ),
//           ListTile(
//             title: Text('currency').tr(),
//             trailing: DropdownButton<String>(
//               value: settings.currency,
//               items: [
//                 DropdownMenuItem(
//                   child: Text('Frw'),
//                   value: 'Frw',
//                 ),
//                 DropdownMenuItem(
//                   child: Text('USD'),
//                   value: 'USD',
//                 ),
//               ],
//               onChanged: (value) {
//                 if (value != null) {
//                   settingsProvider.updateCurrency(value);
//                 }
//               },
//             ),
//           ),
//           ListTile(
//             title: Text('theme').tr(),
//             trailing: DropdownButton<ThemeMode>(
//               value: settings.themeMode,
//               items: [
//                 DropdownMenuItem(
//                   child: Text('light').tr(),
//                   value: ThemeMode.light,
//                 ),
//                 DropdownMenuItem(
//                   child: Text('dark').tr(),
//                   value: ThemeMode.dark,
//                 ),
//                 DropdownMenuItem(
//                   child: Text('system').tr(),
//                   value: ThemeMode.system,
//                 ),
//               ],
//               onChanged: (value) {
//                 if (value != null) {
//                   settingsProvider.updateTheme(value);
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final settings = settingsProvider.settings;

    return Scaffold(
      appBar: AppBar(
        title: Text('settings').tr(),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, 'appearance'.tr()),
          _buildThemeCard(context, settingsProvider),
          const SizedBox(height: 16),
          
          _buildSectionHeader(context, 'language_and_region'.tr()),
          _buildLanguageCard(context, settingsProvider),
          const SizedBox(height: 8),
          _buildCurrencyCard(context, settingsProvider),
          const SizedBox(height: 16),
          
          _buildSectionHeader(context, 'notifications'.tr()),
          _buildNotificationCard(context, settingsProvider),
          const SizedBox(height: 16),
          
          // _buildSectionHeader(context, 'security'.tr()),
          // _buildSecurityCard(context, settingsProvider),
          // const SizedBox(height: 24),
          
          _buildResetButton(context, settingsProvider),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context, SettingsProvider settingsProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.palette_outlined, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(
                  'theme'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildThemeOption(
                    context,
                    'light'.tr(),
                    Icons.light_mode,
                    ThemeMode.light,
                    settingsProvider.settings.themeMode,
                    settingsProvider,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildThemeOption(
                    context,
                    'dark'.tr(),
                    Icons.dark_mode,
                    ThemeMode.dark,
                    settingsProvider.settings.themeMode,
                    settingsProvider,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildThemeOption(
                    context,
                    'system'.tr(),
                    Icons.auto_mode,
                    ThemeMode.system,
                    settingsProvider.settings.themeMode,
                    settingsProvider,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String label,
    IconData icon,
    ThemeMode themeMode,
    ThemeMode currentTheme,
    SettingsProvider settingsProvider,
  ) {
    final isSelected = currentTheme == themeMode;
    
    return GestureDetector(
      onTap: () => settingsProvider.updateTheme(themeMode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected 
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.transparent,
          border: Border.all(
            color: isSelected 
              ? Theme.of(context).primaryColor
              : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected 
                ? Theme.of(context).primaryColor
                : Theme.of(context).iconTheme.color,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected 
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).textTheme.bodySmall?.color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context, SettingsProvider settingsProvider) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.language, color: Theme.of(context).primaryColor),
        title: Text('language'.tr()),
        subtitle: Text(_getLanguageDisplayName(settingsProvider.settings.languageCode)),
        trailing: DropdownButton<String>(
          value: settingsProvider.settings.languageCode,
          underline: const SizedBox(),
          items: const [
            DropdownMenuItem(
              child: Text('English'),
              value: 'en',
            ),
            DropdownMenuItem(
              child: Text('Kinyarwanda'),
              value: 'rw',
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              context.setLocale(Locale(value));
              settingsProvider.updateLanguage(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildCurrencyCard(BuildContext context, SettingsProvider settingsProvider) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.attach_money, color: Theme.of(context).primaryColor),
        title: Text('currency'.tr()),
        subtitle: Text(_getCurrencyDisplayName(settingsProvider.settings.currency)),
        trailing: DropdownButton<String>(
          value: settingsProvider.settings.currency,
          underline: const SizedBox(),
          items: const [
            DropdownMenuItem(
              child: Text('Rwandan Franc (Frw)'),
              value: 'Frw',
            ),
            DropdownMenuItem(
              child: Text('US Dollar (USD)'),
              value: 'USD',
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              settingsProvider.updateCurrency(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, SettingsProvider settingsProvider) {
    return Card(
      child: SwitchListTile(
        secondary: Icon(Icons.notifications, color: Theme.of(context).primaryColor),
        title: Text('enable_notifications'.tr()),
        subtitle: Text('receive_alerts_and_reminders'.tr()),
        value: settingsProvider.settings.enableNotifications,
        onChanged: (value) {
          settingsProvider.updateNotifications(value);
        },
      ),
    );
  }

  // Widget _buildSecurityCard(BuildContext context, SettingsProvider settingsProvider) {
  //   return Card(
  //     child: SwitchListTile(
  //       secondary: Icon(Icons.fingerprint, color: Theme.of(context).primaryColor),
  //       title: Text('biometric_authentication'.tr()),
  //       subtitle: Text('use_fingerprint_or_face_id'.tr()),
  //       value: settingsProvider.settings.enableBiometrics,
  //       onChanged: (value) {
  //         settingsProvider.updateBiometrics(value);
  //       },
  //     ),
  //   );
  // }

  Widget _buildResetButton(BuildContext context, SettingsProvider settingsProvider) {
    return ElevatedButton.icon(
      onPressed: () => _showResetDialog(context, settingsProvider),
      icon: const Icon(Icons.refresh),
      label: Text('reset_to_defaults'.tr()),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  void _showResetDialog(BuildContext context, SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('reset_settings'.tr()),
        content: Text('reset_settings_confirmation'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              settingsProvider.resetSettings();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('settings_reset_successfully'.tr()),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('reset'.tr()),
          ),
        ],
      ),
    );
  }

  String _getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'rw':
        return 'Kinyarwanda';
      default:
        return languageCode;
    }
  }

  String _getCurrencyDisplayName(String currency) {
    switch (currency) {
      case 'Frw':
        return 'Rwandan Franc';
      case 'USD':
        return 'US Dollar';
      default:
        return currency;
    }
  }
}