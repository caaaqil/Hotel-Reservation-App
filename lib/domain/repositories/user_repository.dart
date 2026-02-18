import '../models/user_model.dart';

/// Abstract repository interface for User operations
/// This allows easy swapping between local and remote data sources
abstract class UserRepository {
  Future<List<UserModel>> getAll();
  Future<UserModel?> getById(String id);
  Future<UserModel?> getByRole(String role);
  Future<void> create(UserModel user);
  Future<void> update(UserModel user);
  Future<void> delete(String id);
}
