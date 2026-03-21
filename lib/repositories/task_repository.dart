import 'package:isar/isar.dart';
import 'package:taskmaster/models/models.dart';
import 'package:taskmaster/services/isar_service.dart';

/// Repository handling all Task-related database operations
class TaskRepository {
  final IsarService _isarService;

  TaskRepository(this._isarService);

  // --- Core CRUD ---

  Future<void> saveTask(Task task) async {
    final isar = await _isarService.db;
    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
  }

  Future<void> deleteTask(Id id) async {
    final isar = await _isarService.db;
    await isar.writeTxn(() async {
      await isar.tasks.delete(id);
    });
  }

  // --- Getters & Queries ---

  Future<List<Task>> getAllTasks() async {
    final isar = await _isarService.db;
    return await isar.tasks.where().findAll();
  }

  Stream<List<Task>> watchAllTasks() async* {
    final isar = await _isarService.db;
    yield* isar.tasks.where().watch(fireImmediately: true);
  }

  /// Récupérer les tâches d'une journée spécifique (pour l'Agenda)
  Future<List<Task>> getTasksForDate(DateTime date) async {
    final isar = await _isarService.db;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return await isar.tasks
        .filter()
        .dueDateBetween(startOfDay, endOfDay)
        .sortByDueDate()
        .findAll();
  }

  /// Écouter la liste des tâches d'un jour précis de manière réactive
  Stream<List<Task>> watchTasksForDate(DateTime date) async* {
    final isar = await _isarService.db;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    yield* isar.tasks
        .filter()
        .dueDateBetween(startOfDay, endOfDay)
        .sortByDueDate()
        .watch(fireImmediately: true);
  }

  /// Récupérer les tâches en cours ou à faire (Pour le Dashboard)
  Stream<List<Task>> watchPendingTasks() async* {
    final isar = await _isarService.db;
    yield* isar.tasks
        .filter()
        .statusEqualTo(TaskStatus.todo)
        .or()
        .statusEqualTo(TaskStatus.inProgress)
        .sortByDueDate()
        .watch(fireImmediately: true);
  }

  /// Recherche globale (Search bar)
  Future<List<Task>> searchTasks(String query) async {
    final isar = await _isarService.db;
    return await isar.tasks
        .filter()
        .titleContains(query, caseSensitive: false)
        .or()
        .descriptionContains(query, caseSensitive: false)
        .findAll();
  }
}
