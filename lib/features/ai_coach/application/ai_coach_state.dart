import 'package:vireo/features/ai_coach/domain/chat_message.dart';

enum AiCoachStatus { idle, loading, error }

class AiCoachState {
  const AiCoachState({
    this.messages = const [],
    this.status = AiCoachStatus.idle,
    this.isOffline = false,
    this.pendingUserText,
  });

  final List<ChatMessage> messages;
  final AiCoachStatus status;
  final bool isOffline;
  final String? pendingUserText;

  bool get isLoading => status == AiCoachStatus.loading;
  bool get hasError => status == AiCoachStatus.error;

  AiCoachState copyWith({
    List<ChatMessage>? messages,
    AiCoachStatus? status,
    bool? isOffline,
    String? pendingUserText,
    bool clearPending = false,
  }) {
    return AiCoachState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      isOffline: isOffline ?? this.isOffline,
      pendingUserText:
          clearPending ? null : (pendingUserText ?? this.pendingUserText),
    );
  }
}

ChatMessage userMessage(String text) => ChatMessage(
      id: 'user_${DateTime.now().microsecondsSinceEpoch}',
      role: ChatMessageRole.user,
      content: text.trim(),
      timestamp: DateTime.now(),
    );

ChatMessage assistantMessage(String text, {ChatMessageType type = ChatMessageType.text, bool failed = false}) =>
    ChatMessage(
      id: 'assistant_${DateTime.now().microsecondsSinceEpoch}',
      role: ChatMessageRole.assistant,
      content: text,
      timestamp: DateTime.now(),
      type: type,
      failed: failed,
    );
