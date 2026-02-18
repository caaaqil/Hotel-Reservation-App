import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/room_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../../data/local_db/hive_service.dart';
import '../../../core/utils/date_helper.dart';
import '../../../routes/app_routes.dart';

class BookingCalendarScreen extends StatefulWidget {
  const BookingCalendarScreen({super.key});

  @override
  State<BookingCalendarScreen> createState() => _BookingCalendarScreenState();
}

class _BookingCalendarScreenState extends State<BookingCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedCheckIn;
  DateTime? _selectedCheckOut;

  @override
  Widget build(BuildContext context) {
    final bookingController = Get.find<BookingController>();
    final roomController = Get.find<RoomController>();
    final authController = Get.find<AuthController>();
    final room = roomController.selectedRoom.value;

    if (room == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Book Room')),
        body: const Center(child: Text('Room not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Dates'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Room summary
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${room.price.toStringAsFixed(0)} / night',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Calendar
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) {
                if (_selectedCheckIn != null && _selectedCheckOut != null) {
                  return day.isAfter(_selectedCheckIn!.subtract(const Duration(days: 1))) &&
                      day.isBefore(_selectedCheckOut!.add(const Duration(days: 1)));
                }
                return (_selectedCheckIn != null && DateHelper.isSameDay(day, _selectedCheckIn!)) ||
                    (_selectedCheckOut != null && DateHelper.isSameDay(day, _selectedCheckOut!));
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                  
                  if (_selectedCheckIn == null || 
                      (_selectedCheckIn != null && _selectedCheckOut != null)) {
                    // Start new selection
                    _selectedCheckIn = selectedDay;
                    _selectedCheckOut = null;
                  } else if (_selectedCheckIn != null && _selectedCheckOut == null) {
                    // Complete selection
                    if (selectedDay.isAfter(_selectedCheckIn!)) {
                      _selectedCheckOut = selectedDay;
                    } else {
                      _selectedCheckOut = _selectedCheckIn;
                      _selectedCheckIn = selectedDay;
                    }
                  }
                });
              },
              enabledDayPredicate: (day) {
                return !DateHelper.isPastDate(day);
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blue.shade300,
                  shape: BoxShape.circle,
                ),
                disabledTextStyle: TextStyle(color: Colors.grey.shade400),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
            // Booking summary
            if (_selectedCheckIn != null && _selectedCheckOut != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      'Check-in',
                      DateHelper.formatDate(_selectedCheckIn!),
                    ),
                    _buildSummaryRow(
                      'Check-out',
                      DateHelper.formatDate(_selectedCheckOut!),
                    ),
                    _buildSummaryRow(
                      'Nights',
                      '${DateHelper.calculateNights(_selectedCheckIn!, _selectedCheckOut!)}',
                    ),
                    const Divider(height: 24),
                    _buildSummaryRow(
                      'Total Price',
                      '\$${(DateHelper.calculateNights(_selectedCheckIn!, _selectedCheckOut!) * room.price).toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            // Confirm button
            if (_selectedCheckIn != null && _selectedCheckOut != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Obx(() => ElevatedButton(
                        onPressed: bookingController.isLoading.value
                            ? null
                            : () => _confirmBooking(
                                  bookingController,
                                  authController,
                                  room.id,
                                  room.price,
                                ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: bookingController.isLoading.value
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Confirm Booking',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      )),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? Colors.green.shade700 : null,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmBooking(
    BookingController bookingController,
    AuthController authController,
    String roomId,
    double pricePerNight,
  ) async {
    if (_selectedCheckIn == null || _selectedCheckOut == null) return;

    final userId = authController.currentUser.value?.id;
    if (userId == null) return;

    // Check availability
    final available = await bookingController.checkAvailability(
      roomId,
      _selectedCheckIn!,
      _selectedCheckOut!,
    );

    if (available <= 0) {
      Get.snackbar(
        'Not Available',
        'This room is not available for the selected dates',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Create booking
    final booking = await bookingController.createBooking(
      id: HiveService().generateId(),
      userId: userId,
      roomId: roomId,
      checkIn: _selectedCheckIn!,
      checkOut: _selectedCheckOut!,
      pricePerNight: pricePerNight,
    );

    if (booking != null) {
      Get.snackbar(
        'Success',
        'Booking confirmed!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate to my bookings
      Get.offAllNamed(AppRoutes.myBookings);
    } else {
      Get.snackbar(
        'Error',
        'Failed to create booking. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
