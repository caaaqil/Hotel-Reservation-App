import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/room_controller.dart';
import '../../controllers/booking_controller.dart';
import '../../../domain/models/room_model.dart';
import '../../../data/local_db/hive_service.dart';
import '../../../core/utils/app_colors.dart';

class ManageRoomsScreen extends StatefulWidget {
  const ManageRoomsScreen({super.key});

  @override
  State<ManageRoomsScreen> createState() => _ManageRoomsScreenState();
}

class _ManageRoomsScreenState extends State<ManageRoomsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roomController = Get.find<RoomController>();
    final bookingController = Get.find<BookingController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Manage Rooms',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'All Rooms'),
            Tab(text: 'Occupied'),
            Tab(text: 'Vacant'),
          ],
        ),
      ),
      body: Obx(() {
        if (roomController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return TabBarView(
          controller: _tabController,
          children: [
            _buildRoomsList(roomController.rooms, bookingController),
            _buildRoomsList(roomController.rooms.where((r) => _isOccupied(r.id, bookingController)).toList(), bookingController),
            _buildRoomsList(roomController.rooms.where((r) => !_isOccupied(r.id, bookingController)).toList(), bookingController),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRoomDialog(context, roomController),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  bool _isOccupied(String roomId, BookingController bookingController) {
    return bookingController.confirmedBookings.any((b) => 
      b.roomId == roomId && 
      b.checkIn.isBefore(DateTime.now()) && 
      b.checkOut.isAfter(DateTime.now())
    );
  }

  Widget _buildRoomsList(List<RoomModel> rooms, BookingController bookingController) {
    if (rooms.isEmpty) {
      return const Center(child: Text('No rooms found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        final isOccupied = _isOccupied(room.id, bookingController);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Room Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    room.images.isNotEmpty ? room.images.first : 'https://via.placeholder.com/80',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: AppColors.borderLight,
                        child: const Icon(Icons.hotel, color: AppColors.iconGrey),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Room Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              room.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: isOccupied ? AppColors.occupied : AppColors.vacant,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isOccupied ? 'OCCUPIED' : 'VACANT',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isOccupied ? AppColors.occupiedText : AppColors.vacantText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${room.type} • Floor ${(index % 8) + 1}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${room.price.toStringAsFixed(0)}/night',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                color: AppColors.iconGrey,
                                onPressed: () => _showAddRoomDialog(context, Get.find<RoomController>(), room: room),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20),
                                color: AppColors.iconGrey,
                                onPressed: () => _deleteRoom(Get.find<RoomController>(), room.id),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddRoomDialog(BuildContext context, RoomController controller, {RoomModel? room}) {
    final nameController = TextEditingController(text: room?.name ?? '');
    final typeController = TextEditingController(text: room?.type ?? '');
    final priceController = TextEditingController(text: room?.price.toString() ?? '');
    final totalRoomsController = TextEditingController(text: room?.totalRooms.toString() ?? '');
    final descriptionController = TextEditingController(text: room?.description ?? '');
    String? imageUrl = room?.images.isNotEmpty == true ? room!.images.first : null;
    
    List<String> selectedFeatures = room?.features ?? [];
    final availableFeatures = ['Free Wi-Fi', 'Air Conditioning', 'Smart TV', 'Sea View', 'King Size Bed', 'Kitchenette'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                        ),
                        Text(
                          room == null ? 'Add New Room' : 'Edit Room',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                          onPressed: () {
                            final newRoom = RoomModel(
                              id: room?.id ?? HiveService().generateId(),
                              name: nameController.text,
                              type: typeController.text,
                              price: double.tryParse(priceController.text) ?? 0,
                              totalRooms: int.tryParse(totalRoomsController.text) ?? 0,
                              description: descriptionController.text,
                              features: selectedFeatures,
                              images: imageUrl != null ? [imageUrl!] : ['https://via.placeholder.com/400x300'],
                            );
                            if (room == null) {
                              controller.createRoom(newRoom);
                            } else {
                              controller.updateRoom(newRoom);
                            }
                            Get.back();
                          },
                          child: const Text('Save', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Room Photos
                    const Text('ROOM PHOTOS', style: TextStyle(fontSize: 12, color: AppColors.textLight, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            imageUrl = image.path;
                          });
                        }
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary, width: 2, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.primary.withOpacity(0.05),
                        ),
                        child: imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(imageUrl!, fit: BoxFit.cover, width: double.infinity),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate, size: 48, color: AppColors.primary),
                                  const SizedBox(height: 8),
                                  const Text('Tap to upload photos', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 4),
                                  const Text('PNG, JPG up to 10MB', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Room Details
                    const Text('ROOM DETAILS', style: TextStyle(fontSize: 12, color: AppColors.textLight, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Room Name',
                        hintText: 'e.g. Deluxe Ocean Suite',
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Price per Night',
                              hintText: '\$ 0.00',
                              filled: true,
                              fillColor: AppColors.background,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: totalRoomsController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Total Units',
                              hintText: '1',
                              filled: true,
                              fillColor: AppColors.background,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Features & Amenities
                    const Text('FEATURES & AMENITIES', style: TextStyle(fontSize: 12, color: AppColors.textLight, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableFeatures.map((feature) {
                        final isSelected = selectedFeatures.contains(feature);
                        return FilterChip(
                          label: Text(feature),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedFeatures.add(feature);
                              } else {
                                selectedFeatures.remove(feature);
                              }
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    // Description
                    const Text('DESCRIPTION', style: TextStyle(fontSize: 12, color: AppColors.textLight, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Briefly describe the room\'s unique features...',
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          final newRoom = RoomModel(
                            id: room?.id ?? HiveService().generateId(),
                            name: nameController.text,
                            type: typeController.text.isEmpty ? 'Standard' : typeController.text,
                            price: double.tryParse(priceController.text) ?? 0,
                            totalRooms: int.tryParse(totalRoomsController.text) ?? 1,
                            description: descriptionController.text,
                            features: selectedFeatures,
                            images: imageUrl != null ? [imageUrl!] : ['https://via.placeholder.com/400x300'],
                          );
                          if (room == null) {
                            controller.createRoom(newRoom);
                          } else {
                            controller.updateRoom(newRoom);
                          }
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          elevation: 0,
                        ),
                        child: const Text('Save Room Listing', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteRoom(RoomController controller, String id) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Room'),
        content: const Text('Are you sure you want to delete this room?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await controller.deleteRoom(id);
      Get.snackbar('Success', 'Room deleted', backgroundColor: AppColors.success, colorText: Colors.white);
    }
  }
}
