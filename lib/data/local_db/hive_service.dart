import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/room_model.dart';
import '../../domain/models/booking_model.dart';
import '../../core/utils/constants.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  final _uuid = const Uuid();

  /// Initialize Hive and register adapters
  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(RoomModelAdapter());
    Hive.registerAdapter(BookingModelAdapter());

    // Open boxes
    await Hive.openBox<UserModel>(AppConstants.usersBox);
    await Hive.openBox<RoomModel>(AppConstants.roomsBox);
    await Hive.openBox<BookingModel>(AppConstants.bookingsBox);
    await Hive.openBox(AppConstants.settingsBox);

    // Seed data on first launch
    await _seedDataIfNeeded();
  }

  /// Seed initial data if this is the first launch
  Future<void> _seedDataIfNeeded() async {
    final settingsBox = Hive.box(AppConstants.settingsBox);
    final isFirstLaunch =
        settingsBox.get(AppConstants.isFirstLaunchKey, defaultValue: true);

    if (isFirstLaunch) {
      await _seedUsers();
      await _seedRooms();
      await _seedBookings();
      await settingsBox.put(AppConstants.isFirstLaunchKey, false);
    }
  }

  /// Seed initial users (one for each role)
  Future<void> _seedUsers() async {
    final usersBox = Hive.box<UserModel>(AppConstants.usersBox);

    final users = [
      UserModel(
        id: 'user_customer_1',
        name: 'John Doe',
        email: 'john@customer.com',
        role: AppConstants.roleCustomer,
      ),
      UserModel(
        id: 'user_owner_1',
        name: 'Sarah Smith',
        email: 'sarah@owner.com',
        role: AppConstants.roleOwner,
      ),
      UserModel(
        id: 'user_admin_1',
        name: 'Admin User',
        email: 'admin@hotel.com',
        role: AppConstants.roleAdmin,
      ),
    ];

    for (var user in users) {
      await usersBox.put(user.id, user);
    }
  }

  /// Seed initial rooms
  Future<void> _seedRooms() async {
    final roomsBox = Hive.box<RoomModel>(AppConstants.roomsBox);

    final rooms = [
      RoomModel(
        id: 'room_1',
        name: 'Deluxe Ocean View',
        type: 'Deluxe',
        price: 150.0,
        totalRooms: 5,
        features: ['WiFi', 'Ocean View', 'King Bed', 'Mini Bar', 'AC'],
        images: ['https://via.placeholder.com/400x300?text=Deluxe+Ocean+View'],
        description:
            'Luxurious room with stunning ocean views. Perfect for couples seeking a romantic getaway.',
      ),
      RoomModel(
        id: 'room_2',
        name: 'Standard Double',
        type: 'Standard',
        price: 80.0,
        totalRooms: 10,
        features: ['WiFi', 'Double Bed', 'TV', 'AC'],
        images: ['https://via.placeholder.com/400x300?text=Standard+Double'],
        description:
            'Comfortable standard room with all essential amenities. Great value for money.',
      ),
      RoomModel(
        id: 'room_3',
        name: 'Family Suite',
        type: 'Suite',
        price: 200.0,
        totalRooms: 3,
        features: [
          'WiFi',
          '2 Bedrooms',
          'Kitchen',
          'Living Room',
          'Balcony',
          'AC'
        ],
        images: ['https://via.placeholder.com/400x300?text=Family+Suite'],
        description:
            'Spacious suite perfect for families. Includes separate bedrooms and a full kitchen.',
      ),
      RoomModel(
        id: 'room_4',
        name: 'Executive Room',
        type: 'Executive',
        price: 120.0,
        totalRooms: 7,
        features: ['WiFi', 'Work Desk', 'King Bed', 'Coffee Maker', 'AC', 'TV'],
        images: ['https://via.placeholder.com/400x300?text=Executive+Room'],
        description:
            'Ideal for business travelers. Features a dedicated workspace and premium amenities.',
      ),
      RoomModel(
        id: 'room_5',
        name: 'Penthouse Suite',
        type: 'Penthouse',
        price: 350.0,
        totalRooms: 2,
        features: [
          'WiFi',
          'Jacuzzi',
          'City View',
          'King Bed',
          'Mini Bar',
          'AC',
          'Smart TV'
        ],
        images: ['https://via.placeholder.com/400x300?text=Penthouse+Suite'],
        description:
            'Ultimate luxury experience with panoramic city views and exclusive amenities.',
      ),
    ];

    for (var room in rooms) {
      await roomsBox.put(room.id, room);
    }
  }

  /// Seed some initial bookings for demonstration
  Future<void> _seedBookings() async {
    final bookingsBox = Hive.box<BookingModel>(AppConstants.bookingsBox);

    final now = DateTime.now();
    final bookings = [
      BookingModel(
        id: 'booking_1',
        userId: 'user_customer_1',
        roomId: 'room_1',
        checkIn: DateTime(now.year, now.month, now.day + 5),
        checkOut: DateTime(now.year, now.month, now.day + 8),
        nights: 3,
        totalPrice: 450.0,
        status: AppConstants.statusConfirmed,
      ),
      BookingModel(
        id: 'booking_2',
        userId: 'user_customer_1',
        roomId: 'room_2',
        checkIn: DateTime(now.year, now.month, now.day + 10),
        checkOut: DateTime(now.year, now.month, now.day + 12),
        nights: 2,
        totalPrice: 160.0,
        status: AppConstants.statusConfirmed,
      ),
    ];

    for (var booking in bookings) {
      await bookingsBox.put(booking.id, booking);
    }
  }

  /// Generate a unique ID
  String generateId() => _uuid.v4();

  /// Clear all data (for testing purposes)
  Future<void> clearAllData() async {
    await Hive.box<UserModel>(AppConstants.usersBox).clear();
    await Hive.box<RoomModel>(AppConstants.roomsBox).clear();
    await Hive.box<BookingModel>(AppConstants.bookingsBox).clear();
    await Hive.box(AppConstants.settingsBox).clear();
  }

  /// Close all boxes
  Future<void> close() async {
    await Hive.close();
  }
}
