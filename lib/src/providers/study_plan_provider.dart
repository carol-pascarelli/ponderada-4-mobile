import 'package:flutter/foundation.dart';
import 'package:ponderada_4_mobile/src/services/gemini_service.dart';

class StudyPlanProvider extends ChangeNotifier {
  StudyPlanProvider({required GeminiService geminiService})
      : _geminiService = geminiService;

  final GeminiService _geminiService;

  bool _isLoading = false;
  String? _plan;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get plan => _plan;
  String? get errorMessage => _errorMessage;

  Future<bool> generatePlan(String prompt) async {
    if (prompt.trim().isEmpty) {
      _errorMessage = 'Descreva o que você precisa estudar.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    _plan = null;
    notifyListeners();

    try {
      _plan = await _geminiService.generateStudyPlan(prompt.trim());
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _plan = null;
    _errorMessage = null;
    notifyListeners();
  }
}
