import 'package:hive/hive.dart';
import '../../core/utils/constants.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

/// Local implementation of UserRepository using Hive
class LocalUserRepository implements UserRepository {
  static const String _boxName = 'users';

  Box<UserModel> get _box => Hive.box<UserModel>(_boxName);

  @override
  Future<List<UserModel>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<UserModel?> getById(String id) async {
    return _box.values.firstWhere(
      (user) => user.id == id,
      orElse: () => UserModel(id: '', name: '', email: '', role: ''),
    ).id.isEmpty
        ? null
        : _box.values.firstWhere((user) => user.id == id);
  }

  @override
  Future<UserModel?> getByRole(String role) async {
    try {
      return _box.values.firstWhere((user) => user.role == role);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> create(UserModel user) async {
    await _box.put(user.id, user);
  }

  @override
  Future<void> update(UserModel user) async {
    await _box.put(user.id, user);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
