import 'dart:io';
import 'dart:ui' as ui show ImageByteFormat;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/content/data/food_facts_repository.dart';
import 'package:vireo/features/content/models/food_fact.dart';

final _dailyFoodFactProvider = FutureProvider<FoodFact?>((ref) {
  return FoodFactsRepository.instance.factForDay(DateTime.now());
});

class DailyFoodFactCard extends ConsumerStatefulWidget {
  const DailyFoodFactCard({super.key});

  @override
  ConsumerState<DailyFoodFactCard> createState() => _DailyFoodFactCardState();
}

class _DailyFoodFactCardState extends ConsumerState<DailyFoodFactCard> {
  final GlobalKey _shareKey = GlobalKey();
  bool _sharing = false;

  Future<void> _share(FoodFact fact, bool isAr) async {
    if (_sharing) return;
    setState(() => _sharing = true);
    try {
      final boundary = _shareKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/vireo_food_fact_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      if (!mounted) return;
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: isAr ? fact.titleAr : fact.titleEn,
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');
    final async = ref.watch(_dailyFoodFactProvider);

    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (fact) {
        if (fact == null) return const SizedBox.shrink();
        final title = isAr ? fact.titleAr : fact.titleEn;
        final body = isAr ? fact.bodyAr : fact.bodyEn;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: RepaintBoundary(
            key: _shareKey,
            child: Material(
              color: colors.surface,
              borderRadius: BorderRadius.circular(VRadius.md),
              child: InkWell(
                onTap: () => _share(fact, isAr),
                borderRadius: BorderRadius.circular(VRadius.md),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(VRadius.md),
                    border: Border.all(color: colors.line.withValues(alpha: 0.55)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: colors.gold, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.foodFactCardTitle,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: colors.gold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          if (_sharing)
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: colors.gold),
                            )
                          else
                            Icon(Icons.ios_share, size: 18, color: colors.textMute),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        body,
                        style: TextStyle(color: colors.textMute, fontSize: 12.5, height: 1.35),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.foodFactShareHint,
                        style: TextStyle(color: colors.textMute.withValues(alpha: 0.85), fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
