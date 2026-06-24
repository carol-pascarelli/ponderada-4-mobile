import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ponderada_4_mobile/src/providers/focus_provider.dart';
import 'package:ponderada_4_mobile/src/providers/stats_provider.dart';
import 'package:ponderada_4_mobile/src/providers/task_provider.dart';
import 'package:ponderada_4_mobile/src/widgets/custom_button.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshStats());
  }

  void _refreshStats() {
    context.read<StatsProvider>().updateFromProviders(
          taskProvider: context.read<TaskProvider>(),
          focusProvider: context.read<FocusProvider>(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Estatísticas')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatCard(
            icon: Icons.check_circle_outline,
            label: 'Tarefas concluídas',
            value: '${stats.completedCount}',
            color: theme.colorScheme.primary,
          ),
          _StatCard(
            icon: Icons.pending_actions,
            label: 'Tarefas pendentes',
            value: '${stats.pendingCount}',
            color: theme.colorScheme.tertiary,
          ),
          _StatCard(
            icon: Icons.timer_outlined,
            label: 'Sessões Pomodoro',
            value: '${stats.pomodoroSessions}',
            color: theme.colorScheme.secondary,
          ),
          _StatCard(
            icon: Icons.hourglass_bottom,
            label: 'Tempo total de foco',
            value: '${stats.totalFocusMinutes} min',
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 24),
          CustomButton(
            label: 'Compartilhar progresso',
            icon: Icons.share,
            onPressed: () async {
              _refreshStats();
              await context.read<StatsProvider>().shareProgress();
            },
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(label),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
