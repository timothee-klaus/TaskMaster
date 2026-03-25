import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:taskmaster/models/models.dart';
import 'package:taskmaster/utils/app_colors.dart';

class HomeTaskItem extends StatelessWidget {
  final Task task;
  final bool isDarkMode;

  const HomeTaskItem({super.key, required this.task, required this.isDarkMode});

  Color _getPriorityColor(TaskPriority priority, bool isText) {
    switch (priority) {
      case TaskPriority.high:
        return isText ? const Color(0xFFD92D20) : const Color(0xFFFEE4E2);
      case TaskPriority.medium:
        return isText ? const Color(0xFFDC6803) : const Color(0xFFFEF0C7);
      case TaskPriority.low:
        return isText ? const Color(0xFF039855) : const Color(0xFFD1FADF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/task-details', extra: task),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDarkMode ? AppColors.darkBorder : Colors.grey.shade100,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkBackground
                    : const Color(0xFFEEF2F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.description_outlined,
                color: AppColors.secondary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title ?? 'Sans titre',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.getTextPrimary(isDarkMode),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.dueDate != null
                        ? DateFormat('dd MMM, HH:mm').format(task.dueDate!)
                        : 'Pas de date',
                    style: TextStyle(
                      color: AppColors.getTextSecondary(isDarkMode),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _getPriorityColor(task.priority, false),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                task.priority.name.toUpperCase(),
                style: TextStyle(
                  color: _getPriorityColor(task.priority, true),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
