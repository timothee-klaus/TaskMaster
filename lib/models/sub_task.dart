/// Model for smaller steps within a Task.
class SubTask {
  final String id;
  final String title;
  final bool isCompleted;

  SubTask({required this.id, required this.title, this.isCompleted = false});

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
