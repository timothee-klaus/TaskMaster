import 'package:isar/isar.dart';
import '../enums/task_priority.dart';
import '../enums/task_status.dart';
import '../sub_task/sub_task.dart';
import '../task_history_item/task_history_item.dart';

part 'task.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;

  String? title;
  String? description;
  DateTime? dueDate;

  @enumerated
  TaskPriority priority = TaskPriority.medium;

  @enumerated
  TaskStatus status = TaskStatus.todo;

  int estimatedDurationMinutes = 60;
  bool autoSchedulingEnabled = false;
  bool isFlexible = false;

  List<SubTask> subTasks = [];
  List<String> attachments = [];
  List<TaskHistoryItem> history = [];

  @ignore
  double get progress {
    if (subTasks.isEmpty) return status == TaskStatus.completed ? 1.0 : 0.0;
    final completedCount = subTasks.where((st) => st.isCompleted).length;
    return completedCount / subTasks.length;
  }
}
