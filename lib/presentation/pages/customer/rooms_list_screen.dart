import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/room_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/room_card.dart';
import '../../widgets/feature_chip.dart';

class RoomsListScreen extends StatelessWidget {
  const RoomsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roomController = Get.find<RoomController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar Area
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Find your hotel',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Where to next?',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.person_outline),
                        onPressed: () => _showUserMenu(context, authController),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search Bar
                  TextField(
                    onChanged: (value) => roomController.searchQuery.value = value,
                    decoration: InputDecoration(
                      hintText: 'Search hotels...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: AppTheme.backgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ],
              ),
            ),
            
            // Categories / Filter Chips
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.white,
              child: Obx(() {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: roomController.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final category = roomController.categories[index];
                    return Obx(() {
                      final isSelected = roomController.selectedCategory.value == category;
                      return FeatureChip(
                        label: category,
                        isSelected: isSelected,
                        onTap: () {
                          roomController.selectedCategory.value = category;
                        },
                      );
                    });
                  },
                );
              }),
            ),

            // Room List
            Expanded(
              child: Obx(() {
                if (roomController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (roomController.filteredRooms.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'No rooms found',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => roomController.loadRooms(),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: roomController.filteredRooms.length,
                    itemBuilder: (context, index) {
                      final room = roomController.filteredRooms[index];
                      return RoomCard(
                        room: room,
                        onTap: () {
                          roomController.selectRoom(room);
                          Get.toNamed(AppRoutes.roomDetails);
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppTheme.primaryColor,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online_outlined),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            Get.toNamed(AppRoutes.myBookings);
          }
        },
      ),
    );
  }

  void _showUserMenu(BuildContext context, AuthController authController) {
    // ... same as before but using AppTheme
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(authController.currentUser.value?.name ?? 'User'),
              subtitle: Text(authController.currentUser.value?.email ?? ''),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Get.back();
                await authController.logout();
                Get.offAllNamed(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
