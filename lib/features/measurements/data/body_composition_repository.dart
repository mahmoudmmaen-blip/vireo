import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/core/services/sync_engine.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';

const _hiveKey = 'body_composition_reports_v1';

class BodyCompositionRepository {
  const BodyCompositionRepository();

  Future<List<BodyCompositionReport>> loadAll() async {
    final local = _loadLocal();
    try {
      if (SupabaseService.isInitialized) {
        final userId = SupabaseService.auth.currentUser?.id;
        if (userId != null) {
          final rows = await SupabaseService.client
              .from('body_composition')
              .select()
              .eq('user_id', userId)
              .order('test_date', ascending: false);
          final remote = (rows as List)
              .whereType<Map>()
              .map((e) => BodyCompositionReport.fromJson(
                    Map<String, dynamic>.from(e),
                  ))
              .toList();
          if (remote.isNotEmpty) {
            await _persistLocal(remote);
            return remote;
          }
        }
      }
    } catch (e) {
      BootLog.warn('body_composition remote load failed', e);
    }
    return local;
  }

  Future<void> save(BodyCompositionReport report) async {
    final all = await loadAll();
    final next = [
      report,
      ...all.where((r) => r.id != report.id),
    ]..sort((a, b) => b.testDate.compareTo(a.testDate));
    await _persistLocal(next);

    try {
      if (SupabaseService.isInitialized) {
        final userId = SupabaseService.auth.currentUser?.id;
        if (userId != null) {
          final row = report.toSupabaseRow(userId);
          // Upsert by id when present in DB; otherwise insert.
          if (report.id.startsWith('bc_')) {
            final inserted = await SupabaseService.client
                .from('body_composition')
                .insert(row)
                .select()
                .maybeSingle();
            if (inserted != null) {
              final withId = BodyCompositionReport.fromJson(
                Map<String, dynamic>.from(inserted),
              );
              final merged = [
                withId,
                ...next.where((r) => r.id != report.id),
              ];
              await _persistLocal(merged);
            }
          } else {
            await SupabaseService.client
                .from('body_composition')
                .upsert({...row, 'id': report.id});
          }
        }
      }
    } catch (e) {
      BootLog.warn('body_composition remote save failed', e);
    }

    try {
      await SyncEngine().enqueueChange(
        table: 'body_composition',
        id: report.id,
        operation: SyncOperation.update,
        data: report.toJson(),
      );
    } catch (_) {}
  }

  Future<void> delete(String id) async {
    final next = (await loadAll()).where((r) => r.id != id).toList();
    await _persistLocal(next);
    try {
      if (SupabaseService.isInitialized) {
        await SupabaseService.client
            .from('body_composition')
            .delete()
            .eq('id', id);
      }
    } catch (e) {
      BootLog.warn('body_composition delete failed', e);
    }

    try {
      await SyncEngine().enqueueChange(
        table: 'body_composition',
        id: id,
        operation: SyncOperation.delete,
        data: {'id': id},
      );
    } catch (_) {}
  }

  List<BodyCompositionReport> _loadLocal() {
    if (!HiveService.isInitialized) return const [];
    final raw = HiveService.cacheBox.get(_hiveKey);
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) =>
            BodyCompositionReport.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.testDate.compareTo(a.testDate));
  }

  Future<void> _persistLocal(List<BodyCompositionReport> list) async {
    if (!HiveService.isInitialized) return;
    await HiveService.cacheBox.put(
      _hiveKey,
      list.map((e) => e.toJson()).toList(),
    );
  }
}
