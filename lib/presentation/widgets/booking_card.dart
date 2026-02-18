import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/room_model.dart';
import '../../utils/date_helper.dart';
import '../../utils/constants.dart';
import '../controllers/room_controller.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onCancel;
  final bool showCancelButton;

  const BookingCard({
    super.key,
    required this.booking,
    this.onCancel,
    this.showCancelButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final roomController = Get.find<RoomController>();

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking #${booking.id.substring(0, 8)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),
            const Divider(height: 24),
            FutureBuilder<RoomModel?>(
              future: roomController.getRoomById(booking.roomId),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final room = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.hotel, size: 20, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              room.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  'Check-in: ${DateHelper.formatDate(booking.checkIn)}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.event, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  'Check-out: ${DateHelper.formatDate(booking.checkOut)}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.nights_stay, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  '${booking.nights} night${booking.nights > 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Price:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  '\$${booking.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            if (showCancelButton && booking.isConfirmed && onCancel != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onCancel,
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancel Booking'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final isConfirmed = booking.status == AppConstants.statusConfirmed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isConfirmed ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        booking.status.toUpperCase(),
        style: TextStyle(
          color: isConfirmed ? Colors.green.shade900 : Colors.red.shade900,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
