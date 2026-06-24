import 'package:flutter/material.dart';
import 'package:ponderada_4_mobile/src/providers/task_provider.dart';
import 'package:ponderada_4_mobile/src/providers/focus_provider.dart';
import 'package:ponderada_4_mobile/src/services/share_service.dart';

class StatsProvider extends ChangeNotifier {
  StatsProvider({
    required ShareService shareService,
  }) : _shareService = shareService;

  final ShareService _shareService;

  int completedCount = 0;
  int pendingCount = 0;
  int pomodoroSessions = 0;
  int totalFocusMinutes = 0;
  int completedToday = 0;
  int focusMinutesToday = 0;

  void updateFromProviders({
    required TaskProvider taskProvider,
    required FocusProvider focusProvider,
  }) {
    completedCount = taskProvider.completedTasks.length;
    pendingCount = taskProvider.pendingTasks.length;
    pomodoroSessions = focusProvider.sessions.length;
    totalFocusMinutes = focusProvider.totalFocusSeconds ~/ 60;
    completedToday = taskProvider.completedTasksTodayCount();
    focusMinutesToday = focusProvider.focusMinutesToday;
    notifyListeners();
  }

  Future<void> shareProgress() async {
    await _shareService.shareProgress(
      completedTasksToday: completedToday,
      focusMinutesToday: focusMinutesToday,
    );
  }
}
