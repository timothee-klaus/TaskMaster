import 'package:isar/isar.dart';

part 'task_history_item.g.dart';

@embedded
class TaskHistoryItem {
  String? label;
  DateTime? timestamp;
  String? actor;
}
