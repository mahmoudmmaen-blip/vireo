import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/user_sex_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ramadan/data/ramadan_suhoor_ranking.dart';

final _suhoorRankProvider = FutureProvider<List<RamadanSuhoorRankEntry>>((ref) {
  return RamadanSuhoorRanking.loadRanked();
});

class RamadanGuideScreen extends ConsumerWidget {
  const RamadanGuideScreen({super.key});

  static void open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const RamadanGuideScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final isFemale = ref.watch(isFemaleUserProvider);
    final rankAsync = ref.watch(_suhoorRankProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.ramadanGuideTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _Section(
            title: l10n.ramadanSuhoorRankTitle,
            child: rankAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(12),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => Text(l10n.authErrorGeneric),
              data: (items) {
                if (items.isEmpty) return Text(l10n.authErrorGeneric);
                return Column(
                  children: [
                    for (var i = 0; i < items.length; i++)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: colors.gold.withValues(alpha: 0.15),
                          child: Text('${i + 1}', style: TextStyle(color: colors.gold, fontWeight: FontWeight.w900)),
                        ),
                        title: Text(items[i].nameAr, style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text(
                          l10n.ramadanSuhoorRankSubtitle(items[i].gramsExample.round(), items[i].kcalExample),
                          style: TextStyle(color: colors.textMute, fontSize: 12),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          _Section(
            title: l10n.ramadanIftarPaceTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StepRow(number: 1, text: l10n.ramadanIftarStep1),
                _StepRow(number: 2, text: l10n.ramadanIftarStep2),
                _StepRow(number: 3, text: l10n.ramadanIftarStep3),
                _StepRow(number: 4, text: l10n.ramadanIftarStep4),
              ],
            ),
          ),
          _Section(
            title: l10n.ramadanReboundTitle,
            child: Text(
              l10n.ramadanReboundBody(isFemale ? 'female' : 'other'),
              style: TextStyle(color: colors.textMute, height: 1.45, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(VRadius.md),
        border: Border.all(color: colors.line.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.gold.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Text('$number', style: TextStyle(fontWeight: FontWeight.w900, color: colors.gold, fontSize: 12)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(height: 1.35, fontSize: 14))),
        ],
      ),
    );
  }
}
