import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/features/ai_coach/domain/chat_message.dart';
import 'package:vireo/features/ai_coach/domain/i_ai_coach_service.dart';
import 'package:vireo/features/ai_coach/domain/user_context.dart';

class GeminiCoachService implements IAiCoachService {
  static const emptyResponseFallbackEn =
      'Sorry, connection error. Please try again.';
  static const emptyResponseFallbackAr =
      'عذراً، حدث خطأ في الاتصال. جرب مرة أخرى.';

  @override
  Future<String> sendMessage(
    List<ChatMessage> history,
    String userMessage,
    UserContext context, {
    String languageCode = 'ar',
  }) async {
    if (!SupabaseService.isInitialized) {
      throw const AiCoachOfflineException();
    }

    try {
      final trimmedHistory = history
          .where((m) => !m.failed && m.content.trim().isNotEmpty)
          .toList();
      // Keep last 20 turns for the Edge Function (matches server max).
      final recent = trimmedHistory.length > 20
          ? trimmedHistory.sublist(trimmedHistory.length - 20)
          : trimmedHistory;

      final response = await SupabaseService.client.functions.invoke(
        AppConfig.aiCoachChatFunctionName,
        body: {
          'history': [
            for (final m in recent)
              {
                'role': m.role == ChatMessageRole.user ? 'user' : 'assistant',
                'content': m.content,
              },
          ],
          'message': userMessage,
          'context': {
            'remainingCalories': context.remainingCalories,
            'remainingProtein': context.remainingProtein,
            'targetCalories': context.targetCalories,
            'targetProtein': context.targetProtein,
            'currentWeight': context.currentWeight,
            'goal': context.goal,
          },
          'language': languageCode,
        },
      );

      final data = response.data;
      final errorCode = data is Map ? data['error']?.toString() : null;

      if (response.status == 429 || errorCode == 'DAILY_LIMIT') {
        throw const AiCoachDailyLimitException();
      }
      if (response.status == 401 || errorCode == 'GEMINI_NOT_CONFIGURED') {
        throw const AiCoachConfigException();
      }
      if (response.status >= 400) {
        throw AiCoachApiException(errorCode ?? 'API_ERROR');
      }

      final reply = data is Map ? data['reply']?.toString().trim() : null;
      if (reply == null || reply.isEmpty) {
        return languageCode == 'ar'
            ? emptyResponseFallbackAr
            : emptyResponseFallbackEn;
      }
      return reply;
    } on AiCoachException {
      rethrow;
    } catch (e) {
      final text = e.toString().toLowerCase();
      if (text.contains('socket') ||
          text.contains('network') ||
          text.contains('connection') ||
          text.contains('failed host lookup') ||
          text.contains('offline') ||
          text.contains('not initialized')) {
        throw const AiCoachOfflineException();
      }
      throw AiCoachApiException(e.toString());
    }
  }
}
