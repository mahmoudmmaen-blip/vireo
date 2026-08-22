import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/config/app_config.dart';

void main() {
  late String completeMigration;

  setUpAll(() {
    completeMigration = File(
      'supabase/migrations/20240822160000_vireo_complete_schema_rls.sql',
    ).readAsStringSync();
  });

  group('§2.9 spec tables', () {
    const specTables = [
      'users',
      'exercises',
      'programs',
      'program_days',
      'checkins',
      'walking_logs',
      'weight_logs',
      'reassessments',
      'progress_photos',
      'food_items',
      'recipes',
      'fridge_scans',
      'meal_plans',
    ];

    test('complete migration defines all required tables', () {
      for (final table in specTables) {
        expect(
          completeMigration.contains('create table if not exists public.$table'),
          isTrue,
          reason: 'missing table $table',
        );
      }
    });

    test('RLS enabled on every spec table', () {
      for (final table in specTables) {
        expect(
          completeMigration.contains(
            'alter table public.$table enable row level security',
          ),
          isTrue,
          reason: 'RLS not enabled on $table',
        );
      }
    });

    test('user-owned tables have auth.uid() policies', () {
      const userOwned = [
        'users',
        'programs',
        'checkins',
        'walking_logs',
        'weight_logs',
        'reassessments',
        'progress_photos',
        'fridge_scans',
        'meal_plans',
      ];

      for (final table in userOwned) {
        expect(
          completeMigration.contains('create policy ${table}_select_own'),
          isTrue,
          reason: 'missing select policy for $table',
        );
      }
    });

    test('catalog tables are read-only for authenticated clients', () {
      expect(
        completeMigration.contains('create policy exercises_select_authenticated'),
        isTrue,
      );
      expect(
        completeMigration.contains('create policy food_items_select_authenticated'),
        isTrue,
      );
      expect(
        completeMigration.contains('create policy recipes_select_authenticated'),
        isTrue,
      );
    });
  });

  group('§2.9 migration chain', () {
    test('incremental migrations exist before complete schema', () {
      final dir = Directory('supabase/migrations');
      expect(dir.existsSync(), isTrue);

      final files = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.sql'))
          .map((f) => f.uri.pathSegments.last)
          .toList()
        ..sort();

      expect(files.length, greaterThanOrEqualTo(6));
      expect(files.last, '20240822160000_vireo_complete_schema_rls.sql');
    });
  });

  group('§2.9 delete-account edge function wiring', () {
    late String deleteAccountSource;

    setUpAll(() {
      deleteAccountSource = File(
        'supabase/functions/delete-account/index.ts',
      ).readAsStringSync();
    });

    test('function name matches AppConfig', () {
      expect(AppConfig.deleteAccountFunctionName, 'delete-account');
      expect(File('supabase/functions/delete-account/index.ts').existsSync(), isTrue);
    });

    test('cascade deletes spec user-owned tables', () {
      const cascadeTables = [
        'reassessments',
        'checkins',
        'weight_logs',
        'walking_logs',
        'progress_photos',
        'fridge_scans',
        'meal_plans',
        'programs',
        'program_days',
        'users',
      ];

      for (final table in cascadeTables) {
        expect(
          deleteAccountSource.contains("'$table'") ||
              deleteAccountSource.contains('from(\'$table\')') ||
              deleteAccountSource.contains('from("$table")'),
          isTrue,
          reason: 'delete-account should touch $table',
        );
      }
    });

    test('hard-deletes auth user via admin API', () {
      expect(deleteAccountSource.contains('auth.admin.deleteUser'), isTrue);
    });

    test('clears storage buckets for user media', () {
      expect(deleteAccountSource.contains('progress-photos'), isTrue);
      expect(deleteAccountSource.contains('fridge-scans'), isTrue);
    });

    test('rejects mismatched user_id in request body', () {
      expect(deleteAccountSource.contains('user_id mismatch'), isTrue);
    });
  });
}
