import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/features/subscription/premium_access.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/repositories/nutrition_repository.dart';
import 'package:vireo/features/nutrition/providers/fridge_scan_provider.dart';
import 'package:vireo/features/nutrition/screens/ingredients_confirm_screen.dart';
import 'package:vireo/features/nutrition/screens/manual_food_entry_screen.dart';
import 'package:vireo/features/nutrition/widgets/scanning_overlay.dart';

class FridgeScanScreen extends ConsumerStatefulWidget {
  const FridgeScanScreen({super.key});

  @override
  ConsumerState<FridgeScanScreen> createState() => _FridgeScanScreenState();
}

class _FridgeScanScreenState extends ConsumerState<FridgeScanScreen> {
  File? _preview;
  final _picker = ImagePicker();

  Future<void> _pick(ImageSource source) async {
    final sub = await ref.read(subscriptionProvider.future);
    if (!sub.canUseUnlimitedFridgeScans) {
      final remaining = await ref
          .read(nutritionRepositoryProvider)
          .remainingScansThisMonth(isPremium: false);

      if ((remaining ?? 0) <= 0) {
        if (mounted) {
          requirePremiumAccess(
            context,
            ref,
            paywallContext: paywallContextForSnapshot(sub),
          );
        }
        return;
      }
    }

    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;

    setState(() => _preview = File(picked.path));
    ref.read(fridgeScanFlowProvider.notifier).reset();

    final ok = await ref.read(fridgeScanFlowProvider.notifier).scanFile(_preview!);
    if (!mounted) return;

    if (ok) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const IngredientsConfirmScreen()),
      );
    } else {
      final err = ref.read(fridgeScanFlowProvider).errorMessage;
      if (err == 'SCAN_LIMIT_REACHED') {
        final sub = ref.read(subscriptionProvider).valueOrNull;
        requirePremiumAccess(
          context,
          ref,
          paywallContext: sub != null
              ? paywallContextForSnapshot(sub)
              : PaywallContext.standard,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).nutritionScanFailed),
            action: SnackBarAction(
              label: AppLocalizations.of(context).nutritionManualEntry,
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const ManualFoodEntryScreen()),
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final scanning = ref.watch(fridgeScanFlowProvider).isScanning;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.nutritionScanFridge)),
      body: Column(
        children: [
          Expanded(
            child: scanning || _preview != null
                ? ScanningOverlay(imageFile: _preview)
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        l10n.nutritionScanPrompt,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.textMute),
                      ),
                    ),
                  ),
          ),
          if (scanning)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.nutritionScanning, style: TextStyle(color: colors.ember)),
            )
          else
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pick(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: Text(l10n.nutritionTakePhoto),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => _pick(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(l10n.nutritionChoosePhoto),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
