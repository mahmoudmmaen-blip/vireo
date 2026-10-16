import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';

/// Bottom sheet for the free-text "عدّل النتيجة" correction (P36).
///
/// The user types e.g. "ده سلمون مش فراخ، 150 جم". [onSubmit] runs the parse +
/// resolve pipeline and returns an error message, or null on success (the sheet
/// then closes). No calories are guessed here.
class MealCorrectionSheet extends StatefulWidget {
  const MealCorrectionSheet({
    super.key,
    required this.isArabic,
    required this.onSubmit,
  });

  final bool isArabic;
  final Future<String?> Function(String text) onSubmit;

  static Future<bool?> show(
    BuildContext context, {
    required bool isArabic,
    required Future<String?> Function(String text) onSubmit,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => MealCorrectionSheet(isArabic: isArabic, onSubmit: onSubmit),
    );
  }

  @override
  State<MealCorrectionSheet> createState() => _MealCorrectionSheetState();
}

class _MealCorrectionSheetState extends State<MealCorrectionSheet> {
  final _controller = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.length < 2 || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final err = await widget.onSubmit(text);
    if (!mounted) return;
    if (err == null) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _busy = false;
        _error = err;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final ar = widget.isArabic;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        VSpace.lg,
        0,
        VSpace.lg,
        MediaQuery.viewInsetsOf(context).bottom + VSpace.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              ar ? 'عدّل النتيجة' : 'Correct the result',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: VSpace.xs),
            Text(
              ar
                  ? 'اكتب اللي صح بكلامك، وإحنا نحسبه من قاعدة بيانات الأكل. مثلا: "ده سلمون مش فراخ، 150 جم". لو كتبت "مش فراخ" هنبدّل صنف الفراخ بس، وغير كده هنبدّل الوجبة كلها.'
                  : 'Type what is right in your own words and we will look it up in the food database. Example: "this is salmon not chicken, 150 g". If you write "not chicken" only the chicken item is replaced; otherwise the whole meal is replaced.',
              style: TextStyle(color: colors.textMute, height: 1.4, fontSize: 13),
            ),
            const SizedBox(height: VSpace.md),
            TextField(
              controller: _controller,
              autofocus: true,
              minLines: 1,
              maxLines: 3,
              enabled: !_busy,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                hintText: ar
                    ? 'ده سلمون مش فراخ، 150 جم'
                    : 'This is salmon not chicken, 150 g',
                border: const OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: VSpace.sm),
              Text(_error!, style: TextStyle(color: colors.danger, height: 1.3)),
            ],
            const SizedBox(height: VSpace.md),
            FilledButton(
              onPressed: _busy ? null : _submit,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              child: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(ar ? 'طبّق التعديل' : 'Apply correction'),
            ),
          ],
        ),
      ),
    );
  }
}
