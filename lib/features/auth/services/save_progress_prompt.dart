import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/features/auth/auth_screen.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_meal_log_provider.dart';

const _firstOpenKey = 'app_first_open_date';
const _promptMetaKey = 'save_progress_prompt_meta';
const _successfulScansKey = 'successful_meal_scan_count';

class SaveProgressPromptHost extends ConsumerStatefulWidget {
  const SaveProgressPromptHost({super.key});

  @override
  ConsumerState<SaveProgressPromptHost> createState() =>
      _SaveProgressPromptHostState();
}

class _SaveProgressPromptHostState extends ConsumerState<SaveProgressPromptHost> {
  bool _scheduled = false;

  @override
  void initState() {
    super.initState();
    _ensureFirstOpenDate();
  }

  void _ensureFirstOpenDate() {
    if (!HiveService.isInitialized) return;
    if (!HiveService.cacheBox.containsKey(_firstOpenKey)) {
      HiveService.cacheBox.put(_firstOpenKey, DateTime.now().toIso8601String());
    }
  }

  int _successfulScanCount() {
    if (!HiveService.isInitialized) return 0;
    return (HiveService.cacheBox.get(_successfulScansKey) as num?)?.toInt() ?? 0;
  }

  bool _isDayTwoOrLater() {
    if (!HiveService.isInitialized) return false;
    final raw = HiveService.cacheBox.get(_firstOpenKey) as String?;
    final first = raw != null ? DateTime.tryParse(raw) : null;
    if (first == null) return false;
    final today = DateTime.now();
    final start = DateTime(first.year, first.month, first.day);
    final now = DateTime(today.year, today.month, today.day);
    return now.difference(start).inDays >= 1;
  }

  DateTime? _lastPromptShown() {
    if (!HiveService.isInitialized) return null;
    final raw = HiveService.cacheBox.get(_promptMetaKey);
    if (raw is! Map) return null;
    final iso = Map<String, dynamic>.from(raw)['last_shown'] as String?;
    return iso != null ? DateTime.tryParse(iso) : null;
  }

  Future<void> _markPromptShown() async {
    if (!HiveService.isInitialized) return;
    await HiveService.cacheBox.put(_promptMetaKey, {
      'last_shown': DateTime.now().toIso8601String(),
    });
  }

  bool _mayShowPrompt() {
    final auth = ref.read(authProvider).valueOrNull;
    if (auth == null || !auth.isGuest) return false;

    final last = _lastPromptShown();
    if (last != null) {
      if (DateTime.now().difference(last).inDays < 3) return false;
    }

    final scans = _successfulScanCount();
    final dayTwo = _isDayTwoOrLater();
    return scans >= 2 || dayTwo;
  }

  void _tryShowPrompt() {
    if (_scheduled || !mounted) return;
    if (!_mayShowPrompt()) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      if (!_mayShowPrompt()) return;
      await _markPromptShown();
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.authSaveProgressTitle),
          content: Text(l10n.authSaveProgressSubtitle),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.reassessmentLater),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const AuthScreen()),
                );
              },
              child: Text(l10n.saveProgressToCloud),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (_, __) => _tryShowPrompt());
    ref.listen(aiMealLogProvider, (_, __) => _tryShowPrompt());
    _tryShowPrompt();
    return const SizedBox.shrink();
  }
}

/// Call after a successful AI meal scan is saved. Returns the new total count.
Future<int> recordSuccessfulMealScan() async {
  if (!HiveService.isInitialized) return 0;
  final current =
      (HiveService.cacheBox.get(_successfulScansKey) as num?)?.toInt() ?? 0;
  final next = current + 1;
  await HiveService.cacheBox.put(_successfulScansKey, next);
  return next;
}
