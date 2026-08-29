import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/ai_coach/domain/chat_message.dart';

const _historyKey = 'ai_chat_history';
const _maxMessages = 50;

abstract final class AiCoachHistoryStore {
  static List<ChatMessage> load() {
    if (!HiveService.isInitialized) return const [];
    final raw = HiveService.cacheBox.get(_historyKey);
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => ChatMessage.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  static Future<void> save(List<ChatMessage> messages) async {
    if (!HiveService.isInitialized) return;
    final trimmed = messages.length > _maxMessages
        ? messages.sublist(messages.length - _maxMessages)
        : messages;
    await HiveService.cacheBox.put(
      _historyKey,
      trimmed.map((m) => m.toJson()).toList(),
    );
  }
}
