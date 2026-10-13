import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/ai_nutrition/application/ai_scan_state.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_scan_provider.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_review_screen.dart';
import 'package:vireo/features/ai_nutrition/widgets/meal_scan_loading_overlay.dart';

/// Direct meal analysis screen for photos chosen from the gallery.
/// Bypasses the camera screen, shows the loading overlay with rotating tips,
/// maps errors to clear Egyptian Arabic messages with a retry button,
/// and navigates straight to [MealReviewScreen] on success.
class MealScanAnalyzeScreen extends ConsumerStatefulWidget {
  const MealScanAnalyzeScreen({super.key, required this.photos});

  final List<Uint8List> photos;

  static Future<bool?> open(BuildContext context, List<Uint8List> photos) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => MealScanAnalyzeScreen(photos: photos),
      ),
    );
  }

  @override
  ConsumerState<MealScanAnalyzeScreen> createState() => _MealScanAnalyzeScreenState();
}

class _MealScanAnalyzeScreenState extends ConsumerState<MealScanAnalyzeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAnalysis());
  }

  Future<void> _startAnalysis() async {
    if (widget.photos.isEmpty) {
      if (mounted) Navigator.of(context).pop();
      return;
    }
    HapticFeedback.mediumImpact();
    final loc = Localizations.localeOf(context).languageCode;
    await ref.read(aiScanProvider.notifier).scanMealMulti(widget.photos, language: loc);

    if (!mounted) return;
    final scan = ref.read(aiScanPhaseProvider);
    if (scan.isSuccess && scan.draftOrNull != null) {
      final draft = scan.draftOrNull!;
      final nav = Navigator.of(context);
      final saved = await MealReviewScreen.open(context, draft);
      if (mounted) {
        nav.pop(saved == true);
      }
    }
  }

  String _errorMessage(BuildContext context, AiScanErrorKind kind) {
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    if (isArabic) {
      return switch (kind) {
        AiScanErrorKind.offline => 'مفيش اتصال بالنت.. اتأكد من شبكة الإنترنت وحاول تاني',
        AiScanErrorKind.timeout => 'التحليل أخد وقت أطول من المتوقع.. حاول تاني',
        AiScanErrorKind.noFood || AiScanErrorKind.parse =>
          'مش قادرين نتعرف على الأكل في الصورة.. حاول تصوّر الوجبة بوضوح أكتر',
        AiScanErrorKind.dailyLimit =>
          'وصلت للحد الأقصى للتحليل بالذكاء الاصطناعي اليوم.. جرب بكرة أو اشترك في Pro',
        AiScanErrorKind.config || AiScanErrorKind.api =>
          'حصلت مشكلة في السيرفر.. حاول مرة تانية كمان شوية',
      };
    }
    return switch (kind) {
      AiScanErrorKind.offline => 'No internet connection. Please check your network and try again.',
      AiScanErrorKind.timeout => 'Analysis timed out. Please try again.',
      AiScanErrorKind.noFood || AiScanErrorKind.parse =>
        'Couldn\'t recognize food in the photo. Please take a clearer photo.',
      AiScanErrorKind.dailyLimit => 'Daily AI meal scan limit reached. Try tomorrow or upgrade to Pro.',
      AiScanErrorKind.config || AiScanErrorKind.api => 'Server error occurred. Please try again later.',
    };
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(aiScanPhaseProvider);
    final errorKind = scanState.errorKindOrNull;
    final errorMsg = errorKind != null ? _errorMessage(context, errorKind) : null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: MealScanLoadingOverlay(
        imageBytes: widget.photos.isNotEmpty ? widget.photos.first : null,
        isError: scanState.isError,
        errorMessage: errorMsg,
        onRetry: _startAnalysis,
        onCancel: () {
          ref.read(aiScanProvider.notifier).reset();
          Navigator.of(context).maybePop();
        },
      ),
    );
  }
}
