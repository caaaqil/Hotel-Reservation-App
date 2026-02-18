import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../../core/utils/constants.dart';

class AuthController extends GetxController {
  final UserRepository _userRepository;

  AuthController(this._userRepository);

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
  }

  /// Load current user from settings
  Future<void> _loadCurrentUser() async {
    try {
      isLoading.value = true;
      final settingsBox = Hive.box(AppConstants.settingsBox);
      final userId = settingsBox.get(AppConstants.currentUserIdKey);

      if (userId != null) {
        final user = await _userRepository.getById(userId);
        currentUser.value = user;
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Login with selected user
  Future<void> login(UserModel user) async {
    try {
      isLoading.value = true;
      currentUser.value = user;

      // Save user ID to settings
      final settingsBox = Hive.box(AppConstants.settingsBox);
      await settingsBox.put(AppConstants.currentUserIdKey, user.id);
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      isLoading.value = true;
      currentUser.value = null;

      // Remove user ID from settings
      final settingsBox = Hive.box(AppConstants.settingsBox);
      await settingsBox.delete(AppConstants.currentUserIdKey);
    } finally {
      isLoading.value = false;
    }
  }

  /// Check if user is logged in
  bool get isLoggedIn => currentUser.value != null;

  /// Get current user role
  String? get userRole => currentUser.value?.role;

  /// Check if user is customer
  bool get isCustomer => userRole == AppConstants.roleCustomer;

  /// Check if user is owner
  bool get isOwner => userRole == AppConstants.roleOwner;

  /// Check if user is admin
  bool get isAdmin => userRole == AppConstants.roleAdmin;
}
