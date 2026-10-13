enum FastingPlanType {
  p12_12('12:12', 12, 12, '12:12 للمبتدئين', '12:12 Beginner', 'صيام 12 ساعة ونافذة طعام 12 ساعة — بداية لطيفة ومناسبة للجميع', true),
  p14_10('14:10', 14, 10, '14:10 للمبتدئين', '14:10 Beginner', 'صيام 14 ساعة ونافذة طعام 10 ساعات — تحكم ممتاز بالجوع وسكر الدم', true),
  p16_8('16:8', 16, 8, '16:8 الأكثر شعبية', '16:8 Most Popular', 'صيام 16 ساعة ونافذة طعام 8 ساعات — الخيار الذهبي للياقة وحرق الدهون', false),
  p18_6('18:6', 18, 6, '18:6 للمتقدمين', '18:6 Advanced', 'صيام 18 ساعة ونافذة طعام 6 ساعات — تحفيز أعمق لإنتاج الكيتونات', false),
  p20_4('20:4', 20, 4, '20:4 المحارب (Warrior)', '20:4 Warrior', 'صيام 20 ساعة ونافذة طعام 4 ساعات — وجبتان مغذيتان ومتقاربتان', false),
  omad('23:1', 23, 1, 'وجبة واحدة (OMAD)', 'OMAD (23:1)', 'صيام 23 ساعة ونافذة طعام ساعة واحدة لوجبة رئيسية كاملة', false),
  p5_2('5:2', 16, 8, 'نظام 5:2 الأسبوعي', '5:2 Weekly Plan', 'صيام يومين متفرقين في الأسبوع بأيام طبيعية بينهما', false),
  custom('مخصص', 16, 8, 'خطة مخصصة', 'Custom Plan', 'حدد ساعات الصيام المناسبة لجدولك اليومي (حتى 72 ساعة كحد أقصى)', false);

  const FastingPlanType(
    this.code,
    this.defaultFastHours,
    this.defaultEatingHours,
    this.nameAr,
    this.nameEn,
    this.descriptionAr,
    this.isBeginner,
  );

  final String code;
  final int defaultFastHours;
  final int defaultEatingHours;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final bool isBeginner;

  String displayName(bool isArabic) => isArabic ? nameAr : nameEn;

  /// Recommends a starter plan based on experience level
  static FastingPlanType recommendedForLevel({required bool isBeginner}) {
    return isBeginner ? FastingPlanType.p12_12 : FastingPlanType.p16_8;
  }
}
