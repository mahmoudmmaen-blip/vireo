/// Selectable calorie companions ("رفيقك"). Original flat characters only.
enum MascotCompanion {
  panda, // باندا
  cat, // قطة
  camel, // جمل صغير
  owl, // بومة
}

extension MascotCompanionX on MascotCompanion {
  String get id => name;

  String labelAr(bool isFemale) => switch (this) {
        MascotCompanion.panda => 'باندا',
        MascotCompanion.cat => 'قطة',
        MascotCompanion.camel => 'جمل صغير',
        MascotCompanion.owl => 'بومة',
      };

  String labelEn() => switch (this) {
        MascotCompanion.panda => 'Panda',
        MascotCompanion.cat => 'Cat',
        MascotCompanion.camel => 'Camel',
        MascotCompanion.owl => 'Owl',
      };

  static MascotCompanion fromId(String? id) {
    if (id == null) return MascotCompanion.panda;
    return MascotCompanion.values.firstWhere(
      (c) => c.name == id,
      orElse: () => MascotCompanion.panda,
    );
  }
}
