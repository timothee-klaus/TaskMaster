import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/viewmodels/task_viewmodel.dart';
import 'package:taskmaster/viewmodels/settings_viewmodel.dart';
import 'package:taskmaster/models/models.dart';
import 'package:taskmaster/utils/app_colors.dart';
import 'package:taskmaster/views/tasks/widgets/tasks_list_widgets.dart';

class TasksListScreen extends StatefulWidget {
  const TasksListScreen({super.key});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  @override
  Widget build(BuildContext context) {
    final taskVM = context.watch<TaskViewModel>();
    final settingsVM = context.watch<SettingsViewModel>();
    final isDarkMode = settingsVM.isDarkMode;

    if (taskVM.allTasks.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.getBackground(isDarkMode),
        appBar: _buildAppBar(context, isDarkMode),
        body: TasksListEmptyState(isDarkMode: isDarkMode),
      );
    }

    final pending = taskVM.pendingTasks;
    final completed = taskVM.allTasks
        .where((t) => t.status == TaskStatus.completed)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.getBackground(isDarkMode),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TasksListHeader(
                currentMood: taskVM.currentMood,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 32),
              TasksSearchField(isDarkMode: isDarkMode),
              const SizedBox(height: 24),
              TasksSegmentControl(isDarkMode: isDarkMode),
              const SizedBox(height: 32),
              _buildTasksTitleRow(pending.length, isDarkMode),
              const SizedBox(height: 24),
              ...pending.map(
                (task) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TaskCard(
                    task: task,
                    isDarkMode: isDarkMode,
                    onTap: () => context.push('/task-details', extra: task),
                  ),
                ),
              ),
              if (completed.isNotEmpty) ...[
                Divider(
                  height: 40,
                  color: isDarkMode
                      ? AppColors.darkBorder
                      : Colors.grey.shade200,
                ),
                ...completed.map(
                  (task) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CompletedTaskItem(
                      task: task,
                      vm: taskVM,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create-task'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDarkMode) {
    return AppBar(
      backgroundColor: AppColors.getBackground(isDarkMode),
      elevation: 0,
      centerTitle: true,
      leading: Icon(Icons.menu, color: AppColors.getTextPrimary(isDarkMode)),
      title: Text(
        'Mes Tâches',
        style: TextStyle(
          color: AppColors.getTextPrimary(isDarkMode),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Icon(Icons.search, color: AppColors.getTextPrimary(isDarkMode)),
        const SizedBox(width: 16),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: isDarkMode ? AppColors.darkBorder : Colors.grey.shade100,
          height: 1.0,
        ),
      ),
    );
  }

  Widget _buildTasksTitleRow(int pendingCount, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tous les objectifs',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.getTextPrimary(isDarkMode),
          ),
        ),
        Text(
          "$pendingCount à faire",
          style: TextStyle(
            fontSize: 13,
            color: AppColors.getTextSecondary(isDarkMode),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
