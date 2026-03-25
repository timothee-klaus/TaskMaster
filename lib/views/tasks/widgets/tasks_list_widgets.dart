import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmaster/models/models.dart';
import 'package:taskmaster/utils/app_colors.dart';
import 'package:taskmaster/viewmodels/task_viewmodel.dart';
import 'package:go_router/go_router.dart';

class TasksListEmptyState extends StatelessWidget {
  final bool isDarkMode;
  const TasksListEmptyState({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkSurface
                          : const Color(0xFFFFF1F2),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 15,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.yellow.shade900.withValues(alpha: 0.5)
                            : Colors.yellow.shade200,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 15,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.primary.withValues(alpha: 0.2)
                            : const Color(0xFFFFD4CE),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.assignment_late_outlined,
                    size: 80,
                    color: isDarkMode
                        ? AppColors.primary.withValues(alpha: 0.5)
                        : const Color(0xFFFF998E),
                  ),
                  Positioned(
                    top: 55,
                    right: 55,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.getSurface(isDarkMode),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_circle_outline,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Aucune tâche pour le moment.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.getTextPrimary(isDarkMode),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Commencez par organiser votre journée en\najoutant une nouvelle tâche. Tout commence\npar un petit pas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.getTextSecondary(isDarkMode),
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => context.push('/create-task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                label: const Text(
                  'Créer une tâche',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TasksListHeader extends StatelessWidget {
  final UserMood currentMood;
  final bool isDarkMode;

  const TasksListHeader({
    super.key,
    required this.currentMood,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.primary.withValues(alpha: 0.1)
                : const Color(0xFFFDECEE),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.menu, color: AppColors.primary, size: 24),
        ),
        Row(
          children: [
            Text(
              'TaskMaster',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.getTextPrimary(isDarkMode),
              ),
            ),
            if (currentMood != UserMood.none) ...[
              const SizedBox(width: 8),
              _buildMoodBadge(currentMood, isDarkMode),
            ],
          ],
        ),
        Icon(
          Icons.filter_list,
          color: AppColors.getTextPrimary(isDarkMode),
          size: 28,
        ),
      ],
    );
  }

  Widget _buildMoodBadge(UserMood mood, bool isDarkMode) {
    String label = '';
    Color color = Colors.grey;
    switch (mood) {
      case UserMood.productive:
        label = 'Productif';
        color = const Color(0xFF039855);
        break;
      case UserMood.creative:
        label = 'Créatif';
        color = Colors.purple;
        break;
      case UserMood.tired:
        label = 'Fatigué';
        color = Colors.orange;
        break;
      case UserMood.none:
        break;
    }

    if (mood == UserMood.none) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class TasksSearchField extends StatelessWidget {
  final bool isDarkMode;
  const TasksSearchField({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        style: TextStyle(color: AppColors.getTextPrimary(isDarkMode)),
        decoration: InputDecoration(
          hintText: 'Rechercher une tâche...',
          hintStyle: TextStyle(
            color: AppColors.getTextSecondary(
              isDarkMode,
            ).withValues(alpha: 0.5),
          ),
          icon: Icon(
            Icons.search,
            color: AppColors.getTextSecondary(isDarkMode),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class TasksSegmentControl extends StatelessWidget {
  final bool isDarkMode;
  const TasksSegmentControl({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkBackground : Colors.white,
                borderRadius: BorderRadius.circular(26),
                boxShadow: isDarkMode
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: const Center(
                child: Text(
                  'Jour',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          _buildSegmentItem('Semaine', isDarkMode),
          _buildSegmentItem('Mois', isDarkMode),
        ],
      ),
    );
  }

  Widget _buildSegmentItem(String label, bool isDarkMode) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.getTextSecondary(isDarkMode),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final bool isDarkMode;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = task.title ?? 'Sans titre';
    final timeRaw = task.dueDate != null
        ? DateFormat('HH:mm a').format(task.dueDate!)
        : 'Non défini';
    final dateRaw = task.dueDate != null
        ? DateFormat('dd MMM').format(task.dueDate!)
        : '';

    Color chipColor;
    Color chipTextColor;
    switch (task.priority) {
      case TaskPriority.high:
        chipColor = const Color(0xFFFDECEE);
        chipTextColor = const Color(0xFFFF5A4A);
        break;
      case TaskPriority.medium:
        chipColor = const Color(0xFFFEF0C7);
        chipTextColor = const Color(0xFFDC6803);
        break;
      case TaskPriority.low:
        chipColor = const Color(0xFFD1FADF);
        chipTextColor = const Color(0xFF039855);
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.getSurface(isDarkMode),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.getBorder(isDarkMode),
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: chipColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          task.priority.name.toUpperCase(),
                          style: TextStyle(
                            color: chipTextColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        timeRaw,
                        style: TextStyle(
                          color: AppColors.getTextSecondary(isDarkMode),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.getTextPrimary(isDarkMode),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: AppColors.getTextSecondary(isDarkMode),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        dateRaw,
                        style: TextStyle(
                          color: AppColors.getTextSecondary(isDarkMode),
                          fontSize: 13,
                        ),
                      ),
                    ],
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

class CompletedTaskItem extends StatelessWidget {
  final Task task;
  final TaskViewModel vm;
  final bool isDarkMode;

  const CompletedTaskItem({
    super.key,
    required this.task,
    required this.vm,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkSurface.withValues(alpha: 0.5)
            : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 24,
            ),
            onPressed: () => vm.toggleTaskCompletion(task),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task.title ?? 'Sans titre',
              style: TextStyle(
                color: AppColors.getTextSecondary(isDarkMode),
                fontSize: 14,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
