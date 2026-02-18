import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controllers/room_controller.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../core/utils/app_colors.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roomController = Get.find<RoomController>();
    final bookingController = Get.find<BookingController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.borderLight,
            child: Icon(Icons.person, color: AppColors.iconGrey),
          ),
        ),
        title: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back,',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            Text(
              authController.currentUser.value?.name ?? 'Owner',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
          ],
        )),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            Obx(() {
              final totalRooms = roomController.rooms.fold<int>(0, (sum, room) => sum + room.totalRooms);
              final activeBookings = bookingController.confirmedBookings.where((b) => 
                b.checkIn.isBefore(DateTime.now()) && b.checkOut.isAfter(DateTime.now())
              ).length;

              return Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.hotel,
                      iconColor: AppColors.primary,
                      title: 'Total Rooms',
                      value: totalRooms.toString(),
                      change: '+2%',
                      isPositive: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.check_circle,
                      iconColor: Colors.orange,
                      title: 'Active',
                      value: activeBookings.toString(),
                      change: '+5%',
                      isPositive: true,
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 24),
            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.add_home,
                    title: 'Add Room',
                    color: AppColors.primary,
                    onTap: () => Get.toNamed(AppRoutes.manageRooms),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.calendar_today,
                    title: 'Manage\nBookings',
                    color: Colors.white,
                    textColor: AppColors.textPrimary,
                    onTap: () => Get.toNamed(AppRoutes.manageBookings),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Today's Performance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today\'s Performance',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View Report', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          return Text(
                            days[value.toInt() % 7],
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 40, color: AppColors.primary.withOpacity(0.3), width: 24, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 60, color: AppColors.primary.withOpacity(0.5), width: 24, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 95, color: AppColors.primary, width: 24, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 50, color: AppColors.primary.withOpacity(0.4), width: 24, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 70, color: AppColors.primary.withOpacity(0.4), width: 24, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 45, color: AppColors.primary.withOpacity(0.3), width: 24, borderRadius: BorderRadius.circular(4))]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Activity List
            Obx(() {
              final todayCheckIns = bookingController.confirmedBookings.where((b) => 
                b.checkIn.year == DateTime.now().year &&
                b.checkIn.month == DateTime.now().month &&
                b.checkIn.day == DateTime.now().day
              ).length;

              final todayCheckOuts = bookingController.confirmedBookings.where((b) => 
                b.checkOut.year == DateTime.now().year &&
                b.checkOut.month == DateTime.now().month &&
                b.checkOut.day == DateTime.now().day
              ).length;

              return Column(
                children: [
                  _buildActivityItem(
                    icon: Icons.login,
                    title: 'Check-ins Pending',
                    subtitle: '$todayCheckIns Guests arriving today',
                    count: todayCheckIns,
                  ),
                  const SizedBox(height: 12),
                  _buildActivityItem(
                    icon: Icons.logout,
                    title: 'Scheduled Check-outs',
                    subtitle: '$todayCheckOuts Rooms to be vacated',
                    count: todayCheckOuts,
                  ),
                  const SizedBox(height: 12),
                  _buildActivityItem(
                    icon: Icons.build,
                    title: 'Service Requests',
                    subtitle: 'Maintenance & Cleaning',
                    count: 3,
                    countColor: Colors.orange,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String change,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: isPositive ? AppColors.success : AppColors.danger,
              ),
              const SizedBox(width: 4),
              Text(
                change,
                style: TextStyle(
                  fontSize: 12,
                  color: isPositive ? AppColors.success : AppColors.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color == Colors.white ? AppColors.primary.withOpacity(0.1) : Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color == Colors.white ? AppColors.primary : Colors.white, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor ?? Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required int count,
    Color? countColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.iconGrey, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(
            count.toString().padLeft(2, '0'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: countColor ?? AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.dashboard_outlined, 'Dashboard', true, () {}),
              _buildNavItem(Icons.meeting_room_outlined, 'Properties', false, () => Get.toNamed(AppRoutes.manageRooms)),
              _buildNavItem(Icons.bar_chart, 'Reports', false, () {}),
              _buildNavItem(Icons.settings_outlined, 'Settings', false, () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? AppColors.primary : AppColors.iconGrey, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
