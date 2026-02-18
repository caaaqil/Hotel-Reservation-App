import '../../domain/repositories/booking_repository.dart';
import '../../domain/repositories/room_repository.dart';
import '../../core/utils/date_helper.dart';

class AvailabilityService {
  final BookingRepository _bookingRepository;
  final RoomRepository _roomRepository;

  AvailabilityService(this._bookingRepository, this._roomRepository);

  /// Calculate available rooms for a given room and date range
  Future<int> getAvailableRooms(
    String roomId,
    DateTime checkIn,
    DateTime checkOut,
  ) async {
    // Get the room to know total rooms
    final room = await _roomRepository.getById(roomId);
    if (room == null) return 0;

    // Get confirmed bookings that overlap with the requested date range
    final overlappingBookings =
        await _bookingRepository.getConfirmedBookingsInDateRange(
      roomId,
      checkIn,
      checkOut,
    );

    // Available rooms = total rooms - number of overlapping bookings
    final availableRooms = room.totalRooms - overlappingBookings.length;
    return availableRooms > 0 ? availableRooms : 0;
  }

  /// Check if a booking can be made for the given date range
  Future<bool> canBook(
    String roomId,
    DateTime checkIn,
    DateTime checkOut,
  ) async {
    // Validate dates
    if (!_validateDates(checkIn, checkOut)) {
      return false;
    }

    // Check availability
    final available = await getAvailableRooms(roomId, checkIn, checkOut);
    return available > 0;
  }

  /// Validate date range
  bool _validateDates(DateTime checkIn, DateTime checkOut) {
    // Check if check-in is in the past
    if (DateHelper.isPastDate(checkIn)) {
      return false;
    }

    // Check if check-out is after check-in
    if (!DateHelper.isValidDateRange(checkIn, checkOut)) {
      return false;
    }

    return true;
  }

  /// Get validation error message
  String? getDateValidationError(DateTime? checkIn, DateTime? checkOut) {
    if (checkIn == null || checkOut == null) {
      return 'Please select both check-in and check-out dates';
    }

    if (DateHelper.isPastDate(checkIn)) {
      return 'Check-in date cannot be in the past';
    }

    if (!DateHelper.isValidDateRange(checkIn, checkOut)) {
      return 'Check-out date must be after check-in date';
    }

    return null;
  }
}
