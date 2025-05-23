// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import '../providers/auth_provider.dart';

// // class HomeScreen extends StatelessWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final authProvider = Provider.of<AuthProvider>(context);

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Home"),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.logout),
// //             onPressed: () async {
// //               await authProvider.logout();
// //               Navigator.pushReplacementNamed(context, '/login');
// //             },
// //           ),
// //         ],
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Text(
// //               "Welcome Dear, ${authProvider.firstName ?? "User"}!",
// //               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 10),
// //             Text(
// //               "To Your Expense Tracking😊",
// //               style: TextStyle(fontSize: 16),
// //             ),
// //             const SizedBox(height: 30),
// //             ElevatedButton(
// //               onPressed: () {
// //                 Navigator.pushNamed(context, '/transaction-list');
// //               },
// //               child: const Text("Go to Transactions"),
// //             ),
// //              // ✅ New Button for Financial Summary
// //       ElevatedButton(
// //         onPressed: () {
// //           Navigator.pushNamed(context, '/financial-summary');
// //         },
// //         child: const Text("View Financial Summary"),
// //       ),
// //           ],
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           Navigator.pushNamed(context, '/add-transaction');
// //         },
// //         backgroundColor: Colors.blueAccent,
// //         child: Icon(Icons.add),
// //       ),
// //     );
// //   }
// // } 

// import 'package:expense_tracker_pro/screens/saving_goal_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';


// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);

//     return Scaffold(
//       extendBodyBehindAppBar: true, // Allows content behind the AppBar
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // ✅ Full-Screen Background Image
//           Image.asset(
//             "assets/images/background.jpg", // Make sure you have this image in assets
//             fit: BoxFit.cover,
//           ),

//           // ✅ Dark Overlay for Text Readability
//           Container(
//             color: Colors.black.withOpacity(0.6), // Adjust transparency as needed
//           ),

//           // ✅ Content
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Welcome Message
//                   Text(
//                     "Welcome, ${authProvider.firstName ?? "User"}! 🎉",
//                     style: const TextStyle(
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 12),
//                   const Text(
//                     "Track your expenses and stay financially smart with CungaCash App!",
//                     style: TextStyle(fontSize: 16, color: Colors.white70),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 40),

//                   // ✅ Animated Buttons
//                   _buildButton(
//                     context: context,
//                     label: "Go to Transactions",
//                     onTap: () => Navigator.pushNamed(context, '/transaction-list'),
//                   ),
//                   const SizedBox(height: 15),
//                   _buildButton(
//                     context: context,
//                     label: "View Financial Summary",
//                     onTap: () => Navigator.pushNamed(context, '/financial-summary'),
//                   ),
//                   const SizedBox(height: 20),

//                   //buton new
//                   _buildButton(
//                   context: context,
//                   label: "Manage Saving Goals",
//                   onTap: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => SavingGoalScreen()),
//                   ),
//                 ),
//                 const SizedBox(height: 15),

//                 //---------
//                 _buildButton(
//   context: context,
//   label: "Manage Budgets",
//   onTap: () => Navigator.pushNamed(context, '/budget-screen'),
// ),
// const SizedBox(height: 15),


//                   // ✅ Logout Button
//                   TextButton.icon(
//                     onPressed: () async {
//                       await authProvider.logout();
//                       Navigator.pushReplacementNamed(context, '/login');
//                     },
//                     icon: const Icon(Icons.logout, color: Colors.redAccent),
//                     label: const Text(
//                       "Logout",
//                       style: TextStyle(fontSize: 16, color: Colors.redAccent),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),

//       // ✅ Floating Action Button with Better UX
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, '/add-transaction');
//         },
//         backgroundColor: Colors.blueAccent,
//         child: const Icon(Icons.add, size: 28),
//       ),
//     );
//   }

//   /// 🔥 **Reusable Stylish Button with Animation**
//   Widget _buildButton({
//     required BuildContext context,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(30), // Rounded corners effect
//       splashColor: Colors.blue.withOpacity(0.2), // Ripple effect on tap
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.blueAccent,
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.blueAccent.withOpacity(0.5),
//               blurRadius: 10,
//               spreadRadius: 2,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Text(
//           label,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:expense_tracker_pro/screens/saving_goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    // return Scaffold(
    //   extendBodyBehindAppBar: true,
    //   body: Stack(
    //     fit: StackFit.expand,
    //     children: [
    //       Image.asset(
    //         "assets/images/background.jpg",
    //         fit: BoxFit.cover,
    //       ),
    //       Container(
    //         color: Colors.black.withOpacity(0.6),
    //       ),
    return Scaffold(
  extendBodyBehindAppBar: true,
  appBar: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {
          Navigator.pushNamed(context, '/settings');
        },
      ),
    ],
  ),
  body: Stack(
    fit: StackFit.expand,
    children: [
      Image.asset(
        "assets/images/background.jpg",
        fit: BoxFit.cover,
      ),
      Container(
        color: Colors.black.withOpacity(0.6),
      ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Welcome, ${user?.firstName ?? "User"}! 🎉",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Track your expenses and stay financially smart with CungaCash App!",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  _buildButton(
                    context: context,
                    label: "Go to Transactions",
                    onTap: () => Navigator.pushNamed(context, '/transaction-list'),
                  ),
                  const SizedBox(height: 15),
                  _buildButton(
                    context: context,
                    label: "View Financial Summary",
                    onTap: () => Navigator.pushNamed(context, '/financial-summary'),
                  ),
                  const SizedBox(height: 20),
                  _buildButton(
                    context: context,
                    label: "Manage Saving Goals",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SavingGoalScreen()),
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildButton(
                    context: context,
                    label: "Manage Budgets",
                    onTap: () => Navigator.pushNamed(context, '/budget-screen'),
                  ),
                  const SizedBox(height: 15),
                  TextButton.icon(
                    onPressed: () async {
                      await authProvider.logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    label: const Text(
                      "Logout",
                      style: TextStyle(fontSize: 16, color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-transaction');
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      splashColor: Colors.blue.withOpacity(0.2),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
