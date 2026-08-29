import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/ai_coach/application/ai_coach_state.dart';
import 'package:vireo/features/ai_coach/data/ai_coach_history_store.dart';
import 'package:vireo/features/ai_coach/data/gemini_coach_service.dart';
import 'package:vireo/features/ai_coach/domain/chat_message.dart';
import 'package:vireo/features/ai_coach/domain/i_ai_coach_service.dart';
import 'package:vireo/features/ai_coach/providers/ai_coach_context_provider.dart';

final aiCoachServiceProvider = Provider<IAiCoachService>(
  (ref) => GeminiCoachService(),
);

class AiCoachNotifier extends AsyncNotifier<AiCoachState> {
  @override
  Future<AiCoachState> build() async {
    final messages = AiCoachHistoryStore.load();
    return AiCoachState(messages: messages);
  }

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.valueOrNull?.isLoading == true) return;

    final current = state.valueOrNull ?? const AiCoachState();
    final userMsg = userMessage(trimmed);
    final withUser = [...current.messages, userMsg];

    state = AsyncValue.data(
      current.copyWith(
        messages: withUser,
        status: AiCoachStatus.loading,
        isOffline: false,
        pendingUserText: trimmed,
      ),
    );

    await _completeSend(withUser, trimmed);
  }

  Future<void> retryLast() async {
    final current = state.valueOrNull;
    if (current == null) return;

    final pending = current.pendingUserText;
    if (pending == null || pending.isEmpty) return;

    final withoutFailed = current.messages.where((m) => !m.failed).toList();

    state = AsyncValue.data(
      current.copyWith(
        messages: withoutFailed,
        status: AiCoachStatus.loading,
        isOffline: false,
      ),
    );

    await _completeSend(withoutFailed, pending);
  }

  Future<void> _completeSend(List<ChatMessage> history, String userText) async {
    final context = ref.read(aiCoachUserContextProvider);

    try {
      final reply = await ref.read(aiCoachServiceProvider).sendMessage(
            history,
            userText,
            context,
          );

      final nextMessages = [
        ...history,
        assistantMessage(reply),
      ];

      state = AsyncValue.data(
        AiCoachState(
          messages: nextMessages,
          status: AiCoachStatus.idle,
        ),
      );
      await AiCoachHistoryStore.save(nextMessages);
    } on AiCoachOfflineException {
      final failed = [
        ...history,
        assistantMessage(
          'حدث خطأ، اضغط لإعادة المحاولة',
          type: ChatMessageType.warning,
          failed: true,
        ),
      ];
      state = AsyncValue.data(
        AiCoachState(
          messages: failed,
          status: AiCoachStatus.error,
          isOffline: true,
          pendingUserText: userText,
        ),
      );
      await AiCoachHistoryStore.save(history);
    } on AiCoachException {
      final failed = [
        ...history,
        assistantMessage(
          'حدث خطأ، اضغط لإعادة المحاولة',
          type: ChatMessageType.warning,
          failed: true,
        ),
      ];
      state = AsyncValue.data(
        AiCoachState(
          messages: failed,
          status: AiCoachStatus.error,
          pendingUserText: userText,
        ),
      );
      await AiCoachHistoryStore.save(history);
    } catch (_) {
      final failed = [
        ...history,
        assistantMessage(
          'حدث خطأ، اضغط لإعادة المحاولة',
          type: ChatMessageType.warning,
          failed: true,
        ),
      ];
      state = AsyncValue.data(
        AiCoachState(
          messages: failed,
          status: AiCoachStatus.error,
          pendingUserText: userText,
        ),
      );
      await AiCoachHistoryStore.save(history);
    }
  }
}

final aiCoachProvider =
    AsyncNotifierProvider<AiCoachNotifier, AiCoachState>(AiCoachNotifier.new);

final aiCoachPhaseProvider = Provider<AiCoachState>((ref) {
  return ref.watch(aiCoachProvider).value ?? const AiCoachState();
});
