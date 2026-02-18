import 'package:hive/hive.dart';
import '../../core/utils/constants.dart';
import '../../domain/models/booking_model.dart';
import '../../domain/repositories/booking_repository.dart';

/// Local implementation of BookingRepository using Hive
class LocalBookingRepository implements BookingRepository {
  static const String _boxName = 'bookings';

  Box<BookingModel> get _box => Hive.box<BookingModel>(_boxName);

  @override
  Future<List<BookingModel>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<BookingModel?> getById(String id) async {
    return _box.get(id);
  }

  @override
  Future<List<BookingModel>> getByUserId(String userId) async {
    return _box.values.where((booking) => booking.userId == userId).toList();
  }

  @override
  Future<List<BookingModel>> getByRoomId(String roomId) async {
    return _box.values.where((booking) => booking.roomId == roomId).toList();
  }

  @override
  Future<List<BookingModel>> getConfirmedBookingsInDateRange(
    String roomId,
    DateTime start,
    DateTime end,
  ) async {
    return _box.values
        .where((booking) =>
            booking.roomId == roomId &&
            booking.isConfirmed &&
            booking.overlaps(start, end))
        .toList();
  }

  @override
  Future<void> create(BookingModel booking) async {
    await _box.put(booking.id, booking);
  }

  @override
  Future<void> update(BookingModel booking) async {
    await _box.put(booking.id, booking);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
