import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmaster/models/models.dart';
import 'package:taskmaster/utils/app_colors.dart';
import 'package:taskmaster/viewmodels/task_viewmodel.dart';
import 'package:provider/provider.dart';

class DetailChip extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;

  const DetailChip({
    super.key,
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final bool isDarkMode;

  const SectionTitle(this.title, {super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.getTextSecondary(isDarkMode).withValues(alpha: 0.8),
        letterSpacing: 1.5,
      ),
    );
  }
}

class TimelineItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isActive;
  final bool isLast;
  final bool isDarkMode;

  const TimelineItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.isLast,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary
                    : (isDarkMode
                          ? AppColors.darkBorder
                          : const Color(0xFFEAECF0)),
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                margin: const EdgeInsets.only(top: 4, bottom: 4),
                color: isActive
                    ? (isDarkMode
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : const Color(0xFFFEE4E2))
                    : (isDarkMode
                          ? AppColors.darkBorder.withValues(alpha: 0.5)
                          : const Color(0xFFEAECF0)),
              ),
            if (isLast) const SizedBox(height: 4),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isActive
                    ? AppColors.getTextPrimary(isDarkMode)
                    : AppColors.getTextSecondary(isDarkMode),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.getTextSecondary(isDarkMode),
              ),
            ),
            if (!isLast) const SizedBox(height: 4),
          ],
        ),
      ],
    );
  }
}

class SubtaskItemTile extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final int? durationMinutes;
  final DateTime? startTime;
  final bool isDarkMode;
  final VoidCallback onTap;

  const SubtaskItemTile({
    super.key,
    required this.title,
    required this.isCompleted,
    this.durationMinutes,
    this.startTime,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.getSurface(isDarkMode),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.getBorder(isDarkMode)),
        ),
        child: Row(
          children: [
            Icon(
              isCompleted
                  ? Icons.check_circle_outline
                  : Icons.radio_button_unchecked,
              color: isCompleted
                  ? Colors.blueAccent
                  : AppColors.getTextSecondary(
                      isDarkMode,
                    ).withValues(alpha: 0.5),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isCompleted
                          ? AppColors.getTextSecondary(isDarkMode)
                          : AppColors.getTextPrimary(isDarkMode),
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  Row(
                    children: [
                      if (startTime != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            DateFormat('HH:mm').format(startTime!),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      if (durationMinutes != null)
                        Text(
                          '$durationMinutes min',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.getTextSecondary(isDarkMode),
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

class AttachmentItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final bool isDarkMode;

  const AttachmentItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.getSurface(isDarkMode),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.getBorder(isDarkMode)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.getTextPrimary(isDarkMode),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class TaskDetailsHeader extends StatelessWidget {
  final Task task;
  final bool isDarkMode;

  const TaskDetailsHeader({
    super.key,
    required this.task,
    required this.isDarkMode,
  });

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DetailChip(
              label: task.status.name.toUpperCase(),
              bgColor: task.status == TaskStatus.completed
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.1),
              textColor: task.status == TaskStatus.completed
                  ? AppColors.success
                  : AppColors.primary,
            ),
            const SizedBox(width: 8),
            DetailChip(
              label: 'PRIORITÉ ${task.priority.name.toUpperCase()}',
              bgColor: _getPriorityColor(task.priority, false),
              textColor: _getPriorityColor(task.priority, true),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          task.title ?? 'Sans titre',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.getTextPrimary(isDarkMode),
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 14,
              color: AppColors.getTextSecondary(isDarkMode),
            ),
            const SizedBox(width: 4),
            Text(
              task.dueDate != null
                  ? 'Échéance: ${DateFormat('dd MMM').format(task.dueDate!)}'
                  : 'Pas d\'échéance',
              style: TextStyle(
                color: AppColors.getTextSecondary(isDarkMode),
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.timer_outlined,
              size: 14,
              color: AppColors.getTextSecondary(isDarkMode),
            ),
            const SizedBox(width: 4),
            Text(
              '${task.estimatedDurationMinutes} min',
              style: TextStyle(
                color: AppColors.getTextSecondary(isDarkMode),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TaskHistorySection extends StatelessWidget {
  final Task task;
  final bool isDarkMode;

  const TaskHistorySection({
    super.key,
    required this.task,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle('PROGRESSION', isDarkMode: isDarkMode),
        const SizedBox(height: 16),
        if (task.history.isEmpty)
          Text(
            'Aucun historique disponible',
            style: TextStyle(
              color: AppColors.getTextSecondary(isDarkMode),
              fontSize: 14,
            ),
          )
        else
          ...List.generate(
            task.history.length,
            (index) => TimelineItem(
              title: task.history[index].label ?? 'Action',
              subtitle:
                  '${DateFormat('EEEE, HH:mm', 'fr').format(task.history[index].timestamp ?? DateTime.now())} par ${task.history[index].actor ?? 'Système'}',
              isActive: true,
              isLast: index == task.history.length - 1,
              isDarkMode: isDarkMode,
            ),
          ),
      ],
    );
  }
}

class SubTasksSection extends StatelessWidget {
  final Task task;
  final bool isDarkMode;

  const SubTasksSection({
    super.key,
    required this.task,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final taskVM = context.watch<TaskViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SectionTitle('SOUS-TÂCHES', isDarkMode: isDarkMode),
            if (task.subTasks.isNotEmpty)
              DetailChip(
                label:
                    '${task.subTasks.where((st) => st.isCompleted).length}/${task.subTasks.length} terminées',
                bgColor: isDarkMode
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : const Color(0xFFFDECEE),
                textColor: AppColors.primary,
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (task.subTasks.isEmpty &&
            taskVM.pendingGeneratedSubtasks.isEmpty &&
            !taskVM.isGeneratingSubtasks)
          Text(
            'Aucune sous-tâche',
            style: TextStyle(color: AppColors.getTextSecondary(isDarkMode)),
          )
        else
          ...task.subTasks.asMap().entries.map((entry) {
            final idx = entry.key;
            final st = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: SubtaskItemTile(
                title: st.title ?? 'Sous-tâche',
                isCompleted: st.isCompleted,
                durationMinutes: st.durationMinutes,
                startTime: st.startTime,
                isDarkMode: isDarkMode,
                onTap: () => taskVM.toggleSubTask(task, idx),
              ),
            );
          }),
        if (taskVM.isGeneratingSubtasks)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        if (taskVM.pendingGeneratedSubtasks.isNotEmpty)
          AiSuggestionsSection(task: task, isDarkMode: isDarkMode),
        const SizedBox(height: 16),
        if (!taskVM.isGeneratingSubtasks &&
            taskVM.pendingGeneratedSubtasks.isEmpty)
          OutlinedButton.icon(
            onPressed: () => taskVM.generateSmartSubtasks(task),
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: const Text('Générer avec l\'IA'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
      ],
    );
  }
}

class AiSuggestionsSection extends StatelessWidget {
  final Task task;
  final bool isDarkMode;

  const AiSuggestionsSection({
    super.key,
    required this.task,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final taskVM = context.watch<TaskViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text(
              'Nouvelles sous-tâches proposées',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: AppColors.getTextPrimary(isDarkMode),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...taskVM.pendingGeneratedSubtasks.asMap().entries.map((entry) {
          final idx = entry.key;
          final st = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.getBorder(isDarkMode).withValues(alpha: 0.5),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(text: st.title)
                          ..selection = TextSelection.fromPosition(
                            TextPosition(offset: st.title?.length ?? 0),
                          ),
                        onChanged: (val) =>
                            taskVM.updatePendingSubtask(idx, val),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.getTextPrimary(isDarkMode),
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: 'Titre de la sous-tâche',
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: AppColors.error,
                      ),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: () => taskVM.removePendingSubtask(idx),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 14,
                      color: AppColors.getTextSecondary(isDarkMode),
                    ),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (val) => taskVM.updatePendingSubtaskDuration(
                          idx,
                          int.tryParse(val),
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.getTextSecondary(isDarkMode),
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: 'min',
                          suffixText: 'm',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.access_time_outlined,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                            st.startTime ?? DateTime.now(),
                          ),
                        );
                        if (time != null) {
                          final now = st.startTime ?? DateTime.now();
                          final newDateTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            time.hour,
                            time.minute,
                          );
                          taskVM.updatePendingSubtaskStartTime(
                            idx,
                            newDateTime,
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        st.startTime != null
                            ? DateFormat('HH:mm').format(st.startTime!)
                            : 'Heure...',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => taskVM.clearPendingSubtasks(),
              child: Text(
                'Ignorer',
                style: TextStyle(color: AppColors.getTextSecondary(isDarkMode)),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => taskVM.confirmPendingSubtasks(task),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Sauvegarder'),
            ),
          ],
        ),
      ],
    );
  }
}

class NotesSection extends StatelessWidget {
  final String? description;
  final bool isDarkMode;

  const NotesSection({super.key, this.description, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle('NOTES & INSTRUCTIONS', isDarkMode: isDarkMode),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.primary.withValues(alpha: 0.05)
                : const Color(0xFFFFF1F2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDarkMode
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : const Color(0xFFFECDD3),
            ),
          ),
          child: Text(
            description != null && description!.isNotEmpty
                ? description!
                : "Aucune description fournie pour cette tâche.",
            style: TextStyle(
              color: AppColors.getTextSecondary(isDarkMode),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class AttachmentsSection extends StatelessWidget {
  final List<String> attachments;
  final bool isDarkMode;

  const AttachmentsSection({
    super.key,
    required this.attachments,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle('PIÈCES JOINTES', isDarkMode: isDarkMode),
        const SizedBox(height: 16),
        if (attachments.isEmpty)
          Text(
            'Aucune pièce jointe',
            style: TextStyle(color: AppColors.getTextSecondary(isDarkMode)),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: attachments
                .map(
                  (path) => AttachmentItem(
                    icon: Icons.description_outlined,
                    iconColor: Colors.blueAccent,
                    title: path.split('/').last,
                    isDarkMode: isDarkMode,
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
