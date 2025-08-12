//Home Screen

import 'package:cungacash/screens/saving_goal_screen.dart';
import 'package:cungacash/screens/pay_marriage_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // This removes the back arrow
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),

                    // Welcome Section
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "${"welcome".tr()}, ${user?.firstName ?? "user".tr()}! 🎉",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "homeIntro".tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Action Buttons Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: [
                        _buildGridButton(
                          context: context,
                          label: "goToTransactions".tr(),
                          icon: Icons.receipt_long,
                          onTap: () =>
                              Navigator.pushNamed(context, '/transaction-list'),
                        ),

//---------------------------------------------------------
                        _buildGridButton(
                          context: context,
                          label: "PALS".tr(),
                          icon: Icons.account_balance_wallet,
                          onTap: () =>
                              Navigator.pushNamed(context, '/pay-marriage'),
                        ),
//-------------------------------------------------------------

                        _buildGridButton(
                          context: context,
                          label: "manageBudgets".tr(),
                          icon: Icons.account_balance_wallet,
                          onTap: () =>
                              Navigator.pushNamed(context, '/budget-screen'),
                        ),
                        _buildGridButton(
                          context: context,
                          label: "manageSavingGoals".tr(),
                          icon: Icons.savings,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SavingGoalScreen()),
                          ),
                        ),
                        _buildGridButton(
                          context: context,
                          label: "viewSummary".tr(),
                          icon: Icons.analytics,
                          onTap: () => Navigator.pushNamed(
                              context, '/financial-summary'),
                        ),
                        // _buildGridButton(
                        //   context: context,
                        //   label: "manageSavingGoals".tr(),
                        //   icon: Icons.savings,
                        //   onTap: () => Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (_) => SavingGoalScreen()),
                        //   ),
                        // ),
                        // _buildGridButton(
                        //   context: context,
                        //   label: "manageBudgets".tr(),
                        //   icon: Icons.account_balance_wallet,
                        //   onTap: () => Navigator.pushNamed(context, '/budget-screen'),
                        // ),
                        //                         _buildGridButton(
                        //   context: context,
                        //   label: "goToTransactions".tr(),
                        //   icon: Icons.receipt_long,
                        //   onTap: () => Navigator.pushNamed(context, '/transaction-list'),
                        // ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Add Transaction Button
                    _buildPrimaryButton(
                      context: context,
                      label: "add_transaction".tr(),
                      icon: Icons.add,
                      onTap: () =>
                          Navigator.pushNamed(context, '/add-transaction'),
                    ),

                    const SizedBox(height: 20),

                    // Logout Button
                    Container(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: () async {
                          await authProvider.logout();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.redAccent.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.logout, color: Colors.redAccent),
                        label: Text(
                          "logout".tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildPrimaryButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blueAccent,
              Colors.blue[600]!,
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.6),
              Colors.white.withOpacity(0.4),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.7),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.black87,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
