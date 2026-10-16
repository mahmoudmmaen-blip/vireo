import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/features/diet_programs/data/program_meal_library.dart';
import 'package:vireo/features/diet_programs/domain/diet_program.dart';

/// Lightweight browser for the per-program meal library.
///
/// Slot tabs + four quick filters (no cook, high protein, budget, suhoor).
/// Macros come from FoodDb sums (see [ProgramMealOption]).
class ProgramMealLibraryScreen extends StatefulWidget {
  const ProgramMealLibraryScreen({
    super.key,
    required this.programId,
    required this.programName,
  });

  final DietProgramId programId;
  final L10nText programName;

  @override
  State<ProgramMealLibraryScreen> createState() =>
      _ProgramMealLibraryScreenState();
}

class _ProgramMealLibraryScreenState extends State<ProgramMealLibraryScreen> {
  MealSlot _slot = MealSlot.breakfast;
  bool _noCook = false;
  bool _highProtein = false;
  bool _budget = false;
  bool _suhoor = false;

  static const _title = L10nText('مكتبة الوجبات', 'Meal library');
  static const _empty = L10nText(
    'مفيش وجبات بالفلاتر دي. جرّب تشيل فلتر.',
    'No meals match these filters. Try removing one.',
  );
  static const _slotLabels = {
    MealSlot.breakfast: L10nText('الفطار', 'Breakfast'),
    MealSlot.lunch: L10nText('الغدا', 'Lunch'),
    MealSlot.dinner: L10nText('العشا', 'Dinner'),
    MealSlot.snack: L10nText('سناك', 'Snack'),
  };
  static const _filterNoCook = L10nText('من غير طبخ', 'No cook');
  static const _filterHighProtein = L10nText('بروتين عالي', 'High protein');
  static const _filterBudget = L10nText('اقتصادي', 'Budget');
  static const _filterSuhoor = L10nText('سحور', 'Suhoor');

  String get _lang => Localizations.localeOf(context).languageCode;
  bool get _isAr => _lang == 'ar';

  String _countText(int shown, int total) => _isAr
      ? '$shown من $total وجبة'
      : '$shown of $total meals';

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final all = mealsFor(widget.programId, _slot);
    final shown = all.where((o) {
      if (_noCook && !o.noCook) return false;
      if (_highProtein && !o.highProtein) return false;
      if (_budget && !o.budget) return false;
      if (_suhoor && !o.ramadanSuhoor) return false;
      return true;
    }).toList();

    return FeatureScaffold(
      title: '${_title.of(_lang)} · ${widget.programName.of(_lang)}',
      body: Column(
        children: [
          // Wrap (not a horizontal scroller) so every chip stays visible at
          // 360 dp with text scale 1.3.
          Padding(
            padding: const EdgeInsets.fromLTRB(
              VSpace.md,
              VSpace.sm,
              VSpace.md,
              0,
            ),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Wrap(
                spacing: VSpace.sm,
                children: [
                  for (final s in MealSlot.values)
                    ChoiceChip(
                      key: ValueKey('slot_${s.name}'),
                      label: Text(
                        '${_slotLabels[s]!.of(_lang)} (${mealsFor(widget.programId, s).length})',
                      ),
                      selected: _slot == s,
                      onSelected: (_) => setState(() => _slot = s),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              VSpace.md,
              VSpace.xs,
              VSpace.md,
              0,
            ),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Wrap(
                spacing: VSpace.sm,
                children: [
                  _filter(_filterNoCook, _noCook, (v) => _noCook = v),
                  _filter(
                    _filterHighProtein,
                    _highProtein,
                    (v) => _highProtein = v,
                  ),
                  _filter(_filterBudget, _budget, (v) => _budget = v),
                  _filter(_filterSuhoor, _suhoor, (v) => _suhoor = v),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: VSpace.md,
              vertical: VSpace.xs,
            ),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                _countText(shown.length, all.length),
                style: TextStyle(color: colors.textMute, fontSize: 12),
              ),
            ),
          ),
          Expanded(
            child: shown.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(VSpace.lg),
                      child: Text(
                        _empty.of(_lang),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.textMute),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      VSpace.md,
                      0,
                      VSpace.md,
                      VSpace.lg,
                    ),
                    itemCount: shown.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: VSpace.sm),
                    itemBuilder: (_, i) =>
                        _MealOptionCard(option: shown[i], isAr: _isAr),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filter(L10nText label, bool value, void Function(bool) set) {
    return FilterChip(
      label: Text(label.of(_lang)),
      selected: value,
      onSelected: (v) => setState(() => set(v)),
    );
  }
}

class _MealOptionCard extends StatelessWidget {
  const _MealOptionCard({required this.option, required this.isAr});

  final ProgramMealOption option;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final o = option;
    final kcalUnit = isAr ? 'سعرة' : 'kcal';
    final gUnit = isAr ? 'جم' : 'g';
    final protein = isAr ? 'بروتين' : 'P';
    final carbs = isAr ? 'كارب' : 'C';
    final fat = isAr ? 'دهون' : 'F';
    final minUnit = isAr ? 'د' : 'min';
    final swapsLabel = isAr ? 'بدائل: ' : 'Swaps: ';

    return VireoCard(
      semanticLabel: o.name(isAr ? 'ar' : 'en'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isAr ? o.nameAr : o.nameEn,
            style: const TextStyle(fontWeight: FontWeight.w800, height: 1.3),
          ),
          if (isAr)
            Text(
              o.nameEn,
              textDirection: TextDirection.ltr,
              style: TextStyle(color: colors.textMute, fontSize: 11),
            ),
          const SizedBox(height: 4),
          Text(
            '${o.kcal} $kcalUnit · $protein ${o.proteinG.round()} $gUnit · '
            '$carbs ${o.carbsG.round()} $gUnit · $fat ${o.fatG.round()} $gUnit',
            style: TextStyle(
              color: colors.ember,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isAr
                ? '${o.householdMeasureAr} · ${o.prepMinutes} $minUnit'
                : '${o.prepMinutes} $minUnit',
            style: TextStyle(color: colors.textMute, height: 1.35),
          ),
          if (isAr && o.swaps.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '$swapsLabel${o.swaps.take(2).join(' · ')}',
              style: TextStyle(color: colors.textMute, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
