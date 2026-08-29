import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/config/vireo_ai_prompts.dart';
import 'package:vireo/features/ai_coach/domain/chat_message.dart';
import 'package:vireo/features/ai_coach/domain/i_ai_coach_service.dart';
import 'package:vireo/features/ai_coach/domain/user_context.dart';

class GeminiCoachService implements IAiCoachService {
  GeminiCoachService({String? apiKey}) : _apiKey = apiKey ?? AppConfig.geminiApiKey;

  final String _apiKey;

  static const _modelName = 'gemini-1.5-flash';

  @override
  Future<String> sendMessage(
    List<ChatMessage> history,
    String userMessage,
    UserContext context,
  ) async {
    if (_apiKey.isEmpty) {
      throw const AiCoachConfigException();
    }

    try {
      final systemInstruction = Content.system('''
${VireoAiPrompts.coachSystemPrompt}

${VireoAiPrompts.coachContextBlock(
  remainingCalories: context.remainingCalories,
  remainingProtein: context.remainingProtein,
  targetCalories: context.targetCalories,
  targetProtein: context.targetProtein,
  currentWeight: context.currentWeight,
  goal: context.goal,
)}''');

      final model = GenerativeModel(
        model: _modelName,
        apiKey: _apiKey,
        systemInstruction: systemInstruction,
        generationConfig: GenerationConfig(temperature: 0.7),
      );

      final chat = model.startChat(
        history: _toGeminiHistory(history),
      );

      final response = await chat.sendMessage(Content.text(userMessage));
      final text = response.text?.trim();
      if (text == null || text.isEmpty) {
        throw const AiCoachApiException('EMPTY_RESPONSE');
      }
      return text;
    } on AiCoachException {
      rethrow;
    } on GenerativeAIException catch (e) {
      final msg = e.message.toLowerCase();
      if (msg.contains('network') ||
          msg.contains('connection') ||
          msg.contains('offline') ||
          msg.contains('fetch')) {
        throw const AiCoachOfflineException();
      }
      throw AiCoachApiException(e.message);
    } catch (e) {
      if (e is AiCoachException) rethrow;
      final text = e.toString().toLowerCase();
      if (text.contains('socket') ||
          text.contains('network') ||
          text.contains('connection') ||
          text.contains('failed host lookup')) {
        throw const AiCoachOfflineException();
      }
      throw AiCoachApiException(e.toString());
    }
  }

  List<Content> _toGeminiHistory(List<ChatMessage> history) {
    return history
        .where((m) => !m.failed && m.content.trim().isNotEmpty)
        .map(
          (m) => Content(
            m.role == ChatMessageRole.user ? 'user' : 'model',
            [TextPart(m.content)],
          ),
        )
        .toList();
  }
}
