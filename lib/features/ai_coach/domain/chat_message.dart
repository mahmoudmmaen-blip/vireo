import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

enum ChatMessageRole {
  @JsonValue('user')
  user,
  @JsonValue('assistant')
  assistant,
}

enum ChatMessageType {
  @JsonValue('text')
  text,
  @JsonValue('macro_tip')
  macroTip,
  @JsonValue('warning')
  warning,
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required ChatMessageRole role,
    required String content,
    required DateTime timestamp,
    @Default(ChatMessageType.text) ChatMessageType type,
    @Default(false) bool failed,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
