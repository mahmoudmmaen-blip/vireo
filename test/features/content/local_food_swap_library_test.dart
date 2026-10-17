import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/content/data/local_food_swap_library.dart';
import 'package:vireo/features/content/models/local_food_swap.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('local_food_swaps.json', () {
    late List<LocalFoodSwap> swaps;

    setUpAll(() {
      final path = '${Directory.current.path}/assets/content/local_food_swaps.json';
      final raw = File(path).readAsStringSync();
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      swaps = (decoded['swaps'] as List)
          .map((e) => LocalFoodSwap.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    });

    test('length is at least 100 with positive savings', () {
      expect(swaps.length, greaterThanOrEqualTo(100));
      for (final s in swaps) {
        expect(s.savedKcal, greaterThanOrEqualTo(15));
        expect(s.fromFoodId, isNotEmpty);
        expect(s.toFoodId, isNotEmpty);
      }
    });

    test('picker returns best swap for known food id', () async {
      final pick = await LocalFoodSwapLibrary.instance.bestForFoodIds(['koshary_egyptian']);
      expect(pick, isNotNull);
      expect(pick!.fromFoodId, 'koshary_egyptian');
    });
  });
}
