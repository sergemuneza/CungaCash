// // // // import 'package:expense_tracker_pro/screens/financial_summary_screen.dart';
// // // // import 'package:expense_tracker_pro/screens/transaction_list_screen.dart';
// // // // import 'package:expense_tracker_pro/screens/welcome_screen.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:provider/provider.dart';
// // // // import 'screens/login_screen.dart';
// // // // import 'screens/signup_screen.dart';
// // // // import 'screens/home_screen.dart';
// // // // import 'screens/add_transaction_screen.dart';
// // // // import 'providers/auth_provider.dart';
// // // // import 'providers/transaction_provider.dart';


// // // // void main() async {
// // // //   WidgetsFlutterBinding.ensureInitialized();
  
// // // //   final authProvider = AuthProvider();
// // // //   await authProvider.checkAuthStatus(); // ✅ Now properly defined

// // // //   runApp(
// // // //     MultiProvider(
// // // //       providers: [
// // // //         ChangeNotifierProvider(create: (context) => authProvider),
// // // //         ChangeNotifierProvider(create: (context) => TransactionProvider()),
// // // //       ],
// // // //       child: MyApp(isAuthenticated: authProvider.isAuthenticated),
// // // //     ),
// // // //   );
// // // // }

// // // // class MyApp extends StatelessWidget {
// // // //   final bool isAuthenticated;

// // // //   const MyApp({super.key, required this.isAuthenticated});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return MaterialApp(
// // // //       debugShowCheckedModeBanner: false,
// // // //       title: 'Expense Tracker',
// // // //       theme: ThemeData(
// // // //         primarySwatch: Colors.blue,
// // // //         scaffoldBackgroundColor: Colors.grey[200],
// // // //         appBarTheme: AppBarTheme(
// // // //           color: Colors.blueAccent,
// // // //           elevation: 2,
// // // //           titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
// // // //           iconTheme: IconThemeData(color: Colors.white),
// // // //         ),
// // // //         textTheme: TextTheme(
// // // //           bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // // //           bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
// // // //         ),
// // // //         elevatedButtonTheme: ElevatedButtonThemeData(
// // // //           style: ElevatedButton.styleFrom(
// // // //             backgroundColor: Colors.blueAccent,
// // // //             foregroundColor: Colors.white,
// // // //             shape:
// // // //                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// // // //           ),
// // // //         ),
// // // //         inputDecorationTheme: InputDecorationTheme(
// // // //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// // // //           focusedBorder: OutlineInputBorder(
// // // //             borderSide: BorderSide(color: Colors.blueAccent, width: 2),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //       initialRoute: '/welcome',
// // // //       routes: {
// // // //          '/welcome': (context) => WelcomeScreen(),
// // // //         '/login': (context) => LoginScreen(),
// // // //         '/signup': (context) => SignupScreen(),
// // // //         '/home': (context) => HomeScreen(),
// // // //         '/add-transaction': (context) => AddTransactionScreen(),
// // // //         '/transaction-list': (context) => TransactionListScreen(), 
// // // //         '/financial-summary': (context) => FinancialSummaryScreen(),
// // // //       },
// // // //     );
// // // //   }
// // // // }

// // // import 'package:expense_tracker_pro/screens/financial_summary_screen.dart';
// // // import 'package:expense_tracker_pro/screens/transaction_list_screen.dart';
// // // import 'package:expense_tracker_pro/screens/welcome_screen.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_localizations/flutter_localizations.dart';
// // // import 'package:provider/provider.dart';
// // // import 'package:easy_localization/easy_localization.dart';

// // // import 'screens/login_screen.dart';
// // // import 'screens/signup_screen.dart';
// // // import 'screens/home_screen.dart';
// // // import 'screens/add_transaction_screen.dart';
// // // import 'providers/auth_provider.dart';
// // // import 'providers/transaction_provider.dart';

// // // void main() async {
// // //   WidgetsFlutterBinding.ensureInitialized();
// // //   await EasyLocalization.ensureInitialized();

// // //   final authProvider = AuthProvider();
// // //   await authProvider.checkAuthStatus();

// // //   runApp(
// // //     EasyLocalization(
// // //       supportedLocales: const [Locale('en'), Locale('rw')],
// // //       path: 'assets/langs', // ✅ Path where the translation JSONs are stored
// // //       fallbackLocale: const Locale('en'), 
// // //       child: MultiProvider(
// // //         providers: [
// // //           ChangeNotifierProvider(create: (context) => authProvider),
// // //           ChangeNotifierProvider(create: (context) => TransactionProvider()),
// // //         ],
// // //         child: MyApp(isAuthenticated: authProvider.isAuthenticated),
// // //       ),
// // //     ),

// // //   );
// // // }

// // // class MyApp extends StatelessWidget {
// // //   final bool isAuthenticated;

// // //   const MyApp({super.key, required this.isAuthenticated});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       debugShowCheckedModeBanner: false,
// // //       title: 'CungaCash',
// // //       localizationsDelegates: context.localizationDelegates,
// // //       supportedLocales: context.supportedLocales,
// // //       locale: context.locale,
// // //       theme: ThemeData(
// // //         primarySwatch: Colors.blue,
// // //         scaffoldBackgroundColor: Colors.grey[200],
// // //         appBarTheme: AppBarTheme(
// // //           color: Colors.blueAccent,
// // //           elevation: 2,
// // //           titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
// // //           iconTheme: IconThemeData(color: Colors.white),
// // //         ),
// // //         textTheme: TextTheme(
// // //           bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //           bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
// // //         ),
// // //         elevatedButtonTheme: ElevatedButtonThemeData(
// // //           style: ElevatedButton.styleFrom(
// // //             backgroundColor: Colors.blueAccent,
// // //             foregroundColor: Colors.white,
// // //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// // //           ),
// // //         ),
// // //         inputDecorationTheme: InputDecorationTheme(
// // //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// // //           focusedBorder: OutlineInputBorder(
// // //             borderSide: BorderSide(color: Colors.blueAccent, width: 2),
// // //           ),
// // //         ),
// // //       ),
// // //       initialRoute: '/welcome',
// // //       routes: {
// // //         '/welcome': (context) => WelcomeScreen(),
// // //         '/login': (context) => LoginScreen(),
// // //         '/signup': (context) => SignupScreen(),
// // //         '/home': (context) => HomeScreen(),
// // //         '/add-transaction': (context) => AddTransactionScreen(),
// // //         '/transaction-list': (context) => TransactionListScreen(),
// // //         '/financial-summary': (context) => FinancialSummaryScreen(),
// // //       },
// // //     );
// // //   }
// // // }
// // import 'package:expense_tracker_pro/providers/budget_provider.dart';
// // import 'package:expense_tracker_pro/providers/saving_goal_provider.dart';
// // import 'package:expense_tracker_pro/screens/budget/budget_list_screen.dart';
// // import 'package:expense_tracker_pro/screens/financial_summary_screen.dart';
// // import 'package:expense_tracker_pro/screens/transaction_list_screen.dart';
// // import 'package:expense_tracker_pro/screens/welcome_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_localizations/flutter_localizations.dart';
// // import 'package:provider/provider.dart';
// // import 'package:easy_localization/easy_localization.dart';

// // import 'screens/login_screen.dart';
// // import 'screens/signup_screen.dart';
// // import 'screens/home_screen.dart';
// // import 'screens/add_transaction_screen.dart';
// // import 'providers/auth_provider.dart';
// // import 'providers/transaction_provider.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await EasyLocalization.ensureInitialized();

// //   final authProvider = AuthProvider();
// //   await authProvider.checkAuthStatus();
// //   await EasyLocalization.ensureInitialized();
// //    //await EasyLocalization.deleteSaveLocale(); // 🧹 Clears any saved language

// //   runApp(
// //     EasyLocalization(
// //       supportedLocales: const [Locale('en'), Locale('rw')],
// //       path: 'assets/langs', // ✅ Path where the translation JSONs are stored
// //       fallbackLocale: const Locale('en'), // ✅ Fallback if translation is missing
// //       startLocale: const Locale('en'),    // ✅ Start the app in English
// //        saveLocale: false,    
// //       child: MultiProvider(
// //         providers: [
// //           ChangeNotifierProvider(create: (context) => authProvider),
// //           ChangeNotifierProvider(create: (context) => TransactionProvider()),
// //           ChangeNotifierProvider(create: (_) => SavingGoalProvider()),
// //           ChangeNotifierProvider(create: (_) => BudgetProvider()), // ✅ ADD THIS LINE
// //         ],
// //         child: MyApp(isAuthenticated: authProvider.isAuthenticated),
// //       ),
// //     ),
// //   );
// // }

// // class MyApp extends StatelessWidget {
// //   final bool isAuthenticated;

// //   const MyApp({super.key, required this.isAuthenticated});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'CungaCash',
// //       localizationsDelegates: context.localizationDelegates,
// //       supportedLocales: context.supportedLocales,
// //       locale: context.locale,
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //         scaffoldBackgroundColor: Colors.grey[200],
// //         appBarTheme: AppBarTheme(
// //           color: Colors.blueAccent,
// //           elevation: 2,
// //           titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
// //           iconTheme: IconThemeData(color: Colors.white),
// //         ),
// //         textTheme: TextTheme(
// //           bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //           bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
// //         ),
// //         elevatedButtonTheme: ElevatedButtonThemeData(
// //           style: ElevatedButton.styleFrom(
// //             backgroundColor: Colors.blueAccent,
// //             foregroundColor: Colors.white,
// //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //           ),
// //         ),
// //         inputDecorationTheme: InputDecorationTheme(
// //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //           focusedBorder: OutlineInputBorder(
// //             borderSide: BorderSide(color: Colors.blueAccent, width: 2),
// //           ),
// //         ),
// //       ),
// //       initialRoute: '/welcome',
// //       routes: {
// //         '/welcome': (context) => WelcomeScreen(),
// //         '/login': (context) => LoginScreen(),
// //         '/signup': (context) => SignupScreen(),
// //         '/home': (context) => HomeScreen(),
// //         '/add-transaction': (context) => AddTransactionScreen(),
// //         '/transaction-list': (context) => TransactionListScreen(),
// //         '/financial-summary': (context) => FinancialSummaryScreen(),
// //         '/budget-screen': (context) => const BudgetListScreen(),
// //       },
// //     );
// //   }
// // }
// import 'package:expense_tracker_pro/providers/budget_provider.dart';
// import 'package:expense_tracker_pro/providers/saving_goal_provider.dart';
// import 'package:expense_tracker_pro/providers/settings_provider.dart';
// import 'package:expense_tracker_pro/screens/budget/budget_list_screen.dart';
// import 'package:expense_tracker_pro/screens/financial_summary_screen.dart';
// import 'package:expense_tracker_pro/screens/settings_screen.dart';
// import 'package:expense_tracker_pro/screens/transaction_list_screen.dart';
// import 'package:expense_tracker_pro/screens/welcome_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:provider/provider.dart';
// import 'package:easy_localization/easy_localization.dart';

// import 'screens/login_screen.dart';
// import 'screens/signup_screen.dart';
// import 'screens/home_screen.dart';
// import 'screens/add_transaction_screen.dart';
// import 'providers/auth_provider.dart';
// import 'providers/transaction_provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await EasyLocalization.ensureInitialized();

//   final authProvider = AuthProvider();
//   await authProvider.checkAuthStatus();

//   runApp(
//     EasyLocalization(
//       supportedLocales: const [Locale('en'), Locale('rw')],
//       path: 'assets/langs',
//       fallbackLocale: const Locale('en'),
//       startLocale: const Locale('en'),
//       saveLocale: false,
//       child: MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (context) => authProvider),
//           ChangeNotifierProvider(create: (context) => TransactionProvider()),
//           ChangeNotifierProvider(create: (_) => SavingGoalProvider()),
//           ChangeNotifierProvider(create: (_) => BudgetProvider()),
//           ChangeNotifierProvider(create: (_) => SettingsProvider()),
//         ],
//         child: MyApp(isAuthenticated: authProvider.isAuthenticated, userId: authProvider.currentUser?.id ?? ''),
//       ),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   final bool isAuthenticated;
//   final String userId;

//   const MyApp({super.key, required this.isAuthenticated, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'CungaCash',
//       localizationsDelegates: context.localizationDelegates,
//       supportedLocales: context.supportedLocales,
//       locale: context.locale,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.grey[200],
//         appBarTheme: const AppBarTheme(
//           color: Colors.blueAccent,
//           elevation: 2,
//           titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
//           iconTheme: IconThemeData(color: Colors.white),
//         ),
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blueAccent,
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           focusedBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.blueAccent, width: 2),
//           ),
//         ),
//       ),
//       initialRoute: '/welcome',
//       routes: {
//         '/welcome': (context) => WelcomeScreen(),
//         '/login': (context) => LoginScreen(),
//         '/signup': (context) => SignupScreen(),
//         '/home': (context) => HomeScreen(),
//         '/add-transaction': (context) => AddTransactionScreen(),
//         '/transaction-list': (context) => TransactionListScreen(),
//         '/financial-summary': (context) => FinancialSummaryScreen(),
//         '/budget-screen': (context) => BudgetListScreen(userId: userId),
//         '/settings': (context) => SettingsScreen(),
//       },
//     );
    
//   }
// }
import 'package:expense_tracker_pro/providers/budget_provider.dart';
import 'package:expense_tracker_pro/providers/saving_goal_provider.dart';
import 'package:expense_tracker_pro/providers/settings_provider.dart';
import 'package:expense_tracker_pro/screens/budget/budget_list_screen.dart';
import 'package:expense_tracker_pro/screens/financial_summary_screen.dart';
import 'package:expense_tracker_pro/screens/settings_screen.dart';
import 'package:expense_tracker_pro/screens/transaction_list_screen.dart';
import 'package:expense_tracker_pro/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_transaction_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/transaction_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.checkAuthStatus();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('rw')],
      path: 'assets/langs',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      saveLocale: false,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => authProvider),
          ChangeNotifierProvider(create: (context) => TransactionProvider()),
          ChangeNotifierProvider(create: (_) => SavingGoalProvider()),
          ChangeNotifierProvider(create: (_) => BudgetProvider()),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ],
        child: MyApp(isAuthenticated: authProvider.isAuthenticated, userId: authProvider.currentUser?.id ?? ''),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  final String userId;

  const MyApp({super.key, required this.isAuthenticated, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CungaCash',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          themeMode: settingsProvider.settings.themeMode,
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          initialRoute: '/welcome',
          routes: {
            '/welcome': (context) => WelcomeScreen(),
            '/login': (context) => LoginScreen(),
            '/signup': (context) => SignupScreen(),
            '/home': (context) => HomeScreen(),
            '/add-transaction': (context) => AddTransactionScreen(),
            '/transaction-list': (context) => TransactionListScreen(),
            '/financial-summary': (context) => FinancialSummaryScreen(),
            '/budget-screen': (context) => BudgetListScreen(userId: userId),
            '/settings': (context) => SettingsScreen(),
          },
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      primaryColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.grey[50],
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 2,
        titleTextStyle: TextStyle(
          color: Colors.white, 
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: TextTheme(
        headlineLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        headlineMedium: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        headlineSmall: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        bodyLarge: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        bodyMedium: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      dividerColor: Colors.grey[300],
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      primaryColor: Colors.blueAccent,
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 2,
        titleTextStyle: TextStyle(
          color: Colors.white, 
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: TextTheme(
        headlineLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineSmall: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyLarge: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyMedium: const TextStyle(
          fontSize: 16,
          color: Colors.white70,
        ),
        bodySmall: const TextStyle(
          fontSize: 14,
          color: Colors.white60,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1E1E1E),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white60),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        textColor: Colors.white,
        iconColor: Colors.white70,
      ),
      dividerColor: Colors.white24,
      iconTheme: const IconThemeData(color: Colors.white70),
    );
  }
}