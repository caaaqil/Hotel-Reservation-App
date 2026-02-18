import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../core/utils/constants.dart';
import '../../../core/theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hotel,
                  size: 80,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select your role to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 48),
                Obx(() {
                  if (userController.isLoading.value) {
                    return const CircularProgressIndicator();
                  }

                  return Column(
                    children: [
                      _buildRoleCard(
                        context: context,
                        icon: Icons.person,
                        title: 'Customer',
                        description: 'Browse and book hotel rooms',
                        color: Colors.green,
                        onTap: () => _loginAsRole(
                          authController,
                          userController,
                          AppConstants.roleCustomer,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildRoleCard(
                        context: context,
                        icon: Icons.business,
                        title: 'Owner',
                        description: 'Manage rooms, users, and bookings',
                        color: Colors.orange,
                        onTap: () => _loginAsRole(
                          authController,
                          userController,
                          AppConstants.roleOwner,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildRoleCard(
                        context: context,
                        icon: Icons.admin_panel_settings,
                        title: 'Admin',
                        description: 'Full system access and management',
                        color: Colors.red,
                        onTap: () => _loginAsRole(
                          authController,
                          userController,
                          AppConstants.roleAdmin,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginAsRole(
    AuthController authController,
    UserController userController,
    String role,
  ) async {
    // Find user with the selected role
    final users = userController.filterByRole(role);
    if (users.isEmpty) return;

    final user = users.first;
    await authController.login(user);

    // Navigate to appropriate dashboard
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
    }
  }
}
