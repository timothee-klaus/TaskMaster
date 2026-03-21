import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taskmaster/models/models.dart';

/// Provides a Singleton-like access to the Isar Database Instance
class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = _initDb();
  }

  Future<Isar> _initDb() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [TaskSchema, UserProfileSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }
}
