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
  String get cancelButton => 'إلغاء';

  @override
  String get saveButton => 'حفظ';

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
  String get authSaveProgressTitle => 'احفظ تقدّمك';

  @override
  String get authSaveProgressSubtitle =>
      'اربط حساب عشان خطتك والمسح والمحادثات يتزامنوا بين الأجهزة.';

  @override
  String get signInWithApple => 'تسجيل الدخول بـ Apple';

  @override
  String get signInWithGoogle => 'تسجيل الدخول بـ Google';

  @override
  String get signInWithEmail => 'تسجيل الدخول بالبريد';

  @override
  String get authContinueApple => 'كمّل بـ Apple';

  @override
  String get authContinueGoogle => 'كمّل بـ Google';

  @override
  String get authContinueEmail => 'كمّل بالبريد';

  @override
  String get authSignInWithPassword => 'تسجيل الدخول بكلمة مرور';

  @override
  String get authSendCode => 'ابعت الكود';

  @override
  String get authVerifyCode => 'تأكيد الكود';

  @override
  String get authResendCode => 'إعادة إرسال الكود';

  @override
  String authResendIn(int seconds) {
    return 'إعادة الإرسال بعد $seconds ث';
  }

  @override
  String authOtpSentTo(String email) {
    return 'بعتنا كود من 6 أرقام على $email';
  }

  @override
  String get authBack => 'رجوع';

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
  String get authErrorOffline => 'مفيش نت. تأكد من الاتصال وحاول تاني.';

  @override
  String get authErrorWrongCode => 'الكود غلط. راجع الأرقام وحاول تاني.';

  @override
  String get authErrorTooMany => 'محاولات كتير، حاول تاني بعد دقيقة.';

  @override
  String get authErrorInvalidEmail => 'اكتب إيميل صحيح.';

  @override
  String get authErrorCancelled => 'اتلغى تسجيل الدخول.';

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
  String get authGateAiFeatures =>
      'أنشئ حساب مجاني عشان تستخدم مسح الوجبات بالـ AI وكوتش Vireo. المحادثات والمسح بيتزامنوا بأمان على حسابك.';

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
      'الخطوات بتتعد على الجهاز. لو Health Connect / Apple Health متاحين كمان، Vireo بيعرض العدد الأعلى.';

  @override
  String get walkingPermissionTitle => 'محتاجين إذن الخطوات';

  @override
  String get walkingPermissionBody =>
      'Vireo بيعدّ الخطوات بحساسات الحركة في الموبايل. اسمح بإذن النشاط عشان أهداف المشي والسعرات تبقى دقيقة.';

  @override
  String get walkingOpenSettings => 'فتح الإعدادات';

  @override
  String get walkingTryAgain => 'حاول تاني';

  @override
  String get walkingUnavailableTitle => 'تتبع المشي غير متاح';

  @override
  String get walkingUnavailableBody =>
      'تتبع الخطوات بيشتغل أحسن على موبايل iOS أو Android فيه حساس عدّاد الخطوات.';

  @override
  String get walkingEnableTitle => 'عدّ الخطوات على الموبايل';

  @override
  String get walkingEnableBody =>
      'Vireo بيستخدم حساس الخطوات في موبايلك عشان يتتبع المشي لايف — المسافة والسعرات وهدف اليوم. هنطلب إذن النشاط بعد كده.';

  @override
  String get walkingEnableCta => 'تفعيل عدّ الخطوات';

  @override
  String get walkingActiveMinutes => 'وقت النشاط';

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
      'وصلت للحد الشهري. ترقّى للمسح غير المحدود.';

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
  String get paywallFeatureUnlimitedScans => 'مسح غير محدود للأطباق';

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
      'ماسح الـ AI مش متاح دلوقتي. حاول تاني بعد شوية.';

  @override
  String get aiDailyLimitReached =>
      'وصلت لحد الـ AI النهاردة. رقّي اشتراكك لحد يومي أعلى.';

  @override
  String get aiUpgradeCta => 'ترقية';

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
  String waterAddOneGlass(int ml) {
    return '+1 كوباية ($ml مل)';
  }

  @override
  String get waterLongPressHint => 'اضغط مطوّل لكميات تانية';

  @override
  String get waterQuickAmountsTitle => 'كميات سريعة';

  @override
  String get waterDefaultCupTitle => 'حجم الكوباية الافتراضي';

  @override
  String get waterCustomMl => 'كمية مخصّصة';

  @override
  String get waterAddCustom => 'أضف';

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
    return 'إجمالي العجز الأسبوعي: $kcal سعرة';
  }

  @override
  String get weeklyDeficitEmpty =>
      'سجّل وجبات أو كارديو لعرض رصيد السعرات الأسبوعي.';

  @override
  String get weeklyDeficitInProgress => 'النهاردة (لسه شغّال)';

  @override
  String get progressTrendEmpty => 'سجّل 3 أيام عشان تشوف الاتجاه';

  @override
  String get adaptiveCalorieCardTitle => 'تعديل السعرات المتكيف';

  @override
  String get adaptiveCalorieExplainMath => 'شرح الحسبة';

  @override
  String get adaptiveCalorieAccept => 'قبول التغيير';

  @override
  String get adaptiveCalorieDismiss => 'ليس الآن';

  @override
  String get weeklyReportTitle => 'تقرير التقدم الأسبوعي';

  @override
  String get weeklyReportSubtitle => 'تحليل يوم الجمعة وأبرز محطات الأسبوع';

  @override
  String get weeklyReportShareCta => 'مشاركة التقرير';

  @override
  String get progressPhotosTitle => 'صور التقدم';

  @override
  String get photosPrivacyNote =>
      'صورك محفوظة محلياً على هاتفك فقط، ولا تغادر جهازك أبداً إلا إذا فعّلت النسخ الاحتياطي السحابي.';

  @override
  String get photosCompareSideBySide => 'مقارنة جنباً إلى جنب';

  @override
  String get photosNeedTwoToCompare =>
      'التقط صورتين على الأقل لمقارنة قبل وبعد';

  @override
  String get photoBeforeLabel => 'قبل';

  @override
  String get photoAfterLabel => 'بعد';

  @override
  String get photoMissingFile => 'ملف الصورة غير موجود';

  @override
  String get photoSourceCamera => 'التقاط صورة';

  @override
  String get photoSourceGallery => 'اختيار من المعرض';

  @override
  String get bodyCircumferenceTitle => 'قياسات محيط الجسم';

  @override
  String get achievementsTitle => 'الإنجازات والأوسمة';

  @override
  String get achievementsUnlocked => 'تم فتحها';

  @override
  String get cookMethodRaw => 'نيء';

  @override
  String get cookMethodBoiled => 'مسلوق';

  @override
  String get cookMethodGrilled => 'مشوي';

  @override
  String get cookMethodFried => 'مقلي';

  @override
  String get cookMethodBaked => 'في الفرن';

  @override
  String get cookMethodSteamed => 'على البخار';

  @override
  String get cookMethodOther => 'أخرى';

  @override
  String weeklyDeficitTooltip(int net, int consumed, int burned) {
    return '$net سعرة\nداخل: $consumed · خارج: $burned';
  }

  @override
  String uxGoodMorning(String name) {
    return 'صباح الخير يا $name';
  }

  @override
  String uxGoodAfternoon(String name) {
    return 'نهارك سعيد يا $name';
  }

  @override
  String uxGoodEvening(String name) {
    return 'مساء الخير يا $name';
  }

  @override
  String get uxTodayOverline => 'اليوم';

  @override
  String get uxCaloriesLeft => 'سعرة متبقية';

  @override
  String get uxCaloriesOver => 'سعرة زيادة';

  @override
  String get uxGoal => 'الهدف';

  @override
  String get uxEaten => 'أكلت';

  @override
  String get uxBurned => 'حرقت';

  @override
  String get uxActionScan => 'صوّر وجبة';

  @override
  String get uxActionTrain => 'تمرين';

  @override
  String get uxActionCoach => 'المدرب';

  @override
  String get uxSectionTraining => 'تمرين النهارده';

  @override
  String get uxSectionThisWeek => 'الأسبوع ده';

  @override
  String get uxSectionTodayLog => 'سجل النهارده';

  @override
  String get uxAddMeal => '+ أضف وجبة';

  @override
  String get uxAiScanned => 'تحليل AI';

  @override
  String get uxMealRemoved => 'تم حذف الوجبة';

  @override
  String get uxLogEmptyTitle => 'لسه ما سجلتش أكل النهارده';

  @override
  String get uxLogEmptyBody =>
      'صوّر وجبتك والذكاء الاصطناعي يحسب السعرات والماكروز في ثواني.';

  @override
  String get uxRestDayHint =>
      'الراحة جزء من التمرين. امشِ شوية، اعمل إطالة، وكمّل البروتين.';

  @override
  String uxWorkoutMinutes(int minutes) {
    return '~$minutes دقيقة';
  }

  @override
  String get uxWater => 'المياه';

  @override
  String get uxGlassSize => '250 مل';

  @override
  String uxWaterAdded(String liters) {
    return '+250 مل · $liters لتر النهارده';
  }

  @override
  String get uxWaterGoalDone => 'وصلت لهدف المياه 💧 عاش!';

  @override
  String get uxUndo => 'تراجع';

  @override
  String get uxCopied => 'تم النسخ';

  @override
  String get uxSend => 'إرسال';

  @override
  String get uxQuickLogTitle => 'تسجيل سريع';

  @override
  String get uxQuickLogSubtitle => 'سجّل أي حاجة بضغطة واحدة.';

  @override
  String get uxQuickScanTitle => 'صوّر وجبتك بالذكاء الاصطناعي';

  @override
  String get uxQuickScanSub => 'السعرات والماكروز في ثواني';

  @override
  String get uxQuickWater => 'مياه';

  @override
  String get uxQuickWaterSub => '+كوباية · 250 مل';

  @override
  String get uxQuickWeight => 'الوزن';

  @override
  String get uxQuickWeightSub => 'سجّل وزن النهارده';

  @override
  String get uxQuickCardio => 'كارديو';

  @override
  String get uxQuickCardioSub => 'مشي، جري، عجلة…';

  @override
  String get uxQuickCoach => 'اسأل المدرب';

  @override
  String get uxQuickCoachSub => 'نصيحة ذكية ليك';

  @override
  String get uxCoachOnline => 'متصل · عارف أرقامك';

  @override
  String get uxCoachTyping => 'بيكتب…';

  @override
  String get uxCoachNewChat => 'محادثة جديدة';

  @override
  String get uxCoachClearConfirm =>
      'تبدأ محادثة جديدة؟ الرسائل الحالية هتتمسح.';

  @override
  String get uxCoachHeroTitle => 'مدربك الشخصي الذكي';

  @override
  String get uxCoachHeroBody =>
      'اسأل عن الأكل، البروتين، الحلويات أو التمرين. كل إجابة مبنية على أرقامك النهارده.';

  @override
  String uxCoachKcalLeft(int kcal) {
    return 'باقي $kcal سعرة';
  }

  @override
  String uxCoachProteinLeft(int grams) {
    return 'باقي ${grams}g بروتين';
  }

  @override
  String get uxCoachChipWorkout => 'آكل إيه قبل التمرين؟';

  @override
  String get uxProtein => 'بروتين';

  @override
  String get uxCarbs => 'كارب';

  @override
  String get uxFat => 'دهون';

  @override
  String get aiScanAnalysisTitle => 'تحليل الذكاء الاصطناعي';

  @override
  String get diaryAddMeal => 'إضافة وجبة';

  @override
  String get diaryAddWorkout => 'إضافة تمرين';

  @override
  String get diaryCaloriesIn => 'السعرات الداخلة';

  @override
  String get diaryCaloriesOut => 'السعرات المحروقة';

  @override
  String diaryKcal(int kcal) {
    return '$kcal سعرة';
  }

  @override
  String diaryLastUpdated(String count) {
    return 'آخر تحديث $count';
  }

  @override
  String diaryMealCalories(int calories) {
    return '$calories سعرة';
  }

  @override
  String get diaryNetBalance => 'العجز اليومي';

  @override
  String get diaryNoEntries => 'لا توجد سجلات لهذا اليوم';

  @override
  String get diaryProtein => 'البروتين';

  @override
  String diaryProteinProgress(int current, int goal) {
    return '$current / $goal g';
  }

  @override
  String get diarySetGoalsCta => 'تحديد الأهداف';

  @override
  String get diarySetGoalsFirst => 'حدد أهدافك أولاً';

  @override
  String get diaryTimeline => 'الخط الزمني';

  @override
  String get diaryTitle => 'يومياتي';

  @override
  String get diaryToday => 'اليوم';

  @override
  String get diaryWater => 'المياه';

  @override
  String diaryWaterAmount(int amount) {
    return '$amount ml';
  }

  @override
  String diaryWaterProgress(int current, int goal) {
    return '$current / $goal ml';
  }

  @override
  String diaryWorkoutSubtitle(int minutes, int calories) {
    return '$minutes دقيقة · $calories سعرة';
  }

  @override
  String get exerciseAdvanced => 'متقدم';

  @override
  String get exerciseBeginner => 'مبتدئ';

  @override
  String get exerciseComplete => 'تم المجموعة';

  @override
  String get exerciseDifficulty => 'مستوى الصعوبة';

  @override
  String get exerciseEquipment => 'المعدات';

  @override
  String get exerciseIntermediate => 'متوسط';

  @override
  String get exerciseLoadingDemo => 'جاري تحميل التمرين...';

  @override
  String get exerciseMistakes => 'أخطاء شائعة';

  @override
  String get exerciseReps => 'تكرارات';

  @override
  String get exerciseRest => 'راحة';

  @override
  String get exerciseSets => 'مجموعات';

  @override
  String get exerciseSteps => 'الخطوات';

  @override
  String get exerciseTips => 'نصائح احترافية';

  @override
  String get exerciseViewBack => 'خلفي';

  @override
  String get exerciseViewFront => 'أمامي';

  @override
  String get measurements30Days => '30 يوم';

  @override
  String get measurements3Months => '3 شهور';

  @override
  String get measurements7Days => '7 أيام';

  @override
  String get measurementsAdd => 'إضافة قياس';

  @override
  String get measurementsAddFirst => 'سجّل أول قياس';

  @override
  String get measurementsAll => 'الكل';

  @override
  String get measurementsArms => 'الذراعين';

  @override
  String get measurementsBodyFat => 'نسبة الدهون';

  @override
  String get measurementsChest => 'الصدر';

  @override
  String get measurementsDate => 'التاريخ';

  @override
  String get measurementsDelete => 'حذف';

  @override
  String get measurementsDeleteConfirm => 'تمسح القياس ده؟';

  @override
  String get measurementsHistory => 'السجل';

  @override
  String measurementsLastUpdated(String date) {
    return 'اتحدّث $date';
  }

  @override
  String get measurementsNeedMoreData =>
      'سجّل المزيد من القياسات لمتابعة التطور والرسوم البيانية';

  @override
  String get measurementsNoData => 'لسه مفيش قياسات';

  @override
  String get measurementsNotes => 'ملاحظات';

  @override
  String get measurementsSave => 'حفظ';

  @override
  String get measurementsThighs => 'الفخذين';

  @override
  String get measurementsTitle => 'القياسات';

  @override
  String get measurementsTrendDeclining => 'محتاج متابعة';

  @override
  String get measurementsTrendImproving => 'بيتحسّن';

  @override
  String get measurementsTrendStable => 'ثابت';

  @override
  String get measurementsWaist => 'الخصر';

  @override
  String get measurementsWeight => 'الوزن';

  @override
  String get measurementsWeightInvalid => 'اكتب وزن صحيح';

  @override
  String get muscleBack => 'الظهر';

  @override
  String get muscleBiceps => 'البايسبس';

  @override
  String get muscleCalves => 'السمانة';

  @override
  String get muscleChest => 'الصدر';

  @override
  String get muscleCore => 'البطن';

  @override
  String get muscleForearms => 'الساعد';

  @override
  String get muscleGlutes => 'الأرداف';

  @override
  String get muscleHamstrings => 'الفخذ الخلفي';

  @override
  String get muscleHipFlexors => 'مثني الورك';

  @override
  String get muscleQuads => 'الفخذ الأمامي';

  @override
  String get muscleShoulders => 'الكتف';

  @override
  String get muscleTriceps => 'الترايسبس';

  @override
  String get notificationsBreakfast => 'تذكير الإفطار';

  @override
  String get notificationsDinner => 'تذكير العشاء';

  @override
  String get notificationsLunch => 'تذكير الغداء';

  @override
  String get notificationsOpenSettings => 'فتح الإعدادات';

  @override
  String get notificationsPermissionBanner =>
      'فعّل التنبيهات لتصلك تذكيراتك في موعدها';

  @override
  String get notificationsPreWorkout => 'تذكير التمرين';

  @override
  String get notificationsPreWorkoutSubtitle => 'استعد للتمرين والنشاط';

  @override
  String get notificationsSleep => 'تذكير موعد النوم';

  @override
  String get notificationsSleepSubtitle =>
      'استرخِ وجهز نفسك لنوم عميق وتعافٍ أفضل';

  @override
  String get notificationsTest => 'إرسال تذكير تجريبي';

  @override
  String get notificationsTestBody => 'تذكيرات Vireo تعمل بنجاح';

  @override
  String get notificationsTitle => 'التذكيرات';

  @override
  String get notificationsWater => 'تذكير شرب الماء';

  @override
  String get notificationsWaterSubtitle =>
      'حافظ على ترطيب ونشاط جسمك طوال اليوم';

  @override
  String get notificationsWeeklyReport => 'المتابعة الأسبوعية';

  @override
  String get notificationsWeeklyReportSubtitle =>
      'راجع إنجازاتك وتقدمك خلال الأسبوع';

  @override
  String get notificationsFastingOpen => 'بدء نافذة الأكل';

  @override
  String get notificationsFastingOpenSubtitle => 'وقت بدء وجباتك المتوازنة';

  @override
  String get notificationsFastingClose => 'بدء نافذة الصيام';

  @override
  String get notificationsFastingCloseSubtitle =>
      'وقت إراحة جهازك الهضمي وشرب الماء';

  @override
  String get notificationsStepsNudge => 'تذكير الخطوات';

  @override
  String get notificationsStepsNudgeSubtitle =>
      'تنبيه لطيف الساعة 18:00 إذا كانت الخطوات أقل من 50%';

  @override
  String get notificationsStreakProtection => 'حماية السلسلة';

  @override
  String get notificationsStreakProtectionSubtitle =>
      'تنبيه ودي الساعة 21:00 إذا لم تسجل شيئاً اليوم';

  @override
  String get notificationsQuietHoursTitle => 'ساعات الهدوء';

  @override
  String notificationsQuietHoursSubtitle(String start, String end) {
    return 'من $start إلى $end — بدون أي إزعاج';
  }

  @override
  String get notificationsMaxDailyTitle => 'الحد الأقصى اليومي';

  @override
  String notificationsMaxDailySubtitle(int count) {
    return 'بحد أقصى $count تذكيرات يومياً';
  }

  @override
  String get notificationsPermissionDialogTitle =>
      'خلّيك في مسارك مع تذكيرات Vireo';

  @override
  String get notificationsPermissionDialogBody =>
      'هنبعتلك تذكيرات لطيفة ودافية للماء، والتمارين، والوجبات في وقتها. بنحترم ساعات هدوئك تماماً ومش هنزعجك أبداً.';

  @override
  String get notificationsPermissionAllow => 'تفعيل التذكيرات';

  @override
  String get notificationsPermissionNotNow => 'ليس الآن';

  @override
  String get vitality12WeekProgram => 'برنامج الـ 12 أسبوع';

  @override
  String vitalityArticleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مقال',
      few: '$count مقالات',
      two: 'مقالين',
      one: 'مقال واحد',
    );
    return '$_temp0';
  }

  @override
  String get vitalityArticleDisclaimer =>
      'للتثقيف فقط. اسأل مختص قبل أي قرار يخص صحتك.';

  @override
  String get vitalityArticlesSection => 'مقالات';

  @override
  String get vitalityBadgesTitle => 'الأوسمة';

  @override
  String vitalityBreathingCount(int count) {
    return '$count جلسات';
  }

  @override
  String get vitalityBreathingLog => 'جلسة تنفس';

  @override
  String get vitalityCategoryAdvanced => 'متقدم';

  @override
  String get vitalityCategoryEnvironmental => 'البيئة المحيطة';

  @override
  String get vitalityCategoryLifestyle => 'نمط الحياة';

  @override
  String get vitalityCategoryNutrition => 'التغذية';

  @override
  String get vitalityCategoryTraining => 'التدريب';

  @override
  String get vitalityCheckProtein => 'تحقيق هدف البروتين';

  @override
  String get vitalityCheckSleep => 'نوم مريح وصحي';

  @override
  String get vitalityCheckSunlight => 'ضوء الشمس الصباحي';

  @override
  String get vitalityCheckWorkout => 'التمرين والحركة';

  @override
  String get vitalityCheckZincVitD => 'الزنك وفيتامين د';

  @override
  String vitalityDailyChecklistProgress(int done, int total) {
    return '$done من $total تمّت';
  }

  @override
  String get vitalityDailyChecklistTitle => 'قايمة النهاردة';

  @override
  String get vitalityDailyTipLabel => 'نصيحة اليوم';

  @override
  String get vitalityHubSubtitle => 'عادات مبنية على العلم لطاقة وتعافي أحسن';

  @override
  String get vitalityHubTitle => 'مركز الحيوية';

  @override
  String get vitalityLegendBadge => 'أسطورة';

  @override
  String get vitalityLinkCopied => 'اتنسخ الرابط';

  @override
  String get vitalityLogSection => 'السجل';

  @override
  String get vitalityMarkRead => 'علّم كمقروء';

  @override
  String get vitalityMarkReadDone => 'اتقرا';

  @override
  String get vitalityMarkReadSuccess => 'اتعلّم كمقروء';

  @override
  String get vitalityMedicalDisclaimer => 'محتوى تثقيفي فقط — مش نصيحة طبية.';

  @override
  String get vitalityMetricsEmpty => 'لسه مفيش قياسات';

  @override
  String get vitalityMetricsLast7Days => 'آخر 7 أيام';

  @override
  String vitalityMetricsLastEntry(int score) {
    return 'آخر تسجيل · طاقة $score/10';
  }

  @override
  String get vitalityMetricsSave => 'احفظ القياسات';

  @override
  String get vitalityMetricsSaved => 'اتحفظت';

  @override
  String get vitalityMetricsTapToLog => 'اضغط عشان تسجّل';

  @override
  String get vitalityMetricsTitle => 'قياسات يومك';

  @override
  String get vitalityMorningEnergy => 'طاقة الصبح';

  @override
  String get vitalityMyProgram => 'برنامجي';

  @override
  String get vitalityNotLogged => 'لسه متسجّلش';

  @override
  String get vitalityPhaseFoundation => 'التأسيس';

  @override
  String get vitalityPhaseOptimization => 'التحسين';

  @override
  String get vitalityPhasePeak => 'القمة';

  @override
  String get vitalityProgramAllWeeks => 'كل الأسابيع';

  @override
  String get vitalityProgramComplete => 'خلص البرنامج 🎉';

  @override
  String get vitalityProgramContinue => 'كمّل';

  @override
  String get vitalityProgramDisclaimer => 'برنامج تثقيفي — مش علاج طبي.';

  @override
  String get vitalityProgramDone => 'تمّ';

  @override
  String get vitalityProgramOverallProgress => 'تقدّمك الكلي';

  @override
  String get vitalityProgramStartCta => 'يلا نبدأ البرنامج';

  @override
  String get vitalityProgramSubtitle => '12 أسبوع لطاقة ونوم وتعافي أحسن';

  @override
  String get vitalityProgramTitle => 'تحول الحيوية';

  @override
  String get vitalityProtocolBadgeEarned => 'اتفتح وسام جديد!';

  @override
  String get vitalityProtocolCompleteDay => 'كمّل اليوم';

  @override
  String vitalityProtocolStreak(int days) {
    return '$days يوم متتالي';
  }

  @override
  String get vitalityProtocolTitle => 'البروتوكولات';

  @override
  String vitalityReadingTime(int minutes) {
    return 'قراءة $minutes دقيقة';
  }

  @override
  String get vitalityReportCompletion => 'الإنجاز';

  @override
  String get vitalityReportImproving => 'إنت بتتحسّن — كمّل على نفس الخط.';

  @override
  String get vitalityReportKeepGoing =>
      'الخطوات الصغيرة بتفرق. جرّب تخلّص مهمتين النهاردة.';

  @override
  String get vitalityScientificSources => 'المصادر العلمية';

  @override
  String vitalityScoreBreakdown(
    int sleep,
    int workout,
    int protein,
    int stress,
  ) {
    return 'النوم $sleep · التمرين $workout · البروتين $protein · التوتر $stress';
  }

  @override
  String get vitalityScoreLabel => 'الحيوية';

  @override
  String get vitalitySleepHint => 'كيف كان نومك اليوم؟';

  @override
  String vitalitySleepHours(num hours) {
    return '$hours ساعة';
  }

  @override
  String get vitalitySleepLog => 'سجل النوم';

  @override
  String get vitalitySleepQuality => 'جودة النوم';

  @override
  String vitalityStreak(int days) {
    return '$days يوم متتالي';
  }

  @override
  String get vitalityStressLevel => 'التوتر';

  @override
  String get vitalityUnlockNextWeek => 'افتح الأسبوع الجاي';

  @override
  String vitalityWeekProgress(int percent) {
    return '$percent%';
  }

  @override
  String get vitalityWeekReport => 'تقرير الأسبوع';

  @override
  String vitalityWeekX(int week) {
    return 'الأسبوع $week';
  }

  @override
  String vitalityWeekXOf12(int week) {
    return 'الأسبوع $week من 12';
  }

  @override
  String get vitalityWorkoutDone => 'تمّ التمرين';

  @override
  String get vitalityWorkoutLog => 'التمرين';

  @override
  String get vitalityWorkoutPending => 'راحة / لسه';

  @override
  String get vitalityWorkoutPerformance => 'الأداء';

  @override
  String walkingEstimatedMinutes(int minutes) {
    return '~$minutes دقيقة';
  }

  @override
  String get walkingHealthBanner => 'خطوات لايف من عدّاد الموبايل';

  @override
  String get walkingManualStepsLabel => 'خطوات النهاردة';

  @override
  String get walkingUpdateSteps => 'حدّث الخطوات';

  @override
  String get walkingWebManualBanner => 'على الويب، اكتب خطواتك يدوي';

  @override
  String get vitalityKeyTakeaway => 'الخلاصة';

  @override
  String get dietMyPlan => 'خطتي الغذائية';

  @override
  String get dietProgramsTitle => 'برامج الدايت';

  @override
  String get dietQuizTitle => 'اختبار الخطة الغذائية';

  @override
  String get dietQuizContinue => 'فاهم — كمّل';

  @override
  String get dietQuizYes => 'أيوه';

  @override
  String get dietQuizNo => 'لا';

  @override
  String dietQuizHealthStep(int current, int total) {
    return 'الصحة $current من $total';
  }

  @override
  String dietQuizPrefStep(int current, int total) {
    return 'التفضيلات $current من $total';
  }

  @override
  String get dietPrefBreadRice => 'بتحب العيش والرز؟';

  @override
  String get dietPrefSkipBreakfast => 'تقدر تتخطى الفطار براحة؟';

  @override
  String get dietPrefSimpleRules => 'بتحب قواعد أكل بسيطة؟';

  @override
  String get dietPrefEatsOut => 'بتاكل برا البيت كتير؟';

  @override
  String get dietPrefWeights => 'بتمرّن حديد بانتظام؟';

  @override
  String get dietRecommendedBadge => 'موصى بيه ليك';

  @override
  String get dietActiveBadge => 'نشط';

  @override
  String get dietNeedsDoctor => 'محتاج موافقة دكتور';

  @override
  String get dietReadWarning => 'اقرأ التحذير';

  @override
  String dietCardMacros(int kcal, int protein) {
    return '$kcal سعرة · $proteinجم بروتين';
  }

  @override
  String get dietHowItWorks => 'إزاي بيشتغل';

  @override
  String get dietYourTargets => 'أهدافك';

  @override
  String get dietBestFor => 'مناسب لـ';

  @override
  String get dietNotIdealFor => 'مش مثالي لـ';

  @override
  String get dietRules => 'القواعد';

  @override
  String get dietAllowedFoods => 'أكل مسموح';

  @override
  String get dietLimitFoods => 'قلّل دول';

  @override
  String get dietSampleDay => 'يوم نموذجي';

  @override
  String get dietSideEffects => 'أعراض جانبية';

  @override
  String get dietTips => 'نصايح';

  @override
  String get dietEvidence => 'الأدلة';

  @override
  String get dietStopSigns => 'علامات التوقف';

  @override
  String get dietDisclaimer => 'إخلاء مسؤولية';

  @override
  String get dietStartProgram => 'ابدأ البرنامج ده';

  @override
  String get dietDoctorGateTitle => 'محتاج موافقة دكتور';

  @override
  String get dietAckWarning => 'قرأت التحذير';

  @override
  String get dietMustAckWarning => 'أكّد إنك قرأت التحذير الأول';

  @override
  String get dietStartedToast => 'بدأنا برنامج الدايت';

  @override
  String get dietClose => 'إغلاق';

  @override
  String dietCarbsMax(int grams) {
    return 'حد الكارب: $grams جم';
  }

  @override
  String dietWeeklyLoss(String kg) {
    return 'خسارة أسبوعية متوقعة ≈ $kg كجم';
  }

  @override
  String get dietChoosePlanCard => 'اختار خطتك الغذائية';

  @override
  String dietFastingLeft(String time) {
    return 'صيام — باقي $time';
  }

  @override
  String dietEatingWindowLeft(String time) {
    return 'وقت الأكل — يقفل بعد $time';
  }

  @override
  String dietWindowStartsAt(int hour) {
    return 'وقت الأكل يبدأ الساعة $hour:00';
  }

  @override
  String get dietEditWindow => 'عدّل ساعة البداية';

  @override
  String get dietCarbsLimitLabel => 'حد الكارب';

  @override
  String dietCarbsLimitProgress(int current, int max) {
    return '$current / $max جم كارب';
  }

  @override
  String get todayPlanTitle => 'خطة اليوم';

  @override
  String todayPlanProgressSummary(int percent, int done, int total) {
    return 'أنجزت $percent% من يومك · $done/$total';
  }

  @override
  String get todayPlanNow => 'الآن';

  @override
  String get todayPlanPro => 'PRO';

  @override
  String todayPlanWaterReminder(int index, int total) {
    return 'تذكير ماء $index من $total';
  }

  @override
  String todayPlanWaterGoalLine(int ml) {
    return 'الهدف اليومي $ml مل';
  }

  @override
  String get todayPlanFastingOpen => 'بداية نافذة الأكل';

  @override
  String todayPlanFastingOpenSubtitle(int hours) {
    return 'نافذة أكل $hours ساعة';
  }

  @override
  String get todayPlanFastingClose => 'نهاية نافذة الأكل';

  @override
  String todayPlanFastingCloseSubtitle(int hours) {
    return 'صيام $hours ساعة';
  }

  @override
  String get todayPlanWorkout => 'تمرين اليوم';

  @override
  String get todayPlanSteps => 'هدف الخطوات';

  @override
  String todayPlanStepsProgress(int current, int goal) {
    return '$current / $goal خطوة';
  }

  @override
  String get todayPlanVitalitySleepSubtitle => 'سجّل 7.5+ ساعات في الحيوية';

  @override
  String get todayPlanVitalityProteinSubtitle => 'حقّق هدف البروتين';

  @override
  String get todayPlanVitalitySunSubtitle => 'ضوء الشمس الصباحي';

  @override
  String get todayPlanVitalityStress => 'تخفيف التوتر';

  @override
  String get todayPlanVitalityStressSubtitle => 'جلسة تنفس';

  @override
  String get todayPlanVitalityZincSubtitle => 'زنك وفيتامين D من الغذاء';

  @override
  String get todayPlanSleepTarget => 'هدف النوم';

  @override
  String get todayPlanSleepTargetSubtitle => 'استعد للنوم';

  @override
  String get todayPlanProtocolItem => 'بروتوكول الحيوية';

  @override
  String get todayPlanAiSuggestion => 'اقتراح المدرب';

  @override
  String get todayPlanAiSuggestionSubtitle => 'نصيحة مخصصة لليوم';

  @override
  String waterGoalBasedOnWeight(int kg) {
    return 'حسب وزنك ($kg كجم)';
  }

  @override
  String get authErrorEmailRateLimit => 'رسائل كثيرة، جرّب بعد ساعة';

  @override
  String get profileMyBody => 'جسمي';

  @override
  String get profileGuestProgressHint => 'ضيف — التقدّم غير محفوظ';

  @override
  String get profilePlanPro => 'Pro';

  @override
  String get profilePlanFree => 'مجاني';

  @override
  String profileMemberSince(String date) {
    return 'عضو منذ $date';
  }

  @override
  String get profileSaveProgressCta => 'احفظ تقدّمك';

  @override
  String get profileMyPlanSection => 'خطتي';

  @override
  String get profileChangeDietPlan => 'غيّر الخطة';

  @override
  String get profileBodyMetricsSaved => 'تم تحديث القياسات';

  @override
  String get profileSaveBodyMetrics => 'حفظ';

  @override
  String get profileEditDisplayName => 'الاسم المعروض';

  @override
  String get profileDisplayNameHint => 'اسمك';

  @override
  String get profileFitnessGoal => 'الهدف';

  @override
  String get activityHubTitle => 'النشاط والصحة';

  @override
  String get activityHubSubtitle => 'تمارين GPS، مقاييس الساعة، وتنفس موجّه.';

  @override
  String get activityHealthHomeCardTitle => 'النشاط والصحة';

  @override
  String get activityHealthHomeCardSubtitle =>
      'اربط ساعتك أو ابدأ تمريناً خارجياً';

  @override
  String get outdoorWorkoutTitle => 'تمرين خارجي';

  @override
  String get outdoorWorkoutSubtitle => 'مشي، جري، أو دراجة مع GPS';

  @override
  String get outdoorPickTitle => 'اختر النشاط';

  @override
  String get outdoorPickSubtitle => 'تتبع GPS يعمل فقط أثناء الجلسة.';

  @override
  String get outdoorTypeWalk => 'مشي';

  @override
  String get outdoorTypeRun => 'جري';

  @override
  String get outdoorTypeCycle => 'دراجة';

  @override
  String get outdoorGo => 'انطلق!';

  @override
  String get outdoorLocationDenied => 'يلزم إذن الموقع لتمرين GPS.';

  @override
  String get outdoorDistance => 'المسافة';

  @override
  String get outdoorDuration => 'المدة';

  @override
  String get outdoorPace => 'الوتيرة';

  @override
  String get outdoorSpeed => 'السرعة';

  @override
  String outdoorPaceMinKm(int min, int sec) {
    return '$min:$sec / كم';
  }

  @override
  String outdoorSpeedKmh(String speed) {
    return '$speed كم/س';
  }

  @override
  String outdoorCalories(int kcal) {
    return '$kcal سعرة محروقة';
  }

  @override
  String get outdoorPause => 'إيقاف مؤقت';

  @override
  String get outdoorResume => 'استئناف';

  @override
  String get outdoorHoldToStop => 'اضغط مطولاً للإنهاء';

  @override
  String get outdoorStopTitle => 'إنهاء التمرين؟';

  @override
  String get outdoorStopBody => 'سيتم حفظ المسار والإحصائيات.';

  @override
  String get outdoorStopConfirm => 'إنهاء';

  @override
  String get outdoorPaused => 'متوقف مؤقتاً';

  @override
  String get outdoorAutoPause => 'إيقاف تلقائي عند التوقف';

  @override
  String get outdoorHistoryTitle => 'سجل التمارين';

  @override
  String get outdoorHistorySubtitle => 'جلسات GPS السابقة';

  @override
  String get outdoorHistoryEmpty => 'لا توجد تمارين خارجية بعد.';

  @override
  String get outdoorDetailTitle => 'تفاصيل التمرين';

  @override
  String get outdoorSplitsTitle => 'Splits لكل كيلومتر';

  @override
  String outdoorSplitKm(int km) {
    return 'كم $km';
  }

  @override
  String get uxQuickOutdoor => 'تمرين خارجي';

  @override
  String get uxQuickOutdoorSub => 'مشي، جري، أو دراجة GPS';

  @override
  String get healthHubTitle => 'الصحة';

  @override
  String get healthHubCardSubtitle => 'نبض، نوم، SpO₂ من ساعتك';

  @override
  String get healthHubProgressSubtitle => 'مقاييس الساعة ودرجة النوم';

  @override
  String get healthNotMedical =>
      'ليس للاستخدام الطبي. البيانات من ساعتك عبر Health Connect / Apple Health.';

  @override
  String get healthFromWatch => 'من ساعتك';

  @override
  String get healthConnectWatchTitle => 'اربط ساعتك';

  @override
  String get healthConnectWatchBody =>
      'اسمح بالوصول إلى Health Connect أو Apple Health. لا نقدّر العلامات الحيوية من الهاتف.';

  @override
  String get healthGrantPermission => 'منح صلاحية الصحة';

  @override
  String get healthMetricHeartRate => 'نبض القلب';

  @override
  String get healthMetricRestingHr => 'نبض الراحة';

  @override
  String get healthMetricHrv => 'HRV';

  @override
  String get healthMetricSpO2 => 'أكسجين الدم';

  @override
  String get healthMetricSleep => 'النوم';

  @override
  String get healthMetricWeight => 'الوزن';

  @override
  String get healthMetricWorkout => 'تمارين';

  @override
  String get healthMetricSteps => 'خطوات';

  @override
  String get healthManualSleepTitle => 'تسجيل نوم يدوي';

  @override
  String get healthManualSleepHint => 'لا بيانات نوم من الساعة — اضغط للتسجيل';

  @override
  String healthSleepScore(int score) {
    return 'درجة النوم $score';
  }

  @override
  String get healthBedtime => 'وقت النوم';

  @override
  String get healthWakeTime => 'وقت الاستيقاظ';

  @override
  String get healthSleepQuality => 'الجودة (1–5)';

  @override
  String get healthStressTitle => 'مستوى التوتر (HRV)';

  @override
  String get healthStressLow => 'منخفض';

  @override
  String get healthStressMedium => 'متوسط';

  @override
  String get healthStressHigh => 'مرتفع';

  @override
  String healthHrvDetail(int today, int baseline) {
    return 'اليوم $today ms مقابل baseline $baseline ms';
  }

  @override
  String get breathingHubTitle => 'التنفس';

  @override
  String get breathingHubSubtitle => 'جلسات موجّهة للاسترخاء';

  @override
  String get breathingBoxTitle => 'تنفس صندوقي 4-4-4-4';

  @override
  String get breathingBoxSubtitle => 'شهيق، حبس، زفير، حبس';

  @override
  String get breathing478Title => '4-7-8 للاسترخاء';

  @override
  String get breathing478Subtitle => 'نمط مهدئ قبل النوم';

  @override
  String breathingMinutes(int min) {
    return '$min د';
  }

  @override
  String get breathingSessionTitle => 'جلسة تنفس';

  @override
  String get breathingInhale => 'شهيق';

  @override
  String get breathingHold => 'حبس';

  @override
  String get breathingExhale => 'زفير';

  @override
  String get breathingRest => 'راحة';

  @override
  String get mealReviewTitle => 'مراجعة الوجبة';

  @override
  String get mealReviewAddItem => 'أضف صنفاً';

  @override
  String get mealReviewSlot => 'الوجبة';

  @override
  String mealReviewRemaining(int kcal) {
    return 'المتبقي من الميزانية: $kcal سعرة';
  }

  @override
  String get mealReviewEstimated => 'تقديري';

  @override
  String mealReviewKcalApprox(int count) {
    return '≈ $count سعرة';
  }

  @override
  String get mealReviewPortionLabel => 'الحصة';

  @override
  String get mealReviewOilPrefix => 'زيت:';

  @override
  String get mealReviewOilLight => 'خفيف';

  @override
  String get mealReviewOilNormal => 'عادي';

  @override
  String get mealReviewOilHeavy => 'مسبّك';

  @override
  String get mealReviewFamilyPlateToggle => 'أكلنا من طبق واحد';

  @override
  String get mealReviewMyShare => 'نصيبي';

  @override
  String get ramadanWaterTrackerQuestion =>
      'شربت كام كوباية من الإفطار للسحور؟';

  @override
  String ramadanWaterGoalSplit(int iftarCups, int eveningCups, int suhoorCups) {
    return 'هدف الإفطار: $iftarCups · الليل: $eveningCups · السحور: $suhoorCups كوب';
  }

  @override
  String get ramadanPrayerCityPickerTitle => 'اختار مدينة المواعيد';

  @override
  String get ramadanPrayerCityCustom => 'مدينة تانية';

  @override
  String get ramadanCustomCityName => 'اسم المدينة';

  @override
  String get ramadanCustomCityLat => 'خط العرض';

  @override
  String get ramadanCustomCityLng => 'خط الطول';

  @override
  String get notificationPostScanTitle => 'عايزني أفكرك بالوجبات؟';

  @override
  String get notificationPostScanBody =>
      'تذكيرات لطيفة بمواعيد الغدا والعشا — مرتين في اليوم بس، ومفيش إزعاج من ١١ بالليل لـ ٧ الصبح.';

  @override
  String get notificationPostScanYes => 'أيوه، فكّرني';

  @override
  String get notificationPostScanNotNow => 'مش دلوقتي';

  @override
  String get mealReviewCheckAmount => 'راجع الكمية';

  @override
  String get mealReviewSearchFood => 'ابحث عن أكل…';

  @override
  String get mealReviewLogByText => 'سجّل بالنص بدل كده';

  @override
  String get mealLogTextTitle => 'تسجيل وجبة بالنص';

  @override
  String get mealLogTextHint => 'اكتب اللي أكلته — عربي أو إنجليزي.';

  @override
  String get mealLogTextPlaceholder => 'أكلت 2 بيض ورغيف بلدي وكوباية شاي بسكر';

  @override
  String get mealLogTextAnalyze => 'حلّل';

  @override
  String get mealVoiceStart => 'صوت';

  @override
  String get mealVoiceListening => 'بسمع…';

  @override
  String get mealVoiceUnavailable => 'التسجيل الصوتي غير متاح على الجهاز';

  @override
  String get mealBarcodeTitle => 'مسح باركود';

  @override
  String get mealBarcodeFailed =>
      'مقدرناش نلاقي الباركود. جرّب تاني أو سجّل بالنص.';

  @override
  String get mealScanHintLabel => 'زوّد بكلمتين (اختياري)';

  @override
  String get mealScanHintPlaceholder => 'فيها زيت؟ صوص؟ نوع العيش؟';

  @override
  String get mealHowCalculated => 'إزاي حسبناها';

  @override
  String get plateSizeAskTitle => 'طبقك عادة قد إيه؟';

  @override
  String get plateSizeSmall => 'صغير';

  @override
  String get plateSizeMedium => 'وسط';

  @override
  String get plateSizeLarge => 'كبير';

  @override
  String get inbodyScanTitle => 'مسح تقرير InBody';

  @override
  String get inbodyReviewTitle => 'مراجعة نتيجة InBody';

  @override
  String get inbodyBodyTitle => 'تركيب الجسم';

  @override
  String get inbodyAddResult => 'أضف نتيجة InBody';

  @override
  String get inbodyPickPdf => 'اختَر PDF';

  @override
  String get inbodyFrameHint => 'خلّي ورقة التقرير كاملة جوّه الإطار';

  @override
  String get inbodyAnalyzing => 'بنقرأ التقرير…';

  @override
  String get inbodyUnreadable => 'مقدرناش نقرأ الورقة. صوّر أوضح.';

  @override
  String get inbodyScanFailed => 'فشل مسح InBody. جرّب تاني.';

  @override
  String get inbodySaved => 'اتحفظت نتيجة InBody';

  @override
  String get inbodyMedicalNote => 'مش للاستخدام الطبي — للتتبع الرياضي فقط.';

  @override
  String get inbodyTestDate => 'تاريخ القياس';

  @override
  String get inbodyDevice => 'الجهاز';

  @override
  String get inbodyWeight => 'الوزن (كجم)';

  @override
  String get inbodySmm => 'العضلات الهيكلية (كجم)';

  @override
  String get inbodyFatMass => 'كتلة الدهون (كجم)';

  @override
  String get inbodyPbf => 'نسبة الدهون %';

  @override
  String get inbodyBmi => 'BMI';

  @override
  String get inbodyVisceral => 'دهون حشوية';

  @override
  String get inbodyBmr => 'BMR (سعرة)';

  @override
  String get inbodyScore => 'درجة InBody';

  @override
  String get inbodySave => 'احفظ النتيجة';

  @override
  String get inbodyEmpty => 'مفيش تقارير لسه. امسح ورقة InBody عشان تبدأ.';

  @override
  String get inbodyLatestTitle => 'آخر تقرير';

  @override
  String get inbodyCompareTitle => 'قارن تقريرين';

  @override
  String get inbodySyncHealth => 'مزامنة Health Connect';

  @override
  String get inbodySyncedLabel => 'متزامن من Health Connect';

  @override
  String inbodySyncResult(int count) {
    return 'اتستورد $count قراءة من Health Connect';
  }

  @override
  String inbodyFromDateLabel(String date) {
    return 'من InBody بتاعك يوم $date';
  }

  @override
  String get uxQuickInbody => 'تقرير InBody';

  @override
  String get uxQuickInbodySub => 'امسح ورقة النتيجة';

  @override
  String get mealScanHeroTitle => 'امسح وجبتك';

  @override
  String get mealScanHeroSubtitle =>
      'الذكاء يتعرف على الأكل — وأنت تؤكد الجرامات';

  @override
  String get mealScanTipAbove => 'صوّر من فوق';

  @override
  String get mealScanTipWholePlate => 'الطبق كله ظاهر';

  @override
  String get mealScanTipLight => 'إضاءة كويسة';

  @override
  String get mealScanFlashOn => 'الفلاش شغال';

  @override
  String get mealScanFlashOff => 'الفلاش مقفول';

  @override
  String get uxQuickMealText => 'وجبة بالنص';

  @override
  String get uxQuickMealTextSub => 'اكتب اللي أكلته';

  @override
  String get uxQuickBarcode => 'باركود';

  @override
  String get uxQuickBarcodeSub => 'من Open Food Facts';

  @override
  String get mealFavoriteSave => 'احفظ كمفضلة';

  @override
  String get mealFavoriteSaved => 'اتحفظت في المفضلة';

  @override
  String get mealFavoritesTitle => 'المفضلة';

  @override
  String get mealRecentTitle => 'وجبات أخيرة';

  @override
  String get mealRelog => 'سجّل تاني';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get themeModeSystem => 'تلقائي للنظام';

  @override
  String get themeModeLight => 'الوضع الفاتح';

  @override
  String get themeModeDark => 'الوضع الداكن';

  @override
  String get accentThemeTitle => 'لون التمييز';

  @override
  String get accentEmber => 'إمبير (افتراضي)';

  @override
  String get accentOcean => 'محيطي';

  @override
  String get accentForest => 'غابة';

  @override
  String get accentRoyal => 'ملكي';

  @override
  String detectedActivity(String activity) {
    return 'تم التعرف: $activity';
  }

  @override
  String get manualOverride => 'تعديل';

  @override
  String get mealClarificationTitle => 'تأكيد سريع';

  @override
  String get celebrationWaterTitle => 'حققت هدف شرب الماء اليومي! 💧';

  @override
  String get celebrationProteinTitle => 'حققت هدف البروتين اليومي! 💪';

  @override
  String get celebrationStepsTitle => 'حققت هدف الخطوات اليومي! 🏃';

  @override
  String get celebrationWorkoutTitle => 'أحسنت! أنهيت تمرينك اليوم بنجاح 🔥';

  @override
  String fatEquivalentApprox(String amount) {
    return '≈ $amount دهون';
  }

  @override
  String fatEquivalentBurned(String amount) {
    return 'حرقت ما يعادل ≈ $amount دهون';
  }

  @override
  String fatEquivalentTodayDeficit(String amount) {
    return 'عجز اليوم ≈ $amount دهون';
  }

  @override
  String fatEquivalentTodaySurplus(int kcal) {
    return 'فائض +$kcal سعرة';
  }

  @override
  String fatEquivalentDietPlanRate(String daily, String weekly) {
    return '≈ $daily دهون/يوم • ≈ $weekly/أسبوع';
  }

  @override
  String fatEquivalentThisWeek(String amount) {
    return '≈ $amount دهون هذا الأسبوع';
  }

  @override
  String get fatEquivalentInfoTitle => 'معادل الدهون';

  @override
  String get fatEquivalentInfoBody =>
      'الوزن على الميزان يتأثر أيضاً بالماء والجليكوجين، لذا قد يتغير وزنك اليومي بشكل مختلف. هذا هو المكافئ الحسابي لطاقة الدهون.';

  @override
  String get fatEquivalentInfoDismiss => 'فهمت';

  @override
  String get legalTerms => 'الشروط';

  @override
  String get legalPrivacy => 'الخصوصية';

  @override
  String get legalMedicalDisclaimer => 'إخلاء المسؤولية الطبية';

  @override
  String get welcomeTagline => 'تغذية ذكية ولياقة متطورة مصممة خصيصاً للرجال.';

  @override
  String get welcomePillarScannerTitle => 'المسح الفوري للأطباق';

  @override
  String get welcomePillarScannerDesc =>
      'صوّر وجبتك، واعرف السعرات والبروتين بدقة في ثانيتين';

  @override
  String get welcomePillarPlanTitle => 'خطة يومية مخصصة';

  @override
  String get welcomePillarPlanDesc =>
      'أهداف علمية مدروسة تناسب طبيعة جسمك وهدفك';

  @override
  String get welcomePillarSafetyTitle => 'تغذية آمنة سريرياً';

  @override
  String get welcomePillarSafetyDesc => 'إرشادات تحمي عملية الأيض وصحتك العامة';

  @override
  String get onboardingGoalTitle => 'ما هو هدفك الأساسي؟';

  @override
  String get onboardingGoalSubtitle =>
      'اختر الأهم بالنسبة لك، وسنصمم أهدافك اليومية بناءً عليه.';

  @override
  String get goalLoseFatTitle => 'خسارة الدهون';

  @override
  String get goalLoseFatSubtitle =>
      'حرق الدهون العنيدة مع الحفاظ الكامل على الكتلة العضلية';

  @override
  String get goalBuildMuscleTitle => 'بناء العضلات';

  @override
  String get goalBuildMuscleSubtitle =>
      'تحفيز الضخامة العضلية الصافية بتوزيع مثالي للبروتين وتدرج الأحمال';

  @override
  String get goalMoreEnergyTitle => 'طاقة ونشاط أعلى';

  @override
  String get goalMoreEnergySubtitle =>
      'التخلص من خمول منتصف اليوم ورفع مستوى التحمل والحيوية';

  @override
  String get goalAllOfAboveTitle => 'كل ما سبق';

  @override
  String get goalAllOfAboveSubtitle =>
      'إعادة تشكيل شاملة للجسم: خسارة الدهون، زيادة القوة، وطاقة مستمرة';

  @override
  String get onboardingBodyTitle => 'بيانات جسمك';

  @override
  String get onboardingBodySubtitle =>
      'البيانات الدقيقة تساعدنا في حساب معدل حرقك واحتياجاتك اليومية بدقة.';

  @override
  String get sexMale => 'ذكر';

  @override
  String get sexFemale => 'أنثى';

  @override
  String get unitMetric => 'متري';

  @override
  String get unitImperial => 'باوند';

  @override
  String get bodyMetricAge => 'العمر';

  @override
  String bodyMetricYears(int age) {
    return '$age سنة';
  }

  @override
  String get selectAgeTitle => 'اختر العمر';

  @override
  String ageYearsSuffix(int age) {
    return '$age سنة';
  }

  @override
  String get bodyMetricHeight => 'الطول';

  @override
  String get selectHeightTitle => 'اختر الطول';

  @override
  String get bodyMetricCurrentWeight => 'الوزن الحالي';

  @override
  String get selectCurrentWeightTitle => 'اختر الوزن الحالي';

  @override
  String get bodyMetricTargetWeight => 'الوزن المستهدف';

  @override
  String get selectTargetWeightTitle => 'اختر الوزن المستهدف';

  @override
  String get pickerDone => 'تم';

  @override
  String get onboardingActivityTitle => 'النشاط ومكان التدريب';

  @override
  String get onboardingActivitySubtitle =>
      'نحسب معدل حرق السعرات ونقترح أفضل التمارين المناسبة لك.';

  @override
  String get dailyActivityLevelHeader => 'مستوى النشاط اليومي';

  @override
  String get activitySedentaryTitle => 'قليل الحركة / عمل مكتبي';

  @override
  String get activitySedentarySubtitle =>
      'مشي يومي قليل، وظيفة مكتبية، أقل من 5,000 خطوة';

  @override
  String get activityModeratelyActiveTitle => 'نشاط متوسط';

  @override
  String get activityModeratelyActiveSubtitle =>
      'حركة منتظمة على مدار اليوم، 6,000 إلى 10,000 خطوة يومياً';

  @override
  String get activityVeryActiveTitle => 'نشط جداً / عمل بدني';

  @override
  String get activityVeryActiveSubtitle =>
      'حركة مستمرة أو أكثر من 12,000 خطوة يومياً';

  @override
  String get trainingPlaceHeader => 'أين تخطط للتمرن؟';

  @override
  String get trainingPlaceGymTitle => 'النادي الرياضي (الجيم)';

  @override
  String get trainingPlaceGymSubtitle => 'توفر كامل للأوزان والبارات والأجهزة';

  @override
  String get trainingPlaceHomeTitle => 'في المنزل';

  @override
  String get trainingPlaceHomeSubtitle =>
      'بوزن الجسم، أحبال المقاومة، أو أوزان خفيفة';

  @override
  String get trainingPlaceWalkingTitle => 'المشي';

  @override
  String get trainingPlaceWalkingSubtitle =>
      'خطوات كارديو ومشي في الهواء الطلق';

  @override
  String get onboardingHealthSafetyTitle => 'فحص السلامة الصحية';

  @override
  String get onboardingHealthSafetySubtitle =>
      'حدد أي حالات تنطبق عليك ليصمم نظامنا خطة آمنة تماماً لصحتك.';

  @override
  String get healthSafetyNoneApply => 'لا ينطبق عليّ أي مما سبق';

  @override
  String get healthSafetyOrSelect => 'أو اختر ما ينطبق عليك';

  @override
  String get onboardingTryScanTitle => 'جرّب المسح الفوري للوجبات';

  @override
  String get onboardingTryScanSubtitle =>
      'شاهد كيف يحلل ڤيريو الوجبات الحقيقية إلى سعرات وعناصر غذائية في لحظات.';

  @override
  String get tryScanSamplePlateTitle => 'نموذج وجبة غنية بالبروتين';

  @override
  String get tryScanSamplePlateDesc => 'دجاج مشوي، أرز أبيض وسلطة خضراء';

  @override
  String get tryScanAnalyzing => 'جاري تحليل الوجبة...';

  @override
  String get tryScanSampleCta => 'امسح الطبق النموذجي (تجربة فورية)';

  @override
  String get tryScanOrTestLive => 'أو جرّب على طبقك الحقيقي';

  @override
  String get tryScanOwnMealTitle => 'صوّر وجبتك الحالية';

  @override
  String get tryScanOwnMealDesc => 'التقط صورة حية للطبق الذي أمامك';

  @override
  String get onboardingPlanRevealTitle => 'خطتك المصممة خصيصاً لك';

  @override
  String get onboardingPlanRevealSubtitle =>
      'مصممة وفقاً لمعدل حرقك وطبيعة جسمك وهدفك الرياضي.';

  @override
  String get planRevealStartPlan => 'ابدأ خطتي';

  @override
  String get planRevealProjectedPace => 'المعدل المتوقع';

  @override
  String get planRevealSteadyRecomp => 'إعادة تشكيل متوازنة للجسم';

  @override
  String planRevealFatLossPace(String amount) {
    return 'نزول -$amount كجم دهون أسبوعياً';
  }

  @override
  String planRevealLeanMassPace(String amount) {
    return 'زيادة +$amount كجم عضلات صافية أسبوعياً';
  }

  @override
  String get planRevealDailyCalories => 'هدف السعرات اليومي';

  @override
  String get planRevealPersonalizedBadge => 'مخصص لك';

  @override
  String get planRevealKcalPerDay => 'سعرة / يوم';

  @override
  String get planRevealDailyProtein => 'البروتين اليومي';

  @override
  String get planRevealGramPerDay => 'جم / يوم';

  @override
  String get planRevealHydration => 'شرب الماء';

  @override
  String get planRevealDailySteps => 'الخطوات اليومية';

  @override
  String get planRevealStepsPerDay => 'خطوة / يوم';

  @override
  String get planRevealDietProtocol => 'نظام التغذية';

  @override
  String get planRevealOptimalMatch => 'الخطة الأنسب لك';

  @override
  String get planRevealBalancedPlanDefault => 'خطة العجز المتوازن';

  @override
  String get onboardingNotificationsTitle => 'لا تفوّت أهدافك اليومية';

  @override
  String get onboardingNotificationsSubtitle =>
      'تنبيهات لطيفة تضمن التزامك بتسجيل الوجبات وشرب الماء ومواعيد التمرين.';

  @override
  String get notificationsHeroTitle => 'مصممة للالتزام.. وليس للإزعاج';

  @override
  String get notificationsHeroBody =>
      'المستخدمون الذين يفعّلون التنبيهات أكثر نجاحاً بـ 3.4 أضعاف في الوصول لوزنهم المثالي وبناء عادات مستدامة.';

  @override
  String get notificationsMealLoggingTitle => 'تسجيل الوجبات والأطباق';

  @override
  String get notificationsMealLoggingDesc => 'تذكير في أوقات الغداء والعشاء';

  @override
  String get notificationsWorkoutSessionTitle => 'التمرين اليومي';

  @override
  String get notificationsWorkoutSessionDesc =>
      'حافظ على التزامك بجدول تمارينك';

  @override
  String get notificationsWeeklyReviewTitle => 'المراجعة الأسبوعية للتقدم';

  @override
  String get notificationsWeeklyReviewDesc =>
      'قياس الوزن أسبوعياً وملخص التعديلات المقترحة';

  @override
  String get notificationsEnableButton => 'تفعيل التنبيهات';

  @override
  String get notificationsMaybeLater => 'ربما لاحقاً';

  @override
  String get onboardingPaywallTitle => 'سرّع تحقيق نتائجك';

  @override
  String get onboardingPaywallSubtitle =>
      'امسح الأطباق بلا حدود، واحصل على جداول تمارين ذكية وتحليلات متقدمة.';

  @override
  String get paywallProBadge => 'ڤيريو برو';

  @override
  String get paywallFeatureUnlimitedScansDesc =>
      'بدون أي حدود أو قيود يومية على عدد الوجبات';

  @override
  String get paywallFeatureSmartSub => 'بدائل الوجبات الذكية بالذكاء الاصطناعي';

  @override
  String get paywallFeatureSmartSubDesc =>
      'بدائل صحية ومناسبة للماكروز للأطباق المحلية';

  @override
  String get paywallFeatureAdaptiveSplits => 'جداول تمارين ذكية متكيفة';

  @override
  String get paywallFeatureAdaptiveSplitsDesc =>
      'تتبع زيادة الأوزان والأحمال للجيم أو المنزل';

  @override
  String get paywallPlanAnnualPrice => '\$4.99 / شهرياً';

  @override
  String get paywallPlanAnnualSubtext => 'اشتراك سنوي (وفّر 50%)';

  @override
  String get paywallBadgeBestValue => 'أفضل قيمة';

  @override
  String get paywallPlanMonthlyPrice => '\$9.99 / شهرياً';

  @override
  String get paywallPlanMonthlySubtext => 'اشتراك شهري';

  @override
  String get paywallStartTrialCta => 'ابدأ تجربة مجانية لمدة 7 أيام';

  @override
  String get paywallContinueFreeTier => 'المتابعة بالباقة المجانية';

  @override
  String get appInitErrorFailed => 'فشل في تهيئة خدمات التطبيق.';

  @override
  String get appInitRetry => 'إعادة المحاولة';

  @override
  String get privacyExportTitle => 'تصدير بياناتي';

  @override
  String get privacyExportReady => 'حزمة بياناتك جاهزة بصيغتي JSON و CSV:';

  @override
  String get weeklyProgressShareFailed => 'تعذر إنشاء صورة المشاركة';

  @override
  String get adaptiveCalorieCurrentTarget => 'الهدف الحالي';

  @override
  String get adaptiveCalorieSuggestedTarget => 'الهدف المقترح';

  @override
  String get adaptiveCalorieWindowSpan => 'المدة الزمنية';

  @override
  String get adaptiveCalorieFoodLogsCount => 'عدد أيام تسجيل الطعام';

  @override
  String get adaptiveCalorieWeighInsCount => 'عدد مرات قياس الوزن';

  @override
  String get adaptiveCalorieAverageIntake => 'متوسط السعرات المتناولة';

  @override
  String get adaptiveCalorieTrendWeightChange => 'تغير اتجاه الوزن';

  @override
  String get adaptiveCalorieEstimatedMaintenance => 'سعرات الثبات التقديرية';

  @override
  String get adaptiveCalorieWeeklyChangeCap => 'الحد الأقصى للتغير الأسبوعي';

  @override
  String get adaptiveCalorieSafetyFloorApplied => 'تطبيق الحد الأدنى الآمن';

  @override
  String get chartSevenDayTrend => 'اتجاه 7 أيام';

  @override
  String get chartThirtyDayTrend => 'اتجاه 30 يوماً';

  @override
  String get chartRawDot => 'قياس فردي';

  @override
  String get chartTrendLine => 'خط الاتجاه';

  @override
  String get chartGoalLine => 'خط الهدف';

  @override
  String get scanSourceSheetTitle => 'طريقة تسجيل الوجبة';

  @override
  String get scanSourceCamera => 'صوّر بالكاميرا';

  @override
  String get scanSourceGallery => 'اختار من الاستوديو';

  @override
  String get scanSourceText => 'اكتب الأكل';

  @override
  String get scanSourceFridgeTitle => 'مسح الثلاجة أو الخزانة';

  @override
  String get scanSourceInBodyTitle => 'رفع تقرير إن بادي';

  @override
  String get todayPlanMorning => 'صباحاً';

  @override
  String get todayPlanAfternoon => 'الظهر';

  @override
  String get todayPlanEvening => 'المساء';

  @override
  String get todayPlanWaterQuickAdd => '+250 مل';

  @override
  String todayPlanWaterProgress(String current, String goal) {
    return '$current / $goal لتر';
  }

  @override
  String get todayPlanSleepLogTitle => 'تسجيل جودة النوم';

  @override
  String todayPlanSleepDuration(String hours) {
    return 'نمت $hours ساعات';
  }

  @override
  String get todayPlanSleepLogSave => 'حفظ النوم';

  @override
  String get todayPlanSleepMarkDone => 'تم (7+ ساعات نوم)';

  @override
  String get todayPlanSleepQuality => 'جودة النوم';

  @override
  String get todayPlanSupplements => 'المكملات اليومية';

  @override
  String get todayPlanBreathingAction => 'جلسة تنفس';

  @override
  String get stepsHeroTitle => 'خطوات اليوم';

  @override
  String get stepsEnableButton => 'فعّل عدّ الخطوات';

  @override
  String get stepsPermissionTitle => 'تتبع دقيق للخطوات';

  @override
  String get stepsPermissionBody =>
      'يستخدم ڤيريو حساس الحركة المدمج في جهازك لعد الخطوات بدقة على مدار اليوم بدون استهلاك البطارية.';

  @override
  String get stepsPermissionGrant => 'تفعيل الآن';

  @override
  String get stepsActiveMinutes => 'دقائق نشاط';

  @override
  String stepsFatBurned(String grams) {
    return '≈ $grams جم دهون';
  }

  @override
  String stepsKm(String km) {
    return '$km كم';
  }

  @override
  String get stepsDetailTitle => 'الخطوات والنشاط';

  @override
  String get stepsHourlyTitle => 'توزيع الساعات';

  @override
  String stepsStreakDays(int days) {
    return 'التزام $days أيام متتالية';
  }

  @override
  String stepsBestDay(String steps) {
    return 'أفضل يوم: $steps خطوة';
  }

  @override
  String get stepsWeekTab => 'أسبوع';

  @override
  String get stepsMonthTab => 'شهر';

  @override
  String get mealReviewItemQty => 'الكمية';

  @override
  String mealReviewConfidence(int pct) {
    return 'دقة $pct%';
  }

  @override
  String get mealReviewSourceUsda => 'قاعدة بيانات USDA';

  @override
  String get mealReviewSourceEgypt => 'جدول الأغذية المصري';

  @override
  String get mealReviewSourceAi => 'تقدير الذكاء الاصطناعي';

  @override
  String get mealReviewUnitPiece => 'حبة';

  @override
  String get mealReviewUnitHandful => 'حفنة';

  @override
  String get mealReviewUnitGrams => 'جم';

  @override
  String get mealReviewCookingRaw => 'نيء';

  @override
  String get mealReviewCookingBoiled => 'مسلوق';

  @override
  String get mealReviewCookingGrilled => 'مشوي';

  @override
  String get mealReviewCookingFried => 'مقلي (+زيت)';

  @override
  String get mealReviewCookingBaked => 'في الفرن';

  @override
  String mealReviewCaloriesFormat(int count) {
    return '$count سعرة';
  }

  @override
  String mealReviewProteinFormat(int count) {
    return '$count جم بروتين';
  }

  @override
  String mealReviewCarbsFormat(int count) {
    return '$count جم كارب';
  }

  @override
  String mealReviewFatFormat(int count) {
    return '$count جم دهون';
  }

  @override
  String get cuisineSettingTitle => 'المطبخ';

  @override
  String get cuisineEgyptian => 'مصري';

  @override
  String get cuisineSaudi => 'سعودي وخليجي';

  @override
  String get cuisineLevantine => 'شامي';

  @override
  String get cuisineMoroccan => 'مغربي ومغاربي';

  @override
  String get cuisineTurkish => 'تركي';

  @override
  String get cuisineIndian => 'هندي وباكستاني';

  @override
  String get cuisineIndonesian => 'إندونيسي';

  @override
  String get cuisineWestern => 'غربي / متوسطي';

  @override
  String dietProgramFitReason(String reason) {
    return 'مناسب لهدفك: $reason';
  }

  @override
  String get exerciseMusclesTargeted => 'العضلات المستهدفة';

  @override
  String get exerciseStepsTitle => 'طريقة الأداء خطوة بخطوة';

  @override
  String get exerciseCommonMistakes => 'أخطاء شائعة';

  @override
  String get exerciseBreathingCue => 'التنفس أثناء الحركة';

  @override
  String get exerciseEasierVariation => 'تدرج أسهل';

  @override
  String get exerciseHarderVariation => 'تدرج أصعب';

  @override
  String get exerciseSafetyNote => 'تعليمات الأمان';

  @override
  String get exerciseWarmUpHeader => 'حركات الإحماء';

  @override
  String get reassessmentLaterSnooze => 'لاحقاً (تذكير بعد 3 أيام)';

  @override
  String get measurementsAddEntry => 'سجّل قياس جديد';

  @override
  String get walkingStopSessionTitle => 'إيقاف جولة المشي؟';

  @override
  String get walkingStopSessionDesc =>
      'هل ترغب في حفظ أو إنهاء جولة المشي الحالية؟';

  @override
  String get walkingSessionContinue => 'استمرار';

  @override
  String get walkingSessionEnd => 'إنهاء الجولة';

  @override
  String get walkingEditGoalTitle => 'تعديل هدف الخطوات اليومي';

  @override
  String get walkingTargetStepsLabel => 'عدد الخطوات المستهدف';

  @override
  String get walkingStepsSuffix => 'خطوة';

  @override
  String get walkingScreenTitle => 'المشي والنشاط';

  @override
  String get walkingDiagnosticsTooltip => 'تشخيص الخطوات';

  @override
  String get walkingRefreshTooltip => 'تحديث';

  @override
  String get walkingStartGps => 'ابدأ GPS';

  @override
  String get walkingActivityHistory => 'سجل الحركة والخطوات';

  @override
  String get walkingFilterDay => 'اليوم';

  @override
  String get walkingFilterWeek => 'أسبوع';

  @override
  String get walkingFilterMonth => 'شهر';

  @override
  String get walkingAchievementsTitle => 'الإنجازات والأرقام القياسية 🏆';

  @override
  String get stepToggleError =>
      'تعذر تغيير حالة عداد الخطوات، يرجى المحاولة مرة أخرى';

  @override
  String get scoreInsightsTitle => 'السكور والتوقعات الذكية 🎯';

  @override
  String scoreInsightsTodaySummary(int eaten, int target) {
    return 'اليوم: تناولت $eaten من $target سعرة';
  }

  @override
  String scoreInsightsWeekFatSummary(int grams) {
    return 'هذا الأسبوع: خسرت ≈ $grams جم دهون';
  }

  @override
  String scoreInsightsGoalWeeksSummary(String weeks) {
    return 'ستصل لهدفك خلال ≈ $weeks أسابيع';
  }

  @override
  String get scoreInsightsActionLogProtein => 'سجّل وجبة غنية بالبروتين';

  @override
  String get scoreInsightsActionWalk => 'ابدأ المشي وأكمل خطواتك';

  @override
  String get scoreInsightsActionWater => 'اشرب كوب ماء الآن';

  @override
  String get scoreInsightsPredictionsTitle => 'توقعات ذكية (تقديري 🔮)';

  @override
  String get scoreInsightsPredictionsSubtitle =>
      'مبنية على عجز السعرات ومعدل الحرق';

  @override
  String scoreInsightsNeedData(int days) {
    return 'نحتاج إلى 3 أيام من البيانات لدقة التوقع (سجلت $days يوم)';
  }

  @override
  String get scoreInsightsWeeklyFatLoss => 'دهون مفقودة أسبوعياً';

  @override
  String get scoreInsightsIn4Weeks => 'بعد 4 أسابيع';

  @override
  String get scoreInsightsIn8Weeks => 'بعد 8 أسابيع';

  @override
  String get scoreInsightsGoalHitIn => 'الوصول للهدف في';

  @override
  String get scoreInsightsClampWarning =>
      '⚠️ تم ضبط معدل النزول بما لا يتعدى 1% من وزن الجسم أسبوعياً لحماية صحتك وعضلاتك.';

  @override
  String get scoreInsightsAggressiveDeficitWarning =>
      '⚠️ عجز السعرات أعلى من 1,000 سعرة/يوم. ننصح بزيادة السعرات قليلاً لتجنب تباطؤ الحرق.';

  @override
  String get scoreInsightsHowCalculatedTitle =>
      'كيف تم الحساب؟ (معادلة Mifflin-St Jeor)';

  @override
  String scoreInsightsHowCalculatedBmr(String bmr) {
    return '• معدل الأيض الأساسي (BMR): $bmr سعرة';
  }

  @override
  String scoreInsightsHowCalculatedTdee(String tdee) {
    return '• معدل الحرق اليومي الكامل (TDEE): $tdee سعرة';
  }

  @override
  String get scoreInsightsHowCalculatedFat =>
      '• كل 7,700 سعرة عجز تساوي حرق 1 كجم من دهون الجسم تقريباً.';

  @override
  String get scoreInsightsBodyCompTitle => 'تحليل وتركيب الجسم';

  @override
  String get scoreInsightsBodyCompNewMeasure => 'قياس جديد';

  @override
  String get scoreInsightsBodyCompPrompt =>
      'اعرف نسبة الدهون وعضلاتك بالمازورة أو InBody';

  @override
  String get scoreInsightsEnergyBalanceTitle =>
      'توازن الطاقة (المأكول مقابل المحروق)';

  @override
  String get scoreInsightsEatenKcal => 'سعرات أكل';

  @override
  String get scoreInsightsBurnedKcal => 'حرق ونشاط';

  @override
  String get scoreInsightsMacrosTitle =>
      'توزيع الماكروز اليوم (الهدف vs المأكول)';

  @override
  String get scoreInsightsScoreTrendTitle => 'مسار السكور خلال 7 أيام';

  @override
  String get scoreInsightsImmediateActionsTitle =>
      'نصائح وإجراءات فورية لرفع السكور:';

  @override
  String stepMilestoneToast25(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'بداية قوية يا بطلة 👏',
      'other': 'بداية قوية يا بطل 👏',
    });
    return '$_temp0';
  }

  @override
  String stepMilestoneToast50(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'نص المشوار يا بطلة 💪',
      'other': 'نص المشوار يا بطل 💪',
    });
    return '$_temp0';
  }

  @override
  String stepMilestoneToast75(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'قرّبتِ توصلي يا بطلة 🔥',
      'other': 'قرّبت توصل يا بطل 🔥',
    });
    return '$_temp0';
  }

  @override
  String stepMilestoneToast100(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'عاش يا بطلة! كملتي هدفك 🏆',
      'other': 'عاش يا وحش! كملت هدفك 🏆',
    });
    return '$_temp0';
  }

  @override
  String get livingBackgroundsTitle => 'خلفيات متغيرة';

  @override
  String get livingBackgroundsSubtitle =>
      'مشاهد تتطور مع خطواتك وتتغير كل 3 أيام';

  @override
  String get livingBackgroundsEnable => 'تفعيل الخلفيات التفاعلية';

  @override
  String get livingBackgroundsSceneLock => 'تثبيت المشهد';

  @override
  String get livingBackgroundsAutoRotate => 'تغيير تلقائي كل 3 أيام';

  @override
  String get livingBackgroundsPreview => 'معاينة حية للمشهد';

  @override
  String livingBackgroundsUnlockForCoins(int coins) {
    return 'فتح بـ $coins نقطة';
  }

  @override
  String get livingBackgroundsUnlocked => 'تم الفتح';

  @override
  String get workoutRpeSubtitle =>
      'حسّيت بالمجهود قد إيه؟ من 1 (سهل جداً) لـ 10 (صعب جداً)';

  @override
  String workoutRpeLabel(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      '1': 'سهل جداً',
      '2': 'سهل',
      '3': 'سهل نسبياً',
      '4': 'خفيف',
      '5': 'متوسط',
      '6': 'شوية صعب',
      '7': 'تقيل',
      '8': 'صعب',
      '9': 'صعب أوي',
      'other': 'صعب جداً',
    });
    return '$_temp0';
  }

  @override
  String get workoutRpeFeelingsTitle => 'إحساسك بعد التمرين إيه؟';

  @override
  String get workoutFeelTired => 'تعب';

  @override
  String get workoutFeelJointPain => 'ألم في مفصل';

  @override
  String workoutFeelHappy(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'مبسوطة',
      'other': 'مبسوط',
    });
    return '$_temp0';
  }

  @override
  String get workoutFeelEnergized => 'طاقة عالية';

  @override
  String get workoutRpeNoteHint => 'اكتب ملاحظة (اختياري)';

  @override
  String get workoutRpeSave => 'احفظ';

  @override
  String get workoutRpeDone => 'تمام';

  @override
  String get workoutRpeSavedTitle => 'اتحفظ ✅';

  @override
  String get workoutRpeCommentJoint =>
      'ألم المفصل إشارة لازم نحترمها. خفّف الحمل في الجلسة الجاية وركّز على سلامة الحركة.';

  @override
  String get workoutRpeCommentHard =>
      'التمرين كان تقيل النهاردة. هنخفّف الحمل شوية المرة الجاية عشان جسمك يتعافى كويس.';

  @override
  String get workoutRpeCommentBetter =>
      'أداءك أحسن! نفس التمرين حسّيته أخف من المرة اللي فاتت 💪';

  @override
  String get workoutRpeCommentEasy =>
      'حسّيته سهل. الجلسة الجاية هنزوّد الحمل شوية.';

  @override
  String get workoutRpeCommentSteady => 'مجهود مظبوط. كمّل على نفس الإيقاع.';

  @override
  String get workoutRpeCommentPartial =>
      'اللي عملته من المجموعات محسوب وبيفرق. هنرجع أقوى في الجلسة الجاية.';

  @override
  String get foodFactCardTitle => 'حقيقة عن أكلك';

  @override
  String get foodFactShareHint => 'اضغط لمشاركة البطاقة';

  @override
  String get ramadanGuideTitle => 'دليل رمضان';

  @override
  String get ramadanGuideOpenHint =>
      'ترتيب السحور وإيقاع الإفطار — اضغط للتفاصيل';

  @override
  String get ramadanSuhoorRankTitle =>
      'ترتيب شبع السحور (بروتين + ألياف من قاعدة البيانات)';

  @override
  String ramadanSuhoorRankSubtitle(int grams, int kcal) {
    return 'حصة مثال $grams جم · ≈ $kcal سعرة';
  }

  @override
  String get ramadanIftarPaceTitle => 'إيقاع الإفطار';

  @override
  String get ramadanIftarStep1 => 'تمر + مية الأول';

  @override
  String get ramadanIftarStep2 => 'شوربة دافية';

  @override
  String get ramadanIftarStep3 => 'استنى 15 دقيقة';

  @override
  String get ramadanIftarStep4 => 'الطبق الرئيسي';

  @override
  String get ramadanReboundTitle => 'بعد رمضان';

  @override
  String ramadanReboundBody(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female':
          'ارجعي للروتين براحة: خلّي السحور فيه بروتين، سجّلي الإفطار من غير لوم، وزوّدي 10 دقائق مشي لمدة أسبوع قبل أي تخفيض كبير في السعرات.',
      'other':
          'ارجع للروتين براحة: خلّي السحور فيه بروتين، سجّل الإفطار من غير لوم، وزوّد 10 دقائق مشي لمدة أسبوع قبل أي تخفيض كبير في السعرات.',
    });
    return '$_temp0';
  }

  @override
  String get settingsMySubscription => 'اشتراكي';

  @override
  String get settingsMySubscriptionBody =>
      'تقدر تلغي أو تغيّر خطتك في أي وقت من Google Play — من غير مكالمات ولا خطوات مخفية.';

  @override
  String get weeklyBurnShareTitle => 'رصيد حرقك الأسبوع ده';

  @override
  String get weeklyBurnShareSubtitle => 'شارك خطواتك واستمراريتك';

  @override
  String get weeklyBurnShareCaption => 'رصيد حرقي الأسبوع ده مع ڤيريو';

  @override
  String get weeklyBurnShareAction => 'شارك بطاقة الأسبوع';

  @override
  String get weeklyBurnShareIncludeWeight => 'إظهار تغيّر الوزن في البطاقة';

  @override
  String get weeklyBurnShareStepsLabel => 'خطوات الأسبوع';

  @override
  String get weeklyBurnShareStreakLabel => 'الاستمرارية';

  @override
  String get weeklyBurnShareWeightLabel => 'تغيّر الوزن';

  @override
  String get widgetCaloriesLeftLabel => 'سعرات فاضلة';

  @override
  String get scanLimitTitle => 'خلصت تحليلات الصور النهارده';

  @override
  String get scanLimitBody =>
      'تحليل الصور بيستخدم خوادم. استنى لبكرة، أو Pro، أو سجّل يدوي — على مزاجك.';

  @override
  String get scanLimitProTitle => 'ڤيريو Pro';

  @override
  String get scanLimitProSubtitle =>
      'مسح ذكي غير محدود (40/يوم استخدام عادل)، بدون إعلانات، وكل البرامج';

  @override
  String get scanLimitProCta => 'اشتراك Pro';

  @override
  String get scanLimitWaitTitle => 'استنى لبكرة';

  @override
  String get scanLimitWaitSubtitle =>
      'التحليلات المجانية بتتجدد مع منتصف الليل — الكتابة والباركود لسه مفتوحين';

  @override
  String get scanLimitWaitCta => 'تمام، نشوف بكرة';

  @override
  String get scanLimitManualTitle => 'بحث وتسجيل يدوي';

  @override
  String get scanLimitManualSubtitle => 'مجاني وغير محدود دايماً';

  @override
  String get scanLimitManualCta => 'تسجيل يدوي';

  @override
  String get scanLimitAdRewardSnack => 'اتضاف +2 تحليلات للنهارده';

  @override
  String get scanLimitAdFailedSnack =>
      'مقدرناش نحمّل الإعلان — جرّب تاني بعد شوية';

  @override
  String get rebalanceCardTitle => 'تظبيط يومك';

  @override
  String get rebalanceSafeDay => 'عادي — يومك لسه في الأمان';

  @override
  String get rebalanceNeedsTap => 'مفيش تغيير غير لما تختار';

  @override
  String get weeklyBalanceTitle => 'ميزان الأسبوع';

  @override
  String get weeklyBalanceEmpty => 'سجّل كام يوم عشان نشوف ميزان الأسبوع';

  @override
  String weeklyBalanceOnTrack(int actual, int target) {
    return 'لسه في الهدف: عجز أسبوعي $actual من $target';
  }

  @override
  String weeklyBalanceOffTrack(int actual, int target) {
    return 'الأسبوع ده: عجز $actual من $target — نقدر نعدّل';
  }

  @override
  String weeklyBalanceCumulative(int kcal) {
    return 'التراكمي: $kcal سعرة';
  }

  @override
  String get energyLedgerTitle => 'رصيد حرقك';

  @override
  String get energyLedgerToday => 'اليوم';

  @override
  String get energyLedgerWeek => 'الأسبوع';

  @override
  String get energyLedgerMonth => 'الشهر';

  @override
  String get energyLedgerAllTime => 'من أول يوم';

  @override
  String energyLedgerBurned(int kcal, String fatKg) {
    return 'حرقت $kcal سعرة ≈ $fatKg كجم دهون';
  }

  @override
  String get energyLedgerBalanceNote =>
      'سعرات النشاط وتقدير الدهون من الرصيد منفصلين (تقديري)';

  @override
  String energyLedgerStepsDistance(int steps, String km) {
    return '$steps خطوة · $km كم';
  }

  @override
  String get fingerprintTitle => 'بصمتك — نظام Vireo الذكي';

  @override
  String get fingerprintSubtitle => 'اتعلمت من عاداتك الحقيقية بعد ١٤ يوم';

  @override
  String get fingerprintReset => 'ارجّع الافتراضي';

  @override
  String get fingerprintActivity => 'نشاطك';

  @override
  String get fingerprintNutrition => 'أكلك';

  @override
  String get fingerprintTolerance => 'تحمّلك';

  @override
  String get fingerprintChronotype => 'مواعيدك';

  @override
  String get fingerprintStepsUnit => 'خطوة مريحة';

  @override
  String fingerprintMealsCount(int count) {
    return '$count وجبات / يوم';
  }

  @override
  String fingerprintDeficitValue(int kcal) {
    return 'عجز تتحمّله ≈ $kcal سعرة';
  }

  @override
  String fingerprintLogHour(int hour) {
    return 'بتسجّل عادة حوالي الساعة $hour';
  }

  @override
  String get fingerprintActivityWhy => 'ليه؟ متوسط أحسن ٧٠٪ من أيام خطواتك';

  @override
  String get fingerprintNutritionWhy => 'ليه؟ من مواعيد وجباتك وأكلك المفضّل';

  @override
  String get fingerprintToleranceWhy => 'ليه؟ العجز اللي بتكمله من غير ارتداد';

  @override
  String get fingerprintChronotypeWhy => 'ليه؟ من مواعيد التسجيل والمشي';

  @override
  String get fingerprintEdit => 'عدّلها';

  @override
  String fingerprintNotReady(int days) {
    return 'لسه بنتعلّم — $days/١٤ يوم';
  }

  @override
  String get strideCalibratedBadge => 'مُعايَر على مشيك ✓';

  @override
  String stepSourceLabel(String source) {
    return 'المصدر: $source';
  }

  @override
  String get stepSourcePedometer => 'حساس الموبايل';

  @override
  String get stepSourceHealth => 'الصحة';

  @override
  String get stepSourceManual => 'يدوي';

  @override
  String get stepSourceNone => 'غير متاح';

  @override
  String get eatBackSettingTitle => 'استرجاع سعرات التمرين';

  @override
  String get eatBackHalf => '٥٠٪ (افتراضي)';

  @override
  String get eatBackFull => '١٠٠٪';

  @override
  String get eatBackNone => '٠٪';

  @override
  String get tdeeCheckInTitle => 'خطتك اتعدلت';

  @override
  String get tdeeCheckInUndo => 'تراجع';

  @override
  String get missedStepsCardTitle => 'خطوات امبارح';

  @override
  String get outdoorNetKcalLabel => 'صافي سعرات';

  @override
  String get outdoorCadenceLabel => 'إيقاع الخطوة';

  @override
  String get weeklyReviewTitle => 'مراجعة الأسبوع';

  @override
  String get adaptiveTdeeBlendNote => 'مزيج من تسجيلك + المعادلة';
}

/// The translations for Arabic, as used in Egypt (`ar_EG`).
class AppLocalizationsArEg extends AppLocalizationsAr {
  AppLocalizationsArEg() : super('ar_EG');

  @override
  String get continueButton => 'يلا بينا';

  @override
  String get skipButton => 'عدّيها';

  @override
  String get finishButton => 'خلّصنا';

  @override
  String get yesButton => 'أيوه';

  @override
  String get noButton => 'لأ';

  @override
  String get authWelcomeTitle => 'أهلاً بيك في ڤيريو!';

  @override
  String get authWelcomeSubtitle => 'رحلتك لجسم أصح ولياقة أعلى بتبدأ هنا.';

  @override
  String get workoutFinishCoolDown => 'عاش.. ننهي التمرين';

  @override
  String get workoutStartButton => 'يلا نتمرن';

  @override
  String get workoutSwapEmpty => 'مفيش تمارين بديلة دلوقتي';

  @override
  String get workoutEmptyProgram =>
      'مفيش تمرين متسجل النهاردة.. ريّح واستعد للجي!';

  @override
  String get paywallPlanMonthly => 'شهري';

  @override
  String get paywallPlanAnnual => 'سنوي';

  @override
  String get paywallFeatureUnlimitedScans => 'مسح غير محدود للوجبات بالكاميرا';

  @override
  String homeGreeting(String name) {
    return 'منوّر يا $name 👋';
  }

  @override
  String homeStreakDays(int days) {
    return '$days أيام ورا بعض.. عاش يا بطل!';
  }

  @override
  String get homeStartStreak => 'ابدأ سلسلتك النهاردة وعاش!';

  @override
  String get habitsEmpty => 'لسه ما ضفتش عادات.. ابدأ بعادة بسيطة النهاردة!';

  @override
  String uxGoodMorning(String name) {
    return 'صباح الفل يا $name';
  }

  @override
  String uxGoodAfternoon(String name) {
    return 'مساء الفل يا $name';
  }

  @override
  String uxGoodEvening(String name) {
    return 'مساء الورد يا $name';
  }

  @override
  String get uxActionCoach => 'الكابتن';

  @override
  String get uxLogEmptyTitle => 'لسه ما سجلتش أكل النهاردة';

  @override
  String get uxLogEmptyBody =>
      'صوّر وجبتك والذكاء الاصطناعي هيحسب السعرات والماكروز في ثانية.';

  @override
  String get uxRestDayHint =>
      'الراحة جزء من التمرين.. امشِ شوية، اعمل استطالة، وكمّل بروتينك.';

  @override
  String get uxWaterGoalDone => 'قفلت هدف المية 💧 عاش يا بطل!';

  @override
  String get uxQuickCoach => 'اسأل كابتنك';

  @override
  String get uxQuickCoachSub => 'نصيحة ذكية وسريعة ليك';

  @override
  String get uxCoachOnline => 'أونلاين · وحافظ أرقامك';

  @override
  String get uxCoachTyping => 'بيكتب لك…';

  @override
  String get uxCoachHeroTitle => 'كابتنك الذكي معاك خطوة بخطوة';

  @override
  String get uxCoachHeroBody =>
      'اسأل عن الأكل، البروتين، الحلويات أو التمرين.. كل إجابة على قد أرقامك النهاردة.';

  @override
  String get uxCoachChipWorkout => 'آكل إيه قبل التمرين؟';

  @override
  String get measurementsNoData =>
      'لسه ما سجلتش مقاسات.. ابدأ أول قياس النهاردة!';

  @override
  String get vitalityCheckProtein => 'كمّل هدف البروتين';

  @override
  String get vitalityCheckSleep => 'نوم مريح وكفاية';

  @override
  String get vitalityCheckSunlight => 'شمس الصبح';

  @override
  String get vitalityProgramStartCta => 'يلا نبدأ البرنامج';

  @override
  String get dietQuizContinue => 'فاهم.. يلا نكمل';

  @override
  String get dietQuizYes => 'أيوه';

  @override
  String get dietQuizNo => 'لأ';

  @override
  String get dietPrefSkipBreakfast => 'تقدر تعدّي الفطار من غير ما تتعب؟';

  @override
  String get dietStartProgram => 'يلا نبدأ البرنامج ده';

  @override
  String get todayPlanVitalitySleepSubtitle => 'سجّل 7.5+ ساعات في الحيوية';

  @override
  String get todayPlanProtocolItem => 'بروتوكول الحيوية';

  @override
  String get outdoorHistoryEmpty =>
      'لسه ما نزلتش تمرين بره.. يلا جرّب أول جولة!';

  @override
  String get mealReviewEstimated => 'تقديري';

  @override
  String mealReviewKcalApprox(int count) {
    return '≈ $count سعرة';
  }

  @override
  String get mealReviewPortionLabel => 'الحصة';

  @override
  String get mealReviewOilPrefix => 'زيت:';

  @override
  String get mealReviewOilLight => 'خفيف';

  @override
  String get mealReviewOilNormal => 'عادي';

  @override
  String get mealReviewOilHeavy => 'مسبّك';

  @override
  String get mealReviewFamilyPlateToggle => 'أكلنا من طبق واحد';

  @override
  String get mealReviewMyShare => 'نصيبي';

  @override
  String get ramadanWaterTrackerQuestion =>
      'شربت كام كوباية من الإفطار للسحور؟';

  @override
  String ramadanWaterGoalSplit(int iftarCups, int eveningCups, int suhoorCups) {
    return 'هدف الإفطار: $iftarCups · الليل: $eveningCups · السحور: $suhoorCups كوب';
  }

  @override
  String get ramadanPrayerCityPickerTitle => 'اختار مدينة المواعيد';

  @override
  String get ramadanPrayerCityCustom => 'مدينة تانية';

  @override
  String get ramadanCustomCityName => 'اسم المدينة';

  @override
  String get ramadanCustomCityLat => 'خط العرض';

  @override
  String get ramadanCustomCityLng => 'خط الطول';

  @override
  String get notificationPostScanTitle => 'عايزني أفكرك بالوجبات؟';

  @override
  String get notificationPostScanBody =>
      'تذكيرات لطيفة بمواعيد الغدا والعشا — مرتين في اليوم بس، ومفيش إزعاج من ١١ بالليل لـ ٧ الصبح.';

  @override
  String get notificationPostScanYes => 'أيوه، فكّرني';

  @override
  String get notificationPostScanNotNow => 'مش دلوقتي';

  @override
  String get mealScanHintLabel => 'زوّد كلمتين لو حابب (اختياري)';

  @override
  String get mealScanHintPlaceholder => 'فيها زيت؟ صوص؟ نوع العيش؟';

  @override
  String get inbodyEmpty => 'لسه مفيش تقارير.. صوّر ورقة InBody ويلا بينا!';

  @override
  String get mealFavoritesTitle => 'وجباتي';

  @override
  String get mealRecentTitle => 'آخر حاجات';

  @override
  String get celebrationWaterTitle => 'عاش! قفلت هدف المية النهاردة 💧';

  @override
  String get celebrationProteinTitle => 'عاش يا وحش! قفلت هدف البروتين 💪';

  @override
  String get celebrationStepsTitle => 'عاش! كمّلت خطواتك النهاردة كلها 🏃';

  @override
  String get celebrationWorkoutTitle =>
      'عاش يا بطل! خلّصت تمرينك النهاردة بنجاح 🔥';

  @override
  String fatEquivalentBurned(String amount) {
    return 'حرقت ما يعادل ≈ $amount دهون 🔥';
  }

  @override
  String fatEquivalentTodayDeficit(String amount) {
    return 'عجز النهاردة ≈ $amount دهون 🔥';
  }

  @override
  String fatEquivalentThisWeek(String amount) {
    return '≈ $amount دهون الأسبوع ده 🔥';
  }

  @override
  String get legalTerms => 'الشروط';

  @override
  String get legalPrivacy => 'الخصوصية';

  @override
  String get legalMedicalDisclaimer => 'إخلاء المسؤولية الطبية';

  @override
  String get welcomeTagline => 'تغذية ذكية وتمرين مظبوط متفصلين مخصوص للرجالة.';

  @override
  String get welcomePillarScannerTitle => 'مسح فوري للطبق';

  @override
  String get welcomePillarScannerDesc =>
      'صوّر وجبتك، واعرف السعرات والبروتين في ثانيتين';

  @override
  String get welcomePillarPlanTitle => 'خطة يومية متفصلة ليك';

  @override
  String get welcomePillarPlanDesc => 'أرقام علمية مدروسة على قد جسمك وهدفك';

  @override
  String get welcomePillarSafetyTitle => 'تغذية آمنة وصحية 100%';

  @override
  String get welcomePillarSafetyDesc => 'توجيهات تحافظ على حرقك وصحتك العامة';

  @override
  String get onboardingGoalTitle => 'إيه هو هدفك الأساسي؟';

  @override
  String get onboardingGoalSubtitle =>
      'اختار الأهم بالنسبة لك، وهنظبط أرقامك اليومية عليه.';

  @override
  String get goalLoseFatTitle => 'حرق وتنزيل الدهون';

  @override
  String get goalLoseFatSubtitle => 'احرق الدهون العنيدة مع الحفاظ على عضلاتك';

  @override
  String get goalBuildMuscleTitle => 'بناء وزيادة العضلات';

  @override
  String get goalBuildMuscleSubtitle =>
      'زوّد حجم عضلاتك ببروتين مظبوط وزيادة أوزان ذكية';

  @override
  String get goalMoreEnergyTitle => 'طاقة ونشاط أعلى';

  @override
  String get goalMoreEnergySubtitle =>
      'خلّص على كسل نص اليوم وزوّد نشاطك ولياقتك';

  @override
  String get goalAllOfAboveTitle => 'كل اللي فات مع بعض';

  @override
  String get goalAllOfAboveSubtitle =>
      'إعادة تشكيل شاملة لجسمك: نزول دهون، زيادة قوة، ونشاط عالي';

  @override
  String get onboardingBodyTitle => 'بيانات جسمك';

  @override
  String get onboardingBodySubtitle =>
      'أرقامك المظبوطة بتخلينا نحسب حرقك واحتياجك اليومي بدقة.';

  @override
  String get sexMale => 'راجل';

  @override
  String get sexFemale => 'ست';

  @override
  String get unitMetric => 'متري';

  @override
  String get unitImperial => 'باوند';

  @override
  String get bodyMetricAge => 'السن';

  @override
  String bodyMetricYears(int age) {
    return '$age سنة';
  }

  @override
  String get selectAgeTitle => 'اختار سنك';

  @override
  String ageYearsSuffix(int age) {
    return '$age سنة';
  }

  @override
  String get bodyMetricHeight => 'الطول';

  @override
  String get selectHeightTitle => 'اختار طولك';

  @override
  String get bodyMetricCurrentWeight => 'وزنك الحالي';

  @override
  String get selectCurrentWeightTitle => 'اختار وزنك الحالي';

  @override
  String get bodyMetricTargetWeight => 'الوزن المستهدف';

  @override
  String get selectTargetWeightTitle => 'اختار وزنك المستهدف';

  @override
  String get pickerDone => 'تمام';

  @override
  String get onboardingActivityTitle => 'نشاطك ومكان تمرينك';

  @override
  String get onboardingActivitySubtitle =>
      'بنحسب حرق سعراتك ونرشح لك أنسب تمارين.';

  @override
  String get dailyActivityLevelHeader => 'مستوى حركتك اليومية';

  @override
  String get activitySedentaryTitle => 'قليل الحركة / شغل مكتب';

  @override
  String get activitySedentarySubtitle =>
      'حركة قليلة وشغل مكتبي، أقل من 5,000 خطوة';

  @override
  String get activityModeratelyActiveTitle => 'حركة متوسطة';

  @override
  String get activityModeratelyActiveSubtitle =>
      'بتتحرك بانتظام، من 6,000 لـ 10,000 خطوة يومياً';

  @override
  String get activityVeryActiveTitle => 'حركة عالية جداً / شغل بدني';

  @override
  String get activityVeryActiveSubtitle =>
      'حركة مستمرة أو أكتر من 12,000 خطوة يومياً';

  @override
  String get trainingPlaceHeader => 'ناوي تتمرن فين؟';

  @override
  String get trainingPlaceGymTitle => 'الجيم';

  @override
  String get trainingPlaceGymSubtitle => 'أجهزة وأوزان وبارات متكاملة';

  @override
  String get trainingPlaceHomeTitle => 'في البيت';

  @override
  String get trainingPlaceHomeSubtitle =>
      'وزن الجسم، أستك مقاومة، أو دمبل خفيف';

  @override
  String get trainingPlaceWalkingTitle => 'مشي بس';

  @override
  String get trainingPlaceWalkingSubtitle =>
      'خطوات وتمارين مشي في الهواء الطلق';

  @override
  String get onboardingHealthSafetyTitle => 'فحص السلامة الصحية';

  @override
  String get onboardingHealthSafetySubtitle =>
      'علّم على أي حالة عندك عشان نظبط لك خطة آمنة تماماً لصحتك.';

  @override
  String get healthSafetyNoneApply => 'معنديش أي حاجة من دول';

  @override
  String get healthSafetyOrSelect => 'أو علّم على اللي عندك';

  @override
  String get onboardingTryScanTitle => 'جرّب مسح الوجبات الذكي';

  @override
  String get onboardingTryScanSubtitle =>
      'شوف إزاي ڤيريو بيحسب السعرات والماكروز في ثواني.';

  @override
  String get tryScanSamplePlateTitle => 'نموذج طبق عالي البروتين';

  @override
  String get tryScanSamplePlateDesc => 'فراخ مشوية، رز أبيض مصري، وسلطة بلدي';

  @override
  String get tryScanAnalyzing => 'بنحلل الطبق...';

  @override
  String get tryScanSampleCta => 'امسح الطبق ده (تجربة فورية)';

  @override
  String get tryScanOrTestLive => 'أو جرّب على أكلك الحقيقي';

  @override
  String get tryScanOwnMealTitle => 'صوّر وجبتك دلوقتي';

  @override
  String get tryScanOwnMealDesc => 'خد صورة حية للطبق اللي قدامك';

  @override
  String get onboardingPlanRevealTitle => 'خطتك المتفصلة ليك';

  @override
  String get onboardingPlanRevealSubtitle =>
      'متصممة مخصوص لجسمك وهدفك ومعدل حرقك.';

  @override
  String get planRevealStartPlan => 'يلا نبدأ الخطة';

  @override
  String get planRevealProjectedPace => 'المعدل المتوقع';

  @override
  String get planRevealSteadyRecomp => 'إعادة تشكيل وتناسق للجسم بثبات';

  @override
  String planRevealFatLossPace(String amount) {
    return 'نزول ≈ $amount كجم دهون في الأسبوع';
  }

  @override
  String planRevealLeanMassPace(String amount) {
    return 'زيادة ≈ $amount كجم عضلات في الأسبوع';
  }

  @override
  String get planRevealDailyCalories => 'هدفك اليومي من السعرات';

  @override
  String get planRevealPersonalizedBadge => 'مخصوص ليك';

  @override
  String get planRevealKcalPerDay => 'سعرة / يوم';

  @override
  String get planRevealDailyProtein => 'البروتين اليومي';

  @override
  String get planRevealGramPerDay => 'جم / يوم';

  @override
  String get planRevealHydration => 'شرب المية';

  @override
  String get planRevealDailySteps => 'الخطوات اليومية';

  @override
  String get planRevealStepsPerDay => 'خطوة / يوم';

  @override
  String get planRevealDietProtocol => 'نظام الدايت';

  @override
  String get planRevealOptimalMatch => 'أنسب خطة لجسمك';

  @override
  String get planRevealBalancedPlanDefault => 'خطة العجز المتوازن';

  @override
  String get onboardingNotificationsTitle => 'مش هتفوّت ولا هدف';

  @override
  String get onboardingNotificationsSubtitle =>
      'تنبيهات خفيفة تساعدك تسجل أكلك، تشرب ميتك، وتلتزم بتمرينك.';

  @override
  String get notificationsHeroTitle => 'عشان تلتزم.. مش عشان نزعجك';

  @override
  String get notificationsHeroBody =>
      'اللي بيفعّلوا التنبيهات فرصتهم أعلى بـ 3.4 أضعاف يوصلوا لوزنهم المثالي ويثبتوا عليه.';

  @override
  String get notificationsMealLoggingTitle => 'تسجيل الوجبات';

  @override
  String get notificationsMealLoggingDesc => 'تذكير في ميعاد الغدا والعشا';

  @override
  String get notificationsWorkoutSessionTitle => 'تمرينك اليومي';

  @override
  String get notificationsWorkoutSessionDesc =>
      'عشان تفضل ملتزم بمواعيد تمرينك';

  @override
  String get notificationsWeeklyReviewTitle => 'مراجعة التقدم الأسبوعية';

  @override
  String get notificationsWeeklyReviewDesc =>
      'قياس الوزن كل أسبوع وتعديل الأرقام';

  @override
  String get notificationsEnableButton => 'تفعيل التنبيهات';

  @override
  String get notificationsMaybeLater => 'ممكن بعدين';

  @override
  String get onboardingPaywallTitle => 'سرّع نتايجك';

  @override
  String get onboardingPaywallSubtitle =>
      'امسح وجبات من غير حدود، مع برامج تمرين ذكية وإحصائيات متقدمة.';

  @override
  String get paywallProBadge => 'ڤيريو برو';

  @override
  String get paywallFeatureUnlimitedScansDesc => 'من غير أي حدود يومية';

  @override
  String get paywallFeatureSmartSub => 'بدائل ذكية للأكلات العربية والمصرية';

  @override
  String get paywallFeatureSmartSubDesc =>
      'أكلات متوافقة مع الدايت من غير حرمان';

  @override
  String get paywallFeatureAdaptiveSplits => 'جداول تمرين مرنة بتتطور معاك';

  @override
  String get paywallFeatureAdaptiveSplitsDesc =>
      'متابعة زيادة الأوزان في الجيم أو البيت';

  @override
  String get paywallPlanAnnualPrice => '\$4.99 / شهرياً';

  @override
  String get paywallPlanAnnualSubtext => 'اشتراك سنوي (وفّر 50%)';

  @override
  String get paywallBadgeBestValue => 'أفضل توفير';

  @override
  String get paywallPlanMonthlyPrice => '\$9.99 / شهرياً';

  @override
  String get paywallPlanMonthlySubtext => 'اشتراك شهري';

  @override
  String get paywallStartTrialCta => 'ابدأ التجربة المجانية 7 أيام';

  @override
  String get paywallContinueFreeTier => 'كمّل بالباقة المجانية';

  @override
  String get appInitErrorFailed => 'حصل خطأ في تشغيل خدمات التطبيق.';

  @override
  String get appInitRetry => 'جرّب تاني';

  @override
  String get privacyExportTitle => 'تصدير بياناتي';

  @override
  String get privacyExportReady => 'ملف بياناتك جاهز بصيغة JSON و CSV:';

  @override
  String get weeklyProgressShareFailed => 'معرفناش نعمل صورة المشاركة';

  @override
  String get adaptiveCalorieCurrentTarget => 'الهدف الحالي';

  @override
  String get adaptiveCalorieSuggestedTarget => 'الهدف المقترح';

  @override
  String get adaptiveCalorieWindowSpan => 'المدة الزمنية';

  @override
  String get adaptiveCalorieFoodLogsCount => 'أيام تسجيل الأكل';

  @override
  String get adaptiveCalorieWeighInsCount => 'مرات وزن نفسك';

  @override
  String get adaptiveCalorieAverageIntake => 'متوسط سعرات أكلك';

  @override
  String get adaptiveCalorieTrendWeightChange => 'تغيّر اتجاه الوزن';

  @override
  String get adaptiveCalorieEstimatedMaintenance => 'سعرات الثبات التقديرية';

  @override
  String get adaptiveCalorieWeeklyChangeCap => 'الحد الأقصى للتغيير الأسبوعي';

  @override
  String get adaptiveCalorieSafetyFloorApplied => 'الحد الأدنى الآمن مطبق';

  @override
  String get chartSevenDayTrend => 'اتجاه 7 أيام';

  @override
  String get chartThirtyDayTrend => 'اتجاه 30 يوم';

  @override
  String get chartRawDot => 'قياس يومي';

  @override
  String get chartTrendLine => 'خط الاتجاه';

  @override
  String get chartGoalLine => 'خط الهدف';

  @override
  String get scanSourceSheetTitle => 'هتسجل الأكل إزاي؟';

  @override
  String get scanSourceCamera => 'صوّر بالكاميرا';

  @override
  String get scanSourceGallery => 'اختار من الاستوديو';

  @override
  String get scanSourceText => 'اكتب الأكل';

  @override
  String get scanSourceFridgeTitle => 'صوّر التلاجة أو المطبخ';

  @override
  String get scanSourceInBodyTitle => 'ارفع ورقة الإن بادي';

  @override
  String get todayPlanMorning => 'صباحاً';

  @override
  String get todayPlanAfternoon => 'الظهر';

  @override
  String get todayPlanEvening => 'المساء';

  @override
  String get todayPlanWaterQuickAdd => '+250 مل';

  @override
  String todayPlanWaterProgress(String current, String goal) {
    return '$current / $goal لتر';
  }

  @override
  String get todayPlanSleepLogTitle => 'سجل نومك النهاردة';

  @override
  String todayPlanSleepDuration(String hours) {
    return 'نمت $hours ساعات';
  }

  @override
  String get todayPlanSleepLogSave => 'احفظ النوم';

  @override
  String get todayPlanSleepMarkDone => 'تمام (7+ ساعات نوم)';

  @override
  String get todayPlanSleepQuality => 'جودة النوم';

  @override
  String get todayPlanSupplements => 'المكملات والفيتامينات';

  @override
  String get todayPlanBreathingAction => 'جلسة تنفس';

  @override
  String get stepsHeroTitle => 'خطوات النهاردة';

  @override
  String get stepsEnableButton => 'فعّل عدّ الخطوات';

  @override
  String get stepsPermissionTitle => 'تتبع دقيق لخطواتك';

  @override
  String get stepsPermissionBody =>
      'ڤيريو بيستخدم حساس الحركة في موبايلك عشان يحسب خطواتك بدقة طول اليوم من غير ما يستهلك البطارية.';

  @override
  String get stepsPermissionGrant => 'فعّلها دلوقتي';

  @override
  String get stepsActiveMinutes => 'دقايق حركة';

  @override
  String stepsFatBurned(String grams) {
    return '≈ $grams جم دهون';
  }

  @override
  String stepsKm(String km) {
    return '$km كم';
  }

  @override
  String get stepsDetailTitle => 'الخطوات والمشي';

  @override
  String get stepsHourlyTitle => 'توزيع الساعات';

  @override
  String stepsStreakDays(int days) {
    return 'عاش! $days أيام التزام ورا بعض';
  }

  @override
  String stepsBestDay(String steps) {
    return 'أعلى يوم: $steps خطوة';
  }

  @override
  String get stepsWeekTab => 'الأسبوع';

  @override
  String get stepsMonthTab => 'الشهر';

  @override
  String get mealReviewItemQty => 'الكمية';

  @override
  String mealReviewConfidence(int pct) {
    return 'دقة $pct%';
  }

  @override
  String get mealReviewSourceUsda => 'قاعدة بيانات USDA';

  @override
  String get mealReviewSourceEgypt => 'جدول الأغذية المصري';

  @override
  String get mealReviewSourceAi => 'تقدير الذكاء الاصطناعي';

  @override
  String get mealReviewUnitPiece => 'حبة';

  @override
  String get mealReviewUnitHandful => 'حفنة';

  @override
  String get mealReviewUnitGrams => 'جم';

  @override
  String get mealReviewCookingRaw => 'نيء';

  @override
  String get mealReviewCookingBoiled => 'مسلوق';

  @override
  String get mealReviewCookingGrilled => 'مشوي';

  @override
  String get mealReviewCookingFried => 'مقلي (+زيت)';

  @override
  String get mealReviewCookingBaked => 'في الفرن';

  @override
  String mealReviewCaloriesFormat(int count) {
    return '$count سعرة';
  }

  @override
  String mealReviewProteinFormat(int count) {
    return '$count جم بروتين';
  }

  @override
  String mealReviewCarbsFormat(int count) {
    return '$count جم كارب';
  }

  @override
  String mealReviewFatFormat(int count) {
    return '$count جم دهون';
  }

  @override
  String get cuisineSettingTitle => 'المطبخ';

  @override
  String get cuisineEgyptian => 'الأكل النضيف المصري';

  @override
  String get cuisineSaudi => 'سعودي وخليجي';

  @override
  String get cuisineLevantine => 'شامي';

  @override
  String get cuisineMoroccan => 'مغربي ومغاربي';

  @override
  String get cuisineTurkish => 'تركي';

  @override
  String get cuisineIndian => 'هندي وباكستاني';

  @override
  String get cuisineIndonesian => 'إندونيسي';

  @override
  String get cuisineWestern => 'غربي / متوسطي';

  @override
  String dietProgramFitReason(String reason) {
    return 'مناسب لهدفك: $reason';
  }

  @override
  String get exerciseMusclesTargeted => 'العضلات المستهدفة';

  @override
  String get exerciseStepsTitle => 'إزاي تعمل التمرين صح خطوة بخطوة';

  @override
  String get exerciseCommonMistakes => 'أخطاء شائعة خلّي بالك منها';

  @override
  String get exerciseBreathingCue => 'طريقة النفس الصح';

  @override
  String get exerciseEasierVariation => 'تدرج أسهل لو صعب عليك';

  @override
  String get exerciseHarderVariation => 'تدرج أصعب لو سهل عليك';

  @override
  String get exerciseSafetyNote => 'أمان وإرشادات وقاية';

  @override
  String get exerciseWarmUpHeader => 'حركات التسخين والإحماء';

  @override
  String get reassessmentLaterSnooze => 'لاحقاً (فكرني كمان 3 أيام)';

  @override
  String get measurementsAddEntry => 'سجّل قياس جديد';

  @override
  String get walkingStopSessionTitle => 'توقف جولة المشي؟';

  @override
  String get walkingStopSessionDesc =>
      'حابب تحفظ أو تنهي جولة المشي دي دلوقتي؟';

  @override
  String get walkingSessionContinue => 'كمّل';

  @override
  String get walkingSessionEnd => 'إنهاء الجولة';

  @override
  String get walkingEditGoalTitle => 'تعديل هدف الخطوات اليومي';

  @override
  String get walkingTargetStepsLabel => 'عدد الخطوات المستهدف';

  @override
  String get walkingStepsSuffix => 'خطوة';

  @override
  String get walkingScreenTitle => 'المشي والنشاط';

  @override
  String get walkingDiagnosticsTooltip => 'تشخيص الخطوات';

  @override
  String get walkingRefreshTooltip => 'تحديث';

  @override
  String get walkingStartGps => 'ابدأ GPS';

  @override
  String get walkingActivityHistory => 'سجل الحركة والخطوات';

  @override
  String get walkingFilterDay => 'النهارده';

  @override
  String get walkingFilterWeek => 'أسبوع';

  @override
  String get walkingFilterMonth => 'شهر';

  @override
  String get walkingAchievementsTitle => 'الإنجازات والأرقام القياسية 🏆';

  @override
  String get stepToggleError => 'مقدرناش نغيّر حالة عداد الخطوات، حاول تاني';

  @override
  String get scoreInsightsTitle => 'السكور والتوقعات الذكية 🎯';

  @override
  String scoreInsightsTodaySummary(int eaten, int target) {
    return 'النهارده: أكلت $eaten من $target سعرة';
  }

  @override
  String scoreInsightsWeekFatSummary(int grams) {
    return 'الأسبوع ده: خسرت ≈ $grams جم دهون';
  }

  @override
  String scoreInsightsGoalWeeksSummary(String weeks) {
    return 'هتوصل لهدفك في ≈ $weeks أسابيع';
  }

  @override
  String get scoreInsightsActionLogProtein => 'سجّل وجبة غنية بالبروتين';

  @override
  String get scoreInsightsActionWalk => 'ابدأ مشي وكمّل خطواتك';

  @override
  String get scoreInsightsActionWater => 'اشرب كوباية ماية دلوقتي';

  @override
  String get scoreInsightsPredictionsTitle => 'توقعات ذكية (تقديري 🔮)';

  @override
  String get scoreInsightsPredictionsSubtitle =>
      'مبنية على عجز السعرات ومعدل الحرق';

  @override
  String scoreInsightsNeedData(int days) {
    return 'محتاجين 3 أيام بيانات عشان التوقع يبقى دقيق (سجلت $days يوم)';
  }

  @override
  String get scoreInsightsWeeklyFatLoss => 'دهون مفقودة أسبوعياً';

  @override
  String get scoreInsightsIn4Weeks => 'بعد 4 أسابيع';

  @override
  String get scoreInsightsIn8Weeks => 'بعد 8 أسابيع';

  @override
  String get scoreInsightsGoalHitIn => 'الوصول للهدف في';

  @override
  String get scoreInsightsClampWarning =>
      '⚠️ تم ضبط معدل النزول بما لا يتعدى 1% من وزن الجسم أسبوعياً لحماية صحتك وعضلاتك.';

  @override
  String get scoreInsightsAggressiveDeficitWarning =>
      '⚠️ عجز السعرات أعلى من 1,000 سعرة/يوم. ننصح بزيادة السعرات قليلاً لتجنب تباطؤ الحرق.';

  @override
  String get scoreInsightsHowCalculatedTitle =>
      'إزاي حسبناها؟ (معادلة Mifflin-St Jeor)';

  @override
  String scoreInsightsHowCalculatedBmr(String bmr) {
    return '• معدل الأيض الأساسي (BMR): $bmr سعرة';
  }

  @override
  String scoreInsightsHowCalculatedTdee(String tdee) {
    return '• معدل الحرق اليومي الكامل (TDEE): $tdee سعرة';
  }

  @override
  String get scoreInsightsHowCalculatedFat =>
      '• كل 7,700 سعرة عجز تساوي حرق 1 كجم من دهون الجسم تقريباً.';

  @override
  String get scoreInsightsBodyCompTitle => 'تحليل وتركيب الجسم';

  @override
  String get scoreInsightsBodyCompNewMeasure => 'قياس جديد';

  @override
  String get scoreInsightsBodyCompPrompt =>
      'اعرف نسبة الدهون وعضلاتك بالمازورة أو InBody';

  @override
  String get scoreInsightsEnergyBalanceTitle =>
      'توازن الطاقة (المأكول مقابل المحروق)';

  @override
  String get scoreInsightsEatenKcal => 'سعرات أكل';

  @override
  String get scoreInsightsBurnedKcal => 'حرق ونشاط';

  @override
  String get scoreInsightsMacrosTitle =>
      'توزيع الماكروز اليوم (الهدف vs المأكول)';

  @override
  String get scoreInsightsScoreTrendTitle => 'مسار السكور خلال 7 أيام';

  @override
  String get scoreInsightsImmediateActionsTitle =>
      'نصائح وإجراءات فورية لرفع السكور:';

  @override
  String get workoutRpeSubtitle =>
      'حسّيت بالمجهود قد إيه؟ من 1 (سهل جداً) لـ 10 (صعب جداً)';

  @override
  String workoutRpeLabel(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      '1': 'سهل جداً',
      '2': 'سهل',
      '3': 'سهل نسبياً',
      '4': 'خفيف',
      '5': 'متوسط',
      '6': 'شوية صعب',
      '7': 'تقيل',
      '8': 'صعب',
      '9': 'صعب أوي',
      'other': 'صعب جداً',
    });
    return '$_temp0';
  }

  @override
  String get workoutRpeFeelingsTitle => 'إحساسك بعد التمرين إيه؟';

  @override
  String get workoutFeelTired => 'تعب';

  @override
  String get workoutFeelJointPain => 'ألم في مفصل';

  @override
  String workoutFeelHappy(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'مبسوطة',
      'other': 'مبسوط',
    });
    return '$_temp0';
  }

  @override
  String get workoutFeelEnergized => 'طاقة عالية';

  @override
  String get workoutRpeNoteHint => 'اكتب ملاحظة (اختياري)';

  @override
  String get workoutRpeSave => 'احفظ';

  @override
  String get workoutRpeDone => 'تمام';

  @override
  String get workoutRpeSavedTitle => 'اتحفظ ✅';

  @override
  String get workoutRpeCommentJoint =>
      'ألم المفصل إشارة لازم نحترمها. خفّف الحمل في الجلسة الجاية وركّز على سلامة الحركة.';

  @override
  String get workoutRpeCommentHard =>
      'التمرين كان تقيل النهاردة. هنخفّف الحمل شوية المرة الجاية عشان جسمك يتعافى كويس.';

  @override
  String get workoutRpeCommentBetter =>
      'أداءك أحسن! نفس التمرين حسّيته أخف من المرة اللي فاتت 💪';

  @override
  String get workoutRpeCommentEasy =>
      'حسّيته سهل. الجلسة الجاية هنزوّد الحمل شوية.';

  @override
  String get workoutRpeCommentSteady => 'مجهود مظبوط. كمّل على نفس الإيقاع.';

  @override
  String get workoutRpeCommentPartial =>
      'اللي عملته من المجموعات محسوب وبيفرق. هنرجع أقوى في الجلسة الجاية.';

  @override
  String get foodFactCardTitle => 'حقيقة عن أكلك';

  @override
  String get foodFactShareHint => 'اضغط لمشاركة البطاقة';

  @override
  String get ramadanGuideTitle => 'دليل رمضان';

  @override
  String get ramadanGuideOpenHint =>
      'ترتيب السحور وإيقاع الإفطار — اضغط للتفاصيل';

  @override
  String get ramadanSuhoorRankTitle =>
      'ترتيب شبع السحور (بروتين + ألياف من قاعدة البيانات)';

  @override
  String ramadanSuhoorRankSubtitle(int grams, int kcal) {
    return 'حصة مثال $grams جم · ≈ $kcal سعرة';
  }

  @override
  String get ramadanIftarPaceTitle => 'إيقاع الإفطار';

  @override
  String get ramadanIftarStep1 => 'تمر + مية الأول';

  @override
  String get ramadanIftarStep2 => 'شوربة دافية';

  @override
  String get ramadanIftarStep3 => 'استنى 15 دقيقة';

  @override
  String get ramadanIftarStep4 => 'الطبق الرئيسي';

  @override
  String get ramadanReboundTitle => 'بعد رمضان';

  @override
  String ramadanReboundBody(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female':
          'ارجعي للروتين براحة: خلّي السحور فيه بروتين، سجّلي الإفطار من غير لوم، وزوّدي 10 دقائق مشي لمدة أسبوع قبل أي تخفيض كبير في السعرات.',
      'other':
          'ارجع للروتين براحة: خلّي السحور فيه بروتين، سجّل الإفطار من غير لوم، وزوّد 10 دقائق مشي لمدة أسبوع قبل أي تخفيض كبير في السعرات.',
    });
    return '$_temp0';
  }

  @override
  String get settingsMySubscription => 'اشتراكي';

  @override
  String get settingsMySubscriptionBody =>
      'تقدر تلغي أو تغيّر خطتك في أي وقت من Google Play — من غير مكالمات ولا خطوات مخفية.';

  @override
  String get weeklyBurnShareTitle => 'رصيد حرقك الأسبوع ده';

  @override
  String get weeklyBurnShareSubtitle => 'شارك خطواتك واستمراريتك';

  @override
  String get weeklyBurnShareCaption => 'رصيد حرقي الأسبوع ده مع ڤيريو';

  @override
  String get weeklyBurnShareAction => 'شارك بطاقة الأسبوع';

  @override
  String get weeklyBurnShareIncludeWeight => 'إظهار تغيّر الوزن في البطاقة';

  @override
  String get weeklyBurnShareStepsLabel => 'خطوات الأسبوع';

  @override
  String get weeklyBurnShareStreakLabel => 'الاستمرارية';

  @override
  String get weeklyBurnShareWeightLabel => 'تغيّر الوزن';

  @override
  String get widgetCaloriesLeftLabel => 'سعرات فاضلة';

  @override
  String get scanLimitTitle => 'خلصت تحليلات الصور النهارده';

  @override
  String get scanLimitBody =>
      'تحليل الصور بيستخدم خوادم. استنى لبكرة، أو Pro، أو سجّل يدوي — على مزاجك.';

  @override
  String get scanLimitProTitle => 'ڤيريو Pro';

  @override
  String get scanLimitProSubtitle =>
      'مسح ذكي غير محدود (40/يوم استخدام عادل)، بدون إعلانات، وكل البرامج';

  @override
  String get scanLimitProCta => 'اشتراك Pro';

  @override
  String get scanLimitWaitTitle => 'استنى لبكرة';

  @override
  String get scanLimitWaitSubtitle =>
      'التحليلات المجانية بتتجدد مع منتصف الليل — الكتابة والباركود لسه مفتوحين';

  @override
  String get scanLimitWaitCta => 'تمام، نشوف بكرة';

  @override
  String get scanLimitManualTitle => 'بحث وتسجيل يدوي';

  @override
  String get scanLimitManualSubtitle => 'مجاني وغير محدود دايماً';

  @override
  String get scanLimitManualCta => 'تسجيل يدوي';

  @override
  String get scanLimitAdRewardSnack => 'اتضاف +2 تحليلات للنهارده';

  @override
  String get scanLimitAdFailedSnack =>
      'مقدرناش نحمّل الإعلان — جرّب تاني بعد شوية';

  @override
  String get rebalanceCardTitle => 'تظبيط يومك';

  @override
  String get rebalanceSafeDay => 'عادي — يومك لسه في الأمان';

  @override
  String get rebalanceNeedsTap => 'مفيش تغيير غير لما تختار';

  @override
  String get weeklyBalanceTitle => 'ميزان الأسبوع';

  @override
  String get weeklyBalanceEmpty => 'سجّل كام يوم عشان نشوف ميزان الأسبوع';

  @override
  String weeklyBalanceOnTrack(int actual, int target) {
    return 'لسه في الهدف: عجز أسبوعي $actual من $target';
  }

  @override
  String weeklyBalanceOffTrack(int actual, int target) {
    return 'الأسبوع ده: عجز $actual من $target — نقدر نعدّل';
  }

  @override
  String weeklyBalanceCumulative(int kcal) {
    return 'التراكمي: $kcal سعرة';
  }

  @override
  String get energyLedgerTitle => 'رصيد حرقك';

  @override
  String get energyLedgerToday => 'اليوم';

  @override
  String get energyLedgerWeek => 'الأسبوع';

  @override
  String get energyLedgerMonth => 'الشهر';

  @override
  String get energyLedgerAllTime => 'من أول يوم';

  @override
  String energyLedgerBurned(int kcal, String fatKg) {
    return 'حرقت $kcal سعرة ≈ $fatKg كجم دهون';
  }

  @override
  String get energyLedgerBalanceNote =>
      'سعرات النشاط وتقدير الدهون من الرصيد منفصلين (تقديري)';

  @override
  String energyLedgerStepsDistance(int steps, String km) {
    return '$steps خطوة · $km كم';
  }

  @override
  String get fingerprintTitle => 'بصمتك — نظام Vireo الذكي';

  @override
  String get fingerprintSubtitle => 'اتعلمت من عاداتك الحقيقية بعد ١٤ يوم';

  @override
  String get fingerprintReset => 'ارجّع الافتراضي';

  @override
  String get fingerprintActivity => 'نشاطك';

  @override
  String get fingerprintNutrition => 'أكلك';

  @override
  String get fingerprintTolerance => 'تحمّلك';

  @override
  String get fingerprintChronotype => 'مواعيدك';

  @override
  String get fingerprintStepsUnit => 'خطوة مريحة';

  @override
  String fingerprintMealsCount(int count) {
    return '$count وجبات / يوم';
  }

  @override
  String fingerprintDeficitValue(int kcal) {
    return 'عجز تتحمّله ≈ $kcal سعرة';
  }

  @override
  String fingerprintLogHour(int hour) {
    return 'بتسجّل عادة حوالي الساعة $hour';
  }

  @override
  String get fingerprintActivityWhy => 'ليه؟ متوسط أحسن ٧٠٪ من أيام خطواتك';

  @override
  String get fingerprintNutritionWhy => 'ليه؟ من مواعيد وجباتك وأكلك المفضّل';

  @override
  String get fingerprintToleranceWhy => 'ليه؟ العجز اللي بتكمله من غير ارتداد';

  @override
  String get fingerprintChronotypeWhy => 'ليه؟ من مواعيد التسجيل والمشي';

  @override
  String get fingerprintEdit => 'عدّلها';

  @override
  String fingerprintNotReady(int days) {
    return 'لسه بنتعلّم — $days/١٤ يوم';
  }

  @override
  String get strideCalibratedBadge => 'مُعايَر على مشيك ✓';

  @override
  String stepSourceLabel(String source) {
    return 'المصدر: $source';
  }

  @override
  String get stepSourcePedometer => 'حساس الموبايل';

  @override
  String get stepSourceHealth => 'الصحة';

  @override
  String get stepSourceManual => 'يدوي';

  @override
  String get stepSourceNone => 'غير متاح';

  @override
  String get eatBackSettingTitle => 'استرجاع سعرات التمرين';

  @override
  String get eatBackHalf => '٥٠٪ (افتراضي)';

  @override
  String get eatBackFull => '١٠٠٪';

  @override
  String get eatBackNone => '٠٪';

  @override
  String get tdeeCheckInTitle => 'خطتك اتعدلت';

  @override
  String get tdeeCheckInUndo => 'تراجع';

  @override
  String get missedStepsCardTitle => 'خطوات امبارح';

  @override
  String get outdoorNetKcalLabel => 'صافي سعرات';

  @override
  String get outdoorCadenceLabel => 'إيقاع الخطوة';

  @override
  String get weeklyReviewTitle => 'مراجعة الأسبوع';

  @override
  String get adaptiveTdeeBlendNote => 'مزيج من تسجيلك + المعادلة';
}

/// The translations for Arabic, as used in Saudi Arabia (`ar_SA`).
class AppLocalizationsArSa extends AppLocalizationsAr {
  AppLocalizationsArSa() : super('ar_SA');

  @override
  String get continueButton => 'قدّام';

  @override
  String get skipButton => 'تخطّي';

  @override
  String get finishButton => 'تم';

  @override
  String get yesButton => 'إي والله';

  @override
  String get noButton => 'لا';

  @override
  String get authWelcomeTitle => 'يا هلا ومسهلا في ڤيريو!';

  @override
  String get authWelcomeSubtitle => 'رحلتك لجسم صحي ولياقة أفضل تبدأ الحين.';

  @override
  String get workoutFinishCoolDown => 'كفو.. إنهاء التمرين';

  @override
  String get workoutStartButton => 'يلا نبدأ التمرين';

  @override
  String get workoutSwapEmpty => 'ما فيه تمارين بديلة متوفرة حالياً';

  @override
  String get workoutEmptyProgram =>
      'ما فيه تمرين مجدول اليوم.. ارتاح وجهّز نفسك للجاي!';

  @override
  String get paywallPlanMonthly => 'شهري';

  @override
  String get paywallPlanAnnual => 'سنوي';

  @override
  String get paywallFeatureUnlimitedScans => 'مسح غير محدود للأطباق';

  @override
  String homeGreeting(String name) {
    return 'هلا والله يا $name 👋';
  }

  @override
  String homeStreakDays(int days) {
    return '$days أيام ورا بعض.. كفو ومستمرين!';
  }

  @override
  String get homeStartStreak => 'ابدأ حماسك اليوم وكفو!';

  @override
  String get habitsEmpty => 'ما أضفت عادات بعد.. ابدأ بعادة بسيطة اليوم!';

  @override
  String uxGoodMorning(String name) {
    return 'صباح الخير يا $name';
  }

  @override
  String uxGoodAfternoon(String name) {
    return 'مساك الله بالخير يا $name';
  }

  @override
  String uxGoodEvening(String name) {
    return 'مساء النور يا $name';
  }

  @override
  String get uxActionCoach => 'المدرب';

  @override
  String get uxLogEmptyTitle => 'ما سجّلت وجباتك اليوم بعد';

  @override
  String get uxLogEmptyBody =>
      'صوّر وجبتك والذكاء الاصطناعي بيحسب لك السعرات والماكروز بثواني.';

  @override
  String get uxRestDayHint =>
      'يوم راحة وتجديد نشاط.. خذ لك مشوار خفيف واضبط بروتينك.';

  @override
  String get uxWaterGoalDone => 'وصلت لهدف الموية 💧 كفو!';

  @override
  String get uxQuickCoach => 'اسأل مدربك';

  @override
  String get uxQuickCoachSub => 'استشارة فورية لك';

  @override
  String get uxCoachOnline => 'متصل · وحافظ أرقامك';

  @override
  String get uxCoachTyping => 'يكتب لك الحين…';

  @override
  String get uxCoachHeroTitle => 'مدربك الذكي الشخصي معك خطوة بخطوة';

  @override
  String get uxCoachHeroBody =>
      'اسأل عن أكلك، البروتين، الوجبات أو التمرين.. وكل إجابة على حسب أرقامك اليوم.';

  @override
  String get uxCoachChipWorkout => 'وش آكل قبل التمرين؟';

  @override
  String get measurementsNoData =>
      'ما سجّلت قياسات بعد.. ابدأ قياسك الأول اليوم!';

  @override
  String get vitalityProgramStartCta => 'يلا نبدأ البرنامج';

  @override
  String get dietQuizContinue => 'فاهم عليك.. يلا نكمل';

  @override
  String get dietQuizYes => 'إي والله';

  @override
  String get dietQuizNo => 'لا';

  @override
  String get dietPrefSkipBreakfast => 'تقدر تعدّي الفطور براحة؟';

  @override
  String get dietStartProgram => 'يلا نبدأ هذا البرنامج';

  @override
  String get todayPlanVitalitySleepSubtitle => 'سجّل 7.5+ ساعات في الحيوية';

  @override
  String get todayPlanProtocolItem => 'بروتوكول الحيوية';

  @override
  String get outdoorHistoryEmpty =>
      'ما سجّلت تمارين خارجية بعد.. اخرج وتحرّك اليوم!';

  @override
  String get mealReviewEstimated => 'تقديري';

  @override
  String mealReviewKcalApprox(int count) {
    return '≈ $count سعرة';
  }

  @override
  String get mealReviewPortionLabel => 'الحصة';

  @override
  String get mealReviewOilPrefix => 'زيت:';

  @override
  String get mealReviewOilLight => 'خفيف';

  @override
  String get mealReviewOilNormal => 'عادي';

  @override
  String get mealReviewOilHeavy => 'مسبّك';

  @override
  String get mealReviewFamilyPlateToggle => 'أكلنا من طبق واحد';

  @override
  String get mealReviewMyShare => 'نصيبي';

  @override
  String get ramadanWaterTrackerQuestion =>
      'كم كوب شربت من الإفطار إلى السحور؟';

  @override
  String ramadanWaterGoalSplit(int iftarCups, int eveningCups, int suhoorCups) {
    return 'هدف الإفطار: $iftarCups · الليل: $eveningCups · السحور: $suhoorCups كوب';
  }

  @override
  String get ramadanPrayerCityPickerTitle => 'اختر مدينة المواعيد';

  @override
  String get ramadanPrayerCityCustom => 'مدينة أخرى';

  @override
  String get ramadanCustomCityName => 'اسم المدينة';

  @override
  String get ramadanCustomCityLat => 'خط العرض';

  @override
  String get ramadanCustomCityLng => 'خط الطول';

  @override
  String get notificationPostScanTitle => 'تريد تذكيرات الوجبات؟';

  @override
  String get notificationPostScanBody =>
      'تذكيرات لطيفة للغداء والعشاء — مرتين يومياً كحد أقصى، ولا إزعاج من 11 مساءً إلى 7 صباحاً.';

  @override
  String get notificationPostScanYes => 'نعم، ذكّرني';

  @override
  String get notificationPostScanNotNow => 'ليس الآن';

  @override
  String get mealScanHintLabel => 'أضف كلمتين لو ودّك (اختياري)';

  @override
  String get mealScanHintPlaceholder => 'زيت؟ صوص؟ نوع الخبز؟';

  @override
  String get inbodyEmpty => 'ما فيه تقارير بعد.. صوّر فحص InBody وقدّام!';

  @override
  String get celebrationWaterTitle => 'كفو! جبت هدف الموية اليوم 💧';

  @override
  String get celebrationProteinTitle =>
      'كفو يا بطل! صكيت هدف البروتين اليوم 💪';

  @override
  String get celebrationStepsTitle => 'كفو! قفلت هدف الخطوات بالكامل 🏃';

  @override
  String get celebrationWorkoutTitle => 'كفو والله! خلصت تمرينك اليوم بنجاح 🔥';

  @override
  String fatEquivalentBurned(String amount) {
    return 'حرقت ما يعادل ≈ $amount دهون، كفو!';
  }

  @override
  String fatEquivalentTodayDeficit(String amount) {
    return 'عجز اليوم ≈ $amount دهون، كفو!';
  }

  @override
  String fatEquivalentThisWeek(String amount) {
    return '≈ $amount دهون هذا الأسبوع، كفو!';
  }

  @override
  String get legalTerms => 'الشروط';

  @override
  String get legalPrivacy => 'الخصوصية';

  @override
  String get legalMedicalDisclaimer => 'إخلاء المسؤولية الطبية';

  @override
  String get welcomeTagline => 'تغذية ذكية ولياقة متطورة مصممة خصيصاً للرجال.';

  @override
  String get welcomePillarScannerTitle => 'المسح الفوري للوجبات';

  @override
  String get welcomePillarScannerDesc =>
      'صوّر وجبتك، واعرف السعرات والبروتين بدقة في ثانيتين';

  @override
  String get welcomePillarPlanTitle => 'خطة يومية مخصصة';

  @override
  String get welcomePillarPlanDesc => 'أهداف علمية تناسب طبيعة جسمك وهدفك';

  @override
  String get welcomePillarSafetyTitle => 'تغذية آمنة سريرياً';

  @override
  String get welcomePillarSafetyDesc => 'إرشادات تحمي عملية الأيض وصحتك العامة';

  @override
  String get onboardingGoalTitle => 'ما هو هدفك الأساسي؟';

  @override
  String get onboardingGoalSubtitle =>
      'اختر الأهم بالنسبة لك، وسنصمم أهدافك اليومية بناءً عليه.';

  @override
  String get goalLoseFatTitle => 'حرق الدهون';

  @override
  String get goalLoseFatSubtitle =>
      'حرق الدهون العنيدة مع الحفاظ على الكتلة العضلية';

  @override
  String get goalBuildMuscleTitle => 'بناء العضلات';

  @override
  String get goalBuildMuscleSubtitle =>
      'تحفيز الضخامة العضلية الصافية ببروتين مثالي وتدرج الأحمال';

  @override
  String get goalMoreEnergyTitle => 'طاقة ونشاط أعلى';

  @override
  String get goalMoreEnergySubtitle =>
      'تخلص من خمول النهار وارفع طاقتك ونشاطك اليومي';

  @override
  String get goalAllOfAboveTitle => 'جميع ما سبق';

  @override
  String get goalAllOfAboveSubtitle =>
      'إعادة تشكيل شاملة للجسم: خسارة الدهون وزيادة القوة والنشاط';

  @override
  String get onboardingBodyTitle => 'بيانات جسمك';

  @override
  String get onboardingBodySubtitle =>
      'البيانات الدقيقة تساعدنا في حساب معدل حرقك واحتياجاتك اليومية بدقة.';

  @override
  String get sexMale => 'ذكر';

  @override
  String get sexFemale => 'أنثى';

  @override
  String get unitMetric => 'متري';

  @override
  String get unitImperial => 'باوند';

  @override
  String get bodyMetricAge => 'العمر';

  @override
  String bodyMetricYears(int age) {
    return '$age سنة';
  }

  @override
  String get selectAgeTitle => 'اختر العمر';

  @override
  String ageYearsSuffix(int age) {
    return '$age سنة';
  }

  @override
  String get bodyMetricHeight => 'الطول';

  @override
  String get selectHeightTitle => 'اختر الطول';

  @override
  String get bodyMetricCurrentWeight => 'الوزن الحالي';

  @override
  String get selectCurrentWeightTitle => 'اختر الوزن الحالي';

  @override
  String get bodyMetricTargetWeight => 'الوزن المستهدف';

  @override
  String get selectTargetWeightTitle => 'اختر الوزن المستهدف';

  @override
  String get pickerDone => 'تم';

  @override
  String get onboardingActivityTitle => 'النشاط ومكان التدريب';

  @override
  String get onboardingActivitySubtitle =>
      'نحسب معدل حرق السعرات ونقترح أفضل التمارين لك.';

  @override
  String get dailyActivityLevelHeader => 'مستوى النشاط اليومي';

  @override
  String get activitySedentaryTitle => 'قليل الحركة / عمل مكتبي';

  @override
  String get activitySedentarySubtitle =>
      'مشي يومي قليل، وظيفة مكتبية، أقل من 5,000 خطوة';

  @override
  String get activityModeratelyActiveTitle => 'نشاط متوسط';

  @override
  String get activityModeratelyActiveSubtitle =>
      'حركة منتظمة على مدار اليوم، 6,000 إلى 10,000 خطوة يومياً';

  @override
  String get activityVeryActiveTitle => 'نشط جداً / عمل بدني';

  @override
  String get activityVeryActiveSubtitle =>
      'حركة مستمرة أو أكثر من 12,000 خطوة يومياً';

  @override
  String get trainingPlaceHeader => 'أين تخطط للتمرن؟';

  @override
  String get trainingPlaceGymTitle => 'النادي الرياضي';

  @override
  String get trainingPlaceGymSubtitle => 'توفر كامل للأوزان والبارات والأجهزة';

  @override
  String get trainingPlaceHomeTitle => 'في المنزل';

  @override
  String get trainingPlaceHomeSubtitle =>
      'بوزن الجسم، أحبال المقاومة، أو أوزان خفيفة';

  @override
  String get trainingPlaceWalkingTitle => 'المشي';

  @override
  String get trainingPlaceWalkingSubtitle =>
      'خطوات كارديو ومشي في الهواء الطلق';

  @override
  String get onboardingHealthSafetyTitle => 'فحص السلامة الصحية';

  @override
  String get onboardingHealthSafetySubtitle =>
      'حدد أي حالات تنطبق عليك ليصمم نظامنا خطة آمنة تماماً لصحتك.';

  @override
  String get healthSafetyNoneApply => 'لا ينطبق عليّ أي مما سبق';

  @override
  String get healthSafetyOrSelect => 'أو اختر ما ينطبق عليك';

  @override
  String get onboardingTryScanTitle => 'جرّب المسح الفوري للوجبات';

  @override
  String get onboardingTryScanSubtitle =>
      'شاهد كيف يحلل ڤيريو الوجبات إلى سعرات وعناصر غذائية بدقة.';

  @override
  String get tryScanSamplePlateTitle => 'نموذج وجبة عالية البروتين';

  @override
  String get tryScanSamplePlateDesc => 'دجاج مشوي، أرز أبيض وسلطة خضراء';

  @override
  String get tryScanAnalyzing => 'جاري تحليل الوجبة...';

  @override
  String get tryScanSampleCta => 'امسح الطبق النموذجي (تجربة فورية)';

  @override
  String get tryScanOrTestLive => 'أو جرّب على طبقك الحقيقي';

  @override
  String get tryScanOwnMealTitle => 'صوّر وجبتك الحالية';

  @override
  String get tryScanOwnMealDesc => 'التقط صورة حية للطبق الذي أمامك';

  @override
  String get onboardingPlanRevealTitle => 'خطتك المصممة خصيصاً لك';

  @override
  String get onboardingPlanRevealSubtitle =>
      'مصممة وفقاً لمعدل حرقك وطبيعة جسمك وهدفك الرياضي.';

  @override
  String get planRevealStartPlan => 'ابدأ خطتي';

  @override
  String get planRevealProjectedPace => 'المعدل المتوقع';

  @override
  String get planRevealSteadyRecomp => 'إعادة تشكيل متوازنة للجسم';

  @override
  String planRevealFatLossPace(String amount) {
    return 'نزول -$amount كجم دهون أسبوعياً';
  }

  @override
  String planRevealLeanMassPace(String amount) {
    return 'زيادة +$amount كجم عضلات صافية أسبوعياً';
  }

  @override
  String get planRevealDailyCalories => 'هدف السعرات اليومي';

  @override
  String get planRevealPersonalizedBadge => 'مخصص لك';

  @override
  String get planRevealKcalPerDay => 'سعرة / يوم';

  @override
  String get planRevealDailyProtein => 'البروتين اليومي';

  @override
  String get planRevealGramPerDay => 'جم / يوم';

  @override
  String get planRevealHydration => 'شرب الماء';

  @override
  String get planRevealDailySteps => 'الخطوات اليومية';

  @override
  String get planRevealStepsPerDay => 'خطوة / يوم';

  @override
  String get planRevealDietProtocol => 'نظام التغذية';

  @override
  String get planRevealOptimalMatch => 'الخطة الأنسب لك';

  @override
  String get planRevealBalancedPlanDefault => 'خطة العجز المتوازن';

  @override
  String get onboardingNotificationsTitle => 'لا تفوّت أهدافك اليومية';

  @override
  String get onboardingNotificationsSubtitle =>
      'تنبيهات تضمن التزامك بتسجيل الوجبات وشرب الماء والتمارين.';

  @override
  String get notificationsHeroTitle => 'مصممة للالتزام.. وليس للإزعاج';

  @override
  String get notificationsHeroBody =>
      'المستخدمون الذين يفعّلون التنبيهات أكثر نجاحاً بـ 3.4 أضعاف في الوصول لوزنهم المستهدف.';

  @override
  String get notificationsMealLoggingTitle => 'تسجيل الوجبات';

  @override
  String get notificationsMealLoggingDesc => 'تذكير في أوقات الغداء والعشاء';

  @override
  String get notificationsWorkoutSessionTitle => 'التمرين اليومي';

  @override
  String get notificationsWorkoutSessionDesc =>
      'حافظ على التزامك بجدول تمارينك';

  @override
  String get notificationsWeeklyReviewTitle => 'المراجعة الأسبوعية للتقدم';

  @override
  String get notificationsWeeklyReviewDesc =>
      'قياس الوزن أسبوعياً وتعديل الأهداف';

  @override
  String get notificationsEnableButton => 'تفعيل التنبيهات';

  @override
  String get notificationsMaybeLater => 'ربما لاحقاً';

  @override
  String get onboardingPaywallTitle => 'سرّع تحقيق نتائجك';

  @override
  String get onboardingPaywallSubtitle =>
      'امسح الأطباق بلا حدود، واحصل على جداول تمارين ذكية وتحليلات متقدمة.';

  @override
  String get paywallProBadge => 'ڤيريو برو';

  @override
  String get paywallFeatureUnlimitedScansDesc =>
      'بدون أي قيود يومية على عدد الوجبات';

  @override
  String get paywallFeatureSmartSub => 'بدائل ذكية للوجبات بالذكاء الاصطناعي';

  @override
  String get paywallFeatureSmartSubDesc =>
      'بدائل صحية ومناسبة للماكروز للأطباق المحلية';

  @override
  String get paywallFeatureAdaptiveSplits => 'جداول تمارين متكيفة مع مستواك';

  @override
  String get paywallFeatureAdaptiveSplitsDesc =>
      'تتبع زيادة الأوزان للجيم أو المنزل';

  @override
  String get paywallPlanAnnualPrice => '\$4.99 / شهرياً';

  @override
  String get paywallPlanAnnualSubtext => 'اشتراك سنوي (وفّر 50%)';

  @override
  String get paywallBadgeBestValue => 'أفضل قيمة';

  @override
  String get paywallPlanMonthlyPrice => '\$9.99 / شهرياً';

  @override
  String get paywallPlanMonthlySubtext => 'اشتراك شهري';

  @override
  String get paywallStartTrialCta => 'ابدأ تجربة مجانية لمدة 7 أيام';

  @override
  String get paywallContinueFreeTier => 'المتابعة بالباقة المجانية';

  @override
  String get appInitErrorFailed => 'فشل في تهيئة خدمات التطبيق.';

  @override
  String get appInitRetry => 'إعادة المحاولة';

  @override
  String get privacyExportTitle => 'تصدير بياناتي';

  @override
  String get privacyExportReady => 'حزمة بياناتك جاهزة بصيغتي JSON و CSV:';

  @override
  String get weeklyProgressShareFailed => 'تعذر إنشاء صورة المشاركة';

  @override
  String get adaptiveCalorieCurrentTarget => 'الهدف الحالي';

  @override
  String get adaptiveCalorieSuggestedTarget => 'الهدف المقترح';

  @override
  String get adaptiveCalorieWindowSpan => 'المدة الزمنية';

  @override
  String get adaptiveCalorieFoodLogsCount => 'عدد أيام تسجيل الوجبات';

  @override
  String get adaptiveCalorieWeighInsCount => 'مرات قياس الوزن';

  @override
  String get adaptiveCalorieAverageIntake => 'متوسط السعرات المتناولة';

  @override
  String get adaptiveCalorieTrendWeightChange => 'تغير اتجاه الوزن';

  @override
  String get adaptiveCalorieEstimatedMaintenance => 'سعرات الثبات التقديرية';

  @override
  String get adaptiveCalorieWeeklyChangeCap => 'الحد الأقصى للتغير الأسبوعي';

  @override
  String get adaptiveCalorieSafetyFloorApplied => 'تطبيق الحد الأدنى الآمن';

  @override
  String get chartSevenDayTrend => 'اتجاه 7 أيام';

  @override
  String get chartThirtyDayTrend => 'اتجاه 30 يوماً';

  @override
  String get chartRawDot => 'قياس فردي';

  @override
  String get chartTrendLine => 'خط الاتجاه';

  @override
  String get chartGoalLine => 'خط الهدف';

  @override
  String get scanSourceSheetTitle => 'كيف تحب تسجل وجبتك؟';

  @override
  String get scanSourceCamera => 'صوّر بالكاميرا';

  @override
  String get scanSourceGallery => 'اختر من الاستوديو';

  @override
  String get scanSourceText => 'اكتب الوجبة';

  @override
  String get scanSourceFridgeTitle => 'صوّر الثلاجة أو المطبخ';

  @override
  String get scanSourceInBodyTitle => 'رفع تقرير إن بادي';

  @override
  String get todayPlanMorning => 'صباحاً';

  @override
  String get todayPlanAfternoon => 'الظهر';

  @override
  String get todayPlanEvening => 'المساء';

  @override
  String get todayPlanWaterQuickAdd => '+250 مل';

  @override
  String todayPlanWaterProgress(String current, String goal) {
    return '$current / $goal لتر';
  }

  @override
  String get todayPlanSleepLogTitle => 'سجل نومك اليوم';

  @override
  String todayPlanSleepDuration(String hours) {
    return 'نمت $hours ساعات';
  }

  @override
  String get todayPlanSleepLogSave => 'حفظ النوم';

  @override
  String get todayPlanSleepMarkDone => 'تم (7+ ساعات نوم)';

  @override
  String get todayPlanSleepQuality => 'جودة النوم';

  @override
  String get todayPlanSupplements => 'المكملات اليومية';

  @override
  String get todayPlanBreathingAction => 'جلسة تنفس';

  @override
  String get stepsHeroTitle => 'خطوات اليوم';

  @override
  String get stepsEnableButton => 'فعّل عدّ الخطوات';

  @override
  String get stepsPermissionTitle => 'تتبع دقيق للخطوات';

  @override
  String get stepsPermissionBody =>
      'يستخدم ڤيريو حساس الحركة في جوالك لعد الخطوات بدقة على مدار اليوم بدون استهلاك البطارية.';

  @override
  String get stepsPermissionGrant => 'تفعيل الحين';

  @override
  String get stepsActiveMinutes => 'دقائق نشاط';

  @override
  String stepsFatBurned(String grams) {
    return '≈ $grams جم دهون';
  }

  @override
  String stepsKm(String km) {
    return '$km كم';
  }

  @override
  String get stepsDetailTitle => 'الخطوات والمشي';

  @override
  String get stepsHourlyTitle => 'توزيع الساعات';

  @override
  String stepsStreakDays(int days) {
    return 'كفو! $days أيام متتالية';
  }

  @override
  String stepsBestDay(String steps) {
    return 'أفضل يوم: $steps خطوة';
  }

  @override
  String get stepsWeekTab => 'أسبوع';

  @override
  String get stepsMonthTab => 'شهر';

  @override
  String get mealReviewItemQty => 'الكمية';

  @override
  String mealReviewConfidence(int pct) {
    return 'دقة $pct%';
  }

  @override
  String get mealReviewSourceUsda => 'قاعدة بيانات USDA';

  @override
  String get mealReviewSourceEgypt => 'جدول الأغذية المصري';

  @override
  String get mealReviewSourceAi => 'تقدير الذكاء الاصطناعي';

  @override
  String get mealReviewUnitPiece => 'حبة';

  @override
  String get mealReviewUnitHandful => 'قبضة يد';

  @override
  String get mealReviewUnitGrams => 'جم';

  @override
  String get mealReviewCookingRaw => 'نيء';

  @override
  String get mealReviewCookingBoiled => 'مسلوق';

  @override
  String get mealReviewCookingGrilled => 'مشوي';

  @override
  String get mealReviewCookingFried => 'مقلي (+زيت)';

  @override
  String get mealReviewCookingBaked => 'بالفرن';

  @override
  String mealReviewCaloriesFormat(int count) {
    return '$count سعرة';
  }

  @override
  String mealReviewProteinFormat(int count) {
    return '$count جم بروتين';
  }

  @override
  String mealReviewCarbsFormat(int count) {
    return '$count جم كارب';
  }

  @override
  String mealReviewFatFormat(int count) {
    return '$count جم دهون';
  }

  @override
  String get cuisineSettingTitle => 'المطبخ';

  @override
  String get cuisineEgyptian => 'مصري';

  @override
  String get cuisineSaudi => 'سعودي وخليجي';

  @override
  String get cuisineLevantine => 'شامي';

  @override
  String get cuisineMoroccan => 'مغربي ومغاربي';

  @override
  String get cuisineTurkish => 'تركي';

  @override
  String get cuisineIndian => 'هندي وباكستاني';

  @override
  String get cuisineIndonesian => 'إندونيسي';

  @override
  String get cuisineWestern => 'غربي / متوسطي';

  @override
  String dietProgramFitReason(String reason) {
    return 'مناسب لهدفك: $reason';
  }

  @override
  String get exerciseMusclesTargeted => 'العضلات المستهدفة';

  @override
  String get exerciseStepsTitle => 'طريقة أداء التمرين خطوة بخطوة';

  @override
  String get exerciseCommonMistakes => 'أخطاء شائعة انتبه منها';

  @override
  String get exerciseBreathingCue => 'طريقة التنفس الصحيحة';

  @override
  String get exerciseEasierVariation => 'تدرج أسهل';

  @override
  String get exerciseHarderVariation => 'تدرج أصعب';

  @override
  String get exerciseSafetyNote => 'تعليمات الأمان';

  @override
  String get exerciseWarmUpHeader => 'حركات الإحماء والتسخين';

  @override
  String get reassessmentLaterSnooze => 'لاحقاً (ذكرني بعد 3 أيام)';

  @override
  String get measurementsAddEntry => 'سجّل قياس جديد';

  @override
  String get stepToggleError =>
      'تعذر تغيير حالة عداد الخطوات، يرجى المحاولة مرة أخرى';

  @override
  String get scoreInsightsTitle => 'السكور والتوقعات الذكية 🎯';

  @override
  String scoreInsightsTodaySummary(int eaten, int target) {
    return 'اليوم: تناولت $eaten من $target سعرة';
  }

  @override
  String scoreInsightsWeekFatSummary(int grams) {
    return 'هذا الأسبوع: خسرت ≈ $grams جم دهون';
  }

  @override
  String scoreInsightsGoalWeeksSummary(String weeks) {
    return 'ستصل لهدفك خلال ≈ $weeks أسابيع';
  }

  @override
  String get scoreInsightsActionLogProtein => 'سجّل وجبة غنية بالبروتين';

  @override
  String get scoreInsightsActionWalk => 'ابدأ المشي وأكمل خطواتك';

  @override
  String get scoreInsightsActionWater => 'اشرب كوب ماء الآن';

  @override
  String get scoreInsightsPredictionsTitle => 'توقعات ذكية (تقديري 🔮)';

  @override
  String get scoreInsightsPredictionsSubtitle =>
      'مبنية على عجز السعرات ومعدل الحرق';

  @override
  String scoreInsightsNeedData(int days) {
    return 'نحتاج إلى 3 أيام من البيانات لدقة التوقع (سجلت $days يوم)';
  }

  @override
  String get scoreInsightsWeeklyFatLoss => 'دهون مفقودة أسبوعياً';

  @override
  String get scoreInsightsIn4Weeks => 'بعد 4 أسابيع';

  @override
  String get scoreInsightsIn8Weeks => 'بعد 8 أسابيع';

  @override
  String get scoreInsightsGoalHitIn => 'الوصول للهدف في';

  @override
  String get scoreInsightsClampWarning =>
      '⚠️ تم ضبط معدل النزول بما لا يتعدى 1% من وزن الجسم أسبوعياً لحماية صحتك وعضلاتك.';

  @override
  String get scoreInsightsAggressiveDeficitWarning =>
      '⚠️ عجز السعرات أعلى من 1,000 سعرة/يوم. ننصح بزيادة السعرات قليلاً لتجنب تباطؤ الحرق.';

  @override
  String get scoreInsightsHowCalculatedTitle =>
      'كيف تم الحساب؟ (معادلة Mifflin-St Jeor)';

  @override
  String scoreInsightsHowCalculatedBmr(String bmr) {
    return '• معدل الأيض الأساسي (BMR): $bmr سعرة';
  }

  @override
  String scoreInsightsHowCalculatedTdee(String tdee) {
    return '• معدل الحرق اليومي الكامل (TDEE): $tdee سعرة';
  }

  @override
  String get scoreInsightsHowCalculatedFat =>
      '• كل 7,700 سعرة عجز تساوي حرق 1 كجم من دهون الجسم تقريباً.';

  @override
  String get scoreInsightsBodyCompTitle => 'تحليل وتركيب الجسم';

  @override
  String get scoreInsightsBodyCompNewMeasure => 'قياس جديد';

  @override
  String get scoreInsightsBodyCompPrompt =>
      'اعرف نسبة الدهون وعضلاتك بالمازورة أو InBody';

  @override
  String get scoreInsightsEnergyBalanceTitle =>
      'توازن الطاقة (المأكول مقابل المحروق)';

  @override
  String get scoreInsightsEatenKcal => 'سعرات أكل';

  @override
  String get scoreInsightsBurnedKcal => 'حرق ونشاط';

  @override
  String get scoreInsightsMacrosTitle =>
      'توزيع الماكروز اليوم (الهدف vs المأكول)';

  @override
  String get scoreInsightsScoreTrendTitle => 'مسار السكور خلال 7 أيام';

  @override
  String get scoreInsightsImmediateActionsTitle =>
      'نصائح وإجراءات فورية لرفع السكور:';

  @override
  String get workoutRpeSubtitle =>
      'كيف كان شعورك بالمجهود؟ من 1 (سهل جداً) إلى 10 (صعب جداً)';

  @override
  String workoutRpeLabel(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      '1': 'سهل جداً',
      '2': 'سهل',
      '3': 'سهل نسبياً',
      '4': 'خفيف',
      '5': 'متوسط',
      '6': 'صعب نوعاً ما',
      '7': 'شاق',
      '8': 'صعب',
      '9': 'صعب للغاية',
      'other': 'صعب جداً',
    });
    return '$_temp0';
  }

  @override
  String get workoutRpeFeelingsTitle => 'ما إحساسك بعد التمرين؟';

  @override
  String get workoutFeelTired => 'تعب';

  @override
  String get workoutFeelJointPain => 'ألم في مفصل';

  @override
  String workoutFeelHappy(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'مسرورة',
      'other': 'مسرور',
    });
    return '$_temp0';
  }

  @override
  String get workoutFeelEnergized => 'طاقة عالية';

  @override
  String get workoutRpeNoteHint => 'اكتب ملاحظة (اختياري)';

  @override
  String get workoutRpeSave => 'احفظ';

  @override
  String get workoutRpeDone => 'تمام';

  @override
  String get workoutRpeSavedTitle => 'تم الحفظ ✅';

  @override
  String get workoutRpeCommentJoint =>
      'ألم المفصل إشارة تستحق الاهتمام. خفّف الحمل في الجلسة القادمة وركّز على سلامة الحركة.';

  @override
  String get workoutRpeCommentHard =>
      'كان التمرين شاقاً اليوم. سنخفف الحمل قليلاً في المرة القادمة ليتعافى جسمك جيداً.';

  @override
  String get workoutRpeCommentBetter =>
      'أداؤك أفضل! نفس التمرين بدا أخف من المرة السابقة 💪';

  @override
  String get workoutRpeCommentEasy =>
      'بدا التمرين سهلاً. في الجلسة القادمة سنزيد الحمل قليلاً.';

  @override
  String get workoutRpeCommentSteady => 'جهد مناسب. استمر على هذا الإيقاع.';

  @override
  String get workoutRpeCommentPartial =>
      'ما أنجزته من المجموعات يُحسب لك. سنعود أقوى في الجلسة القادمة.';

  @override
  String get foodFactCardTitle => 'حقيقة عن أكلك';

  @override
  String get foodFactShareHint => 'اضغط لمشاركة البطاقة';

  @override
  String get ramadanGuideTitle => 'دليل رمضان';

  @override
  String get ramadanGuideOpenHint =>
      'ترتيب السحور وإيقاع الإفطار — اضغط للتفاصيل';

  @override
  String get ramadanSuhoorRankTitle =>
      'ترتيب شبع السحور (بروتين + ألياف من قاعدة البيانات)';

  @override
  String ramadanSuhoorRankSubtitle(int grams, int kcal) {
    return 'حصة مثال $grams جم · ≈ $kcal سعرة';
  }

  @override
  String get ramadanIftarPaceTitle => 'إيقاع الإفطار';

  @override
  String get ramadanIftarStep1 => 'تمر + مية أولاً';

  @override
  String get ramadanIftarStep2 => 'شوربة دافئة';

  @override
  String get ramadanIftarStep3 => 'انتظر 15 دقيقة';

  @override
  String get ramadanIftarStep4 => 'الطبق الرئيسي';

  @override
  String get ramadanReboundTitle => 'بعد رمضان';

  @override
  String ramadanReboundBody(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female':
          'عودي للروتين برفق: أبقي السحور غنياً بالبروتين، سجّلي الإفطار دون لوم، وأضيفي 10 دقائق مشي لمدة أسبوع قبل أي تخفيض كبير للسعرات.',
      'other':
          'عد للروتين برفق: أبقِ السحور غنياً بالبروtين، سجّل الإفطار دون لوم، وأضف 10 دقائق مشي لمدة أسبوع قبل أي تخفيض كبير للسعرات.',
    });
    return '$_temp0';
  }

  @override
  String get settingsMySubscription => 'اشتراكي';

  @override
  String get settingsMySubscriptionBody =>
      'يمكنك إلغاء أو تغيير خطتك في أي وقت من Google Play — دون مكالمات أو خطوات مخفية.';

  @override
  String get weeklyBurnShareTitle => 'رصيد حرقك هذا الأسبوع';

  @override
  String get weeklyBurnShareSubtitle => 'شارك خطواتك واستمراريتك';

  @override
  String get weeklyBurnShareCaption => 'رصيد حرقي هذا الأسبوع مع Vireo';

  @override
  String get weeklyBurnShareAction => 'مشاركة بطاقة الأسبوع';

  @override
  String get weeklyBurnShareIncludeWeight => 'إظهار تغيّر الوزن في البطاقة';

  @override
  String get weeklyBurnShareStepsLabel => 'خطوات الأسبوع';

  @override
  String get weeklyBurnShareStreakLabel => 'الاستمرارية';

  @override
  String get weeklyBurnShareWeightLabel => 'تغيّر الوزن';

  @override
  String get widgetCaloriesLeftLabel => 'سعرات متبقية';

  @override
  String get scanLimitTitle => 'انتهى حد تحليل الصور اليوم';

  @override
  String get scanLimitBody =>
      'تحليل الصور يستخدم خوادم. انتظر حتى الغد، أو Pro، أو سجّل يدوياً.';

  @override
  String get scanLimitProTitle => 'Vireo Pro';

  @override
  String get scanLimitProSubtitle =>
      'مسح ذكي غير محدود (40/يوم)، بدون إعلانات، وكل البرامج';

  @override
  String get scanLimitProCta => 'اشتراك Pro';

  @override
  String get scanLimitWaitTitle => 'انتظر حتى الغد';

  @override
  String get scanLimitWaitSubtitle =>
      'تتجدد التحليلات المجانية عند منتصف الليل — الكتابة والباركود مفتوحان';

  @override
  String get scanLimitWaitCta => 'حسناً، أراك غداً';

  @override
  String get scanLimitManualTitle => 'بحث وتسجيل يدوي';

  @override
  String get scanLimitManualSubtitle => 'مجاني وغير محدود دائماً';

  @override
  String get scanLimitManualCta => 'تسجيل يدوي';

  @override
  String get scanLimitAdRewardSnack => 'تمت إضافة +2 تحليلات لليوم';

  @override
  String get scanLimitAdFailedSnack => 'تعذر تحميل الإعلان — حاول لاحقاً';

  @override
  String get rebalanceCardTitle => 'تظبيط يومك';

  @override
  String get rebalanceSafeDay => 'عادي — يومك لسه في الأمان';

  @override
  String get rebalanceNeedsTap => 'مفيش تغيير غير لما تختار';

  @override
  String get weeklyBalanceTitle => 'ميزان الأسبوع';

  @override
  String get weeklyBalanceEmpty => 'سجّل كام يوم عشان نشوف ميزان الأسبوع';

  @override
  String weeklyBalanceOnTrack(int actual, int target) {
    return 'لسه في الهدف: عجز أسبوعي $actual من $target';
  }

  @override
  String weeklyBalanceOffTrack(int actual, int target) {
    return 'الأسبوع ده: عجز $actual من $target — نقدر نعدّل';
  }

  @override
  String weeklyBalanceCumulative(int kcal) {
    return 'التراكمي: $kcal سعرة';
  }

  @override
  String get energyLedgerTitle => 'رصيد حرقك';

  @override
  String get energyLedgerToday => 'اليوم';

  @override
  String get energyLedgerWeek => 'الأسبوع';

  @override
  String get energyLedgerMonth => 'الشهر';

  @override
  String get energyLedgerAllTime => 'من أول يوم';

  @override
  String energyLedgerBurned(int kcal, String fatKg) {
    return 'حرقت $kcal سعرة ≈ $fatKg كجم دهون';
  }

  @override
  String get energyLedgerBalanceNote =>
      'سعرات النشاط وتقدير الدهون من الرصيد منفصلين (تقديري)';

  @override
  String energyLedgerStepsDistance(int steps, String km) {
    return '$steps خطوة · $km كم';
  }

  @override
  String get fingerprintTitle => 'بصمتك — نظام Vireo الذكي';

  @override
  String get fingerprintSubtitle => 'اتعلمت من عاداتك الحقيقية بعد ١٤ يوم';

  @override
  String get fingerprintReset => 'ارجّع الافتراضي';

  @override
  String get fingerprintActivity => 'نشاطك';

  @override
  String get fingerprintNutrition => 'أكلك';

  @override
  String get fingerprintTolerance => 'تحمّلك';

  @override
  String get fingerprintChronotype => 'مواعيدك';

  @override
  String get fingerprintStepsUnit => 'خطوة مريحة';

  @override
  String fingerprintMealsCount(int count) {
    return '$count وجبات / يوم';
  }

  @override
  String fingerprintDeficitValue(int kcal) {
    return 'عجز تتحمّله ≈ $kcal سعرة';
  }

  @override
  String fingerprintLogHour(int hour) {
    return 'بتسجّل عادة حوالي الساعة $hour';
  }

  @override
  String get fingerprintActivityWhy => 'ليه؟ متوسط أحسن ٧٠٪ من أيام خطواتك';

  @override
  String get fingerprintNutritionWhy => 'ليه؟ من مواعيد وجباتك وأكلك المفضّل';

  @override
  String get fingerprintToleranceWhy => 'ليه؟ العجز اللي بتكمله من غير ارتداد';

  @override
  String get fingerprintChronotypeWhy => 'ليه؟ من مواعيد التسجيل والمشي';

  @override
  String get fingerprintEdit => 'عدّلها';

  @override
  String fingerprintNotReady(int days) {
    return 'لسه بنتعلّم — $days/١٤ يوم';
  }

  @override
  String get strideCalibratedBadge => 'مُعايَر على مشيك ✓';

  @override
  String stepSourceLabel(String source) {
    return 'المصدر: $source';
  }

  @override
  String get stepSourcePedometer => 'حساس الموبايل';

  @override
  String get stepSourceHealth => 'الصحة';

  @override
  String get stepSourceManual => 'يدوي';

  @override
  String get stepSourceNone => 'غير متاح';

  @override
  String get eatBackSettingTitle => 'استرجاع سعرات التمرين';

  @override
  String get eatBackHalf => '٥٠٪ (افتراضي)';

  @override
  String get eatBackFull => '١٠٠٪';

  @override
  String get eatBackNone => '٠٪';

  @override
  String get tdeeCheckInTitle => 'خطتك اتعدلت';

  @override
  String get tdeeCheckInUndo => 'تراجع';

  @override
  String get missedStepsCardTitle => 'خطوات امبارح';

  @override
  String get outdoorNetKcalLabel => 'صافي سعرات';

  @override
  String get outdoorCadenceLabel => 'إيقاع الخطوة';

  @override
  String get weeklyReviewTitle => 'مراجعة الأسبوع';

  @override
  String get adaptiveTdeeBlendNote => 'مزيج من تسجيلك + المعادلة';
}
