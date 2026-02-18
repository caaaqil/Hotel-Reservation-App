class AppConstants {
  // User roles
  static const String roleCustomer = 'customer';
  static const String roleOwner = 'owner';
  static const String roleAdmin = 'admin';

  // Booking status
  static const String statusConfirmed = 'confirmed';
  static const String statusCancelled = 'cancelled';

  // Hive box names
  static const String usersBox = 'users';
  static const String roomsBox = 'rooms';
  static const String bookingsBox = 'bookings';
  static const String settingsBox = 'settings';

  // Settings keys
  static const String currentUserIdKey = 'current_user_id';
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String hasSeenIntroKey = 'has_seen_intro';

  // App info
  static const String appName = 'Roomly';
  static const String appVersion = '1.0.0';
}
