import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/nutrition/domain/household_measures.dart';
import 'package:vireo/features/nutrition/providers/cup_size_preference_provider.dart';

/// Modal bottom sheet for picking a portion using household measures ("مقاييس البيت").
class PortionPickerSheet extends ConsumerStatefulWidget {
  const PortionPickerSheet({
    super.key,
    required this.nameAr,
    required this.nameEn,
    required this.initialGrams,
    this.explicitUnits,
  });

  final String nameAr;
  final String nameEn;
  final double initialGrams;
  final List<HouseholdUnitPortion>? explicitUnits;

  static Future<double?> show(
    BuildContext context, {
    required String nameAr,
    required String nameEn,
    required double initialGrams,
    List<HouseholdUnitPortion>? explicitUnits,
  }) {
    return showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PortionPickerSheet(
        nameAr: nameAr,
        nameEn: nameEn,
        initialGrams: initialGrams,
        explicitUnits: explicitUnits,
      ),
    );
  }

  @override
  ConsumerState<PortionPickerSheet> createState() => _PortionPickerSheetState();
}

class _PortionPickerSheetState extends ConsumerState<PortionPickerSheet> {
  late List<HouseholdUnitPortion> _units;
  late HouseholdUnitPortion _selectedUnit;
  double _quantity = 1.0;
  late double _currentGrams;

  @override
  void initState() {
    super.initState();
    _currentGrams = widget.initialGrams;
    _units = HouseholdMeasures.getUnitsForFood(
      nameAr: widget.nameAr,
      nameEn: widget.nameEn,
      explicitUnits: widget.explicitUnits,
    );

    // Default to the first unit
    _selectedUnit = _units.first;

    // Pick closest quantity step to initialGrams
    final cupMl = UserCupSizeNotifier.defaultCupMl;
    final baseG = _selectedUnit.gramsWithCupCalibration(cupMl);
    if (baseG > 0) {
      double bestDiff = double.infinity;
      double bestStep = 1.0;
      for (final s in HouseholdMeasures.quantitySteps) {
        final diff = ((baseG * s) - widget.initialGrams).abs();
        if (diff < bestDiff) {
          bestDiff = diff;
          bestStep = s;
        }
      }
      _quantity = bestStep;
      _currentGrams = (baseG * _quantity).roundToDouble();
    }
  }

  void _onUnitSelected(HouseholdUnitPortion unit) {
    HapticFeedback.selectionClick();
    final cupMl = ref.read(userCupSizeProvider);
    setState(() {
      _selectedUnit = unit;
      _currentGrams = HouseholdMeasures.computeGrams(
        portion: _selectedUnit,
        quantity: _quantity,
        cupSizeMl: cupMl,
      );
    });
  }

  void _onQuantitySelected(double qty) {
    HapticFeedback.selectionClick();
    final cupMl = ref.read(userCupSizeProvider);
    setState(() {
      _quantity = qty;
      _currentGrams = HouseholdMeasures.computeGrams(
        portion: _selectedUnit,
        quantity: _quantity,
        cupSizeMl: cupMl,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final cupMl = ref.watch(userCupSizeProvider);
    final displayName = isArabic ? widget.nameAr : (widget.nameEn.isNotEmpty ? widget.nameEn : widget.nameAr);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(VRadius.xl)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Grabber handle
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Header: Title + Grams readout
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? 'مقاييس البيت 🥣' : 'Household Portion 🥣',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: colors.ember.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colors.ember.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '≈ ${_currentGrams.round()} ${isArabic ? "جم" : "g"}',
                    style: TextStyle(
                      color: colors.ember,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 1. Unit Selector Chips
            Text(
              isArabic ? 'الوحدة (بدون ميزان)' : 'Unit (no scale needed)',
              style: TextStyle(color: colors.textMute, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final unit in _units) ...[
                  ChoiceChip(
                    avatar: Text(unit.unitId.emoji, style: const TextStyle(fontSize: 16)),
                    label: Text('${unit.label(isArabic)} (≈${unit.gramsWithCupCalibration(cupMl).round()}${isArabic ? "جم" : "g"})'),
                    selected: _selectedUnit.unitId == unit.unitId,
                    onSelected: (val) {
                      if (val) _onUnitSelected(unit);
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // 2. Quantity Stepper Chips
            Text(
              isArabic ? 'الكمية' : 'Quantity',
              style: TextStyle(color: colors.textMute, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final step in HouseholdMeasures.quantitySteps) ...[
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(HouseholdMeasures.formatQuantity(step, isArabic)),
                        selected: _quantity == step,
                        onSelected: (val) {
                          if (val) _onQuantitySelected(step);
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Button
            FilledButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.of(context).pop(_currentGrams);
              },
              style: FilledButton.styleFrom(
                backgroundColor: colors.ember,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                isArabic ? 'تأكيد الكمية (${_currentGrams.round()} جم)' : 'Confirm (${_currentGrams.round()}g)',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
