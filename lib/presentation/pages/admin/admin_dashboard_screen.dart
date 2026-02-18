import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/room_controller.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/user_controller.dart';
import '../../../routes/app_routes.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final roomController = Get.find<RoomController>();
    final bookingController = Get.find<BookingController>();
    final userController = Get.find<UserController>();

    // Load all bookings for admin
    bookingController.loadAllBookings();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.logout();
              Get.offAllNamed(AppRoutes.login);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${authController.currentUser.value?.name}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            // Statistics
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Rooms',
                        '${roomController.rooms.length}',
                        Icons.hotel,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Total Bookings',
                        '${bookingController.bookings.length}',
                        Icons.book_online,
                        Colors.green,
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 12),
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Users',
                        '${userController.users.length}',
                        Icons.people,
                        Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Confirmed',
                        '${bookingController.confirmedBookings.length}',
                        Icons.check_circle,
                        Colors.orange,
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 32),
            // Management options
            const Text(
              'System Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              'View Rooms',
              'Browse all hotel rooms',
              Icons.hotel,
              Colors.blue,
              () => Get.toNamed(AppRoutes.manageRooms),
            ),
            const SizedBox(height: 12),
            _buildMenuCard(
              'View Bookings',
              'Monitor all bookings',
              Icons.book_online,
              Colors.green,
              () => Get.toNamed(AppRoutes.manageBookings),
            ),
            const SizedBox(height: 12),
            _buildMenuCard(
              'View Users',
              'See all system users',
              Icons.people,
              Colors.purple,
              () => Get.toNamed(AppRoutes.manageUsers),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
