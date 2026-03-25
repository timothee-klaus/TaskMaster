import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taskmaster/models/models.dart';
import 'package:taskmaster/repositories/task_repository.dart';
import 'package:taskmaster/repositories/ai_repository.dart';
import 'package:taskmaster/repositories/user_repository.dart';
import 'package:taskmaster/services/notification_service.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;
  final AiRepository _aiRepository;
  final UserRepository _userRepository;
  final NotificationService _notificationService;

  List<Task> _allTasks = [];
  List<Task> _agendaTasks = [];
  List<Task> _pendingTasks = [];
  List<SubTask> _pendingGeneratedSubtasks = [];

  UserProfile? _userProfile;

  StreamSubscription? _allTasksSub;
  StreamSubscription? _agendaTasksSub;
  StreamSubscription? _pendingTasksSub;

  DateTime _selectedAgendaDate = DateTime.now();

  bool _isGeneratingSubtasks = false;
  UserMood _mood = UserMood.none;
  bool _hasPromptedMood = false;
  bool _isAiBarActive = false;

  TaskViewModel(
    this._taskRepository,
    this._aiRepository,
    this._userRepository,
    this._notificationService,
  ) {
    _initStreams();
    _loadUserProfile();
  }

  UserProfile? get userProfile => _userProfile;

  Future<void> _loadUserProfile() async {
    _userProfile = await _userRepository.getUserProfile();
    notifyListeners();
  }

  List<Task> get allTasks => _allTasks;
  List<Task> get agendaTasks => _agendaTasks;
  List<Task> get pendingTasks => _pendingTasks;
  DateTime get selectedAgendaDate => _selectedAgendaDate;

  bool get isGeneratingSubtasks => _isGeneratingSubtasks;
  List<SubTask> get pendingGeneratedSubtasks => _pendingGeneratedSubtasks;
  UserMood get currentMood => _mood;
  bool get isAiBarActive => _isAiBarActive;

  bool shouldPromptMood() {
    if (!_hasPromptedMood && _mood == UserMood.none) {
      _hasPromptedMood = true;
      return true;
    }
    return false;
  }

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
          _agendaTasks = _sortTasksByMood(tasks, _mood);
          notifyListeners();
        });
  }

  void setAgendaDate(DateTime date) {
    _selectedAgendaDate = date;
    _updateAgendaStream();
  }

  void setMood(UserMood newMood) {
    _mood = newMood;
    _agendaTasks = _sortTasksByMood(List.from(_agendaTasks), _mood);
    notifyListeners();
  }

  void setAiBarActive(bool active) {
    if (_isAiBarActive != active) {
      _isAiBarActive = active;
      notifyListeners();
    }
  }

  List<Task> _sortTasksByMood(List<Task> tasks, UserMood mood) {
    if (mood == UserMood.productive) {
      tasks.sort((a, b) {
        if (a.priority != b.priority) {
          return b.priority.index.compareTo(a.priority.index); // High first
        }
        return (b.estimatedDurationMinutes ?? 0).compareTo(
          a.estimatedDurationMinutes ?? 0,
        );
      });
    } else if (mood == UserMood.tired) {
      tasks.sort((a, b) {
        if (a.priority != b.priority) {
          return a.priority.index.compareTo(b.priority.index); // Low first
        }
        return (a.estimatedDurationMinutes ?? 0).compareTo(
          b.estimatedDurationMinutes ?? 0,
        );
      });
    }
    return tasks;
  }

  Future<void> addTask(Task task) async {
    // Note: Google Calendar sync was moved to TaskRepository to avoid tight coupling.
    await _taskRepository.saveTask(task);
    _scheduleNotifications(task);
  }

  void _scheduleNotifications(Task task) {
    if (task.status != TaskStatus.completed) {
      _notificationService.scheduleTaskReminder(task);
      for (var st in task.subTasks) {
        if (!st.isCompleted) {
          _notificationService.scheduleSubtaskReminder(
            st,
            task.id + st.hashCode,
          );
        }
      }
    } else {
      _notificationService.cancelReminder(task.id);
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final bool isNowCompleted = task.status != TaskStatus.completed;
    task.status = isNowCompleted ? TaskStatus.completed : TaskStatus.todo;

    if (isNowCompleted) {
      final cleanHistory = task.history
          .where((item) => item.label != 'Tâche complétée')
          .toList();

      final historyItem = TaskHistoryItem()
        ..label = 'Tâche complétée'
        ..timestamp = DateTime.now()
        ..actor = 'Vous';

      task.history = [...cleanHistory, historyItem];
    } else {
      task.history = task.history
          .where((item) => item.label != 'Tâche complétée')
          .toList();
    }

    await _taskRepository.saveTask(task);
    _scheduleNotifications(task);
  }

  Future<void> toggleSubTask(Task task, int index) async {
    if (index >= 0 && index < task.subTasks.length) {
      final subtask = task.subTasks[index];
      subtask.isCompleted = !subtask.isCompleted;

      final labelToMatch = 'Sous-tâche "${subtask.title}" complétée';

      if (subtask.isCompleted) {
        final cleanHistory = task.history
            .where((item) => item.label != labelToMatch)
            .toList();

        final historyItem = TaskHistoryItem()
          ..label = labelToMatch
          ..timestamp = DateTime.now()
          ..actor = 'Vous';

        task.history = [...cleanHistory, historyItem];
      } else {
        task.history = task.history
            .where((item) => item.label != labelToMatch)
            .toList();
      }

      task.subTasks = [...task.subTasks];
      await _taskRepository.saveTask(task);
      _scheduleNotifications(task);
      notifyListeners();
    }
  }

  Future<void> deleteTask(int id) async {
    await _taskRepository.deleteTask(id);
  }

  Future<List<Task>> search(String query) async {
    if (query.isEmpty) return _allTasks;
    return await _taskRepository.searchTasks(query);
  }

  Future<void> generateSmartSubtasks(Task task) async {
    if (task.title == null || task.title!.isEmpty) return;

    _isGeneratingSubtasks = true;
    notifyListeners();

    try {
      final subtasks = await _aiRepository.generateSubtasks(task);
      if (subtasks.isNotEmpty) {
        _pendingGeneratedSubtasks = subtasks;
      }
    } finally {
      _isGeneratingSubtasks = false;
      notifyListeners();
    }
  }

  Future<Task?> parseTaskFromNaturalLanguage(String text) async {
    return _aiRepository.parseTaskFromNaturalLanguage(text);
  }

  void updatePendingSubtask(int index, String newTitle) {
    if (index >= 0 && index < _pendingGeneratedSubtasks.length) {
      _pendingGeneratedSubtasks[index].title = newTitle;
      notifyListeners();
    }
  }

  void updatePendingSubtaskDuration(int index, int? duration) {
    if (index >= 0 && index < _pendingGeneratedSubtasks.length) {
      _pendingGeneratedSubtasks[index].durationMinutes = duration;
      notifyListeners();
    }
  }

  void updatePendingSubtaskStartTime(int index, DateTime startTime) {
    if (index >= 0 && index < _pendingGeneratedSubtasks.length) {
      _pendingGeneratedSubtasks[index].startTime = startTime;
      notifyListeners();
    }
  }

  void removePendingSubtask(int index) {
    if (index >= 0 && index < _pendingGeneratedSubtasks.length) {
      _pendingGeneratedSubtasks.removeAt(index);
      notifyListeners();
    }
  }

  void clearPendingSubtasks() {
    _pendingGeneratedSubtasks.clear();
    notifyListeners();
  }

  Future<void> confirmPendingSubtasks(Task task) async {
    if (_pendingGeneratedSubtasks.isNotEmpty) {
      task.subTasks = [...task.subTasks, ..._pendingGeneratedSubtasks];
      await _taskRepository.saveTask(task);
      _pendingGeneratedSubtasks.clear();
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
