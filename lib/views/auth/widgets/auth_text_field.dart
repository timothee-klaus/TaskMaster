import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/viewmodels/settings_viewmodel.dart';
import 'package:taskmaster/utils/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;

  const AuthTextField(
    this.controller, {
    required this.label,
    required this.icon,
    this.obscure = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settingsVM = context.watch<SettingsViewModel>();
    final isDarkMode = settingsVM.isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: AppColors.getTextPrimary(isDarkMode)),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primary),
          hintText: label,
          hintStyle: TextStyle(
            color: AppColors.getTextSecondary(isDarkMode).withOpacity(0.5),
          ),
          filled: true,
          fillColor: isDarkMode
              ? AppColors.darkBackground
              : Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: isDarkMode ? AppColors.darkBorder : Colors.grey.shade300,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: isDarkMode ? AppColors.darkBorder : Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
