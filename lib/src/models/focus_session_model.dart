import 'package:cloud_firestore/cloud_firestore.dart';

class FocusSessionModel {
  const FocusSessionModel({
    required this.id,
    required this.userId,
    required this.duration,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final int duration;
  final DateTime createdAt;

  factory FocusSessionModel.fromMap(Map<String, dynamic> map, {required String id}) {
    final createdAtRaw = map['createdAt'];
    DateTime createdAt;

    if (createdAtRaw is Timestamp) {
      createdAt = createdAtRaw.toDate();
    } else if (createdAtRaw is DateTime) {
      createdAt = createdAtRaw;
    } else {
      createdAt = DateTime.now();
    }

    return FocusSessionModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      duration: map['duration'] as int? ?? 0,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'duration': duration,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
