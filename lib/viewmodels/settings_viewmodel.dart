import 'package:flutter/material.dart';
import 'package:taskmaster/models/models.dart';
import 'package:taskmaster/repositories/user_repository.dart';
import 'package:taskmaster/services/api/google_calendar_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  final GoogleCalendarService _googleCalendarService;

  UserProfile? _profile;
  bool _isLoading = true;

  SettingsViewModel(this._userRepository, this._googleCalendarService) {
    _loadProfile();
  }

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _profile?.themePreference == AppTheme.dark;

  Future<void> refreshProfile() async {
    await _loadProfile();
  }

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

    try {
      if (isLinked) {
        final success = await _googleCalendarService.signIn();
        if (!success) {
          // Si l'auth échoue, on force l'état à false et on notifie
          _profile!.googleCalendarIntegrated = false;
          await _userRepository.saveUserProfile(_profile!);
          notifyListeners();
          return;
        }
      } else {
        await _googleCalendarService.signOut();
      }

      _profile!.googleCalendarIntegrated = isLinked;
      await _userRepository.saveUserProfile(_profile!);
      notifyListeners();
    } catch (e) {
      print('Erreur lors du toggle Google Calendar: $e');
      _profile!.googleCalendarIntegrated = false;
      await _userRepository.saveUserProfile(_profile!);
      notifyListeners();
    }
  }

  Future<void> toggleGoogleSync(bool enabled) async {
    if (_profile == null) return;
    _profile!.googleSyncEnabled = enabled;
    await _userRepository.saveUserProfile(_profile!);
    notifyListeners();
  }
}
