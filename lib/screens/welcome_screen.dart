//welcome screen 
import 'package:cungacash/widgets/LanguageDropdown.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade300,
              Colors.blue.shade600,
              Colors.blue.shade900,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 🧭 Main Content (moved before decorative elements)
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 80),

                          // 🎯 Enhanced Logo with Animation
                          TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 1200),
                            tween: Tween<double>(begin: 0, end: 1),
                            builder: (context, double value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, (1 - value) * -50),
                                  child: Transform.scale(
                                    scale: 0.7 + (value * 0.3),
                                    child: child,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: 'appLogo',
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'assets/images/logoexpense.png',
                                  height: 160,
                                  width: 160,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Enhanced App Title
                          TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 1000),
                            tween: Tween<double>(begin: 0, end: 1),
                            builder: (context, double value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, (1 - value) * 20),
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              context.tr('CungaCash — Smart Personal Finance Manager App'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                                height: 1.3,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Enhanced Subtitle
                          TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 1200),
                            tween: Tween<double>(begin: 0, end: 1),
                            builder: (context, double value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, (1 - value) * 15),
                                  child: child,
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.2)),
                              ),
                              child: Text(
                                context.tr('An app that help you to manage and track your finance effectively!'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 50),

                          // Enhanced Buttons
                          _buildAnimatedButton(
                            text: context.tr('login'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                              );
                            },
                            isPrimary: true,
                          ),
                          
                          const SizedBox(height: 18),
                          
                          _buildAnimatedButton(
                            text: context.tr('signup'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SignupScreen()),
                              );
                            },
                            isPrimary: false,
                          ),

                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),

                  // 👨‍💻 Developer Credit and Copyright Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Developer Credit
                        Text(
                          context.tr('Developed by SERGE MUNEZA'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.95),
                            letterSpacing: 0.8,
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Copyright Information
                        Text(
                          '© ${DateTime.now().year} CungaCash. All rights reserved.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Version info
                        Text(
                          'Version 1.0.0',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.6),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 🌟 Background decorative elements (moved after main content)
              Positioned(
                top: 100,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: 200,
                left: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),

              // 🌐 Language Dropdown Positioned Top-Right (keeping your original - HIGHEST Z-INDEX)
              Positioned(
                right: 20,
                top: 10,
                child: Material(
                  color: Colors.transparent,
                  elevation: 10,
                  child: const LanguageDropdown(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton({
    required String text,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 0.8 + (value * 0.2),
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isPrimary ? Colors.white : Colors.transparent,
            foregroundColor: isPrimary ? Colors.blue.shade700 : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: isPrimary ? 8 : 0,
            shadowColor: Colors.black.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: isPrimary 
                ? BorderSide.none 
                : BorderSide(color: Colors.white.withOpacity(0.8), width: 2),
            ),
          ),
          onPressed: onTap,
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: isPrimary ? Colors.blue.shade700 : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}