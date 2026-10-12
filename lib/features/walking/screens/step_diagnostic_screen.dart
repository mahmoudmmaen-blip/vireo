import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';
import 'package:vireo/features/walking/data/step_permission.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';

class StepDiagnosticScreen extends ConsumerStatefulWidget {
  const StepDiagnosticScreen({super.key});

  @override
  ConsumerState<StepDiagnosticScreen> createState() => _StepDiagnosticScreenState();
}

class _StepDiagnosticScreenState extends ConsumerState<StepDiagnosticScreen> {

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final live = ref.watch(liveStepsProvider).valueOrNull ?? StepCounterService.latest;
    final state = StepCounterService.readRawState();
    final history = StepCounterService.readHistory();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('تشخيص الخطوات (Step Diagnostics)'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sensor status card
          _Card(
            title: 'حالة الحساس (Hardware Sensor)',
            icon: Icons.sensors_rounded,
            color: live.sensorAvailable ? colors.success : colors.danger,
            children: [
              _Row('مدعوم في الجهاز (Supported)', live.sensorAvailable ? 'نعم (Yes)' : 'لا (No)'),
              _Row('الصلاحية ممنوحة (Permission)', live.permissionGranted ? 'ممنوحة (Granted)' : 'مرفوضة (Denied)'),
              _Row('مصدر الخطوات الحالي (Source)', live.source.name),
              _Row('خطوات اليوم المسجلة (Today Steps)', '${live.todaySteps}'),
            ],
          ),
          const SizedBox(height: 16),

          // Cumulative & Baseline logic
          _Card(
            title: 'قيم الحساب والبداية (Baseline & Offsets)',
            icon: Icons.calculate_outlined,
            color: colors.ember,
            children: [
              _Row('تاريخ التسجيل (Date)', '${state['date'] ?? 'غير محدد'}'),
              _Row('قيمة البداية (Baseline)', '${state['baseline'] ?? 'غير محدد'}'),
              _Row('إزاحة إعادة التشغيل (Reboot Offset)', '${state['offset'] ?? 0}'),
              _Row('آخر قراءة تراكمية (Last Cumulative)', '${state['lastCumulative'] ?? 'غير محدد'}'),
            ],
          ),
          const SizedBox(height: 16),

          // Actions
          _Card(
            title: 'إجراءات الإصلاح (Troubleshooting Actions)',
            icon: Icons.build_circle_outlined,
            color: colors.gold,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.security_update_good_rounded),
                title: const Text('طلب صلاحية النشاط البدني مجدداً'),
                subtitle: const Text('Request Activity Recognition permission'),
                trailing: ElevatedButton(
                  onPressed: () async {
                    HapticFeedback.selectionClick();
                    await StepPermission.request();
                    await StepCounterService.startListening();
                    await StepCounterService.refresh();
                    setState(() {});
                  },
                  child: const Text('طلب'),
                ),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.settings_outlined),
                title: const Text('فتح إعدادات التطبيق في النظام'),
                subtitle: const Text('Open App Settings in OS'),
                trailing: OutlinedButton(
                  onPressed: () => StepPermission.openSettings(),
                  child: const Text('فتح'),
                ),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.refresh_rounded),
                title: const Text('إعادة ضبط نقطة البداية (Reset Baseline)'),
                subtitle: const Text('يعيد حساب الخطوات من الصفر لليوم الحالي'),
                trailing: TextButton(
                  style: TextButton.styleFrom(foregroundColor: colors.danger),
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    await StepCounterService.resetBaseline();
                    setState(() {});
                  },
                  child: const Text('إعادة ضبط'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Recent 7 days in history
          _Card(
            title: 'سجل الأيام السابقة (Hive History)',
            icon: Icons.history_rounded,
            color: VMacro.steps,
            children: [
              for (final entry in history.entries.take(7))
                _Row(entry.key, '${entry.value} خطوة'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(VRadius.md),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: colors.textMute, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }
}
