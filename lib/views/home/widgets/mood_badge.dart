import 'package:flutter/material.dart';
import 'package:taskmaster/utils/app_colors.dart';
import 'package:taskmaster/models/models.dart';

class MoodBadge extends StatelessWidget {
  final UserMood mood;
  final bool isDarkMode;

  const MoodBadge({super.key, required this.mood, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String label;

    switch (mood) {
      case UserMood.productive:
        icon = Icons.bolt;
        color = AppColors.primary;
        label = 'Focus';
        break;
      case UserMood.tired:
        icon = Icons.battery_2_bar;
        color = Colors.orange;
        label = 'Fatigué';
        break;
      case UserMood.creative:
        icon = Icons.palette_outlined;
        color = Colors.purpleAccent;
        label = 'Créatif';
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
