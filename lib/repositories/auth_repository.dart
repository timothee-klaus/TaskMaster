import 'package:taskmaster/services/auth_service.dart';
import 'package:taskmaster/repositories/user_repository.dart';
import 'package:taskmaster/models/models.dart';

/// Repository that handles the global authentication flow
/// and coordinates between AuthService and UserRepository.
class AuthRepository {
  final AuthService _authService;
  final UserRepository _userRepository;

  // Use a simple state for local dummy auth
  bool _isAuthenticated = false;

  AuthRepository(this._authService, this._userRepository);

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      if (response.containsKey('token')) {
        _isAuthenticated = true;
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await _authService.register(name, email, password);
      if (response.containsKey('token')) {
        // Save minimal user profile in Isar database
        final profile = UserProfile()
          ..fullName = name
          ..email = email;
        await _userRepository.saveUserProfile(profile);
        _isAuthenticated = true;
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    // Simulate clearing secure storage and session
    await Future.delayed(const Duration(milliseconds: 300));
    _isAuthenticated = false;
  }
}
