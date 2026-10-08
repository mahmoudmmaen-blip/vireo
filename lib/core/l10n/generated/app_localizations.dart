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
  /// **'Pre-workout reminder'**
  String get notificationsPreWorkout;

  /// No description provided for @notificationsPreWorkoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get ready to train'**
  String get notificationsPreWorkoutSubtitle;

  /// No description provided for @notificationsSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep reminder'**
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
  /// **'Notifications'**
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
  /// **'Weekly report'**
  String get notificationsWeeklyReport;

  /// No description provided for @notificationsWeeklyReportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See how your week went'**
  String get notificationsWeeklyReportSubtitle;

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
