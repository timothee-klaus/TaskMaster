import 'package:flutter/material.dart';
import 'package:taskmaster/utils/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final bool isDarkMode;

  const HomeHeader({
    super.key,
    required this.name,
    this.avatarUrl,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl!)
                  : const NetworkImage(
                      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80',
                    ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour,',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.getTextSecondary(isDarkMode),
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.getTextPrimary(isDarkMode),
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkSurface : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDarkMode ? AppColors.darkBorder : Colors.grey.shade200,
            ),
          ),
          child: Icon(
            Icons.notifications_none,
            color: AppColors.getTextSecondary(isDarkMode),
          ),
        ),
      ],
    );
  }
}
