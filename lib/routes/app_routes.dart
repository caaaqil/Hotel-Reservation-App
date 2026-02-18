class AppRoutes {
  // Auth routes
  static const String splash = '/';
  static const String login = '/login';

  // Customer routes
  static const String customerRooms = '/customer/rooms';
  static const String roomDetails = '/customer/room-details';
  static const String bookingCalendar = '/customer/booking-calendar';
  static const String myBookings = '/customer/my-bookings';

  // Owner routes
  static const String ownerDashboard = '/owner/dashboard';
  static const String manageRooms = '/owner/manage-rooms';
  static const String manageUsers = '/owner/manage-users';
  static const String manageBookings = '/owner/manage-bookings';

  // Admin routes
  static const String adminDashboard = '/admin/dashboard';
}
