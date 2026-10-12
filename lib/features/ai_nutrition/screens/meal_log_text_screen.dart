import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ai_nutrition/data/gemini_food_service_core.dart';
import 'package:vireo/features/ai_nutrition/domain/i_food_vision_service.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_review_screen.dart';
import 'package:vireo/features/ai_nutrition/widgets/meal_quick_relog_row.dart';

class MealLogTextScreen extends ConsumerStatefulWidget {
  const MealLogTextScreen({
    super.key,
    this.startListeningOnInit = false,
  });

  final bool startListeningOnInit;

  @override
  ConsumerState<MealLogTextScreen> createState() => _MealLogTextScreenState();
}

class _MealLogTextScreenState extends ConsumerState<MealLogTextScreen> {
  final _ctrl = TextEditingController();
  final _speech = stt.SpeechToText();
  bool _loading = false;
  bool _listening = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.startListeningOnInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _toggleVoice();
      });
    }
  }

  Future<void> _submit() async {
    final text = _ctrl.text.trim();
    if (text.length < 2) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final lang = Localizations.localeOf(context).languageCode;
      final draft = await GeminiFoodServiceCore.parseTextToDraft(
        text,
        language: lang,
      );
      if (!mounted) return;
      await MealReviewScreen.open(context, draft);
      if (mounted) Navigator.of(context).maybePop();
    } on FoodVisionException catch (e) {
      BootLog.warn('meal text log failed', e);
      setState(() => _error = e.message);
    } catch (e) {
      BootLog.warn('meal text log unexpected', e);
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggleVoice() async {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }
    final ok = await _speech.initialize(
      onError: (e) => BootLog.warn('speech error', e.errorMsg),
    );
    if (!ok) {
      setState(() => _error = l10n.mealVoiceUnavailable);
      return;
    }
    setState(() => _listening = true);
    await _speech.listen(
      listenOptions: stt.SpeechListenOptions(
        localeId: lang == 'ar' ? 'ar_EG' : 'en_US',
      ),
      onResult: (r) {
        setState(() => _ctrl.text = r.recognizedWords);
      },
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.mealLogTextTitle)),
      body: Padding(
        padding: const EdgeInsets.all(VSpace.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.mealLogTextHint, style: TextStyle(color: colors.textMute)),
            const SizedBox(height: VSpace.md),
            const MealQuickRelogRow(),
            const SizedBox(height: VSpace.md),
            TextField(
              controller: _ctrl,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.mealLogTextPlaceholder,
                border: const OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: colors.danger)),
              TextButton(
                onPressed: _submit,
                child: Text(l10n.mealReviewLogByText),
              ),
            ],
            const SizedBox(height: VSpace.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _loading ? null : _toggleVoice,
                    icon: Icon(_listening ? Icons.mic : Icons.mic_none),
                    label: Text(
                      _listening ? l10n.mealVoiceListening : l10n.mealVoiceStart,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.mealLogTextAnalyze),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
