import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/motion.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ai_coach/domain/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    this.onRetry,
  });

  final ChatMessage message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final isUser = message.role == ChatMessageRole.user;
    final isWarning = message.type == ChatMessageType.warning;

    const r = Radius.circular(20);
    const tail = Radius.circular(6);
    final radius = BorderRadiusDirectional.only(
      topStart: r,
      topEnd: r,
      bottomStart: isUser ? r : tail,
      bottomEnd: isUser ? tail : r,
    );

    final bubble = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        gradient: isUser
            ? LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [
                  Color.lerp(colors.ember, Colors.white, 0.08)!,
                  Color.lerp(colors.ember, Colors.black, 0.12)!,
                ],
              )
            : null,
        color: isUser
            ? null
            : isWarning
                ? colors.gold.withValues(alpha: 0.12)
                : colors.surface,
        borderRadius: radius,
        border: message.failed
            ? Border.all(color: colors.danger.withValues(alpha: 0.6))
            : isUser
                ? null
                : Border.all(color: colors.line.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message.type == ChatMessageType.macroTip)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Icon(Icons.insights_rounded, size: 16, color: colors.ember),
            ),
          Text(
            message.content,
            style: TextStyle(
              color: isUser ? Colors.white : colors.text,
              height: 1.45,
              fontSize: 14.5,
            ),
          ),
          if (message.failed)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh_rounded, size: 16, color: colors.danger),
                  const SizedBox(width: 4),
                  Text(
                    l10n.aiScanTryAgain,
                    style: TextStyle(
                      color: colors.danger,
                      fontWeight: FontWeight.w800,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );

    return FadeSlideIn(
      offset: 10,
      onceId: 'chat_${message.id}',
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: isUser ? 56 : 12,
          end: isUser ? 12 : 48,
          bottom: 10,
        ),
        child: Row(
          mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isUser) ...[
              const CoachAvatar(size: 28),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: GestureDetector(
                onTap: message.failed ? onRetry : null,
                onLongPress: () {
                  HapticFeedback.mediumImpact();
                  Clipboard.setData(ClipboardData(text: message.content));
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(l10n.uxCopied)));
                },
                child: bubble,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gradient orb that represents Vireo AI across the app.
class CoachAvatar extends StatelessWidget {
  const CoachAvatar({super.key, this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [VMacro.ai, colors.ember],
        ),
        boxShadow: [
          BoxShadow(
            color: VMacro.ai.withValues(alpha: 0.35),
            blurRadius: size / 2,
            spreadRadius: -size / 8,
          ),
        ],
      ),
      child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: size * 0.5),
    );
  }
}
