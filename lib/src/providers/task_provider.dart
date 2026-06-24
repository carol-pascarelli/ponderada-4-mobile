import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:ponderada_4_mobile/src/models/task_model.dart';
import 'package:ponderada_4_mobile/src/repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider({required TaskRepository taskRepository})
      : _taskRepository = taskRepository;

  final TaskRepository _taskRepository;

  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<List<TaskModel>>? _subscription;

  List<TaskModel> get tasks => List.unmodifiable(_tasks);
  List<TaskModel> get pendingTasks =>
      _tasks.where((task) => !task.completed).toList();
  List<TaskModel> get completedTasks =>
      _tasks.where((task) => task.completed).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void listenToTasks(String userId) {
    _subscription?.cancel();
    _subscription = _taskRepository.watchTasks(userId).listen(
      (tasks) {
        _tasks = tasks;
        notifyListeners();
      },
      onError: (Object error) {
        _errorMessage = 'Erro ao carregar tarefas.';
        notifyListeners();
      },
    );
  }

  Future<bool> createTask({
    required String userId,
    required String title,
    required String description,
    required DateTime dueDate,
    double? latitude,
    double? longitude,
    String? locationLabel,
  }) async {
    _setLoading(true);
    try {
      await _taskRepository.createTask(
        userId: userId,
        title: title,
        description: description,
        dueDate: dueDate,
        latitude: latitude,
        longitude: longitude,
        locationLabel: locationLabel,
      );
      _errorMessage = null;
      return true;
    } catch (_) {
      _errorMessage = 'Não foi possível criar a tarefa.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateTask(TaskModel task) async {
    _setLoading(true);
    try {
      await _taskRepository.updateTask(task);
      _errorMessage = null;
      return true;
    } catch (_) {
      _errorMessage = 'Não foi possível atualizar a tarefa.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteTask(String taskId) async {
    _setLoading(true);
    try {
      await _taskRepository.deleteTask(taskId);
      _errorMessage = null;
      return true;
    } catch (_) {
      _errorMessage = 'Não foi possível excluir a tarefa.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> toggleComplete(TaskModel task) async {
    try {
      await _taskRepository.toggleComplete(task);
      return true;
    } catch (_) {
      _errorMessage = 'Não foi possível atualizar o status.';
      notifyListeners();
      return false;
    }
  }

  int completedTasksTodayCount() {
    final today = DateTime.now();
    return _tasks.where((task) {
      if (!task.completed || task.completedAt == null) return false;
      final completedAt = task.completedAt!;
      return completedAt.year == today.year &&
          completedAt.month == today.month &&
          completedAt.day == today.day;
    }).length;
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _tasks = [];
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
