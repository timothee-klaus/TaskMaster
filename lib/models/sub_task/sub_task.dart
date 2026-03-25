import 'package:isar/isar.dart';

part 'sub_task.g.dart';

@embedded
class SubTask {
  String? title;
  bool isCompleted = false;
  int? durationMinutes; // Temps estimé ou passé en minutes
  DateTime? startTime; // Heure de début suggérée ou réelle
}
