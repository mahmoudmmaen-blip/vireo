enum DailyCoinTask {
  meal(points: 10, titleAr: 'تسجيل وجبة', titleEn: 'Log Meal'),
  walk(points: 25, titleAr: 'هدف الخطوات', titleEn: 'Walk Goal'),
  water(points: 5, titleAr: 'شرب الماء', titleEn: 'Hydration'),
  workout(points: 25, titleAr: 'إكمال التمرين', titleEn: 'Workout'),
  weighIn(points: 5, titleAr: 'تسجيل الوزن', titleEn: 'Weigh-in'),
  moodCheck(points: 5, titleAr: 'فحص المزاج/الراحة', titleEn: 'Mood Check'),
  fasting(points: 15, titleAr: 'إكمال الصيام', titleEn: 'Complete Fast');

  const DailyCoinTask({
    required this.points,
    required this.titleAr,
    required this.titleEn,
  });

  final int points;
  final String titleAr;
  final String titleEn;
}
