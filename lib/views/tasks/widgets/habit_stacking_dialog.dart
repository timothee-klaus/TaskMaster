import 'package:flutter/material.dart';
import 'package:taskmaster/models/models.dart';
import 'package:taskmaster/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/viewmodels/task_viewmodel.dart';

class HabitStackingDialog extends StatelessWidget {
  final Task completedTask;
  final bool isDarkMode;

  const HabitStackingDialog({
    super.key,
    required this.completedTask,
    required this.isDarkMode,
  });

  static void show(BuildContext context, Task task, bool isDarkMode) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'HabitDialog',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return HabitStackingDialog(completedTask: task, isDarkMode: isDarkMode);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.getBackground(isDarkMode),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 20,
              spreadRadius: -5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.self_improvement,
                color: AppColors.primary,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Habit Stacking',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.getTextPrimary(isDarkMode),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Félicitations pour avoir accompli « ${completedTask.title} » ! C\'est le moment cérébral idéal pour ancrer une nouvelle habitude positive.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.getTextSecondary(isDarkMode),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkSurface
                    : const Color(0xFFF3F6FA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.spa,
                      color: Colors.purpleAccent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '5 minutes de Méditation',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.getTextPrimary(isDarkMode),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Respiration libre et focus',
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
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _acceptHabit(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Accepter & Démarrer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Pas maintenant',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
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

  void _acceptHabit(BuildContext context) {
    // Cree une mini tâche completée pour donner de la satisfaction
    final taskVM = context.read<TaskViewModel>();

    final habitTask = Task()
      ..title = 'Habitude : 5 minutes de Méditation'
      ..description = 'Complétée via le Habit Stacking après une tâche majeure.'
      ..dueDate = DateTime.now()
      ..status = TaskStatus.completed
      ..estimatedDurationMinutes = 5
      ..priority = TaskPriority.low;

    taskVM.addTask(habitTask);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Excellente décision ! Habitude ancrée avec succès.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
