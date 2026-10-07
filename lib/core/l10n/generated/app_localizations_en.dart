// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vireo';

  @override
  String get homeTitle => 'Home';

  @override
  String get onboardingTitle => 'Welcome';

  @override
  String get workoutTitle => 'Workout';

  @override
  String get nutritionTitle => 'Nutrition';

  @override
  String get progressTitle => 'Progress';

  @override
  String get profileTitle => 'Profile';

  @override
  String get authTitle => 'Sign In';

  @override
  String get languageToggle => 'العربية';

  @override
  String get setupComplete => 'Vireo is ready';

  @override
  String get continueButton => 'Continue';

  @override
  String get skipButton => 'Skip';

  @override
  String get finishButton => 'Finish';

  @override
  String get yesButton => 'Yes';

  @override
  String get noButton => 'No';

  @override
  String onboardingStepProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get onboardingStep1Title => 'About you';

  @override
  String get onboardingStep1Subtitle =>
      'We\'ll personalize your plan from these basics.';

  @override
  String get onboardingStep2Title => 'Health screening';

  @override
  String get onboardingStep2Subtitle =>
      'Answer honestly — this helps us keep workouts safer.';

  @override
  String get onboardingStep3Title => 'Where you train';

  @override
  String get onboardingStep3Subtitle =>
      'We\'ll only show exercises that match your setup.';

  @override
  String get onboardingStep4Title => 'Your goal';

  @override
  String get onboardingStep4Subtitle => 'What matters most right now?';

  @override
  String get onboardingStep5Title => 'Before we start';

  @override
  String get onboardingStep5Subtitle => 'Please read and accept to continue.';

  @override
  String get onboardingStep6Title => 'Stay on track';

  @override
  String get onboardingStep6Subtitle =>
      'Optional reminders — you can change these later.';

  @override
  String get unitsMetric => 'kg / cm';

  @override
  String get unitsImperial => 'lb / in';

  @override
  String get onboardingAge => 'Age';

  @override
  String get onboardingHeight => 'Height';

  @override
  String get onboardingWeight => 'Weight';

  @override
  String get onboardingActivityLevel => 'Activity level';

  @override
  String get onboardingDietaryOptional => 'Dietary restrictions (optional)';

  @override
  String get activitySedentary => 'Mostly sedentary';

  @override
  String get activityModerate => 'Moderately active';

  @override
  String get activityVeryActive => 'Very active';

  @override
  String get dietHalal => 'Halal';

  @override
  String get dietVegetarian => 'Vegetarian';

  @override
  String get dietVegan => 'Vegan';

  @override
  String get dietGlutenFree => 'Gluten-free';

  @override
  String get dietDairyFree => 'Dairy-free';

  @override
  String get dietLowSodium => 'Low sodium';

  @override
  String get dietLowCarb => 'Low carb';

  @override
  String get dietDiabeticFriendly => 'Diabetic-friendly';

  @override
  String get onboardingMedicalFlagNotice =>
      'We\'ll adjust intensity and show in-workout safety reminders.';

  @override
  String get healthQuestionHeart =>
      'Heart disease or cardiovascular condition?';

  @override
  String get healthQuestionDiabetes => 'Diabetes or blood sugar condition?';

  @override
  String get healthQuestionBloodPressure => 'High or low blood pressure?';

  @override
  String get healthQuestionJoints => 'Joint injuries or chronic pain?';

  @override
  String get healthQuestionMedications =>
      'Currently taking regular medications?';

  @override
  String get envHomeNoEquipment => 'Home — no equipment';

  @override
  String get envHomeNoEquipmentDesc => 'Bodyweight exercises only';

  @override
  String get envHomeLightEquipment => 'Home — light equipment';

  @override
  String get envHomeLightEquipmentDesc => 'Bands, dumbbells, or similar';

  @override
  String get envGymFull => 'Full gym';

  @override
  String get envGymFullDesc => 'Machines, barbells, full rack access';

  @override
  String get envWalkingOnly => 'Walking only';

  @override
  String get envWalkingOnlyDesc => 'Step goals and light mobility';

  @override
  String get goalWeightLoss => 'Weight loss';

  @override
  String get goalWeightLossDesc => 'Fat loss with sustainable training';

  @override
  String get goalMuscleGain => 'Muscle gain';

  @override
  String get goalMuscleGainDesc => 'Strength and lean mass focus';

  @override
  String get goalGeneralVitality => 'General vitality';

  @override
  String get goalGeneralVitalityDesc => 'Energy, consistency, feeling better';

  @override
  String get goalAllOfAbove => 'All of the above';

  @override
  String get goalAllOfAboveDesc => 'Balanced plan across goals';

  @override
  String get legalDisclaimerText =>
      'Vireo is an organizational fitness tool and is not a substitute for direct medical advice. Content (workouts, meal plans, and health information) is for general guidance only.\n\nIf you have any chronic condition — such as heart disease, diabetes, high blood pressure, or current joint injuries — or take medication, consult your doctor before starting any exercise or nutrition program.\n\nDietary supplements and hormone-related guidance (such as testosterone) are general educational information only. They are not medical prescriptions or treatment recommendations.\n\nBy participating in any in-app program, I confirm I have read the terms and understand Vireo is not liable for injury or health complications from using the app without medical consultation.';

  @override
  String get legalDisclaimerSection1 =>
      'Vireo is an organizational fitness tool and is not a substitute for direct medical advice. Content (workouts, meal plans, and health information) is for general guidance only.';

  @override
  String get legalDisclaimerSection2 =>
      'If you have any chronic condition — such as heart disease, diabetes, high blood pressure, or current joint injuries — or take medication, consult your doctor before starting any exercise or nutrition program.';

  @override
  String get legalDisclaimerSection3 =>
      'Dietary supplements are general educational information only. They are not medical prescriptions or treatment recommendations.';

  @override
  String get legalDisclaimerSection4 =>
      'Hormone-related guidance (such as testosterone) is general educational information only. It is not a medical prescription or treatment recommendation.';

  @override
  String get legalDisclaimerSection5 =>
      'By participating in any in-app program, I confirm I have read the terms and understand Vireo is not liable for injury or health complications from using the app without medical consultation.';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get consentCheckboxLabel =>
      'I have read and agree to the terms and health disclaimer';

  @override
  String get notificationWorkoutTime => 'Preferred workout time';

  @override
  String get notificationWalkingReminder => 'Daily walking reminder';

  @override
  String get notificationWeeklyCheckIn => 'Weekly check-in reminder';

  @override
  String get notificationNotSet => 'Not set';

  @override
  String get authWelcomeTitle => 'Welcome to Vireo';

  @override
  String get authWelcomeSubtitle =>
      'Sign in to sync progress across devices, or continue locally as a guest.';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithEmail => 'Sign in with email';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authSignUp => 'Sign up';

  @override
  String get authHasAccount => 'Already have an account?';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authSignedIn => 'Signed in';

  @override
  String get authErrorGeneric => 'Something went wrong. Please try again.';

  @override
  String get signOut => 'Sign out';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get guestModeTitle => 'Guest mode';

  @override
  String get guestModeSubtitle =>
      'Your progress is saved on this device only. Create an account to sync and subscribe.';

  @override
  String get profileStatWorkoutsLabel => 'Workouts completed';

  @override
  String get profileStatStreakLabel => 'Day streak';

  @override
  String get saveProgressToCloud => 'Save progress to cloud';

  @override
  String get profileCloudSynced => 'Progress synced to your account';

  @override
  String get authGateTitle => 'Create an account';

  @override
  String get authGateSaveProgress =>
      'Create a free account to save your progress to the cloud and access it on any device.';

  @override
  String get authGateSubscribe =>
      'Create an account before subscribing so your premium access is linked to you.';

  @override
  String get authGateSignUp => 'Sign up';

  @override
  String get authGateNotNow => 'Not now';

  @override
  String get deleteAccountTitle => 'Delete account';

  @override
  String get deleteAccountWarningTitle => 'This cannot be undone';

  @override
  String get deleteAccountWarningBody =>
      'All your profile data, workout logs, meal plans, and progress photos will be permanently deleted from our servers.';

  @override
  String get deleteAccountCancel => 'Cancel';

  @override
  String get deleteAccountContinue => 'Continue';

  @override
  String get deleteAccountConfirmTitle => 'Confirm deletion';

  @override
  String get deleteAccountConfirmInstructions =>
      'Type the word below exactly to confirm permanent account deletion:';

  @override
  String get deleteConfirmationWord => 'DELETE';

  @override
  String get deleteAccountTypeHint => 'Type DELETE';

  @override
  String get deleteAccountConfirmButton => 'Delete my account permanently';

  @override
  String get deleteAccountSuccess => 'Your account has been deleted.';

  @override
  String get workoutMedicalWarning =>
      'You indicated a health condition during onboarding. Stop if you feel pain, dizziness, or shortness of breath. Consult your doctor before intense exercise.';

  @override
  String get workoutWarmUpTitle => 'Warm-up';

  @override
  String get workoutWarmUpSubtitle =>
      'Complete these mobility exercises before your main workout.';

  @override
  String get workoutCoolDownTitle => 'Cool-down';

  @override
  String get workoutCoolDownSubtitle =>
      'Gentle mobility to help your body recover.';

  @override
  String get workoutActiveTitle => 'Active workout';

  @override
  String get workoutBeginWorkout => 'Begin workout';

  @override
  String get workoutFinishCoolDown => 'Finish cool-down';

  @override
  String get workoutStartButton => 'Start today\'s workout';

  @override
  String get workoutTodayTitle => 'Today\'s program';

  @override
  String workoutTodaySubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count main exercises',
      one: '1 main exercise',
    );
    return '$_temp0';
  }

  @override
  String workoutPhaseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises',
      one: '1 exercise',
    );
    return '$_temp0';
  }

  @override
  String get workoutExerciseProgress => 'Exercise';

  @override
  String get workoutStatSets => 'Sets';

  @override
  String get workoutStatReps => 'Reps';

  @override
  String get workoutStatRest => 'Rest';

  @override
  String get workoutSetsLabel => 'Sets';

  @override
  String workoutSetNumber(int number) {
    return 'Set $number';
  }

  @override
  String get workoutPrevious => 'Previous';

  @override
  String get workoutNext => 'Next';

  @override
  String get workoutSwapExercise => 'Swap exercise';

  @override
  String get workoutSwapTitle => 'Swap exercise';

  @override
  String get workoutSwapSubtitle =>
      'Alternatives for the same muscle group and your training environment.';

  @override
  String get workoutSwapEmpty => 'No alternatives available right now.';

  @override
  String get workoutRestTitle => 'Rest';

  @override
  String get workoutRestSkip => 'Skip';

  @override
  String get workoutRestAdd15 => '+15s';

  @override
  String get workoutPausedTitle => 'Workout paused';

  @override
  String get workoutResume => 'Resume';

  @override
  String get workoutEndWorkout => 'End workout';

  @override
  String get workoutRestart => 'Restart workout';

  @override
  String get workoutEndConfirmTitle => 'End workout?';

  @override
  String get workoutEndConfirmBody =>
      'Your progress in this session will not be saved.';

  @override
  String get workoutFeedbackTitle => 'How was this workout?';

  @override
  String get workoutFeedbackEasy => 'Easy';

  @override
  String get workoutFeedbackJustRight => 'Just right';

  @override
  String get workoutFeedbackHard => 'Hard';

  @override
  String get workoutVideoUnavailable => 'Video unavailable';

  @override
  String get workoutEmptyProgram => 'No exercises scheduled for today.';

  @override
  String get walkingTitle => 'Walking';

  @override
  String get walkingStepsToday => 'steps today';

  @override
  String walkingDailyGoal(int steps) {
    return 'Goal: $steps steps';
  }

  @override
  String walkingGoalProgress(int percent) {
    return '$percent% of today\'s goal';
  }

  @override
  String get walkingWeeklyChartTitle => 'Last 7 days';

  @override
  String get walkingHealthSourceNote =>
      'Steps are counted on this device. If Health Connect / Apple Health is also available, Vireo shows the higher count.';

  @override
  String get walkingPermissionTitle => 'Steps access needed';

  @override
  String get walkingPermissionBody =>
      'Vireo counts steps with your phone’s motion sensors. Allow activity access so walking goals and calories stay accurate.';

  @override
  String get walkingOpenSettings => 'Open Settings';

  @override
  String get walkingTryAgain => 'Try again';

  @override
  String get walkingUnavailableTitle => 'Walking tracker unavailable';

  @override
  String get walkingUnavailableBody =>
      'Step tracking works best on a physical iOS or Android phone with a step counter sensor.';

  @override
  String get walkingEnableTitle => 'Count steps on this phone';

  @override
  String get walkingEnableBody =>
      'Vireo uses your phone’s step sensor to track walking live — distance, calories, and your daily goal. We’ll ask for activity permission next.';

  @override
  String get walkingEnableCta => 'Enable step counting';

  @override
  String get walkingActiveMinutes => 'Active time';

  @override
  String get nutritionTabBreakfast => 'Breakfast';

  @override
  String get nutritionTabLunch => 'Lunch';

  @override
  String get nutritionTabDinner => 'Dinner';

  @override
  String get nutritionTabSnack => 'Snack';

  @override
  String get nutritionNoMealPlanned => 'No meal planned for today.';

  @override
  String nutritionPrepMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get nutritionTagHighProtein => 'High protein';

  @override
  String get nutritionTagQuickEasy => 'Quick & easy';

  @override
  String get nutritionTagLightEnergy => 'Light energy';

  @override
  String get nutritionScanFridge => 'Scan your fridge';

  @override
  String nutritionScansRemaining(int count) {
    return '$count fridge scans left this month';
  }

  @override
  String get nutritionScanPrompt =>
      'Take a photo of your fridge or pantry to detect ingredients.';

  @override
  String get nutritionTakePhoto => 'Take photo';

  @override
  String get nutritionChoosePhoto => 'Choose from gallery';

  @override
  String get nutritionScanning => 'Scanning ingredients…';

  @override
  String get nutritionScanFailed =>
      'Scan failed. Try again or enter ingredients manually.';

  @override
  String get nutritionScanLimitReached =>
      'Monthly scan limit reached. Upgrade for unlimited scans.';

  @override
  String get nutritionConfirmIngredients => 'Confirm ingredients';

  @override
  String get nutritionIngredientsHint =>
      'Remove anything incorrect and add missing items.';

  @override
  String get nutritionAddIngredient => 'Add ingredient';

  @override
  String get nutritionGetRecipes => 'Get recipe ideas';

  @override
  String get nutritionNoIngredients => 'Add at least one ingredient.';

  @override
  String get nutritionRecipeSuggestions => 'Recipe ideas';

  @override
  String get nutritionRecipeSuggestionsSubtitle =>
      'Based on your ingredients, goal, and dietary preferences.';

  @override
  String get nutritionNoRecipesFound => 'No matching recipes found.';

  @override
  String get nutritionManualEntry => 'Enter manually';

  @override
  String get nutritionManualEntryHint =>
      'Type what you have on hand — we\'ll suggest recipes that match your goal and dietary preferences.';

  @override
  String get nutritionSwapMeal => 'Swap meal';

  @override
  String get nutritionSwapMealSubtitle =>
      'Pick a different recipe — no repeats within 14 days.';

  @override
  String get nutritionSwapMealEmpty =>
      'No alternative meals available right now.';

  @override
  String get nutritionDemoQuickMeals => 'Quick healthy demo meals';

  @override
  String get nutritionTryDemoScan => 'Try demo scan';

  @override
  String get homeWelcomeSubtitle => 'Your personalized fitness hub.';

  @override
  String get homeWalkingCardSubtitle =>
      'Track daily steps from Apple Health or Health Connect.';

  @override
  String get homeDailyProgramTitle => 'Daily program';

  @override
  String get homeTodayWorkout => 'Today\'s workout';

  @override
  String get homeNextMeal => 'Next meal';

  @override
  String homeWorkoutExerciseCount(int count) {
    return '$count exercises';
  }

  @override
  String get progressTabWeight => 'Weight';

  @override
  String get progressTabAdherence => 'Adherence';

  @override
  String get progressTabEnergy => 'Energy';

  @override
  String get progressWeightChartTitle => 'Weight trend';

  @override
  String progressWeightGoalLine(String value, String unit) {
    return 'Goal: $value $unit';
  }

  @override
  String get progressAdherenceChartTitle => 'Weekly adherence';

  @override
  String get progressAdherenceSubtitle => 'Workout completion % per week';

  @override
  String get progressEnergyChartTitle => 'Energy levels';

  @override
  String get progressEnergySubtitle => 'Weekly check-in energy score (1–10)';

  @override
  String get progressLogWeight => 'Log weight';

  @override
  String progressWeightLabel(String unit) {
    return 'Weight ($unit)';
  }

  @override
  String get progressLogDate => 'Date';

  @override
  String get progressSaveWeight => 'Save';

  @override
  String get reassessmentTitle => 'Monthly check-in';

  @override
  String get reassessmentSubtitle =>
      'Update your weight, activity, and training setup so we can keep your program accurate.';

  @override
  String get reassessmentLater => 'Later';

  @override
  String get reassessmentSubmit => 'Update my plan';

  @override
  String get reassessmentSummaryTitle => 'What changed';

  @override
  String get reassessmentSummarySubtitle => 'Compared to your last check-in';

  @override
  String reassessmentPhaseUpdated(int phase) {
    return 'Program phase updated to phase $phase';
  }

  @override
  String get reassessmentNoPhaseChange =>
      'No program changes needed — keep going!';

  @override
  String get paywallTitle => 'Vireo Premium';

  @override
  String get paywallHeadline => 'Unlock your full potential';

  @override
  String get paywallSubtitle =>
      'Premium gives you unlimited scans, full program phases, and deeper progress insights.';

  @override
  String get paywallBestValue => 'Best Value';

  @override
  String get paywallPlanMonthly => 'Monthly';

  @override
  String get paywallPlanAnnual => 'Annual';

  @override
  String get paywallPlanLifetime => 'Lifetime';

  @override
  String get paywallFeatureUnlimitedScans => 'Unlimited fridge scans';

  @override
  String get paywallFeatureFullProgram =>
      'Full program phases & progressive workouts';

  @override
  String get paywallFeatureCloudSync => 'Cloud sync across devices';

  @override
  String get paywallFeatureProgressAnalytics => 'Advanced progress analytics';

  @override
  String get paywallSubscribe => 'Subscribe';

  @override
  String get paywallRestorePurchases => 'Restore purchases';

  @override
  String get paywallPurchaseSuccess => 'Welcome to Premium!';

  @override
  String get paywallPurchaseError => 'Purchase failed. Please try again.';

  @override
  String get paywallRestoreSuccess => 'Purchases restored successfully.';

  @override
  String get paywallRestoreEmpty =>
      'No active subscription found for this account.';

  @override
  String get paywallRestoreError =>
      'Could not restore purchases. Try again later.';

  @override
  String get paywallNotConfigured =>
      'Subscriptions are not available in this build.';

  @override
  String get paywallSubscriptionExpiredMessage =>
      'Your subscription has expired. Resubscribe to unlock premium features.';

  @override
  String get trialEndedTitle => 'Your trial has ended';

  @override
  String get trialEndedBody =>
      'Thanks for trying Vireo Premium. Subscribe to keep unlimited scans, full program phases, and cloud sync.';

  @override
  String get trialEndedViewPlans => 'View plans';

  @override
  String subscriptionTrialDaysRemaining(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days left in your free trial',
      one: '1 day left in your free trial',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionExpiredBanner =>
      'Subscription expired — tap to renew premium access';

  @override
  String get subscriptionPremiumActive => 'Premium active';

  @override
  String get subscriptionFreeTier => 'Free plan';

  @override
  String get subscriptionUpgrade => 'Upgrade';

  @override
  String get settingsManageSubscription =>
      'View plans, subscribe, or restore purchases';

  @override
  String workoutPhaseLockedTitle(int phase) {
    return 'Phase $phase locked';
  }

  @override
  String get workoutPhaseLockedBody =>
      'Resubscribe to continue your full training program. Basic tracking remains available on the free plan.';

  @override
  String homeGreeting(String name) {
    return 'Hello $name 👋';
  }

  @override
  String homeDayPhase(int day, String phase) {
    return 'Day $day · $phase phase';
  }

  @override
  String get homeGuestBanner =>
      'You\'re in guest mode — sign up to save your progress';

  @override
  String get homeGuestSignUp => 'Sign up';

  @override
  String get homeGuestCta => 'Sign up now — free for 7 days';

  @override
  String homeStreakDays(int days) {
    return '$days day streak';
  }

  @override
  String get homeStartStreak => 'Start your streak today';

  @override
  String get homeTodayWorkoutTitle => 'Today\'s workout';

  @override
  String get homeStartWorkout => 'Start workout';

  @override
  String get homeRestDay => 'Active rest day 🧘';

  @override
  String get homeBreakfast => 'Breakfast';

  @override
  String get homeMealConfirmed => 'Confirmed ✓';

  @override
  String get homeMealPending => 'Pending';

  @override
  String homeWalkingSteps(int current, int goal) {
    return '$current / $goal steps';
  }

  @override
  String homeWeeklyProgress(int completed) {
    return '$completed / 7 days complete';
  }

  @override
  String get homeCheckInBanner => '⏱️ Weekly check-in ready — just one minute';

  @override
  String get homeRecoveryScore => 'Recovery score';

  @override
  String get homeRecoveryReady => 'Your body is ready to train';

  @override
  String get homeGuestName => 'Champion';

  @override
  String get homePhaseFoundation => 'Foundation';

  @override
  String get nutritionFilterAll => 'All';

  @override
  String get nutritionFilterQuick => 'Quick';

  @override
  String get nutritionFilterLowCalorie => 'Low calorie';

  @override
  String nutritionMacroSummary(int calories, int protein) {
    return '$calories cal · ${protein}g protein';
  }

  @override
  String get nutritionMacroBar => 'Cal | Protein | Carbs | Fat';

  @override
  String get nutritionMealConfirmed => 'Confirmed ✓';

  @override
  String nutritionFridgeBanner(int remaining) {
    return '📷 Scan your fridge — $remaining scans left this month';
  }

  @override
  String get nutritionFridgeScanCta => 'Scan';

  @override
  String get workoutWarmUpStep1 => 'Shoulder circles — 30 seconds';

  @override
  String get workoutWarmUpStep2 => 'March in place — 60 seconds';

  @override
  String get workoutWarmUpStep3 => 'Light squats — 10 reps';

  @override
  String get workoutSkipWarmUp => 'Skip warm-up';

  @override
  String get workoutStartMainWorkout => 'Start main workout';

  @override
  String get workoutWarmUpComplete => 'Warm-up done — ready!';

  @override
  String homeProgramDay(int day, int total) {
    return 'Day $day of $total';
  }

  @override
  String get homeStartProgram => 'Start your program';

  @override
  String get nutritionDailyCalorieGoal => 'Your daily calorie target';

  @override
  String nutritionCalorieTargetSummary(
    int calories,
    int protein,
    int carbs,
    int fat,
  ) {
    return 'Target: $calories cal — ${protein}g protein, ${carbs}g carbs, ${fat}g fat';
  }

  @override
  String nutritionCalorieProgress(int consumed, int target) {
    return '$consumed / $target cal today';
  }

  @override
  String get nutritionEditCalorieGoal => 'Edit calorie target';

  @override
  String get nutritionCalorieHint => 'Daily calories';

  @override
  String get settingsThemeTitle => 'Appearance';

  @override
  String get settingsThemeDark => 'Dark mode';

  @override
  String get settingsThemeLight => 'Light mode';

  @override
  String get settingsThemeSystem => 'System default';

  @override
  String get progressAxisDate => 'Date';

  @override
  String get progressAxisWeight => 'Weight (kg)';

  @override
  String get progressAxisEnergy => 'Energy (1–10)';

  @override
  String get progressAllChartsTitle => 'Your progress overview';

  @override
  String get profileGuestAvatar => 'Guest';

  @override
  String get profileStatProgramDays => 'Program days';

  @override
  String get profileStatsSection => 'Your stats';

  @override
  String get profileGoalWeight => 'Goal weight';

  @override
  String get profileCurrentBmi => 'Current BMI';

  @override
  String get profileActivityLevel => 'Activity level';

  @override
  String get profileEditProfile => 'Edit profile';

  @override
  String get profileBmiUnderweight => 'Underweight';

  @override
  String get profileBmiHealthy => 'Healthy weight';

  @override
  String get profileBmiOverweight => 'Overweight';

  @override
  String get profileBmiObese => 'Obese';

  @override
  String get profileBmiTooltip =>
      'BMI (Body Mass Index) estimates body fat from height and weight. It is a general guide — not a diagnosis.';

  @override
  String get workoutSplitChestTriceps => 'Chest & Triceps';

  @override
  String get workoutSplitBackBiceps => 'Back & Biceps';

  @override
  String get workoutSplitLegs => 'Legs';

  @override
  String get workoutSplitCardio => 'Cardio';

  @override
  String get workoutSplitShoulders => 'Shoulders';

  @override
  String get workoutSplitFullBody => 'Full Body';

  @override
  String get workoutSplitRest => 'Rest day';

  @override
  String get habitsTitle => 'Daily habits';

  @override
  String get habitsEmpty => 'No habits yet — tap + to add your first one';

  @override
  String get habitsAddTitle => 'New habit';

  @override
  String get habitsAddHint => 'Habit name';

  @override
  String get habitsAddConfirm => 'Add';

  @override
  String habitsStreak(int days) {
    return '$days day streak';
  }

  @override
  String get habitsRetry => 'Retry';

  @override
  String get habitsErrorTitle => 'Could not load habits';

  @override
  String homeRecoveryExplain(int score) {
    return 'A recovery score of $score% blends sleep quality, rest days, and muscle fatigue. Higher means your body is ready to train hard.';
  }

  @override
  String get homeRecoveryFactorSleep => 'Sleep quality';

  @override
  String get homeRecoveryFactorRest => 'Rest days';

  @override
  String get homeRecoveryFactorMuscle => 'Muscle fatigue';

  @override
  String get homeRecoveryTipSleep => 'Aim for 7–9 hours tonight';

  @override
  String get homeRecoveryTipRest => 'Keep at least one full rest day weekly';

  @override
  String get homeRecoveryTipMuscle => 'Ease intensity if soreness is high';

  @override
  String get homeRecoveryImproveTitle => 'Tips to improve';

  @override
  String get homeRecoveryImproveBody =>
      'Prioritize sleep, hydrate, and swap a hard session for mobility when fatigue spikes.';

  @override
  String get walkingMetricsTitle => 'Today\'s walking metrics';

  @override
  String get walkingDistance => 'Distance';

  @override
  String get walkingSpeed => 'Speed';

  @override
  String get walkingPace => 'Pace';

  @override
  String get walkingCalories => 'Calories burned';

  @override
  String walkingWeightLoss(String kg) {
    return 'Est. fat burn ≈ $kg kg';
  }

  @override
  String walkingCadence(int spm) {
    return 'Cadence ≈ $spm steps/min';
  }

  @override
  String get walkingMetricsEstimatedNote =>
      'Health Connect unavailable — showing estimated metrics from step count.';

  @override
  String get mealBuilderTitle => 'Customize ingredients';

  @override
  String mealBuilderTitleFor(String meal) {
    return 'Customize $meal';
  }

  @override
  String get mealBuilderSubtitle =>
      'Adjust protein, cooking fat, and add-ons — macros update live.';

  @override
  String get mealBuilderEggs => 'Eggs';

  @override
  String mealBuilderEggCount(int count) {
    return '$count eggs';
  }

  @override
  String mealBuilderPortionCount(int count) {
    return '$count portions';
  }

  @override
  String get mealBuilderProteinLunch => 'Protein portions';

  @override
  String get mealBuilderProteinDinner => 'Dinner protein';

  @override
  String get mealBuilderProteinSnack => 'Snack protein';

  @override
  String get mealBuilderFatSource => 'Fat source';

  @override
  String get mealBuilderFatButter => 'Butter';

  @override
  String get mealBuilderFatGhee => 'Ghee';

  @override
  String get mealBuilderFatOliveOil => 'Olive oil';

  @override
  String get mealBuilderFatSpray => 'Oil spray';

  @override
  String get mealBuilderAddOns => 'Add-ons';

  @override
  String get mealBuilderAddonCheese => 'Cheese';

  @override
  String get mealBuilderAddonVeggies => 'Vegetables';

  @override
  String get mealBuilderAddonBread => 'Whole grain bread';

  @override
  String get mealBuilderAddonRice => 'Rice';

  @override
  String get mealBuilderAddonYogurt => 'Yogurt';

  @override
  String get mealBuilderLiveMacros => 'Live macros';

  @override
  String get weeklyCheckInTitle => 'Weekly check-in';

  @override
  String get weeklyCheckInBanner =>
      'Time for your weekly assessment — update weight & energy';

  @override
  String get weeklyCheckInSubtitle =>
      'We\'ll recalculate your BMR/TDEE and macros for next week.';

  @override
  String get weeklyCheckInWeight => 'Current weight';

  @override
  String get weeklyCheckInWaist => 'Waist measurement';

  @override
  String get weeklyCheckInEnergy => 'Energy level (1–5)';

  @override
  String weeklyCheckInAdherence(int pct) {
    return 'Training adherence: $pct%';
  }

  @override
  String get weeklyCheckInSubmit => 'Update my targets';

  @override
  String get weeklyCheckInDoneTitle => 'Targets updated';

  @override
  String weeklyCheckInDoneBody(
    int prev,
    int next,
    int protein,
    int carbs,
    int fat,
  ) {
    return 'Calories $prev → $next kcal. Macros: ${protein}g protein, ${carbs}g carbs, ${fat}g fat.';
  }

  @override
  String get settingsAccentTitle => 'Accent color';

  @override
  String get settingsAccentOrange => 'Orange';

  @override
  String get settingsAccentEmerald => 'Emerald';

  @override
  String get settingsAccentBlue => 'Ocean';

  @override
  String get settingsAccentViolet => 'Violet';

  @override
  String get settingsSkinTitle => 'Color theme skins';

  @override
  String get settingsSkinStandard => 'Standard';

  @override
  String get settingsSkinStandardDesc => 'Classic Vireo dark / light';

  @override
  String get settingsSkinAmoled => 'AMOLED Pure Black';

  @override
  String get settingsSkinAmoledDesc => 'True black with gold & cyan accents';

  @override
  String get settingsSkinNavy => 'Deep Navy Blue';

  @override
  String get settingsSkinNavyDesc => 'Navy #0B192C with ice blue & teal';

  @override
  String get settingsAccentLockedHint =>
      'Accent swatches are locked while AMOLED / Navy skin is active.';

  @override
  String get workoutSwapWarmUp => 'Swap warm-up move';

  @override
  String get workoutSwapWarmUpTitle => 'Choose a warm-up alternative';

  @override
  String get workoutSwapWarmUpSubtitle =>
      'Mobility and low-impact options for your training environment.';

  @override
  String get profileBmiExplainShort =>
      'BMI assesses weight relative to height.';

  @override
  String get profileBmiExplainFull =>
      'Body Mass Index (BMI) is a measure to assess weight relative to height. It is a general screening tool — not a medical diagnosis.';

  @override
  String get mealBuilderCheeseTitle => 'Cheese';

  @override
  String get mealBuilderCheeseNone => 'No cheese';

  @override
  String get mealBuilderCheeseCottage => 'Cottage cheese';

  @override
  String get mealBuilderCheeseCheddar => 'Cheddar';

  @override
  String get mealBuilderCheeseMozzarella => 'Mozzarella';

  @override
  String get mealBuilderCheeseFeta => 'Feta';

  @override
  String mealBuilderCheeseGrams(int grams) {
    return 'Quantity: ${grams}g';
  }

  @override
  String get homeRecoveryFormulaExplain =>
      'Recovery = Rest days (40%) + Step target (30%) + Meal/workout consistency (30%).';

  @override
  String get homeRecoveryFactorRestDays => 'Rest days';

  @override
  String get homeRecoveryFactorSteps => 'Step count target';

  @override
  String get homeRecoveryFactorConsistency => 'Meal & workout consistency';

  @override
  String homeRecoveryRestDetail(int days) {
    return '$days rest day(s) this week';
  }

  @override
  String homeRecoveryStepsDetail(int current, int goal) {
    return '$current / $goal steps today';
  }

  @override
  String homeRecoveryConsistencyDetail(
    int mealsDone,
    int mealsTotal,
    int wDone,
    int wTotal,
  ) {
    return 'Meals $mealsDone/$mealsTotal · Workouts $wDone/$wTotal';
  }

  @override
  String get homeRecoveryTipSteps =>
      'Hit your daily step goal to lift this pillar';

  @override
  String get homeRecoveryTipConsistency =>
      'Confirm meals and finish planned workouts';

  @override
  String homeRecoveryMathLine(int rest, int steps, int consistency, int total) {
    return '$rest + $steps + $consistency = $total%';
  }

  @override
  String get cardioTitle => 'Cardio & daily activity';

  @override
  String get cardioSubtitle =>
      'Log brisk walks, runs, and more — calories use MET × weight × time.';

  @override
  String get cardioSelectActivity => 'Activity';

  @override
  String cardioDuration(int minutes) {
    return 'Duration: $minutes min';
  }

  @override
  String cardioEstimatedBurn(int kcal) {
    return 'Est. burn: $kcal kcal';
  }

  @override
  String cardioMetHint(String met) {
    return 'MET $met · formula: MET × kg × hours';
  }

  @override
  String get cardioLogButton => 'Log activity';

  @override
  String get cardioLoggedSnack => 'Cardio session logged';

  @override
  String cardioTodayTotal(int kcal) {
    return 'Burned today: $kcal kcal';
  }

  @override
  String get cardioEmpty =>
      'No cardio logged yet — add your first session above.';

  @override
  String cardioLogSubtitle(int minutes, int kcal) {
    return '$minutes min · $kcal kcal';
  }

  @override
  String get cardioLogCta => 'Log cardio activity';

  @override
  String get cardioBriskWalking => 'Brisk walking';

  @override
  String get cardioRunning => 'Running';

  @override
  String get cardioCycling => 'Cycling';

  @override
  String get cardioSwimming => 'Swimming';

  @override
  String get cardioJumpRope => 'Jump rope';

  @override
  String get cardioHiit => 'HIIT';

  @override
  String get cardioElliptical => 'Elliptical';

  @override
  String workoutGoalPlanLabel(String goal) {
    return 'Plan for: $goal';
  }

  @override
  String get aiScanTitle => 'AI Meal Scanner';

  @override
  String get aiScanPrompt =>
      'Photograph your meal — AI estimates calories and macros from the portion size.';

  @override
  String get aiScanCamera => 'Camera';

  @override
  String get aiScanGallery => 'Gallery';

  @override
  String get aiScanAnalyzing => 'Analyzing meal…';

  @override
  String get aiScanOffline =>
      'No internet connection. Check your network and try again.';

  @override
  String get aiScanFailed => 'Scan failed. Please try again.';

  @override
  String get aiScanParseError =>
      'Could not read the analysis. Try another photo or enter manually.';

  @override
  String get aiScanConfigError =>
      'AI scanner is not configured. Add GEMINI_API_KEY to enable.';

  @override
  String get aiScanTryAgain => 'Try again';

  @override
  String get aiScanManualEntry => 'Manual entry';

  @override
  String get aiScanCardTitle => 'Scan your meal with AI';

  @override
  String get aiScanCardSubtitle =>
      'Snap a photo — get calories, macros, and smart swaps instantly.';

  @override
  String get aiScanSaveToLog => 'Save to log';

  @override
  String get aiScanSavedSnack => 'Meal saved to today\'s log';

  @override
  String get aiScanMacroProtein => 'Protein';

  @override
  String get aiScanMacroCarbs => 'Carbs';

  @override
  String get aiScanMacroFats => 'Fats';

  @override
  String get aiScanSmartSwaps => 'Smart swaps';

  @override
  String aiScanCaloriesChip(int calories) {
    return '$calories kcal';
  }

  @override
  String get aiCoachTitle => 'Vireo AI';

  @override
  String get aiCoachFabLabel => 'Vireo AI';

  @override
  String get aiCoachInputHint => 'Ask about meals, macros, or training…';

  @override
  String get aiCoachOfflineBanner =>
      'You are offline — showing cached messages.';

  @override
  String get aiCoachChipDinner => 'Suggest a dinner meal';

  @override
  String get aiCoachChipProtein => 'How do I boost protein?';

  @override
  String get aiCoachChipDessert => 'Healthy dessert swap';

  @override
  String get waterTrackerTitle => 'Water intake';

  @override
  String waterTrackerSummary(double current, double goal, int percent) {
    return '${current}L / ${goal}L — $percent% completed';
  }

  @override
  String get weeklyDeficitChartTitle => 'Weekly calorie balance';

  @override
  String get weeklyDeficitSubtitle =>
      'TDEE − meals + cardio burn (last 7 days)';

  @override
  String weeklyDeficitTotal(int kcal) {
    return 'Weekly net balance: $kcal kcal';
  }

  @override
  String get weeklyDeficitEmpty =>
      'Log meals or cardio to see your weekly calorie balance.';

  @override
  String weeklyDeficitTooltip(int net, int consumed, int burned) {
    return '$net kcal\nIn: $consumed · Out: $burned';
  }

  @override
  String uxGoodMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String uxGoodAfternoon(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String uxGoodEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String get uxTodayOverline => 'TODAY';

  @override
  String get uxCaloriesLeft => 'kcal left';

  @override
  String get uxCaloriesOver => 'kcal over';

  @override
  String get uxGoal => 'Goal';

  @override
  String get uxEaten => 'Eaten';

  @override
  String get uxBurned => 'Burned';

  @override
  String get uxActionScan => 'Scan meal';

  @override
  String get uxActionTrain => 'Train';

  @override
  String get uxActionCoach => 'AI Coach';

  @override
  String get uxSectionTraining => 'Today\'s training';

  @override
  String get uxSectionThisWeek => 'This week';

  @override
  String get uxSectionTodayLog => 'Today\'s log';

  @override
  String get uxAddMeal => '+ Add meal';

  @override
  String get uxAiScanned => 'AI scan';

  @override
  String get uxMealRemoved => 'Meal removed';

  @override
  String get uxLogEmptyTitle => 'Nothing logged yet';

  @override
  String get uxLogEmptyBody =>
      'Snap a photo of your meal — AI counts the calories and macros in seconds.';

  @override
  String get uxRestDayHint =>
      'Recovery is training too. Walk, stretch and hit your protein.';

  @override
  String uxWorkoutMinutes(int minutes) {
    return '~$minutes min';
  }

  @override
  String get uxWater => 'Water';

  @override
  String get uxGlassSize => '250 ml';

  @override
  String uxWaterAdded(String liters) {
    return '+250 ml · $liters L today';
  }

  @override
  String get uxWaterGoalDone => 'Water goal reached 💧 great job!';

  @override
  String get uxUndo => 'Undo';

  @override
  String get uxCopied => 'Copied';

  @override
  String get uxSend => 'Send';

  @override
  String get uxQuickLogTitle => 'Quick log';

  @override
  String get uxQuickLogSubtitle => 'Log anything in one tap.';

  @override
  String get uxQuickScanTitle => 'Scan a meal with AI';

  @override
  String get uxQuickScanSub => 'Calories & macros in seconds';

  @override
  String get uxQuickWater => 'Water';

  @override
  String get uxQuickWaterSub => '+1 glass · 250 ml';

  @override
  String get uxQuickWeight => 'Weight';

  @override
  String get uxQuickWeightSub => 'Log today\'s weigh-in';

  @override
  String get uxQuickCardio => 'Cardio';

  @override
  String get uxQuickCardioSub => 'Walk, run, bike…';

  @override
  String get uxQuickCoach => 'Ask coach';

  @override
  String get uxQuickCoachSub => 'Personal AI advice';

  @override
  String get uxCoachOnline => 'Online · knows your macros';

  @override
  String get uxCoachTyping => 'Typing…';

  @override
  String get uxCoachNewChat => 'New chat';

  @override
  String get uxCoachClearConfirm =>
      'Start a new conversation? Current messages will be cleared.';

  @override
  String get uxCoachHeroTitle => 'Your personal AI coach';

  @override
  String get uxCoachHeroBody =>
      'Ask about meals, protein, cravings or training. Every answer is based on your numbers today.';

  @override
  String uxCoachKcalLeft(int kcal) {
    return '$kcal kcal left';
  }

  @override
  String uxCoachProteinLeft(int grams) {
    return '${grams}g protein left';
  }

  @override
  String get uxCoachChipWorkout => 'What should I eat before training?';

  @override
  String get uxProtein => 'Protein';

  @override
  String get uxCarbs => 'Carbs';

  @override
  String get uxFat => 'Fat';

  @override
  String get aiScanAnalysisTitle => 'AI analysis';

  @override
  String get diaryAddMeal => 'Add Meal';

  @override
  String get diaryAddWorkout => 'Add Workout';

  @override
  String get diaryCaloriesIn => 'Calories In';

  @override
  String get diaryCaloriesOut => 'Calories Out';

  @override
  String diaryKcal(int kcal) {
    return '$kcal kcal';
  }

  @override
  String diaryLastUpdated(String count) {
    return 'Last updated $count';
  }

  @override
  String diaryMealCalories(int calories) {
    return '$calories kcal';
  }

  @override
  String get diaryNetBalance => 'Net Balance';

  @override
  String get diaryNoEntries => 'No entries for this day';

  @override
  String get diaryProtein => 'Protein';

  @override
  String diaryProteinProgress(int current, int goal) {
    return '$current / $goal g';
  }

  @override
  String get diarySetGoalsCta => 'Set goals';

  @override
  String get diarySetGoalsFirst => 'Set your goals first';

  @override
  String get diaryTimeline => 'Timeline';

  @override
  String get diaryTitle => 'My Diary';

  @override
  String get diaryToday => 'Today';

  @override
  String get diaryWater => 'Water';

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
  String get exerciseAdvanced => 'Advanced';

  @override
  String get exerciseBeginner => 'Beginner';

  @override
  String get exerciseComplete => 'Complete Set';

  @override
  String get exerciseDifficulty => 'Difficulty';

  @override
  String get exerciseEquipment => 'Equipment';

  @override
  String get exerciseIntermediate => 'Intermediate';

  @override
  String get exerciseLoadingDemo => 'Loading exercise demo...';

  @override
  String get exerciseMistakes => 'Common Mistakes';

  @override
  String get exerciseReps => 'Reps';

  @override
  String get exerciseRest => 'Rest';

  @override
  String get exerciseSets => 'Sets';

  @override
  String get exerciseSteps => 'Steps';

  @override
  String get exerciseTips => 'Pro Tips';

  @override
  String get exerciseViewBack => 'Back';

  @override
  String get exerciseViewFront => 'Front';

  @override
  String get measurements30Days => '30 days';

  @override
  String get measurements3Months => '3 months';

  @override
  String get measurements7Days => '7 days';

  @override
  String get measurementsAdd => 'Add measurement';

  @override
  String get measurementsAddFirst => 'Log your first measurement';

  @override
  String get measurementsAll => 'All';

  @override
  String get measurementsArms => 'Arms';

  @override
  String get measurementsBodyFat => 'Body fat %';

  @override
  String get measurementsChest => 'Chest';

  @override
  String get measurementsDate => 'Date';

  @override
  String get measurementsDelete => 'Delete';

  @override
  String get measurementsDeleteConfirm => 'Delete this measurement?';

  @override
  String get measurementsHistory => 'History';

  @override
  String measurementsLastUpdated(String date) {
    return 'Updated $date';
  }

  @override
  String get measurementsNeedMoreData => 'Log more entries to see trends';

  @override
  String get measurementsNoData => 'No measurements yet';

  @override
  String get measurementsNotes => 'Notes';

  @override
  String get measurementsSave => 'Save';

  @override
  String get measurementsThighs => 'Thighs';

  @override
  String get measurementsTitle => 'Measurements';

  @override
  String get measurementsTrendDeclining => 'Needs attention';

  @override
  String get measurementsTrendImproving => 'Improving';

  @override
  String get measurementsTrendStable => 'Stable';

  @override
  String get measurementsWaist => 'Waist';

  @override
  String get measurementsWeight => 'Weight';

  @override
  String get measurementsWeightInvalid => 'Enter a valid weight';

  @override
  String get muscleBack => 'Back';

  @override
  String get muscleBiceps => 'Biceps';

  @override
  String get muscleCalves => 'Calves';

  @override
  String get muscleChest => 'Chest';

  @override
  String get muscleCore => 'Core';

  @override
  String get muscleForearms => 'Forearms';

  @override
  String get muscleGlutes => 'Glutes';

  @override
  String get muscleHamstrings => 'Hamstrings';

  @override
  String get muscleHipFlexors => 'Hip Flexors';

  @override
  String get muscleQuads => 'Quads';

  @override
  String get muscleShoulders => 'Shoulders';

  @override
  String get muscleTriceps => 'Triceps';

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
  String get notificationsTitle => 'Notifications';

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
    return '$count sessions';
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
  String get vitalityHubTitle => 'Vitality Hub';

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
    return 'Last entry · energy $score/10';
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
  String get vitalityMyProgram => 'My Program';

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
  String get vitalityProgramTitle => 'Vitality Transformation';

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
  String get vitalityReportCompletion => 'Completion';

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
  String get vitalityScoreLabel => 'Vitality';

  @override
  String get vitalitySleepHint => 'How did you sleep?';

  @override
  String vitalitySleepHours(num hours) {
    return '$hours h';
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
  String get walkingHealthBanner => 'Live steps from this phone’s pedometer';

  @override
  String get walkingManualStepsLabel => 'Steps today';

  @override
  String get walkingUpdateSteps => 'Update steps';

  @override
  String get walkingWebManualBanner => 'On web, enter steps manually';

  @override
  String get vitalityKeyTakeaway => 'Key takeaway';
}
