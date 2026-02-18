import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'data/local_db/hive_service.dart';
import 'data/repositories/local_user_repository.dart';
import 'data/repositories/local_room_repository.dart';
import 'data/repositories/local_booking_repository.dart';
import 'domain/services/availability_service.dart';
import 'domain/services/booking_service.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/room_controller.dart';
import 'presentation/controllers/booking_controller.dart';
import 'presentation/controllers/user_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final hiveService = HiveService();
  await hiveService.init();

  // Initialize repositories
  final userRepository = LocalUserRepository();
  final roomRepository = LocalRoomRepository();
  final bookingRepository = LocalBookingRepository();

  // Initialize services
  final availabilityService = AvailabilityService(bookingRepository, roomRepository);
  final bookingService = BookingService(bookingRepository, availabilityService);

  // Initialize controllers with GetX dependency injection
  Get.put(AuthController(userRepository));
  Get.put(RoomController(roomRepository));
  Get.put(BookingController(bookingService, availabilityService));
  Get.put(UserController(userRepository));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Hotel Reservation',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
