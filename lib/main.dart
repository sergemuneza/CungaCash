// // import 'package:expense_tracker_pro/screens/financial_summary_screen.dart';
// // import 'package:expense_tracker_pro/screens/transaction_list_screen.dart';
// // import 'package:expense_tracker_pro/screens/welcome_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'screens/login_screen.dart';
// // import 'screens/signup_screen.dart';
// // import 'screens/home_screen.dart';
// // import 'screens/add_transaction_screen.dart';
// // import 'providers/auth_provider.dart';
// // import 'providers/transaction_provider.dart';


// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
  
// //   final authProvider = AuthProvider();
// //   await authProvider.checkAuthStatus(); // ✅ Now properly defined

// //   runApp(
// //     MultiProvider(
// //       providers: [
// //         ChangeNotifierProvider(create: (context) => authProvider),
// //         ChangeNotifierProvider(create: (context) => TransactionProvider()),
// //       ],
// //       child: MyApp(isAuthenticated: authProvider.isAuthenticated),
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
// //       title: 'Expense Tracker',
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
// //             shape:
// //                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
// //          '/welcome': (context) => WelcomeScreen(),
// //         '/login': (context) => LoginScreen(),
// //         '/signup': (context) => SignupScreen(),
// //         '/home': (context) => HomeScreen(),
// //         '/add-transaction': (context) => AddTransactionScreen(),
// //         '/transaction-list': (context) => TransactionListScreen(), 
// //         '/financial-summary': (context) => FinancialSummaryScreen(),
// //       },
// //     );
// //   }
// // }

// import 'package:expense_tracker_pro/screens/financial_summary_screen.dart';
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
//       path: 'assets/langs', // ✅ Path where the translation JSONs are stored
//       fallbackLocale: const Locale('en'), 
//       child: MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (context) => authProvider),
//           ChangeNotifierProvider(create: (context) => TransactionProvider()),
//         ],
//         child: MyApp(isAuthenticated: authProvider.isAuthenticated),
//       ),
//     ),

//   );
// }

// class MyApp extends StatelessWidget {
//   final bool isAuthenticated;

//   const MyApp({super.key, required this.isAuthenticated});

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
//         appBarTheme: AppBarTheme(
//           color: Colors.blueAccent,
//           elevation: 2,
//           titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
//           iconTheme: IconThemeData(color: Colors.white),
//         ),
//         textTheme: TextTheme(
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
//           focusedBorder: OutlineInputBorder(
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
//       },
//     );
//   }
// }
import 'package:expense_tracker_pro/providers/saving_goal_provider.dart';
import 'package:expense_tracker_pro/screens/financial_summary_screen.dart';
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
  await EasyLocalization.ensureInitialized();
   //await EasyLocalization.deleteSaveLocale(); // 🧹 Clears any saved language

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('rw')],
      path: 'assets/langs', // ✅ Path where the translation JSONs are stored
      fallbackLocale: const Locale('en'), // ✅ Fallback if translation is missing
      startLocale: const Locale('en'),    // ✅ Start the app in English
       saveLocale: false,    
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => authProvider),
          ChangeNotifierProvider(create: (context) => TransactionProvider()),
          ChangeNotifierProvider(create: (_) => SavingGoalProvider()),
        ],
        child: MyApp(isAuthenticated: authProvider.isAuthenticated),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;

  const MyApp({super.key, required this.isAuthenticated});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CungaCash',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
        appBarTheme: AppBarTheme(
          color: Colors.blueAccent,
          elevation: 2,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
        ),
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/add-transaction': (context) => AddTransactionScreen(),
        '/transaction-list': (context) => TransactionListScreen(),
        '/financial-summary': (context) => FinancialSummaryScreen(),
      },
    );
  }
}
