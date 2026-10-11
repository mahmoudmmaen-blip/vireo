import 'dart:io';
import 'dart:ui' as ui show ImageByteFormat;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

class SocialShareCardHelper {
  static Future<void> showBadgeShareSheet({
    required BuildContext context,
    required String title,
    required String description,
    required String icon,
    required bool isArabic,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BadgeShareSheet(
        title: title,
        description: description,
        icon: icon,
        isArabic: isArabic,
      ),
    );
  }
}

class _BadgeShareSheet extends StatefulWidget {
  const _BadgeShareSheet({
    required this.title,
    required this.description,
    required this.icon,
    required this.isArabic,
  });

  final String title;
  final String description;
  final String icon;
  final bool isArabic;

  @override
  State<_BadgeShareSheet> createState() => _BadgeShareSheetState();
}

class _BadgeShareSheetState extends State<_BadgeShareSheet> {
  final GlobalKey _cardKey = GlobalKey();
  bool _isGenerating = false;

  Future<void> _exportAndCopy() async {
    setState(() => _isGenerating = true);
    try {
      final boundary = _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/vireo_badge_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(pngBytes);

      final shareText = widget.isArabic
          ? 'حققت إنجاز "${widget.title}" على تطبيق Vireo! 🌱 حمّل التطبيق وابدأ رحلتك.'
          : 'I unlocked the "${widget.title}" badge on Vireo! 🌱 Join me on Vireo.';

      await Clipboard.setData(ClipboardData(text: shareText));

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 4),
          content: Text(
            widget.isArabic
                ? 'تم حفظ بطاقة الإنجاز في الصور ونسخ الرسالة للمشاركة! (${file.path})'
                : 'Achievement card saved & text copied ready to share! (${file.path})',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isArabic ? 'حدث خطأ أثناء حفظ البطاقة' : 'Could not generate share card'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.line,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.isArabic ? 'مشاركة الإنجاز' : 'Share Achievement',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),

          // Renderable Share Card
          RepaintBoundary(
            key: _cardKey,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.surfaceRaised,
                    colors.surface,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colors.ember.withValues(alpha: 0.5), width: 1.5),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colors.ember.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Text('🌱', style: const TextStyle(fontSize: 14)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'VIREO',
                        style: TextStyle(
                          letterSpacing: 2,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: colors.ember,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(widget.icon, style: const TextStyle(fontSize: 54)),
                  const SizedBox(height: 12),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colors.textMute, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.isArabic ? 'تم الإنجاز بنجاح 🏅' : 'Achievement Unlocked 🏅',
                      style: const TextStyle(
                        color: Color(0xFF22C55E),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _isGenerating ? null : _exportAndCopy,
            icon: _isGenerating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.share_outlined),
            label: Text(
              _isGenerating
                  ? (widget.isArabic ? 'جاري التجهيز...' : 'Preparing...')
                  : (widget.isArabic ? 'مشاركة وتصدير البطاقة' : 'Export & Share Card'),
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ],
      ),
    );
  }
}
