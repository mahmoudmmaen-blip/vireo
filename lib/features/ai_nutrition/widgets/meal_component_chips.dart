import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';
import 'package:vireo/features/nutrition/data/food_db_repository.dart';

/// P54: meal components as editable chips (name + grams + kcal).
class MealComponentChips extends StatelessWidget {
  const MealComponentChips({
    super.key,
    required this.lines,
    required this.isArabic,
    required this.onChanged,
    required this.onRemove,
    required this.onAdd,
  });

  final List<ResolvedMealLine> lines;
  final bool isArabic;
  final void Function(int index, ResolvedMealLine updated) onChanged;
  final void Function(int index) onRemove;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          isArabic
              ? 'مكوّنات الوجبة (${lines.length})'
              : 'Meal components (${lines.length})',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (var i = 0; i < lines.length; i++)
              _ComponentChip(
                line: lines[i],
                isArabic: isArabic,
                onTap: () => _openEditor(
                  context,
                  index: i,
                  line: lines[i],
                ),
                onRemove: () {
                  HapticFeedback.mediumImpact();
                  onRemove(i);
                },
              ),
            ActionChip(
              avatar: Icon(Icons.add_rounded, size: 18, color: colors.ember),
              label: Text(
                isArabic ? 'إضافة مكوّن' : 'Add component',
                style: TextStyle(
                  color: colors.ember,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.5,
                ),
              ),
              backgroundColor: colors.ember.withValues(alpha: 0.1),
              side: BorderSide(color: colors.ember.withValues(alpha: 0.45)),
              onPressed: () {
                HapticFeedback.selectionClick();
                onAdd();
              },
            ),
          ],
        ),
        if (lines.isEmpty) ...[
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'مفيش مكوّنات لسه — اضغط «إضافة مكوّن» أو حلّل صورة.'
                : 'No components yet — tap “Add component” or scan a photo.',
            style: TextStyle(
              color: colors.textMute,
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _openEditor(
    BuildContext context, {
    required int index,
    required ResolvedMealLine line,
  }) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.vireoColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(ctx).bottom,
          ),
          child: _ChipEditSheet(
            line: line,
            isArabic: isArabic,
            onChanged: (updated) => onChanged(index, updated),
            onRemove: () {
              Navigator.of(ctx).pop();
              onRemove(index);
            },
          ),
        );
      },
    );
  }
}

class _ComponentChip extends StatelessWidget {
  const _ComponentChip({
    required this.line,
    required this.isArabic,
    required this.onTap,
    required this.onRemove,
  });

  final ResolvedMealLine line;
  final bool isArabic;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final name = isArabic
        ? line.nameAr
        : (line.nameEn.isNotEmpty ? line.nameEn : line.nameAr);
    final unit = isArabic ? 'جم' : 'g';
    final label =
        '$name ${line.grams.round()}$unit · ≈${line.kcal.round()}';

    return Material(
      color: colors.surfaceRaised,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        onLongPress: onRemove,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsetsDirectional.only(
            start: 12,
            end: 4,
            top: 6,
            bottom: 6,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: colors.line),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.text,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
              ),
              IconButton(
                tooltip: isArabic ? 'احذف' : 'Remove',
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                icon: Icon(Icons.close_rounded, size: 16, color: colors.textMute),
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipEditSheet extends StatefulWidget {
  const _ChipEditSheet({
    required this.line,
    required this.isArabic,
    required this.onChanged,
    required this.onRemove,
  });

  final ResolvedMealLine line;
  final bool isArabic;
  final ValueChanged<ResolvedMealLine> onChanged;
  final VoidCallback onRemove;

  @override
  State<_ChipEditSheet> createState() => _ChipEditSheetState();
}

class _ChipEditSheetState extends State<_ChipEditSheet> {
  late ResolvedMealLine _line;
  late final TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    _line = widget.line;
    _nameCtrl = TextEditingController(
      text: widget.isArabic ? widget.line.nameAr : widget.line.nameEn,
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _applyGrams(double grams) {
    final next = rescaleLine(_line, grams.clamp(5, 2000));
    setState(() => _line = next);
    widget.onChanged(next);
  }

  void _applyName(String raw) {
    final name = raw.trim();
    if (name.isEmpty) return;
    final next = widget.isArabic
        ? _line.copyWith(nameAr: name)
        : _line.copyWith(nameEn: name, nameAr: _line.nameAr.isEmpty ? name : null);
    setState(() => _line = next);
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final isArabic = widget.isArabic;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(VSpace.md, VSpace.sm, VSpace.md, VSpace.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: colors.line,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            Text(
              isArabic ? 'عدّل المكوّن' : 'Edit component',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameCtrl,
              textInputAction: TextInputAction.done,
              onSubmitted: _applyName,
              onChanged: _applyName,
              decoration: InputDecoration(
                labelText: isArabic ? 'الاسم' : 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: () => _applyGrams(_line.grams - 10),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  '${_line.grams.round()} ${isArabic ? 'جم' : 'g'}',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                IconButton(
                  onPressed: () => _applyGrams(_line.grams + 10),
                  icon: const Icon(Icons.add_circle_outline),
                ),
                const SizedBox(width: 8),
                Text(
                  '≈ ${_line.kcal.round()} ${isArabic ? 'سعرة' : 'kcal'}',
                  style: TextStyle(
                    color: colors.ember,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            Slider(
              value: _line.grams.clamp(10, 500),
              min: 10,
              max: 500,
              divisions: 49,
              onChanged: _applyGrams,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onRemove,
                    icon: Icon(Icons.delete_outline, color: colors.danger),
                    label: Text(
                      isArabic ? 'احذف' : 'Remove',
                      style: TextStyle(color: colors.danger),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(isArabic ? 'تم' : 'Done'),
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
