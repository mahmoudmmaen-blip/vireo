import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/sync_engine.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/profile/delete_account_warning_screen.dart';

final syncEngineProvider = Provider<SyncEngine>((ref) {
  return SyncEngine();
});

class PrivacySettingsScreen extends ConsumerStatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  ConsumerState<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends ConsumerState<PrivacySettingsScreen> {
  bool _isExporting = false;

  Future<void> _exportData() async {
    final auth = ref.read(authProvider).valueOrNull;
    final userId = auth?.user?.id ?? 'guest_user';
    final sync = ref.read(syncEngineProvider);

    setState(() => _isExporting = true);
    try {
      final export = await sync.exportUserData(userId);
      if (!mounted) return;
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Export My Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your data package is ready in JSON & CSV formats:'),
              const SizedBox(height: 12),
              ...export.keys.map(
                (k) => Text('• $k (${export[k]!.length} bytes)', style: const TextStyle(fontSize: 12)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final sync = ref.watch(syncEngineProvider);
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final backupPhotos = sync.isBackupPhotosEnabled;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(isArabic ? 'الخصوصية وإدارة البيانات' : 'Privacy & Data Management'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section 1: Cloud Backup & Sync
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceRaised,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'النسخ السحابي' : 'Cloud Backup & Sync',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  isArabic
                      ? 'يتم حفظ بياناتك محلياً أولاً ومزامنتها تلقائياً عند توفر الإنترنت.'
                      : 'Your data is written locally first and synced securely to the cloud when online.',
                  style: TextStyle(color: colors.textMute, fontSize: 12),
                ),
                const SizedBox(height: 12),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(isArabic ? 'النسخ الاحتياطي لصور التقدم' : 'Back up progress photos'),
                  subtitle: Text(
                    isArabic
                        ? 'مستبعدة افتراضياً لحماية خصوصيتك التامة.'
                        : 'Excluded by default from sync to protect your privacy.',
                    style: TextStyle(color: colors.textMute, fontSize: 11),
                  ),
                  value: backupPhotos,
                  onChanged: (val) async {
                    await sync.setBackupPhotosEnabled(val);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Section 2: Export Data
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceRaised,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'تصدير بياناتي' : 'Export My Data',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  isArabic
                      ? 'حمّل نسخة كاملة من سجلاتك الغذائية والخطوات والوزن بتنسيقي JSON وCSV.'
                      : 'Download a complete export of your meals, steps, and weight records in JSON & CSV.',
                  style: TextStyle(color: colors.textMute, fontSize: 12),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: _isExporting ? null : _exportData,
                  icon: _isExporting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download_outlined, size: 18),
                  label: Text(
                    isArabic ? 'تصدير ملفاتي الآن' : 'Export Data Package',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Section 3: Delete Account & Wipe Data
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceRaised,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.danger.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'حذف الحساب والبيانات بالكامل' : 'Delete My Account & Data',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colors.danger,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isArabic
                      ? 'سيتم مسح جميع بياناتك نهائياً من هذا الجهاز ومن خوادم السحابة بما فيها الصور والمجموعات.'
                      : 'Permanently deletes all stored data from this device and cloud servers.',
                  style: TextStyle(color: colors.textMute, fontSize: 12),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: colors.danger),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const DeleteAccountWarningScreen(),
                    ),
                  ),
                  child: Text(isArabic ? 'بدء حذف الحساب' : 'Delete Account'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
