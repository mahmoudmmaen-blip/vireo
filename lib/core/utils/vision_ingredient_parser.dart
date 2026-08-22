import 'dart:convert';

/// Parses vision model output into ingredient chips (Section 4).
/// Mirrors `parseIngredientArray` in `vision-client.ts`.
abstract final class VisionIngredientParser {
  static List<String> parse(String raw) {
    var text = raw.trim();

    final fenced = RegExp(
      r'```(?:json)?\s*([\s\S]*?)```',
      caseSensitive: false,
    ).firstMatch(text);
    if (fenced != null) {
      text = fenced.group(1)!.trim();
    }

    final decoded = jsonDecode(text);
    if (decoded is! List) {
      throw const FormatException('VISION_INVALID_SHAPE');
    }

    final ingredients = <String>[];
    final seen = <String>{};

    for (final item in decoded) {
      if (item is! String) continue;
      final normalized = item.trim();
      if (normalized.isEmpty) continue;
      final key = normalized.toLowerCase();
      if (seen.contains(key)) continue;
      seen.add(key);
      ingredients.add(normalized);
    }

    return ingredients;
  }
}
