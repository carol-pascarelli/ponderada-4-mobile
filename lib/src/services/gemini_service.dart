import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ponderada_4_mobile/src/core/constants/app_constants.dart';
import 'package:ponderada_4_mobile/src/core/constants/env_constants.dart';

class GeminiService {
  GeminiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<String> generateStudyPlan(String userPrompt) async {
    if (!EnvConstants.hasGeminiApiKey) {
      throw Exception(
        'Chave da Gemini API não configurada. '
        'Execute com: flutter run --dart-define=GEMINI_API_KEY=sua_chave',
      );
    }

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/'
      '${AppConstants.geminiModel}:generateContent?key=${EnvConstants.geminiApiKey}',
    );

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {
              'text':
                  'Você é um assistente de estudos. Crie um plano de estudos '
                  'detalhado, organizado por dias, com tópicos e dicas práticas. '
                  'Responda em português brasileiro, de forma clara e formatada.\n\n'
                  'Pedido do estudante: $userPrompt',
            },
          ],
        },
      ],
    });

    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao gerar plano (${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = data['candidates'] as List<dynamic>?;

    if (candidates == null || candidates.isEmpty) {
      throw Exception('A IA não retornou um plano de estudos.');
    }

    final content = candidates.first['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;

    if (parts == null || parts.isEmpty) {
      throw Exception('Resposta da IA vazia.');
    }

    return parts.first['text'] as String? ?? 'Plano gerado sem conteúdo.';
  }
}
