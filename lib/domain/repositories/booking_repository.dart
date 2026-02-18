import '../models/booking_model.dart';

/// Abstract repository interface for Booking operations
/// This allows easy swapping between local and remote data sources
abstract class BookingRepository {
  Future<List<BookingModel>> getAll();
  Future<BookingModel?> getById(String id);
  Future<List<BookingModel>> getByUserId(String userId);
  Future<List<BookingModel>> getByRoomId(String roomId);
  Future<List<BookingModel>> getConfirmedBookingsInDateRange(
    String roomId,
    DateTime start,
    DateTime end,
  );
  Future<void> create(BookingModel booking);
  Future<void> update(BookingModel booking);
  Future<void> delete(String id);
}
