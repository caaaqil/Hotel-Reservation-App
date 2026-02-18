import 'package:get/get.dart';
import '../../domain/models/room_model.dart';
import '../../domain/repositories/room_repository.dart';

class RoomController extends GetxController {
  final RoomRepository _roomRepository;

  RoomController(this._roomRepository);

  final RxList<RoomModel> rooms = <RoomModel>[].obs;
  final Rx<RoomModel?> selectedRoom = Rx<RoomModel?>(null);
  final RxBool isLoading = false.obs;
  
  // Search and Filter
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;

  List<RoomModel> get filteredRooms {
    return rooms.where((room) {
      final matchesSearch = room.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          room.type.toLowerCase().contains(searchQuery.value.toLowerCase());
      
      final matchesCategory = selectedCategory.value == 'All' || room.type == selectedCategory.value;
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  // Categories derived from rooms
  List<String> get categories {
    final types = rooms.map((r) => r.type).toSet().toList();
    return ['All', ...types];
  }

  @override
  void onInit() {
    super.onInit();
    loadRooms();
  }

  /// Load all rooms
  Future<void> loadRooms() async {
    try {
      isLoading.value = true;
      final allRooms = await _roomRepository.getAll();
      rooms.value = allRooms;
    } finally {
      isLoading.value = false;
    }
  }

  /// Get room by ID
  Future<RoomModel?> getRoomById(String id) async {
    try {
      return await _roomRepository.getById(id);
    } catch (e) {
      return null;
    }
  }

  /// Select a room
  void selectRoom(RoomModel room) {
    selectedRoom.value = room;
  }

  /// Create a new room
  Future<bool> createRoom(RoomModel room) async {
    try {
      isLoading.value = true;
      await _roomRepository.create(room);
      await loadRooms();
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update a room
  Future<bool> updateRoom(RoomModel room) async {
    try {
      isLoading.value = true;
      await _roomRepository.update(room);
      await loadRooms();
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a room
  Future<bool> deleteRoom(String id) async {
    try {
      isLoading.value = true;
      await _roomRepository.delete(id);
      await loadRooms();
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Filter rooms by type
  List<RoomModel> filterByType(String type) {
    return rooms.where((room) => room.type == type).toList();
  }

  /// Search rooms by name
  List<RoomModel> searchByName(String query) {
    return rooms
        .where((room) =>
            room.name.toLowerCase().contains(query.toLowerCase()) ||
            room.type.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
