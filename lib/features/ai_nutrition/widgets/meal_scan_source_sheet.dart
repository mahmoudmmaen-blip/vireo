import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ai_nutrition/screens/ai_scan_screen.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_log_text_screen.dart';

/// Shows a bottom sheet allowing the user to choose the meal scan source:
/// 1. Camera ("صوّر بالكاميرا")
/// 2. Gallery ("اختار من الاستوديو")
/// 3. Text description ("اكتب الأكل")
Future<void> showMealScanSourceSheet(BuildContext context, WidgetRef ref) {
  HapticFeedback.lightImpact();
  final l10n = AppLocalizations.of(context);
  final colors = context.vireoColors;

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(VRadius.xl)),
    ),
    builder: (sheetCtx) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.scanSourceSheetTitle,
                textAlign: TextAlign.center,
                style: Theme.of(sheetCtx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 18),
              _SourceOptionTile(
                icon: Icons.camera_alt_rounded,
                iconColor: colors.ember,
                title: l10n.scanSourceCamera,
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AiScanScreen(
                        initialSource: ImageSource.camera,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _SourceOptionTile(
                icon: Icons.photo_library_rounded,
                iconColor: const Color(0xFF38BDF8), // sky blue
                title: l10n.scanSourceGallery,
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AiScanScreen(
                        initialSource: ImageSource.gallery,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _SourceOptionTile(
                icon: Icons.edit_note_rounded,
                iconColor: const Color(0xFF10B981), // emerald
                title: l10n.scanSourceText,
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const MealLogTextScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Generic media source bottom sheet for Fridge Scan and InBody reports:
/// Camera ("صوّر بالكاميرا") vs Gallery ("اختار من الاستوديو").
Future<ImageSource?> showPhotoSourceSheet(
  BuildContext context, {
  String? title,
  VoidCallback? onCustomAction,
  String? customActionLabel,
  IconData? customActionIcon,
}) {
  HapticFeedback.lightImpact();
  final l10n = AppLocalizations.of(context);
  final colors = context.vireoColors;

  return showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(VRadius.xl)),
    ),
    builder: (sheetCtx) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title ?? l10n.scanSourceSheetTitle,
                textAlign: TextAlign.center,
                style: Theme.of(sheetCtx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 18),
              _SourceOptionTile(
                icon: Icons.camera_alt_rounded,
                iconColor: colors.ember,
                title: l10n.scanSourceCamera,
                onTap: () => Navigator.of(sheetCtx).pop(ImageSource.camera),
              ),
              const SizedBox(height: 10),
              _SourceOptionTile(
                icon: Icons.photo_library_rounded,
                iconColor: const Color(0xFF38BDF8),
                title: l10n.scanSourceGallery,
                onTap: () => Navigator.of(sheetCtx).pop(ImageSource.gallery),
              ),
              if (onCustomAction != null && customActionLabel != null) ...[
                const SizedBox(height: 10),
                _SourceOptionTile(
                  icon: customActionIcon ?? Icons.description_rounded,
                  iconColor: const Color(0xFFA855F7),
                  title: customActionLabel,
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    onCustomAction();
                  },
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

class _SourceOptionTile extends StatelessWidget {
  const _SourceOptionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(VRadius.md),
          border: Border.all(color: colors.line.withValues(alpha: 0.6)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(VRadius.sm),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.textMute, size: 20),
          ],
        ),
      ),
    );
  }
}
