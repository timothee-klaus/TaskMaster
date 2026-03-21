import 'package:isar/isar.dart';

part 'sub_task.g.dart';

@embedded
class SubTask {
  String? title;
  bool isCompleted = false;
}
