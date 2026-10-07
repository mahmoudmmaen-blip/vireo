enum VitalityCategory {
  nutrition,
  training,
  lifestyle,
  environmental,
  advanced,
}

class VitalityScientificSource {
  const VitalityScientificSource({
    required this.titleEn,
    required this.titleAr,
    required this.url,
  });

  final String titleEn;
  final String titleAr;
  final String url;

  String titleFor(String locale) => locale == 'ar' ? titleAr : titleEn;
}

class VitalityContentBlock {
  const VitalityContentBlock({
    this.headingEn,
    this.headingAr,
    this.bulletsEn = const [],
    this.bulletsAr = const [],
    this.keyTakeawayEn,
    this.keyTakeawayAr,
    this.protocolStepsEn = const [],
    this.protocolStepsAr = const [],
  });

  final String? headingEn;
  final String? headingAr;
  final List<String> bulletsEn;
  final List<String> bulletsAr;
  final String? keyTakeawayEn;
  final String? keyTakeawayAr;
  final List<String> protocolStepsEn;
  final List<String> protocolStepsAr;

  String? headingFor(String locale) =>
      locale == 'ar' ? headingAr : headingEn;

  List<String> bulletsFor(String locale) =>
      locale == 'ar' ? bulletsAr : bulletsEn;

  String? keyTakeawayFor(String locale) =>
      locale == 'ar' ? keyTakeawayAr : keyTakeawayEn;

  List<String> protocolStepsFor(String locale) =>
      locale == 'ar' ? protocolStepsAr : protocolStepsEn;
}

class VitalityProtocolItem {
  const VitalityProtocolItem({
    required this.id,
    required this.textEn,
    required this.textAr,
  });

  final String id;
  final String textEn;
  final String textAr;

  String textFor(String locale) => locale == 'ar' ? textAr : textEn;
}

class VitalityArticle {
  const VitalityArticle({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.summaryEn,
    required this.summaryAr,
    required this.category,
    required this.readingTimeMinutes,
    required this.blocks,
    required this.scientificSources,
    this.protocolItems = const [],
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String summaryEn;
  final String summaryAr;
  final VitalityCategory category;
  final int readingTimeMinutes;
  final List<VitalityContentBlock> blocks;
  final List<VitalityScientificSource> scientificSources;
  final List<VitalityProtocolItem> protocolItems;

  String titleFor(String locale) => locale == 'ar' ? titleAr : titleEn;
  String summaryFor(String locale) => locale == 'ar' ? summaryAr : summaryEn;

  bool get hasProtocol => protocolItems.isNotEmpty;
}

class VitalityTip {
  const VitalityTip({
    required this.id,
    required this.textEn,
    required this.textAr,
  });

  final String id;
  final String textEn;
  final String textAr;

  String textFor(String locale) => locale == 'ar' ? textAr : textEn;
}

abstract class IVitalityContentRepository {
  List<VitalityArticle> getArticles();
  VitalityArticle? getArticleById(String id);
  List<VitalityTip> getDailyTips();
  VitalityTip tipForDay(DateTime date);
}
