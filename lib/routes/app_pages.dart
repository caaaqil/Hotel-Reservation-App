import 'package:get/get.dart';
import '../presentation/pages/splash_screen.dart';
import '../presentation/pages/auth/login_screen.dart';
import '../presentation/pages/customer/rooms_list_screen.dart';
import '../presentation/pages/customer/room_details_screen.dart';
import '../presentation/pages/customer/booking_calendar_screen.dart';
import '../presentation/pages/customer/my_bookings_screen.dart';
import '../presentation/pages/owner/owner_dashboard_screen.dart';
import '../presentation/pages/owner/manage_rooms_screen.dart';
import '../presentation/pages/owner/manage_users_screen.dart';
import '../presentation/pages/owner/manage_bookings_screen.dart';
import '../presentation/pages/admin/admin_dashboard_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.customerRooms,
      page: () => const RoomsListScreen(),
    ),
    GetPage(
      name: AppRoutes.roomDetails,
      page: () => const RoomDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.bookingCalendar,
      page: () => const BookingCalendarScreen(),
    ),
    GetPage(
      name: AppRoutes.myBookings,
      page: () => const MyBookingsScreen(),
    ),
    GetPage(
      name: AppRoutes.ownerDashboard,
      page: () => const OwnerDashboardScreen(),
    ),
    GetPage(
      name: AppRoutes.manageRooms,
      page: () => const ManageRoomsScreen(),
    ),
    GetPage(
      name: AppRoutes.manageUsers,
      page: () => const ManageUsersScreen(),
    ),
    GetPage(
      name: AppRoutes.manageBookings,
      page: () => const ManageBookingsScreen(),
    ),
    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => const AdminDashboardScreen(),
    ),
  ];
}
