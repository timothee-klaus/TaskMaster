import 'task_priority.dart';
import 'task_status.dart';
import 'sub_task.dart';
import 'task_history_item.dart';

/// Model representing a single Task in the TaskMaster system.
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final TaskStatus status;
  final Duration estimatedDuration;
  final bool autoSchedulingEnabled;
  final List<SubTask> subTasks;
  final List<String> attachments; // Paths or URLs to files
  final List<TaskHistoryItem> history;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.dueDate,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.todo,
    this.estimatedDuration = const Duration(hours: 1),
    this.autoSchedulingEnabled = false,
    this.subTasks = const [],
    this.attachments = const [],
    this.history = const [],
  });

  /// Calculates the completion percentage based on subtasks.
  double get progress {
    if (subTasks.isEmpty) return status == TaskStatus.completed ? 1.0 : 0.0;
    final completedCount = subTasks.where((st) => st.isCompleted).length;
    return completedCount / subTasks.length;
  }

  /// Factory for creating a Task from a JSON map (for API/Database).
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      dueDate: DateTime.parse(json['dueDate'] as String),
      priority: TaskPriority.values.byName(json['priority'] as String),
      status: TaskStatus.values.byName(json['status'] as String),
      estimatedDuration: Duration(
        minutes: json['estimatedDurationMinutes'] as int,
      ),
      autoSchedulingEnabled: json['autoSchedulingEnabled'] as bool? ?? false,
      subTasks:
          (json['subTasks'] as List<dynamic>?)
              ?.map((i) => SubTask.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
      attachments: List<String>.from(json['attachments'] ?? []),
      history: const [], // History parsing omitted, defaults to empty list
    );
  }
}
