import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:ponderada_4_mobile/src/models/user_model.dart';
import 'package:ponderada_4_mobile/src/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({required AuthRepository authRepository})
      : _authRepository = authRepository {
    _authRepository.authStateChanges.listen(_onAuthStateChanged);
  }

  final AuthRepository _authRepository;

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _authRepository.currentUser != null;

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
      notifyListeners();
      return;
    }

    try {
      _user = await _authRepository.fetchCurrentUser();
    } catch (_) {
      _user = UserModel(
        uid: firebaseUser.uid,
        name: 'Estudante',
        email: firebaseUser.email ?? '',
      );
    }
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      _user = await _authRepository.signIn(email: email, password: password);
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = _mapAuthError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      _user = await _authRepository.register(
        name: name,
        email: email,
        password: password,
      );
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = _mapAuthError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _authRepository.signOut();
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _mapAuthError(Object error) {
    final message = error.toString();
    if (message.contains('invalid-credential') ||
        message.contains('wrong-password') ||
        message.contains('user-not-found')) {
      return 'E-mail ou senha inválidos.';
    }
    if (message.contains('email-already-in-use')) {
      return 'Este e-mail já está cadastrado.';
    }
    if (message.contains('weak-password')) {
      return 'A senha deve ter pelo menos 6 caracteres.';
    }
    if (message.contains('invalid-email')) {
      return 'E-mail inválido.';
    }
    return 'Ocorreu um erro. Tente novamente.';
  }
}
