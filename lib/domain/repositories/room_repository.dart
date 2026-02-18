import '../models/room_model.dart';

/// Abstract repository interface for Room operations
/// This allows easy swapping between local and remote data sources
abstract class RoomRepository {
  Future<List<RoomModel>> getAll();
  Future<RoomModel?> getById(String id);
  Future<void> create(RoomModel room);
  Future<void> update(RoomModel room);
  Future<void> delete(String id);
}
