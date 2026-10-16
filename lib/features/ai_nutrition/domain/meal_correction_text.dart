/// Pure helpers for the free-text "عدّل النتيجة" correction on the meal
/// review screen (P36).
///
/// The user types things like "ده سلمون مش فراخ، 150 جم". We do NOT guess
/// calories from this text. We only:
///  1. drop the part the user said is wrong ("مش فراخ"),
///  2. keep the names (+ grams) so the existing parse step can turn them into
///     items, and the existing MealResolutionService can resolve them against
///     the food DB,
///  3. tell the screen which existing lines the user meant to replace.
class MealCorrection {
  const MealCorrection({
    required this.textForParser,
    required this.negatedTerms,
    required this.statedGrams,
  });

  /// Cleaned text to send to the text parser ("سلمون 150 جم").
  final String textForParser;

  /// Normalized terms the user said are wrong (e.g. ["فراخ"]).
  final List<String> negatedTerms;

  /// Grams the user stated, when exactly one amount was typed.
  final double? statedGrams;

  bool get isEmpty => textForParser.trim().isEmpty;
}

abstract final class MealCorrectionText {
  static const _negationMarkers = {
    'مش',
    'مو',
    'ليس',
    'وليس',
    'مش.',
    'بدل',
    'بدلا',
    'مفيش',
    'مافيش',
  };

  static const _fillers = {
    'ده',
    'دي',
    'دا',
    'دة',
    'هو',
    'هي',
    'كان',
    'كانت',
    'في',
    'من',
    'ما',
    'اصلا',
    'اصلاً',
    'يعني',
    'قصدي',
    'انا',
    'هوه',
    'ده.',
  };

  static const _unitTokens = {
    'جم',
    'جرام',
    'غرام',
    'جرامات',
    'g',
    'gm',
    'gr',
    'gram',
    'grams',
  };

  /// Words that mean the same thing for matching a term against a line name.
  static const _synonymGroups = <Set<String>>[
    {'فراخ', 'دجاج', 'فرخه', 'جاج', 'chicken'},
    {'لحم', 'لحمه', 'كندوز', 'بقري', 'beef', 'meat'},
    {'سمك', 'سمكه', 'fish'},
    {'رز', 'ارز', 'rice'},
    {'عيش', 'خبز', 'رغيف', 'bread'},
    {'بيض', 'بيضه', 'egg', 'eggs'},
    {'جبنه', 'cheese'},
    {'زبادي', 'yogurt'},
    {'سلمون', 'salmon'},
    {'تونه', 'tuna'},
    {'جمبري', 'روبيان', 'shrimp'},
  ];

  static const _arabicIndic = '٠١٢٣٤٥٦٧٨٩';
  static const _extendedIndic = '۰۱۲۳۴۵۶۷۸۹';

  static String _digits(String s) {
    final b = StringBuffer();
    for (final r in s.runes) {
      final ch = String.fromCharCode(r);
      var i = _arabicIndic.indexOf(ch);
      if (i < 0) i = _extendedIndic.indexOf(ch);
      b.write(i >= 0 ? '$i' : ch);
    }
    return b.toString();
  }

  /// Lower-case, strip tashkeel, unify alef/yaa/taa-marbuta, drop leading "ال".
  static String normalize(String input) {
    var s = _digits(input).toLowerCase().trim();
    s = s.replaceAll(RegExp('[\u064B-\u065F\u0670\u0640]'), '');
    s = s
        .replaceAll(RegExp('[أإآ]'), 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه');
    s = s.replaceAll(RegExp(r'[^\p{L}\p{N}.\s]', unicode: true), ' ');
    s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (s.startsWith('ال') && s.length > 4) s = s.substring(2);
    return s;
  }

  static bool _isNumberToken(String t) => RegExp(r'^\d+([.,]\d+)?$').hasMatch(t);

  static bool _isUnitToken(String t) => _unitTokens.contains(t);

  /// Parses [raw] into a [MealCorrection].
  static MealCorrection parse(String raw) {
    final text = _digits(raw.trim());
    final clauses = text
        .split(RegExp(r'[،,;؛\n]+'))
        .map((c) => c.trim())
        .where((c) => c.isNotEmpty)
        .toList();

    final negated = <String>[];
    final positiveClauses = <List<String>>[];

    for (final clause in clauses) {
      final tokens = clause.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
      var markerIdx = -1;
      for (var i = 0; i < tokens.length; i++) {
        if (_negationMarkers.contains(normalize(tokens[i]))) {
          markerIdx = i;
          break;
        }
      }

      final pos = <String>[];
      if (markerIdx < 0) {
        pos.addAll(tokens);
      } else {
        pos.addAll(tokens.sublist(0, markerIdx));
        var after = tokens.sublist(markerIdx + 1);
        // "بدل من X" / "بدلا من X"
        if (after.isNotEmpty && normalize(after.first) == 'من') {
          after = after.sublist(1);
        }
        // grams typed after the negated food still belong to the positive food
        for (final t in after) {
          final n = normalize(t);
          if (n.isEmpty || _fillers.contains(n)) continue;
          if (_isNumberToken(n) || _isUnitToken(n)) {
            pos.add(t);
          } else {
            negated.add(n);
          }
        }
      }

      final cleaned = pos.where((t) {
        final n = normalize(t);
        return n.isNotEmpty && !_fillers.contains(n);
      }).toList();
      if (cleaned.isNotEmpty) positiveClauses.add(cleaned);
    }

    // Merge amount-only clauses ("150 جم") into the previous food clause.
    final merged = <List<String>>[];
    for (final c in positiveClauses) {
      final amountOnly = c.every((t) {
        final n = normalize(t);
        return _isNumberToken(n) || _isUnitToken(n);
      });
      if (amountOnly && merged.isNotEmpty) {
        merged.last.addAll(c);
      } else {
        merged.add(List.of(c));
      }
    }

    // Stated grams: exactly one "<number> <unit>" in the whole text.
    final amountMatches = RegExp(
      r'(\d+(?:[.,]\d+)?)\s*(?:جم|جرام|غرام|جرامات|gm|gr|grams?|g)(?![\p{L}])',
      caseSensitive: false,
      unicode: true,
    ).allMatches(text).toList();
    double? grams;
    if (amountMatches.length == 1) {
      grams = double.tryParse(amountMatches.first.group(1)!.replaceAll(',', '.'));
      if (grams != null && (grams <= 0 || grams > 3000)) grams = null;
    }

    final out = merged.map((c) => c.join(' ')).join('، ');
    return MealCorrection(
      textForParser: out.trim(),
      negatedTerms: negated,
      statedGrams: grams,
    );
  }

  /// Whether an existing meal line (by its names) is what [term] refers to.
  static bool lineMatchesTerm({
    required String nameAr,
    required String nameEn,
    required String term,
  }) {
    final t = normalize(term);
    if (t.isEmpty) return false;
    final tokens = <String>{
      for (final w in normalize(nameAr).split(' ')) normalize(w),
      for (final w in normalize(nameEn).split(' ')) normalize(w),
    }..removeWhere((w) => w.isEmpty);

    for (final w in tokens) {
      if (w == t) return true;
      if (t.length >= 3 && w.length >= 3 && (w.startsWith(t) || t.startsWith(w))) {
        return true;
      }
    }
    for (final group in _synonymGroups) {
      if (group.contains(t) && tokens.any(group.contains)) return true;
    }
    return false;
  }
}
