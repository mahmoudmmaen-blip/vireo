import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Vireo'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingTitle;

  /// No description provided for @workoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workoutTitle;

  /// No description provided for @nutritionTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutritionTitle;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @authTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authTitle;

  /// No description provided for @languageToggle.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageToggle;

  /// No description provided for @setupComplete.
  ///
  /// In en, this message translates to:
  /// **'Vireo is ready'**
  String get setupComplete;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @skipButton.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipButton;

  /// No description provided for @finishButton.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finishButton;

  /// No description provided for @yesButton.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesButton;

  /// No description provided for @noButton.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noButton;

  /// No description provided for @onboardingStepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingStepProgress(int current, int total);

  /// No description provided for @onboardingStep1Title.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get onboardingStep1Title;

  /// No description provided for @onboardingStep1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll personalize your plan from these basics.'**
  String get onboardingStep1Subtitle;

  /// No description provided for @onboardingStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Health screening'**
  String get onboardingStep2Title;

  /// No description provided for @onboardingStep2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Answer honestly — this helps us keep workouts safer.'**
  String get onboardingStep2Subtitle;

  /// No description provided for @onboardingStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Where you train'**
  String get onboardingStep3Title;

  /// No description provided for @onboardingStep3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll only show exercises that match your setup.'**
  String get onboardingStep3Subtitle;

  /// No description provided for @onboardingStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Your goal'**
  String get onboardingStep4Title;

  /// No description provided for @onboardingStep4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'What matters most right now?'**
  String get onboardingStep4Subtitle;

  /// No description provided for @onboardingStep5Title.
  ///
  /// In en, this message translates to:
  /// **'Before we start'**
  String get onboardingStep5Title;

  /// No description provided for @onboardingStep5Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Please read and accept to continue.'**
  String get onboardingStep5Subtitle;

  /// No description provided for @onboardingStep6Title.
  ///
  /// In en, this message translates to:
  /// **'Stay on track'**
  String get onboardingStep6Title;

  /// No description provided for @onboardingStep6Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional reminders — you can change these later.'**
  String get onboardingStep6Subtitle;

  /// No description provided for @unitsMetric.
  ///
  /// In en, this message translates to:
  /// **'kg / cm'**
  String get unitsMetric;

  /// No description provided for @unitsImperial.
  ///
  /// In en, this message translates to:
  /// **'lb / in'**
  String get unitsImperial;

  /// No description provided for @onboardingAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get onboardingAge;

  /// No description provided for @onboardingHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get onboardingHeight;

  /// No description provided for @onboardingWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get onboardingWeight;

  /// No description provided for @onboardingActivityLevel.
  ///
  /// In en, this message translates to:
  /// **'Activity level'**
  String get onboardingActivityLevel;

  /// No description provided for @onboardingDietaryOptional.
  ///
  /// In en, this message translates to:
  /// **'Dietary restrictions (optional)'**
  String get onboardingDietaryOptional;

  /// No description provided for @activitySedentary.
  ///
  /// In en, this message translates to:
  /// **'Mostly sedentary'**
  String get activitySedentary;

  /// No description provided for @activityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderately active'**
  String get activityModerate;

  /// No description provided for @activityVeryActive.
  ///
  /// In en, this message translates to:
  /// **'Very active'**
  String get activityVeryActive;

  /// No description provided for @dietHalal.
  ///
  /// In en, this message translates to:
  /// **'Halal'**
  String get dietHalal;

  /// No description provided for @dietVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get dietVegetarian;

  /// No description provided for @dietVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get dietVegan;

  /// No description provided for @dietGlutenFree.
  ///
  /// In en, this message translates to:
  /// **'Gluten-free'**
  String get dietGlutenFree;

  /// No description provided for @dietDairyFree.
  ///
  /// In en, this message translates to:
  /// **'Dairy-free'**
  String get dietDairyFree;

  /// No description provided for @dietLowSodium.
  ///
  /// In en, this message translates to:
  /// **'Low sodium'**
  String get dietLowSodium;

  /// No description provided for @dietLowCarb.
  ///
  /// In en, this message translates to:
  /// **'Low carb'**
  String get dietLowCarb;

  /// No description provided for @dietDiabeticFriendly.
  ///
  /// In en, this message translates to:
  /// **'Diabetic-friendly'**
  String get dietDiabeticFriendly;

  /// No description provided for @onboardingMedicalFlagNotice.
  ///
  /// In en, this message translates to:
  /// **'We\'ll adjust intensity and show in-workout safety reminders.'**
  String get onboardingMedicalFlagNotice;

  /// No description provided for @healthQuestionHeart.
  ///
  /// In en, this message translates to:
  /// **'Heart disease or cardiovascular condition?'**
  String get healthQuestionHeart;

  /// No description provided for @healthQuestionDiabetes.
  ///
  /// In en, this message translates to:
  /// **'Diabetes or blood sugar condition?'**
  String get healthQuestionDiabetes;

  /// No description provided for @healthQuestionBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'High or low blood pressure?'**
  String get healthQuestionBloodPressure;

  /// No description provided for @healthQuestionJoints.
  ///
  /// In en, this message translates to:
  /// **'Joint injuries or chronic pain?'**
  String get healthQuestionJoints;

  /// No description provided for @healthQuestionMedications.
  ///
  /// In en, this message translates to:
  /// **'Currently taking regular medications?'**
  String get healthQuestionMedications;

  /// No description provided for @envHomeNoEquipment.
  ///
  /// In en, this message translates to:
  /// **'Home — no equipment'**
  String get envHomeNoEquipment;

  /// No description provided for @envHomeNoEquipmentDesc.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight exercises only'**
  String get envHomeNoEquipmentDesc;

  /// No description provided for @envHomeLightEquipment.
  ///
  /// In en, this message translates to:
  /// **'Home — light equipment'**
  String get envHomeLightEquipment;

  /// No description provided for @envHomeLightEquipmentDesc.
  ///
  /// In en, this message translates to:
  /// **'Bands, dumbbells, or similar'**
  String get envHomeLightEquipmentDesc;

  /// No description provided for @envGymFull.
  ///
  /// In en, this message translates to:
  /// **'Full gym'**
  String get envGymFull;

  /// No description provided for @envGymFullDesc.
  ///
  /// In en, this message translates to:
  /// **'Machines, barbells, full rack access'**
  String get envGymFullDesc;

  /// No description provided for @envWalkingOnly.
  ///
  /// In en, this message translates to:
  /// **'Walking only'**
  String get envWalkingOnly;

  /// No description provided for @envWalkingOnlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Step goals and light mobility'**
  String get envWalkingOnlyDesc;

  /// No description provided for @goalWeightLoss.
  ///
  /// In en, this message translates to:
  /// **'Weight loss'**
  String get goalWeightLoss;

  /// No description provided for @goalWeightLossDesc.
  ///
  /// In en, this message translates to:
  /// **'Fat loss with sustainable training'**
  String get goalWeightLossDesc;

  /// No description provided for @goalMuscleGain.
  ///
  /// In en, this message translates to:
  /// **'Muscle gain'**
  String get goalMuscleGain;

  /// No description provided for @goalMuscleGainDesc.
  ///
  /// In en, this message translates to:
  /// **'Strength and lean mass focus'**
  String get goalMuscleGainDesc;

  /// No description provided for @goalGeneralVitality.
  ///
  /// In en, this message translates to:
  /// **'General vitality'**
  String get goalGeneralVitality;

  /// No description provided for @goalGeneralVitalityDesc.
  ///
  /// In en, this message translates to:
  /// **'Energy, consistency, feeling better'**
  String get goalGeneralVitalityDesc;

  /// No description provided for @goalAllOfAbove.
  ///
  /// In en, this message translates to:
  /// **'All of the above'**
  String get goalAllOfAbove;

  /// No description provided for @goalAllOfAboveDesc.
  ///
  /// In en, this message translates to:
  /// **'Balanced plan across goals'**
  String get goalAllOfAboveDesc;

  /// No description provided for @legalDisclaimerText.
  ///
  /// In en, this message translates to:
  /// **'Vireo is an organizational fitness tool and is not a substitute for direct medical advice. Content (workouts, meal plans, and health information) is for general guidance only.\n\nIf you have any chronic condition — such as heart disease, diabetes, high blood pressure, or current joint injuries — or take medication, consult your doctor before starting any exercise or nutrition program.\n\nDietary supplements and hormone-related guidance (such as testosterone) are general educational information only. They are not medical prescriptions or treatment recommendations.\n\nBy participating in any in-app program, I confirm I have read the terms and understand Vireo is not liable for injury or health complications from using the app without medical consultation.'**
  String get legalDisclaimerText;

  /// No description provided for @legalDisclaimerSection1.
  ///
  /// In en, this message translates to:
  /// **'Vireo is an organizational fitness tool and is not a substitute for direct medical advice. Content (workouts, meal plans, and health information) is for general guidance only.'**
  String get legalDisclaimerSection1;

  /// No description provided for @legalDisclaimerSection2.
  ///
  /// In en, this message translates to:
  /// **'If you have any chronic condition — such as heart disease, diabetes, high blood pressure, or current joint injuries — or take medication, consult your doctor before starting any exercise or nutrition program.'**
  String get legalDisclaimerSection2;

  /// No description provided for @legalDisclaimerSection3.
  ///
  /// In en, this message translates to:
  /// **'Dietary supplements are general educational information only. They are not medical prescriptions or treatment recommendations.'**
  String get legalDisclaimerSection3;

  /// No description provided for @legalDisclaimerSection4.
  ///
  /// In en, this message translates to:
  /// **'Hormone-related guidance (such as testosterone) is general educational information only. It is not a medical prescription or treatment recommendation.'**
  String get legalDisclaimerSection4;

  /// No description provided for @legalDisclaimerSection5.
  ///
  /// In en, this message translates to:
  /// **'By participating in any in-app program, I confirm I have read the terms and understand Vireo is not liable for injury or health complications from using the app without medical consultation.'**
  String get legalDisclaimerSection5;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @consentCheckboxLabel.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the terms and health disclaimer'**
  String get consentCheckboxLabel;

  /// No description provided for @notificationWorkoutTime.
  ///
  /// In en, this message translates to:
  /// **'Preferred workout time'**
  String get notificationWorkoutTime;

  /// No description provided for @notificationWalkingReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily walking reminder'**
  String get notificationWalkingReminder;

  /// No description provided for @notificationWeeklyCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Weekly check-in reminder'**
  String get notificationWeeklyCheckIn;

  /// No description provided for @notificationNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notificationNotSet;

  /// No description provided for @authWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Vireo'**
  String get authWelcomeTitle;

  /// No description provided for @authWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync progress across devices, or continue locally as a guest.'**
  String get authWelcomeSubtitle;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign in with email'**
  String get signInWithEmail;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authSignUp;

  /// No description provided for @authHasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authHasAccount;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authNoAccount;

  /// No description provided for @authSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get authSignedIn;

  /// No description provided for @authErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get authErrorGeneric;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @guestModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Guest mode'**
  String get guestModeTitle;

  /// No description provided for @guestModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your progress is saved on this device only. Create an account to sync and subscribe.'**
  String get guestModeSubtitle;

  /// No description provided for @profileStatWorkoutsLabel.
  ///
  /// In en, this message translates to:
  /// **'Workouts completed'**
  String get profileStatWorkoutsLabel;

  /// No description provided for @profileStatStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Day streak'**
  String get profileStatStreakLabel;

  /// No description provided for @saveProgressToCloud.
  ///
  /// In en, this message translates to:
  /// **'Save progress to cloud'**
  String get saveProgressToCloud;

  /// No description provided for @profileCloudSynced.
  ///
  /// In en, this message translates to:
  /// **'Progress synced to your account'**
  String get profileCloudSynced;

  /// No description provided for @authGateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get authGateTitle;

  /// No description provided for @authGateSaveProgress.
  ///
  /// In en, this message translates to:
  /// **'Create a free account to save your progress to the cloud and access it on any device.'**
  String get authGateSaveProgress;

  /// No description provided for @authGateSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Create an account before subscribing so your premium access is linked to you.'**
  String get authGateSubscribe;

  /// No description provided for @authGateSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authGateSignUp;

  /// No description provided for @authGateNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get authGateNotNow;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone'**
  String get deleteAccountWarningTitle;

  /// No description provided for @deleteAccountWarningBody.
  ///
  /// In en, this message translates to:
  /// **'All your profile data, workout logs, meal plans, and progress photos will be permanently deleted from our servers.'**
  String get deleteAccountWarningBody;

  /// No description provided for @deleteAccountCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get deleteAccountCancel;

  /// No description provided for @deleteAccountContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get deleteAccountContinue;

  /// No description provided for @deleteAccountConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get deleteAccountConfirmTitle;

  /// No description provided for @deleteAccountConfirmInstructions.
  ///
  /// In en, this message translates to:
  /// **'Type the word below exactly to confirm permanent account deletion:'**
  String get deleteAccountConfirmInstructions;

  /// No description provided for @deleteConfirmationWord.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get deleteConfirmationWord;

  /// No description provided for @deleteAccountTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Type DELETE'**
  String get deleteAccountTypeHint;

  /// No description provided for @deleteAccountConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Delete my account permanently'**
  String get deleteAccountConfirmButton;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted.'**
  String get deleteAccountSuccess;

  /// No description provided for @workoutMedicalWarning.
  ///
  /// In en, this message translates to:
  /// **'You indicated a health condition during onboarding. Stop if you feel pain, dizziness, or shortness of breath. Consult your doctor before intense exercise.'**
  String get workoutMedicalWarning;

  /// No description provided for @workoutWarmUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Warm-up'**
  String get workoutWarmUpTitle;

  /// No description provided for @workoutWarmUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete these mobility exercises before your main workout.'**
  String get workoutWarmUpSubtitle;

  /// No description provided for @workoutCoolDownTitle.
  ///
  /// In en, this message translates to:
  /// **'Cool-down'**
  String get workoutCoolDownTitle;

  /// No description provided for @workoutCoolDownSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle mobility to help your body recover.'**
  String get workoutCoolDownSubtitle;

  /// No description provided for @workoutActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Active workout'**
  String get workoutActiveTitle;

  /// No description provided for @workoutBeginWorkout.
  ///
  /// In en, this message translates to:
  /// **'Begin workout'**
  String get workoutBeginWorkout;

  /// No description provided for @workoutFinishCoolDown.
  ///
  /// In en, this message translates to:
  /// **'Finish cool-down'**
  String get workoutFinishCoolDown;

  /// No description provided for @workoutStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start today\'s workout'**
  String get workoutStartButton;

  /// No description provided for @workoutTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s program'**
  String get workoutTodayTitle;

  /// No description provided for @workoutTodaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 main exercise} other{{count} main exercises}}'**
  String workoutTodaySubtitle(int count);

  /// No description provided for @workoutPhaseCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 exercise} other{{count} exercises}}'**
  String workoutPhaseCount(int count);

  /// No description provided for @workoutExerciseProgress.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get workoutExerciseProgress;

  /// No description provided for @workoutStatSets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get workoutStatSets;

  /// No description provided for @workoutStatReps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get workoutStatReps;

  /// No description provided for @workoutStatRest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get workoutStatRest;

  /// No description provided for @workoutSetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get workoutSetsLabel;

  /// No description provided for @workoutSetNumber.
  ///
  /// In en, this message translates to:
  /// **'Set {number}'**
  String workoutSetNumber(int number);

  /// No description provided for @workoutPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get workoutPrevious;

  /// No description provided for @workoutNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get workoutNext;

  /// No description provided for @workoutSwapExercise.
  ///
  /// In en, this message translates to:
  /// **'Swap exercise'**
  String get workoutSwapExercise;

  /// No description provided for @workoutSwapTitle.
  ///
  /// In en, this message translates to:
  /// **'Swap exercise'**
  String get workoutSwapTitle;

  /// No description provided for @workoutSwapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Alternatives for the same muscle group and your training environment.'**
  String get workoutSwapSubtitle;

  /// No description provided for @workoutSwapEmpty.
  ///
  /// In en, this message translates to:
  /// **'No alternatives available right now.'**
  String get workoutSwapEmpty;

  /// No description provided for @workoutRestTitle.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get workoutRestTitle;

  /// No description provided for @workoutRestSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get workoutRestSkip;

  /// No description provided for @workoutRestAdd15.
  ///
  /// In en, this message translates to:
  /// **'+15s'**
  String get workoutRestAdd15;

  /// No description provided for @workoutPausedTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout paused'**
  String get workoutPausedTitle;

  /// No description provided for @workoutResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get workoutResume;

  /// No description provided for @workoutEndWorkout.
  ///
  /// In en, this message translates to:
  /// **'End workout'**
  String get workoutEndWorkout;

  /// No description provided for @workoutRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart workout'**
  String get workoutRestart;

  /// No description provided for @workoutEndConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'End workout?'**
  String get workoutEndConfirmTitle;

  /// No description provided for @workoutEndConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Your progress in this session will not be saved.'**
  String get workoutEndConfirmBody;

  /// No description provided for @workoutFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'How was this workout?'**
  String get workoutFeedbackTitle;

  /// No description provided for @workoutFeedbackEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get workoutFeedbackEasy;

  /// No description provided for @workoutFeedbackJustRight.
  ///
  /// In en, this message translates to:
  /// **'Just right'**
  String get workoutFeedbackJustRight;

  /// No description provided for @workoutFeedbackHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get workoutFeedbackHard;

  /// No description provided for @workoutVideoUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Video unavailable'**
  String get workoutVideoUnavailable;

  /// No description provided for @workoutEmptyProgram.
  ///
  /// In en, this message translates to:
  /// **'No exercises scheduled for today.'**
  String get workoutEmptyProgram;

  /// No description provided for @walkingTitle.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get walkingTitle;

  /// No description provided for @walkingStepsToday.
  ///
  /// In en, this message translates to:
  /// **'steps today'**
  String get walkingStepsToday;

  /// No description provided for @walkingDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal: {steps} steps'**
  String walkingDailyGoal(int steps);

  /// No description provided for @walkingGoalProgress.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of today\'s goal'**
  String walkingGoalProgress(int percent);

  /// No description provided for @walkingWeeklyChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get walkingWeeklyChartTitle;

  /// No description provided for @walkingHealthSourceNote.
  ///
  /// In en, this message translates to:
  /// **'Step counts are read from Apple Health or Health Connect — Vireo does not use a built-in pedometer.'**
  String get walkingHealthSourceNote;

  /// No description provided for @walkingPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Steps access needed'**
  String get walkingPermissionTitle;

  /// No description provided for @walkingPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Vireo reads your steps from Apple Health (iOS) or Health Connect (Android) for accurate tracking. Allow access in Settings, then return here.'**
  String get walkingPermissionBody;

  /// No description provided for @walkingOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get walkingOpenSettings;

  /// No description provided for @walkingTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get walkingTryAgain;

  /// No description provided for @walkingUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Walking tracker unavailable'**
  String get walkingUnavailableTitle;

  /// No description provided for @walkingUnavailableBody.
  ///
  /// In en, this message translates to:
  /// **'Step tracking requires a physical iOS or Android device with Apple Health or Health Connect.'**
  String get walkingUnavailableBody;

  /// No description provided for @nutritionTabBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get nutritionTabBreakfast;

  /// No description provided for @nutritionTabLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get nutritionTabLunch;

  /// No description provided for @nutritionTabDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get nutritionTabDinner;

  /// No description provided for @nutritionTabSnack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get nutritionTabSnack;

  /// No description provided for @nutritionNoMealPlanned.
  ///
  /// In en, this message translates to:
  /// **'No meal planned for today.'**
  String get nutritionNoMealPlanned;

  /// No description provided for @nutritionPrepMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String nutritionPrepMinutes(int minutes);

  /// No description provided for @nutritionTagHighProtein.
  ///
  /// In en, this message translates to:
  /// **'High protein'**
  String get nutritionTagHighProtein;

  /// No description provided for @nutritionTagQuickEasy.
  ///
  /// In en, this message translates to:
  /// **'Quick & easy'**
  String get nutritionTagQuickEasy;

  /// No description provided for @nutritionTagLightEnergy.
  ///
  /// In en, this message translates to:
  /// **'Light energy'**
  String get nutritionTagLightEnergy;

  /// No description provided for @nutritionScanFridge.
  ///
  /// In en, this message translates to:
  /// **'Scan your fridge'**
  String get nutritionScanFridge;

  /// No description provided for @nutritionScansRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} fridge scans left this month'**
  String nutritionScansRemaining(int count);

  /// No description provided for @nutritionScanPrompt.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of your fridge or pantry to detect ingredients.'**
  String get nutritionScanPrompt;

  /// No description provided for @nutritionTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get nutritionTakePhoto;

  /// No description provided for @nutritionChoosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get nutritionChoosePhoto;

  /// No description provided for @nutritionScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning ingredients…'**
  String get nutritionScanning;

  /// No description provided for @nutritionScanFailed.
  ///
  /// In en, this message translates to:
  /// **'Scan failed. Try again or enter ingredients manually.'**
  String get nutritionScanFailed;

  /// No description provided for @nutritionScanLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Monthly scan limit reached. Upgrade for unlimited scans.'**
  String get nutritionScanLimitReached;

  /// No description provided for @nutritionConfirmIngredients.
  ///
  /// In en, this message translates to:
  /// **'Confirm ingredients'**
  String get nutritionConfirmIngredients;

  /// No description provided for @nutritionIngredientsHint.
  ///
  /// In en, this message translates to:
  /// **'Remove anything incorrect and add missing items.'**
  String get nutritionIngredientsHint;

  /// No description provided for @nutritionAddIngredient.
  ///
  /// In en, this message translates to:
  /// **'Add ingredient'**
  String get nutritionAddIngredient;

  /// No description provided for @nutritionGetRecipes.
  ///
  /// In en, this message translates to:
  /// **'Get recipe ideas'**
  String get nutritionGetRecipes;

  /// No description provided for @nutritionNoIngredients.
  ///
  /// In en, this message translates to:
  /// **'Add at least one ingredient.'**
  String get nutritionNoIngredients;

  /// No description provided for @nutritionRecipeSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Recipe ideas'**
  String get nutritionRecipeSuggestions;

  /// No description provided for @nutritionRecipeSuggestionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Based on your ingredients, goal, and dietary preferences.'**
  String get nutritionRecipeSuggestionsSubtitle;

  /// No description provided for @nutritionNoRecipesFound.
  ///
  /// In en, this message translates to:
  /// **'No matching recipes found.'**
  String get nutritionNoRecipesFound;

  /// No description provided for @nutritionManualEntry.
  ///
  /// In en, this message translates to:
  /// **'Enter manually'**
  String get nutritionManualEntry;

  /// No description provided for @nutritionManualEntryHint.
  ///
  /// In en, this message translates to:
  /// **'Type what you have on hand — we\'ll suggest recipes that match your goal and dietary preferences.'**
  String get nutritionManualEntryHint;

  /// No description provided for @nutritionSwapMeal.
  ///
  /// In en, this message translates to:
  /// **'Swap meal'**
  String get nutritionSwapMeal;

  /// No description provided for @nutritionSwapMealSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a different recipe — no repeats within 14 days.'**
  String get nutritionSwapMealSubtitle;

  /// No description provided for @nutritionSwapMealEmpty.
  ///
  /// In en, this message translates to:
  /// **'No alternative meals available right now.'**
  String get nutritionSwapMealEmpty;

  /// No description provided for @nutritionDemoQuickMeals.
  ///
  /// In en, this message translates to:
  /// **'Quick healthy demo meals'**
  String get nutritionDemoQuickMeals;

  /// No description provided for @nutritionTryDemoScan.
  ///
  /// In en, this message translates to:
  /// **'Try demo scan'**
  String get nutritionTryDemoScan;

  /// No description provided for @homeWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your personalized fitness hub.'**
  String get homeWelcomeSubtitle;

  /// No description provided for @homeWalkingCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track daily steps from Apple Health or Health Connect.'**
  String get homeWalkingCardSubtitle;

  /// No description provided for @homeDailyProgramTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily program'**
  String get homeDailyProgramTitle;

  /// No description provided for @homeTodayWorkout.
  ///
  /// In en, this message translates to:
  /// **'Today\'s workout'**
  String get homeTodayWorkout;

  /// No description provided for @homeNextMeal.
  ///
  /// In en, this message translates to:
  /// **'Next meal'**
  String get homeNextMeal;

  /// No description provided for @homeWorkoutExerciseCount.
  ///
  /// In en, this message translates to:
  /// **'{count} exercises'**
  String homeWorkoutExerciseCount(int count);

  /// No description provided for @progressTabWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get progressTabWeight;

  /// No description provided for @progressTabAdherence.
  ///
  /// In en, this message translates to:
  /// **'Adherence'**
  String get progressTabAdherence;

  /// No description provided for @progressTabEnergy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get progressTabEnergy;

  /// No description provided for @progressWeightChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Weight trend'**
  String get progressWeightChartTitle;

  /// No description provided for @progressWeightGoalLine.
  ///
  /// In en, this message translates to:
  /// **'Goal: {value} {unit}'**
  String progressWeightGoalLine(String value, String unit);

  /// No description provided for @progressAdherenceChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly adherence'**
  String get progressAdherenceChartTitle;

  /// No description provided for @progressAdherenceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Workout completion % per week'**
  String get progressAdherenceSubtitle;

  /// No description provided for @progressEnergyChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Energy levels'**
  String get progressEnergyChartTitle;

  /// No description provided for @progressEnergySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly check-in energy score (1–10)'**
  String get progressEnergySubtitle;

  /// No description provided for @progressLogWeight.
  ///
  /// In en, this message translates to:
  /// **'Log weight'**
  String get progressLogWeight;

  /// No description provided for @progressWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight ({unit})'**
  String progressWeightLabel(String unit);

  /// No description provided for @progressLogDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get progressLogDate;

  /// No description provided for @progressSaveWeight.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get progressSaveWeight;

  /// No description provided for @reassessmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly check-in'**
  String get reassessmentTitle;

  /// No description provided for @reassessmentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your weight, activity, and training setup so we can keep your program accurate.'**
  String get reassessmentSubtitle;

  /// No description provided for @reassessmentLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get reassessmentLater;

  /// No description provided for @reassessmentSubmit.
  ///
  /// In en, this message translates to:
  /// **'Update my plan'**
  String get reassessmentSubmit;

  /// No description provided for @reassessmentSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'What changed'**
  String get reassessmentSummaryTitle;

  /// No description provided for @reassessmentSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Compared to your last check-in'**
  String get reassessmentSummarySubtitle;

  /// No description provided for @reassessmentPhaseUpdated.
  ///
  /// In en, this message translates to:
  /// **'Program phase updated to phase {phase}'**
  String reassessmentPhaseUpdated(int phase);

  /// No description provided for @reassessmentNoPhaseChange.
  ///
  /// In en, this message translates to:
  /// **'No program changes needed — keep going!'**
  String get reassessmentNoPhaseChange;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Vireo Premium'**
  String get paywallTitle;

  /// No description provided for @paywallHeadline.
  ///
  /// In en, this message translates to:
  /// **'Unlock your full potential'**
  String get paywallHeadline;

  /// No description provided for @paywallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Premium gives you unlimited scans, full program phases, and deeper progress insights.'**
  String get paywallSubtitle;

  /// No description provided for @paywallBestValue.
  ///
  /// In en, this message translates to:
  /// **'Best Value'**
  String get paywallBestValue;

  /// No description provided for @paywallPlanMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get paywallPlanMonthly;

  /// No description provided for @paywallPlanAnnual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get paywallPlanAnnual;

  /// No description provided for @paywallPlanLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get paywallPlanLifetime;

  /// No description provided for @paywallFeatureUnlimitedScans.
  ///
  /// In en, this message translates to:
  /// **'Unlimited fridge scans'**
  String get paywallFeatureUnlimitedScans;

  /// No description provided for @paywallFeatureFullProgram.
  ///
  /// In en, this message translates to:
  /// **'Full program phases & progressive workouts'**
  String get paywallFeatureFullProgram;

  /// No description provided for @paywallFeatureCloudSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync across devices'**
  String get paywallFeatureCloudSync;

  /// No description provided for @paywallFeatureProgressAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Advanced progress analytics'**
  String get paywallFeatureProgressAnalytics;

  /// No description provided for @paywallSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get paywallSubscribe;

  /// No description provided for @paywallRestorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get paywallRestorePurchases;

  /// No description provided for @paywallPurchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Premium!'**
  String get paywallPurchaseSuccess;

  /// No description provided for @paywallPurchaseError.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again.'**
  String get paywallPurchaseError;

  /// No description provided for @paywallRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored successfully.'**
  String get paywallRestoreSuccess;

  /// No description provided for @paywallRestoreEmpty.
  ///
  /// In en, this message translates to:
  /// **'No active subscription found for this account.'**
  String get paywallRestoreEmpty;

  /// No description provided for @paywallRestoreError.
  ///
  /// In en, this message translates to:
  /// **'Could not restore purchases. Try again later.'**
  String get paywallRestoreError;

  /// No description provided for @paywallNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions are not available in this build.'**
  String get paywallNotConfigured;

  /// No description provided for @paywallSubscriptionExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your subscription has expired. Resubscribe to unlock premium features.'**
  String get paywallSubscriptionExpiredMessage;

  /// No description provided for @trialEndedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your trial has ended'**
  String get trialEndedTitle;

  /// No description provided for @trialEndedBody.
  ///
  /// In en, this message translates to:
  /// **'Thanks for trying Vireo Premium. Subscribe to keep unlimited scans, full program phases, and cloud sync.'**
  String get trialEndedBody;

  /// No description provided for @trialEndedViewPlans.
  ///
  /// In en, this message translates to:
  /// **'View plans'**
  String get trialEndedViewPlans;

  /// No description provided for @subscriptionTrialDaysRemaining.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day left in your free trial} other{{days} days left in your free trial}}'**
  String subscriptionTrialDaysRemaining(int days);

  /// No description provided for @subscriptionExpiredBanner.
  ///
  /// In en, this message translates to:
  /// **'Subscription expired — tap to renew premium access'**
  String get subscriptionExpiredBanner;

  /// No description provided for @subscriptionPremiumActive.
  ///
  /// In en, this message translates to:
  /// **'Premium active'**
  String get subscriptionPremiumActive;

  /// No description provided for @subscriptionFreeTier.
  ///
  /// In en, this message translates to:
  /// **'Free plan'**
  String get subscriptionFreeTier;

  /// No description provided for @subscriptionUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get subscriptionUpgrade;

  /// No description provided for @settingsManageSubscription.
  ///
  /// In en, this message translates to:
  /// **'View plans, subscribe, or restore purchases'**
  String get settingsManageSubscription;

  /// No description provided for @workoutPhaseLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Phase {phase} locked'**
  String workoutPhaseLockedTitle(int phase);

  /// No description provided for @workoutPhaseLockedBody.
  ///
  /// In en, this message translates to:
  /// **'Resubscribe to continue your full training program. Basic tracking remains available on the free plan.'**
  String get workoutPhaseLockedBody;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello {name} 👋'**
  String homeGreeting(String name);

  /// No description provided for @homeDayPhase.
  ///
  /// In en, this message translates to:
  /// **'Day {day} · {phase} phase'**
  String homeDayPhase(int day, String phase);

  /// No description provided for @homeGuestBanner.
  ///
  /// In en, this message translates to:
  /// **'You\'re in guest mode — sign up to save your progress'**
  String get homeGuestBanner;

  /// No description provided for @homeGuestSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get homeGuestSignUp;

  /// No description provided for @homeGuestCta.
  ///
  /// In en, this message translates to:
  /// **'Sign up now — free for 7 days'**
  String get homeGuestCta;

  /// No description provided for @homeStreakDays.
  ///
  /// In en, this message translates to:
  /// **'{days} day streak'**
  String homeStreakDays(int days);

  /// No description provided for @homeStartStreak.
  ///
  /// In en, this message translates to:
  /// **'Start your streak today'**
  String get homeStartStreak;

  /// No description provided for @homeTodayWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s workout'**
  String get homeTodayWorkoutTitle;

  /// No description provided for @homeStartWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start workout'**
  String get homeStartWorkout;

  /// No description provided for @homeRestDay.
  ///
  /// In en, this message translates to:
  /// **'Active rest day 🧘'**
  String get homeRestDay;

  /// No description provided for @homeBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get homeBreakfast;

  /// No description provided for @homeMealConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed ✓'**
  String get homeMealConfirmed;

  /// No description provided for @homeMealPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get homeMealPending;

  /// No description provided for @homeWalkingSteps.
  ///
  /// In en, this message translates to:
  /// **'{current} / {goal} steps'**
  String homeWalkingSteps(int current, int goal);

  /// No description provided for @homeWeeklyProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed} / 7 days complete'**
  String homeWeeklyProgress(int completed);

  /// No description provided for @homeCheckInBanner.
  ///
  /// In en, this message translates to:
  /// **'⏱️ Weekly check-in ready — just one minute'**
  String get homeCheckInBanner;

  /// No description provided for @homeRecoveryScore.
  ///
  /// In en, this message translates to:
  /// **'Recovery score'**
  String get homeRecoveryScore;

  /// No description provided for @homeRecoveryReady.
  ///
  /// In en, this message translates to:
  /// **'Your body is ready to train'**
  String get homeRecoveryReady;

  /// No description provided for @homeGuestName.
  ///
  /// In en, this message translates to:
  /// **'Champion'**
  String get homeGuestName;

  /// No description provided for @homePhaseFoundation.
  ///
  /// In en, this message translates to:
  /// **'Foundation'**
  String get homePhaseFoundation;

  /// No description provided for @nutritionFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get nutritionFilterAll;

  /// No description provided for @nutritionFilterQuick.
  ///
  /// In en, this message translates to:
  /// **'Quick'**
  String get nutritionFilterQuick;

  /// No description provided for @nutritionFilterLowCalorie.
  ///
  /// In en, this message translates to:
  /// **'Low calorie'**
  String get nutritionFilterLowCalorie;

  /// No description provided for @nutritionMacroSummary.
  ///
  /// In en, this message translates to:
  /// **'{calories} cal · {protein}g protein'**
  String nutritionMacroSummary(int calories, int protein);

  /// No description provided for @nutritionMacroBar.
  ///
  /// In en, this message translates to:
  /// **'Cal | Protein | Carbs | Fat'**
  String get nutritionMacroBar;

  /// No description provided for @nutritionMealConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed ✓'**
  String get nutritionMealConfirmed;

  /// No description provided for @nutritionFridgeBanner.
  ///
  /// In en, this message translates to:
  /// **'📷 Scan your fridge — {remaining} scans left this month'**
  String nutritionFridgeBanner(int remaining);

  /// No description provided for @nutritionFridgeScanCta.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get nutritionFridgeScanCta;

  /// No description provided for @workoutWarmUpStep1.
  ///
  /// In en, this message translates to:
  /// **'Shoulder circles — 30 seconds'**
  String get workoutWarmUpStep1;

  /// No description provided for @workoutWarmUpStep2.
  ///
  /// In en, this message translates to:
  /// **'March in place — 60 seconds'**
  String get workoutWarmUpStep2;

  /// No description provided for @workoutWarmUpStep3.
  ///
  /// In en, this message translates to:
  /// **'Light squats — 10 reps'**
  String get workoutWarmUpStep3;

  /// No description provided for @workoutSkipWarmUp.
  ///
  /// In en, this message translates to:
  /// **'Skip warm-up'**
  String get workoutSkipWarmUp;

  /// No description provided for @workoutStartMainWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start main workout'**
  String get workoutStartMainWorkout;

  /// No description provided for @workoutWarmUpComplete.
  ///
  /// In en, this message translates to:
  /// **'Warm-up done — ready!'**
  String get workoutWarmUpComplete;

  /// No description provided for @homeProgramDay.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of {total}'**
  String homeProgramDay(int day, int total);

  /// No description provided for @homeStartProgram.
  ///
  /// In en, this message translates to:
  /// **'Start your program'**
  String get homeStartProgram;

  /// No description provided for @nutritionDailyCalorieGoal.
  ///
  /// In en, this message translates to:
  /// **'Your daily calorie target'**
  String get nutritionDailyCalorieGoal;

  /// No description provided for @nutritionCalorieTargetSummary.
  ///
  /// In en, this message translates to:
  /// **'Target: {calories} cal — {protein}g protein, {carbs}g carbs, {fat}g fat'**
  String nutritionCalorieTargetSummary(
    int calories,
    int protein,
    int carbs,
    int fat,
  );

  /// No description provided for @nutritionCalorieProgress.
  ///
  /// In en, this message translates to:
  /// **'{consumed} / {target} cal today'**
  String nutritionCalorieProgress(int consumed, int target);

  /// No description provided for @nutritionEditCalorieGoal.
  ///
  /// In en, this message translates to:
  /// **'Edit calorie target'**
  String get nutritionEditCalorieGoal;

  /// No description provided for @nutritionCalorieHint.
  ///
  /// In en, this message translates to:
  /// **'Daily calories'**
  String get nutritionCalorieHint;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsThemeTitle;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get settingsThemeLight;

  /// No description provided for @progressAxisDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get progressAxisDate;

  /// No description provided for @progressAxisWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get progressAxisWeight;

  /// No description provided for @progressAxisEnergy.
  ///
  /// In en, this message translates to:
  /// **'Energy (1–10)'**
  String get progressAxisEnergy;

  /// No description provided for @progressAllChartsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your progress overview'**
  String get progressAllChartsTitle;

  /// No description provided for @profileGuestAvatar.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get profileGuestAvatar;

  /// No description provided for @profileStatProgramDays.
  ///
  /// In en, this message translates to:
  /// **'Program days'**
  String get profileStatProgramDays;

  /// No description provided for @profileStatsSection.
  ///
  /// In en, this message translates to:
  /// **'Your stats'**
  String get profileStatsSection;

  /// No description provided for @profileGoalWeight.
  ///
  /// In en, this message translates to:
  /// **'Goal weight'**
  String get profileGoalWeight;

  /// No description provided for @profileCurrentBmi.
  ///
  /// In en, this message translates to:
  /// **'Current BMI'**
  String get profileCurrentBmi;

  /// No description provided for @profileActivityLevel.
  ///
  /// In en, this message translates to:
  /// **'Activity level'**
  String get profileActivityLevel;

  /// No description provided for @profileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEditProfile;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
