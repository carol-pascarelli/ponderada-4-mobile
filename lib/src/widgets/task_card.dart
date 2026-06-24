import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ponderada_4_mobile/src/models/task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.onToggleComplete,
  });

  final TaskModel task;
  final VoidCallback onTap;
  final VoidCallback? onToggleComplete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (onToggleComplete != null)
                Checkbox(
                  value: task.completed,
                  onChanged: (_) => onToggleComplete?.call(),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration:
                            task.completed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (task.hasLocation) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              task.locationLabel ?? 'Local definido',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateFormat.format(task.dueDate),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                task.completed ? Icons.check_circle : Icons.chevron_right,
                color: task.completed
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
