import 'package:vireo/features/ai_coach/domain/chat_message.dart';
import 'package:vireo/features/ai_coach/domain/user_context.dart';

sealed class AiCoachException implements Exception {
  const AiCoachException(this.message);
  final String message;

  @override
  String toString() => message;
}

final class AiCoachOfflineException extends AiCoachException {
  const AiCoachOfflineException() : super('OFFLINE');
}

final class AiCoachApiException extends AiCoachException {
  const AiCoachApiException([super.message = 'API_ERROR']);
}

final class AiCoachConfigException extends AiCoachException {
  const AiCoachConfigException() : super('CONFIG_ERROR');
}

abstract class IAiCoachService {
  Future<String> sendMessage(
    List<ChatMessage> history,
    String userMessage,
    UserContext context,
  );
}
