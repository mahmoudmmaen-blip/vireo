import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';

class RamadanCountdownCard extends ConsumerStatefulWidget {
  const RamadanCountdownCard({super.key});

  @override
  ConsumerState<RamadanCountdownCard> createState() => _RamadanCountdownCardState();
}

class _RamadanCountdownCardState extends ConsumerState<RamadanCountdownCard> {
  Timer? _timer;

  void _syncTimer(bool enabled) {
    if (!enabled && _timer != null) {
      _timer?.cancel();
      _timer = null;
    } else if (enabled && _timer == null) {
      _timer = Timer.periodic(const Duration(seconds: 30), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(ramadanSettingsProvider);
    _syncTimer(settings.isEnabled);
    if (!settings.isEnabled) return const SizedBox.shrink();

    final prayer = ref.watch(ramadanPrayerTimesProvider);
    if (prayer == null) return const SizedBox.shrink();

    final colors = context.vireoColors;
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');

    final isFasting = prayer.isFasting;
    final timeFormat = DateFormat('h:mm a', isAr ? 'ar' : 'en');

    final countdownStr = isFasting
        ? prayer.formatCountdown(prayer.timeUntilIftar)
        : prayer.formatCountdown(prayer.timeUntilSuhoorEnd);

    final title = isFasting
        ? (isAr ? 'إفطار بعد ⏳ $countdownStr' : 'Iftar in ⏳ $countdownStr')
        : (isAr ? 'الإمساك بعد ⏳ $countdownStr' : 'Suhoor ends in ⏳ $countdownStr');

    final statusSubtitle = isFasting
        ? (isAr ? 'أذان المغرب: ${timeFormat.format(prayer.maghrib)}' : 'Maghrib: ${timeFormat.format(prayer.maghrib)}')
        : (isAr ? 'أذان الفجر: ${timeFormat.format(prayer.fajr)}' : 'Fajr: ${timeFormat.format(prayer.fajr)}');

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E293B),
            colors.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(VRadius.lg),
        border: Border.all(
          color: colors.gold.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.gold.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '🌙',
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: colors.gold,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      statusSubtitle,
                      style: TextStyle(
                        color: colors.textMute,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${settings.cityName}',
                      style: TextStyle(
                        color: colors.textMute.withValues(alpha: 0.8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
