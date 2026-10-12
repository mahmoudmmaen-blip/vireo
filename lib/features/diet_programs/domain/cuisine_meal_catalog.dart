import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/diet_programs/domain/cuisine_type.dart';

abstract final class CuisineMealCatalog {
  static String sampleDishName({
    required CuisineType cuisine,
    required MealType type,
    required String locale,
  }) {
    final isAr = locale.startsWith('ar');
    return switch (cuisine) {
      CuisineType.egyptian => switch (type) {
          MealType.breakfast => isAr ? 'فول مدمس وزيت زيتون وبيض مسلوق' : 'Ful mudammas & boiled eggs',
          MealType.lunch => isAr ? 'صدور دجاج مشوية مع أرز بسمتي وسلطة' : 'Grilled chicken, basmati rice & salad',
          MealType.dinner => isAr ? 'جبنة قريش بالطماطم وزيت الزيتون' : 'Cottage cheese with tomatoes & olive oil',
          MealType.snack => isAr ? 'حفنة مكسرات أو زبادي يوناني' : 'Handful of almonds or Greek yogurt',
        },
      CuisineType.saudi => switch (type) {
          MealType.breakfast => isAr ? 'شكشوكة بالبيض والخضار الطازج' : 'Shakshuka with eggs & fresh greens',
          MealType.lunch => isAr ? 'كبسة دجاج صحية مشوية مع سلطة' : 'Healthy chicken kabsa with salad',
          MealType.dinner => isAr ? 'تونا بزيت الزيتون وسلطة خضراء' : 'Tuna salad with olive oil',
          MealType.snack => isAr ? 'تمر مع قهوة سعودية ومكسرات' : 'Dates with coffee & walnuts',
        },
      CuisineType.levantine => switch (type) {
          MealType.breakfast => isAr ? 'لبنة بزيت الزيتون وزعتر وبيض مسلوق' : 'Labneh with zaatar & boiled eggs',
          MealType.lunch => isAr ? 'شيش طاووق مشوي مع برغل وتبولة' : 'Grilled shish tawook with bulgur & tabbouleh',
          MealType.dinner => isAr ? 'جبنة حلوم مشوية وسلطة فتوش خفيفة' : 'Grilled halloumi with light fattoush',
          MealType.snack => isAr ? 'خيار وجزر مع حمص بطحينة' : 'Hummus dip with fresh vegetables',
        },
      CuisineType.moroccan => switch (type) {
          MealType.breakfast => isAr ? 'بيض بالخليع أو زيت زيتون وجبن بلدي' : 'Poached eggs with olive oil & fresh cheese',
          MealType.lunch => isAr ? 'طاجين دجاج بالليمون والخضار' : 'Chicken tagine with preserved lemon & vegetables',
          MealType.dinner => isAr ? 'شوربة حريرة صحية غنية بالبروتين' : 'High-protein Harira soup',
          MealType.snack => isAr ? 'فواكه مجففة ولوز مغربي' : 'Moroccan almonds & dried figs',
        },
      CuisineType.turkish => switch (type) {
          MealType.breakfast => locale == 'tr' ? 'Menemen, beyaz peynir ve zeytin' : 'Menemen with feta & olives',
          MealType.lunch => locale == 'tr' ? 'Izgara tavuk şiş, bulgur ve çoban salata' : 'Grilled chicken shish with bulgur & salad',
          MealType.dinner => locale == 'tr' ? 'Mercimek çorbası ve ızgara köfte' : 'Lentil soup & grilled kofte',
          MealType.snack => locale == 'tr' ? 'Süzme yoğurt ve ceviz' : 'Strained yogurt & walnuts',
        },
      CuisineType.indian => switch (type) {
          MealType.breakfast => locale == 'hi' ? 'बेसन चीला या अंडा भुर्जी' : 'Besan chilla or egg bhurji with chai',
          MealType.lunch => locale == 'hi' ? 'तंदूरी चिकन, ब्राउन राइस और दाल' : 'Tandoori chicken, brown rice & yellow dal',
          MealType.dinner => locale == 'hi' ? 'पनीर टिक्का और खीरा रायता' : 'Paneer tikka with cucumber raita',
          MealType.snack => locale == 'hi' ? 'रोस्टेड मखाना और बादाम' : 'Roasted makhana & almonds',
        },
      CuisineType.indonesian => switch (type) {
          MealType.breakfast => locale == 'id' ? 'Telur rebus, tempe panggang & lalapan' : 'Boiled eggs, grilled tempeh & greens',
          MealType.lunch => locale == 'id' ? 'Ayam bakar dengan nasi merah & sayur asem' : 'Grilled chicken, red rice & sayur asem',
          MealType.dinner => locale == 'id' ? 'Ikan panggang & tumis kangkung' : 'Grilled fish & stir-fried water spinach',
          MealType.snack => locale == 'id' ? 'Edamame rebus atau buah segar' : 'Boiled edamame or fresh papaya',
        },
      CuisineType.western => switch (type) {
          MealType.breakfast => isAr ? 'شوفان بالواي بروتين والتوت' : 'Oatmeal with whey protein & fresh berries',
          MealType.lunch => isAr ? 'سلمون مشوي مع كينوا وخضار سوتيه' : 'Grilled salmon with quinoa & steamed greens',
          MealType.dinner => isAr ? 'صدور ديك رومي وسلطة يونانية' : 'Turkey breast with Greek salad',
          MealType.snack => isAr ? 'زبادي يوناني مع بذور الشيا' : 'Greek yogurt bowl with chia seeds',
        },
    };
  }

  static String sampleRamadanDishName({
    required CuisineType cuisine,
    required String slot, // 'suhoor', 'iftar', 'snack'
    required String locale,
  }) {
    final isAr = locale.startsWith('ar');
    return switch (cuisine) {
      CuisineType.egyptian => switch (slot) {
          'suhoor' => isAr ? 'فول بالكمون وزيت الزيتون، بيض مسلوق، عيش بلدي، زبادي خفيف' : 'Ful mudammas, boiled eggs, baladi bread, light yogurt',
          'iftar' => isAr ? 'شوربة لسان عصفور، فراخ مشوية، سلطة خضراء، أرز بالشعرية' : 'Orzo soup, grilled chicken, green salad, vermicelli rice',
          _ => isAr ? 'تمرتان وقطايف مشوية باعتدال أو زبادي مع عسل' : '2 dates & moderate baked qatayef or yogurt with honey',
        },
      CuisineType.saudi => switch (slot) {
          'suhoor' => isAr ? 'فول حجازي، بيض، زبادي وتمر مع ماء وفير' : 'Hijazi ful, eggs, yogurt and dates with plenty of water',
          'iftar' => isAr ? 'شوربة شوفان باللحم، كبسة دجاج خفيفة، سمبوسة بالفرن، سلطة' : 'Meat oat soup, baked sambusa, light chicken kabsa',
          _ => isAr ? 'تمر ورطب مع قهوة سعودية وحفنة لوز' : 'Fresh dates with Saudi coffee & almonds',
        },
      CuisineType.levantine => switch (slot) {
          'suhoor' => isAr ? 'مناقيش زعتر خفيفة، لبنة بلدية، خيار وطماطم، بيض مسلوق' : 'Light zaatar manoushe, labneh, cucumber & eggs',
          'iftar' => isAr ? 'شوربة عدس، فتوش خفيف، شيش طاووق مع أرز أو برغل' : 'Lentil soup, light fattoush, shish tawook with bulgur',
          _ => isAr ? 'مهلبية خفيفة أو فواكه مجففة مع جوز' : 'Light muhallabia or dried fruits with walnuts',
        },
      _ => switch (slot) {
          'suhoor' => isAr ? 'شوفان بالحليب والمكسرات، بيض مسلوق، زبادي' : 'Oats with milk & nuts, boiled eggs, yogurt',
          'iftar' => isAr ? 'شوربة خضار أو عدس، بروتين مشوي، أرز وسلطة مشكلة' : 'Lentil or vegetable soup, grilled protein, rice & salad',
          _ => isAr ? 'تمر ومكسرات أو سلطة فواكه طازجة' : 'Dates and mixed nuts or fresh fruit salad',
        },
    };
  }
}
