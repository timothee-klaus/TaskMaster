import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taskmaster/models/models.dart';
import 'package:taskmaster/repositories/task_repository.dart';
import 'package:taskmaster/repositories/ai_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;
  final AiRepository _aiRepository;

  List<Task> _allTasks = [];
  List<Task> _agendaTasks = [];
  List<Task> _pendingTasks = [];

  StreamSubscription? _allTasksSub;
  StreamSubscription? _agendaTasksSub;
  StreamSubscription? _pendingTasksSub;

  DateTime _selectedAgendaDate = DateTime.now();

  bool _isGeneratingSubtasks = false;

  TaskViewModel(this._taskRepository, this._aiRepository) {
    _initStreams();
  }

  List<Task> get allTasks => _allTasks;
  List<Task> get agendaTasks => _agendaTasks;
  List<Task> get pendingTasks => _pendingTasks;
  DateTime get selectedAgendaDate => _selectedAgendaDate;

  bool get isGeneratingSubtasks => _isGeneratingSubtasks;

  void _initStreams() {
    _allTasksSub = _taskRepository.watchAllTasks().listen((tasks) {
      _allTasks = tasks;
      notifyListeners();
    });

    _pendingTasksSub = _taskRepository.watchPendingTasks().listen((tasks) {
      _pendingTasks = tasks;
      notifyListeners();
    });

    _updateAgendaStream();
  }

  void _updateAgendaStream() {
    _agendaTasksSub?.cancel();
    _agendaTasksSub = _taskRepository
        .watchTasksForDate(_selectedAgendaDate)
        .listen((tasks) {
          _agendaTasks = tasks;
          notifyListeners();
        });
  }

  void setAgendaDate(DateTime date) {
    _selectedAgendaDate = date;
    _updateAgendaStream();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _taskRepository.saveTask(task);
  }

  Future<void> toggleTaskCompletion(Task task) async {
    task.status = task.status == TaskStatus.completed
        ? TaskStatus.todo
        : TaskStatus.completed;
    await _taskRepository.saveTask(task);
  }

  Future<void> deleteTask(int id) async {
    await _taskRepository.deleteTask(id);
  }

  Future<List<Task>> search(String query) async {
    if (query.isEmpty) return _allTasks;
    return await _taskRepository.searchTasks(query);
  }

  /// Appelle l'API d'IA Groq pour décomposer automatiquement la tâche actuelle
  Future<void> generateSmartSubtasks(Task task) async {
    if (task.title == null || task.title!.isEmpty) return;

    _isGeneratingSubtasks = true;
    notifyListeners();

    try {
      final subtasks = await _aiRepository.generateSubtasks(task.title!);
      if (subtasks.isNotEmpty) {
        // En Isar, on doit recréer ou modifier la liste complètement
        task.subTasks = [...task.subTasks, ...subtasks];
        await addTask(task);
      }
    } finally {
      _isGeneratingSubtasks = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _allTasksSub?.cancel();
    _agendaTasksSub?.cancel();
    _pendingTasksSub?.cancel();
    super.dispose();
  }
}
