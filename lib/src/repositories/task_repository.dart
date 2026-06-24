import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ponderada_4_mobile/src/core/constants/firestore_collections.dart';
import 'package:ponderada_4_mobile/src/models/task_model.dart';
import 'package:ponderada_4_mobile/src/services/notification_service.dart';

class TaskRepository {
  TaskRepository({
    FirebaseFirestore? firestore,
    NotificationService? notificationService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _notificationService =
            notificationService ?? NotificationService();

  final FirebaseFirestore _firestore;
  final NotificationService _notificationService;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestoreCollections.tasks);

  Stream<List<TaskModel>> watchTasks(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('dueDate')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TaskModel.fromMap(doc.data(), id: doc.id))
              .toList(),
        );
  }

  Future<List<TaskModel>> getTasks(String userId) async {
    final snapshot = await _collection
        .where('userId', isEqualTo: userId)
        .orderBy('dueDate')
        .get();

    return snapshot.docs
        .map((doc) => TaskModel.fromMap(doc.data(), id: doc.id))
        .toList();
  }

  Future<TaskModel> createTask({
    required String userId,
    required String title,
    required String description,
    required DateTime dueDate,
    double? latitude,
    double? longitude,
    String? locationLabel,
  }) async {
    final docRef = _collection.doc();
    final task = TaskModel(
      id: docRef.id,
      userId: userId,
      title: title.trim(),
      description: description.trim(),
      dueDate: dueDate,
      completed: false,
      latitude: latitude,
      longitude: longitude,
      locationLabel: locationLabel,
    );

    await docRef.set(task.toMap());
    await _scheduleReminder(task);

    return task;
  }

  Future<void> updateTask(TaskModel task) async {
    await _collection.doc(task.id).update(task.toMap());
    await _notificationService.cancelTaskReminder(task.id.hashCode);
    if (!task.completed) {
      await _scheduleReminder(task);
    }
  }

  Future<void> deleteTask(String taskId) async {
    await _notificationService.cancelTaskReminder(taskId.hashCode);
    await _collection.doc(taskId).delete();
  }

  Future<void> toggleComplete(TaskModel task) async {
    final nowCompleted = !task.completed;
    final updated = task.copyWith(
      completed: nowCompleted,
      completedAt: nowCompleted ? DateTime.now() : null,
    );
    await updateTask(updated);
  }

  Future<void> _scheduleReminder(TaskModel task) async {
    var body = task.description.isNotEmpty
        ? task.description
        : 'Sua tarefa está próxima do prazo.';

    if (task.hasLocation) {
      final locationText = task.locationLabel ??
          '${task.latitude!.toStringAsFixed(4)}, ${task.longitude!.toStringAsFixed(4)}';
      body = '$body\n📍 Local: $locationText';
    }

    await _notificationService.scheduleTaskReminder(
      notificationId: task.id.hashCode,
      title: 'Lembrete: ${task.title}',
      body: body,
      scheduledDate: task.dueDate,
    );
  }
}
