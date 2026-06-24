import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ponderada_4_mobile/src/models/task_model.dart';
import 'package:ponderada_4_mobile/src/providers/auth_provider.dart';
import 'package:ponderada_4_mobile/src/providers/task_provider.dart';
import 'package:ponderada_4_mobile/src/services/location_service.dart';
import 'package:ponderada_4_mobile/src/widgets/custom_button.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key, this.task});

  final TaskModel? task;

  bool get isEditing => task != null;

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late DateTime _dueDate;
  late TimeOfDay _dueTime;
  double? _latitude;
  double? _longitude;
  String? _locationLabel;
  bool _isCapturingLocation = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');

    final initial =
        widget.task?.dueDate ?? DateTime.now().add(const Duration(hours: 1));
    _dueDate = DateTime(initial.year, initial.month, initial.day);
    _dueTime = TimeOfDay(hour: initial.hour, minute: initial.minute);

    _latitude = widget.task?.latitude;
    _longitude = widget.task?.longitude;
    _locationLabel = widget.task?.locationLabel;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  DateTime get _combinedDueDate => DateTime(
        _dueDate.year,
        _dueDate.month,
        _dueDate.day,
        _dueTime.hour,
        _dueTime.minute,
      );

  bool get _hasLocation => _latitude != null && _longitude != null;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dueTime,
    );
    if (picked != null) {
      setState(() => _dueTime = picked);
    }
  }

  Future<void> _captureLocation() async {
    setState(() => _isCapturingLocation = true);

    try {
      final location = await LocationService().getCurrentLocation();
      if (!mounted) return;

      setState(() {
        _latitude = location.latitude;
        _longitude = location.longitude;
        _locationLabel = location.label ??
            '${location.latitude.toStringAsFixed(4)}, '
            '${location.longitude.toStringAsFixed(4)}';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Localização capturada com sucesso!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) setState(() => _isCapturingLocation = false);
    }
  }

  void _clearLocation() {
    setState(() {
      _latitude = null;
      _longitude = null;
      _locationLabel = null;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final taskProvider = context.read<TaskProvider>();
    final userId = context.read<AuthProvider>().user?.uid;

    if (userId == null) return;

    bool success;
    TaskModel? targetTask;

    if (widget.isEditing) {
      targetTask = widget.task!.copyWith(
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _combinedDueDate,
        latitude: _latitude,
        longitude: _longitude,
        locationLabel: _locationLabel,
        clearLocation: !_hasLocation,
      );
      success = await taskProvider.updateTask(targetTask);
    } else {
      // Cria uma estrutura temporária para retorno caso seu provider não retorne o objeto criado
      targetTask = TaskModel(
        id: '',
        userId: userId,
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _combinedDueDate,
        latitude: _latitude,
        longitude: _longitude,
        locationLabel: _locationLabel,
        completed: false,
      );
      success = await taskProvider.createTask(
        userId: userId,
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _combinedDueDate,
        latitude: _latitude,
        longitude: _longitude,
        locationLabel: _locationLabel,
      );
    }

    if (!mounted) return;

    if (success) {
      // Retorna true ou o objeto modificado para a tela anterior atualizar
      Navigator.pop(context, targetTask);
    } else if (taskProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(taskProvider.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Editar tarefa' : 'Nova tarefa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: Icon(Icons.notes),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: const Text('Data'),
                subtitle: Text(
                  '${_dueDate.day.toString().padLeft(2, '0')}/'
                  '${_dueDate.month.toString().padLeft(2, '0')}/'
                  '${_dueDate.year}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: _pickDate,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.access_time),
                title: const Text('Horário'),
                subtitle: Text(_dueTime.format(context)),
                trailing: const Icon(Icons.chevron_right),
                onTap: _pickTime,
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Local do lembrete',
                            style: theme.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Use o GPS para associar um local à tarefa '
                        '(ex: biblioteca, sala de aula).',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (_hasLocation) ...[
                        const SizedBox(height: 12),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.place),
                          title: Text(_locationLabel ?? 'Local capturado'),
                          subtitle: Text(
                            '${_latitude!.toStringAsFixed(5)}, '
                            '${_longitude!.toStringAsFixed(5)}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: _clearLocation,
                            tooltip: 'Remover localização',
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      CustomButton(
                        label: _hasLocation
                            ? 'Atualizar localização (GPS)'
                            : 'Capturar localização (GPS)',
                        icon: Icons.my_location,
                        isLoading: _isCapturingLocation,
                        outlined: _hasLocation,
                        onPressed:
                            _isCapturingLocation ? null : _captureLocation,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: widget.isEditing ? 'Salvar alterações' : 'Criar tarefa',
                isLoading: taskProvider.isLoading,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}