import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ponderada_4_mobile/src/core/constants/firestore_collections.dart';
import 'package:ponderada_4_mobile/src/models/focus_session_model.dart';

class FocusRepository {
  FocusRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestoreCollections.focusSessions);

  Stream<List<FocusSessionModel>> watchSessions(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FocusSessionModel.fromMap(doc.data(), id: doc.id))
              .toList(),
        );
  }

  Future<List<FocusSessionModel>> getSessions(String userId) async {
    final snapshot = await _collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => FocusSessionModel.fromMap(doc.data(), id: doc.id))
        .toList();
  }

  Future<FocusSessionModel> saveSession({
    required String userId,
    required int duration,
  }) async {
    final docRef = _collection.doc();
    final session = FocusSessionModel(
      id: docRef.id,
      userId: userId,
      duration: duration,
      createdAt: DateTime.now(),
    );

    await docRef.set(session.toMap());
    return session;
  }
}
