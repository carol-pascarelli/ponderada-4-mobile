import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ponderada_4_mobile/src/providers/focus_provider.dart';
import 'package:ponderada_4_mobile/src/widgets/custom_button.dart';

class PomodoroScreen extends StatelessWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final focus = context.watch<FocusProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primaryContainer,
              ),
              alignment: Alignment.center,
              child: Text(
                focus.formattedTime,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              focus.isRunning
                  ? 'Mantenha o foco!'
                  : 'Sessão de 25 minutos',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${focus.sessions.length} sessões concluídas',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: focus.isRunning ? 'Pausar' : 'Iniciar',
                    icon: focus.isRunning ? Icons.pause : Icons.play_arrow,
                    onPressed: focus.isRunning ? focus.pause : focus.start,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    label: 'Reiniciar',
                    outlined: true,
                    icon: Icons.refresh,
                    onPressed: focus.reset,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
