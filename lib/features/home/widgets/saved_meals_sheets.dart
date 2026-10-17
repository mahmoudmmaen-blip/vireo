import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_review_screen.dart';
import 'package:vireo/features/nutrition/providers/meal_favorites_provider.dart';

/// "وجباتي" — starred meals (max 2 taps from Home: chip → meal → review).
Future<void> showFavoriteMealsSheet(
  BuildContext context, {
  MealType? slot,
}) {
  return _show(context, kind: _SheetKind.favorites, slot: slot);
}

/// "آخر حاجات" — the last meals the user logged.
Future<void> showRecentMealsSheet(
  BuildContext context, {
  MealType? slot,
}) {
  return _show(context, kind: _SheetKind.recents, slot: slot);
}

/// Opens [snippet] in the review screen (SavedMealSnippet.toDraft → MealReviewScreen).
/// Returns false (and shows a friendly snackbar) when the draft can't be built.
Future<bool> openSavedMealInReview(
  BuildContext context,
  SavedMealSnippet snippet, {
  MealType? slot,
}) async {
  try {
    final draft = await snippet.toDraft();
    if (!context.mounted) return false;
    await MealReviewScreen.open(context, draft, slot: slot);
    return true;
  } catch (_) {
    if (!context.mounted) return false;
    final isArabic =
        Localizations.localeOf(context).languageCode.startsWith('ar');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isArabic
              ? 'مقدرتش أفتح الوجبة دي. جرّب تاني.'
              : 'Could not open this meal. Please try again.',
        ),
      ),
    );
    return false;
  }
}

enum _SheetKind { favorites, recents }

Future<void> _show(
  BuildContext hostContext, {
  required _SheetKind kind,
  MealType? slot,
}) {
  return showModalBottomSheet<void>(
    context: hostContext,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => _SavedMealsSheet(
      kind: kind,
      onPick: (snippet) async {
        Navigator.of(sheetContext).pop();
        await openSavedMealInReview(hostContext, snippet, slot: slot);
      },
    ),
  );
}

class _SavedMealsSheet extends ConsumerWidget {
  const _SavedMealsSheet({required this.kind, required this.onPick});

  final _SheetKind kind;
  final ValueChanged<SavedMealSnippet> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final isArabic =
        Localizations.localeOf(context).languageCode.startsWith('ar');
    final isFav = kind == _SheetKind.favorites;
    final items = ref.watch(isFav ? mealFavoritesProvider : mealRecentProvider);

    final title = isFav
        ? (isArabic ? 'وجباتي' : 'My meals')
        : (isArabic ? 'آخر حاجات' : 'Recent meals');
    final emptyText = isFav
        ? (isArabic
            ? 'لسه ما حطيتش وجبة في وجباتي. بعد ما تسجل وجبة دوس على النجمة وهتلاقيها هنا.'
            : 'No saved meals yet. Star a meal after logging it and it will show up here.')
        : (isArabic
            ? 'لسه ما سجلتش حاجة. أول وجبة تسجلها هتظهر هنا.'
            : 'Nothing logged yet. Your first meal will show up here.');

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              VSpace.gutter,
              0,
              VSpace.gutter,
              VSpace.xs,
            ),
            child: Row(
              children: [
                Icon(
                  isFav ? Icons.star_rounded : Icons.history_rounded,
                  color: isFav ? colors.gold : colors.ember,
                ),
                const SizedBox(width: VSpace.xs),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(VSpace.gutter),
              child: Text(
                emptyText,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.textMute, height: 1.4),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(
                  VSpace.sm,
                  0,
                  VSpace.sm,
                  VSpace.lg,
                ),
                itemCount: items.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: colors.line.withValues(alpha: 0.5),
                ),
                itemBuilder: (context, i) {
                  final s = items[i];
                  final label = isArabic
                      ? s.labelAr
                      : (s.labelEn.isNotEmpty ? s.labelEn : s.labelAr);
                  return ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 56),
                    child: ListTile(
                      minVerticalPadding: 8,
                      title: Text(
                        label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        '${s.kcal} ${isArabic ? 'سعرة' : 'kcal'}',
                        style: TextStyle(color: colors.textMute),
                      ),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onPick(s);
                      },
                      trailing: isFav
                          ? IconButton(
                              tooltip: isArabic ? 'شيل من وجباتي' : 'Remove',
                              constraints: const BoxConstraints(
                                minWidth: 48,
                                minHeight: 48,
                              ),
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: colors.textMute,
                              ),
                              onPressed: () => ref
                                  .read(mealFavoritesProvider.notifier)
                                  .remove(s.id),
                            )
                          : Icon(
                              Icons.add_circle_outline_rounded,
                              color: colors.ember,
                            ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
