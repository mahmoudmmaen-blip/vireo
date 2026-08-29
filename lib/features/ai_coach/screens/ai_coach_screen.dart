import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/ai_coach/application/ai_coach_state.dart';
import 'package:vireo/features/ai_coach/providers/ai_coach_provider.dart';
import 'package:vireo/features/ai_coach/widgets/chat_message_bubble.dart';
import 'package:vireo/features/ai_coach/widgets/typing_indicator.dart';

class AiCoachScreen extends ConsumerStatefulWidget {
  const AiCoachScreen({super.key});

  @override
  ConsumerState<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends ConsumerState<AiCoachScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send([String? preset]) async {
    final text = preset ?? _controller.text;
    if (text.trim().isEmpty) return;
    _controller.clear();
    await ref.read(aiCoachProvider.notifier).send(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final coachAsync = ref.watch(aiCoachProvider);
    final coach = coachAsync.value ?? const AiCoachState();

    ref.listen(aiCoachProvider, (_, _) => _scrollToBottom());

    final quickChips = [
      l10n.aiCoachChipDinner,
      l10n.aiCoachChipProtein,
      l10n.aiCoachChipDessert,
    ];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.aiCoachTitle),
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: coach.isOffline ? colors.textMute : colors.success,
                shape: BoxShape.circle,
                boxShadow: coach.isOffline
                    ? null
                    : [
                        BoxShadow(
                          color: colors.success.withValues(alpha: 0.6),
                          blurRadius: 6,
                        ),
                      ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (coach.isOffline)
            MaterialBanner(
              content: Text(l10n.aiCoachOfflineBanner),
              backgroundColor: colors.gold.withValues(alpha: 0.15),
              actions: [
                TextButton(
                  onPressed: () => ref.read(aiCoachProvider.notifier).retryLast(),
                  child: Text(l10n.aiScanTryAgain),
                ),
              ],
            ),
          Expanded(
            child: coachAsync.isLoading && coach.messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: coach.messages.length + (coach.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= coach.messages.length) {
                        return const TypingIndicator();
                      }
                      final message = coach.messages[index];
                      return ChatMessageBubble(
                        message: message,
                        onRetry: message.failed
                            ? () => ref.read(aiCoachProvider.notifier).retryLast()
                            : null,
                      );
                    },
                  ),
          ),
          SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: quickChips.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      return ActionChip(
                        label: Text(quickChips[i]),
                        onPressed: coach.isLoading ? null : () => _send(quickChips[i]),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          maxLines: 3,
                          minLines: 1,
                          textInputAction: TextInputAction.send,
                          onSubmitted: coach.isLoading ? null : (_) => _send(),
                          decoration: InputDecoration(
                            hintText: l10n.aiCoachInputHint,
                            filled: true,
                            fillColor: colors.surfaceRaised,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: colors.line),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: coach.isLoading ? null : () => _send(),
                        icon: const Icon(Icons.send_rounded),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
