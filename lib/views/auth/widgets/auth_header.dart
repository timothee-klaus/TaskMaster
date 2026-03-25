import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/viewmodels/settings_viewmodel.dart';
import 'package:taskmaster/utils/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String caption;

  const AuthHeader({
    required this.title,
    required this.subtitle,
    required this.caption,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settingsVM = context.watch<SettingsViewModel>();
    final isDarkMode = settingsVM.isDarkMode;

    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimary(isDarkMode),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          caption,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.getTextSecondary(isDarkMode),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
