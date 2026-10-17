import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/ramadan/domain/ramadan_prayer_city.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';

/// Picks a preset city or custom lat/long (no location permission).
Future<void> showRamadanCityPicker(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final locale = Localizations.localeOf(context).languageCode;
  final isAr = locale.startsWith('ar');
  final settings = ref.read(ramadanSettingsProvider);

  final picked = await showModalBottomSheet<RamadanPrayerCityPreset?>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      final colors = ctx.vireoColors;
      return SafeArea(
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          builder: (_, scrollCtrl) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    l10n.ramadanPrayerCityPickerTitle,
                    style: Theme.of(ctx).textTheme.titleLarge,
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollCtrl,
                    children: [
                      for (final city in RamadanPrayerCities.presets)
                        ListTile(
                          leading: Icon(
                            settings.cityPresetId == city.id
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: colors.gold,
                          ),
                          title: Text(city.localizedName(locale)),
                          subtitle: Text(
                            isAr
                                ? city.calculationMethod.labelAr
                                : city.calculationMethod.name,
                            style: TextStyle(fontSize: 12, color: colors.textMute),
                          ),
                          onTap: () => Navigator.pop(ctx, city),
                        ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.edit_location_alt_outlined),
                        title: Text(l10n.ramadanPrayerCityCustom),
                        subtitle: settings.cityPresetId == RamadanPrayerCityIds.custom
                            ? Text(
                                '${settings.cityName} (${settings.latitude.toStringAsFixed(2)}, ${settings.longitude.toStringAsFixed(2)})',
                                style: TextStyle(fontSize: 12, color: colors.textMute),
                              )
                            : null,
                        onTap: () async {
                          final custom = await _showCustomCityDialog(ctx, l10n, settings);
                          if (custom != null && ctx.mounted) {
                            Navigator.pop(ctx, custom);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );

  if (picked == null) return;
  if (picked.id == RamadanPrayerCityIds.custom) {
    // Custom dialog already applied via notifier.
    return;
  }
  await ref.read(ramadanSettingsProvider.notifier).setCityPreset(picked);
}

Future<RamadanPrayerCityPreset?> _showCustomCityDialog(
  BuildContext context,
  AppLocalizations l10n,
  RamadanSettingsState settings,
) async {
  final nameCtrl = TextEditingController(text: settings.cityName);
  final latCtrl = TextEditingController(text: settings.latitude.toStringAsFixed(4));
  final lngCtrl = TextEditingController(text: settings.longitude.toStringAsFixed(4));

  String? savedName;
  double? savedLat;
  double? savedLng;

  final saved = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.ramadanPrayerCityCustom),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(labelText: l10n.ramadanCustomCityName),
            ),
            TextField(
              controller: latCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: InputDecoration(labelText: l10n.ramadanCustomCityLat),
            ),
            TextField(
              controller: lngCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: InputDecoration(labelText: l10n.ramadanCustomCityLng),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.reassessmentLater),
        ),
        FilledButton(
          onPressed: () {
            savedLat = double.tryParse(latCtrl.text.trim());
            savedLng = double.tryParse(lngCtrl.text.trim());
            final n = nameCtrl.text.trim();
            savedName = n.isEmpty ? l10n.ramadanPrayerCityCustom : n;
            if (savedLat == null ||
                savedLng == null ||
                savedLat!.abs() > 90 ||
                savedLng!.abs() > 180) {
              return;
            }
            Navigator.pop(ctx, true);
          },
          child: Text(l10n.waterAddCustom),
        ),
      ],
    ),
  );

  nameCtrl.dispose();
  latCtrl.dispose();
  lngCtrl.dispose();

  if (saved != true || savedLat == null || savedLng == null || savedName == null) {
    return null;
  }

  final lat = savedLat!;
  final lng = savedLng!;
  final name = savedName!;

  if (!context.mounted) return null;
  final container = ProviderScope.containerOf(context);
  await container.read(ramadanSettingsProvider.notifier).setCustomLocation(
        cityName: name,
        lat: lat,
        lng: lng,
      );

  return RamadanPrayerCityPreset(
    id: RamadanPrayerCityIds.custom,
    nameAr: name,
    nameEn: name,
    latitude: lat,
    longitude: lng,
    calculationMethod: settings.calculationMethod,
  );
}
