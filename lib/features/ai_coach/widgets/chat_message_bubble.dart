import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
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
    final colors = context.vireoColors;
    final isUser = message.role == ChatMessageRole.user;

    final bubbleColor = isUser
        ? const Color(0xFF5BA4F5)
        : message.type == ChatMessageType.warning
            ? colors.gold.withValues(alpha: 0.15)
            : colors.surfaceRaised;

    final textColor = isUser ? Colors.white : colors.text;
    final align =
        isUser ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart;
    final margin = isUser
        ? const EdgeInsetsDirectional.only(start: 48, end: 16, bottom: 8)
        : const EdgeInsetsDirectional.only(start: 16, end: 48, bottom: 8);

    return Align(
      alignment: align,
      child: GestureDetector(
        onTap: message.failed ? onRetry : null,
        child: Container(
          margin: margin,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isUser ? 16 : 4),
              bottomRight: Radius.circular(isUser ? 4 : 16),
            ),
            border: message.failed
                ? Border.all(color: colors.danger.withValues(alpha: 0.5))
                : isUser
                    ? null
                    : Border.all(color: colors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.type == ChatMessageType.macroTip)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.insights_outlined, size: 16, color: colors.ember),
                ),
              Text(
                message.content,
                style: TextStyle(color: textColor, height: 1.35),
              ),
              if (message.failed)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '↻',
                    style: TextStyle(color: colors.danger, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
