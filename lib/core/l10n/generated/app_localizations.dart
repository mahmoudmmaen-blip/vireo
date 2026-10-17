import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';

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
    Locale('ar', 'EG'),
    Locale('ar', 'SA'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('tr'),
    Locale('ur'),
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

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

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

  /// No description provided for @authSaveProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Save your progress'**
  String get authSaveProgressTitle;

  /// No description provided for @authSaveProgressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Link an account so your plan, scans, and chats sync across devices.'**
  String get authSaveProgressSubtitle;

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

  /// No description provided for @authContinueApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authContinueApple;

  /// No description provided for @authContinueGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueGoogle;

  /// No description provided for @authContinueEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with email'**
  String get authContinueEmail;

  /// No description provided for @authSignInWithPassword.
  ///
  /// In en, this message translates to:
  /// **'Sign in with password'**
  String get authSignInWithPassword;

  /// No description provided for @authSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get authSendCode;

  /// No description provided for @authVerifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get authVerifyCode;

  /// No description provided for @authResendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authResendCode;

  /// No description provided for @authResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String authResendIn(int seconds);

  /// No description provided for @authOtpSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {email}'**
  String authOtpSentTo(String email);

  /// No description provided for @authBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get authBack;

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

  /// No description provided for @authErrorOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet. Check your connection and try again.'**
  String get authErrorOffline;

  /// No description provided for @authErrorWrongCode.
  ///
  /// In en, this message translates to:
  /// **'Wrong code. Check the digits and try again.'**
  String get authErrorWrongCode;

  /// No description provided for @authErrorTooMany.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts, try again in a minute.'**
  String get authErrorTooMany;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorCancelled.
  ///
  /// In en, this message translates to:
  /// **'Sign-in was cancelled.'**
  String get authErrorCancelled;

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

  /// No description provided for @authGateAiFeatures.
  ///
  /// In en, this message translates to:
  /// **'Create a free account to use AI meal scan and Vireo Coach. Your chats and scans sync securely to your account.'**
  String get authGateAiFeatures;

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
  /// **'Steps are counted on this device. If Health Connect / Apple Health is also available, Vireo shows the higher count.'**
  String get walkingHealthSourceNote;

  /// No description provided for @walkingPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Steps access needed'**
  String get walkingPermissionTitle;

  /// No description provided for @walkingPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Vireo counts steps with your phone’s motion sensors. Allow activity access so walking goals and calories stay accurate.'**
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
  /// **'Step tracking works best on a physical iOS or Android phone with a step counter sensor.'**
  String get walkingUnavailableBody;

  /// No description provided for @walkingEnableTitle.
  ///
  /// In en, this message translates to:
  /// **'Count steps on this phone'**
  String get walkingEnableTitle;

  /// No description provided for @walkingEnableBody.
  ///
  /// In en, this message translates to:
  /// **'Vireo uses your phone’s step sensor to track walking live — distance, calories, and your daily goal. We’ll ask for activity permission next.'**
  String get walkingEnableBody;

  /// No description provided for @walkingEnableCta.
  ///
  /// In en, this message translates to:
  /// **'Enable step counting'**
  String get walkingEnableCta;

  /// No description provided for @walkingActiveMinutes.
  ///
  /// In en, this message translates to:
  /// **'Active time'**
  String get walkingActiveMinutes;

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
  /// **'Unlimited Instant Plate Scans'**
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

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsThemeSystem;

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

  /// No description provided for @profileBmiUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get profileBmiUnderweight;

  /// No description provided for @profileBmiHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy weight'**
  String get profileBmiHealthy;

  /// No description provided for @profileBmiOverweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get profileBmiOverweight;

  /// No description provided for @profileBmiObese.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get profileBmiObese;

  /// No description provided for @profileBmiTooltip.
  ///
  /// In en, this message translates to:
  /// **'BMI (Body Mass Index) estimates body fat from height and weight. It is a general guide — not a diagnosis.'**
  String get profileBmiTooltip;

  /// No description provided for @workoutSplitChestTriceps.
  ///
  /// In en, this message translates to:
  /// **'Chest & Triceps'**
  String get workoutSplitChestTriceps;

  /// No description provided for @workoutSplitBackBiceps.
  ///
  /// In en, this message translates to:
  /// **'Back & Biceps'**
  String get workoutSplitBackBiceps;

  /// No description provided for @workoutSplitLegs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get workoutSplitLegs;

  /// No description provided for @workoutSplitCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get workoutSplitCardio;

  /// No description provided for @workoutSplitShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get workoutSplitShoulders;

  /// No description provided for @workoutSplitFullBody.
  ///
  /// In en, this message translates to:
  /// **'Full Body'**
  String get workoutSplitFullBody;

  /// No description provided for @workoutSplitRest.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get workoutSplitRest;

  /// No description provided for @habitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily habits'**
  String get habitsTitle;

  /// No description provided for @habitsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No habits yet — tap + to add your first one'**
  String get habitsEmpty;

  /// No description provided for @habitsAddTitle.
  ///
  /// In en, this message translates to:
  /// **'New habit'**
  String get habitsAddTitle;

  /// No description provided for @habitsAddHint.
  ///
  /// In en, this message translates to:
  /// **'Habit name'**
  String get habitsAddHint;

  /// No description provided for @habitsAddConfirm.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get habitsAddConfirm;

  /// No description provided for @habitsStreak.
  ///
  /// In en, this message translates to:
  /// **'{days} day streak'**
  String habitsStreak(int days);

  /// No description provided for @habitsRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get habitsRetry;

  /// No description provided for @habitsErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load habits'**
  String get habitsErrorTitle;

  /// No description provided for @homeRecoveryExplain.
  ///
  /// In en, this message translates to:
  /// **'A recovery score of {score}% blends sleep quality, rest days, and muscle fatigue. Higher means your body is ready to train hard.'**
  String homeRecoveryExplain(int score);

  /// No description provided for @homeRecoveryFactorSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep quality'**
  String get homeRecoveryFactorSleep;

  /// No description provided for @homeRecoveryFactorRest.
  ///
  /// In en, this message translates to:
  /// **'Rest days'**
  String get homeRecoveryFactorRest;

  /// No description provided for @homeRecoveryFactorMuscle.
  ///
  /// In en, this message translates to:
  /// **'Muscle fatigue'**
  String get homeRecoveryFactorMuscle;

  /// No description provided for @homeRecoveryTipSleep.
  ///
  /// In en, this message translates to:
  /// **'Aim for 7–9 hours tonight'**
  String get homeRecoveryTipSleep;

  /// No description provided for @homeRecoveryTipRest.
  ///
  /// In en, this message translates to:
  /// **'Keep at least one full rest day weekly'**
  String get homeRecoveryTipRest;

  /// No description provided for @homeRecoveryTipMuscle.
  ///
  /// In en, this message translates to:
  /// **'Ease intensity if soreness is high'**
  String get homeRecoveryTipMuscle;

  /// No description provided for @homeRecoveryImproveTitle.
  ///
  /// In en, this message translates to:
  /// **'Tips to improve'**
  String get homeRecoveryImproveTitle;

  /// No description provided for @homeRecoveryImproveBody.
  ///
  /// In en, this message translates to:
  /// **'Prioritize sleep, hydrate, and swap a hard session for mobility when fatigue spikes.'**
  String get homeRecoveryImproveBody;

  /// No description provided for @walkingMetricsTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s walking metrics'**
  String get walkingMetricsTitle;

  /// No description provided for @walkingDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get walkingDistance;

  /// No description provided for @walkingSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get walkingSpeed;

  /// No description provided for @walkingPace.
  ///
  /// In en, this message translates to:
  /// **'Pace'**
  String get walkingPace;

  /// No description provided for @walkingCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories burned'**
  String get walkingCalories;

  /// No description provided for @walkingWeightLoss.
  ///
  /// In en, this message translates to:
  /// **'Est. fat burn ≈ {kg} kg'**
  String walkingWeightLoss(String kg);

  /// No description provided for @walkingCadence.
  ///
  /// In en, this message translates to:
  /// **'Cadence ≈ {spm} steps/min'**
  String walkingCadence(int spm);

  /// No description provided for @walkingMetricsEstimatedNote.
  ///
  /// In en, this message translates to:
  /// **'Health Connect unavailable — showing estimated metrics from step count.'**
  String get walkingMetricsEstimatedNote;

  /// No description provided for @mealBuilderTitle.
  ///
  /// In en, this message translates to:
  /// **'Customize ingredients'**
  String get mealBuilderTitle;

  /// No description provided for @mealBuilderTitleFor.
  ///
  /// In en, this message translates to:
  /// **'Customize {meal}'**
  String mealBuilderTitleFor(String meal);

  /// No description provided for @mealBuilderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust protein, cooking fat, and add-ons — macros update live.'**
  String get mealBuilderSubtitle;

  /// No description provided for @mealBuilderEggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get mealBuilderEggs;

  /// No description provided for @mealBuilderEggCount.
  ///
  /// In en, this message translates to:
  /// **'{count} eggs'**
  String mealBuilderEggCount(int count);

  /// No description provided for @mealBuilderPortionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} portions'**
  String mealBuilderPortionCount(int count);

  /// No description provided for @mealBuilderProteinLunch.
  ///
  /// In en, this message translates to:
  /// **'Protein portions'**
  String get mealBuilderProteinLunch;

  /// No description provided for @mealBuilderProteinDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner protein'**
  String get mealBuilderProteinDinner;

  /// No description provided for @mealBuilderProteinSnack.
  ///
  /// In en, this message translates to:
  /// **'Snack protein'**
  String get mealBuilderProteinSnack;

  /// No description provided for @mealBuilderFatSource.
  ///
  /// In en, this message translates to:
  /// **'Fat source'**
  String get mealBuilderFatSource;

  /// No description provided for @mealBuilderFatButter.
  ///
  /// In en, this message translates to:
  /// **'Butter'**
  String get mealBuilderFatButter;

  /// No description provided for @mealBuilderFatGhee.
  ///
  /// In en, this message translates to:
  /// **'Ghee'**
  String get mealBuilderFatGhee;

  /// No description provided for @mealBuilderFatOliveOil.
  ///
  /// In en, this message translates to:
  /// **'Olive oil'**
  String get mealBuilderFatOliveOil;

  /// No description provided for @mealBuilderFatSpray.
  ///
  /// In en, this message translates to:
  /// **'Oil spray'**
  String get mealBuilderFatSpray;

  /// No description provided for @mealBuilderAddOns.
  ///
  /// In en, this message translates to:
  /// **'Add-ons'**
  String get mealBuilderAddOns;

  /// No description provided for @mealBuilderAddonCheese.
  ///
  /// In en, this message translates to:
  /// **'Cheese'**
  String get mealBuilderAddonCheese;

  /// No description provided for @mealBuilderAddonVeggies.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get mealBuilderAddonVeggies;

  /// No description provided for @mealBuilderAddonBread.
  ///
  /// In en, this message translates to:
  /// **'Whole grain bread'**
  String get mealBuilderAddonBread;

  /// No description provided for @mealBuilderAddonRice.
  ///
  /// In en, this message translates to:
  /// **'Rice'**
  String get mealBuilderAddonRice;

  /// No description provided for @mealBuilderAddonYogurt.
  ///
  /// In en, this message translates to:
  /// **'Yogurt'**
  String get mealBuilderAddonYogurt;

  /// No description provided for @mealBuilderLiveMacros.
  ///
  /// In en, this message translates to:
  /// **'Live macros'**
  String get mealBuilderLiveMacros;

  /// No description provided for @weeklyCheckInTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly check-in'**
  String get weeklyCheckInTitle;

  /// No description provided for @weeklyCheckInBanner.
  ///
  /// In en, this message translates to:
  /// **'Time for your weekly assessment — update weight & energy'**
  String get weeklyCheckInBanner;

  /// No description provided for @weeklyCheckInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll recalculate your BMR/TDEE and macros for next week.'**
  String get weeklyCheckInSubtitle;

  /// No description provided for @weeklyCheckInWeight.
  ///
  /// In en, this message translates to:
  /// **'Current weight'**
  String get weeklyCheckInWeight;

  /// No description provided for @weeklyCheckInWaist.
  ///
  /// In en, this message translates to:
  /// **'Waist measurement'**
  String get weeklyCheckInWaist;

  /// No description provided for @weeklyCheckInEnergy.
  ///
  /// In en, this message translates to:
  /// **'Energy level (1–5)'**
  String get weeklyCheckInEnergy;

  /// No description provided for @weeklyCheckInAdherence.
  ///
  /// In en, this message translates to:
  /// **'Training adherence: {pct}%'**
  String weeklyCheckInAdherence(int pct);

  /// No description provided for @weeklyCheckInSubmit.
  ///
  /// In en, this message translates to:
  /// **'Update my targets'**
  String get weeklyCheckInSubmit;

  /// No description provided for @weeklyCheckInDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Targets updated'**
  String get weeklyCheckInDoneTitle;

  /// No description provided for @weeklyCheckInDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Calories {prev} → {next} kcal. Macros: {protein}g protein, {carbs}g carbs, {fat}g fat.'**
  String weeklyCheckInDoneBody(
    int prev,
    int next,
    int protein,
    int carbs,
    int fat,
  );

  /// No description provided for @settingsAccentTitle.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get settingsAccentTitle;

  /// No description provided for @settingsAccentOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get settingsAccentOrange;

  /// No description provided for @settingsAccentEmerald.
  ///
  /// In en, this message translates to:
  /// **'Emerald'**
  String get settingsAccentEmerald;

  /// No description provided for @settingsAccentBlue.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get settingsAccentBlue;

  /// No description provided for @settingsAccentViolet.
  ///
  /// In en, this message translates to:
  /// **'Violet'**
  String get settingsAccentViolet;

  /// No description provided for @settingsSkinTitle.
  ///
  /// In en, this message translates to:
  /// **'Color theme skins'**
  String get settingsSkinTitle;

  /// No description provided for @settingsSkinStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get settingsSkinStandard;

  /// No description provided for @settingsSkinStandardDesc.
  ///
  /// In en, this message translates to:
  /// **'Classic Vireo dark / light'**
  String get settingsSkinStandardDesc;

  /// No description provided for @settingsSkinAmoled.
  ///
  /// In en, this message translates to:
  /// **'AMOLED Pure Black'**
  String get settingsSkinAmoled;

  /// No description provided for @settingsSkinAmoledDesc.
  ///
  /// In en, this message translates to:
  /// **'True black with gold & cyan accents'**
  String get settingsSkinAmoledDesc;

  /// No description provided for @settingsSkinNavy.
  ///
  /// In en, this message translates to:
  /// **'Deep Navy Blue'**
  String get settingsSkinNavy;

  /// No description provided for @settingsSkinNavyDesc.
  ///
  /// In en, this message translates to:
  /// **'Navy #0B192C with ice blue & teal'**
  String get settingsSkinNavyDesc;

  /// No description provided for @settingsAccentLockedHint.
  ///
  /// In en, this message translates to:
  /// **'Accent swatches are locked while AMOLED / Navy skin is active.'**
  String get settingsAccentLockedHint;

  /// No description provided for @workoutSwapWarmUp.
  ///
  /// In en, this message translates to:
  /// **'Swap warm-up move'**
  String get workoutSwapWarmUp;

  /// No description provided for @workoutSwapWarmUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a warm-up alternative'**
  String get workoutSwapWarmUpTitle;

  /// No description provided for @workoutSwapWarmUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mobility and low-impact options for your training environment.'**
  String get workoutSwapWarmUpSubtitle;

  /// No description provided for @profileBmiExplainShort.
  ///
  /// In en, this message translates to:
  /// **'BMI assesses weight relative to height.'**
  String get profileBmiExplainShort;

  /// No description provided for @profileBmiExplainFull.
  ///
  /// In en, this message translates to:
  /// **'Body Mass Index (BMI) is a measure to assess weight relative to height. It is a general screening tool — not a medical diagnosis.'**
  String get profileBmiExplainFull;

  /// No description provided for @mealBuilderCheeseTitle.
  ///
  /// In en, this message translates to:
  /// **'Cheese'**
  String get mealBuilderCheeseTitle;

  /// No description provided for @mealBuilderCheeseNone.
  ///
  /// In en, this message translates to:
  /// **'No cheese'**
  String get mealBuilderCheeseNone;

  /// No description provided for @mealBuilderCheeseCottage.
  ///
  /// In en, this message translates to:
  /// **'Cottage cheese'**
  String get mealBuilderCheeseCottage;

  /// No description provided for @mealBuilderCheeseCheddar.
  ///
  /// In en, this message translates to:
  /// **'Cheddar'**
  String get mealBuilderCheeseCheddar;

  /// No description provided for @mealBuilderCheeseMozzarella.
  ///
  /// In en, this message translates to:
  /// **'Mozzarella'**
  String get mealBuilderCheeseMozzarella;

  /// No description provided for @mealBuilderCheeseFeta.
  ///
  /// In en, this message translates to:
  /// **'Feta'**
  String get mealBuilderCheeseFeta;

  /// No description provided for @mealBuilderCheeseGrams.
  ///
  /// In en, this message translates to:
  /// **'Quantity: {grams}g'**
  String mealBuilderCheeseGrams(int grams);

  /// No description provided for @homeRecoveryFormulaExplain.
  ///
  /// In en, this message translates to:
  /// **'Recovery = Rest days (40%) + Step target (30%) + Meal/workout consistency (30%).'**
  String get homeRecoveryFormulaExplain;

  /// No description provided for @homeRecoveryFactorRestDays.
  ///
  /// In en, this message translates to:
  /// **'Rest days'**
  String get homeRecoveryFactorRestDays;

  /// No description provided for @homeRecoveryFactorSteps.
  ///
  /// In en, this message translates to:
  /// **'Step count target'**
  String get homeRecoveryFactorSteps;

  /// No description provided for @homeRecoveryFactorConsistency.
  ///
  /// In en, this message translates to:
  /// **'Meal & workout consistency'**
  String get homeRecoveryFactorConsistency;

  /// No description provided for @homeRecoveryRestDetail.
  ///
  /// In en, this message translates to:
  /// **'{days} rest day(s) this week'**
  String homeRecoveryRestDetail(int days);

  /// No description provided for @homeRecoveryStepsDetail.
  ///
  /// In en, this message translates to:
  /// **'{current} / {goal} steps today'**
  String homeRecoveryStepsDetail(int current, int goal);

  /// No description provided for @homeRecoveryConsistencyDetail.
  ///
  /// In en, this message translates to:
  /// **'Meals {mealsDone}/{mealsTotal} · Workouts {wDone}/{wTotal}'**
  String homeRecoveryConsistencyDetail(
    int mealsDone,
    int mealsTotal,
    int wDone,
    int wTotal,
  );

  /// No description provided for @homeRecoveryTipSteps.
  ///
  /// In en, this message translates to:
  /// **'Hit your daily step goal to lift this pillar'**
  String get homeRecoveryTipSteps;

  /// No description provided for @homeRecoveryTipConsistency.
  ///
  /// In en, this message translates to:
  /// **'Confirm meals and finish planned workouts'**
  String get homeRecoveryTipConsistency;

  /// No description provided for @homeRecoveryMathLine.
  ///
  /// In en, this message translates to:
  /// **'{rest} + {steps} + {consistency} = {total}%'**
  String homeRecoveryMathLine(int rest, int steps, int consistency, int total);

  /// No description provided for @cardioTitle.
  ///
  /// In en, this message translates to:
  /// **'Cardio & daily activity'**
  String get cardioTitle;

  /// No description provided for @cardioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log brisk walks, runs, and more — calories use MET × weight × time.'**
  String get cardioSubtitle;

  /// No description provided for @cardioSelectActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get cardioSelectActivity;

  /// No description provided for @cardioDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration: {minutes} min'**
  String cardioDuration(int minutes);

  /// No description provided for @cardioEstimatedBurn.
  ///
  /// In en, this message translates to:
  /// **'Est. burn: {kcal} kcal'**
  String cardioEstimatedBurn(int kcal);

  /// No description provided for @cardioMetHint.
  ///
  /// In en, this message translates to:
  /// **'MET {met} · formula: MET × kg × hours'**
  String cardioMetHint(String met);

  /// No description provided for @cardioLogButton.
  ///
  /// In en, this message translates to:
  /// **'Log activity'**
  String get cardioLogButton;

  /// No description provided for @cardioLoggedSnack.
  ///
  /// In en, this message translates to:
  /// **'Cardio session logged'**
  String get cardioLoggedSnack;

  /// No description provided for @cardioTodayTotal.
  ///
  /// In en, this message translates to:
  /// **'Burned today: {kcal} kcal'**
  String cardioTodayTotal(int kcal);

  /// No description provided for @cardioEmpty.
  ///
  /// In en, this message translates to:
  /// **'No cardio logged yet — add your first session above.'**
  String get cardioEmpty;

  /// No description provided for @cardioLogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min · {kcal} kcal'**
  String cardioLogSubtitle(int minutes, int kcal);

  /// No description provided for @cardioLogCta.
  ///
  /// In en, this message translates to:
  /// **'Log cardio activity'**
  String get cardioLogCta;

  /// No description provided for @cardioBriskWalking.
  ///
  /// In en, this message translates to:
  /// **'Brisk walking'**
  String get cardioBriskWalking;

  /// No description provided for @cardioRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get cardioRunning;

  /// No description provided for @cardioCycling.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get cardioCycling;

  /// No description provided for @cardioSwimming.
  ///
  /// In en, this message translates to:
  /// **'Swimming'**
  String get cardioSwimming;

  /// No description provided for @cardioJumpRope.
  ///
  /// In en, this message translates to:
  /// **'Jump rope'**
  String get cardioJumpRope;

  /// No description provided for @cardioHiit.
  ///
  /// In en, this message translates to:
  /// **'HIIT'**
  String get cardioHiit;

  /// No description provided for @cardioElliptical.
  ///
  /// In en, this message translates to:
  /// **'Elliptical'**
  String get cardioElliptical;

  /// No description provided for @workoutGoalPlanLabel.
  ///
  /// In en, this message translates to:
  /// **'Plan for: {goal}'**
  String workoutGoalPlanLabel(String goal);

  /// No description provided for @aiScanTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Meal Scanner'**
  String get aiScanTitle;

  /// No description provided for @aiScanPrompt.
  ///
  /// In en, this message translates to:
  /// **'Photograph your meal — AI estimates calories and macros from the portion size.'**
  String get aiScanPrompt;

  /// No description provided for @aiScanCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get aiScanCamera;

  /// No description provided for @aiScanGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get aiScanGallery;

  /// No description provided for @aiScanAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing meal…'**
  String get aiScanAnalyzing;

  /// No description provided for @aiScanOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get aiScanOffline;

  /// No description provided for @aiScanFailed.
  ///
  /// In en, this message translates to:
  /// **'Scan failed. Please try again.'**
  String get aiScanFailed;

  /// No description provided for @aiScanParseError.
  ///
  /// In en, this message translates to:
  /// **'Could not read the analysis. Try another photo or enter manually.'**
  String get aiScanParseError;

  /// No description provided for @aiScanConfigError.
  ///
  /// In en, this message translates to:
  /// **'AI scanner is not available right now. Please try again later.'**
  String get aiScanConfigError;

  /// No description provided for @aiDailyLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You have reached today\'s AI limit. Upgrade for a higher daily allowance.'**
  String get aiDailyLimitReached;

  /// No description provided for @aiUpgradeCta.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get aiUpgradeCta;

  /// No description provided for @aiScanTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get aiScanTryAgain;

  /// No description provided for @aiScanManualEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual entry'**
  String get aiScanManualEntry;

  /// No description provided for @aiScanCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan your meal with AI'**
  String get aiScanCardTitle;

  /// No description provided for @aiScanCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Snap a photo — get calories, macros, and smart swaps instantly.'**
  String get aiScanCardSubtitle;

  /// No description provided for @aiScanSaveToLog.
  ///
  /// In en, this message translates to:
  /// **'Save to log'**
  String get aiScanSaveToLog;

  /// No description provided for @aiScanSavedSnack.
  ///
  /// In en, this message translates to:
  /// **'Meal saved to today\'s log'**
  String get aiScanSavedSnack;

  /// No description provided for @aiScanMacroProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get aiScanMacroProtein;

  /// No description provided for @aiScanMacroCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get aiScanMacroCarbs;

  /// No description provided for @aiScanMacroFats.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get aiScanMacroFats;

  /// No description provided for @aiScanSmartSwaps.
  ///
  /// In en, this message translates to:
  /// **'Smart swaps'**
  String get aiScanSmartSwaps;

  /// No description provided for @aiScanCaloriesChip.
  ///
  /// In en, this message translates to:
  /// **'{calories} kcal'**
  String aiScanCaloriesChip(int calories);

  /// No description provided for @aiCoachTitle.
  ///
  /// In en, this message translates to:
  /// **'Vireo AI'**
  String get aiCoachTitle;

  /// No description provided for @aiCoachFabLabel.
  ///
  /// In en, this message translates to:
  /// **'Vireo AI'**
  String get aiCoachFabLabel;

  /// No description provided for @aiCoachInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about meals, macros, or training…'**
  String get aiCoachInputHint;

  /// No description provided for @aiCoachOfflineBanner.
  ///
  /// In en, this message translates to:
  /// **'You are offline — showing cached messages.'**
  String get aiCoachOfflineBanner;

  /// No description provided for @aiCoachChipDinner.
  ///
  /// In en, this message translates to:
  /// **'Suggest a dinner meal'**
  String get aiCoachChipDinner;

  /// No description provided for @aiCoachChipProtein.
  ///
  /// In en, this message translates to:
  /// **'How do I boost protein?'**
  String get aiCoachChipProtein;

  /// No description provided for @aiCoachChipDessert.
  ///
  /// In en, this message translates to:
  /// **'Healthy dessert swap'**
  String get aiCoachChipDessert;

  /// No description provided for @waterAddOneGlass.
  ///
  /// In en, this message translates to:
  /// **'+1 glass ({ml} ml)'**
  String waterAddOneGlass(int ml);

  /// No description provided for @waterLongPressHint.
  ///
  /// In en, this message translates to:
  /// **'Long-press for more amounts'**
  String get waterLongPressHint;

  /// No description provided for @waterQuickAmountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick amounts'**
  String get waterQuickAmountsTitle;

  /// No description provided for @waterDefaultCupTitle.
  ///
  /// In en, this message translates to:
  /// **'Default cup size'**
  String get waterDefaultCupTitle;

  /// No description provided for @waterCustomMl.
  ///
  /// In en, this message translates to:
  /// **'Custom amount'**
  String get waterCustomMl;

  /// No description provided for @waterAddCustom.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get waterAddCustom;

  /// No description provided for @waterTrackerTitle.
  ///
  /// In en, this message translates to:
  /// **'Water intake'**
  String get waterTrackerTitle;

  /// No description provided for @waterTrackerSummary.
  ///
  /// In en, this message translates to:
  /// **'{current}L / {goal}L — {percent}% completed'**
  String waterTrackerSummary(double current, double goal, int percent);

  /// No description provided for @weeklyDeficitChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly calorie balance'**
  String get weeklyDeficitChartTitle;

  /// No description provided for @weeklyDeficitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'TDEE − meals + cardio burn (last 7 days)'**
  String get weeklyDeficitSubtitle;

  /// No description provided for @weeklyDeficitTotal.
  ///
  /// In en, this message translates to:
  /// **'Weekly net balance: {kcal} kcal'**
  String weeklyDeficitTotal(int kcal);

  /// No description provided for @weeklyDeficitEmpty.
  ///
  /// In en, this message translates to:
  /// **'Log meals or cardio to see your weekly calorie balance.'**
  String get weeklyDeficitEmpty;

  /// No description provided for @weeklyDeficitInProgress.
  ///
  /// In en, this message translates to:
  /// **'Today (in progress)'**
  String get weeklyDeficitInProgress;

  /// No description provided for @progressTrendEmpty.
  ///
  /// In en, this message translates to:
  /// **'Log 3 days to see your trend'**
  String get progressTrendEmpty;

  /// No description provided for @adaptiveCalorieCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Adaptive Calorie Target'**
  String get adaptiveCalorieCardTitle;

  /// No description provided for @adaptiveCalorieExplainMath.
  ///
  /// In en, this message translates to:
  /// **'Explain the math'**
  String get adaptiveCalorieExplainMath;

  /// No description provided for @adaptiveCalorieAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept Change'**
  String get adaptiveCalorieAccept;

  /// No description provided for @adaptiveCalorieDismiss.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get adaptiveCalorieDismiss;

  /// No description provided for @weeklyReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Progress Report'**
  String get weeklyReportTitle;

  /// No description provided for @weeklyReportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Friday breakdown & weekly highlights'**
  String get weeklyReportSubtitle;

  /// No description provided for @weeklyReportShareCta.
  ///
  /// In en, this message translates to:
  /// **'Share Report'**
  String get weeklyReportShareCta;

  /// No description provided for @progressPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress Photos'**
  String get progressPhotosTitle;

  /// No description provided for @photosPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Your photos are stored locally on this phone only. They never leave your device unless you enable cloud backup.'**
  String get photosPrivacyNote;

  /// No description provided for @photosCompareSideBySide.
  ///
  /// In en, this message translates to:
  /// **'Side-by-Side Compare'**
  String get photosCompareSideBySide;

  /// No description provided for @photosNeedTwoToCompare.
  ///
  /// In en, this message translates to:
  /// **'Take at least 2 photos to compare before & after'**
  String get photosNeedTwoToCompare;

  /// No description provided for @photoBeforeLabel.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get photoBeforeLabel;

  /// No description provided for @photoAfterLabel.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get photoAfterLabel;

  /// No description provided for @photoMissingFile.
  ///
  /// In en, this message translates to:
  /// **'Image file not found'**
  String get photoMissingFile;

  /// No description provided for @photoSourceCamera.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get photoSourceCamera;

  /// No description provided for @photoSourceGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get photoSourceGallery;

  /// No description provided for @bodyCircumferenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Body Circumference'**
  String get bodyCircumferenceTitle;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements & Badges'**
  String get achievementsTitle;

  /// No description provided for @achievementsUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get achievementsUnlocked;

  /// No description provided for @cookMethodRaw.
  ///
  /// In en, this message translates to:
  /// **'Raw'**
  String get cookMethodRaw;

  /// No description provided for @cookMethodBoiled.
  ///
  /// In en, this message translates to:
  /// **'Boiled'**
  String get cookMethodBoiled;

  /// No description provided for @cookMethodGrilled.
  ///
  /// In en, this message translates to:
  /// **'Grilled'**
  String get cookMethodGrilled;

  /// No description provided for @cookMethodFried.
  ///
  /// In en, this message translates to:
  /// **'Fried'**
  String get cookMethodFried;

  /// No description provided for @cookMethodBaked.
  ///
  /// In en, this message translates to:
  /// **'Baked'**
  String get cookMethodBaked;

  /// No description provided for @cookMethodSteamed.
  ///
  /// In en, this message translates to:
  /// **'Steamed'**
  String get cookMethodSteamed;

  /// No description provided for @cookMethodOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get cookMethodOther;

  /// No description provided for @weeklyDeficitTooltip.
  ///
  /// In en, this message translates to:
  /// **'{net} kcal\nIn: {consumed} · Out: {burned}'**
  String weeklyDeficitTooltip(int net, int consumed, int burned);

  /// No description provided for @uxGoodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String uxGoodMorning(String name);

  /// No description provided for @uxGoodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}'**
  String uxGoodAfternoon(String name);

  /// No description provided for @uxGoodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}'**
  String uxGoodEvening(String name);

  /// No description provided for @uxTodayOverline.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get uxTodayOverline;

  /// No description provided for @uxCaloriesLeft.
  ///
  /// In en, this message translates to:
  /// **'kcal left'**
  String get uxCaloriesLeft;

  /// No description provided for @uxCaloriesOver.
  ///
  /// In en, this message translates to:
  /// **'kcal over'**
  String get uxCaloriesOver;

  /// No description provided for @uxGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get uxGoal;

  /// No description provided for @uxEaten.
  ///
  /// In en, this message translates to:
  /// **'Eaten'**
  String get uxEaten;

  /// No description provided for @uxBurned.
  ///
  /// In en, this message translates to:
  /// **'Burned'**
  String get uxBurned;

  /// No description provided for @uxActionScan.
  ///
  /// In en, this message translates to:
  /// **'Scan meal'**
  String get uxActionScan;

  /// No description provided for @uxActionTrain.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get uxActionTrain;

  /// No description provided for @uxActionCoach.
  ///
  /// In en, this message translates to:
  /// **'AI Coach'**
  String get uxActionCoach;

  /// No description provided for @uxSectionTraining.
  ///
  /// In en, this message translates to:
  /// **'Today\'s training'**
  String get uxSectionTraining;

  /// No description provided for @uxSectionThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get uxSectionThisWeek;

  /// No description provided for @uxSectionTodayLog.
  ///
  /// In en, this message translates to:
  /// **'Today\'s log'**
  String get uxSectionTodayLog;

  /// No description provided for @uxAddMeal.
  ///
  /// In en, this message translates to:
  /// **'+ Add meal'**
  String get uxAddMeal;

  /// No description provided for @uxAiScanned.
  ///
  /// In en, this message translates to:
  /// **'AI scan'**
  String get uxAiScanned;

  /// No description provided for @uxMealRemoved.
  ///
  /// In en, this message translates to:
  /// **'Meal removed'**
  String get uxMealRemoved;

  /// No description provided for @uxLogEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged yet'**
  String get uxLogEmptyTitle;

  /// No description provided for @uxLogEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Snap a photo of your meal — AI counts the calories and macros in seconds.'**
  String get uxLogEmptyBody;

  /// No description provided for @uxRestDayHint.
  ///
  /// In en, this message translates to:
  /// **'Recovery is training too. Walk, stretch and hit your protein.'**
  String get uxRestDayHint;

  /// No description provided for @uxWorkoutMinutes.
  ///
  /// In en, this message translates to:
  /// **'~{minutes} min'**
  String uxWorkoutMinutes(int minutes);

  /// No description provided for @uxWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get uxWater;

  /// No description provided for @uxGlassSize.
  ///
  /// In en, this message translates to:
  /// **'250 ml'**
  String get uxGlassSize;

  /// No description provided for @uxWaterAdded.
  ///
  /// In en, this message translates to:
  /// **'+250 ml · {liters} L today'**
  String uxWaterAdded(String liters);

  /// No description provided for @uxWaterGoalDone.
  ///
  /// In en, this message translates to:
  /// **'Water goal reached 💧 great job!'**
  String get uxWaterGoalDone;

  /// No description provided for @uxUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get uxUndo;

  /// No description provided for @uxCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get uxCopied;

  /// No description provided for @uxSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get uxSend;

  /// No description provided for @uxQuickLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick log'**
  String get uxQuickLogTitle;

  /// No description provided for @uxQuickLogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log anything in one tap.'**
  String get uxQuickLogSubtitle;

  /// No description provided for @uxQuickScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan a meal with AI'**
  String get uxQuickScanTitle;

  /// No description provided for @uxQuickScanSub.
  ///
  /// In en, this message translates to:
  /// **'Calories & macros in seconds'**
  String get uxQuickScanSub;

  /// No description provided for @uxQuickWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get uxQuickWater;

  /// No description provided for @uxQuickWaterSub.
  ///
  /// In en, this message translates to:
  /// **'+1 glass · 250 ml'**
  String get uxQuickWaterSub;

  /// No description provided for @uxQuickWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get uxQuickWeight;

  /// No description provided for @uxQuickWeightSub.
  ///
  /// In en, this message translates to:
  /// **'Log today\'s weigh-in'**
  String get uxQuickWeightSub;

  /// No description provided for @uxQuickCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get uxQuickCardio;

  /// No description provided for @uxQuickCardioSub.
  ///
  /// In en, this message translates to:
  /// **'Walk, run, bike…'**
  String get uxQuickCardioSub;

  /// No description provided for @uxQuickCoach.
  ///
  /// In en, this message translates to:
  /// **'Ask coach'**
  String get uxQuickCoach;

  /// No description provided for @uxQuickCoachSub.
  ///
  /// In en, this message translates to:
  /// **'Personal AI advice'**
  String get uxQuickCoachSub;

  /// No description provided for @uxCoachOnline.
  ///
  /// In en, this message translates to:
  /// **'Online · knows your macros'**
  String get uxCoachOnline;

  /// No description provided for @uxCoachTyping.
  ///
  /// In en, this message translates to:
  /// **'Typing…'**
  String get uxCoachTyping;

  /// No description provided for @uxCoachNewChat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get uxCoachNewChat;

  /// No description provided for @uxCoachClearConfirm.
  ///
  /// In en, this message translates to:
  /// **'Start a new conversation? Current messages will be cleared.'**
  String get uxCoachClearConfirm;

  /// No description provided for @uxCoachHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Your personal AI coach'**
  String get uxCoachHeroTitle;

  /// No description provided for @uxCoachHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Ask about meals, protein, cravings or training. Every answer is based on your numbers today.'**
  String get uxCoachHeroBody;

  /// No description provided for @uxCoachKcalLeft.
  ///
  /// In en, this message translates to:
  /// **'{kcal} kcal left'**
  String uxCoachKcalLeft(int kcal);

  /// No description provided for @uxCoachProteinLeft.
  ///
  /// In en, this message translates to:
  /// **'{grams}g protein left'**
  String uxCoachProteinLeft(int grams);

  /// No description provided for @uxCoachChipWorkout.
  ///
  /// In en, this message translates to:
  /// **'What should I eat before training?'**
  String get uxCoachChipWorkout;

  /// No description provided for @uxProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get uxProtein;

  /// No description provided for @uxCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get uxCarbs;

  /// No description provided for @uxFat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get uxFat;

  /// No description provided for @aiScanAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'AI analysis'**
  String get aiScanAnalysisTitle;

  /// No description provided for @diaryAddMeal.
  ///
  /// In en, this message translates to:
  /// **'Add Meal'**
  String get diaryAddMeal;

  /// No description provided for @diaryAddWorkout.
  ///
  /// In en, this message translates to:
  /// **'Add Workout'**
  String get diaryAddWorkout;

  /// No description provided for @diaryCaloriesIn.
  ///
  /// In en, this message translates to:
  /// **'Calories In'**
  String get diaryCaloriesIn;

  /// No description provided for @diaryCaloriesOut.
  ///
  /// In en, this message translates to:
  /// **'Calories Out'**
  String get diaryCaloriesOut;

  /// No description provided for @diaryKcal.
  ///
  /// In en, this message translates to:
  /// **'{kcal} kcal'**
  String diaryKcal(int kcal);

  /// No description provided for @diaryLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {count}'**
  String diaryLastUpdated(String count);

  /// No description provided for @diaryMealCalories.
  ///
  /// In en, this message translates to:
  /// **'{calories} kcal'**
  String diaryMealCalories(int calories);

  /// No description provided for @diaryNetBalance.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get diaryNetBalance;

  /// No description provided for @diaryNoEntries.
  ///
  /// In en, this message translates to:
  /// **'No entries for this day'**
  String get diaryNoEntries;

  /// No description provided for @diaryProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get diaryProtein;

  /// No description provided for @diaryProteinProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {goal} g'**
  String diaryProteinProgress(int current, int goal);

  /// No description provided for @diarySetGoalsCta.
  ///
  /// In en, this message translates to:
  /// **'Set goals'**
  String get diarySetGoalsCta;

  /// No description provided for @diarySetGoalsFirst.
  ///
  /// In en, this message translates to:
  /// **'Set your goals first'**
  String get diarySetGoalsFirst;

  /// No description provided for @diaryTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get diaryTimeline;

  /// No description provided for @diaryTitle.
  ///
  /// In en, this message translates to:
  /// **'My Diary'**
  String get diaryTitle;

  /// No description provided for @diaryToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get diaryToday;

  /// No description provided for @diaryWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get diaryWater;

  /// No description provided for @diaryWaterAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} ml'**
  String diaryWaterAmount(int amount);

  /// No description provided for @diaryWaterProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {goal} ml'**
  String diaryWaterProgress(int current, int goal);

  /// No description provided for @diaryWorkoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min · {calories} kcal'**
  String diaryWorkoutSubtitle(int minutes, int calories);

  /// No description provided for @exerciseAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get exerciseAdvanced;

  /// No description provided for @exerciseBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get exerciseBeginner;

  /// No description provided for @exerciseComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete Set'**
  String get exerciseComplete;

  /// No description provided for @exerciseDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get exerciseDifficulty;

  /// No description provided for @exerciseEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get exerciseEquipment;

  /// No description provided for @exerciseIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get exerciseIntermediate;

  /// No description provided for @exerciseLoadingDemo.
  ///
  /// In en, this message translates to:
  /// **'Loading exercise demo...'**
  String get exerciseLoadingDemo;

  /// No description provided for @exerciseMistakes.
  ///
  /// In en, this message translates to:
  /// **'Common Mistakes'**
  String get exerciseMistakes;

  /// No description provided for @exerciseReps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get exerciseReps;

  /// No description provided for @exerciseRest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get exerciseRest;

  /// No description provided for @exerciseSets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get exerciseSets;

  /// No description provided for @exerciseSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get exerciseSteps;

  /// No description provided for @exerciseTips.
  ///
  /// In en, this message translates to:
  /// **'Pro Tips'**
  String get exerciseTips;

  /// No description provided for @exerciseViewBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get exerciseViewBack;

  /// No description provided for @exerciseViewFront.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get exerciseViewFront;

  /// No description provided for @measurements30Days.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get measurements30Days;

  /// No description provided for @measurements3Months.
  ///
  /// In en, this message translates to:
  /// **'3 months'**
  String get measurements3Months;

  /// No description provided for @measurements7Days.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get measurements7Days;

  /// No description provided for @measurementsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add measurement'**
  String get measurementsAdd;

  /// No description provided for @measurementsAddFirst.
  ///
  /// In en, this message translates to:
  /// **'Log your first measurement'**
  String get measurementsAddFirst;

  /// No description provided for @measurementsAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get measurementsAll;

  /// No description provided for @measurementsArms.
  ///
  /// In en, this message translates to:
  /// **'Arms'**
  String get measurementsArms;

  /// No description provided for @measurementsBodyFat.
  ///
  /// In en, this message translates to:
  /// **'Body fat %'**
  String get measurementsBodyFat;

  /// No description provided for @measurementsChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get measurementsChest;

  /// No description provided for @measurementsDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get measurementsDate;

  /// No description provided for @measurementsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get measurementsDelete;

  /// No description provided for @measurementsDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this measurement?'**
  String get measurementsDeleteConfirm;

  /// No description provided for @measurementsHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get measurementsHistory;

  /// No description provided for @measurementsLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String measurementsLastUpdated(String date);

  /// No description provided for @measurementsNeedMoreData.
  ///
  /// In en, this message translates to:
  /// **'Log more entries to see trends'**
  String get measurementsNeedMoreData;

  /// No description provided for @measurementsNoData.
  ///
  /// In en, this message translates to:
  /// **'No measurements yet'**
  String get measurementsNoData;

  /// No description provided for @measurementsNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get measurementsNotes;

  /// No description provided for @measurementsSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get measurementsSave;

  /// No description provided for @measurementsThighs.
  ///
  /// In en, this message translates to:
  /// **'Thighs'**
  String get measurementsThighs;

  /// No description provided for @measurementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get measurementsTitle;

  /// No description provided for @measurementsTrendDeclining.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get measurementsTrendDeclining;

  /// No description provided for @measurementsTrendImproving.
  ///
  /// In en, this message translates to:
  /// **'Improving'**
  String get measurementsTrendImproving;

  /// No description provided for @measurementsTrendStable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get measurementsTrendStable;

  /// No description provided for @measurementsWaist.
  ///
  /// In en, this message translates to:
  /// **'Waist'**
  String get measurementsWaist;

  /// No description provided for @measurementsWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get measurementsWeight;

  /// No description provided for @measurementsWeightInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid weight'**
  String get measurementsWeightInvalid;

  /// No description provided for @muscleBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get muscleBack;

  /// No description provided for @muscleBiceps.
  ///
  /// In en, this message translates to:
  /// **'Biceps'**
  String get muscleBiceps;

  /// No description provided for @muscleCalves.
  ///
  /// In en, this message translates to:
  /// **'Calves'**
  String get muscleCalves;

  /// No description provided for @muscleChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get muscleChest;

  /// No description provided for @muscleCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get muscleCore;

  /// No description provided for @muscleForearms.
  ///
  /// In en, this message translates to:
  /// **'Forearms'**
  String get muscleForearms;

  /// No description provided for @muscleGlutes.
  ///
  /// In en, this message translates to:
  /// **'Glutes'**
  String get muscleGlutes;

  /// No description provided for @muscleHamstrings.
  ///
  /// In en, this message translates to:
  /// **'Hamstrings'**
  String get muscleHamstrings;

  /// No description provided for @muscleHipFlexors.
  ///
  /// In en, this message translates to:
  /// **'Hip Flexors'**
  String get muscleHipFlexors;

  /// No description provided for @muscleQuads.
  ///
  /// In en, this message translates to:
  /// **'Quads'**
  String get muscleQuads;

  /// No description provided for @muscleShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get muscleShoulders;

  /// No description provided for @muscleTriceps.
  ///
  /// In en, this message translates to:
  /// **'Triceps'**
  String get muscleTriceps;

  /// No description provided for @notificationsBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast reminder'**
  String get notificationsBreakfast;

  /// No description provided for @notificationsDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner reminder'**
  String get notificationsDinner;

  /// No description provided for @notificationsLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch reminder'**
  String get notificationsLunch;

  /// No description provided for @notificationsOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get notificationsOpenSettings;

  /// No description provided for @notificationsPermissionBanner.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications to stay on track'**
  String get notificationsPermissionBanner;

  /// No description provided for @notificationsPreWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout reminder'**
  String get notificationsPreWorkout;

  /// No description provided for @notificationsPreWorkoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get ready to train'**
  String get notificationsPreWorkoutSubtitle;

  /// No description provided for @notificationsSleep.
  ///
  /// In en, this message translates to:
  /// **'Bedtime reminder'**
  String get notificationsSleep;

  /// No description provided for @notificationsSleepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Wind down for better recovery'**
  String get notificationsSleepSubtitle;

  /// No description provided for @notificationsTest.
  ///
  /// In en, this message translates to:
  /// **'Send test notification'**
  String get notificationsTest;

  /// No description provided for @notificationsTestBody.
  ///
  /// In en, this message translates to:
  /// **'Vireo reminders are working'**
  String get notificationsTestBody;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get notificationsTitle;

  /// No description provided for @notificationsWater.
  ///
  /// In en, this message translates to:
  /// **'Water reminder'**
  String get notificationsWater;

  /// No description provided for @notificationsWaterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay hydrated through the day'**
  String get notificationsWaterSubtitle;

  /// No description provided for @notificationsWeeklyReport.
  ///
  /// In en, this message translates to:
  /// **'Weekly check-in'**
  String get notificationsWeeklyReport;

  /// No description provided for @notificationsWeeklyReportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See how your week went'**
  String get notificationsWeeklyReportSubtitle;

  /// No description provided for @notificationsFastingOpen.
  ///
  /// In en, this message translates to:
  /// **'Fasting window opens'**
  String get notificationsFastingOpen;

  /// No description provided for @notificationsFastingOpenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Time to start your eating window'**
  String get notificationsFastingOpenSubtitle;

  /// No description provided for @notificationsFastingClose.
  ///
  /// In en, this message translates to:
  /// **'Fasting window closes'**
  String get notificationsFastingClose;

  /// No description provided for @notificationsFastingCloseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Time to wind down meals and hydrate'**
  String get notificationsFastingCloseSubtitle;

  /// No description provided for @notificationsStepsNudge.
  ///
  /// In en, this message translates to:
  /// **'Steps nudge'**
  String get notificationsStepsNudge;

  /// No description provided for @notificationsStepsNudgeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Nudge at 18:00 if under 50% of your goal'**
  String get notificationsStepsNudgeSubtitle;

  /// No description provided for @notificationsStreakProtection.
  ///
  /// In en, this message translates to:
  /// **'Streak protection'**
  String get notificationsStreakProtection;

  /// No description provided for @notificationsStreakProtectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle nudge at 21:00 if nothing logged today'**
  String get notificationsStreakProtectionSubtitle;

  /// No description provided for @notificationsQuietHoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiet hours'**
  String get notificationsQuietHoursTitle;

  /// No description provided for @notificationsQuietHoursSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{start} to {end} — no notifications will sound'**
  String notificationsQuietHoursSubtitle(String start, String end);

  /// No description provided for @notificationsMaxDailyTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily notification limit'**
  String get notificationsMaxDailyTitle;

  /// No description provided for @notificationsMaxDailySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Up to {count} notifications per day'**
  String notificationsMaxDailySubtitle(int count);

  /// No description provided for @notificationsPermissionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay in your flow with reminders'**
  String get notificationsPermissionDialogTitle;

  /// No description provided for @notificationsPermissionDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Vireo sends gentle, supportive nudges for hydration, workouts, and meals. We respect your quiet hours and never spam you.'**
  String get notificationsPermissionDialogBody;

  /// No description provided for @notificationsPermissionAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow reminders'**
  String get notificationsPermissionAllow;

  /// No description provided for @notificationsPermissionNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notificationsPermissionNotNow;

  /// No description provided for @vitality12WeekProgram.
  ///
  /// In en, this message translates to:
  /// **'12-Week Program'**
  String get vitality12WeekProgram;

  /// No description provided for @vitalityArticleCount.
  ///
  /// In en, this message translates to:
  /// **'{count} articles'**
  String vitalityArticleCount(int count);

  /// No description provided for @vitalityArticleDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'For education only. Consult a professional for personal advice.'**
  String get vitalityArticleDisclaimer;

  /// No description provided for @vitalityArticlesSection.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get vitalityArticlesSection;

  /// No description provided for @vitalityBadgesTitle.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get vitalityBadgesTitle;

  /// No description provided for @vitalityBreathingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions'**
  String vitalityBreathingCount(int count);

  /// No description provided for @vitalityBreathingLog.
  ///
  /// In en, this message translates to:
  /// **'Breathing'**
  String get vitalityBreathingLog;

  /// No description provided for @vitalityCategoryAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get vitalityCategoryAdvanced;

  /// No description provided for @vitalityCategoryEnvironmental.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get vitalityCategoryEnvironmental;

  /// No description provided for @vitalityCategoryLifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get vitalityCategoryLifestyle;

  /// No description provided for @vitalityCategoryNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get vitalityCategoryNutrition;

  /// No description provided for @vitalityCategoryTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get vitalityCategoryTraining;

  /// No description provided for @vitalityCheckProtein.
  ///
  /// In en, this message translates to:
  /// **'Hit protein'**
  String get vitalityCheckProtein;

  /// No description provided for @vitalityCheckSleep.
  ///
  /// In en, this message translates to:
  /// **'Quality sleep'**
  String get vitalityCheckSleep;

  /// No description provided for @vitalityCheckSunlight.
  ///
  /// In en, this message translates to:
  /// **'Morning light'**
  String get vitalityCheckSunlight;

  /// No description provided for @vitalityCheckWorkout.
  ///
  /// In en, this message translates to:
  /// **'Move / train'**
  String get vitalityCheckWorkout;

  /// No description provided for @vitalityCheckZincVitD.
  ///
  /// In en, this message translates to:
  /// **'Zinc / Vit D'**
  String get vitalityCheckZincVitD;

  /// No description provided for @vitalityDailyChecklistProgress.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total} done'**
  String vitalityDailyChecklistProgress(int done, int total);

  /// No description provided for @vitalityDailyChecklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s checklist'**
  String get vitalityDailyChecklistTitle;

  /// No description provided for @vitalityDailyTipLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily tip'**
  String get vitalityDailyTipLabel;

  /// No description provided for @vitalityHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Science-backed habits for energy and recovery'**
  String get vitalityHubSubtitle;

  /// No description provided for @vitalityHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Vitality Hub'**
  String get vitalityHubTitle;

  /// No description provided for @vitalityLegendBadge.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get vitalityLegendBadge;

  /// No description provided for @vitalityLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get vitalityLinkCopied;

  /// No description provided for @vitalityLogSection.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get vitalityLogSection;

  /// No description provided for @vitalityMarkRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get vitalityMarkRead;

  /// No description provided for @vitalityMarkReadDone.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get vitalityMarkReadDone;

  /// No description provided for @vitalityMarkReadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Marked as read'**
  String get vitalityMarkReadSuccess;

  /// No description provided for @vitalityMedicalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Educational content only — not medical advice.'**
  String get vitalityMedicalDisclaimer;

  /// No description provided for @vitalityMetricsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No metrics yet'**
  String get vitalityMetricsEmpty;

  /// No description provided for @vitalityMetricsLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get vitalityMetricsLast7Days;

  /// No description provided for @vitalityMetricsLastEntry.
  ///
  /// In en, this message translates to:
  /// **'Last entry · energy {score}/10'**
  String vitalityMetricsLastEntry(int score);

  /// No description provided for @vitalityMetricsSave.
  ///
  /// In en, this message translates to:
  /// **'Save metrics'**
  String get vitalityMetricsSave;

  /// No description provided for @vitalityMetricsSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get vitalityMetricsSaved;

  /// No description provided for @vitalityMetricsTapToLog.
  ///
  /// In en, this message translates to:
  /// **'Tap to log'**
  String get vitalityMetricsTapToLog;

  /// No description provided for @vitalityMetricsTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily metrics'**
  String get vitalityMetricsTitle;

  /// No description provided for @vitalityMorningEnergy.
  ///
  /// In en, this message translates to:
  /// **'Morning energy'**
  String get vitalityMorningEnergy;

  /// No description provided for @vitalityMyProgram.
  ///
  /// In en, this message translates to:
  /// **'My Program'**
  String get vitalityMyProgram;

  /// No description provided for @vitalityNotLogged.
  ///
  /// In en, this message translates to:
  /// **'Not logged'**
  String get vitalityNotLogged;

  /// No description provided for @vitalityPhaseFoundation.
  ///
  /// In en, this message translates to:
  /// **'Foundation'**
  String get vitalityPhaseFoundation;

  /// No description provided for @vitalityPhaseOptimization.
  ///
  /// In en, this message translates to:
  /// **'Optimization'**
  String get vitalityPhaseOptimization;

  /// No description provided for @vitalityPhasePeak.
  ///
  /// In en, this message translates to:
  /// **'Peak'**
  String get vitalityPhasePeak;

  /// No description provided for @vitalityProgramAllWeeks.
  ///
  /// In en, this message translates to:
  /// **'All weeks'**
  String get vitalityProgramAllWeeks;

  /// No description provided for @vitalityProgramComplete.
  ///
  /// In en, this message translates to:
  /// **'Program complete'**
  String get vitalityProgramComplete;

  /// No description provided for @vitalityProgramContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get vitalityProgramContinue;

  /// No description provided for @vitalityProgramDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Educational program — not a medical treatment.'**
  String get vitalityProgramDisclaimer;

  /// No description provided for @vitalityProgramDone.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get vitalityProgramDone;

  /// No description provided for @vitalityProgramOverallProgress.
  ///
  /// In en, this message translates to:
  /// **'Overall progress'**
  String get vitalityProgramOverallProgress;

  /// No description provided for @vitalityProgramStartCta.
  ///
  /// In en, this message translates to:
  /// **'Start program'**
  String get vitalityProgramStartCta;

  /// No description provided for @vitalityProgramSubtitle.
  ///
  /// In en, this message translates to:
  /// **'12 weeks to better energy, sleep and recovery'**
  String get vitalityProgramSubtitle;

  /// No description provided for @vitalityProgramTitle.
  ///
  /// In en, this message translates to:
  /// **'Vitality Transformation'**
  String get vitalityProgramTitle;

  /// No description provided for @vitalityProtocolBadgeEarned.
  ///
  /// In en, this message translates to:
  /// **'Badge unlocked!'**
  String get vitalityProtocolBadgeEarned;

  /// No description provided for @vitalityProtocolCompleteDay.
  ///
  /// In en, this message translates to:
  /// **'Complete day'**
  String get vitalityProtocolCompleteDay;

  /// No description provided for @vitalityProtocolStreak.
  ///
  /// In en, this message translates to:
  /// **'{days}-day streak'**
  String vitalityProtocolStreak(int days);

  /// No description provided for @vitalityProtocolTitle.
  ///
  /// In en, this message translates to:
  /// **'Protocols'**
  String get vitalityProtocolTitle;

  /// No description provided for @vitalityReadingTime.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min read'**
  String vitalityReadingTime(int minutes);

  /// No description provided for @vitalityReportCompletion.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get vitalityReportCompletion;

  /// No description provided for @vitalityReportImproving.
  ///
  /// In en, this message translates to:
  /// **'You\'re improving — keep the streak going.'**
  String get vitalityReportImproving;

  /// No description provided for @vitalityReportKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Small steps still count. Finish a couple tasks today.'**
  String get vitalityReportKeepGoing;

  /// No description provided for @vitalityScientificSources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get vitalityScientificSources;

  /// No description provided for @vitalityScoreBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Sleep {sleep} · Train {workout} · Protein {protein} · Stress {stress}'**
  String vitalityScoreBreakdown(
    int sleep,
    int workout,
    int protein,
    int stress,
  );

  /// No description provided for @vitalityScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Vitality'**
  String get vitalityScoreLabel;

  /// No description provided for @vitalitySleepHint.
  ///
  /// In en, this message translates to:
  /// **'How did you sleep?'**
  String get vitalitySleepHint;

  /// No description provided for @vitalitySleepHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String vitalitySleepHours(num hours);

  /// No description provided for @vitalitySleepLog.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get vitalitySleepLog;

  /// No description provided for @vitalitySleepQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get vitalitySleepQuality;

  /// No description provided for @vitalityStreak.
  ///
  /// In en, this message translates to:
  /// **'{days}-day streak'**
  String vitalityStreak(int days);

  /// No description provided for @vitalityStressLevel.
  ///
  /// In en, this message translates to:
  /// **'Stress'**
  String get vitalityStressLevel;

  /// No description provided for @vitalityUnlockNextWeek.
  ///
  /// In en, this message translates to:
  /// **'Unlock next week'**
  String get vitalityUnlockNextWeek;

  /// No description provided for @vitalityWeekProgress.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String vitalityWeekProgress(int percent);

  /// No description provided for @vitalityWeekReport.
  ///
  /// In en, this message translates to:
  /// **'Week report'**
  String get vitalityWeekReport;

  /// No description provided for @vitalityWeekX.
  ///
  /// In en, this message translates to:
  /// **'Week {week}'**
  String vitalityWeekX(int week);

  /// No description provided for @vitalityWeekXOf12.
  ///
  /// In en, this message translates to:
  /// **'Week {week} of 12'**
  String vitalityWeekXOf12(int week);

  /// No description provided for @vitalityWorkoutDone.
  ///
  /// In en, this message translates to:
  /// **'Trained'**
  String get vitalityWorkoutDone;

  /// No description provided for @vitalityWorkoutLog.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get vitalityWorkoutLog;

  /// No description provided for @vitalityWorkoutPending.
  ///
  /// In en, this message translates to:
  /// **'Rest / not yet'**
  String get vitalityWorkoutPending;

  /// No description provided for @vitalityWorkoutPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get vitalityWorkoutPerformance;

  /// No description provided for @walkingEstimatedMinutes.
  ///
  /// In en, this message translates to:
  /// **'~{minutes} min'**
  String walkingEstimatedMinutes(int minutes);

  /// No description provided for @walkingHealthBanner.
  ///
  /// In en, this message translates to:
  /// **'Live steps from this phone’s pedometer'**
  String get walkingHealthBanner;

  /// No description provided for @walkingManualStepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Steps today'**
  String get walkingManualStepsLabel;

  /// No description provided for @walkingUpdateSteps.
  ///
  /// In en, this message translates to:
  /// **'Update steps'**
  String get walkingUpdateSteps;

  /// No description provided for @walkingWebManualBanner.
  ///
  /// In en, this message translates to:
  /// **'On web, enter steps manually'**
  String get walkingWebManualBanner;

  /// No description provided for @vitalityKeyTakeaway.
  ///
  /// In en, this message translates to:
  /// **'Key takeaway'**
  String get vitalityKeyTakeaway;

  /// No description provided for @dietMyPlan.
  ///
  /// In en, this message translates to:
  /// **'My diet plan'**
  String get dietMyPlan;

  /// No description provided for @dietProgramsTitle.
  ///
  /// In en, this message translates to:
  /// **'Diet programs'**
  String get dietProgramsTitle;

  /// No description provided for @dietQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Diet plan quiz'**
  String get dietQuizTitle;

  /// No description provided for @dietQuizContinue.
  ///
  /// In en, this message translates to:
  /// **'I understand — continue'**
  String get dietQuizContinue;

  /// No description provided for @dietQuizYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get dietQuizYes;

  /// No description provided for @dietQuizNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get dietQuizNo;

  /// No description provided for @dietQuizHealthStep.
  ///
  /// In en, this message translates to:
  /// **'Health {current} of {total}'**
  String dietQuizHealthStep(int current, int total);

  /// No description provided for @dietQuizPrefStep.
  ///
  /// In en, this message translates to:
  /// **'Preferences {current} of {total}'**
  String dietQuizPrefStep(int current, int total);

  /// No description provided for @dietPrefBreadRice.
  ///
  /// In en, this message translates to:
  /// **'Do you love bread and rice?'**
  String get dietPrefBreadRice;

  /// No description provided for @dietPrefSkipBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Can you comfortably skip breakfast?'**
  String get dietPrefSkipBreakfast;

  /// No description provided for @dietPrefSimpleRules.
  ///
  /// In en, this message translates to:
  /// **'Do you prefer simple food rules?'**
  String get dietPrefSimpleRules;

  /// No description provided for @dietPrefEatsOut.
  ///
  /// In en, this message translates to:
  /// **'Do you eat out often?'**
  String get dietPrefEatsOut;

  /// No description provided for @dietPrefWeights.
  ///
  /// In en, this message translates to:
  /// **'Do you train with weights regularly?'**
  String get dietPrefWeights;

  /// No description provided for @dietRecommendedBadge.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get dietRecommendedBadge;

  /// No description provided for @dietActiveBadge.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get dietActiveBadge;

  /// No description provided for @dietNeedsDoctor.
  ///
  /// In en, this message translates to:
  /// **'Needs doctor approval'**
  String get dietNeedsDoctor;

  /// No description provided for @dietReadWarning.
  ///
  /// In en, this message translates to:
  /// **'Read warning'**
  String get dietReadWarning;

  /// No description provided for @dietCardMacros.
  ///
  /// In en, this message translates to:
  /// **'{kcal} kcal · {protein}g protein'**
  String dietCardMacros(int kcal, int protein);

  /// No description provided for @dietHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get dietHowItWorks;

  /// No description provided for @dietYourTargets.
  ///
  /// In en, this message translates to:
  /// **'Your targets'**
  String get dietYourTargets;

  /// No description provided for @dietBestFor.
  ///
  /// In en, this message translates to:
  /// **'Best for'**
  String get dietBestFor;

  /// No description provided for @dietNotIdealFor.
  ///
  /// In en, this message translates to:
  /// **'Not ideal for'**
  String get dietNotIdealFor;

  /// No description provided for @dietRules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get dietRules;

  /// No description provided for @dietAllowedFoods.
  ///
  /// In en, this message translates to:
  /// **'Allowed foods'**
  String get dietAllowedFoods;

  /// No description provided for @dietLimitFoods.
  ///
  /// In en, this message translates to:
  /// **'Limit these'**
  String get dietLimitFoods;

  /// No description provided for @dietSampleDay.
  ///
  /// In en, this message translates to:
  /// **'Sample day'**
  String get dietSampleDay;

  /// No description provided for @dietSideEffects.
  ///
  /// In en, this message translates to:
  /// **'Side effects'**
  String get dietSideEffects;

  /// No description provided for @dietTips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get dietTips;

  /// No description provided for @dietEvidence.
  ///
  /// In en, this message translates to:
  /// **'Evidence'**
  String get dietEvidence;

  /// No description provided for @dietStopSigns.
  ///
  /// In en, this message translates to:
  /// **'Stop signs'**
  String get dietStopSigns;

  /// No description provided for @dietDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get dietDisclaimer;

  /// No description provided for @dietStartProgram.
  ///
  /// In en, this message translates to:
  /// **'Start this program'**
  String get dietStartProgram;

  /// No description provided for @dietDoctorGateTitle.
  ///
  /// In en, this message translates to:
  /// **'Doctor approval needed'**
  String get dietDoctorGateTitle;

  /// No description provided for @dietAckWarning.
  ///
  /// In en, this message translates to:
  /// **'I read the warning'**
  String get dietAckWarning;

  /// No description provided for @dietMustAckWarning.
  ///
  /// In en, this message translates to:
  /// **'Please confirm you read the warning first'**
  String get dietMustAckWarning;

  /// No description provided for @dietStartedToast.
  ///
  /// In en, this message translates to:
  /// **'Diet program started'**
  String get dietStartedToast;

  /// No description provided for @dietClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get dietClose;

  /// No description provided for @dietCarbsMax.
  ///
  /// In en, this message translates to:
  /// **'Carbs cap: {grams} g'**
  String dietCarbsMax(int grams);

  /// No description provided for @dietWeeklyLoss.
  ///
  /// In en, this message translates to:
  /// **'Est. weekly loss ≈ {kg} kg'**
  String dietWeeklyLoss(String kg);

  /// No description provided for @dietChoosePlanCard.
  ///
  /// In en, this message translates to:
  /// **'Choose your diet plan'**
  String get dietChoosePlanCard;

  /// No description provided for @dietFastingLeft.
  ///
  /// In en, this message translates to:
  /// **'Fasting — {time} left'**
  String dietFastingLeft(String time);

  /// No description provided for @dietEatingWindowLeft.
  ///
  /// In en, this message translates to:
  /// **'Eating window — closes in {time}'**
  String dietEatingWindowLeft(String time);

  /// No description provided for @dietWindowStartsAt.
  ///
  /// In en, this message translates to:
  /// **'Eating window starts at {hour}:00'**
  String dietWindowStartsAt(int hour);

  /// No description provided for @dietEditWindow.
  ///
  /// In en, this message translates to:
  /// **'Edit start hour'**
  String get dietEditWindow;

  /// No description provided for @dietCarbsLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Carbs limit'**
  String get dietCarbsLimitLabel;

  /// No description provided for @dietCarbsLimitProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {max} g carbs'**
  String dietCarbsLimitProgress(int current, int max);

  /// No description provided for @todayPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'TODAY PLAN'**
  String get todayPlanTitle;

  /// No description provided for @todayPlanProgressSummary.
  ///
  /// In en, this message translates to:
  /// **'You\'ve completed {percent}% of your day · {done}/{total} items'**
  String todayPlanProgressSummary(int percent, int done, int total);

  /// No description provided for @todayPlanNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get todayPlanNow;

  /// No description provided for @todayPlanPro.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get todayPlanPro;

  /// No description provided for @todayPlanWaterReminder.
  ///
  /// In en, this message translates to:
  /// **'Water reminder {index} of {total}'**
  String todayPlanWaterReminder(int index, int total);

  /// No description provided for @todayPlanWaterGoalLine.
  ///
  /// In en, this message translates to:
  /// **'Daily goal {ml} ml'**
  String todayPlanWaterGoalLine(int ml);

  /// No description provided for @todayPlanFastingOpen.
  ///
  /// In en, this message translates to:
  /// **'Eating window opens'**
  String get todayPlanFastingOpen;

  /// No description provided for @todayPlanFastingOpenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{hours}h eating window begins'**
  String todayPlanFastingOpenSubtitle(int hours);

  /// No description provided for @todayPlanFastingClose.
  ///
  /// In en, this message translates to:
  /// **'Eating window closes'**
  String get todayPlanFastingClose;

  /// No description provided for @todayPlanFastingCloseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{hours}h fast begins'**
  String todayPlanFastingCloseSubtitle(int hours);

  /// No description provided for @todayPlanWorkout.
  ///
  /// In en, this message translates to:
  /// **'Today\'s workout'**
  String get todayPlanWorkout;

  /// No description provided for @todayPlanSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps goal'**
  String get todayPlanSteps;

  /// No description provided for @todayPlanStepsProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {goal} steps'**
  String todayPlanStepsProgress(int current, int goal);

  /// No description provided for @todayPlanVitalitySleepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log 7.5+ hours in Vitality'**
  String get todayPlanVitalitySleepSubtitle;

  /// No description provided for @todayPlanVitalityProteinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hit your protein target'**
  String get todayPlanVitalityProteinSubtitle;

  /// No description provided for @todayPlanVitalitySunSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Morning sunlight exposure'**
  String get todayPlanVitalitySunSubtitle;

  /// No description provided for @todayPlanVitalityStress.
  ///
  /// In en, this message translates to:
  /// **'Stress reset'**
  String get todayPlanVitalityStress;

  /// No description provided for @todayPlanVitalityStressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log a breathing session'**
  String get todayPlanVitalityStressSubtitle;

  /// No description provided for @todayPlanVitalityZincSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Food-first zinc & vitamin D'**
  String get todayPlanVitalityZincSubtitle;

  /// No description provided for @todayPlanSleepTarget.
  ///
  /// In en, this message translates to:
  /// **'Sleep target'**
  String get todayPlanSleepTarget;

  /// No description provided for @todayPlanSleepTargetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Wind down for quality sleep'**
  String get todayPlanSleepTargetSubtitle;

  /// No description provided for @todayPlanProtocolItem.
  ///
  /// In en, this message translates to:
  /// **'Vitality protocol'**
  String get todayPlanProtocolItem;

  /// No description provided for @todayPlanAiSuggestion.
  ///
  /// In en, this message translates to:
  /// **'AI coach suggestion'**
  String get todayPlanAiSuggestion;

  /// No description provided for @todayPlanAiSuggestionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personalized tip for today'**
  String get todayPlanAiSuggestionSubtitle;

  /// No description provided for @waterGoalBasedOnWeight.
  ///
  /// In en, this message translates to:
  /// **'Based on your weight ({kg} kg)'**
  String waterGoalBasedOnWeight(int kg);

  /// No description provided for @authErrorEmailRateLimit.
  ///
  /// In en, this message translates to:
  /// **'Too many emails, try again in an hour'**
  String get authErrorEmailRateLimit;

  /// No description provided for @profileMyBody.
  ///
  /// In en, this message translates to:
  /// **'My body'**
  String get profileMyBody;

  /// No description provided for @profileGuestProgressHint.
  ///
  /// In en, this message translates to:
  /// **'Guest — progress not saved'**
  String get profileGuestProgressHint;

  /// No description provided for @profilePlanPro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get profilePlanPro;

  /// No description provided for @profilePlanFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get profilePlanFree;

  /// No description provided for @profileMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String profileMemberSince(String date);

  /// No description provided for @profileSaveProgressCta.
  ///
  /// In en, this message translates to:
  /// **'Save your progress'**
  String get profileSaveProgressCta;

  /// No description provided for @profileMyPlanSection.
  ///
  /// In en, this message translates to:
  /// **'My plan'**
  String get profileMyPlanSection;

  /// No description provided for @profileChangeDietPlan.
  ///
  /// In en, this message translates to:
  /// **'Change plan'**
  String get profileChangeDietPlan;

  /// No description provided for @profileBodyMetricsSaved.
  ///
  /// In en, this message translates to:
  /// **'Body metrics updated'**
  String get profileBodyMetricsSaved;

  /// No description provided for @profileSaveBodyMetrics.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileSaveBodyMetrics;

  /// No description provided for @profileEditDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get profileEditDisplayName;

  /// No description provided for @profileDisplayNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get profileDisplayNameHint;

  /// No description provided for @profileFitnessGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get profileFitnessGoal;

  /// No description provided for @activityHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity & Health'**
  String get activityHubTitle;

  /// No description provided for @activityHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'GPS workouts, wearable metrics, and guided breathing — phone-first, watch-powered.'**
  String get activityHubSubtitle;

  /// No description provided for @activityHealthHomeCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity & Health'**
  String get activityHealthHomeCardTitle;

  /// No description provided for @activityHealthHomeCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect your watch or start an outdoor workout'**
  String get activityHealthHomeCardSubtitle;

  /// No description provided for @outdoorWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Outdoor workout'**
  String get outdoorWorkoutTitle;

  /// No description provided for @outdoorWorkoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Walk, run, or cycle with GPS maps and voice cues'**
  String get outdoorWorkoutSubtitle;

  /// No description provided for @outdoorPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose activity'**
  String get outdoorPickTitle;

  /// No description provided for @outdoorPickSubtitle.
  ///
  /// In en, this message translates to:
  /// **'GPS tracking runs only during your session.'**
  String get outdoorPickSubtitle;

  /// No description provided for @outdoorTypeWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get outdoorTypeWalk;

  /// No description provided for @outdoorTypeRun.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get outdoorTypeRun;

  /// No description provided for @outdoorTypeCycle.
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get outdoorTypeCycle;

  /// No description provided for @outdoorGo.
  ///
  /// In en, this message translates to:
  /// **'Go!'**
  String get outdoorGo;

  /// No description provided for @outdoorLocationDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required for GPS workouts.'**
  String get outdoorLocationDenied;

  /// No description provided for @outdoorDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get outdoorDistance;

  /// No description provided for @outdoorDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get outdoorDuration;

  /// No description provided for @outdoorPace.
  ///
  /// In en, this message translates to:
  /// **'Pace'**
  String get outdoorPace;

  /// No description provided for @outdoorSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get outdoorSpeed;

  /// No description provided for @outdoorPaceMinKm.
  ///
  /// In en, this message translates to:
  /// **'{min}:{sec} / km'**
  String outdoorPaceMinKm(int min, int sec);

  /// No description provided for @outdoorSpeedKmh.
  ///
  /// In en, this message translates to:
  /// **'{speed} km/h'**
  String outdoorSpeedKmh(String speed);

  /// No description provided for @outdoorCalories.
  ///
  /// In en, this message translates to:
  /// **'{kcal} kcal burned'**
  String outdoorCalories(int kcal);

  /// No description provided for @outdoorPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get outdoorPause;

  /// No description provided for @outdoorResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get outdoorResume;

  /// No description provided for @outdoorHoldToStop.
  ///
  /// In en, this message translates to:
  /// **'Hold to stop'**
  String get outdoorHoldToStop;

  /// No description provided for @outdoorStopTitle.
  ///
  /// In en, this message translates to:
  /// **'End workout?'**
  String get outdoorStopTitle;

  /// No description provided for @outdoorStopBody.
  ///
  /// In en, this message translates to:
  /// **'Your route and stats will be saved.'**
  String get outdoorStopBody;

  /// No description provided for @outdoorStopConfirm.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get outdoorStopConfirm;

  /// No description provided for @outdoorPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get outdoorPaused;

  /// No description provided for @outdoorAutoPause.
  ///
  /// In en, this message translates to:
  /// **'Auto-pause when idle'**
  String get outdoorAutoPause;

  /// No description provided for @outdoorHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout history'**
  String get outdoorHistoryTitle;

  /// No description provided for @outdoorHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Past GPS sessions'**
  String get outdoorHistorySubtitle;

  /// No description provided for @outdoorHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No outdoor workouts yet.'**
  String get outdoorHistoryEmpty;

  /// No description provided for @outdoorDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout detail'**
  String get outdoorDetailTitle;

  /// No description provided for @outdoorSplitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Kilometer splits'**
  String get outdoorSplitsTitle;

  /// No description provided for @outdoorSplitKm.
  ///
  /// In en, this message translates to:
  /// **'Km {km}'**
  String outdoorSplitKm(int km);

  /// No description provided for @uxQuickOutdoor.
  ///
  /// In en, this message translates to:
  /// **'Outdoor workout'**
  String get uxQuickOutdoor;

  /// No description provided for @uxQuickOutdoorSub.
  ///
  /// In en, this message translates to:
  /// **'GPS walk, run, or ride'**
  String get uxQuickOutdoorSub;

  /// No description provided for @healthHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get healthHubTitle;

  /// No description provided for @healthHubCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Heart rate, sleep, SpO₂ from your watch'**
  String get healthHubCardSubtitle;

  /// No description provided for @healthHubProgressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Wearable metrics and sleep score'**
  String get healthHubProgressSubtitle;

  /// No description provided for @healthNotMedical.
  ///
  /// In en, this message translates to:
  /// **'Not for medical use. Metrics come from your watch via Health Connect / Apple Health.'**
  String get healthNotMedical;

  /// No description provided for @healthFromWatch.
  ///
  /// In en, this message translates to:
  /// **'From your watch'**
  String get healthFromWatch;

  /// No description provided for @healthConnectWatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect your watch'**
  String get healthConnectWatchTitle;

  /// No description provided for @healthConnectWatchBody.
  ///
  /// In en, this message translates to:
  /// **'Grant access to Health Connect or Apple Health so Vireo can show heart rate, sleep, steps, and more. We never estimate vitals from the phone.'**
  String get healthConnectWatchBody;

  /// No description provided for @healthGrantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant health access'**
  String get healthGrantPermission;

  /// No description provided for @healthMetricHeartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart rate'**
  String get healthMetricHeartRate;

  /// No description provided for @healthMetricRestingHr.
  ///
  /// In en, this message translates to:
  /// **'Resting heart rate'**
  String get healthMetricRestingHr;

  /// No description provided for @healthMetricHrv.
  ///
  /// In en, this message translates to:
  /// **'HRV (RMSSD)'**
  String get healthMetricHrv;

  /// No description provided for @healthMetricSpO2.
  ///
  /// In en, this message translates to:
  /// **'Blood oxygen'**
  String get healthMetricSpO2;

  /// No description provided for @healthMetricSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get healthMetricSleep;

  /// No description provided for @healthMetricWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get healthMetricWeight;

  /// No description provided for @healthMetricWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get healthMetricWorkout;

  /// No description provided for @healthMetricSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get healthMetricSteps;

  /// No description provided for @healthManualSleepTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual sleep log'**
  String get healthManualSleepTitle;

  /// No description provided for @healthManualSleepHint.
  ///
  /// In en, this message translates to:
  /// **'No wearable sleep data — tap to log bedtime and quality'**
  String get healthManualSleepHint;

  /// No description provided for @healthSleepScore.
  ///
  /// In en, this message translates to:
  /// **'Sleep score {score}'**
  String healthSleepScore(int score);

  /// No description provided for @healthBedtime.
  ///
  /// In en, this message translates to:
  /// **'Bedtime'**
  String get healthBedtime;

  /// No description provided for @healthWakeTime.
  ///
  /// In en, this message translates to:
  /// **'Wake time'**
  String get healthWakeTime;

  /// No description provided for @healthSleepQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality (1–5)'**
  String get healthSleepQuality;

  /// No description provided for @healthStressTitle.
  ///
  /// In en, this message translates to:
  /// **'Stress level (HRV)'**
  String get healthStressTitle;

  /// No description provided for @healthStressLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get healthStressLow;

  /// No description provided for @healthStressMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get healthStressMedium;

  /// No description provided for @healthStressHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get healthStressHigh;

  /// No description provided for @healthHrvDetail.
  ///
  /// In en, this message translates to:
  /// **'Today {today} ms vs 14-day baseline {baseline} ms'**
  String healthHrvDetail(int today, int baseline);

  /// No description provided for @breathingHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Breathing'**
  String get breathingHubTitle;

  /// No description provided for @breathingHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Guided sessions for stress recovery'**
  String get breathingHubSubtitle;

  /// No description provided for @breathingBoxTitle.
  ///
  /// In en, this message translates to:
  /// **'Box breathing 4-4-4-4'**
  String get breathingBoxTitle;

  /// No description provided for @breathingBoxSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Equal inhale, hold, exhale, hold'**
  String get breathingBoxSubtitle;

  /// No description provided for @breathing478Title.
  ///
  /// In en, this message translates to:
  /// **'4-7-8 relaxation'**
  String get breathing478Title;

  /// No description provided for @breathing478Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Calming pattern before sleep'**
  String get breathing478Subtitle;

  /// No description provided for @breathingMinutes.
  ///
  /// In en, this message translates to:
  /// **'{min} min'**
  String breathingMinutes(int min);

  /// No description provided for @breathingSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Breathing session'**
  String get breathingSessionTitle;

  /// No description provided for @breathingInhale.
  ///
  /// In en, this message translates to:
  /// **'Inhale'**
  String get breathingInhale;

  /// No description provided for @breathingHold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get breathingHold;

  /// No description provided for @breathingExhale.
  ///
  /// In en, this message translates to:
  /// **'Exhale'**
  String get breathingExhale;

  /// No description provided for @breathingRest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get breathingRest;

  /// No description provided for @mealReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review meal'**
  String get mealReviewTitle;

  /// No description provided for @mealReviewAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get mealReviewAddItem;

  /// No description provided for @mealReviewSlot.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get mealReviewSlot;

  /// No description provided for @mealReviewRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining budget: {kcal} kcal'**
  String mealReviewRemaining(int kcal);

  /// No description provided for @mealReviewEstimated.
  ///
  /// In en, this message translates to:
  /// **'estimated'**
  String get mealReviewEstimated;

  /// No description provided for @mealReviewKcalApprox.
  ///
  /// In en, this message translates to:
  /// **'≈ {count} kcal'**
  String mealReviewKcalApprox(int count);

  /// No description provided for @mealReviewPortionLabel.
  ///
  /// In en, this message translates to:
  /// **'Portion'**
  String get mealReviewPortionLabel;

  /// No description provided for @mealReviewOilPrefix.
  ///
  /// In en, this message translates to:
  /// **'Oil:'**
  String get mealReviewOilPrefix;

  /// No description provided for @mealReviewOilLight.
  ///
  /// In en, this message translates to:
  /// **'light'**
  String get mealReviewOilLight;

  /// No description provided for @mealReviewOilNormal.
  ///
  /// In en, this message translates to:
  /// **'normal'**
  String get mealReviewOilNormal;

  /// No description provided for @mealReviewOilHeavy.
  ///
  /// In en, this message translates to:
  /// **'heavy'**
  String get mealReviewOilHeavy;

  /// No description provided for @mealReviewFamilyPlateToggle.
  ///
  /// In en, this message translates to:
  /// **'We shared one dish'**
  String get mealReviewFamilyPlateToggle;

  /// No description provided for @mealReviewMyShare.
  ///
  /// In en, this message translates to:
  /// **'My share'**
  String get mealReviewMyShare;

  /// No description provided for @ramadanWaterTrackerQuestion.
  ///
  /// In en, this message translates to:
  /// **'How many cups since iftar until suhoor?'**
  String get ramadanWaterTrackerQuestion;

  /// No description provided for @ramadanWaterGoalSplit.
  ///
  /// In en, this message translates to:
  /// **'Iftar: {iftarCups} · Evening: {eveningCups} · Suhoor: {suhoorCups} cups'**
  String ramadanWaterGoalSplit(int iftarCups, int eveningCups, int suhoorCups);

  /// No description provided for @ramadanPrayerCityPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose prayer city'**
  String get ramadanPrayerCityPickerTitle;

  /// No description provided for @ramadanPrayerCityCustom.
  ///
  /// In en, this message translates to:
  /// **'Another city'**
  String get ramadanPrayerCityCustom;

  /// No description provided for @ramadanCustomCityName.
  ///
  /// In en, this message translates to:
  /// **'City name'**
  String get ramadanCustomCityName;

  /// No description provided for @ramadanCustomCityLat.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get ramadanCustomCityLat;

  /// No description provided for @ramadanCustomCityLng.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get ramadanCustomCityLng;

  /// No description provided for @notificationPostScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Want meal reminders?'**
  String get notificationPostScanTitle;

  /// No description provided for @notificationPostScanBody.
  ///
  /// In en, this message translates to:
  /// **'Gentle nudges for lunch and dinner — max 2 per day, quiet from 11 PM to 7 AM.'**
  String get notificationPostScanBody;

  /// No description provided for @notificationPostScanYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, remind me'**
  String get notificationPostScanYes;

  /// No description provided for @notificationPostScanNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notificationPostScanNotNow;

  /// No description provided for @mealReviewCheckAmount.
  ///
  /// In en, this message translates to:
  /// **'check the amount'**
  String get mealReviewCheckAmount;

  /// No description provided for @mealReviewSearchFood.
  ///
  /// In en, this message translates to:
  /// **'Search foods…'**
  String get mealReviewSearchFood;

  /// No description provided for @mealReviewLogByText.
  ///
  /// In en, this message translates to:
  /// **'Log by text instead'**
  String get mealReviewLogByText;

  /// No description provided for @mealLogTextTitle.
  ///
  /// In en, this message translates to:
  /// **'Log meal by text'**
  String get mealLogTextTitle;

  /// No description provided for @mealLogTextHint.
  ///
  /// In en, this message translates to:
  /// **'Describe what you ate — Arabic or English.'**
  String get mealLogTextHint;

  /// No description provided for @mealLogTextPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'أكلت 2 بيض ورغيف بلدي وكوباية شاي بسكر'**
  String get mealLogTextPlaceholder;

  /// No description provided for @mealLogTextAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get mealLogTextAnalyze;

  /// No description provided for @mealVoiceStart.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get mealVoiceStart;

  /// No description provided for @mealVoiceListening.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get mealVoiceListening;

  /// No description provided for @mealVoiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Voice input unavailable on this device'**
  String get mealVoiceUnavailable;

  /// No description provided for @mealBarcodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get mealBarcodeTitle;

  /// No description provided for @mealBarcodeFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not look up that barcode. Try again or log by text.'**
  String get mealBarcodeFailed;

  /// No description provided for @mealScanHintLabel.
  ///
  /// In en, this message translates to:
  /// **'Add a few words (optional)'**
  String get mealScanHintLabel;

  /// No description provided for @mealScanHintPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Oil? Sauce? Bread type?'**
  String get mealScanHintPlaceholder;

  /// No description provided for @mealHowCalculated.
  ///
  /// In en, this message translates to:
  /// **'How we calculated this'**
  String get mealHowCalculated;

  /// No description provided for @plateSizeAskTitle.
  ///
  /// In en, this message translates to:
  /// **'What’s your usual plate size?'**
  String get plateSizeAskTitle;

  /// No description provided for @plateSizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get plateSizeSmall;

  /// No description provided for @plateSizeMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get plateSizeMedium;

  /// No description provided for @plateSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get plateSizeLarge;

  /// No description provided for @inbodyScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan InBody report'**
  String get inbodyScanTitle;

  /// No description provided for @inbodyReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review InBody result'**
  String get inbodyReviewTitle;

  /// No description provided for @inbodyBodyTitle.
  ///
  /// In en, this message translates to:
  /// **'Body composition'**
  String get inbodyBodyTitle;

  /// No description provided for @inbodyAddResult.
  ///
  /// In en, this message translates to:
  /// **'Add InBody result'**
  String get inbodyAddResult;

  /// No description provided for @inbodyPickPdf.
  ///
  /// In en, this message translates to:
  /// **'Choose PDF'**
  String get inbodyPickPdf;

  /// No description provided for @inbodyFrameHint.
  ///
  /// In en, this message translates to:
  /// **'Fit the full report sheet inside the frame'**
  String get inbodyFrameHint;

  /// No description provided for @inbodyAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Reading your report…'**
  String get inbodyAnalyzing;

  /// No description provided for @inbodyUnreadable.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t read that sheet. Try a clearer photo.'**
  String get inbodyUnreadable;

  /// No description provided for @inbodyScanFailed.
  ///
  /// In en, this message translates to:
  /// **'InBody scan failed. Try again.'**
  String get inbodyScanFailed;

  /// No description provided for @inbodySaved.
  ///
  /// In en, this message translates to:
  /// **'InBody result saved'**
  String get inbodySaved;

  /// No description provided for @inbodyMedicalNote.
  ///
  /// In en, this message translates to:
  /// **'Not for medical use — for fitness tracking only.'**
  String get inbodyMedicalNote;

  /// No description provided for @inbodyTestDate.
  ///
  /// In en, this message translates to:
  /// **'Test date'**
  String get inbodyTestDate;

  /// No description provided for @inbodyDevice.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get inbodyDevice;

  /// No description provided for @inbodyWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get inbodyWeight;

  /// No description provided for @inbodySmm.
  ///
  /// In en, this message translates to:
  /// **'Skeletal muscle (kg)'**
  String get inbodySmm;

  /// No description provided for @inbodyFatMass.
  ///
  /// In en, this message translates to:
  /// **'Fat mass (kg)'**
  String get inbodyFatMass;

  /// No description provided for @inbodyPbf.
  ///
  /// In en, this message translates to:
  /// **'Body fat %'**
  String get inbodyPbf;

  /// No description provided for @inbodyBmi.
  ///
  /// In en, this message translates to:
  /// **'BMI'**
  String get inbodyBmi;

  /// No description provided for @inbodyVisceral.
  ///
  /// In en, this message translates to:
  /// **'Visceral fat level'**
  String get inbodyVisceral;

  /// No description provided for @inbodyBmr.
  ///
  /// In en, this message translates to:
  /// **'BMR (kcal)'**
  String get inbodyBmr;

  /// No description provided for @inbodyScore.
  ///
  /// In en, this message translates to:
  /// **'InBody score'**
  String get inbodyScore;

  /// No description provided for @inbodySave.
  ///
  /// In en, this message translates to:
  /// **'Save result'**
  String get inbodySave;

  /// No description provided for @inbodyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No body composition reports yet. Scan an InBody sheet to start.'**
  String get inbodyEmpty;

  /// No description provided for @inbodyLatestTitle.
  ///
  /// In en, this message translates to:
  /// **'Latest report'**
  String get inbodyLatestTitle;

  /// No description provided for @inbodyCompareTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare two reports'**
  String get inbodyCompareTitle;

  /// No description provided for @inbodySyncHealth.
  ///
  /// In en, this message translates to:
  /// **'Sync Health Connect'**
  String get inbodySyncHealth;

  /// No description provided for @inbodySyncedLabel.
  ///
  /// In en, this message translates to:
  /// **'Synced from Health Connect'**
  String get inbodySyncedLabel;

  /// No description provided for @inbodySyncResult.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} Health Connect reading(s)'**
  String inbodySyncResult(int count);

  /// No description provided for @inbodyFromDateLabel.
  ///
  /// In en, this message translates to:
  /// **'from your InBody on {date}'**
  String inbodyFromDateLabel(String date);

  /// No description provided for @uxQuickInbody.
  ///
  /// In en, this message translates to:
  /// **'InBody report'**
  String get uxQuickInbody;

  /// No description provided for @uxQuickInbodySub.
  ///
  /// In en, this message translates to:
  /// **'Scan a result sheet'**
  String get uxQuickInbodySub;

  /// No description provided for @mealScanHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan your meal'**
  String get mealScanHeroTitle;

  /// No description provided for @mealScanHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI identifies foods — you confirm grams'**
  String get mealScanHeroSubtitle;

  /// No description provided for @mealScanTipAbove.
  ///
  /// In en, this message translates to:
  /// **'Shoot from above'**
  String get mealScanTipAbove;

  /// No description provided for @mealScanTipWholePlate.
  ///
  /// In en, this message translates to:
  /// **'Whole plate visible'**
  String get mealScanTipWholePlate;

  /// No description provided for @mealScanTipLight.
  ///
  /// In en, this message translates to:
  /// **'Good light'**
  String get mealScanTipLight;

  /// No description provided for @mealScanFlashOn.
  ///
  /// In en, this message translates to:
  /// **'Flash on'**
  String get mealScanFlashOn;

  /// No description provided for @mealScanFlashOff.
  ///
  /// In en, this message translates to:
  /// **'Flash off'**
  String get mealScanFlashOff;

  /// No description provided for @uxQuickMealText.
  ///
  /// In en, this message translates to:
  /// **'Text meal'**
  String get uxQuickMealText;

  /// No description provided for @uxQuickMealTextSub.
  ///
  /// In en, this message translates to:
  /// **'Type what you ate'**
  String get uxQuickMealTextSub;

  /// No description provided for @uxQuickBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get uxQuickBarcode;

  /// No description provided for @uxQuickBarcodeSub.
  ///
  /// In en, this message translates to:
  /// **'Open Food Facts lookup'**
  String get uxQuickBarcodeSub;

  /// No description provided for @mealFavoriteSave.
  ///
  /// In en, this message translates to:
  /// **'Save favorite'**
  String get mealFavoriteSave;

  /// No description provided for @mealFavoriteSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to favorites'**
  String get mealFavoriteSaved;

  /// No description provided for @mealFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get mealFavoritesTitle;

  /// No description provided for @mealRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent meals'**
  String get mealRecentTitle;

  /// No description provided for @mealRelog.
  ///
  /// In en, this message translates to:
  /// **'Log again'**
  String get mealRelog;

  /// No description provided for @appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// No description provided for @themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get themeModeDark;

  /// No description provided for @accentThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get accentThemeTitle;

  /// No description provided for @accentEmber.
  ///
  /// In en, this message translates to:
  /// **'Ember (Default)'**
  String get accentEmber;

  /// No description provided for @accentOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get accentOcean;

  /// No description provided for @accentForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get accentForest;

  /// No description provided for @accentRoyal.
  ///
  /// In en, this message translates to:
  /// **'Royal'**
  String get accentRoyal;

  /// No description provided for @detectedActivity.
  ///
  /// In en, this message translates to:
  /// **'Detected: {activity}'**
  String detectedActivity(String activity);

  /// No description provided for @manualOverride.
  ///
  /// In en, this message translates to:
  /// **'Override'**
  String get manualOverride;

  /// No description provided for @mealClarificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick clarification'**
  String get mealClarificationTitle;

  /// No description provided for @celebrationWaterTitle.
  ///
  /// In en, this message translates to:
  /// **'Hydration Goal Achieved! 💧'**
  String get celebrationWaterTitle;

  /// No description provided for @celebrationProteinTitle.
  ///
  /// In en, this message translates to:
  /// **'Protein Goal Smashed! 💪'**
  String get celebrationProteinTitle;

  /// No description provided for @celebrationStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'Step Goal Completed! 🏃'**
  String get celebrationStepsTitle;

  /// No description provided for @celebrationWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout Finished! 🔥'**
  String get celebrationWorkoutTitle;

  /// No description provided for @fatEquivalentApprox.
  ///
  /// In en, this message translates to:
  /// **'≈ {amount} of fat'**
  String fatEquivalentApprox(String amount);

  /// No description provided for @fatEquivalentBurned.
  ///
  /// In en, this message translates to:
  /// **'≈ {amount} of fat'**
  String fatEquivalentBurned(String amount);

  /// No description provided for @fatEquivalentTodayDeficit.
  ///
  /// In en, this message translates to:
  /// **'Today\'s deficit ≈ {amount} of fat'**
  String fatEquivalentTodayDeficit(String amount);

  /// No description provided for @fatEquivalentTodaySurplus.
  ///
  /// In en, this message translates to:
  /// **'Surplus +{kcal} kcal'**
  String fatEquivalentTodaySurplus(int kcal);

  /// No description provided for @fatEquivalentDietPlanRate.
  ///
  /// In en, this message translates to:
  /// **'≈ {daily} fat/day • ≈ {weekly}/week'**
  String fatEquivalentDietPlanRate(String daily, String weekly);

  /// No description provided for @fatEquivalentThisWeek.
  ///
  /// In en, this message translates to:
  /// **'≈ {amount} of fat this week'**
  String fatEquivalentThisWeek(String amount);

  /// No description provided for @fatEquivalentInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Fat Equivalent'**
  String get fatEquivalentInfoTitle;

  /// No description provided for @fatEquivalentInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Real scale weight also changes with water and glycogen, so daily weight can move differently. This is the energy equivalent of fat.'**
  String get fatEquivalentInfoBody;

  /// No description provided for @fatEquivalentInfoDismiss.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get fatEquivalentInfoDismiss;

  /// No description provided for @legalTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get legalTerms;

  /// No description provided for @legalPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get legalPrivacy;

  /// No description provided for @legalMedicalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Medical Disclaimer'**
  String get legalMedicalDisclaimer;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Smart nutrition & intelligent fitness built specifically for men.'**
  String get welcomeTagline;

  /// No description provided for @welcomePillarScannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Instant Plate Scanner'**
  String get welcomePillarScannerTitle;

  /// No description provided for @welcomePillarScannerDesc.
  ///
  /// In en, this message translates to:
  /// **'Snap your meal, get accurate calories & protein in 2 seconds'**
  String get welcomePillarScannerDesc;

  /// No description provided for @welcomePillarPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Personalized Daily Plan'**
  String get welcomePillarPlanTitle;

  /// No description provided for @welcomePillarPlanDesc.
  ///
  /// In en, this message translates to:
  /// **'Evidence-backed targets tailored to your body and goal'**
  String get welcomePillarPlanDesc;

  /// No description provided for @welcomePillarSafetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Clinically Safe Nutrition'**
  String get welcomePillarSafetyTitle;

  /// No description provided for @welcomePillarSafetyDesc.
  ///
  /// In en, this message translates to:
  /// **'Guidance that protects your metabolism and overall health'**
  String get welcomePillarSafetyDesc;

  /// No description provided for @onboardingGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'What is your primary focus?'**
  String get onboardingGoalTitle;

  /// No description provided for @onboardingGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick what matters most. We will engineer your daily targets around this.'**
  String get onboardingGoalSubtitle;

  /// No description provided for @goalLoseFatTitle.
  ///
  /// In en, this message translates to:
  /// **'Lose Fat'**
  String get goalLoseFatTitle;

  /// No description provided for @goalLoseFatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Torch stubborn fat while maintaining hard-earned muscle mass'**
  String get goalLoseFatSubtitle;

  /// No description provided for @goalBuildMuscleTitle.
  ///
  /// In en, this message translates to:
  /// **'Build Muscle'**
  String get goalBuildMuscleTitle;

  /// No description provided for @goalBuildMuscleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Maximize lean hypertrophy with optimized protein & progressive overload'**
  String get goalBuildMuscleSubtitle;

  /// No description provided for @goalMoreEnergyTitle.
  ///
  /// In en, this message translates to:
  /// **'More Energy'**
  String get goalMoreEnergyTitle;

  /// No description provided for @goalMoreEnergySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Eliminate mid-day crashes and elevate everyday stamina & vitality'**
  String get goalMoreEnergySubtitle;

  /// No description provided for @goalAllOfAboveTitle.
  ///
  /// In en, this message translates to:
  /// **'All of the Above'**
  String get goalAllOfAboveTitle;

  /// No description provided for @goalAllOfAboveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Total body recomposition: drop body fat, gain strength, and feel relentless'**
  String get goalAllOfAboveSubtitle;

  /// No description provided for @onboardingBodyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Body Profile'**
  String get onboardingBodyTitle;

  /// No description provided for @onboardingBodySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Accurate metrics allow us to calculate your exact caloric burn & daily targets.'**
  String get onboardingBodySubtitle;

  /// No description provided for @sexMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get sexMale;

  /// No description provided for @sexFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get sexFemale;

  /// No description provided for @unitMetric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get unitMetric;

  /// No description provided for @unitImperial.
  ///
  /// In en, this message translates to:
  /// **'US (lb)'**
  String get unitImperial;

  /// No description provided for @bodyMetricAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get bodyMetricAge;

  /// No description provided for @bodyMetricYears.
  ///
  /// In en, this message translates to:
  /// **'{age} years'**
  String bodyMetricYears(int age);

  /// No description provided for @selectAgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Age'**
  String get selectAgeTitle;

  /// No description provided for @ageYearsSuffix.
  ///
  /// In en, this message translates to:
  /// **'{age} yrs'**
  String ageYearsSuffix(int age);

  /// No description provided for @bodyMetricHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get bodyMetricHeight;

  /// No description provided for @selectHeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Height'**
  String get selectHeightTitle;

  /// No description provided for @bodyMetricCurrentWeight.
  ///
  /// In en, this message translates to:
  /// **'Current Weight'**
  String get bodyMetricCurrentWeight;

  /// No description provided for @selectCurrentWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Current Weight'**
  String get selectCurrentWeightTitle;

  /// No description provided for @bodyMetricTargetWeight.
  ///
  /// In en, this message translates to:
  /// **'Target Weight'**
  String get bodyMetricTargetWeight;

  /// No description provided for @selectTargetWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Target Weight'**
  String get selectTargetWeightTitle;

  /// No description provided for @pickerDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get pickerDone;

  /// No description provided for @onboardingActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity & Training Place'**
  String get onboardingActivityTitle;

  /// No description provided for @onboardingActivitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We calibrate daily calorie output and recommend optimal workouts.'**
  String get onboardingActivitySubtitle;

  /// No description provided for @dailyActivityLevelHeader.
  ///
  /// In en, this message translates to:
  /// **'DAILY ACTIVITY LEVEL'**
  String get dailyActivityLevelHeader;

  /// No description provided for @activitySedentaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Sedentary / Desk Work'**
  String get activitySedentaryTitle;

  /// No description provided for @activitySedentarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Minimal daily walking, desk job, under 5,000 steps'**
  String get activitySedentarySubtitle;

  /// No description provided for @activityModeratelyActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Moderately Active'**
  String get activityModeratelyActiveTitle;

  /// No description provided for @activityModeratelyActiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'On your feet regularly, 6,000–10,000 daily steps'**
  String get activityModeratelyActiveSubtitle;

  /// No description provided for @activityVeryActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Very Active / Physical Job'**
  String get activityVeryActiveTitle;

  /// No description provided for @activityVeryActiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Constantly on the move or 12,000+ daily steps'**
  String get activityVeryActiveSubtitle;

  /// No description provided for @trainingPlaceHeader.
  ///
  /// In en, this message translates to:
  /// **'WHERE DO YOU PLAN TO TRAIN?'**
  String get trainingPlaceHeader;

  /// No description provided for @trainingPlaceGymTitle.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get trainingPlaceGymTitle;

  /// No description provided for @trainingPlaceGymSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Full access to barbells, machines & dumbbells'**
  String get trainingPlaceGymSubtitle;

  /// No description provided for @trainingPlaceHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get trainingPlaceHomeTitle;

  /// No description provided for @trainingPlaceHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight, resistance bands, or light dumbbells'**
  String get trainingPlaceHomeSubtitle;

  /// No description provided for @trainingPlaceWalkingTitle.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get trainingPlaceWalkingTitle;

  /// No description provided for @trainingPlaceWalkingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cardio steps & outdoor walking routines'**
  String get trainingPlaceWalkingSubtitle;

  /// No description provided for @onboardingHealthSafetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Safety Screening'**
  String get onboardingHealthSafetyTitle;

  /// No description provided for @onboardingHealthSafetySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select any conditions that apply so our engine can protect your safety.'**
  String get onboardingHealthSafetySubtitle;

  /// No description provided for @healthSafetyNoneApply.
  ///
  /// In en, this message translates to:
  /// **'None of these apply to me'**
  String get healthSafetyNoneApply;

  /// No description provided for @healthSafetyOrSelect.
  ///
  /// In en, this message translates to:
  /// **'OR SELECT ANY APPLICABLE'**
  String get healthSafetyOrSelect;

  /// No description provided for @onboardingTryScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Experience Instant Scanning'**
  String get onboardingTryScanTitle;

  /// No description provided for @onboardingTryScanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See how effortlessly Vireo breaks down real food into macros and calories.'**
  String get onboardingTryScanSubtitle;

  /// No description provided for @tryScanSamplePlateTitle.
  ///
  /// In en, this message translates to:
  /// **'Sample High-Protein Plate'**
  String get tryScanSamplePlateTitle;

  /// No description provided for @tryScanSamplePlateDesc.
  ///
  /// In en, this message translates to:
  /// **'Grilled Chicken, Egyptian Rice & Garden Salad'**
  String get tryScanSamplePlateDesc;

  /// No description provided for @tryScanAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing Plate...'**
  String get tryScanAnalyzing;

  /// No description provided for @tryScanSampleCta.
  ///
  /// In en, this message translates to:
  /// **'Scan Sample Plate (Instant)'**
  String get tryScanSampleCta;

  /// No description provided for @tryScanOrTestLive.
  ///
  /// In en, this message translates to:
  /// **'OR TEST LIVE'**
  String get tryScanOrTestLive;

  /// No description provided for @tryScanOwnMealTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Your Own Meal'**
  String get tryScanOwnMealTitle;

  /// No description provided for @tryScanOwnMealDesc.
  ///
  /// In en, this message translates to:
  /// **'Take a live photo of your current plate'**
  String get tryScanOwnMealDesc;

  /// No description provided for @onboardingPlanRevealTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Personalized Blueprint'**
  String get onboardingPlanRevealTitle;

  /// No description provided for @onboardingPlanRevealSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Engineered specifically for your metabolic profile and fitness goal.'**
  String get onboardingPlanRevealSubtitle;

  /// No description provided for @planRevealStartPlan.
  ///
  /// In en, this message translates to:
  /// **'Start My Plan'**
  String get planRevealStartPlan;

  /// No description provided for @planRevealProjectedPace.
  ///
  /// In en, this message translates to:
  /// **'PROJECTED PACE'**
  String get planRevealProjectedPace;

  /// No description provided for @planRevealSteadyRecomp.
  ///
  /// In en, this message translates to:
  /// **'Steady body recomposition'**
  String get planRevealSteadyRecomp;

  /// No description provided for @planRevealFatLossPace.
  ///
  /// In en, this message translates to:
  /// **'-{amount} kg / week fat loss'**
  String planRevealFatLossPace(String amount);

  /// No description provided for @planRevealLeanMassPace.
  ///
  /// In en, this message translates to:
  /// **'+{amount} kg / week lean mass'**
  String planRevealLeanMassPace(String amount);

  /// No description provided for @planRevealDailyCalories.
  ///
  /// In en, this message translates to:
  /// **'DAILY CALORIC TARGET'**
  String get planRevealDailyCalories;

  /// No description provided for @planRevealPersonalizedBadge.
  ///
  /// In en, this message translates to:
  /// **'Personalized'**
  String get planRevealPersonalizedBadge;

  /// No description provided for @planRevealKcalPerDay.
  ///
  /// In en, this message translates to:
  /// **'kcal / day'**
  String get planRevealKcalPerDay;

  /// No description provided for @planRevealDailyProtein.
  ///
  /// In en, this message translates to:
  /// **'DAILY PROTEIN'**
  String get planRevealDailyProtein;

  /// No description provided for @planRevealGramPerDay.
  ///
  /// In en, this message translates to:
  /// **'g / day'**
  String get planRevealGramPerDay;

  /// No description provided for @planRevealHydration.
  ///
  /// In en, this message translates to:
  /// **'HYDRATION'**
  String get planRevealHydration;

  /// No description provided for @planRevealDailySteps.
  ///
  /// In en, this message translates to:
  /// **'DAILY STEPS'**
  String get planRevealDailySteps;

  /// No description provided for @planRevealStepsPerDay.
  ///
  /// In en, this message translates to:
  /// **'steps / day'**
  String get planRevealStepsPerDay;

  /// No description provided for @planRevealDietProtocol.
  ///
  /// In en, this message translates to:
  /// **'DIET PROTOCOL'**
  String get planRevealDietProtocol;

  /// No description provided for @planRevealOptimalMatch.
  ///
  /// In en, this message translates to:
  /// **'Optimal match'**
  String get planRevealOptimalMatch;

  /// No description provided for @planRevealBalancedPlanDefault.
  ///
  /// In en, this message translates to:
  /// **'Balanced Deficit Plan'**
  String get planRevealBalancedPlanDefault;

  /// No description provided for @onboardingNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Never Miss a Target'**
  String get onboardingNotificationsTitle;

  /// No description provided for @onboardingNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle nudges keep your nutrition log, hydration, and workouts on track.'**
  String get onboardingNotificationsSubtitle;

  /// No description provided for @notificationsHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Built For Accountability, Not Spam'**
  String get notificationsHeroTitle;

  /// No description provided for @notificationsHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Users who enable reminders are 3.4x more likely to reach their target weight and build lasting fitness habits.'**
  String get notificationsHeroBody;

  /// No description provided for @notificationsMealLoggingTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal & Plate Logging'**
  String get notificationsMealLoggingTitle;

  /// No description provided for @notificationsMealLoggingDesc.
  ///
  /// In en, this message translates to:
  /// **'Timely reminders around lunch and dinner'**
  String get notificationsMealLoggingDesc;

  /// No description provided for @notificationsWorkoutSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Workout Session'**
  String get notificationsWorkoutSessionTitle;

  /// No description provided for @notificationsWorkoutSessionDesc.
  ///
  /// In en, this message translates to:
  /// **'Stay committed to your training schedule'**
  String get notificationsWorkoutSessionDesc;

  /// No description provided for @notificationsWeeklyReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Progress Review'**
  String get notificationsWeeklyReviewTitle;

  /// No description provided for @notificationsWeeklyReviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Sunday weigh-in & weekly adjustment summary'**
  String get notificationsWeeklyReviewDesc;

  /// No description provided for @notificationsEnableButton.
  ///
  /// In en, this message translates to:
  /// **'Enable Reminders'**
  String get notificationsEnableButton;

  /// No description provided for @notificationsMaybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get notificationsMaybeLater;

  /// No description provided for @onboardingPaywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Accelerate Your Results'**
  String get onboardingPaywallTitle;

  /// No description provided for @onboardingPaywallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock unlimited plate scans, full AI workout generation, and advanced analytics.'**
  String get onboardingPaywallSubtitle;

  /// No description provided for @paywallProBadge.
  ///
  /// In en, this message translates to:
  /// **'VIREO PRO'**
  String get paywallProBadge;

  /// No description provided for @paywallFeatureUnlimitedScansDesc.
  ///
  /// In en, this message translates to:
  /// **'Never worry about daily limits or quotas'**
  String get paywallFeatureUnlimitedScansDesc;

  /// No description provided for @paywallFeatureSmartSub.
  ///
  /// In en, this message translates to:
  /// **'AI Smart Substitution & Meal Prep'**
  String get paywallFeatureSmartSub;

  /// No description provided for @paywallFeatureSmartSubDesc.
  ///
  /// In en, this message translates to:
  /// **'Instant macro-friendly swaps for local dishes'**
  String get paywallFeatureSmartSubDesc;

  /// No description provided for @paywallFeatureAdaptiveSplits.
  ///
  /// In en, this message translates to:
  /// **'Custom Adaptive Workout Splits'**
  String get paywallFeatureAdaptiveSplits;

  /// No description provided for @paywallFeatureAdaptiveSplitsDesc.
  ///
  /// In en, this message translates to:
  /// **'Progressive overload tracking for gym or home'**
  String get paywallFeatureAdaptiveSplitsDesc;

  /// No description provided for @paywallPlanAnnualPrice.
  ///
  /// In en, this message translates to:
  /// **'\$4.99 / mo'**
  String get paywallPlanAnnualPrice;

  /// No description provided for @paywallPlanAnnualSubtext.
  ///
  /// In en, this message translates to:
  /// **'Billed yearly (Save 50%)'**
  String get paywallPlanAnnualSubtext;

  /// No description provided for @paywallBadgeBestValue.
  ///
  /// In en, this message translates to:
  /// **'BEST VALUE'**
  String get paywallBadgeBestValue;

  /// No description provided for @paywallPlanMonthlyPrice.
  ///
  /// In en, this message translates to:
  /// **'\$9.99 / mo'**
  String get paywallPlanMonthlyPrice;

  /// No description provided for @paywallPlanMonthlySubtext.
  ///
  /// In en, this message translates to:
  /// **'Billed monthly'**
  String get paywallPlanMonthlySubtext;

  /// No description provided for @paywallStartTrialCta.
  ///
  /// In en, this message translates to:
  /// **'Start 7-Day Free Trial'**
  String get paywallStartTrialCta;

  /// No description provided for @paywallContinueFreeTier.
  ///
  /// In en, this message translates to:
  /// **'Continue with Free Tier'**
  String get paywallContinueFreeTier;

  /// No description provided for @appInitErrorFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize app services.'**
  String get appInitErrorFailed;

  /// No description provided for @appInitRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get appInitRetry;

  /// No description provided for @privacyExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export My Data'**
  String get privacyExportTitle;

  /// No description provided for @privacyExportReady.
  ///
  /// In en, this message translates to:
  /// **'Your data package is ready in JSON & CSV formats:'**
  String get privacyExportReady;

  /// No description provided for @weeklyProgressShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not generate share image'**
  String get weeklyProgressShareFailed;

  /// No description provided for @adaptiveCalorieCurrentTarget.
  ///
  /// In en, this message translates to:
  /// **'Current Target'**
  String get adaptiveCalorieCurrentTarget;

  /// No description provided for @adaptiveCalorieSuggestedTarget.
  ///
  /// In en, this message translates to:
  /// **'Suggested Target'**
  String get adaptiveCalorieSuggestedTarget;

  /// No description provided for @adaptiveCalorieWindowSpan.
  ///
  /// In en, this message translates to:
  /// **'Window span'**
  String get adaptiveCalorieWindowSpan;

  /// No description provided for @adaptiveCalorieFoodLogsCount.
  ///
  /// In en, this message translates to:
  /// **'Food logs count'**
  String get adaptiveCalorieFoodLogsCount;

  /// No description provided for @adaptiveCalorieWeighInsCount.
  ///
  /// In en, this message translates to:
  /// **'Weigh-ins count'**
  String get adaptiveCalorieWeighInsCount;

  /// No description provided for @adaptiveCalorieAverageIntake.
  ///
  /// In en, this message translates to:
  /// **'Average intake'**
  String get adaptiveCalorieAverageIntake;

  /// No description provided for @adaptiveCalorieTrendWeightChange.
  ///
  /// In en, this message translates to:
  /// **'Trend weight change'**
  String get adaptiveCalorieTrendWeightChange;

  /// No description provided for @adaptiveCalorieEstimatedMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Estimated maintenance'**
  String get adaptiveCalorieEstimatedMaintenance;

  /// No description provided for @adaptiveCalorieWeeklyChangeCap.
  ///
  /// In en, this message translates to:
  /// **'Weekly change cap'**
  String get adaptiveCalorieWeeklyChangeCap;

  /// No description provided for @adaptiveCalorieSafetyFloorApplied.
  ///
  /// In en, this message translates to:
  /// **'Safety floor applied'**
  String get adaptiveCalorieSafetyFloorApplied;

  /// No description provided for @chartSevenDayTrend.
  ///
  /// In en, this message translates to:
  /// **'7-Day Trend'**
  String get chartSevenDayTrend;

  /// No description provided for @chartThirtyDayTrend.
  ///
  /// In en, this message translates to:
  /// **'30-Day Trend'**
  String get chartThirtyDayTrend;

  /// No description provided for @chartRawDot.
  ///
  /// In en, this message translates to:
  /// **'Raw Dot'**
  String get chartRawDot;

  /// No description provided for @chartTrendLine.
  ///
  /// In en, this message translates to:
  /// **'Trend Line'**
  String get chartTrendLine;

  /// No description provided for @chartGoalLine.
  ///
  /// In en, this message translates to:
  /// **'Goal Line'**
  String get chartGoalLine;

  /// No description provided for @scanSourceSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Meal Source'**
  String get scanSourceSheetTitle;

  /// No description provided for @scanSourceCamera.
  ///
  /// In en, this message translates to:
  /// **'Take photo with camera'**
  String get scanSourceCamera;

  /// No description provided for @scanSourceGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get scanSourceGallery;

  /// No description provided for @scanSourceText.
  ///
  /// In en, this message translates to:
  /// **'Write what you ate'**
  String get scanSourceText;

  /// No description provided for @scanSourceFridgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Fridge or Pantry'**
  String get scanSourceFridgeTitle;

  /// No description provided for @scanSourceInBodyTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Body Composition'**
  String get scanSourceInBodyTitle;

  /// No description provided for @todayPlanMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get todayPlanMorning;

  /// No description provided for @todayPlanAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get todayPlanAfternoon;

  /// No description provided for @todayPlanEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get todayPlanEvening;

  /// No description provided for @todayPlanWaterQuickAdd.
  ///
  /// In en, this message translates to:
  /// **'+250 ml'**
  String get todayPlanWaterQuickAdd;

  /// No description provided for @todayPlanWaterProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {goal} L'**
  String todayPlanWaterProgress(String current, String goal);

  /// No description provided for @todayPlanSleepLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Quality Sleep Log'**
  String get todayPlanSleepLogTitle;

  /// No description provided for @todayPlanSleepDuration.
  ///
  /// In en, this message translates to:
  /// **'{hours} hrs slept'**
  String todayPlanSleepDuration(String hours);

  /// No description provided for @todayPlanSleepLogSave.
  ///
  /// In en, this message translates to:
  /// **'Save Sleep'**
  String get todayPlanSleepLogSave;

  /// No description provided for @todayPlanSleepMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as 7h+ Sleep'**
  String get todayPlanSleepMarkDone;

  /// No description provided for @todayPlanSleepQuality.
  ///
  /// In en, this message translates to:
  /// **'Sleep Quality'**
  String get todayPlanSleepQuality;

  /// No description provided for @todayPlanSupplements.
  ///
  /// In en, this message translates to:
  /// **'Daily Supplements'**
  String get todayPlanSupplements;

  /// No description provided for @todayPlanBreathingAction.
  ///
  /// In en, this message translates to:
  /// **'Breathing Session'**
  String get todayPlanBreathingAction;

  /// No description provided for @stepsHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Steps'**
  String get stepsHeroTitle;

  /// No description provided for @stepsEnableButton.
  ///
  /// In en, this message translates to:
  /// **'Enable Step Counting'**
  String get stepsEnableButton;

  /// No description provided for @stepsPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Accurate Step Tracking'**
  String get stepsPermissionTitle;

  /// No description provided for @stepsPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Vireo uses your device\'s built-in motion sensor to count steps accurately throughout the day without draining your battery.'**
  String get stepsPermissionBody;

  /// No description provided for @stepsPermissionGrant.
  ///
  /// In en, this message translates to:
  /// **'Enable Now'**
  String get stepsPermissionGrant;

  /// No description provided for @stepsActiveMinutes.
  ///
  /// In en, this message translates to:
  /// **'Active Mins'**
  String get stepsActiveMinutes;

  /// No description provided for @stepsFatBurned.
  ///
  /// In en, this message translates to:
  /// **'≈ {grams}g Fat'**
  String stepsFatBurned(String grams);

  /// No description provided for @stepsKm.
  ///
  /// In en, this message translates to:
  /// **'{km} km'**
  String stepsKm(String km);

  /// No description provided for @stepsDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Steps & Walking'**
  String get stepsDetailTitle;

  /// No description provided for @stepsHourlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Hourly Breakdown'**
  String get stepsHourlyTitle;

  /// No description provided for @stepsStreakDays.
  ///
  /// In en, this message translates to:
  /// **'{days}-Day Streak'**
  String stepsStreakDays(int days);

  /// No description provided for @stepsBestDay.
  ///
  /// In en, this message translates to:
  /// **'Best Day: {steps} steps'**
  String stepsBestDay(String steps);

  /// No description provided for @stepsWeekTab.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get stepsWeekTab;

  /// No description provided for @stepsMonthTab.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get stepsMonthTab;

  /// No description provided for @mealReviewItemQty.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get mealReviewItemQty;

  /// No description provided for @mealReviewConfidence.
  ///
  /// In en, this message translates to:
  /// **'{pct}% confidence'**
  String mealReviewConfidence(int pct);

  /// No description provided for @mealReviewSourceUsda.
  ///
  /// In en, this message translates to:
  /// **'USDA Database'**
  String get mealReviewSourceUsda;

  /// No description provided for @mealReviewSourceEgypt.
  ///
  /// In en, this message translates to:
  /// **'Egyptian Food Table'**
  String get mealReviewSourceEgypt;

  /// No description provided for @mealReviewSourceAi.
  ///
  /// In en, this message translates to:
  /// **'AI Vision Estimate'**
  String get mealReviewSourceAi;

  /// No description provided for @mealReviewUnitPiece.
  ///
  /// In en, this message translates to:
  /// **'piece'**
  String get mealReviewUnitPiece;

  /// No description provided for @mealReviewUnitHandful.
  ///
  /// In en, this message translates to:
  /// **'handful'**
  String get mealReviewUnitHandful;

  /// No description provided for @mealReviewUnitGrams.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get mealReviewUnitGrams;

  /// No description provided for @mealReviewCookingRaw.
  ///
  /// In en, this message translates to:
  /// **'Raw'**
  String get mealReviewCookingRaw;

  /// No description provided for @mealReviewCookingBoiled.
  ///
  /// In en, this message translates to:
  /// **'Boiled'**
  String get mealReviewCookingBoiled;

  /// No description provided for @mealReviewCookingGrilled.
  ///
  /// In en, this message translates to:
  /// **'Grilled'**
  String get mealReviewCookingGrilled;

  /// No description provided for @mealReviewCookingFried.
  ///
  /// In en, this message translates to:
  /// **'Fried (+oil)'**
  String get mealReviewCookingFried;

  /// No description provided for @mealReviewCookingBaked.
  ///
  /// In en, this message translates to:
  /// **'Oven Baked'**
  String get mealReviewCookingBaked;

  /// No description provided for @mealReviewCaloriesFormat.
  ///
  /// In en, this message translates to:
  /// **'{count} kcal'**
  String mealReviewCaloriesFormat(int count);

  /// No description provided for @mealReviewProteinFormat.
  ///
  /// In en, this message translates to:
  /// **'{count}g protein'**
  String mealReviewProteinFormat(int count);

  /// No description provided for @mealReviewCarbsFormat.
  ///
  /// In en, this message translates to:
  /// **'{count}g carbs'**
  String mealReviewCarbsFormat(int count);

  /// No description provided for @mealReviewFatFormat.
  ///
  /// In en, this message translates to:
  /// **'{count}g fat'**
  String mealReviewFatFormat(int count);

  /// No description provided for @cuisineSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'Cuisine'**
  String get cuisineSettingTitle;

  /// No description provided for @cuisineEgyptian.
  ///
  /// In en, this message translates to:
  /// **'Egyptian'**
  String get cuisineEgyptian;

  /// No description provided for @cuisineSaudi.
  ///
  /// In en, this message translates to:
  /// **'Saudi & Gulf'**
  String get cuisineSaudi;

  /// No description provided for @cuisineLevantine.
  ///
  /// In en, this message translates to:
  /// **'Levantine'**
  String get cuisineLevantine;

  /// No description provided for @cuisineMoroccan.
  ///
  /// In en, this message translates to:
  /// **'Moroccan & Maghreb'**
  String get cuisineMoroccan;

  /// No description provided for @cuisineTurkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get cuisineTurkish;

  /// No description provided for @cuisineIndian.
  ///
  /// In en, this message translates to:
  /// **'Indian & Pakistani'**
  String get cuisineIndian;

  /// No description provided for @cuisineIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get cuisineIndonesian;

  /// No description provided for @cuisineWestern.
  ///
  /// In en, this message translates to:
  /// **'Western / Mediterranean'**
  String get cuisineWestern;

  /// No description provided for @dietProgramFitReason.
  ///
  /// In en, this message translates to:
  /// **'Fits your goal: {reason}'**
  String dietProgramFitReason(String reason);

  /// No description provided for @exerciseMusclesTargeted.
  ///
  /// In en, this message translates to:
  /// **'Target Muscles'**
  String get exerciseMusclesTargeted;

  /// No description provided for @exerciseStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'How to Perform'**
  String get exerciseStepsTitle;

  /// No description provided for @exerciseCommonMistakes.
  ///
  /// In en, this message translates to:
  /// **'Common Mistakes'**
  String get exerciseCommonMistakes;

  /// No description provided for @exerciseBreathingCue.
  ///
  /// In en, this message translates to:
  /// **'Breathing'**
  String get exerciseBreathingCue;

  /// No description provided for @exerciseEasierVariation.
  ///
  /// In en, this message translates to:
  /// **'Easier Variation'**
  String get exerciseEasierVariation;

  /// No description provided for @exerciseHarderVariation.
  ///
  /// In en, this message translates to:
  /// **'Harder Variation'**
  String get exerciseHarderVariation;

  /// No description provided for @exerciseSafetyNote.
  ///
  /// In en, this message translates to:
  /// **'Safety Note'**
  String get exerciseSafetyNote;

  /// No description provided for @exerciseWarmUpHeader.
  ///
  /// In en, this message translates to:
  /// **'Warm-Up Moves'**
  String get exerciseWarmUpHeader;

  /// No description provided for @reassessmentLaterSnooze.
  ///
  /// In en, this message translates to:
  /// **'Later (remind in 3 days)'**
  String get reassessmentLaterSnooze;

  /// No description provided for @measurementsAddEntry.
  ///
  /// In en, this message translates to:
  /// **'Log New Entry'**
  String get measurementsAddEntry;

  /// No description provided for @walkingStopSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop walking session?'**
  String get walkingStopSessionTitle;

  /// No description provided for @walkingStopSessionDesc.
  ///
  /// In en, this message translates to:
  /// **'Would you like to save or end the current walking session?'**
  String get walkingStopSessionDesc;

  /// No description provided for @walkingSessionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get walkingSessionContinue;

  /// No description provided for @walkingSessionEnd.
  ///
  /// In en, this message translates to:
  /// **'End Session'**
  String get walkingSessionEnd;

  /// No description provided for @walkingEditGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Daily Step Goal'**
  String get walkingEditGoalTitle;

  /// No description provided for @walkingTargetStepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Target Steps'**
  String get walkingTargetStepsLabel;

  /// No description provided for @walkingStepsSuffix.
  ///
  /// In en, this message translates to:
  /// **'steps'**
  String get walkingStepsSuffix;

  /// No description provided for @walkingScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Walking & Activity'**
  String get walkingScreenTitle;

  /// No description provided for @walkingDiagnosticsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Step Diagnostics'**
  String get walkingDiagnosticsTooltip;

  /// No description provided for @walkingRefreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get walkingRefreshTooltip;

  /// No description provided for @walkingStartGps.
  ///
  /// In en, this message translates to:
  /// **'Start GPS'**
  String get walkingStartGps;

  /// No description provided for @walkingActivityHistory.
  ///
  /// In en, this message translates to:
  /// **'Movement & Step History'**
  String get walkingActivityHistory;

  /// No description provided for @walkingFilterDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get walkingFilterDay;

  /// No description provided for @walkingFilterWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get walkingFilterWeek;

  /// No description provided for @walkingFilterMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get walkingFilterMonth;

  /// No description provided for @walkingAchievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements & Records 🏆'**
  String get walkingAchievementsTitle;

  /// No description provided for @stepToggleError.
  ///
  /// In en, this message translates to:
  /// **'Could not toggle step counter, please try again'**
  String get stepToggleError;

  /// No description provided for @scoreInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Score & Smart Insights 🎯'**
  String get scoreInsightsTitle;

  /// No description provided for @scoreInsightsTodaySummary.
  ///
  /// In en, this message translates to:
  /// **'Today: ate {eaten} of {target} kcal'**
  String scoreInsightsTodaySummary(int eaten, int target);

  /// No description provided for @scoreInsightsWeekFatSummary.
  ///
  /// In en, this message translates to:
  /// **'This week: lost ≈ {grams}g fat'**
  String scoreInsightsWeekFatSummary(int grams);

  /// No description provided for @scoreInsightsGoalWeeksSummary.
  ///
  /// In en, this message translates to:
  /// **'Reach goal in ≈ {weeks} weeks'**
  String scoreInsightsGoalWeeksSummary(String weeks);

  /// No description provided for @scoreInsightsActionLogProtein.
  ///
  /// In en, this message translates to:
  /// **'Log a high-protein meal'**
  String get scoreInsightsActionLogProtein;

  /// No description provided for @scoreInsightsActionWalk.
  ///
  /// In en, this message translates to:
  /// **'Start walking towards goal'**
  String get scoreInsightsActionWalk;

  /// No description provided for @scoreInsightsActionWater.
  ///
  /// In en, this message translates to:
  /// **'Log water glass now'**
  String get scoreInsightsActionWater;

  /// No description provided for @scoreInsightsPredictionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Predictions (Estimated 🔮)'**
  String get scoreInsightsPredictionsTitle;

  /// No description provided for @scoreInsightsPredictionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Based on calorie deficit and metabolic rate'**
  String get scoreInsightsPredictionsSubtitle;

  /// No description provided for @scoreInsightsNeedData.
  ///
  /// In en, this message translates to:
  /// **'Need at least 3 completed days for accurate prediction ({days} logged)'**
  String scoreInsightsNeedData(int days);

  /// No description provided for @scoreInsightsWeeklyFatLoss.
  ///
  /// In en, this message translates to:
  /// **'Weekly Fat Loss'**
  String get scoreInsightsWeeklyFatLoss;

  /// No description provided for @scoreInsightsIn4Weeks.
  ///
  /// In en, this message translates to:
  /// **'In 4 Weeks'**
  String get scoreInsightsIn4Weeks;

  /// No description provided for @scoreInsightsIn8Weeks.
  ///
  /// In en, this message translates to:
  /// **'In 8 Weeks'**
  String get scoreInsightsIn8Weeks;

  /// No description provided for @scoreInsightsGoalHitIn.
  ///
  /// In en, this message translates to:
  /// **'Goal Hit In'**
  String get scoreInsightsGoalHitIn;

  /// No description provided for @scoreInsightsClampWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Projected loss clamped to ≤1% body weight per week for muscle safety.'**
  String get scoreInsightsClampWarning;

  /// No description provided for @scoreInsightsAggressiveDeficitWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Deficit exceeds 1,000 kcal/day. Consider eating slightly more to preserve BMR.'**
  String get scoreInsightsAggressiveDeficitWarning;

  /// No description provided for @scoreInsightsHowCalculatedTitle.
  ///
  /// In en, this message translates to:
  /// **'How was this calculated? (Mifflin-St Jeor)'**
  String get scoreInsightsHowCalculatedTitle;

  /// No description provided for @scoreInsightsHowCalculatedBmr.
  ///
  /// In en, this message translates to:
  /// **'• Basal Metabolic Rate (BMR): {bmr} kcal'**
  String scoreInsightsHowCalculatedBmr(String bmr);

  /// No description provided for @scoreInsightsHowCalculatedTdee.
  ///
  /// In en, this message translates to:
  /// **'• Total Daily Energy Expenditure (TDEE): {tdee} kcal'**
  String scoreInsightsHowCalculatedTdee(String tdee);

  /// No description provided for @scoreInsightsHowCalculatedFat.
  ///
  /// In en, this message translates to:
  /// **'• 7,700 kcal deficit ≈ 1 kg fat loss.'**
  String get scoreInsightsHowCalculatedFat;

  /// No description provided for @scoreInsightsBodyCompTitle.
  ///
  /// In en, this message translates to:
  /// **'Body Composition'**
  String get scoreInsightsBodyCompTitle;

  /// No description provided for @scoreInsightsBodyCompNewMeasure.
  ///
  /// In en, this message translates to:
  /// **'New Measure'**
  String get scoreInsightsBodyCompNewMeasure;

  /// No description provided for @scoreInsightsBodyCompPrompt.
  ///
  /// In en, this message translates to:
  /// **'Track body fat and muscle accurately with tape or InBody'**
  String get scoreInsightsBodyCompPrompt;

  /// No description provided for @scoreInsightsEnergyBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Energy Balance (Eaten vs Burned)'**
  String get scoreInsightsEnergyBalanceTitle;

  /// No description provided for @scoreInsightsEatenKcal.
  ///
  /// In en, this message translates to:
  /// **'Eaten'**
  String get scoreInsightsEatenKcal;

  /// No description provided for @scoreInsightsBurnedKcal.
  ///
  /// In en, this message translates to:
  /// **'Burned'**
  String get scoreInsightsBurnedKcal;

  /// No description provided for @scoreInsightsMacrosTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Macros (Target vs Actual)'**
  String get scoreInsightsMacrosTitle;

  /// No description provided for @scoreInsightsScoreTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'7-Day Score Trend'**
  String get scoreInsightsScoreTrendTitle;

  /// No description provided for @scoreInsightsImmediateActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Actionable Tips to Boost Score:'**
  String get scoreInsightsImmediateActionsTitle;

  /// Toast at 25% step milestone
  ///
  /// In en, this message translates to:
  /// **'{gender, select, female{Strong start, champion! 👏} other{Strong start, champion! 👏}}'**
  String stepMilestoneToast25(String gender);

  /// Toast at 50% step milestone
  ///
  /// In en, this message translates to:
  /// **'{gender, select, female{Halfway there, champion! 💪} other{Halfway there, champion! 💪}}'**
  String stepMilestoneToast50(String gender);

  /// Toast at 75% step milestone
  ///
  /// In en, this message translates to:
  /// **'{gender, select, female{Almost there, champion! 🔥} other{Almost there, champion! 🔥}}'**
  String stepMilestoneToast75(String gender);

  /// Toast at 100% step milestone
  ///
  /// In en, this message translates to:
  /// **'{gender, select, female{Incredible job! Daily goal crushed 🏆} other{Incredible job! Daily goal crushed 🏆}}'**
  String stepMilestoneToast100(String gender);

  /// No description provided for @livingBackgroundsTitle.
  ///
  /// In en, this message translates to:
  /// **'Living Backgrounds'**
  String get livingBackgroundsTitle;

  /// No description provided for @livingBackgroundsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dynamic scenes evolving with your steps & rotating every 3 days'**
  String get livingBackgroundsSubtitle;

  /// No description provided for @livingBackgroundsEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable Living Backgrounds'**
  String get livingBackgroundsEnable;

  /// No description provided for @livingBackgroundsSceneLock.
  ///
  /// In en, this message translates to:
  /// **'Lock Scene'**
  String get livingBackgroundsSceneLock;

  /// No description provided for @livingBackgroundsAutoRotate.
  ///
  /// In en, this message translates to:
  /// **'Rotate every 3 days'**
  String get livingBackgroundsAutoRotate;

  /// No description provided for @livingBackgroundsPreview.
  ///
  /// In en, this message translates to:
  /// **'Live Scene Preview'**
  String get livingBackgroundsPreview;

  /// No description provided for @livingBackgroundsUnlockForCoins.
  ///
  /// In en, this message translates to:
  /// **'Unlock for {coins} coins'**
  String livingBackgroundsUnlockForCoins(int coins);

  /// No description provided for @livingBackgroundsUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get livingBackgroundsUnlocked;

  /// No description provided for @workoutRpeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How hard did it feel? 1 = very easy, 10 = very hard'**
  String get workoutRpeSubtitle;

  /// No description provided for @workoutRpeLabel.
  ///
  /// In en, this message translates to:
  /// **'{level, select, 1{Very easy} 2{Easy} 3{Fairly easy} 4{Light} 5{Moderate} 6{Somewhat hard} 7{Tough} 8{Hard} 9{Really hard} other{Very hard}}'**
  String workoutRpeLabel(String level);

  /// No description provided for @workoutRpeFeelingsTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you feel?'**
  String get workoutRpeFeelingsTitle;

  /// No description provided for @workoutFeelTired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get workoutFeelTired;

  /// No description provided for @workoutFeelJointPain.
  ///
  /// In en, this message translates to:
  /// **'Joint pain'**
  String get workoutFeelJointPain;

  /// No description provided for @workoutFeelHappy.
  ///
  /// In en, this message translates to:
  /// **'{gender, select, female{Happy} other{Happy}}'**
  String workoutFeelHappy(String gender);

  /// No description provided for @workoutFeelEnergized.
  ///
  /// In en, this message translates to:
  /// **'High energy'**
  String get workoutFeelEnergized;

  /// No description provided for @workoutRpeNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Add a note (optional)'**
  String get workoutRpeNoteHint;

  /// No description provided for @workoutRpeSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get workoutRpeSave;

  /// No description provided for @workoutRpeDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get workoutRpeDone;

  /// No description provided for @workoutRpeSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved ✅'**
  String get workoutRpeSavedTitle;

  /// No description provided for @workoutRpeCommentJoint.
  ///
  /// In en, this message translates to:
  /// **'Joint pain is a signal worth respecting. Lighten the load next session and focus on form.'**
  String get workoutRpeCommentJoint;

  /// No description provided for @workoutRpeCommentHard.
  ///
  /// In en, this message translates to:
  /// **'That was a heavy one. We will ease the load a little next time so you recover well.'**
  String get workoutRpeCommentHard;

  /// No description provided for @workoutRpeCommentBetter.
  ///
  /// In en, this message translates to:
  /// **'Your performance is better! The same workout felt lighter than last time 💪'**
  String get workoutRpeCommentBetter;

  /// No description provided for @workoutRpeCommentEasy.
  ///
  /// In en, this message translates to:
  /// **'That felt easy. Next session we will nudge the load up a little.'**
  String get workoutRpeCommentEasy;

  /// No description provided for @workoutRpeCommentSteady.
  ///
  /// In en, this message translates to:
  /// **'Just the right effort. Keep this rhythm.'**
  String get workoutRpeCommentSteady;

  /// No description provided for @workoutRpeCommentPartial.
  ///
  /// In en, this message translates to:
  /// **'What you did of the sets still counts. We will come back stronger next session.'**
  String get workoutRpeCommentPartial;

  /// No description provided for @foodFactCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Food fact'**
  String get foodFactCardTitle;

  /// No description provided for @foodFactShareHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to share as a story card'**
  String get foodFactShareHint;

  /// No description provided for @ramadanGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Ramadan guide'**
  String get ramadanGuideTitle;

  /// No description provided for @ramadanGuideOpenHint.
  ///
  /// In en, this message translates to:
  /// **'Suhoor ranking & iftar pacing — tap to open'**
  String get ramadanGuideOpenHint;

  /// No description provided for @ramadanSuhoorRankTitle.
  ///
  /// In en, this message translates to:
  /// **'Suhoor fullness ranking'**
  String get ramadanSuhoorRankTitle;

  /// No description provided for @ramadanSuhoorRankSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Example portion {grams} g · ≈ {kcal} kcal'**
  String ramadanSuhoorRankSubtitle(int grams, int kcal);

  /// No description provided for @ramadanIftarPaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Iftar pacing'**
  String get ramadanIftarPaceTitle;

  /// No description provided for @ramadanIftarStep1.
  ///
  /// In en, this message translates to:
  /// **'Dates + water first'**
  String get ramadanIftarStep1;

  /// No description provided for @ramadanIftarStep2.
  ///
  /// In en, this message translates to:
  /// **'Warm soup'**
  String get ramadanIftarStep2;

  /// No description provided for @ramadanIftarStep3.
  ///
  /// In en, this message translates to:
  /// **'Wait 15 minutes'**
  String get ramadanIftarStep3;

  /// No description provided for @ramadanIftarStep4.
  ///
  /// In en, this message translates to:
  /// **'Main dish'**
  String get ramadanIftarStep4;

  /// No description provided for @ramadanReboundTitle.
  ///
  /// In en, this message translates to:
  /// **'After Ramadan'**
  String get ramadanReboundTitle;

  /// No description provided for @ramadanReboundBody.
  ///
  /// In en, this message translates to:
  /// **'{gender, select, female{Ease back gently: keep suhoor protein, log iftar without guilt, and add 10 minutes of walking for a week before big calorie cuts.} other{Ease back gently: keep suhoor protein, log iftar without guilt, and add 10 minutes of walking for a week before big calorie cuts.}}'**
  String ramadanReboundBody(String gender);

  /// No description provided for @settingsMySubscription.
  ///
  /// In en, this message translates to:
  /// **'My subscription'**
  String get settingsMySubscription;

  /// No description provided for @settingsMySubscriptionBody.
  ///
  /// In en, this message translates to:
  /// **'Cancel or change your plan anytime in Google Play — no calls or hidden steps.'**
  String get settingsMySubscriptionBody;

  /// No description provided for @weeklyBurnShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Your burn balance this week'**
  String get weeklyBurnShareTitle;

  /// No description provided for @weeklyBurnShareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your steps & streak'**
  String get weeklyBurnShareSubtitle;

  /// No description provided for @weeklyBurnShareCaption.
  ///
  /// In en, this message translates to:
  /// **'My weekly burn balance on Vireo'**
  String get weeklyBurnShareCaption;

  /// No description provided for @weeklyBurnShareAction.
  ///
  /// In en, this message translates to:
  /// **'Share story card'**
  String get weeklyBurnShareAction;

  /// No description provided for @weeklyBurnShareIncludeWeight.
  ///
  /// In en, this message translates to:
  /// **'Include weight change on the card'**
  String get weeklyBurnShareIncludeWeight;

  /// No description provided for @weeklyBurnShareStepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Steps this week'**
  String get weeklyBurnShareStepsLabel;

  /// No description provided for @weeklyBurnShareStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get weeklyBurnShareStreakLabel;

  /// No description provided for @weeklyBurnShareWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight change'**
  String get weeklyBurnShareWeightLabel;

  /// No description provided for @widgetCaloriesLeftLabel.
  ///
  /// In en, this message translates to:
  /// **'Calories left'**
  String get widgetCaloriesLeftLabel;

  /// No description provided for @scanLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily AI scan limit reached'**
  String get scanLimitTitle;

  /// No description provided for @scanLimitBody.
  ///
  /// In en, this message translates to:
  /// **'Photo scans use server resources. Wait until tomorrow, go Pro, or log manually — your choice.'**
  String get scanLimitBody;

  /// No description provided for @scanLimitProTitle.
  ///
  /// In en, this message translates to:
  /// **'Vireo Pro'**
  String get scanLimitProTitle;

  /// No description provided for @scanLimitProSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlimited AI scans (40/day fair use), no ads, full programs'**
  String get scanLimitProSubtitle;

  /// No description provided for @scanLimitProCta.
  ///
  /// In en, this message translates to:
  /// **'Get Pro'**
  String get scanLimitProCta;

  /// No description provided for @scanLimitWaitTitle.
  ///
  /// In en, this message translates to:
  /// **'Wait until tomorrow'**
  String get scanLimitWaitTitle;

  /// No description provided for @scanLimitWaitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your free scans reset at midnight — text & barcode logging stay unlimited'**
  String get scanLimitWaitSubtitle;

  /// No description provided for @scanLimitWaitCta.
  ///
  /// In en, this message translates to:
  /// **'OK, see you tomorrow'**
  String get scanLimitWaitCta;

  /// No description provided for @scanLimitManualTitle.
  ///
  /// In en, this message translates to:
  /// **'Search & manual log'**
  String get scanLimitManualTitle;

  /// No description provided for @scanLimitManualSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Always free and unlimited'**
  String get scanLimitManualSubtitle;

  /// No description provided for @scanLimitManualCta.
  ///
  /// In en, this message translates to:
  /// **'Log manually'**
  String get scanLimitManualCta;

  /// No description provided for @scanLimitAdRewardSnack.
  ///
  /// In en, this message translates to:
  /// **'+2 extra scans added for today'**
  String get scanLimitAdRewardSnack;

  /// No description provided for @scanLimitAdFailedSnack.
  ///
  /// In en, this message translates to:
  /// **'Could not load the ad — try again later'**
  String get scanLimitAdFailedSnack;

  /// No description provided for @rebalanceCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s rebalance'**
  String get rebalanceCardTitle;

  /// No description provided for @rebalanceSafeDay.
  ///
  /// In en, this message translates to:
  /// **'You\'re still in the safe zone today'**
  String get rebalanceSafeDay;

  /// No description provided for @rebalanceNeedsTap.
  ///
  /// In en, this message translates to:
  /// **'Nothing changes until you tap an option'**
  String get rebalanceNeedsTap;

  /// No description provided for @weeklyBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly balance'**
  String get weeklyBalanceTitle;

  /// No description provided for @weeklyBalanceEmpty.
  ///
  /// In en, this message translates to:
  /// **'Log a few days to see your weekly balance'**
  String get weeklyBalanceEmpty;

  /// No description provided for @weeklyBalanceOnTrack.
  ///
  /// In en, this message translates to:
  /// **'Still on track: weekly deficit {actual} of {target}'**
  String weeklyBalanceOnTrack(int actual, int target);

  /// No description provided for @weeklyBalanceOffTrack.
  ///
  /// In en, this message translates to:
  /// **'This week: deficit {actual} of {target} — we can adjust'**
  String weeklyBalanceOffTrack(int actual, int target);

  /// No description provided for @weeklyBalanceCumulative.
  ///
  /// In en, this message translates to:
  /// **'Cumulative: {kcal} kcal'**
  String weeklyBalanceCumulative(int kcal);

  /// No description provided for @energyLedgerTitle.
  ///
  /// In en, this message translates to:
  /// **'Your burn balance'**
  String get energyLedgerTitle;

  /// No description provided for @energyLedgerToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get energyLedgerToday;

  /// No description provided for @energyLedgerWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get energyLedgerWeek;

  /// No description provided for @energyLedgerMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get energyLedgerMonth;

  /// No description provided for @energyLedgerAllTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get energyLedgerAllTime;

  /// No description provided for @energyLedgerBurned.
  ///
  /// In en, this message translates to:
  /// **'Burned {kcal} kcal ≈ {fatKg} kg fat'**
  String energyLedgerBurned(int kcal, String fatKg);

  /// No description provided for @energyLedgerBalanceNote.
  ///
  /// In en, this message translates to:
  /// **'Activity kcal and balance-based fat are labeled separately (estimate)'**
  String get energyLedgerBalanceNote;

  /// No description provided for @energyLedgerStepsDistance.
  ///
  /// In en, this message translates to:
  /// **'{steps} steps · {km} km'**
  String energyLedgerStepsDistance(int steps, String km);

  /// No description provided for @fingerprintTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Fingerprint — Vireo smart system'**
  String get fingerprintTitle;

  /// No description provided for @fingerprintSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learned from your real habits after 14 days'**
  String get fingerprintSubtitle;

  /// No description provided for @fingerprintReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get fingerprintReset;

  /// No description provided for @fingerprintActivity.
  ///
  /// In en, this message translates to:
  /// **'Your activity'**
  String get fingerprintActivity;

  /// No description provided for @fingerprintNutrition.
  ///
  /// In en, this message translates to:
  /// **'Your eating'**
  String get fingerprintNutrition;

  /// No description provided for @fingerprintTolerance.
  ///
  /// In en, this message translates to:
  /// **'Your tolerance'**
  String get fingerprintTolerance;

  /// No description provided for @fingerprintChronotype.
  ///
  /// In en, this message translates to:
  /// **'Your timing'**
  String get fingerprintChronotype;

  /// No description provided for @fingerprintStepsUnit.
  ///
  /// In en, this message translates to:
  /// **'comfortable steps'**
  String get fingerprintStepsUnit;

  /// No description provided for @fingerprintMealsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} meals / day'**
  String fingerprintMealsCount(int count);

  /// No description provided for @fingerprintDeficitValue.
  ///
  /// In en, this message translates to:
  /// **'Sustainable deficit ≈ {kcal} kcal'**
  String fingerprintDeficitValue(int kcal);

  /// No description provided for @fingerprintLogHour.
  ///
  /// In en, this message translates to:
  /// **'Usually logs around {hour}:00'**
  String fingerprintLogHour(int hour);

  /// No description provided for @fingerprintActivityWhy.
  ///
  /// In en, this message translates to:
  /// **'Why? Median of your best 70% step days'**
  String get fingerprintActivityWhy;

  /// No description provided for @fingerprintNutritionWhy.
  ///
  /// In en, this message translates to:
  /// **'Why? From your meal times and favorites'**
  String get fingerprintNutritionWhy;

  /// No description provided for @fingerprintToleranceWhy.
  ///
  /// In en, this message translates to:
  /// **'Why? Deficit you sustain without rebound'**
  String get fingerprintToleranceWhy;

  /// No description provided for @fingerprintChronotypeWhy.
  ///
  /// In en, this message translates to:
  /// **'Why? From your logging and walk hours'**
  String get fingerprintChronotypeWhy;

  /// No description provided for @fingerprintEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get fingerprintEdit;

  /// No description provided for @fingerprintNotReady.
  ///
  /// In en, this message translates to:
  /// **'Still learning — {days}/14 days'**
  String fingerprintNotReady(int days);

  /// No description provided for @strideCalibratedBadge.
  ///
  /// In en, this message translates to:
  /// **'Calibrated to your walk ✓'**
  String get strideCalibratedBadge;

  /// No description provided for @stepSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source: {source}'**
  String stepSourceLabel(String source);

  /// No description provided for @stepSourcePedometer.
  ///
  /// In en, this message translates to:
  /// **'Phone sensor'**
  String get stepSourcePedometer;

  /// No description provided for @stepSourceHealth.
  ///
  /// In en, this message translates to:
  /// **'Health Connect'**
  String get stepSourceHealth;

  /// No description provided for @stepSourceManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get stepSourceManual;

  /// No description provided for @stepSourceNone.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get stepSourceNone;

  /// No description provided for @eatBackSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'Eat-back from exercise'**
  String get eatBackSettingTitle;

  /// No description provided for @eatBackHalf.
  ///
  /// In en, this message translates to:
  /// **'50% (default)'**
  String get eatBackHalf;

  /// No description provided for @eatBackFull.
  ///
  /// In en, this message translates to:
  /// **'100%'**
  String get eatBackFull;

  /// No description provided for @eatBackNone.
  ///
  /// In en, this message translates to:
  /// **'0%'**
  String get eatBackNone;

  /// No description provided for @tdeeCheckInTitle.
  ///
  /// In en, this message translates to:
  /// **'Your plan updated'**
  String get tdeeCheckInTitle;

  /// No description provided for @tdeeCheckInUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get tdeeCheckInUndo;

  /// No description provided for @missedStepsCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Yesterday\'s steps'**
  String get missedStepsCardTitle;

  /// No description provided for @outdoorNetKcalLabel.
  ///
  /// In en, this message translates to:
  /// **'Net kcal'**
  String get outdoorNetKcalLabel;

  /// No description provided for @outdoorCadenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Cadence'**
  String get outdoorCadenceLabel;

  /// No description provided for @weeklyReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly review'**
  String get weeklyReviewTitle;

  /// No description provided for @adaptiveTdeeBlendNote.
  ///
  /// In en, this message translates to:
  /// **'Blended from your logs + formula'**
  String get adaptiveTdeeBlendNote;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'tr',
    'ur',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'ar':
      {
        switch (locale.countryCode) {
          case 'EG':
            return AppLocalizationsArEg();
          case 'SA':
            return AppLocalizationsArSa();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'tr':
      return AppLocalizationsTr();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
