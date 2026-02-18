import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/user_controller.dart';
import '../../controllers/room_controller.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/date_helper.dart';

class ManageBookingsScreen extends StatefulWidget {
  const ManageBookingsScreen({super.key});

  @override
  State<ManageBookingsScreen> createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final bookingController = Get.find<BookingController>();
    bookingController.loadAllBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingController = Get.find<BookingController>();
    final userController = Get.find<UserController>();
    final roomController = Get.find<RoomController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Manage Bookings',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'In-House'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: Obx(() {
        if (bookingController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final now = DateTime.now();
        final upcoming = bookingController.bookings.where((b) => b.checkIn.isAfter(now) && b.status == 'confirmed').toList();
        final inHouse = bookingController.bookings.where((b) => b.checkIn.isBefore(now) && b.checkOut.isAfter(now) && b.status == 'confirmed').toList();
        final past = bookingController.bookings.where((b) => b.checkOut.isBefore(now) || b.status == 'cancelled').toList();

        return TabBarView(
          controller: _tabController,
          children: [
            _buildBookingsList(upcoming, userController, roomController, bookingController),
            _buildBookingsList(inHouse, userController, roomController, bookingController),
            _buildBookingsList(past, userController, roomController, bookingController),
          ],
        );
      }),
    );
  }

  Widget _buildBookingsList(List bookings, UserController userController, RoomController roomController, BookingController bookingController) {
    if (bookings.isEmpty) {
      return const Center(child: Text('No bookings found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final user = userController.users.firstWhereOrNull((u) => u.id == booking.userId);
        final room = roomController.rooms.firstWhereOrNull((r) => r.id == booking.roomId);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Room Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    room?.images.first ?? 'https://via.placeholder.com/80',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: AppColors.borderLight,
                        child: const Icon(Icons.hotel, color: AppColors.iconGrey),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Booking Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.name ?? 'Guest',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  room?.name ?? 'Room',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: booking.status == 'confirmed' ? AppColors.confirmed : AppColors.pending,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              booking.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: booking.status == 'confirmed' ? AppColors.confirmedText : AppColors.pendingText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 6),
                          Text(
                            '${DateHelper.formatDate(booking.checkIn)} - ${DateHelper.formatDate(booking.checkOut)} • ${booking.nights} nights',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.edit, size: 16),
                              label: const Text('Modify'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.textPrimary,
                                side: const BorderSide(color: AppColors.border),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _cancelBooking(bookingController, booking.id),
                              icon: const Icon(Icons.close, size: 16),
                              label: const Text('Cancel'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.danger,
                                side: const BorderSide(color: AppColors.danger),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _cancelBooking(BookingController bookingController, String bookingId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Yes', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await bookingController.cancelBooking(bookingId);
      Get.snackbar(
        'Success',
        'Booking cancelled',
        backgroundColor: AppColors.warning,
        colorText: Colors.white,
      );
    }
  }
}
