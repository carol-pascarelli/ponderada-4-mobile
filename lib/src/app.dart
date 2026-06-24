import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ponderada_4_mobile/src/core/constants/app_constants.dart';
import 'package:ponderada_4_mobile/src/core/routes/app_routes.dart';
import 'package:ponderada_4_mobile/src/core/theme/app_theme.dart';
import 'package:ponderada_4_mobile/src/providers/auth_provider.dart';
import 'package:ponderada_4_mobile/src/providers/focus_provider.dart';
import 'package:ponderada_4_mobile/src/providers/stats_provider.dart';
import 'package:ponderada_4_mobile/src/providers/study_plan_provider.dart';
import 'package:ponderada_4_mobile/src/providers/task_provider.dart';
import 'package:ponderada_4_mobile/src/repositories/auth_repository.dart';
import 'package:ponderada_4_mobile/src/repositories/focus_repository.dart';
import 'package:ponderada_4_mobile/src/repositories/task_repository.dart';
import 'package:ponderada_4_mobile/src/services/gemini_service.dart';
import 'package:ponderada_4_mobile/src/services/notification_service.dart';
import 'package:ponderada_4_mobile/src/services/share_service.dart';
import 'package:ponderada_4_mobile/src/widgets/auth_gate.dart';

class RemindersApp extends StatelessWidget {
  const RemindersApp({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationService = NotificationService();
    final authRepository = AuthRepository();
    final taskRepository =
        TaskRepository(notificationService: notificationService);
    final focusRepository = FocusRepository();
    final geminiService = GeminiService();
    final shareService = ShareService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository: authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => TaskProvider(taskRepository: taskRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => FocusProvider(
            focusRepository: focusRepository,
            notificationService: notificationService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => StudyPlanProvider(geminiService: geminiService),
        ),
        ChangeNotifierProvider(
          create: (_) => StatsProvider(shareService: shareService),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const AuthGate(),
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
