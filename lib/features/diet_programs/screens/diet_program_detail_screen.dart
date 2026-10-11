import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/ring_progress.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/core/utils/fat_equivalent.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/features/diet_programs/application/diet_plan_engine.dart';
import 'package:vireo/features/diet_programs/data/diet_plan_storage.dart';
import 'package:vireo/features/diet_programs/data/diet_programs_catalog.dart';
import 'package:vireo/features/diet_programs/domain/diet_program.dart';
import 'package:vireo/features/diet_programs/providers/diet_programs_provider.dart';

class DietProgramDetailScreen extends ConsumerStatefulWidget {
  const DietProgramDetailScreen({super.key, required this.programId});

  final DietProgramId programId;

  @override
  ConsumerState<DietProgramDetailScreen> createState() =>
      _DietProgramDetailScreenState();
}

class _DietProgramDetailScreenState
    extends ConsumerState<DietProgramDetailScreen> {
  bool _cautionAck = false;

  String get _lang => Localizations.localeOf(context).languageCode;

  RankedProgram? get _ranked {
    final list = ref.watch(rankedProgramsProvider);
    for (final r in list) {
      if (r.program.id == widget.programId) return r;
    }
    return null;
  }

  Future<void> _onStart(RankedProgram ranked) async {
    final l10n = AppLocalizations.of(context);
    final elig = ranked.eligibility;

    if (elig.isMinor) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text(DietSafetyCopy.minorGate.of(_lang)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.dietClose),
            ),
          ],
        ),
      );
      return;
    }

    if (elig.status == EligibilityStatus.doctorRequired &&
        !DietPlanStorage.isDoctorApproved(ranked.program.id)) {
      final ok = await _showDoctorSheet();
      if (ok != true || !mounted) return;
      await ref.read(dietPlanActionsProvider).approveDoctor(ranked.program.id);
    }

    if (elig.status == EligibilityStatus.caution && !_cautionAck) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: const Duration(seconds: 3), persist: false, content: Text(l10n.dietMustAckWarning)),
      );
      return;
    }

    await ref.read(dietPlanActionsProvider).startProgram(ranked.program);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(duration: const Duration(seconds: 3), persist: false, content: Text(l10n.dietStartedToast)),
    );
    Navigator.of(context).pop();
  }

  Future<bool?> _showDoctorSheet() {
    var checked = false;
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx);
        final colors = ctx.vireoColors;
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                VSpace.lg,
                VSpace.lg,
                VSpace.lg,
                MediaQuery.paddingOf(ctx).bottom + VSpace.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.dietDoctorGateTitle,
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: VSpace.sm),
                  Text(
                    DietSafetyCopy.doctorGate.of(_lang),
                    style: TextStyle(height: 1.45, color: colors.textMute),
                  ),
                  const SizedBox(height: VSpace.md),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: checked,
                    onChanged: (v) => setLocal(() => checked = v ?? false),
                    title: Text(DietSafetyCopy.doctorConfirm.of(_lang)),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: VSpace.md),
                  FilledButton(
                    onPressed: checked ? () => Navigator.pop(ctx, true) : null,
                    child: Text(l10n.dietStartProgram),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final ranked = _ranked;
    if (ranked == null) {
      return FeatureScaffold(
        title: l10n.dietProgramsTitle,
        body: Center(child: Text(l10n.authErrorGeneric)),
      );
    }
    final p = ranked.program;
    final t = ranked.targets;
    final elig = ranked.eligibility;

    return FeatureScaffold(
      title: p.name.of(_lang),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                VSpace.md,
                VSpace.sm,
                VSpace.md,
                VSpace.md,
              ),
              children: [
                Text(
                  '${p.emoji}  ${p.tagline.of(_lang)}',
                  style: TextStyle(color: colors.textMute, height: 1.4),
                ),
                SectionHeader(title: l10n.dietHowItWorks),
                Text(p.howItWorks.of(_lang), style: const TextStyle(height: 1.45)),
                SectionHeader(title: l10n.dietYourTargets),
                VireoCard(
                  child: Column(
                    children: [
                      RingProgress(
                        progress: 1,
                        color: colors.ember,
                        size: 110,
                        stroke: 10,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${t.calories}',
                              style: VType.number(size: 26, color: colors.text),
                            ),
                            Text(
                              'kcal',
                              style: TextStyle(
                                color: colors.textMute,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: VSpace.md),
                      MacroBar(
                        label: l10n.uxProtein,
                        value: t.proteinG.toDouble(),
                        target: t.proteinG.toDouble(),
                        color: VMacro.protein,
                      ),
                      const SizedBox(height: VSpace.sm),
                      MacroBar(
                        label: l10n.uxCarbs,
                        value: t.carbsG.toDouble(),
                        target: (t.carbsMaxG ?? t.carbsG).toDouble(),
                        color: VMacro.carbs,
                      ),
                      if (t.carbsMaxG != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          l10n.dietCarbsMax(t.carbsMaxG!),
                          style: TextStyle(
                            color: colors.gold,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const SizedBox(height: VSpace.sm),
                      MacroBar(
                        label: l10n.uxFat,
                        value: t.fatG.toDouble(),
                        target: t.fatG.toDouble(),
                        color: VMacro.fat,
                      ),
                      if (t.floorApplied) ...[
                        const SizedBox(height: VSpace.md),
                        Text(
                          DietSafetyCopy.floorNote.of(_lang),
                          style: TextStyle(
                            color: colors.gold,
                            height: 1.35,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: VSpace.sm),
                      Text(
                        l10n.dietWeeklyLoss(t.weeklyLossKg.toStringAsFixed(2)),
                        style: TextStyle(color: colors.textMute, fontSize: 13),
                      ),
                      if (t.deficitKcal > 0 || t.weeklyLossKg > 0) ...[
                        const SizedBox(height: 6),
                        FatEquivalentBadge(
                          customText: FatEquivalent.dietPlanRateText(
                            dailyDeficitKcal: t.deficitKcal,
                            weeklyLossKg: t.weeklyLossKg,
                            l10n: l10n,
                            lang: _lang,
                          ),
                          style: TextStyle(
                            color: colors.ember,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SectionHeader(title: l10n.dietBestFor),
                ...p.bestFor.map((e) => _Bullet(e.of(_lang))),
                SectionHeader(title: l10n.dietNotIdealFor),
                ...p.notIdealFor.map((e) => _Bullet(e.of(_lang))),
                SectionHeader(title: l10n.dietRules),
                ...p.rules.map((e) => _Bullet(e.of(_lang))),
                SectionHeader(title: l10n.dietAllowedFoods),
                ...p.allowedFoods.map((e) => _Bullet(e.of(_lang))),
                SectionHeader(title: l10n.dietLimitFoods),
                ...p.limitFoods.map((e) => _Bullet(e.of(_lang))),
                SectionHeader(title: l10n.dietSampleDay),
                ...p.sampleDay.map(
                  (m) => Padding(
                    padding: const EdgeInsets.only(bottom: VSpace.sm),
                    child: VireoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.time.of(_lang),
                            style: VType.overline(context),
                          ),
                          Text(
                            m.name.of(_lang),
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            m.items.of(_lang),
                            style: TextStyle(
                              color: colors.textMute,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SectionHeader(title: l10n.dietSideEffects),
                ...p.sideEffects.map((e) => _Bullet(e.of(_lang))),
                SectionHeader(title: l10n.dietTips),
                ...p.tips.map((e) => _Bullet(e.of(_lang))),
                SectionHeader(title: l10n.dietEvidence),
                Text(
                  p.evidenceSummary.of(_lang),
                  style: const TextStyle(height: 1.45),
                ),
                const SizedBox(height: VSpace.sm),
                ...p.sources.map(
                  (s) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.link, color: colors.ember),
                    title: Text(
                      s.title,
                      style: TextStyle(
                        color: colors.ember,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    onTap: () => launchUrl(
                      Uri.parse(s.url),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                ),
                SectionHeader(title: l10n.dietStopSigns),
                VireoCard(
                  color: colors.danger.withValues(alpha: 0.12),
                  borderColor: colors.danger.withValues(alpha: 0.45),
                  child: Text(
                    DietSafetyCopy.stopSigns.of(_lang),
                    style: TextStyle(
                      color: colors.danger,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SectionHeader(title: l10n.dietDisclaimer),
                Text(
                  DietSafetyCopy.disclaimer.of(_lang),
                  style: TextStyle(
                    color: colors.textMute,
                    height: 1.4,
                    fontSize: 13,
                  ),
                ),
                if (elig.status == EligibilityStatus.caution) ...[
                  const SizedBox(height: VSpace.md),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _cautionAck,
                    onChanged: (v) =>
                        setState(() => _cautionAck = v ?? false),
                    title: Text(l10n.dietAckWarning),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
                const SizedBox(height: VSpace.xl),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                VSpace.md,
                VSpace.sm,
                VSpace.md,
                VSpace.sm,
              ),
              child: FilledButton(
                onPressed: () => _onStart(ranked),
                child: Text(l10n.dietStartProgram),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: VSpace.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ', style: TextStyle(color: context.vireoColors.ember)),
          Expanded(child: Text(text, style: const TextStyle(height: 1.4))),
        ],
      ),
    );
  }
}
