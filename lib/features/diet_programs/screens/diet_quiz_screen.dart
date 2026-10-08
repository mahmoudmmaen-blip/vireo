import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/features/diet_programs/data/diet_programs_catalog.dart';
import 'package:vireo/features/diet_programs/domain/diet_program.dart';
import 'package:vireo/features/diet_programs/providers/diet_programs_provider.dart';
import 'package:vireo/features/diet_programs/screens/diet_programs_screen.dart';

class DietQuizScreen extends ConsumerStatefulWidget {
  const DietQuizScreen({super.key});

  @override
  ConsumerState<DietQuizScreen> createState() => _DietQuizScreenState();
}

class _DietQuizScreenState extends ConsumerState<DietQuizScreen> {
  /// 0 = disclaimer+health, 1 = preferences, 2 = done → navigate.
  int _step = 0;
  final Set<HealthCondition> _yes = {};
  int _healthIndex = 0;
  bool _acceptedDisclaimer = false;

  bool _lovesBreadAndRice = true;
  bool _canSkipBreakfast = false;
  bool _wantsSimpleRules = true;
  bool _eatsOutOften = false;
  bool _trainsWithWeights = false;
  int _prefIndex = 0;

  static final _healthKeys = DietSafetyCopy.questions.keys.toList();

  String get _lang => Localizations.localeOf(context).languageCode;

  Future<void> _finish() async {
    final prefs = DietPreferences(
      lovesBreadAndRice: _lovesBreadAndRice,
      canSkipBreakfast: _canSkipBreakfast,
      wantsSimpleRules: _wantsSimpleRules,
      eatsOutOften: _eatsOutOften,
      trainsWithWeights: _trainsWithWeights,
    );
    await ref.read(dietPlanActionsProvider).saveScreening(
          conditions: _yes,
          preferences: prefs,
        );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const DietProgramsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return FeatureScaffold(
      title: l10n.dietQuizTitle,
      body: Padding(
        padding: const EdgeInsets.all(VSpace.md),
        child: switch (_step) {
          0 => _buildHealthStep(l10n, colors),
          1 => _buildPrefStep(l10n, colors),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }

  Widget _buildHealthStep(AppLocalizations l10n, VireoColors colors) {
    if (!_acceptedDisclaimer) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VireoCard(
            glow: colors.gold,
            child: Text(
              DietSafetyCopy.disclaimer.of(_lang),
              style: TextStyle(height: 1.45, color: colors.text),
            ),
          ),
          const Spacer(),
          FilledButton(
            onPressed: () => setState(() => _acceptedDisclaimer = true),
            child: Text(l10n.dietQuizContinue),
          ),
        ],
      );
    }

    final condition = _healthKeys[_healthIndex];
    final question = DietSafetyCopy.questions[condition]!.of(_lang);
    final progress = (_healthIndex + 1) / _healthKeys.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.dietQuizHealthStep(_healthIndex + 1, _healthKeys.length),
          style: VType.overline(context),
        ),
        const SizedBox(height: VSpace.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(VRadius.pill),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            color: colors.ember,
            backgroundColor: colors.line,
          ),
        ),
        const SizedBox(height: VSpace.xl),
        Expanded(
          child: Center(
            child: Text(
              question,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                  ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _answerHealth(condition, false),
                child: Text(l10n.dietQuizNo),
              ),
            ),
            const SizedBox(width: VSpace.sm),
            Expanded(
              child: FilledButton(
                onPressed: () => _answerHealth(condition, true),
                child: Text(l10n.dietQuizYes),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _answerHealth(HealthCondition condition, bool yes) {
    setState(() {
      if (yes) {
        _yes.add(condition);
      } else {
        _yes.remove(condition);
      }
      if (_healthIndex < _healthKeys.length - 1) {
        _healthIndex++;
      } else {
        _step = 1;
      }
    });
  }

  Widget _buildPrefStep(AppLocalizations l10n, VireoColors colors) {
    final prefs = <({String q, bool value, void Function(bool) set})>[
      (
        q: l10n.dietPrefBreadRice,
        value: _lovesBreadAndRice,
        set: (v) => _lovesBreadAndRice = v,
      ),
      (
        q: l10n.dietPrefSkipBreakfast,
        value: _canSkipBreakfast,
        set: (v) => _canSkipBreakfast = v,
      ),
      (
        q: l10n.dietPrefSimpleRules,
        value: _wantsSimpleRules,
        set: (v) => _wantsSimpleRules = v,
      ),
      (
        q: l10n.dietPrefEatsOut,
        value: _eatsOutOften,
        set: (v) => _eatsOutOften = v,
      ),
      (
        q: l10n.dietPrefWeights,
        value: _trainsWithWeights,
        set: (v) => _trainsWithWeights = v,
      ),
    ];
    final item = prefs[_prefIndex];
    final progress = (_prefIndex + 1) / prefs.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.dietQuizPrefStep(_prefIndex + 1, prefs.length),
          style: VType.overline(context),
        ),
        const SizedBox(height: VSpace.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(VRadius.pill),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            color: colors.ember,
            backgroundColor: colors.line,
          ),
        ),
        const SizedBox(height: VSpace.xl),
        Expanded(
          child: Center(
            child: Text(
              item.q,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                  ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    item.set(false);
                    if (_prefIndex < prefs.length - 1) {
                      _prefIndex++;
                    } else {
                      _finish();
                    }
                  });
                },
                child: Text(l10n.dietQuizNo),
              ),
            ),
            const SizedBox(width: VSpace.sm),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  setState(() {
                    item.set(true);
                    if (_prefIndex < prefs.length - 1) {
                      _prefIndex++;
                    } else {
                      _finish();
                    }
                  });
                },
                child: Text(l10n.dietQuizYes),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
