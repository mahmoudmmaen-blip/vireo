import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/locale_provider.dart';

void main() {
  test('default locale is Arabic when no preference is stored', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(localeProvider).languageCode, 'ar');
  });
}
