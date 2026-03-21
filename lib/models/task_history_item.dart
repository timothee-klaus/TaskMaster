/// Model for the task timeline/history.
class TaskHistoryItem {
  final String label;
  final DateTime timestamp;
  final String actor;

  TaskHistoryItem({
    required this.label,
    required this.timestamp,
    required this.actor,
  });
}
