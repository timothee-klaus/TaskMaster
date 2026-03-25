import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/viewmodels/settings_viewmodel.dart';
import 'package:taskmaster/utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final settingsVM = context.watch<SettingsViewModel>();
    final isDarkMode = settingsVM.isDarkMode;

    return AppBar(
      backgroundColor: AppColors.getBackground(isDarkMode),
      elevation: 0,
      centerTitle: false,
      leading: Icon(Icons.checklist_rtl, color: AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.getTextPrimary(isDarkMode),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: isDarkMode ? AppColors.darkBorder : Colors.grey.shade100,
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
