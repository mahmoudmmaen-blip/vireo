import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/data/models/recipe.dart';

enum MealSwapFilter { all, quick, highProtein, lowCalorie }

class MealSwapSheet extends StatefulWidget {
  const MealSwapSheet({
    super.key,
    required this.alternatives,
    required this.locale,
  });

  final List<Recipe> alternatives;
  final String locale;

  static Future<Recipe?> show(
    BuildContext context, {
    required List<Recipe> alternatives,
    required String locale,
  }) {
    return showModalBottomSheet<Recipe>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => MealSwapSheet(
        alternatives: alternatives,
        locale: locale,
      ),
    );
  }

  @override
  State<MealSwapSheet> createState() => _MealSwapSheetState();
}

class _MealSwapSheetState extends State<MealSwapSheet> {
  MealSwapFilter _filter = MealSwapFilter.all;

  List<Recipe> get _filtered {
    final items = widget.alternatives;
    return switch (_filter) {
      MealSwapFilter.quick => items.where((r) => r.isQuick).toList(),
      MealSwapFilter.highProtein => items.where((r) => r.isHighProtein).toList(),
      MealSwapFilter.lowCalorie => items.where((r) => r.isLowCalorie).toList(),
      MealSwapFilter.all => items,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final filtered = _filtered;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.nutritionSwapMeal, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(l10n.nutritionSwapMealSubtitle, style: TextStyle(color: colors.textMute)),
                const SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: l10n.nutritionFilterAll,
                        selected: _filter == MealSwapFilter.all,
                        onTap: () => setState(() => _filter = MealSwapFilter.all),
                      ),
                      _FilterChip(
                        label: l10n.nutritionFilterQuick,
                        selected: _filter == MealSwapFilter.quick,
                        onTap: () => setState(() => _filter = MealSwapFilter.quick),
                      ),
                      _FilterChip(
                        label: l10n.nutritionTagHighProtein,
                        selected: _filter == MealSwapFilter.highProtein,
                        onTap: () => setState(() => _filter = MealSwapFilter.highProtein),
                      ),
                      _FilterChip(
                        label: l10n.nutritionFilterLowCalorie,
                        selected: _filter == MealSwapFilter.lowCalorie,
                        onTap: () => setState(() => _filter = MealSwapFilter.lowCalorie),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(child: Text(l10n.nutritionSwapMealEmpty))
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final recipe = filtered[index];
                            return _SwapTile(
                              recipe: recipe,
                              locale: widget.locale,
                              onTap: () => Navigator.of(context).pop(recipe),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: colors.ember.withValues(alpha: 0.25),
        checkmarkColor: colors.ember,
        labelStyle: TextStyle(
          color: selected ? colors.ember : colors.textMute,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VireoDecorations.chipRadius),
          side: BorderSide(color: colors.line),
        ),
      ),
    );
  }
}

class _SwapTile extends StatelessWidget {
  const _SwapTile({
    required this.recipe,
    required this.locale,
    required this.onTap,
  });

  final Recipe recipe;
  final String locale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: VireoDecorations.premiumCard(colors),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: VireoDecorations.mealThumbnail(colors),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.restaurant, color: Colors.white, size: 20),
        ),
        title: Text(
          recipe.localizedTitle(locale),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          l10n.nutritionMacroSummary(recipe.calories, recipe.proteinG),
          style: TextStyle(color: colors.textMute, fontSize: 12),
        ),
        trailing: Text(
          l10n.nutritionPrepMinutes(recipe.prepTimeMinutes),
          style: TextStyle(color: colors.gold, fontSize: 12),
        ),
      ),
    );
  }
}
