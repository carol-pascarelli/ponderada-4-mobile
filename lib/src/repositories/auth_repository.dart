import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ponderada_4_mobile/src/core/constants/firestore_collections.dart';
import 'package:ponderada_4_mobile/src/models/user_model.dart';

class AuthRepository {
  AuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Não foi possível realizar o login.');
    }

    return _fetchUser(user.uid);
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Não foi possível criar a conta.');
    }

    final userModel = UserModel(
      uid: user.uid,
      name: name.trim(),
      email: email.trim(),
    );

    await _firestore
        .collection(FirestoreCollections.users)
        .doc(user.uid)
        .set(userModel.toMap());

    return userModel;
  }

  Future<UserModel> fetchCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado.');
    }
    return _fetchUser(user.uid);
  }

  Future<UserModel> _fetchUser(String uid) async {
    final doc =
        await _firestore.collection(FirestoreCollections.users).doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      final firebaseUser = _auth.currentUser;
      return UserModel(
        uid: uid,
        name: firebaseUser?.displayName ?? 'Estudante',
        email: firebaseUser?.email ?? '',
      );
    }

    return UserModel.fromMap(doc.data()!, uid: uid);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
