import 'package:hive/hive.dart';
import '../../core/utils/constants.dart';
import '../../domain/models/room_model.dart';
import '../../domain/repositories/room_repository.dart';

/// Local implementation of RoomRepository using Hive
class LocalRoomRepository implements RoomRepository {
  static const String _boxName = 'rooms';

  Box<RoomModel> get _box => Hive.box<RoomModel>(_boxName);

  @override
  Future<List<RoomModel>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<RoomModel?> getById(String id) async {
    return _box.get(id);
  }

  @override
  Future<void> create(RoomModel room) async {
    await _box.put(room.id, room);
  }

  @override
  Future<void> update(RoomModel room) async {
    await _box.put(room.id, room);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
