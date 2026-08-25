import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/nutrition/models/meal_builder_state.dart';

final mealBuilderProvider =
    StateProvider.family<MealBuilderState, MealType>((ref, type) {
  return MealBuilderState.defaultsFor(type);
});

class MealBuilderPanel extends ConsumerWidget {
  const MealBuilderPanel({super.key, required this.mealType});

  final MealType mealType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final state = ref.watch(mealBuilderProvider(mealType));
    final notifier = mealBuilderProvider(mealType);
    final macros = state.macros;

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: VireoDecorations.premiumCard(colors),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.mealBuilderTitleFor(_mealTitle(l10n)),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.mealBuilderSubtitle,
            style: TextStyle(color: colors.textMute, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Text(
            _proteinLabel(l10n),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: state.proteinOptions.map((count) {
              final selected = state.proteinCount == count;
              return ChoiceChip(
                label: Text(_proteinCountLabel(l10n, count)),
                selected: selected,
                onSelected: (_) {
                  ref.read(notifier.notifier).state =
                      state.copyWith(proteinCount: count);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(l10n.mealBuilderFatSource, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: FatSource.values.map((fat) {
              final selected = state.fatSource == fat;
              return FilterChip(
                label: Text(_fatLabel(l10n, fat)),
                selected: selected,
                onSelected: (_) {
                  ref.read(notifier.notifier).state =
                      state.copyWith(fatSource: fat);
                },
              );
            }).toList(),
          ),
          if (state.supportsCheese) ...[
            const SizedBox(height: 16),
            Text(l10n.mealBuilderCheeseTitle, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<CheeseType>(
              key: ValueKey('${mealType.name}_${state.cheeseType.name}'),
              initialValue: state.cheeseType,
              decoration: InputDecoration(
                filled: true,
                fillColor: colors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colors.line),
                ),
              ),
              items: CheeseType.values
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(_cheeseLabel(l10n, c)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                ref.read(notifier.notifier).state =
                    state.copyWith(cheeseType: value);
              },
            ),
            if (state.cheeseType != CheeseType.none) ...[
              const SizedBox(height: 12),
              Text(
                l10n.mealBuilderCheeseGrams(state.cheeseGrams),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Slider(
                value: state.cheeseGrams.toDouble().clamp(10, 150),
                min: 10,
                max: 150,
                divisions: 28,
                label: '${state.cheeseGrams}g',
                onChanged: (v) {
                  ref.read(notifier.notifier).state =
                      state.copyWith(cheeseGrams: v.round());
                },
              ),
            ],
          ],
          const SizedBox(height: 16),
          Text(l10n.mealBuilderAddOns, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          ...state.availableAddOns.map((addon) {
            final on = state.addOns.contains(addon);
            return SwitchListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(_addonLabel(l10n, addon)),
              value: on,
              onChanged: (value) {
                final next = Set<MealAddOn>.from(state.addOns);
                if (value) {
                  next.add(addon);
                } else {
                  next.remove(addon);
                }
                ref.read(notifier.notifier).state =
                    state.copyWith(addOns: next);
              },
            );
          }),
          const Divider(height: 24),
          Text(
            l10n.mealBuilderLiveMacros,
            style: TextStyle(color: colors.textMute, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _LiveMacro(label: '${macros.calories}', hint: 'kcal', colors: colors),
              _LiveMacro(label: '${macros.proteinG}g', hint: 'P', colors: colors),
              _LiveMacro(label: '${macros.carbsG}g', hint: 'C', colors: colors),
              _LiveMacro(label: '${macros.fatG}g', hint: 'F', colors: colors),
            ],
          ),
        ],
      ),
    );
  }

  String _mealTitle(AppLocalizations l10n) => switch (mealType) {
        MealType.breakfast => l10n.nutritionTabBreakfast,
        MealType.lunch => l10n.nutritionTabLunch,
        MealType.dinner => l10n.nutritionTabDinner,
        MealType.snack => l10n.nutritionTabSnack,
      };

  String _proteinLabel(AppLocalizations l10n) => switch (mealType) {
        MealType.breakfast => l10n.mealBuilderEggs,
        MealType.lunch => l10n.mealBuilderProteinLunch,
        MealType.dinner => l10n.mealBuilderProteinDinner,
        MealType.snack => l10n.mealBuilderProteinSnack,
      };

  String _proteinCountLabel(AppLocalizations l10n, int count) =>
      switch (mealType) {
        MealType.breakfast => l10n.mealBuilderEggCount(count),
        _ => l10n.mealBuilderPortionCount(count),
      };

  String _fatLabel(AppLocalizations l10n, FatSource fat) => switch (fat) {
        FatSource.butter => l10n.mealBuilderFatButter,
        FatSource.ghee => l10n.mealBuilderFatGhee,
        FatSource.oliveOil => l10n.mealBuilderFatOliveOil,
        FatSource.oilSpray => l10n.mealBuilderFatSpray,
      };

  String _addonLabel(AppLocalizations l10n, MealAddOn addon) => switch (addon) {
        MealAddOn.vegetables => l10n.mealBuilderAddonVeggies,
        MealAddOn.wholeGrainBread => l10n.mealBuilderAddonBread,
        MealAddOn.rice => l10n.mealBuilderAddonRice,
        MealAddOn.yogurt => l10n.mealBuilderAddonYogurt,
      };

  String _cheeseLabel(AppLocalizations l10n, CheeseType type) => switch (type) {
        CheeseType.none => l10n.mealBuilderCheeseNone,
        CheeseType.cottage => l10n.mealBuilderCheeseCottage,
        CheeseType.cheddar => l10n.mealBuilderCheeseCheddar,
        CheeseType.mozzarella => l10n.mealBuilderCheeseMozzarella,
        CheeseType.feta => l10n.mealBuilderCheeseFeta,
      };
}

class _LiveMacro extends StatelessWidget {
  const _LiveMacro({
    required this.label,
    required this.hint,
    required this.colors,
  });

  final String label;
  final String hint;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsetsDirectional.only(end: 6),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: colors.ember.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.ember.withValues(alpha: 0.35)),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.w800, color: colors.ember)),
            Text(hint, style: TextStyle(fontSize: 10, color: colors.textMute)),
          ],
        ),
      ),
    );
  }
}
