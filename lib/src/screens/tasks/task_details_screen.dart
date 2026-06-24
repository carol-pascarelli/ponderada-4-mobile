import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ponderada_4_mobile/src/core/routes/app_routes.dart';
import 'package:ponderada_4_mobile/src/models/task_model.dart';
import 'package:ponderada_4_mobile/src/providers/task_provider.dart';
import 'package:ponderada_4_mobile/src/widgets/custom_button.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key, required this.task});

  final TaskModel task;

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late TaskModel _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  Future<void> _toggleComplete() async {
    final success = await context.read<TaskProvider>().toggleComplete(_task);
    if (!mounted) return;

    if (success) {
      setState(() => _task = _task.copyWith(completed: !_task.completed));
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir tarefa'),
        content: const Text('Deseja realmente excluir esta tarefa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success =
        await context.read<TaskProvider>().deleteTask(_task.id);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    }
  }

  Future<void> _openInMaps() async {
    if (!_task.hasLocation) return;

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query='
      '${_task.latitude},${_task.longitude}',
    );

    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o mapa.')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao tentar abrir aplicativo de mapas.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final taskProvider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da tarefa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // Aguarda o retorno do objeto modificado vindo da CreateTaskScreen
              final updatedTask = await Navigator.pushNamed(
                context,
                AppRoutes.createTask,
                arguments: _task,
              );

              if (updatedTask != null && updatedTask is TaskModel && mounted) {
                setState(() {
                  _task = updatedTask;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _task.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                decoration:
                    _task.completed ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text(_task.completed ? 'Concluída' : 'Pendente'),
                avatar: Icon(
                  _task.completed ? Icons.check_circle : Icons.pending,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _DetailRow(
              icon: Icons.notes,
              label: 'Descrição',
              value: _task.description.isEmpty
                  ? 'Sem descrição'
                  : _task.description,
            ),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.schedule,
              label: 'Prazo',
              value: dateFormat.format(_task.dueDate),
            ),
            if (_task.hasLocation) ...[
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.location_on,
                label: 'Local',
                value: _task.locationLabel ??
                    '${_task.latitude!.toStringAsFixed(5)}, '
                    '${_task.longitude!.toStringAsFixed(5)}',
              ),
              const SizedBox(height: 12),
              CustomButton(
                label: 'Abrir no mapa',
                outlined: true,
                icon: Icons.map_outlined,
                onPressed: _openInMaps,
              ),
            ],
            const Spacer(),
            CustomButton(
              label: _task.completed ? 'Marcar como pendente' : 'Concluir tarefa',
              icon: _task.completed ? Icons.undo : Icons.check,
              onPressed: taskProvider.isLoading ? null : _toggleComplete,
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Excluir tarefa',
              outlined: true,
              icon: Icons.delete_outline,
              onPressed: taskProvider.isLoading ? null : _delete,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              Text(value),
            ],
          ),
        ),
      ],
    );
  }
}