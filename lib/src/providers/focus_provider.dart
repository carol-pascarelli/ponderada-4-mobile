import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:ponderada_4_mobile/src/core/constants/app_constants.dart';
import 'package:ponderada_4_mobile/src/models/focus_session_model.dart';
import 'package:ponderada_4_mobile/src/repositories/focus_repository.dart';
import 'package:ponderada_4_mobile/src/services/notification_service.dart';

class FocusProvider extends ChangeNotifier {
  FocusProvider({
    required FocusRepository focusRepository,
    required NotificationService notificationService,
  })  : _focusRepository = focusRepository,
        _notificationService = notificationService;

  final FocusRepository _focusRepository;
  final NotificationService _notificationService;

  List<FocusSessionModel> _sessions = [];
  int _remainingSeconds = AppConstants.pomodoroDurationSeconds;
  bool _isRunning = false;
  String? _errorMessage;
  String? _currentUserId;
  Timer? _timer;
  StreamSubscription<List<FocusSessionModel>>? _subscription;

  List<FocusSessionModel> get sessions => List.unmodifiable(_sessions);
  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  String? get errorMessage => _errorMessage;

  int get totalFocusSeconds =>
      _sessions.fold(0, (sum, session) => sum + session.duration);

  int get focusMinutesToday {
    final today = DateTime.now();
    return _sessions
        .where((session) {
          return session.createdAt.year == today.year &&
              session.createdAt.month == today.month &&
              session.createdAt.day == today.day;
        })
        .fold(0, (sum, session) => sum + session.duration) ~/
        60;
  }

  String get formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void listenToSessions(String userId) {
    _currentUserId = userId;
    _subscription?.cancel();
    _subscription = _focusRepository.watchSessions(userId).listen(
      (sessions) {
        _sessions = sessions;
        notifyListeners();
      },
    );
  }

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick);
    notifyListeners();
  }

  void pause() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    _isRunning = false;
    _remainingSeconds = AppConstants.pomodoroDurationSeconds;
    notifyListeners();
  }

  Future<void> _tick() async {
    if (_remainingSeconds <= 1) {
      _remainingSeconds = 0;
      notifyListeners();
      await _completeSession();
      return;
    }

    _remainingSeconds--;
    notifyListeners();
  }

  Future<void> _completeSession() async {
    _timer?.cancel();
    _isRunning = false;

    await _notificationService.showPomodoroCompleteNotification();

    if (_currentUserId != null) {
      try {
        await _focusRepository.saveSession(
          userId: _currentUserId!,
          duration: AppConstants.pomodoroDurationSeconds,
        );
      } catch (_) {
        _errorMessage = 'Sessão concluída, mas não foi salva.';
      }
    }

    reset();
  }

  void stopListening() {
    _currentUserId = null;
    _subscription?.cancel();
    _subscription = null;
    _sessions = [];
    reset();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }
}
