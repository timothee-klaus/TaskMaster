import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/viewmodels/task_viewmodel.dart';
import 'package:taskmaster/viewmodels/settings_viewmodel.dart';
import 'package:taskmaster/models/models.dart';
import 'package:taskmaster/utils/app_colors.dart';

import 'package:taskmaster/views/home/widgets/mood_selector_bottom_sheet.dart';
import 'package:taskmaster/views/home/widgets/home_header.dart';
import 'package:taskmaster/views/home/widgets/ai_promo_banner.dart';
import 'package:taskmaster/views/home/widgets/stat_card.dart';
import 'package:taskmaster/views/home/widgets/mood_badge.dart';
import 'package:taskmaster/views/home/widgets/home_task_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final taskVM = context.read<TaskViewModel>();
      final settingsVM = context.read<SettingsViewModel>();
      if (taskVM.shouldPromptMood()) {
        MoodSelectorBottomSheet.show(context, settingsVM.isDarkMode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskVM = context.watch<TaskViewModel>();
    final settingsVM = context.watch<SettingsViewModel>();
    final profile = settingsVM.profile;
    final isDarkMode = settingsVM.isDarkMode;

    final completedCount = taskVM.allTasks
        .where((t) => t.status == TaskStatus.completed)
        .length;
    final pendingCount = taskVM.pendingTasks.length;
    final upcomingTasks = taskVM.pendingTasks.take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.getBackground(isDarkMode),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                name: profile?.fullName?.split(' ').first ?? 'Utilisateur',
                avatarUrl: profile?.avatarUrl,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 24),
              const AiPromoBanner(),
              const SizedBox(height: 32),
              Text(
                'Tâches du jour',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(isDarkMode),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Complétées',
                      count: '$completedCount',
                      icon: Icons.check_circle,
                      iconColor: AppColors.success,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: 'En attente',
                      count: '$pendingCount',
                      icon: Icons.more_horiz,
                      iconColor: AppColors.warning,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'Prochaines échéances',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextPrimary(isDarkMode),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (taskVM.currentMood != UserMood.none) ...[
                          const SizedBox(width: 8),
                          MoodBadge(
                            mood: taskVM.currentMood,
                            isDarkMode: isDarkMode,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Voir tout',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.info,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (upcomingTasks.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      'Aucune tâche prévue',
                      style: TextStyle(
                        color: AppColors.getTextSecondary(isDarkMode),
                      ),
                    ),
                  ),
                )
              else
                ...upcomingTasks.map(
                  (task) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: HomeTaskItem(task: task, isDarkMode: isDarkMode),
                  ),
                ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
