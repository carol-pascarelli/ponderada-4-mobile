import 'package:flutter/material.dart';
import 'package:ponderada_4_mobile/src/models/task_model.dart';
import 'package:ponderada_4_mobile/src/screens/ai/study_plan_screen.dart';
import 'package:ponderada_4_mobile/src/screens/auth/login_screen.dart';
import 'package:ponderada_4_mobile/src/screens/auth/register_screen.dart';
import 'package:ponderada_4_mobile/src/screens/dashboard/dashboard_screen.dart';
import 'package:ponderada_4_mobile/src/screens/pomodoro/pomodoro_screen.dart';
import 'package:ponderada_4_mobile/src/screens/stats/stats_screen.dart';
import 'package:ponderada_4_mobile/src/screens/tasks/create_task_screen.dart';
import 'package:ponderada_4_mobile/src/screens/tasks/task_details_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String createTask = '/tasks/create';
  static const String taskDetails = '/tasks/details';
  static const String pomodoro = '/pomodoro';
  static const String studyPlan = '/study-plan';
  static const String stats = '/stats';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case createTask:
        final task = settings.arguments as TaskModel?;
        return MaterialPageRoute(
          builder: (_) => CreateTaskScreen(task: task),
        );
      case taskDetails:
        final task = settings.arguments as TaskModel;
        return MaterialPageRoute(
          builder: (_) => TaskDetailsScreen(task: task),
        );
      case pomodoro:
        return MaterialPageRoute(builder: (_) => const PomodoroScreen());
      case studyPlan:
        return MaterialPageRoute(builder: (_) => const StudyPlanScreen());
      case stats:
        return MaterialPageRoute(builder: (_) => const StatsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Rota não encontrada')),
          ),
        );
    }
  }
}
