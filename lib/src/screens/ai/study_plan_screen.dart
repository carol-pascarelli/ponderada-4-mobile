import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ponderada_4_mobile/src/providers/study_plan_provider.dart';
import 'package:ponderada_4_mobile/src/widgets/custom_button.dart';
import 'package:ponderada_4_mobile/src/widgets/loading_widget.dart';

class StudyPlanScreen extends StatefulWidget {
  const StudyPlanScreen({super.key});

  @override
  State<StudyPlanScreen> createState() => _StudyPlanScreenState();
}

class _StudyPlanScreenState extends State<StudyPlanScreen> {
  final _promptController = TextEditingController(
    text: 'Tenho prova de Flutter em 5 dias',
  );

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final provider = context.read<StudyPlanProvider>();
    final success = await provider.generatePlan(_promptController.text);

    if (!mounted) return;

    if (!success && provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudyPlanProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Plano de estudos com IA')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _promptController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'O que você precisa estudar?',
                    hintText: 'Ex: Tenho prova de Flutter em 5 dias',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  label: 'Gerar plano',
                  icon: Icons.auto_awesome,
                  isLoading: provider.isLoading,
                  onPressed: _generate,
                ),
              ],
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const LoadingWidget(message: 'Gerando plano de estudos...')
                : provider.plan == null
                    ? Center(
                        child: Text(
                          'Informe seu objetivo e toque em "Gerar plano".',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: SelectableText(
                              provider.plan!,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
