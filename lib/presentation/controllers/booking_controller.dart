import 'package:get/get.dart';
import '../../domain/models/booking_model.dart';
import '../../domain/services/booking_service.dart';
import '../../domain/services/availability_service.dart';

class BookingController extends GetxController {
  final BookingService _bookingService;
  final AvailabilityService _availabilityService;

  BookingController(this._bookingService, this._availabilityService);

  final RxList<BookingModel> bookings = <BookingModel>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<DateTime?> selectedCheckIn = Rx<DateTime?>(null);
  final Rx<DateTime?> selectedCheckOut = Rx<DateTime?>(null);

  /// Load bookings for a specific user
  Future<void> loadUserBookings(String userId) async {
    try {
      isLoading.value = true;
      final userBookings = await _bookingService.getUserBookings(userId);
      bookings.value = userBookings;
    } finally {
      isLoading.value = false;
    }
  }

  /// Load all bookings (for owner/admin)
  Future<void> loadAllBookings() async {
    try {
      isLoading.value = true;
      final allBookings = await _bookingService.getAllBookings();
      bookings.value = allBookings;
    } finally {
      isLoading.value = false;
    }
  }

  /// Create a new booking
  Future<BookingModel?> createBooking({
    required String id,
    required String userId,
    required String roomId,
    required DateTime checkIn,
    required DateTime checkOut,
    required double pricePerNight,
  }) async {
    try {
      isLoading.value = true;
      final booking = await _bookingService.createBooking(
        id: id,
        userId: userId,
        roomId: roomId,
        checkIn: checkIn,
        checkOut: checkOut,
        pricePerNight: pricePerNight,
      );
      
      if (booking != null) {
        await loadUserBookings(userId);
      }
      
      return booking;
    } finally {
      isLoading.value = false;
    }
  }

  /// Cancel a booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      isLoading.value = true;
      await _bookingService.cancelBooking(bookingId);
      
      // Refresh bookings list
      final index = bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        bookings[index] = bookings[index].copyWith(status: 'cancelled');
        bookings.refresh();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Check availability for a room and date range
  Future<int> checkAvailability(
    String roomId,
    DateTime checkIn,
    DateTime checkOut,
  ) async {
    return await _availabilityService.getAvailableRooms(
      roomId,
      checkIn,
      checkOut,
    );
  }

  /// Set selected dates
  void setCheckInDate(DateTime date) {
    selectedCheckIn.value = date;
  }

  void setCheckOutDate(DateTime date) {
    selectedCheckOut.value = date;
  }

  /// Clear selected dates
  void clearDates() {
    selectedCheckIn.value = null;
    selectedCheckOut.value = null;
  }

  /// Get booking summary
  Map<String, dynamic>? getBookingSummary(double pricePerNight) {
    if (selectedCheckIn.value == null || selectedCheckOut.value == null) {
      return null;
    }

    return _bookingService.calculateBookingSummary(
      checkIn: selectedCheckIn.value!,
      checkOut: selectedCheckOut.value!,
      pricePerNight: pricePerNight,
    );
  }

  /// Validate selected dates
  String? validateDates() {
    return _availabilityService.getDateValidationError(
      selectedCheckIn.value,
      selectedCheckOut.value,
    );
  }

  /// Filter bookings by status
  List<BookingModel> filterByStatus(String status) {
    return bookings.where((booking) => booking.status == status).toList();
  }

  /// Get confirmed bookings
  List<BookingModel> get confirmedBookings =>
      bookings.where((b) => b.isConfirmed).toList();

  /// Get cancelled bookings
  List<BookingModel> get cancelledBookings =>
      bookings.where((b) => b.isCancelled).toList();
}
