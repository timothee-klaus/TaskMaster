import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/viewmodels/settings_viewmodel.dart';
import 'package:taskmaster/viewmodels/task_viewmodel.dart';
import 'package:taskmaster/utils/app_colors.dart';
import 'package:taskmaster/models/models.dart';
import 'package:taskmaster/views/tasks/widgets/habit_stacking_dialog.dart';
import 'package:taskmaster/views/tasks/widgets/task_details_widgets.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;
  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final settingsVM = context.watch<SettingsViewModel>();
    final taskVM = context.watch<TaskViewModel>();
    final isDarkMode = settingsVM.isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getBackground(isDarkMode),
      appBar: AppBar(
        backgroundColor: AppColors.getBackground(isDarkMode),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.getTextPrimary(isDarkMode),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Détails de l\'objectif',
          style: TextStyle(
            color: AppColors.getTextPrimary(isDarkMode),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: AppColors.getTextPrimary(isDarkMode),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              color: AppColors.getTextPrimary(isDarkMode),
            ),
            onPressed: () {
              context.push('/create-task', extra: task);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.primary),
            onPressed: () => _showDeleteConfirmation(context, taskVM),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TaskDetailsHeader(task: task, isDarkMode: isDarkMode),
                    const SizedBox(height: 32),
                    TaskHistorySection(task: task, isDarkMode: isDarkMode),
                    const SizedBox(height: 32),
                    SubTasksSection(task: task, isDarkMode: isDarkMode),
                    const SizedBox(height: 32),
                    NotesSection(
                      description: task.description,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 32),
                    AttachmentsSection(
                      attachments: task.attachments,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildStickyBottomButton(context, taskVM, isDarkMode),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    TaskViewModel taskVM,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la tâche ?'),
        content: const Text(
          'Cette action est irréversible. Êtes-vous sûr de vouloir supprimer cette tâche ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Supprimer',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await taskVM.deleteTask(task.id);
      if (context.mounted) context.pop();
    }
  }

  Widget _buildStickyBottomButton(
    BuildContext context,
    TaskViewModel taskVM,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.getSurface(isDarkMode),
        boxShadow: isDarkMode
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
        border: isDarkMode
            ? Border(top: BorderSide(color: AppColors.darkBorder))
            : null,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () async {
            final wasCompleted = task.status == TaskStatus.completed;
            await taskVM.toggleTaskCompletion(task);
            if (context.mounted) {
              if (!wasCompleted &&
                  task.status == TaskStatus.completed &&
                  (task.priority == TaskPriority.high ||
                      task.estimatedDurationMinutes >= 60)) {
                HabitStackingDialog.show(context, task, isDarkMode);
              } else {
                context.pop();
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: task.status == TaskStatus.completed
                ? AppColors.getTextSecondary(isDarkMode)
                : const Color(0xFFFF5A4A),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          icon: Icon(
            task.status == TaskStatus.completed
                ? Icons.undo
                : Icons.check_circle_outline,
            color: Colors.white,
          ),
          label: Text(
            task.status == TaskStatus.completed
                ? 'Marquer comme à faire'
                : 'Marquer comme terminé',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
