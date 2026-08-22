/// Canonical dietary restriction tags stored on the user profile.
abstract final class DietaryRestrictions {
  static const halal = 'halal';
  static const vegetarian = 'vegetarian';
  static const vegan = 'vegan';
  static const glutenFree = 'gluten_free';
  static const dairyFree = 'dairy_free';
  static const lowSodium = 'low_sodium';
  static const lowCarb = 'low_carb';
  static const diabeticFriendly = 'diabetic_friendly';

  static const all = [
    halal,
    vegetarian,
    vegan,
    glutenFree,
    dairyFree,
    lowSodium,
    lowCarb,
    diabeticFriendly,
  ];
}
