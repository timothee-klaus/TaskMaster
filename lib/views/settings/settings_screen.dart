import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/viewmodels/settings_viewmodel.dart';
import 'package:taskmaster/viewmodels/auth_viewmodel.dart';
import 'package:taskmaster/utils/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settingsVM = context.watch<SettingsViewModel>();
    final authVM = context.read<AuthViewModel>();
    final profile = settingsVM.profile;

    final isDarkMode = settingsVM.isDarkMode;
    final isAutoSync = profile?.googleSyncEnabled ?? true;

    return Scaffold(
      backgroundColor: AppColors.getBackground(isDarkMode),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Paramètres',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.getTextPrimary(isDarkMode),
                      letterSpacing: -0.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkSurface
                          : AppColors.lightDivider,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.search,
                      color: AppColors.getTextSecondary(isDarkMode),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Profile Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.darkSurface
                      : const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.darkBorder
                        : const Color(0xFFFFE4E6),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: profile?.avatarUrl != null
                            ? NetworkImage(profile!.avatarUrl!)
                            : const NetworkImage(
                                'https://images.unsplash.com/photo-1560250097-0b93528c311a?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80',
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile?.fullName ?? 'Utilisateur Inconnu',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextPrimary(isDarkMode),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile?.email ?? 'Aucune adresse',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.getTextSecondary(isDarkMode),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.edit_outlined,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              _buildSectionTitle('APPARENCE', isDarkMode),
              _buildSwitchTile(
                icon: Icons.dark_mode_outlined,
                title: 'Thème Sombre',
                value: isDarkMode,
                onChanged: (val) {
                  settingsVM.toggleTheme(val);
                },
                isDarkMode: isDarkMode,
              ),

              const SizedBox(height: 16),
              _buildSectionTitle('INTÉGRATIONS', isDarkMode),
              _buildListTile(
                icon: Icons.calendar_today_outlined,
                title: 'Calendrier Google',
                onTap: () {
                  final isLinked = profile?.googleCalendarIntegrated ?? false;
                  settingsVM.toggleGoogleCalendar(!isLinked);
                },
                isDarkMode: isDarkMode,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      profile?.googleCalendarIntegrated == true
                          ? 'Connecté'
                          : 'Déconnecté',
                      style: TextStyle(
                        color: profile?.googleCalendarIntegrated == true
                            ? AppColors.success
                            : AppColors.getTextSecondary(isDarkMode),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.getTextSecondary(
                        isDarkMode,
                      ).withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              _buildSwitchTile(
                icon: Icons.sync,
                title: 'Synchronisation auto',
                value: isAutoSync,
                onChanged: (val) => settingsVM.toggleGoogleSync(val),
                isDarkMode: isDarkMode,
              ),

              const SizedBox(height: 16),
              _buildSectionTitle('PRÉFÉRENCES', isDarkMode),
              _buildListTile(
                icon: Icons.notifications_none,
                title: 'Notifications',
                isDarkMode: isDarkMode,
              ),
              _buildListTile(
                icon: Icons.lock_outline,
                title: 'Confidentialité',
                isDarkMode: isDarkMode,
              ),
              _buildListTile(
                icon: Icons.language,
                title: 'Langue',
                isDarkMode: isDarkMode,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Français',
                      style: TextStyle(
                        color: AppColors.getTextSecondary(isDarkMode),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.getTextSecondary(
                        isDarkMode,
                      ).withOpacity(0.5),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await authVM.logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? AppColors.darkSurface
                        : const Color(0xFFFFF1F2),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                      side: isDarkMode
                          ? const BorderSide(color: AppColors.error, width: 1)
                          : BorderSide.none,
                    ),
                  ),
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: const Text(
                    'Déconnexion',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              Center(
                child: Text(
                  'TaskMaster v2.4.0 • Fabriqué avec passion',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.getTextSecondary(isDarkMode),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.getTextSecondary(isDarkMode).withOpacity(0.7),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required bool isDarkMode,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextPrimary(isDarkMode),
                ),
              ),
            ),
            if (trailing != null)
              trailing
            else
              Icon(
                Icons.chevron_right,
                color: AppColors.getTextSecondary(isDarkMode).withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.getTextPrimary(isDarkMode),
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: isDarkMode
                ? Colors.grey.shade400
                : Colors.white,
            inactiveTrackColor: isDarkMode
                ? Colors.grey.shade800
                : Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
