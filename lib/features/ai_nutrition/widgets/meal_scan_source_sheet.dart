import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ai_nutrition/screens/cal_ai_camera_screen.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_barcode_screen.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_log_text_screen.dart';

/// Shows the unified bottom sheet "سجّل وجبتك" with 5 big tiles:
/// 1. صوّر الوجبة (CalAi camera)
/// 2. من الاستوديو (pickMultiImage)
/// 3. اكتب (text entry)
/// 4. بالصوت (voice speech-to-text)
/// 5. باركود (barcode scanner)
Future<void> showMealScanSourceSheet(BuildContext context, WidgetRef ref) {
  HapticFeedback.lightImpact();
  final colors = context.vireoColors;

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.surface,
    isScrollControlled: true,
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
                'سجّل وجبتك',
                textAlign: TextAlign.center,
                style: Theme.of(sheetCtx).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 18),
              _SourceOptionTile(
                icon: Icons.camera_alt_rounded,
                iconColor: colors.ember,
                title: 'صوّر الوجبة',
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const CalAiCameraScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _SourceOptionTile(
                icon: Icons.photo_library_rounded,
                iconColor: const Color(0xFF38BDF8), // sky blue
                title: 'من الاستوديو',
                onTap: () async {
                  Navigator.of(sheetCtx).pop();
                  final picker = ImagePicker();
                  final pickedFiles = await picker.pickMultiImage(limit: 5);
                  if (pickedFiles.isNotEmpty && context.mounted) {
                    final bytesList = <Uint8List>[];
                    for (final pf in pickedFiles.take(5)) {
                      bytesList.add(await pf.readAsBytes());
                    }
                    if (context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => CalAiCameraScreen(
                            initialPhotos: bytesList,
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 10),
              _SourceOptionTile(
                icon: Icons.edit_note_rounded,
                iconColor: const Color(0xFF10B981), // emerald
                title: 'اكتب',
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const MealLogTextScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _SourceOptionTile(
                icon: Icons.mic_rounded,
                iconColor: const Color(0xFFA855F7), // purple
                title: 'بالصوت',
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const MealLogTextScreen(startListeningOnInit: true),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _SourceOptionTile(
                icon: Icons.qr_code_scanner_rounded,
                iconColor: const Color(0xFFF59E0B), // amber
                title: 'باركود',
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const MealBarcodeScreen(),
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
