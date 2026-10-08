import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/motion.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ai_coach/application/ai_coach_state.dart';
import 'package:vireo/features/ai_coach/providers/ai_coach_provider.dart';
import 'package:vireo/features/ai_coach/widgets/chat_message_bubble.dart';
import 'package:vireo/features/ai_coach/widgets/typing_indicator.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_scan_budget_provider.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';

class AiCoachScreen extends ConsumerStatefulWidget {
  const AiCoachScreen({super.key});

  @override
  ConsumerState<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends ConsumerState<AiCoachScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focus = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: VMotion.base,
        curve: VMotion.standard,
      );
    });
  }

  Future<void> _send([String? preset]) async {
    final text = preset ?? _controller.text;
    if (text.trim().isEmpty) return;
    HapticFeedback.lightImpact();
    _controller.clear();
    await ref.read(aiCoachProvider.notifier).send(text);
    _scrollToBottom();
  }

  Future<void> _confirmClear() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.uxCoachNewChat),
        content: Text(l10n.uxCoachClearConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.uxCoachNewChat),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(aiCoachProvider.notifier).clearHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final coachAsync = ref.watch(aiCoachProvider);
    final coach = coachAsync.value ?? const AiCoachState();

    ref.listen(aiCoachProvider, (_, _) => _scrollToBottom());

    final suggestions = <(IconData, String)>[
      (Icons.dinner_dining_rounded, l10n.aiCoachChipDinner),
      (Icons.egg_alt_rounded, l10n.aiCoachChipProtein),
      (Icons.icecream_rounded, l10n.aiCoachChipDessert),
      (Icons.fitness_center_rounded, l10n.uxCoachChipWorkout),
    ];

    final isEmpty = coach.messages.isEmpty && !coach.isLoading;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            const CoachAvatar(size: 34),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.aiCoachTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: coach.isOffline ? colors.textMute : colors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        coach.isLoading
                            ? l10n.uxCoachTyping
                            : coach.isOffline
                                ? l10n.aiCoachOfflineBanner
                                : l10n.uxCoachOnline,
                        style: TextStyle(color: colors.textMute, fontSize: 11.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (coach.messages.isNotEmpty)
            IconButton(
              tooltip: l10n.uxCoachNewChat,
              onPressed: coach.isLoading ? null : _confirmClear,
              icon: const Icon(Icons.edit_square),
            ),
        ],
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
          if (coach.hitDailyLimit)
            MaterialBanner(
              content: Text(l10n.aiDailyLimitReached),
              backgroundColor: colors.ember.withValues(alpha: 0.12),
              actions: [
                TextButton(
                  onPressed: () => openPaywall(context),
                  child: Text(l10n.aiUpgradeCta),
                ),
              ],
            ),
          Expanded(
            child: coachAsync.isLoading && coach.messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : isEmpty
                    ? _EmptyCoach(
                        suggestions: suggestions,
                        onPick: (text) => _send(text),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.only(top: 12, bottom: 8),
                        itemCount: coach.messages.length + (coach.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= coach.messages.length) {
                            return const TypingIndicator();
                          }
                          final message = coach.messages[index];
                          return ChatMessageBubble(
                            key: ValueKey<String>(message.id),
                            message: message,
                            onRetry: message.failed
                                ? () => ref.read(aiCoachProvider.notifier).retryLast()
                                : null,
                          );
                        },
                      ),
          ),
          if (!isEmpty)
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: suggestions.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) => _SuggestionChip(
                  icon: suggestions[i].$1,
                  label: suggestions[i].$2,
                  onTap: coach.isLoading ? null : () => _send(suggestions[i].$2),
                ),
              ),
            ),
          _Composer(
            controller: _controller,
            focusNode: _focus,
            canSend: _hasText && !coach.isLoading,
            onSend: () => _send(),
          ),
        ],
      ),
    );
  }
}

class _EmptyCoach extends ConsumerWidget {
  const _EmptyCoach({required this.suggestions, required this.onPick});

  final List<(IconData, String)> suggestions;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final kcal = ref.watch(remainingCaloriesForAiScanProvider);
    final protein = ref.watch(remainingProteinForAiScanProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(VSpace.gutter, VSpace.xl, VSpace.gutter, VSpace.md),
      children: [
        const FadeSlideIn(child: Center(child: CoachAvatar(size: 76))),
        const SizedBox(height: VSpace.md),
        FadeSlideIn(
          index: 1,
          child: Text(
            l10n.uxCoachHeroTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
        const SizedBox(height: VSpace.xs),
        FadeSlideIn(
          index: 2,
          child: Text(
            l10n.uxCoachHeroBody,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.textMute, height: 1.4),
          ),
        ),
        const SizedBox(height: VSpace.md),
        FadeSlideIn(
          index: 3,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              VireoPill(
                icon: Icons.local_fire_department_rounded,
                label: l10n.uxCoachKcalLeft(kcal),
                color: colors.ember,
              ),
              VireoPill(
                icon: Icons.egg_alt_rounded,
                label: l10n.uxCoachProteinLeft(protein.round()),
                color: VMacro.protein,
              ),
            ],
          ),
        ),
        const SizedBox(height: VSpace.xl),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: VSpace.sm,
          crossAxisSpacing: VSpace.sm,
          childAspectRatio: 1.45,
          children: [
            for (var i = 0; i < suggestions.length; i++)
              FadeSlideIn(
                index: 4 + i,
                child: VireoCard(
                  onTap: () => onPick(suggestions[i].$2),
                  semanticLabel: suggestions[i].$2,
                  radius: VRadius.md,
                  padding: const EdgeInsets.all(VSpace.sm + 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(suggestions[i].$1, color: colors.ember, size: 22),
                      Text(
                        suggestions[i].$2,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(VRadius.pill),
          border: Border.all(color: colors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colors.ember),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.focusNode,
    required this.canSend,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool canSend;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
        child: Container(
          padding: const EdgeInsetsDirectional.only(start: 16, end: 6),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: colors.line),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  onSubmitted: canSend ? (_) => onSend() : null,
                  decoration: InputDecoration(
                    hintText: l10n.aiCoachInputHint,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: AnimatedContainer(
                  duration: VMotion.base,
                  curve: VMotion.standard,
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: canSend ? colors.ember : colors.surfaceRaised,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    tooltip: l10n.uxSend,
                    onPressed: canSend ? onSend : null,
                    icon: Icon(
                      Icons.arrow_upward_rounded,
                      color: canSend ? Colors.white : colors.textMute,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
