import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../../core/utils/constants.dart';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for 2 seconds to show splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is logged in
    final authController = Get.find<AuthController>();
    
    if (authController.isLoggedIn) {
      // Navigate to appropriate dashboard based on role
      _navigateToDashboard(authController.userRole);
    } else {
      // Navigate to login screen
      Get.offAllNamed(AppRoutes.login);
    }
  }

  void _navigateToDashboard(String? role) {
    switch (role) {
      case AppConstants.roleCustomer:
        Get.offAllNamed(AppRoutes.customerRooms);
        break;
      case AppConstants.roleOwner:
        Get.offAllNamed(AppRoutes.ownerDashboard);
        break;
      case AppConstants.roleAdmin:
        Get.offAllNamed(AppRoutes.adminDashboard);
        break;
      default:
        Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hotel,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              AppConstants.appName,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
