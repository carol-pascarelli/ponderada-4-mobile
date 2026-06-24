class EnvConstants {
  EnvConstants._();

  /// Defina ao executar: flutter run --dart-define=GEMINI_API_KEY=sua_chave
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

  static bool get hasGeminiApiKey => geminiApiKey.isNotEmpty;
}
