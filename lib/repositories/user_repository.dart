import 'package:isar/isar.dart';
import 'package:taskmaster/models/models.dart';
import 'package:taskmaster/services/isar_service.dart';

/// Repository handling all UserProfile database operations
class UserRepository {
  final IsarService _isarService;

  UserRepository(this._isarService);

  Future<void> saveUserProfile(UserProfile profile) async {
    final isar = await _isarService.db;
    await isar.writeTxn(() async {
      await isar.userProfiles.put(profile);
    });
  }

  Future<UserProfile?> getUserProfile() async {
    final isar = await _isarService.db;
    return await isar.userProfiles.where().findFirst();
  }
}
