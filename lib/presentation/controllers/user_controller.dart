import 'package:get/get.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class UserController extends GetxController {
  final UserRepository _userRepository;

  UserController(this._userRepository);

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  /// Load all users
  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      final allUsers = await _userRepository.getAll();
      users.value = allUsers;
    } finally {
      isLoading.value = false;
    }
  }

  /// Get user by ID
  Future<UserModel?> getUserById(String id) async {
    try {
      return await _userRepository.getById(id);
    } catch (e) {
      return null;
    }
  }

  /// Filter users by role
  List<UserModel> filterByRole(String role) {
    return users.where((user) => user.role == role).toList();
  }

  /// Get customers only
  List<UserModel> get customers =>
      users.where((user) => user.role == 'customer').toList();

  /// Get owners only
  List<UserModel> get owners =>
      users.where((user) => user.role == 'owner').toList();

  /// Get admins only
  List<UserModel> get admins =>
      users.where((user) => user.role == 'admin').toList();
}
