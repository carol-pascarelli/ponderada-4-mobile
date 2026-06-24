import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  const TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.completed,
    this.completedAt,
    this.latitude,
    this.longitude,
    this.locationLabel,
  });

  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool completed;
  final DateTime? completedAt;
  final double? latitude;
  final double? longitude;
  final String? locationLabel;

  bool get hasLocation => latitude != null && longitude != null;

  factory TaskModel.fromMap(Map<String, dynamic> map, {required String id}) {
    final dueDateRaw = map['dueDate'];
    DateTime dueDate;

    if (dueDateRaw is Timestamp) {
      dueDate = dueDateRaw.toDate();
    } else if (dueDateRaw is DateTime) {
      dueDate = dueDateRaw;
    } else {
      dueDate = DateTime.now();
    }

    return TaskModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      dueDate: dueDate,
      completed: map['completed'] as bool? ?? false,
      completedAt: _parseDate(map['completedAt']),
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      locationLabel: map['locationLabel'] as String?,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'completed': completed,
      if (completedAt != null)
        'completedAt': Timestamp.fromDate(completedAt!),
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (locationLabel != null && locationLabel!.isNotEmpty)
        'locationLabel': locationLabel,
    };
  }

  TaskModel copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    bool? completed,
    DateTime? completedAt,
    double? latitude,
    double? longitude,
    String? locationLabel,
    bool clearLocation = false,
  }) {
    return TaskModel(
      id: id,
      userId: userId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      latitude: clearLocation ? null : (latitude ?? this.latitude),
      longitude: clearLocation ? null : (longitude ?? this.longitude),
      locationLabel:
          clearLocation ? null : (locationLabel ?? this.locationLabel),
    );
  }
}
