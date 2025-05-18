// // // /*
// // // Developer: SERGE MUNEZA
// // //  */

// // // import 'package:flutter/material.dart';
// // // import 'login_screen.dart';
// // // import 'signup_screen.dart';

// // // class WelcomeScreen extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       body: Container(
// // //         width: double.infinity,
// // //         decoration: BoxDecoration(
// // //           gradient: LinearGradient(
// // //             colors: [Colors.blue.shade400, Colors.blue.shade900],
// // //             begin: Alignment.topCenter,
// // //             end: Alignment.bottomCenter,
// // //           ),
// // //         ),
// // //         child: SafeArea(
// // //           child: SingleChildScrollView(
// // //             child: Padding(
// // //               padding: const EdgeInsets.symmetric(horizontal: 20),
// // //               child: Column(
// // //                 mainAxisAlignment: MainAxisAlignment.center,
// // //                 children: [
// // //                   const SizedBox(height:20),

// // //                   // ✅ Animated Logo
// // //                   TweenAnimationBuilder(
// // //                     duration: const Duration(milliseconds: 1000),
// // //                     tween: Tween<double>(begin: 0, end: 1),
// // //                     builder: (context, double value, child) {
// // //                       return Opacity(
// // //                         opacity: value,
// // //                         child: Transform.translate(
// // //                           offset: Offset(0, (1 - value) * -30),
// // //                           child: child,
// // //                         ),
// // //                       );
// // //                     },
// // //                     child: Image.asset(
// // //                       'assets/images/logoexpense.png',
// // //                       height: 250,
// // //                       width: 250,
// // //                     ),
// // //                   ),

// // //                   const SizedBox(height: 5),

// // //                   // ✅ Welcome Text
// // //                   const Text(
// // //                     "CungaCash — Smart Personal Finance Manager App",
// // //                     textAlign: TextAlign.center,
// // //                     style: TextStyle(
// // //                       fontSize: 20,
// // //                       fontWeight: FontWeight.bold,
// // //                       color: Colors.white,
// // //                       letterSpacing: 1.0,
// // //                     ),
// // //                   ),

// // //                   const SizedBox(height: 20),

// // //                   // ✅ Description Text
// // //                   const Text(
// // //                     "App yo kugufasha gucunga no kubika amafaranga yawe neza!"
// // //                     "App yo kugufasha gucunga no kubika amafaranga yawe neza!"
// // //                     "App yo kugufasha gucunga no kubika amafaranga yawe neza!"
// // //                     "App yo kugufasha gucunga no kubika amafaranga yawe neza!"
// // //                     "App yo kugufasha gucunga no kubika amafaranga yawe neza!",
// // //                     textAlign: TextAlign.center,
// // //                     style: TextStyle(fontSize: 16, color: Colors.white70),
// // //                   ),

// // //                   const SizedBox(height: 30),

// // //                   // ✅ Gift From Text
// // //                   const Text(
// // //                     "Developer: SERGE MUNEZA",
// // //                     style: TextStyle(
// // //                         fontSize: 20,
// // //                         fontWeight: FontWeight.bold,
// // //                         color: Colors.white),
// // //                   ),

// // //                   const SizedBox(height: 50),

// // //                   // ✅ Animated Buttons
// // //                   _buildAnimatedButton(
// // //                     text: "Login",
// // //                     onTap: () {
// // //                       Navigator.push(
// // //                           context,
// // //                           MaterialPageRoute(
// // //                               builder: (context) => LoginScreen()));
// // //                     },
// // //                   ),
// // //                   const SizedBox(height: 15),
// // //                   _buildAnimatedButton(
// // //                     text: "Sign Up",
// // //                     onTap: () {
// // //                       Navigator.push(
// // //                           context,
// // //                           MaterialPageRoute(
// // //                               builder: (context) => SignupScreen()));
// // //                     },
// // //                   ),

// // //                   const SizedBox(height: 40),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   /// 🔥 **Developer Info Widget**
// // //   Widget _buildDeveloperInfo(
// // //       {required String imagePath, required String name}) {
// // //     return Row(
// // //       mainAxisAlignment: MainAxisAlignment.center,
// // //       children: [
// // //         CircleAvatar(
// // //           radius: 35,
// // //           backgroundImage: AssetImage(imagePath),
// // //         ),
// // //         const SizedBox(width: 10),
// // //         Text(
// // //           name,
// // //           style: const TextStyle(
// // //             fontSize: 18,
// // //             fontWeight: FontWeight.bold,
// // //             color: Colors.white,
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   /// 🔥 **Reusable Animated Button**
// // //   Widget _buildAnimatedButton(
// // //       {required String text, required VoidCallback onTap}) {
// // //     return TweenAnimationBuilder(
// // //       duration: const Duration(milliseconds: 800),
// // //       tween: Tween<double>(begin: 0, end: 1),
// // //       builder: (context, double value, child) {
// // //         return Opacity(
// // //           opacity: value,
// // //           child: Transform.scale(
// // //             scale: value,
// // //             child: child,
// // //           ),
// // //         );
// // //       },
// // //       child: ElevatedButton(
// // //         style: ElevatedButton.styleFrom(
// // //           backgroundColor: Colors.white,
// // //           padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
// // //           elevation: 5,
// // //           shape: RoundedRectangleBorder(
// // //               borderRadius: BorderRadius.circular(30)), // Rounded buttons
// // //         ),
// // //         onPressed: onTap,
// // //         child: Text(text,
// // //             style: const TextStyle(
// // //                 color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold)),
// // //       ),
// // //     );
// // //   }
// // // }
// // /*
// // Developer: SERGE MUNEZA
// // */

// // import 'package:flutter/material.dart';
// // import 'package:easy_localization/easy_localization.dart';
// // import 'login_screen.dart';
// // import 'signup_screen.dart';

// // class WelcomeScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         width: double.infinity,
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: [Colors.blue.shade400, Colors.blue.shade900],
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //           ),
// //         ),
// //         child: SafeArea(
// //           child: SingleChildScrollView(
// //             child: Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 20),
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   const SizedBox(height: 20),

// //                   // ✅ Animated Logo
// //                   TweenAnimationBuilder(
// //                     duration: const Duration(milliseconds: 1000),
// //                     tween: Tween<double>(begin: 0, end: 1),
// //                     builder: (context, double value, child) {
// //                       return Opacity(
// //                         opacity: value,
// //                         child: Transform.translate(
// //                           offset: Offset(0, (1 - value) * -30),
// //                           child: child,
// //                         ),
// //                       );
// //                     },
// //                     child: Image.asset(
// //                       'assets/images/logoexpense.png',
// //                       height: 250,
// //                       width: 250,
// //                     ),
// //                   ),

// //                   const SizedBox(height: 5),

// //                   // ✅ Localized App Name
// //                   Text(
// //                     "welcome_title".tr(),
// //                     textAlign: TextAlign.center,
// //                     style: const TextStyle(
// //                       fontSize: 20,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.white,
// //                       letterSpacing: 1.0,
// //                     ),
// //                   ),

// //                   const SizedBox(height: 20),

// //                   // ✅ Localized Description
// //                   Text(
// //                     "welcome_description".tr(),
// //                     textAlign: TextAlign.center,
// //                     style: const TextStyle(fontSize: 16, color: Colors.white70),
// //                   ),

// //                   const SizedBox(height: 30),

// //                   // ✅ Localized Developer Info
// //                   Text(
// //                     "developer_info".tr(),
// //                     style: const TextStyle(
// //                         fontSize: 20,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.white),
// //                   ),

// //                   const SizedBox(height: 50),

// //                   // ✅ Animated Buttons
// //                   _buildAnimatedButton(
// //                     text: "login".tr(),
// //                     onTap: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(builder: (context) => LoginScreen()),
// //                       );
// //                     },
// //                   ),
// //                   const SizedBox(height: 15),
// //                   _buildAnimatedButton(
// //                     text: "signup".tr(),
// //                     onTap: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(builder: (context) => SignupScreen()),
// //                       );
// //                     },
// //                   ),

// //                   const SizedBox(height: 40),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildAnimatedButton(
// //       {required String text, required VoidCallback onTap}) {
// //     return TweenAnimationBuilder(
// //       duration: const Duration(milliseconds: 800),
// //       tween: Tween<double>(begin: 0, end: 1),
// //       builder: (context, double value, child) {
// //         return Opacity(
// //           opacity: value,
// //           child: Transform.scale(
// //             scale: value,
// //             child: child,
// //           ),
// //         );
// //       },
// //       child: ElevatedButton(
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: Colors.white,
// //           padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
// //           elevation: 5,
// //           shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(30)),
// //         ),
// //         onPressed: onTap,
// //         child: Text(
// //           text,
// //           style: const TextStyle(
// //               color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:expense_tracker_pro/widgets/LanguageDropdown.dart';
// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'login_screen.dart';
// import 'signup_screen.dart';

// class WelcomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blue.shade400, Colors.blue.shade900],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: Stack(
//             children: [
//               // 🌐 Language Dropdown Positioned Top-Right
//               Positioned(
//                 right: 20,
//                 top: 10,
//                 child: LanguageDropdown(),
//               ),
//               // Main Content
//               SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 60),

//                       // ✅ Logo
//                       TweenAnimationBuilder(
//                         duration: const Duration(milliseconds: 1000),
//                         tween: Tween<double>(begin: 0, end: 1),
//                         builder: (context, double value, child) {
//                           return Opacity(
//                             opacity: value,
//                             child: Transform.translate(
//                               offset: Offset(0, (1 - value) * -30),
//                               child: child,
//                             ),
//                           );
//                         },
//                         child: Image.asset(
//                           'assets/images/logoexpense.png',
//                           height: 250,
//                           width: 250,
//                         ),
//                       ),

//                       const SizedBox(height: 5),

//                       Text(
//                         "welcome_title".tr(),
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           letterSpacing: 1.0,
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       Text(
//                         "welcome_description".tr(),
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(fontSize: 16, color: Colors.white70),
//                       ),

//                       const SizedBox(height: 30),

//                       Text(
//                         "developer_info".tr(),
//                         style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),

//                       const SizedBox(height: 50),

//                       _buildAnimatedButton(
//                         text: "login".tr(),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => LoginScreen()),
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 15),
//                       _buildAnimatedButton(
//                         text: "signup".tr(),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => SignupScreen()),
//                           );
//                         },
//                       ),

//                       const SizedBox(height: 40),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAnimatedButton({required String text, required VoidCallback onTap}) {
//     return TweenAnimationBuilder(
//       duration: const Duration(milliseconds: 800),
//       tween: Tween<double>(begin: 0, end: 1),
//       builder: (context, double value, child) {
//         return Opacity(
//           opacity: value,
//           child: Transform.scale(
//             scale: value,
//             child: child,
//           ),
//         );
//       },
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
//           elevation: 5,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         ),
//         onPressed: onTap,
//         child: Text(
//           text,
//           style: const TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
import 'package:expense_tracker_pro/widgets/LanguageDropdown.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 🌐 Language Dropdown Positioned Top-Right
              Positioned(
                right: 20,
                top: 10,
                child: LanguageDropdown(),
              ),
              // Main Content
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),

                      // ✅ Logo
                      TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 1000),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, double value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, (1 - value) * -30),
                              child: child,
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/images/logoexpense.png',
                          height: 250,
                          width: 250,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "welcome_title".tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "welcome_description".tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.white70),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        "developer_info".tr(),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),

                      const SizedBox(height: 50),

                      _buildAnimatedButton(
                        text: "login".tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildAnimatedButton(
                        text: "signup".tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignupScreen()),
                          );
                        },
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton({required String text, required VoidCallback onTap}) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: value,
            child: child,
          ),
        );
      },
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
