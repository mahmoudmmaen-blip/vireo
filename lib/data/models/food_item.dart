class FoodItem {
  const FoodItem({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    this.category,
  });

  final String id;
  final String nameEn;
  final String nameAr;
  final String? category;

  String localizedName(String languageCode) =>
      languageCode == 'ar' ? nameAr : nameEn;

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as String,
      nameEn: json['name_en'] as String,
      nameAr: json['name_ar'] as String,
      category: json['category'] as String?,
    );
  }
}
