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
    return '$calories kcal';
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
    return '$minutes min · $calories kcal';
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
  String get measurements30Days => '30 days';

  @override
  String get measurements3Months => '3 months';

  @override
  String get measurements7Days => '7 days';

  @override
  String get measurementsAdd => 'إضافة قياس';

  @override
  String get measurementsAddFirst => 'Log your first measurement';

  @override
  String get measurementsAll => 'All';

  @override
  String get measurementsArms => 'الذراعين';

  @override
  String get measurementsBodyFat => 'نسبة الدهون';

  @override
  String get measurementsChest => 'الصدر';

  @override
  String get measurementsDate => 'Date';

  @override
  String get measurementsDelete => 'حذف';

  @override
  String get measurementsDeleteConfirm => 'Delete this measurement?';

  @override
  String get measurementsHistory => 'السجل';

  @override
  String measurementsLastUpdated(String date) {
    return 'Updated $date';
  }

  @override
  String get measurementsNeedMoreData => 'Log more entries to see trends';

  @override
  String get measurementsNoData => 'No measurements yet';

  @override
  String get measurementsNotes => 'ملاحظات';

  @override
  String get measurementsSave => 'حفظ';

  @override
  String get measurementsThighs => 'الفخذين';

  @override
  String get measurementsTitle => 'القياسات';

  @override
  String get measurementsTrendDeclining => 'Needs attention';

  @override
  String get measurementsTrendImproving => 'Improving';

  @override
  String get measurementsTrendStable => 'Stable';

  @override
  String get measurementsWaist => 'الخصر';

  @override
  String get measurementsWeight => 'الوزن';

  @override
  String get measurementsWeightInvalid => 'Enter a valid weight';

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
  String get notificationsBreakfast => 'Breakfast reminder';

  @override
  String get notificationsDinner => 'Dinner reminder';

  @override
  String get notificationsLunch => 'Lunch reminder';

  @override
  String get notificationsOpenSettings => 'Open settings';

  @override
  String get notificationsPermissionBanner =>
      'Enable notifications to stay on track';

  @override
  String get notificationsPreWorkout => 'Pre-workout reminder';

  @override
  String get notificationsPreWorkoutSubtitle => 'Get ready to train';

  @override
  String get notificationsSleep => 'Sleep reminder';

  @override
  String get notificationsSleepSubtitle => 'Wind down for better recovery';

  @override
  String get notificationsTest => 'Send test notification';

  @override
  String get notificationsTestBody => 'Vireo reminders are working';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsWater => 'Water reminder';

  @override
  String get notificationsWaterSubtitle => 'Stay hydrated through the day';

  @override
  String get notificationsWeeklyReport => 'Weekly report';

  @override
  String get notificationsWeeklyReportSubtitle => 'See how your week went';

  @override
  String get vitality12WeekProgram => '12-Week Program';

  @override
  String vitalityArticleCount(int count) {
    return '$count articles';
  }

  @override
  String get vitalityArticleDisclaimer =>
      'For education only. Consult a professional for personal advice.';

  @override
  String get vitalityArticlesSection => 'Articles';

  @override
  String get vitalityBadgesTitle => 'Badges';

  @override
  String vitalityBreathingCount(int count) {
    return '$count جلسات';
  }

  @override
  String get vitalityBreathingLog => 'Breathing';

  @override
  String get vitalityCategoryAdvanced => 'Advanced';

  @override
  String get vitalityCategoryEnvironmental => 'Environment';

  @override
  String get vitalityCategoryLifestyle => 'Lifestyle';

  @override
  String get vitalityCategoryNutrition => 'Nutrition';

  @override
  String get vitalityCategoryTraining => 'Training';

  @override
  String get vitalityCheckProtein => 'Hit protein';

  @override
  String get vitalityCheckSleep => 'Quality sleep';

  @override
  String get vitalityCheckSunlight => 'Morning light';

  @override
  String get vitalityCheckWorkout => 'Move / train';

  @override
  String get vitalityCheckZincVitD => 'Zinc / Vit D';

  @override
  String vitalityDailyChecklistProgress(int done, int total) {
    return '$done/$total done';
  }

  @override
  String get vitalityDailyChecklistTitle => 'Today\'s checklist';

  @override
  String get vitalityDailyTipLabel => 'Daily tip';

  @override
  String get vitalityHubSubtitle =>
      'Science-backed habits for energy and recovery';

  @override
  String get vitalityHubTitle => 'مركز الحيوية';

  @override
  String get vitalityLegendBadge => 'Legend';

  @override
  String get vitalityLinkCopied => 'Link copied';

  @override
  String get vitalityLogSection => 'Log';

  @override
  String get vitalityMarkRead => 'Mark as read';

  @override
  String get vitalityMarkReadDone => 'Read';

  @override
  String get vitalityMarkReadSuccess => 'Marked as read';

  @override
  String get vitalityMedicalDisclaimer =>
      'Educational content only — not medical advice.';

  @override
  String get vitalityMetricsEmpty => 'No metrics yet';

  @override
  String get vitalityMetricsLast7Days => 'Last 7 days';

  @override
  String vitalityMetricsLastEntry(int score) {
    return 'آخر تسجيل · طاقة $score/10';
  }

  @override
  String get vitalityMetricsSave => 'Save metrics';

  @override
  String get vitalityMetricsSaved => 'Saved';

  @override
  String get vitalityMetricsTapToLog => 'Tap to log';

  @override
  String get vitalityMetricsTitle => 'Daily metrics';

  @override
  String get vitalityMorningEnergy => 'Morning energy';

  @override
  String get vitalityMyProgram => 'برنامجي';

  @override
  String get vitalityNotLogged => 'Not logged';

  @override
  String get vitalityPhaseFoundation => 'Foundation';

  @override
  String get vitalityPhaseOptimization => 'Optimization';

  @override
  String get vitalityPhasePeak => 'Peak';

  @override
  String get vitalityProgramAllWeeks => 'All weeks';

  @override
  String get vitalityProgramComplete => 'Program complete';

  @override
  String get vitalityProgramContinue => 'Continue';

  @override
  String get vitalityProgramDisclaimer =>
      'Educational program — not a medical treatment.';

  @override
  String get vitalityProgramDone => 'Completed';

  @override
  String get vitalityProgramOverallProgress => 'Overall progress';

  @override
  String get vitalityProgramStartCta => 'Start program';

  @override
  String get vitalityProgramSubtitle =>
      '12 weeks to better energy, sleep and recovery';

  @override
  String get vitalityProgramTitle => 'تحول الحيوية';

  @override
  String get vitalityProtocolBadgeEarned => 'Badge unlocked!';

  @override
  String get vitalityProtocolCompleteDay => 'Complete day';

  @override
  String vitalityProtocolStreak(int days) {
    return '$days-day streak';
  }

  @override
  String get vitalityProtocolTitle => 'Protocols';

  @override
  String vitalityReadingTime(int minutes) {
    return '$minutes min read';
  }

  @override
  String get vitalityReportCompletion => 'الإنجاز';

  @override
  String get vitalityReportImproving =>
      'You\'re improving — keep the streak going.';

  @override
  String get vitalityReportKeepGoing =>
      'Small steps still count. Finish a couple tasks today.';

  @override
  String get vitalityScientificSources => 'Sources';

  @override
  String vitalityScoreBreakdown(
    int sleep,
    int workout,
    int protein,
    int stress,
  ) {
    return 'Sleep $sleep · Train $workout · Protein $protein · Stress $stress';
  }

  @override
  String get vitalityScoreLabel => 'الحيوية';

  @override
  String get vitalitySleepHint => 'How did you sleep?';

  @override
  String vitalitySleepHours(num hours) {
    return '$hours ساعة';
  }

  @override
  String get vitalitySleepLog => 'Sleep';

  @override
  String get vitalitySleepQuality => 'Quality';

  @override
  String vitalityStreak(int days) {
    return '$days-day streak';
  }

  @override
  String get vitalityStressLevel => 'Stress';

  @override
  String get vitalityUnlockNextWeek => 'Unlock next week';

  @override
  String vitalityWeekProgress(int percent) {
    return '$percent%';
  }

  @override
  String get vitalityWeekReport => 'Week report';

  @override
  String vitalityWeekX(int week) {
    return 'Week $week';
  }

  @override
  String vitalityWeekXOf12(int week) {
    return 'Week $week of 12';
  }

  @override
  String get vitalityWorkoutDone => 'Trained';

  @override
  String get vitalityWorkoutLog => 'Workout';

  @override
  String get vitalityWorkoutPending => 'Rest / not yet';

  @override
  String get vitalityWorkoutPerformance => 'Performance';

  @override
  String walkingEstimatedMinutes(int minutes) {
    return '~$minutes min';
  }

  @override
  String get walkingHealthBanner => 'خطوات لايف من عدّاد الموبايل';

  @override
  String get walkingManualStepsLabel => 'Steps today';

  @override
  String get walkingUpdateSteps => 'Update steps';

  @override
  String get walkingWebManualBanner => 'On web, enter steps manually';

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
  String get todayPlanVitalitySleepSubtitle => 'سجّل 7.5+ ساعات في Vitality';

  @override
  String get todayPlanVitalityProteinSubtitle => 'حقّق هدف البروtein';

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
  String get todayPlanProtocolItem => 'بروتوكول Vitality';

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
}
