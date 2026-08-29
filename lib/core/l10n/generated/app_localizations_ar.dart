// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Vireo';

  @override
  String get homeTitle => 'الرئيسية';

  @override
  String get onboardingTitle => 'مرحباً';

  @override
  String get workoutTitle => 'التمارين';

  @override
  String get nutritionTitle => 'التغذية';

  @override
  String get progressTitle => 'التقدم';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get authTitle => 'تسجيل الدخول';

  @override
  String get languageToggle => 'English';

  @override
  String get setupComplete => 'Vireo جاهز';

  @override
  String get continueButton => 'متابعة';

  @override
  String get skipButton => 'تخطي';

  @override
  String get finishButton => 'إنهاء';

  @override
  String get yesButton => 'نعم';

  @override
  String get noButton => 'لا';

  @override
  String onboardingStepProgress(int current, int total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get onboardingStep1Title => 'عنك';

  @override
  String get onboardingStep1Subtitle => 'هنخصّص خطتك من المعلومات دي.';

  @override
  String get onboardingStep2Title => 'فحص صحي';

  @override
  String get onboardingStep2Subtitle =>
      'جاوب بصدق — ده بيساعدنا نخلي التمارين أأمن.';

  @override
  String get onboardingStep3Title => 'بتتمرّن فين؟';

  @override
  String get onboardingStep3Subtitle => 'هنعرض بس تمارين تناسب بيئة تمرينك.';

  @override
  String get onboardingStep4Title => 'هدفك';

  @override
  String get onboardingStep4Subtitle => 'إيه الأهم ليك دلوقتي؟';

  @override
  String get onboardingStep5Title => 'قبل ما نبدأ';

  @override
  String get onboardingStep5Subtitle => 'اقرأ ووافق عشان تكمل.';

  @override
  String get onboardingStep6Title => 'فاكرني';

  @override
  String get onboardingStep6Subtitle =>
      'تذكيرات اختيارية — تقدر تغيّرها بعدين.';

  @override
  String get unitsMetric => 'كجم / سم';

  @override
  String get unitsImperial => 'lb / in';

  @override
  String get onboardingAge => 'السن';

  @override
  String get onboardingHeight => 'الطول';

  @override
  String get onboardingWeight => 'الوزن';

  @override
  String get onboardingActivityLevel => 'مستوى النشاط';

  @override
  String get onboardingDietaryOptional => 'قيود غذائية (اختياري)';

  @override
  String get activitySedentary => 'قليل الحركة';

  @override
  String get activityModerate => 'نشاط متوسط';

  @override
  String get activityVeryActive => 'نشيط جداً';

  @override
  String get dietHalal => 'حلال';

  @override
  String get dietVegetarian => 'نباتي';

  @override
  String get dietVegan => 'نباتي صرف';

  @override
  String get dietGlutenFree => 'خالي من الجلوتين';

  @override
  String get dietDairyFree => 'خالي من اللاكتوز';

  @override
  String get dietLowSodium => 'قليل الملح';

  @override
  String get dietLowCarb => 'قليل الكارب';

  @override
  String get dietDiabeticFriendly => 'مناسب للسكري';

  @override
  String get onboardingMedicalFlagNotice =>
      'هنخفّف الشدة ونظهر تحذيرات أمان في التمرين.';

  @override
  String get healthQuestionHeart => 'أمراض قلب أو أوعية دموية؟';

  @override
  String get healthQuestionDiabetes => 'سكري أو مشاكل سكر في الدم؟';

  @override
  String get healthQuestionBloodPressure => 'ضغط دم مرتفع أو منخفض؟';

  @override
  String get healthQuestionJoints => 'إصابات مفاصل أو ألم مزمن؟';

  @override
  String get healthQuestionMedications => 'بتاخد أدوية بانتظام؟';

  @override
  String get envHomeNoEquipment => 'البيت — بدون معدات';

  @override
  String get envHomeNoEquipmentDesc => 'تمارين وزن الجسم فقط';

  @override
  String get envHomeLightEquipment => 'البيت — معدات خفيفة';

  @override
  String get envHomeLightEquipmentDesc => 'حبال، دамбل، أو مشابه';

  @override
  String get envGymFull => 'جيم كامل';

  @override
  String get envGymFullDesc => 'أجهزة، بار، rack';

  @override
  String get envWalkingOnly => 'مشي بس';

  @override
  String get envWalkingOnlyDesc => 'خطوات وحركة خفيفة';

  @override
  String get goalWeightLoss => 'خسارة وزن';

  @override
  String get goalWeightLossDesc => 'حرق دهون بتمرين مستدام';

  @override
  String get goalMuscleGain => 'بناء عضل';

  @override
  String get goalMuscleGainDesc => 'تركيز على القوة والكتلة';

  @override
  String get goalGeneralVitality => 'حيوية عامة';

  @override
  String get goalGeneralVitalityDesc => 'طاقة، التزام، وتحسّن يومي';

  @override
  String get goalAllOfAbove => 'كل ما سبق';

  @override
  String get goalAllOfAboveDesc => 'خطة متوازنة لكل الأهداف';

  @override
  String get legalDisclaimerText =>
      'تطبيق Vireo هو أداة تنظيمية للياقة البدنية وليس بديلاً عن الاستشارة الطبية المباشرة. المحتوى المقدم (تمارين، خطط غذائية، ومعلومات صحية) يهدف للتوجيه العام فقط.\n\nإذا كنت تعاني من أي حالة صحية مزمنة — مثل أمراض القلب، السكري، ضغط الدم المرتفع، إصابات المفاصل الحالية — أو تتناول أدوية حالياً، يجب استشارة طبيبك المعالج قبل البدء بأي برنامج تمارين أو تغذية.\n\nالمكملات الغذائية والنصائح المتعلقة بالهرمونات (مثل التستيستيرون) هي معلومات تعليمية عامة فقط. لا يُعتبر وصفة طبية ولا توصية علاجية.\n\nبالمشاركة في أي برنامج داخل التطبيق، أقر بأنني قرأت الشروط وأفهم أن Vireo لا يتحمل مسؤولية أي إصابة أو مضاعفات صحية ناتجة عن استخدام التطبيق دون استشارة طبية.';

  @override
  String get legalDisclaimerSection1 =>
      'تطبيق Vireo هو أداة تنظيمية للياقة البدنية وليس بديلاً عن الاستشارة الطبية المباشرة. المحتوى المقدم (تمارين، خطط غذائية، ومعلومات صحية) يهدف للتوجيه العام فقط.';

  @override
  String get legalDisclaimerSection2 =>
      'إذا كنت تعاني من أي حالة صحية مزمنة — مثل أمراض القلب، السكري، ضغط الدم المرتفع، إصابات المفاصل الحالية — أو تتناول أدوية حالياً، يجب استشارة طبيبك المعالج قبل البدء بأي برنامج تمارين أو تغذية.';

  @override
  String get legalDisclaimerSection3 =>
      'المكملات الغذائية هي معلومات تعليمية عامة فقط. لا تُعتبر وصفة طبية ولا توصية علاجية.';

  @override
  String get legalDisclaimerSection4 =>
      'النصائح المتعلقة بالهرمونات (مثل التستيستيرون) هي معلومات تعليمية عامة فقط. لا تُعتبر وصفة طبية ولا توصية علاجية.';

  @override
  String get legalDisclaimerSection5 =>
      'بالمشاركة في أي برنامج داخل التطبيق، أقر بأنني قرأت الشروط وأفهم أن Vireo لا يتحمل مسؤولية أي إصابة أو مضاعفات صحية ناتجة عن استخدام التطبيق دون استشارة طبية.';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get consentCheckboxLabel =>
      'قرأت ووافقت على الشروط وإخلاء المسؤولية الصحي';

  @override
  String get notificationWorkoutTime => 'وقت التمرين المفضل';

  @override
  String get notificationWalkingReminder => 'تذكير المشي اليومي';

  @override
  String get notificationWeeklyCheckIn => 'تذكير التقييم الأسبوعي';

  @override
  String get notificationNotSet => 'غير محدد';

  @override
  String get authWelcomeTitle => 'مرحباً في Vireo';

  @override
  String get authWelcomeSubtitle =>
      'سجّل دخولك لمزامنة تقدّمك على كل الأجهزة، أو كمّل محلياً كضيف.';

  @override
  String get signInWithApple => 'تسجيل الدخول بـ Apple';

  @override
  String get signInWithGoogle => 'تسجيل الدخول بـ Google';

  @override
  String get signInWithEmail => 'تسجيل الدخول بالبريد';

  @override
  String get continueAsGuest => 'المتابعة كضيف';

  @override
  String get authEmail => 'البريد الإلكتروني';

  @override
  String get authPassword => 'كلمة المرور';

  @override
  String get authSignIn => 'تسجيل الدخول';

  @override
  String get authSignUp => 'إنشاء حساب';

  @override
  String get authHasAccount => 'عندك حساب؟';

  @override
  String get authNoAccount => 'ما عندكش حساب؟';

  @override
  String get authSignedIn => 'مسجّل الدخول';

  @override
  String get authErrorGeneric => 'حصل خطأ. حاول تاني.';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get guestModeTitle => 'وضع الضيف';

  @override
  String get guestModeSubtitle =>
      'تقدّمك محفوظ على الجهاز ده بس. أنشئ حساب للمزامنة والاشتراك.';

  @override
  String get profileStatWorkoutsLabel => 'تمارين مكتملة';

  @override
  String get profileStatStreakLabel => 'سلسلة أيام';

  @override
  String get saveProgressToCloud => 'حفظ التقدّم على السحابة';

  @override
  String get profileCloudSynced => 'التقدّم متزامن مع حسابك';

  @override
  String get authGateTitle => 'إنشاء حساب';

  @override
  String get authGateSaveProgress =>
      'أنشئ حساب مجاني لحفظ تقدّمك على السحابة والوصول له من أي جهاز.';

  @override
  String get authGateSubscribe =>
      'أنشئ حساب قبل الاشتراك عشان يتربط اشتراكك بحسابك.';

  @override
  String get authGateSignUp => 'إنشاء حساب';

  @override
  String get authGateNotNow => 'ليس الآن';

  @override
  String get deleteAccountTitle => 'حذف الحساب';

  @override
  String get deleteAccountWarningTitle => 'لا يمكن التراجع';

  @override
  String get deleteAccountWarningBody =>
      'كل بيانات ملفك، سجلات التمارين، خطط الوجبات، وصور التقدّم هتتحذف نهائياً من خوادمنا.';

  @override
  String get deleteAccountCancel => 'إلغاء';

  @override
  String get deleteAccountContinue => 'متابعة';

  @override
  String get deleteAccountConfirmTitle => 'تأكيد الحذف';

  @override
  String get deleteAccountConfirmInstructions =>
      'اكتب الكلمة التالية بالضبط لتأكيد حذف الحساب نهائياً:';

  @override
  String get deleteConfirmationWord => 'حذف';

  @override
  String get deleteAccountTypeHint => 'اكتب حذف';

  @override
  String get deleteAccountConfirmButton => 'حذف حسابي نهائياً';

  @override
  String get deleteAccountSuccess => 'تم حذف حسابك.';

  @override
  String get workoutMedicalWarning =>
      'أشرت لحالة صحية في التسجيل. توقف لو حصل ألم أو دوخة أو ضيق نفس. استشر طبيبك قبل التمارين الشاقة.';

  @override
  String get workoutWarmUpTitle => 'الإحماء';

  @override
  String get workoutWarmUpSubtitle =>
      'كمّل تمارين الحركة دي قبل التمرين الأساسي.';

  @override
  String get workoutCoolDownTitle => 'التهدئة';

  @override
  String get workoutCoolDownSubtitle => 'حركة خفيفة لمساعدة جسمك على التعافي.';

  @override
  String get workoutActiveTitle => 'التمرين النشط';

  @override
  String get workoutBeginWorkout => 'ابدأ التمرين';

  @override
  String get workoutFinishCoolDown => 'إنهاء التهدئة';

  @override
  String get workoutStartButton => 'ابدأ تمرين النهاردة';

  @override
  String get workoutTodayTitle => 'برنامج النهاردة';

  @override
  String workoutTodaySubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تمارين',
      one: 'تمرين واحد',
    );
    return '$_temp0';
  }

  @override
  String workoutPhaseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تمارين',
      one: 'تمرين واحد',
    );
    return '$_temp0';
  }

  @override
  String get workoutExerciseProgress => 'تمرين';

  @override
  String get workoutStatSets => 'مجموعات';

  @override
  String get workoutStatReps => 'تكرارات';

  @override
  String get workoutStatRest => 'راحة';

  @override
  String get workoutSetsLabel => 'المجموعات';

  @override
  String workoutSetNumber(int number) {
    return 'مجموعة $number';
  }

  @override
  String get workoutPrevious => 'السابق';

  @override
  String get workoutNext => 'التالي';

  @override
  String get workoutSwapExercise => 'استبدال التمرين';

  @override
  String get workoutSwapTitle => 'استبدال التمرين';

  @override
  String get workoutSwapSubtitle => 'بدائل لنفس العضلة وبيئة تمرينك.';

  @override
  String get workoutSwapEmpty => 'مفيش بدائل متاحة دلوقتي.';

  @override
  String get workoutRestTitle => 'راحة';

  @override
  String get workoutRestSkip => 'تخطي';

  @override
  String get workoutRestAdd15 => '+15 ث';

  @override
  String get workoutPausedTitle => 'التمرين متوقف';

  @override
  String get workoutResume => 'متابعة';

  @override
  String get workoutEndWorkout => 'إنهاء التمرين';

  @override
  String get workoutRestart => 'إعادة التمرين';

  @override
  String get workoutEndConfirmTitle => 'إنهاء التمرين؟';

  @override
  String get workoutEndConfirmBody => 'تقدّمك في الجلسة دي مش هيتسجّل.';

  @override
  String get workoutFeedbackTitle => 'التمرين كان إزاي؟';

  @override
  String get workoutFeedbackEasy => 'سهل';

  @override
  String get workoutFeedbackJustRight => 'مناسب';

  @override
  String get workoutFeedbackHard => 'صعب';

  @override
  String get workoutVideoUnavailable => 'الفيديو غير متاح';

  @override
  String get workoutEmptyProgram => 'مفيش تمارين مجدولة للنهاردة.';

  @override
  String get walkingTitle => 'المشي';

  @override
  String get walkingStepsToday => 'خطوة النهاردة';

  @override
  String walkingDailyGoal(int steps) {
    return 'الهدف: $steps خطوة';
  }

  @override
  String walkingGoalProgress(int percent) {
    return '$percent% من هدف النهاردة';
  }

  @override
  String get walkingWeeklyChartTitle => 'آخر 7 أيام';

  @override
  String get walkingHealthSourceNote =>
      'عدد الخطوات بيتقرأ من Apple Health أو Health Connect — Vireo مبيستخدمش pedometer داخلي.';

  @override
  String get walkingPermissionTitle => 'محتاجين إذن الخطوات';

  @override
  String get walkingPermissionBody =>
      'Vireo بيقرأ خطواتك من Apple Health (iOS) أو Health Connect (Android) للدقة. اسمح بالوصول من الإعدادات ورجع تاني.';

  @override
  String get walkingOpenSettings => 'فتح الإعدادات';

  @override
  String get walkingTryAgain => 'حاول تاني';

  @override
  String get walkingUnavailableTitle => 'تتبع المشي غير متاح';

  @override
  String get walkingUnavailableBody =>
      'تتبع الخطوات محتاج جهاز iOS أو Android مع Apple Health أو Health Connect.';

  @override
  String get nutritionTabBreakfast => 'فطار';

  @override
  String get nutritionTabLunch => 'غداء';

  @override
  String get nutritionTabDinner => 'عشاء';

  @override
  String get nutritionTabSnack => 'سناك';

  @override
  String get nutritionNoMealPlanned => 'مفيش وجبة مجدولة للنهاردة.';

  @override
  String nutritionPrepMinutes(int minutes) {
    return '$minutes د';
  }

  @override
  String get nutritionTagHighProtein => 'بروتين عالي';

  @override
  String get nutritionTagQuickEasy => 'سريع وسهل';

  @override
  String get nutritionTagLightEnergy => 'طاقة خفيفة';

  @override
  String get nutritionScanFridge => 'امسح التلاجة';

  @override
  String nutritionScansRemaining(int count) {
    return 'فاضل $count مسح للتلاجة الشهر ده';
  }

  @override
  String get nutritionScanPrompt =>
      'صوّر التلاجة أو المخزن عشان نكتشف المكونات.';

  @override
  String get nutritionTakePhoto => 'التقاط صورة';

  @override
  String get nutritionChoosePhoto => 'اختيار من المعرض';

  @override
  String get nutritionScanning => 'جاري مسح المكونات…';

  @override
  String get nutritionScanFailed =>
      'فشل المسح. حاول تاني أو أدخل المكونات يدوي.';

  @override
  String get nutritionScanLimitReached =>
      'وصلت للimit الشهري. ترقّى للمسح غير المlimited.';

  @override
  String get nutritionConfirmIngredients => 'تأكيد المكونات';

  @override
  String get nutritionIngredientsHint => 'احذف اللي غلط وأضف اللي ناقص.';

  @override
  String get nutritionAddIngredient => 'إضافة مكون';

  @override
  String get nutritionGetRecipes => 'اقتراحات وصفات';

  @override
  String get nutritionNoIngredients => 'أضف مكون واحد على الأقل.';

  @override
  String get nutritionRecipeSuggestions => 'أفكار وصفات';

  @override
  String get nutritionRecipeSuggestionsSubtitle =>
      'حسب مكوناتك وهدفك وقيودك الغذائية.';

  @override
  String get nutritionNoRecipesFound => 'مفيش وصفات مطابقة.';

  @override
  String get nutritionManualEntry => 'إدخال يدوي';

  @override
  String get nutritionManualEntryHint =>
      'اكتب اللي عندك — هنقترح وصفات تناسب هدفك وقيودك الغذائية.';

  @override
  String get nutritionSwapMeal => 'بدّل الوجبة';

  @override
  String get nutritionSwapMealSubtitle =>
      'اختار وصفة مختلفة — بدون تكرار خلال 14 يوم.';

  @override
  String get nutritionSwapMealEmpty => 'مفيش وجبات بديلة متاحة دلوقتي.';

  @override
  String get nutritionDemoQuickMeals => 'وجبات صحية تجريبية سريعة';

  @override
  String get nutritionTryDemoScan => 'جرب مسح تجريبي';

  @override
  String get homeWelcomeSubtitle => 'مركز لياقتك الشخصي.';

  @override
  String get homeWalkingCardSubtitle =>
      'تتبع خطواتك اليومية من Apple Health أو Health Connect.';

  @override
  String get homeDailyProgramTitle => 'البرنامج اليومي';

  @override
  String get homeTodayWorkout => 'تمرين النهارده';

  @override
  String get homeNextMeal => 'الوجبة الجاية';

  @override
  String homeWorkoutExerciseCount(int count) {
    return '$count تمارين';
  }

  @override
  String get progressTabWeight => 'الوزن';

  @override
  String get progressTabAdherence => 'الالتزام';

  @override
  String get progressTabEnergy => 'الطاقة';

  @override
  String get progressWeightChartTitle => 'اتجاه الوزن';

  @override
  String progressWeightGoalLine(String value, String unit) {
    return 'الهدف: $value $unit';
  }

  @override
  String get progressAdherenceChartTitle => 'الالتزام الأسبوعي';

  @override
  String get progressAdherenceSubtitle => 'نسبة إكمال التمارين كل أسبوع';

  @override
  String get progressEnergyChartTitle => 'مستويات الطاقة';

  @override
  String get progressEnergySubtitle =>
      'درجة الطاقة من المتابعة الأسبوعية (1–10)';

  @override
  String get progressLogWeight => 'تسجيل الوزن';

  @override
  String progressWeightLabel(String unit) {
    return 'الوزن ($unit)';
  }

  @override
  String get progressLogDate => 'التاريخ';

  @override
  String get progressSaveWeight => 'حفظ';

  @override
  String get reassessmentTitle => 'متابعة شهرية';

  @override
  String get reassessmentSubtitle =>
      'حدّث وزنك ونشاطك وبيئة التمرين عشان البرنامج يفضل دقيق.';

  @override
  String get reassessmentLater => 'لاحقاً';

  @override
  String get reassessmentSubmit => 'تحديث خطتي';

  @override
  String get reassessmentSummaryTitle => 'إيه اللي اتغير';

  @override
  String get reassessmentSummarySubtitle => 'مقارنة بآخر متابعة';

  @override
  String reassessmentPhaseUpdated(int phase) {
    return 'تم تحديث مرحلة البرنامج للمرحلة $phase';
  }

  @override
  String get reassessmentNoPhaseChange => 'مفيش تغيير في البرنامج — كمّل!';

  @override
  String get paywallTitle => 'Vireo Premium';

  @override
  String get paywallHeadline => 'افتح إمكانياتك الكاملة';

  @override
  String get paywallSubtitle =>
      'Premium يمنحك مسح غير محدود، مراحل برنامج كاملة، ورؤى تقدم أعمق.';

  @override
  String get paywallBestValue => 'أفضل قيمة';

  @override
  String get paywallPlanMonthly => 'شهري';

  @override
  String get paywallPlanAnnual => 'سنوي';

  @override
  String get paywallPlanLifetime => 'مدى الحياة';

  @override
  String get paywallFeatureUnlimitedScans => 'مسح تلاجة غير محدود';

  @override
  String get paywallFeatureFullProgram => 'مراحل برنامج كاملة وتمارين متقدمة';

  @override
  String get paywallFeatureCloudSync => 'مزامنة سحابية بين الأجهزة';

  @override
  String get paywallFeatureProgressAnalytics => 'تحليلات تقدم متقدمة';

  @override
  String get paywallSubscribe => 'اشترك';

  @override
  String get paywallRestorePurchases => 'استعادة المشتريات';

  @override
  String get paywallPurchaseSuccess => 'مرحباً بك في Premium!';

  @override
  String get paywallPurchaseError => 'فشل الشراء. حاول مرة أخرى.';

  @override
  String get paywallRestoreSuccess => 'تمت استعادة المشتريات بنجاح.';

  @override
  String get paywallRestoreEmpty => 'لم يُعثر على اشتراك نشط لهذا الحساب.';

  @override
  String get paywallRestoreError => 'تعذّرت استعادة المشتريات. حاول لاحقاً.';

  @override
  String get paywallNotConfigured => 'الاشتراكات غير متاحة في هذا الإصدار.';

  @override
  String get paywallSubscriptionExpiredMessage =>
      'انتهى اشتراكك. أعد الاشتراك لفتح الميزات المميزة.';

  @override
  String get trialEndedTitle => 'انتهت تجربتك المجانية';

  @override
  String get trialEndedBody =>
      'شكراً لتجربة Vireo Premium. اشترك للاحتفاظ بالمسح غير المحدود ومراحل البرنامج الكاملة والمزامنة السحابية.';

  @override
  String get trialEndedViewPlans => 'عرض الخطط';

  @override
  String subscriptionTrialDaysRemaining(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days أيام متبقية في تجربتك المجانية',
      one: 'يوم واحد متبقٍ في تجربتك المجانية',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionExpiredBanner => 'انتهى الاشتراك — اضغط للتجديد';

  @override
  String get subscriptionPremiumActive => 'Premium نشط';

  @override
  String get subscriptionFreeTier => 'الخطة المجانية';

  @override
  String get subscriptionUpgrade => 'ترقية';

  @override
  String get settingsManageSubscription =>
      'عرض الخطط والاشتراك أو استعادة المشتريات';

  @override
  String workoutPhaseLockedTitle(int phase) {
    return 'المرحلة $phase مقفلة';
  }

  @override
  String get workoutPhaseLockedBody =>
      'أعد الاشتراك لمتابعة برنامجك الكامل. التتبع الأساسي يبقى متاحاً في الخطة المجانية.';

  @override
  String homeGreeting(String name) {
    return 'أهلاً $name 👋';
  }

  @override
  String homeDayPhase(int day, String phase) {
    return 'اليوم $day · مرحلة $phase';
  }

  @override
  String get homeGuestBanner => 'أنت في وضع الضيف — سجّل الآن عشان تحفظ تقدمك';

  @override
  String get homeGuestSignUp => 'سجّل';

  @override
  String get homeGuestCta => 'سجّل الآن — مجاناً لـ 7 أيام';

  @override
  String homeStreakDays(int days) {
    return '$days أيام متتالية';
  }

  @override
  String get homeStartStreak => 'ابدأ سلسلتك اليوم';

  @override
  String get homeTodayWorkoutTitle => 'تمرين اليوم';

  @override
  String get homeStartWorkout => 'ابدأ التمرين';

  @override
  String get homeRestDay => 'يوم راحة نشطة 🧘';

  @override
  String get homeBreakfast => 'الفطار';

  @override
  String get homeMealConfirmed => 'مؤكد ✓';

  @override
  String get homeMealPending => 'لسه';

  @override
  String homeWalkingSteps(int current, int goal) {
    return '$current / $goal خطوة';
  }

  @override
  String homeWeeklyProgress(int completed) {
    return '$completed / ٧ أيام مكتملة';
  }

  @override
  String get homeCheckInBanner => '⏱️ Check-in الأسبوعي جاهز — دقيقة واحدة بس';

  @override
  String get homeRecoveryScore => 'نسبة التعافي';

  @override
  String get homeRecoveryReady => 'جسمك جاهز للتمرين';

  @override
  String get homeGuestName => 'بطل';

  @override
  String get homePhaseFoundation => 'التأسيس';

  @override
  String get nutritionFilterAll => 'الكل';

  @override
  String get nutritionFilterQuick => 'سريع';

  @override
  String get nutritionFilterLowCalorie => 'سعرات منخفضة';

  @override
  String nutritionMacroSummary(int calories, int protein) {
    return '$calories سعرة · ${protein}g بروتين';
  }

  @override
  String get nutritionMacroBar => 'سعرات | بروتين | كارب | دهون';

  @override
  String get nutritionMealConfirmed => 'مؤكد ✓';

  @override
  String nutritionFridgeBanner(int remaining) {
    return '📷 صوّر تلاجتك — باقي $remaining مسحات هذا الشهر';
  }

  @override
  String get nutritionFridgeScanCta => 'صوّر';

  @override
  String get workoutWarmUpStep1 => 'دوران الكتفين — 30 ثانية';

  @override
  String get workoutWarmUpStep2 => 'مشي في المكان — 60 ثانية';

  @override
  String get workoutWarmUpStep3 => 'سكوات خفيف — 10 تكرار';

  @override
  String get workoutSkipWarmUp => 'تخطي الإحماء';

  @override
  String get workoutStartMainWorkout => 'ابدأ التمرين الرئيسي';

  @override
  String get workoutWarmUpComplete => 'تم الإحماء — جاهز!';

  @override
  String homeProgramDay(int day, int total) {
    return 'اليوم $day من $total';
  }

  @override
  String get homeStartProgram => 'ابدأ برنامجك';

  @override
  String get nutritionDailyCalorieGoal => 'هدفك اليومي من السعرات';

  @override
  String nutritionCalorieTargetSummary(
    int calories,
    int protein,
    int carbs,
    int fat,
  ) {
    return 'هدفك: $calories سعرة — ${protein}g بروتين، ${carbs}g كارب، ${fat}g دهون';
  }

  @override
  String nutritionCalorieProgress(int consumed, int target) {
    return '$consumed / $target سعرة اليوم';
  }

  @override
  String get nutritionEditCalorieGoal => 'تعديل هدف السعرات';

  @override
  String get nutritionCalorieHint => 'السعرات اليومية';

  @override
  String get settingsThemeTitle => 'المظهر';

  @override
  String get settingsThemeDark => 'الوضع الداكن';

  @override
  String get settingsThemeLight => 'الوضع الفاتح';

  @override
  String get settingsThemeSystem => 'حسب النظام';

  @override
  String get progressAxisDate => 'التاريخ';

  @override
  String get progressAxisWeight => 'الوزن (كجم)';

  @override
  String get progressAxisEnergy => 'الطاقة (1–10)';

  @override
  String get progressAllChartsTitle => 'نظرة عامة على تقدمك';

  @override
  String get profileGuestAvatar => 'ضيف';

  @override
  String get profileStatProgramDays => 'أيام في البرنامج';

  @override
  String get profileStatsSection => 'إحصائياتك';

  @override
  String get profileGoalWeight => 'وزن الهدف';

  @override
  String get profileCurrentBmi => 'BMI الحالي';

  @override
  String get profileActivityLevel => 'مستوى النشاط';

  @override
  String get profileEditProfile => 'تعديل الملف';

  @override
  String get profileBmiUnderweight => 'نقص وزن';

  @override
  String get profileBmiHealthy => 'وزن صحي';

  @override
  String get profileBmiOverweight => 'وزن زائد';

  @override
  String get profileBmiObese => 'سمنة';

  @override
  String get profileBmiTooltip =>
      'مؤشر كتلة الجسم (BMI) يقدّر نسبة الدهون من الطول والوزن — دليل عام وليس تشخيصاً طبياً.';

  @override
  String get workoutSplitChestTriceps => 'صدر وترايسبس';

  @override
  String get workoutSplitBackBiceps => 'ظهر وبايسبس';

  @override
  String get workoutSplitLegs => 'أرجل';

  @override
  String get workoutSplitCardio => 'كارديو';

  @override
  String get workoutSplitShoulders => 'أكتاف';

  @override
  String get workoutSplitFullBody => 'جسم كامل';

  @override
  String get workoutSplitRest => 'يوم راحة';

  @override
  String get habitsTitle => 'العادات اليومية';

  @override
  String get habitsEmpty => 'لا توجد عادات بعد — اضغط + لإضافة أول عادة';

  @override
  String get habitsAddTitle => 'عادة جديدة';

  @override
  String get habitsAddHint => 'اسم العادة';

  @override
  String get habitsAddConfirm => 'إضافة';

  @override
  String habitsStreak(int days) {
    return 'سلسلة $days أيام';
  }

  @override
  String get habitsRetry => 'إعادة المحاولة';

  @override
  String get habitsErrorTitle => 'تعذّر تحميل العادات';

  @override
  String homeRecoveryExplain(int score) {
    return 'نسبة التعافي $score% تجمع بين جودة النوم وأيام الراحة وإرهاق العضلات. الرقم الأعلى يعني جسمك جاهز للتدريب بقوة.';
  }

  @override
  String get homeRecoveryFactorSleep => 'جودة النوم';

  @override
  String get homeRecoveryFactorRest => 'أيام الراحة';

  @override
  String get homeRecoveryFactorMuscle => 'إرهاق العضلات';

  @override
  String get homeRecoveryTipSleep => 'استهدف 7–9 ساعات نوم الليلة';

  @override
  String get homeRecoveryTipRest => 'حافظ على يوم راحة كامل أسبوعياً';

  @override
  String get homeRecoveryTipMuscle => 'خفّف الشدة لو الألم العضلي عالي';

  @override
  String get homeRecoveryImproveTitle => 'نصائح للتحسين';

  @override
  String get homeRecoveryImproveBody =>
      'ركّز على النوم والترطيب، واستبدل جلسة قوية بتمارين مرونة عند ارتفاع الإرهاق.';

  @override
  String get walkingMetricsTitle => 'مقاييس المشي اليوم';

  @override
  String get walkingDistance => 'المسافة';

  @override
  String get walkingSpeed => 'السرعة';

  @override
  String get walkingPace => 'الإيقاع';

  @override
  String get walkingCalories => 'السعرات المحروقة';

  @override
  String walkingWeightLoss(String kg) {
    return 'حرق دهون تقديري ≈ $kg كجم';
  }

  @override
  String walkingCadence(int spm) {
    return 'إيقاع الخطوات ≈ $spm خطوة/دقيقة';
  }

  @override
  String get walkingMetricsEstimatedNote =>
      'بيانات الصحة غير متاحة — عرض تقديرات من عدد الخطوات.';

  @override
  String get mealBuilderTitle => 'تخصيص المكونات';

  @override
  String mealBuilderTitleFor(String meal) {
    return 'تخصيص $meal';
  }

  @override
  String get mealBuilderSubtitle =>
      'عدّل البروتين ودهن الطبخ والإضافات — الماكروز تتحدث فوراً.';

  @override
  String get mealBuilderEggs => 'البيض';

  @override
  String mealBuilderEggCount(int count) {
    return '$count بيضات';
  }

  @override
  String mealBuilderPortionCount(int count) {
    return '$count حصص';
  }

  @override
  String get mealBuilderProteinLunch => 'حصص البروتين';

  @override
  String get mealBuilderProteinDinner => 'بروتين العشاء';

  @override
  String get mealBuilderProteinSnack => 'بروتين السناك';

  @override
  String get mealBuilderFatSource => 'مصدر الدهون';

  @override
  String get mealBuilderFatButter => 'زبدة';

  @override
  String get mealBuilderFatGhee => 'سمنة';

  @override
  String get mealBuilderFatOliveOil => 'زيت زيتون';

  @override
  String get mealBuilderFatSpray => 'زيت بخاخ';

  @override
  String get mealBuilderAddOns => 'إضافات';

  @override
  String get mealBuilderAddonCheese => 'جبن';

  @override
  String get mealBuilderAddonVeggies => 'خضروات';

  @override
  String get mealBuilderAddonBread => 'خبز حبوب كاملة';

  @override
  String get mealBuilderAddonRice => 'أرز';

  @override
  String get mealBuilderAddonYogurt => 'زبادي';

  @override
  String get mealBuilderLiveMacros => 'الماكروز الحية';

  @override
  String get weeklyCheckInTitle => 'التقييم الأسبوعي';

  @override
  String get weeklyCheckInBanner =>
      'حان وقت التقييم الأسبوعي — حدّث الوزن والطاقة';

  @override
  String get weeklyCheckInSubtitle =>
      'هنحسب BMR/TDEE من جديد ونحدّث السعرات والماكروز للأسبوع الجاي.';

  @override
  String get weeklyCheckInWeight => 'الوزن الحالي';

  @override
  String get weeklyCheckInWaist => 'محيط الخصر';

  @override
  String get weeklyCheckInEnergy => 'مستوى الطاقة (1–5)';

  @override
  String weeklyCheckInAdherence(int pct) {
    return 'الالتزام بالتدريب: $pct%';
  }

  @override
  String get weeklyCheckInSubmit => 'حدّث أهدافي';

  @override
  String get weeklyCheckInDoneTitle => 'تم تحديث الأهداف';

  @override
  String weeklyCheckInDoneBody(
    int prev,
    int next,
    int protein,
    int carbs,
    int fat,
  ) {
    return 'السعرات $prev ← $next سعرة. الماكروز: ${protein}g بروتين، ${carbs}g كارب، ${fat}g دهون.';
  }

  @override
  String get settingsAccentTitle => 'لون التمييز';

  @override
  String get settingsAccentOrange => 'برتقالي';

  @override
  String get settingsAccentEmerald => 'أخضر';

  @override
  String get settingsAccentBlue => 'أزرق';

  @override
  String get settingsAccentViolet => 'بنفسجي';

  @override
  String get settingsSkinTitle => 'سمات الألوان';

  @override
  String get settingsSkinStandard => 'قياسي';

  @override
  String get settingsSkinStandardDesc => 'الوضع الداكن / الفاتح الكلاسيكي';

  @override
  String get settingsSkinAmoled => 'أسود داكن (AMOLED)';

  @override
  String get settingsSkinAmoledDesc => 'أسود نقي مع ذهبي وسماوي';

  @override
  String get settingsSkinNavy => 'كحلي عميق';

  @override
  String get settingsSkinNavyDesc => 'كحلي #0B192C مع أزرق ثلجي وتيل';

  @override
  String get settingsAccentLockedHint =>
      'ألوان التمييز مقفلة أثناء سمة AMOLED أو الكحلي.';

  @override
  String get workoutSwapWarmUp => 'تبديل تمرين الإحماء';

  @override
  String get workoutSwapWarmUpTitle => 'اختر بديلاً للإحماء';

  @override
  String get workoutSwapWarmUpSubtitle =>
      'خيارات مرونة وتأثير منخفض تناسب بيئة تمرينك.';

  @override
  String get profileBmiExplainShort =>
      'مؤشر كتلة الجسم يقيم الوزن بالنسبة للطول.';

  @override
  String get profileBmiExplainFull =>
      'مؤشر كتلة الجسم (BMI) هو مقياس لتقييم الوزن بالنسبة للطول. أداة فحص عامة — وليس تشخيصاً طبياً.';

  @override
  String get mealBuilderCheeseTitle => 'الجبن';

  @override
  String get mealBuilderCheeseNone => 'بدون جبن';

  @override
  String get mealBuilderCheeseCottage => 'جبن قريش';

  @override
  String get mealBuilderCheeseCheddar => 'شيدر';

  @override
  String get mealBuilderCheeseMozzarella => 'موزاريلا';

  @override
  String get mealBuilderCheeseFeta => 'فيتا';

  @override
  String mealBuilderCheeseGrams(int grams) {
    return 'الكمية: ${grams}g';
  }

  @override
  String get homeRecoveryFormulaExplain =>
      'التعافي = أيام الراحة (40%) + هدف الخطوات (30%) + التزام الوجبات/التمارين (30%).';

  @override
  String get homeRecoveryFactorRestDays => 'أيام الراحة';

  @override
  String get homeRecoveryFactorSteps => 'هدف الخطوات';

  @override
  String get homeRecoveryFactorConsistency => 'التزام الوجبات والتمارين';

  @override
  String homeRecoveryRestDetail(int days) {
    return '$days يوم راحة هذا الأسبوع';
  }

  @override
  String homeRecoveryStepsDetail(int current, int goal) {
    return '$current / $goal خطوة اليوم';
  }

  @override
  String homeRecoveryConsistencyDetail(
    int mealsDone,
    int mealsTotal,
    int wDone,
    int wTotal,
  ) {
    return 'وجبات $mealsDone/$mealsTotal · تمارين $wDone/$wTotal';
  }

  @override
  String get homeRecoveryTipSteps => 'حقّق هدف خطواتك اليومي لرفع هذا المحور';

  @override
  String get homeRecoveryTipConsistency =>
      'أكّد الوجبات وأكمِل التمارين المخططة';

  @override
  String homeRecoveryMathLine(int rest, int steps, int consistency, int total) {
    return '$rest + $steps + $consistency = $total%';
  }

  @override
  String get cardioTitle => 'كارديو والنشاط اليومي';

  @override
  String get cardioSubtitle =>
      'سجّل مشي سريع أو جري وغيرها — السعرات = MET × الوزن × الوقت.';

  @override
  String get cardioSelectActivity => 'النشاط';

  @override
  String cardioDuration(int minutes) {
    return 'المدة: $minutes دقيقة';
  }

  @override
  String cardioEstimatedBurn(int kcal) {
    return 'حرق تقديري: $kcal سعرة';
  }

  @override
  String cardioMetHint(String met) {
    return 'MET $met · المعادلة: MET × كجم × ساعات';
  }

  @override
  String get cardioLogButton => 'تسجيل النشاط';

  @override
  String get cardioLoggedSnack => 'تم تسجيل جلسة الكارديو';

  @override
  String cardioTodayTotal(int kcal) {
    return 'محروق اليوم: $kcal سعرة';
  }

  @override
  String get cardioEmpty => 'لا يوجد كارديو بعد — سجّل أول جلسة أعلاه.';

  @override
  String cardioLogSubtitle(int minutes, int kcal) {
    return '$minutes دقيقة · $kcal سعرة';
  }

  @override
  String get cardioLogCta => 'تسجيل كارديو';

  @override
  String get cardioBriskWalking => 'مشي سريع';

  @override
  String get cardioRunning => 'جري';

  @override
  String get cardioCycling => 'دراجة';

  @override
  String get cardioSwimming => 'سباحة';

  @override
  String get cardioJumpRope => 'نط الحبل';

  @override
  String get cardioHiit => 'HIIT';

  @override
  String get cardioElliptical => 'إلپتيكال';

  @override
  String workoutGoalPlanLabel(String goal) {
    return 'الخطة لـ: $goal';
  }

  @override
  String get aiScanTitle => 'مسح الوجبة بالذكاء الاصطناعي';

  @override
  String get aiScanPrompt =>
      'صوّر وجبتك — الذكاء الاصطناعي يقدّر السعرات والماكروز من حجم الحصة.';

  @override
  String get aiScanCamera => 'الكاميرا';

  @override
  String get aiScanGallery => 'المعرض';

  @override
  String get aiScanAnalyzing => 'جاري تحليل الوجبة…';

  @override
  String get aiScanOffline =>
      'لا يوجد اتصال بالإنترنت. تحقق من الشبكة وحاول مجدداً.';

  @override
  String get aiScanFailed => 'فشل المسح. حاول مرة أخرى.';

  @override
  String get aiScanParseError =>
      'تعذّر قراءة التحليل. جرّب صورة أخرى أو أدخل يدوياً.';

  @override
  String get aiScanConfigError =>
      'الماسح غير مهيّأ. أضف GEMINI_API_KEY للتفعيل.';

  @override
  String get aiScanTryAgain => 'إعادة المحاولة';

  @override
  String get aiScanManualEntry => 'إدخال يدوي';

  @override
  String get aiScanCardTitle => 'امسح وجبتك بالذكاء الاصطناعي';

  @override
  String get aiScanCardSubtitle =>
      'صوّر الوجبة — احصل على السعرات والماكروز وبدائل ذكية فوراً.';

  @override
  String get aiScanSaveToLog => 'حفظ في السجل';

  @override
  String get aiScanSavedSnack => 'تم حفظ الوجبة في سجل اليوم';

  @override
  String get aiScanMacroProtein => 'بروتين';

  @override
  String get aiScanMacroCarbs => 'كربوهيدرات';

  @override
  String get aiScanMacroFats => 'دهون';

  @override
  String get aiScanSmartSwaps => 'بدائل ذكية';

  @override
  String aiScanCaloriesChip(int calories) {
    return '$calories سعرة';
  }

  @override
  String get aiCoachTitle => 'Vireo AI';

  @override
  String get aiCoachFabLabel => 'Vireo AI';

  @override
  String get aiCoachInputHint => 'اسأل عن الوجبات أو الماكروز أو التمرين…';

  @override
  String get aiCoachOfflineBanner => 'أنت غير متصل — يتم عرض الرسائل المحفوظة.';

  @override
  String get aiCoachChipDinner => 'اقترح وجبة عشاء';

  @override
  String get aiCoachChipProtein => 'كيف أزيد بروتيني؟';

  @override
  String get aiCoachChipDessert => 'بديل صحي للحلويات';

  @override
  String get waterTrackerTitle => 'شرب الماء';

  @override
  String waterTrackerSummary(double current, double goal, int percent) {
    return '${current}L / ${goal}L — $percent% مكتمل';
  }

  @override
  String get weeklyDeficitChartTitle => 'رصيد السعرات الأسبوعي';

  @override
  String get weeklyDeficitSubtitle =>
      'TDEE − الوجبات + حرق الكارديو (آخر 7 أيام)';

  @override
  String weeklyDeficitTotal(int kcal) {
    return 'إجمالي العجز الأسبوعي: $kcal kcal';
  }

  @override
  String get weeklyDeficitEmpty =>
      'سجّل وجبات أو كارديو لعرض رصيد السعرات الأسبوعي.';

  @override
  String weeklyDeficitTooltip(int net, int consumed, int burned) {
    return '$net kcal\nداخل: $consumed · خارج: $burned';
  }
}
