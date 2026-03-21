import 'app_theme.dart';

/// User Profile model for the settings and dashboard.
class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final AppTheme themePreference;
  final bool googleCalendarIntegrated;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    this.themePreference = AppTheme.light,
    this.googleCalendarIntegrated = false,
  });
}
