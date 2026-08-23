import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/data/demo/exercise_demo_catalog.dart';

/// Seeds global catalog tables via Supabase client when empty (no CLI required).
abstract final class CatalogSeedService {
  static const _minExercises = 20;

  static Future<void> seedIfNeeded() async {
    if (!SupabaseService.isInitialized) {
      BootLog.step('CatalogSeedService skipped (Supabase offline)');
      return;
    }

    try {
      await _seedExercisesIfNeeded();
    } catch (e) {
      BootLog.warn('CatalogSeedService failed — continuing offline', e);
    }
  }

  static Future<void> _seedExercisesIfNeeded() async {
    final existing = await SupabaseService.client
        .from('exercises')
        .select('id')
        .limit(_minExercises);

    final count = (existing as List).length;
    if (count >= _minExercises) {
      BootLog.step('CatalogSeedService exercises OK ($count rows)');
      return;
    }

    BootLog.step('CatalogSeedService seeding ${ExerciseDemoCatalog.seedRows.length} exercises');
    await SupabaseService.client
        .from('exercises')
        .upsert(ExerciseDemoCatalog.seedRows, onConflict: 'id');
    BootLog.ok('CatalogSeedService exercises seeded');
  }
}
