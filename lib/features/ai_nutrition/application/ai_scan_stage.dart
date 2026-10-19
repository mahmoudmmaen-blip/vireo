/// Staged progress shown while a meal photo is analyzed (P52).
enum AiScanStage {
  readingPlate,
  identifyingIngredients,
  estimatingOil,
}

extension AiScanStageLabels on AiScanStage {
  String labelAr() => switch (this) {
        AiScanStage.readingPlate => 'بنحلل الطبق…',
        AiScanStage.identifyingIngredients => 'بنقدّر المكونات…',
        AiScanStage.estimatingOil => 'بنحسب الزيت…',
      };

  String labelEn() => switch (this) {
        AiScanStage.readingPlate => 'Reading the plate…',
        AiScanStage.identifyingIngredients => 'Identifying ingredients…',
        AiScanStage.estimatingOil => 'Estimating oil…',
      };
}
