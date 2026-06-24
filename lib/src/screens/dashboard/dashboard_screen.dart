import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ponderada_4_mobile/src/core/routes/app_routes.dart';
import 'package:ponderada_4_mobile/src/providers/auth_provider.dart';
import 'package:ponderada_4_mobile/src/providers/focus_provider.dart';
import 'package:ponderada_4_mobile/src/providers/task_provider.dart';
import 'package:ponderada_4_mobile/src/widgets/task_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.uid;
      if (userId != null) {
        context.read<TaskProvider>().listenToTasks(userId);
        context.read<FocusProvider>().listenToSessions(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final taskProvider = context.watch<TaskProvider>();
    final theme = Theme.of(context);
    final pendingTasks = taskProvider.pendingTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              taskProvider.stopListening();
              context.read<FocusProvider>().stopListening();
              await auth.logout();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final userId = auth.user?.uid;
          if (userId != null) {
            context.read<TaskProvider>().listenToTasks(userId);
            context.read<FocusProvider>().listenToSessions(userId);
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Olá, ${auth.user?.name ?? 'Estudante'}!',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Você tem ${pendingTasks.length} tarefa(s) pendente(s)',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _ActionChip(
                  icon: Icons.add_task,
                  label: 'Nova tarefa',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.createTask),
                ),
                _ActionChip(
                  icon: Icons.timer_outlined,
                  label: 'Pomodoro',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.pomodoro),
                ),
                _ActionChip(
                  icon: Icons.auto_awesome,
                  label: 'Plano com IA',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.studyPlan),
                ),
                _ActionChip(
                  icon: Icons.bar_chart,
                  label: 'Estatísticas',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.stats),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Tarefas pendentes',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (pendingTasks.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.task_alt,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      const Text('Nenhuma tarefa pendente. Ótimo trabalho!'),
                    ],
                  ),
                ),
              )
            else
              ...pendingTasks.take(5).map(
                    (task) => TaskCard(
                      task: task,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.taskDetails,
                        arguments: task,
                      ),
                      onToggleComplete: () => taskProvider.toggleComplete(task),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.createTask),
        icon: const Icon(Icons.add),
        label: const Text('Nova tarefa'),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }
}
