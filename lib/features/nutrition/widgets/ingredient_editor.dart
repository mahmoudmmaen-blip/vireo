import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/food_item.dart';
import 'package:vireo/features/nutrition/providers/food_search_provider.dart';

class IngredientEditor extends ConsumerStatefulWidget {
  const IngredientEditor({
    super.key,
    required this.ingredients,
    required this.onChanged,
  });

  final List<String> ingredients;
  final ValueChanged<List<String>> onChanged;

  @override
  ConsumerState<IngredientEditor> createState() => _IngredientEditorState();
}

class _IngredientEditorState extends ConsumerState<IngredientEditor> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    if (widget.ingredients.any((i) => i.toLowerCase() == trimmed.toLowerCase())) {
      return;
    }
    widget.onChanged([...widget.ingredients, trimmed]);
    _controller.clear();
    setState(() {});
  }

  void _remove(String item) {
    widget.onChanged(widget.ingredients.where((i) => i != item).toList());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = ref.watch(localeProvider).languageCode;
    final query = _controller.text;
    final suggestionsAsync = query.length >= 2
        ? ref.watch(foodSearchProvider(query))
        : const AsyncValue.data(<FoodItem>[]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.ingredients.map((item) {
            return Chip(
              label: Text(item),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () => _remove(item),
              backgroundColor: colors.surfaceRaised,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          onChanged: (_) => setState(() {}),
          onSubmitted: _add,
          decoration: InputDecoration(
            labelText: l10n.nutritionAddIngredient,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _add(_controller.text),
            ),
          ),
        ),
        suggestionsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (items) {
            if (items.isEmpty || query.length < 2) return const SizedBox.shrink();
            return Card(
              margin: const EdgeInsets.only(top: 8),
              child: Column(
                children: items.map((food) {
                  return ListTile(
                    dense: true,
                    title: Text(food.localizedName(locale)),
                    onTap: () => _add(food.localizedName(locale)),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
