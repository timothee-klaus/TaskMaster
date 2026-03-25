import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/models/models.dart';
import 'package:taskmaster/viewmodels/task_viewmodel.dart';
import 'package:taskmaster/utils/app_colors.dart';

class MoodSelectorBottomSheet extends StatelessWidget {
  final bool isDarkMode;
  const MoodSelectorBottomSheet({super.key, required this.isDarkMode});

  static void show(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MoodSelectorBottomSheet(isDarkMode: isDarkMode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.getBackground(isDarkMode),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.getTextSecondary(
                    isDarkMode,
                  ).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'État d\'esprit',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.getTextPrimary(isDarkMode),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),
            _buildMoodCard(
              context,
              title: 'Productif & Focus',
              description: 'Privilégier les tâches complexes',
              icon: Icons.bolt,
              mood: UserMood.productive,
            ),
            _buildMoodCard(
              context,
              title: 'Fatigué',
              description: 'Tâches administratives simples',
              icon: Icons.battery_2_bar,
              mood: UserMood.tired,
            ),
            _buildMoodCard(
              context,
              title: 'Créatif',
              description: 'Tâches flexibles sans contrainte de temps',
              icon: Icons.palette_outlined,
              mood: UserMood.creative,
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {
                  final taskVM = context.read<TaskViewModel>();
                  taskVM.setMood(UserMood.none);
                  Navigator.pop(context);
                },
                child: Text(
                  'Passer',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.getTextSecondary(isDarkMode),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required UserMood mood,
  }) {
    return InkWell(
      onTap: () {
        final taskVM = context.read<TaskViewModel>();
        taskVM.setMood(mood);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.getTextSecondary(
                isDarkMode,
              ).withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.getTextSecondary(isDarkMode), size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getTextPrimary(isDarkMode),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.getTextSecondary(isDarkMode),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
