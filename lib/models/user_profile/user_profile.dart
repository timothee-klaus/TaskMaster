import 'package:isar/isar.dart';
import '../enums/app_theme.dart';

part 'user_profile.g.dart';

@collection
class UserProfile {
  Id id = Isar.autoIncrement;

  String? fullName;
  String? email;
  String? avatarUrl;

  @enumerated
  AppTheme themePreference = AppTheme.light;

  bool googleCalendarIntegrated = false;
}
