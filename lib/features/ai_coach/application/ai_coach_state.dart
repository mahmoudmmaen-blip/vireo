import 'package:vireo/features/ai_coach/domain/chat_message.dart';

enum AiCoachStatus { idle, loading, error }

class AiCoachState {
  const AiCoachState({
    this.messages = const [],
    this.status = AiCoachStatus.idle,
    this.isOffline = false,
    this.pendingUserText,
    this.failedMessageId,
    this.errorMessage,
    this.hitDailyLimit = false,
  });

  final List<ChatMessage> messages;
  final AiCoachStatus status;
  final bool isOffline;
  final String? pendingUserText;
  final String? failedMessageId;
  final String? errorMessage;
  final bool hitDailyLimit;

  bool get isLoading => status == AiCoachStatus.loading;
  bool get hasError => status == AiCoachStatus.error;

  AiCoachState copyWith({
    List<ChatMessage>? messages,
    AiCoachStatus? status,
    bool? isOffline,
    String? pendingUserText,
    String? failedMessageId,
    String? errorMessage,
    bool? hitDailyLimit,
    bool clearPending = false,
    bool clearError = false,
  }) {
    return AiCoachState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      isOffline: isOffline ?? this.isOffline,
      pendingUserText:
          clearPending ? null : (pendingUserText ?? this.pendingUserText),
      failedMessageId:
          clearError ? null : (failedMessageId ?? this.failedMessageId),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      hitDailyLimit: hitDailyLimit ?? this.hitDailyLimit,
    );
  }
}

ChatMessage userMessage(String text) => ChatMessage(
      id: 'user_${DateTime.now().microsecondsSinceEpoch}',
      role: ChatMessageRole.user,
      content: text.trim(),
      timestamp: DateTime.now(),
    );

ChatMessage assistantMessage(
  String text, {
  ChatMessageType type = ChatMessageType.text,
  bool failed = false,
}) =>
    ChatMessage(
      id: 'assistant_${DateTime.now().microsecondsSinceEpoch}',
      role: ChatMessageRole.assistant,
      content: text,
      timestamp: DateTime.now(),
      type: type,
      failed: failed,
    );
