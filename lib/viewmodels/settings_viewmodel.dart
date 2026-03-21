import 'package:flutter/material.dart';
import 'package:taskmaster/models/models.dart';
import 'package:taskmaster/repositories/user_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  final UserRepository _userRepository;

  UserProfile? _profile;
  bool _isLoading = true;

  SettingsViewModel(this._userRepository) {
    _loadProfile();
  }

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _profile?.themePreference == AppTheme.dark;

  Future<void> _loadProfile() async {
    _profile = await _userRepository.getUserProfile();

    // Si aucun profil, on en crée un générique
    if (_profile == null) {
      final defaultProfile = UserProfile()
        ..fullName = "Utilisateur"
        ..email = ""
        ..themePreference = AppTheme.light;
      await _userRepository.saveUserProfile(defaultProfile);
      _profile = defaultProfile;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleTheme(bool isDark) async {
    if (_profile == null) return;
    _profile!.themePreference = isDark ? AppTheme.dark : AppTheme.light;
    await _userRepository.saveUserProfile(_profile!);
    notifyListeners();
  }

  Future<void> toggleGoogleCalendar(bool isLinked) async {
    if (_profile == null) return;
    _profile!.googleCalendarIntegrated = isLinked;
    await _userRepository.saveUserProfile(_profile!);
    notifyListeners();
  }
}
