import '../models/booking_model.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/date_helper.dart';
import 'availability_service.dart';

class BookingService {
  final BookingRepository _bookingRepository;
  final AvailabilityService _availabilityService;

  BookingService(this._bookingRepository, this._availabilityService);

  /// Create a new booking with validation
  Future<BookingModel?> createBooking({
    required String id,
    required String userId,
    required String roomId,
    required DateTime checkIn,
    required DateTime checkOut,
    required double pricePerNight,
  }) async {
    // Check availability
    final canBook = await _availabilityService.canBook(roomId, checkIn, checkOut);
    if (!canBook) {
      return null;
    }

    // Calculate nights and total price
    final nights = DateHelper.calculateNights(checkIn, checkOut);
    final totalPrice = nights * pricePerNight;

    // Create booking
    final booking = BookingModel(
      id: id,
      userId: userId,
      roomId: roomId,
      checkIn: checkIn,
      checkOut: checkOut,
      nights: nights,
      totalPrice: totalPrice,
      status: AppConstants.statusConfirmed,
    );

    await _bookingRepository.create(booking);
    return booking;
  }

  /// Cancel a booking
  Future<void> cancelBooking(String bookingId) async {
    final booking = await _bookingRepository.getById(bookingId);
    if (booking != null) {
      final updatedBooking = booking.copyWith(
        status: AppConstants.statusCancelled,
      );
      await _bookingRepository.update(updatedBooking);
    }
  }

  /// Get all bookings for a user
  Future<List<BookingModel>> getUserBookings(String userId) async {
    return await _bookingRepository.getByUserId(userId);
  }

  /// Get all bookings (for owner/admin)
  Future<List<BookingModel>> getAllBookings() async {
    return await _bookingRepository.getAll();
  }

  /// Calculate booking summary
  Map<String, dynamic> calculateBookingSummary({
    required DateTime checkIn,
    required DateTime checkOut,
    required double pricePerNight,
  }) {
    final nights = DateHelper.calculateNights(checkIn, checkOut);
    final totalPrice = nights * pricePerNight;

    return {
      'nights': nights,
      'totalPrice': totalPrice,
      'checkInFormatted': DateHelper.formatDate(checkIn),
      'checkOutFormatted': DateHelper.formatDate(checkOut),
    };
  }
}
