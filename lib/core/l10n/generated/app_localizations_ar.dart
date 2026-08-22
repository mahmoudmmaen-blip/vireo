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
  String get onboardingStep3Subtitle => 'هنعرض بس تمارين تناسب setup بتاعك.';

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
  String get dietVegan => 'vegan';

  @override
  String get dietGlutenFree => 'خالي من الجلuten';

  @override
  String get dietDairyFree => 'خالي من الألبان';

  @override
  String get dietLowSodium => 'قليل الملح';

  @override
  String get dietLowCarb => 'قليل الكarb';

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
  String get envHomeNoEquipmentDesc => 'تمارين bodyweight بس';

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
  String get legalDisclaimerText => '[legal disclaimer text]';

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
  String get nutritionTagHighProtein => 'بروtein عالي';

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
  String get homeWelcomeSubtitle => 'مركز لياقتك الشخصي.';

  @override
  String get homeWalkingCardSubtitle =>
      'تتبع خطواتك اليومية من Apple Health أو Health Connect.';

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
}
