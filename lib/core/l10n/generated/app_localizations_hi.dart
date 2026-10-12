// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Vireo';

  @override
  String get homeTitle => 'होम';

  @override
  String get onboardingTitle => 'स्वागत है';

  @override
  String get workoutTitle => 'वर्कआउट';

  @override
  String get nutritionTitle => 'पोषण';

  @override
  String get progressTitle => 'प्रगति';

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get authTitle => 'साइन इन करें';

  @override
  String get languageToggle => 'English';

  @override
  String get setupComplete => 'Vireo तैयार है';

  @override
  String get continueButton => 'जारी रखें';

  @override
  String get skipButton => 'छोड़ें';

  @override
  String get finishButton => 'समाप्त करें';

  @override
  String get yesButton => 'हाँ';

  @override
  String get noButton => 'नहीं';

  @override
  String onboardingStepProgress(int current, int total) {
    return '$total में से चरण $current';
  }

  @override
  String get onboardingStep1Title => 'आपके बारे में';

  @override
  String get onboardingStep1Subtitle =>
      'हम इन बुनियादी जानकारियों से आपका प्लान तैयार करेंगे।';

  @override
  String get onboardingStep2Title => 'स्वास्थ्य जांच';

  @override
  String get onboardingStep2Subtitle =>
      'ईमानदारी से उत्तर दें — इससे हमें वर्कआउट को सुरक्षित रखने में मदद मिलती है।';

  @override
  String get onboardingStep3Title => 'आप कहाँ ट्रेनिंग करते हैं';

  @override
  String get onboardingStep3Subtitle =>
      'हम केवल वही व्यायाम दिखाएंगे जो आपकी सेटअप के अनुकूल हों।';

  @override
  String get onboardingStep4Title => 'आपका लक्ष्य';

  @override
  String get onboardingStep4Subtitle =>
      'इस समय आपके लिए सबसे महत्वपूर्ण क्या है?';

  @override
  String get onboardingStep5Title => 'शुरू करने से पहले';

  @override
  String get onboardingStep5Subtitle =>
      'आगे बढ़ने के लिए कृपया पढ़ें और स्वीकार करें।';

  @override
  String get onboardingStep6Title => 'ट्रैक पर रहें';

  @override
  String get onboardingStep6Subtitle =>
      'वैकल्पिक रिमाइंडर — आप इन्हें बाद में बदल सकते हैं।';

  @override
  String get unitsMetric => 'किग्रा / सेमी';

  @override
  String get unitsImperial => 'पाउंड / इंच';

  @override
  String get onboardingAge => 'उम्र';

  @override
  String get onboardingHeight => 'कद';

  @override
  String get onboardingWeight => 'वज़न';

  @override
  String get onboardingActivityLevel => 'गतिविधि स्तर';

  @override
  String get onboardingDietaryOptional =>
      'खान-पान संबंधी प्राथमिकताएं (वैकल्पिक)';

  @override
  String get activitySedentary => 'अधिकतर गतिहीन';

  @override
  String get activityModerate => 'मध्यम सक्रिय';

  @override
  String get activityVeryActive => 'अत्यधिक सक्रिय';

  @override
  String get dietHalal => 'हलाल';

  @override
  String get dietVegetarian => 'शाकाहारी';

  @override
  String get dietVegan => 'वीगन';

  @override
  String get dietGlutenFree => 'ग्लूटेन-मुक्त';

  @override
  String get dietDairyFree => 'डेयरी-मुक्त';

  @override
  String get dietLowSodium => 'कम सोडियम';

  @override
  String get dietLowCarb => 'कम कार्ब';

  @override
  String get dietDiabeticFriendly => 'डायबिटिक-फ्रेंडली';

  @override
  String get onboardingMedicalFlagNotice =>
      'हम तीव्रता को समायोजित करेंगे और वर्कआउट के दौरान सुरक्षा रिमाइंडर दिखाएंगे।';

  @override
  String get healthQuestionHeart => 'हृदय रोग या कार्डियोवैस्कुलर समस्या?';

  @override
  String get healthQuestionDiabetes => 'डायबिटीज या ब्लड शुगर की समस्या?';

  @override
  String get healthQuestionBloodPressure => 'हाई या लो ब्लड प्रेशर?';

  @override
  String get healthQuestionJoints => 'जोड़ों की चोट या पुराना दर्द?';

  @override
  String get healthQuestionMedications =>
      'वर्तमान में नियमित दवाएं ले रहे हैं?';

  @override
  String get envHomeNoEquipment => 'घर — कोई उपकरण नहीं';

  @override
  String get envHomeNoEquipmentDesc => 'केवल बॉडीवेट व्यायाम';

  @override
  String get envHomeLightEquipment => 'घर — हल्के उपकरण';

  @override
  String get envHomeLightEquipmentDesc =>
      'रेजिस्टेंस बैंड, डम्बल या समान उपकरण';

  @override
  String get envGymFull => 'फुल जिम';

  @override
  String get envGymFullDesc => 'मशीनें, बारबेल, फुल रैक की सुविधा';

  @override
  String get envWalkingOnly => 'केवल वॉक';

  @override
  String get envWalkingOnlyDesc => 'कदमों का लक्ष्य और हल्की मोबिलिटी';

  @override
  String get goalWeightLoss => 'वज़न घटाना';

  @override
  String get goalWeightLossDesc => 'टिकाऊ ट्रेनिंग के साथ फैट लॉस';

  @override
  String get goalMuscleGain => 'मांसपेशियों का निर्माण';

  @override
  String get goalMuscleGainDesc => 'स्ट्रेंथ और लीन मसल मास पर ध्यान';

  @override
  String get goalGeneralVitality => 'सामान्य ऊर्जा और स्फूर्ति';

  @override
  String get goalGeneralVitalityDesc => 'ऊर्जा, निरंतरता और बेहतर महसूस करना';

  @override
  String get goalAllOfAbove => 'उपरोक्त सभी';

  @override
  String get goalAllOfAboveDesc => 'सभी लक्ष्यों का संतुलित प्लान';

  @override
  String get legalDisclaimerText =>
      'Vireo एक संगठनात्मक फिटनेस टूल है और यह प्रत्यक्ष चिकित्सा सलाह का विकल्प नहीं है। सामग्री (वर्कआउट, मील प्लान और स्वास्थ्य जानकारी) केवल सामान्य मार्गदर्शन के लिए है।\n\nयदि आपको कोई पुरानी बीमारी है — जैसे हृदय रोग, डायबिटीज, हाई ब्लड प्रेशर, या जोड़ों की चोट — या आप दवा ले रहे हैं, तो कोई भी व्यायाम या पोषण कार्यक्रम शुरू करने से पहले अपने डॉक्टर से परामर्श लें।\n\nआहार पूरक (सप्लीमेंट्स) और हार्मोन संबंधी मार्गदर्शन (जैसे टेस्टोस्टेरोन) केवल सामान्य शैक्षिक जानकारी हैं। वे कोई चिकित्सीय नुस्खे या उपचार की सिफारिशें नहीं हैं।\n\nइन-ऐप प्रोग्राम में भाग लेकर, मैं पुष्टि करता/करती हूँ कि मैंने शर्तें पढ़ ली हैं और समझता/समझती हूँ कि बिना चिकित्सीय परामर्श के ऐप का उपयोग करने से होने वाली किसी भी चोट या स्वास्थ्य संबंधी जटिलताओं के लिए Vireo उत्तरदायी नहीं है।';

  @override
  String get legalDisclaimerSection1 =>
      'Vireo एक संगठनात्मक फिटनेस टूल है और यह प्रत्यक्ष चिकित्सा सलाह का विकल्प नहीं है। सामग्री (वर्कआउट, मील प्लान और स्वास्थ्य जानकारी) केवल सामान्य मार्गदर्शन के लिए है।';

  @override
  String get legalDisclaimerSection2 =>
      'यदि आपको कोई पुरानी बीमारी है — जैसे हृदय रोग, डायबिटीज, हाई ब्लड प्रेशर, या जोड़ों की चोट — या आप दवा ले रहे हैं, तो कोई भी व्यायाम या पोषण कार्यक्रम शुरू करने से पहले अपने डॉक्टर से परामर्श लें।';

  @override
  String get legalDisclaimerSection3 =>
      'आहार पूरक (सप्लीमेंट्स) केवल सामान्य शैक्षिक जानकारी हैं। वे कोई चिकित्सीय नुस्खे या उपचार की सिफारिशें नहीं हैं।';

  @override
  String get legalDisclaimerSection4 =>
      'हार्मोन संबंधी मार्गदर्शन (जैसे टेस्टोस्टेरोन) केवल सामान्य शैक्षिक जानकारी है। यह कोई चिकित्सीय नुस्खा या उपचार की सिफारिश नहीं है।';

  @override
  String get legalDisclaimerSection5 =>
      'इन-ऐप प्रोग्राम में भाग लेकर, मैं पुष्टि करता/करती हूँ कि मैंने शर्तें पढ़ ली हैं और समझता/समझती हूँ कि बिना चिकित्सीय परामर्श के ऐप का उपयोग करने से होने वाली किसी भी चोट या स्वास्थ्य संबंधी जटिलताओं के लिए Vireo उत्तरदायी नहीं है।';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get consentCheckboxLabel =>
      'मैंने नियम व शर्तें और स्वास्थ्य अस्वीकरण पढ़ लिया है और मैं इनसे सहमत हूँ';

  @override
  String get notificationWorkoutTime => 'वर्कआउट का पसंदीदा समय';

  @override
  String get notificationWalkingReminder => 'दैनिक वॉक रिमाइंडर';

  @override
  String get notificationWeeklyCheckIn => 'साप्ताहिक चेक-इन रिमाइंडर';

  @override
  String get notificationNotSet => 'सेट नहीं है';

  @override
  String get authWelcomeTitle => 'Vireo में आपका स्वागत है';

  @override
  String get authWelcomeSubtitle =>
      'डिवाइसों के बीच प्रगति सिंक करने के लिए साइन इन करें, या अतिथि के रूप में जारी रखें।';

  @override
  String get authSaveProgressTitle => 'अपनी प्रगति सहेजें';

  @override
  String get authSaveProgressSubtitle =>
      'एक खाता लिंक करें ताकि आपका प्लान, स्कैन और चैट सभी डिवाइसों पर सिंक हो सकें।';

  @override
  String get signInWithApple => 'Apple के साथ साइन इन करें';

  @override
  String get signInWithGoogle => 'Google के साथ साइन इन करें';

  @override
  String get signInWithEmail => 'ईमेल के साथ साइन इन करें';

  @override
  String get authContinueApple => 'Apple के साथ जारी रखें';

  @override
  String get authContinueGoogle => 'Google के साथ जारी रखें';

  @override
  String get authContinueEmail => 'ईमेल के साथ जारी रखें';

  @override
  String get authSignInWithPassword => 'पासवर्ड से साइन इन करें';

  @override
  String get authSendCode => 'कोड भेजें';

  @override
  String get authVerifyCode => 'कोड सत्यापित करें';

  @override
  String get authResendCode => 'कोड दोबारा भेजें';

  @override
  String authResendIn(int seconds) {
    return '${seconds}s में दोबारा भेजें';
  }

  @override
  String authOtpSentTo(String email) {
    return 'हमने $email पर 6 अंकों का कोड भेजा है';
  }

  @override
  String get authBack => 'वापस';

  @override
  String get continueAsGuest => 'अतिथि के रूप में जारी रखें';

  @override
  String get authEmail => 'ईमेल';

  @override
  String get authPassword => 'पासवर्ड';

  @override
  String get authSignIn => 'साइन इन करें';

  @override
  String get authSignUp => 'साइन अप करें';

  @override
  String get authHasAccount => 'क्या पहले से खाता है?';

  @override
  String get authNoAccount => 'खाता नहीं है?';

  @override
  String get authSignedIn => 'साइन इन हो गया';

  @override
  String get authErrorGeneric => 'कुछ गड़बड़ हुई। कृपया पुनः प्रयास करें।';

  @override
  String get authErrorOffline =>
      'इंटरनेट नहीं है। अपना कनेक्शन जांचें और पुनः प्रयास करें।';

  @override
  String get authErrorWrongCode => 'गलत कोड। अंक जांचें और पुनः प्रयास करें।';

  @override
  String get authErrorTooMany =>
      'बहुत अधिक प्रयास, कृपया एक मिनट बाद पुनः प्रयास करें।';

  @override
  String get authErrorInvalidEmail => 'एक मान्य ईमेल पता दर्ज करें।';

  @override
  String get authErrorCancelled => 'साइन-इन रद्द कर दिया गया।';

  @override
  String get signOut => 'साइन आउट करें';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get guestModeTitle => 'अतिथि मोड';

  @override
  String get guestModeSubtitle =>
      'आपकी प्रगति केवल इस डिवाइस पर सहेजी गई है। सिंक करने और सदस्यता लेने के लिए एक खाता बनाएं।';

  @override
  String get profileStatWorkoutsLabel => 'पूरे किए गए वर्कआउट';

  @override
  String get profileStatStreakLabel => 'दिनों की स्ट्रीक';

  @override
  String get saveProgressToCloud => 'प्रगति को क्लाउड पर सहेजें';

  @override
  String get profileCloudSynced => 'प्रगति आपके खाते से सिंक हो गई है';

  @override
  String get authGateTitle => 'खाता बनाएं';

  @override
  String get authGateSaveProgress =>
      'अपनी प्रगति को क्लाउड पर सहेजने और किसी भी डिवाइस पर एक्सेस करने के लिए एक मुफ़्त खाता बनाएं।';

  @override
  String get authGateSubscribe =>
      'सदस्यता लेने से पहले एक खाता बनाएं ताकि आपकी प्रीमियम एक्सेस आपसे लिंक हो सके।';

  @override
  String get authGateAiFeatures =>
      'AI मील स्कैन और Vireo कोच का उपयोग करने के लिए एक मुफ़्त खाता बनाएं। आपके चैट और स्कैन आपके खाते में सुरक्षित रूप से सिंक होते हैं।';

  @override
  String get authGateSignUp => 'साइन अप करें';

  @override
  String get authGateNotNow => 'अभी नहीं';

  @override
  String get deleteAccountTitle => 'खाता हटाएं';

  @override
  String get deleteAccountWarningTitle => 'यह वापस नहीं बदला जा सकता';

  @override
  String get deleteAccountWarningBody =>
      'आपके सभी प्रोफ़ाइल डेटा, वर्कआउट लॉग, मील प्लान और प्रगति की तस्वीरें हमारे सर्वर से स्थायी रूप से हटा दी जाएंगी।';

  @override
  String get deleteAccountCancel => 'रद्द करें';

  @override
  String get deleteAccountContinue => 'जारी रखें';

  @override
  String get deleteAccountConfirmTitle => 'हटाने की पुष्टि करें';

  @override
  String get deleteAccountConfirmInstructions =>
      'स्थायी खाता हटाने की पुष्टि के लिए नीचे दिया गया शब्द ठीक वैसे ही टाइप करें:';

  @override
  String get deleteConfirmationWord => 'DELETE';

  @override
  String get deleteAccountTypeHint => 'DELETE टाइप करें';

  @override
  String get deleteAccountConfirmButton => 'मेरा खाता स्थायी रूप से हटाएं';

  @override
  String get deleteAccountSuccess => 'आपका खाता हटा दिया गया है।';

  @override
  String get workoutMedicalWarning =>
      'आपने ऑनबोर्डिंग के दौरान स्वास्थ्य समस्या का संकेत दिया था। दर्द, चक्कर या सांस फूलने पर तुरंत रुकें। तीव्र व्यायाम से पहले अपने डॉक्टर से सलाह लें।';

  @override
  String get workoutWarmUpTitle => 'वॉर्म-अप';

  @override
  String get workoutWarmUpSubtitle =>
      'अपने मुख्य वर्कआउट से पहले ये मोबिलिटी व्यायाम पूरे करें।';

  @override
  String get workoutCoolDownTitle => 'कूल-डाउन';

  @override
  String get workoutCoolDownSubtitle =>
      'आपके शरीर को रिकवर करने में मदद करने के लिए सौम्य मोबिलिटी।';

  @override
  String get workoutActiveTitle => 'सक्रिय वर्कआउट';

  @override
  String get workoutBeginWorkout => 'वर्कआउट शुरू करें';

  @override
  String get workoutFinishCoolDown => 'कूल-डाउन समाप्त करें';

  @override
  String get workoutStartButton => 'आज का वर्कआउट शुरू करें';

  @override
  String get workoutTodayTitle => 'आज का कार्यक्रम';

  @override
  String workoutTodaySubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मुख्य व्यायाम',
      one: '1 मुख्य व्यायाम',
    );
    return '$_temp0';
  }

  @override
  String workoutPhaseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count व्यायाम',
      one: '1 व्यायाम',
    );
    return '$_temp0';
  }

  @override
  String get workoutExerciseProgress => 'व्यायाम';

  @override
  String get workoutStatSets => 'सेट';

  @override
  String get workoutStatReps => 'रेप्स';

  @override
  String get workoutStatRest => 'विश्राम';

  @override
  String get workoutSetsLabel => 'सेट';

  @override
  String workoutSetNumber(int number) {
    return 'सेट $number';
  }

  @override
  String get workoutPrevious => 'पिछला';

  @override
  String get workoutNext => 'अगला';

  @override
  String get workoutSwapExercise => 'व्यायाम बदलें';

  @override
  String get workoutSwapTitle => 'व्यायाम बदलें';

  @override
  String get workoutSwapSubtitle =>
      'उसी मांसपेशी समूह और आपके ट्रेनिंग वातावरण के लिए विकल्प।';

  @override
  String get workoutSwapEmpty => 'वर्तमान में कोई विकल्प उपलब्ध नहीं है।';

  @override
  String get workoutRestTitle => 'विश्राम';

  @override
  String get workoutRestSkip => 'छोड़ें';

  @override
  String get workoutRestAdd15 => '+15s';

  @override
  String get workoutPausedTitle => 'वर्कआउट रुका हुआ है';

  @override
  String get workoutResume => 'फिर शुरू करें';

  @override
  String get workoutEndWorkout => 'वर्कआउट समाप्त करें';

  @override
  String get workoutRestart => 'वर्कआउट दोबारा शुरू करें';

  @override
  String get workoutEndConfirmTitle => 'वर्कआउट समाप्त करें?';

  @override
  String get workoutEndConfirmBody =>
      'इस सत्र में आपकी प्रगति सहेजी नहीं जाएगी।';

  @override
  String get workoutFeedbackTitle => 'यह वर्कआउट कैसा रहा?';

  @override
  String get workoutFeedbackEasy => 'आसान';

  @override
  String get workoutFeedbackJustRight => 'बिल्कुल सही';

  @override
  String get workoutFeedbackHard => 'कठिन';

  @override
  String get workoutVideoUnavailable => 'वीडियो उपलब्ध नहीं है';

  @override
  String get workoutEmptyProgram => 'आज के लिए कोई व्यायाम निर्धारित नहीं है।';

  @override
  String get walkingTitle => 'वॉक';

  @override
  String get walkingStepsToday => 'कदम आज';

  @override
  String walkingDailyGoal(int steps) {
    return 'लक्ष्य: $steps कदम';
  }

  @override
  String walkingGoalProgress(int percent) {
    return 'आज के लक्ष्य का $percent%';
  }

  @override
  String get walkingWeeklyChartTitle => 'पिछले 7 दिन';

  @override
  String get walkingHealthSourceNote =>
      'कदम इस डिवाइस पर गिने जाते हैं। यदि Health Connect / Apple Health भी उपलब्ध है, तो Vireo अधिक संख्या दिखाता है।';

  @override
  String get walkingPermissionTitle => 'कदम ट्रैकिंग की अनुमति आवश्यक है';

  @override
  String get walkingPermissionBody =>
      'Vireo आपके फ़ोन के मोशन सेंसर से कदम गिनता है। गतिविधि अनुमति दें ताकि चलने के लक्ष्य और कैलोरी सटीक रहें।';

  @override
  String get walkingOpenSettings => 'सेटिंग्स खोलें';

  @override
  String get walkingTryAgain => 'पुनः प्रयास करें';

  @override
  String get walkingUnavailableTitle => 'वॉकिंग ट्रैकर अनुपलब्ध है';

  @override
  String get walkingUnavailableBody =>
      'स्टेप ट्रैकिंग स्टेप काउंटर सेंसर वाले फिजिकल iOS या Android फ़ोन पर सबसे अच्छा काम करती है।';

  @override
  String get walkingEnableTitle => 'इस फ़ोन पर कदम गिनें';

  @override
  String get walkingEnableBody =>
      'Vireo रीयल-टाइम में चलने को ट्रैक करने के लिए आपके फ़ोन के स्टेप सेंसर का उपयोग करता है — दूरी, कैलोरी और आपका दैनिक लक्ष्य। हम इसके बाद गतिविधि अनुमति मांगेंगे।';

  @override
  String get walkingEnableCta => 'स्टेप काउंटिंग सक्षम करें';

  @override
  String get walkingActiveMinutes => 'सक्रिय समय';

  @override
  String get nutritionTabBreakfast => 'नाश्ता';

  @override
  String get nutritionTabLunch => 'दोपहर का भोजन';

  @override
  String get nutritionTabDinner => 'रात का भोजन';

  @override
  String get nutritionTabSnack => 'स्नैक';

  @override
  String get nutritionNoMealPlanned => 'आज के लिए कोई भोजन निर्धारित नहीं है।';

  @override
  String nutritionPrepMinutes(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String get nutritionTagHighProtein => 'हाई प्रोटीन';

  @override
  String get nutritionTagQuickEasy => 'झटपट और आसान';

  @override
  String get nutritionTagLightEnergy => 'हल्की ऊर्जा';

  @override
  String get nutritionScanFridge => 'अपने फ्रिज को स्कैन करें';

  @override
  String nutritionScansRemaining(int count) {
    return 'इस महीने $count फ्रिज स्कैन शेष हैं';
  }

  @override
  String get nutritionScanPrompt =>
      'सामग्रियों की पहचान करने के लिए अपने फ्रिज या पैंट्री की तस्वीर लें।';

  @override
  String get nutritionTakePhoto => 'फ़ोटो लें';

  @override
  String get nutritionChoosePhoto => 'गैलरी से चुनें';

  @override
  String get nutritionScanning => 'सामग्रियों को स्कैन किया जा रहा है…';

  @override
  String get nutritionScanFailed =>
      'स्कैन विफल रहा। पुनः प्रयास करें या सामग्रियां मैन्युअल रूप से दर्ज करें।';

  @override
  String get nutritionScanLimitReached =>
      'मासिक स्कैन सीमा समाप्त हो गई। असीमित स्कैन के लिए अपग्रेड करें।';

  @override
  String get nutritionConfirmIngredients => 'सामग्रियों की पुष्टि करें';

  @override
  String get nutritionIngredientsHint =>
      'कोई भी गलत चीज़ हटाएं और छूटी हुई वस्तुएं जोड़ें।';

  @override
  String get nutritionAddIngredient => 'सामग्री जोड़ें';

  @override
  String get nutritionGetRecipes => 'रेसिपी सुझाव प्राप्त करें';

  @override
  String get nutritionNoIngredients => 'कम से कम एक सामग्री जोड़ें।';

  @override
  String get nutritionRecipeSuggestions => 'रेसिपी सुझाव';

  @override
  String get nutritionRecipeSuggestionsSubtitle =>
      'आपकी सामग्रियों, लक्ष्य और खान-पान प्राथमिकताओं के आधार पर।';

  @override
  String get nutritionNoRecipesFound => 'कोई मेल खाती रेसिपी नहीं मिली।';

  @override
  String get nutritionManualEntry => 'मैन्युअल रूप से दर्ज करें';

  @override
  String get nutritionManualEntryHint =>
      'जो कुछ आपके पास उपलब्ध है उसे टाइप करें — हम आपके लक्ष्य और प्राथमिकताओं के अनुसार रेसिपी सुझाएंगे।';

  @override
  String get nutritionSwapMeal => 'भोजन बदलें';

  @override
  String get nutritionSwapMealSubtitle =>
      'एक अलग रेसिपी चुनें — 14 दिनों तक दोहराव नहीं।';

  @override
  String get nutritionSwapMealEmpty =>
      'वर्तमान में कोई वैकल्पिक भोजन उपलब्ध नहीं है।';

  @override
  String get nutritionDemoQuickMeals => 'झटपट स्वस्थ डेमो भोजन';

  @override
  String get nutritionTryDemoScan => 'डेमो स्कैन आज़माएं';

  @override
  String get homeWelcomeSubtitle => 'आपका व्यक्तिगत फिटनेस हब।';

  @override
  String get homeWalkingCardSubtitle =>
      'Apple Health या Health Connect से दैनिक कदम ट्रैक करें।';

  @override
  String get homeDailyProgramTitle => 'दैनिक कार्यक्रम';

  @override
  String get homeTodayWorkout => 'आज का वर्कआउट';

  @override
  String get homeNextMeal => 'अगला भोजन';

  @override
  String homeWorkoutExerciseCount(int count) {
    return '$count व्यायाम';
  }

  @override
  String get progressTabWeight => 'वज़न';

  @override
  String get progressTabAdherence => 'निरंतरता';

  @override
  String get progressTabEnergy => 'ऊर्जा';

  @override
  String get progressWeightChartTitle => 'वज़न का रुझान';

  @override
  String progressWeightGoalLine(String value, String unit) {
    return 'लक्ष्य: $value $unit';
  }

  @override
  String get progressAdherenceChartTitle => 'साप्ताहिक निरंतरता';

  @override
  String get progressAdherenceSubtitle => 'प्रति सप्ताह वर्कआउट पूरा होने का %';

  @override
  String get progressEnergyChartTitle => 'ऊर्जा स्तर';

  @override
  String get progressEnergySubtitle => 'साप्ताहिक चेक-इन ऊर्जा स्कोर (1–10)';

  @override
  String get progressLogWeight => 'वज़न लॉग करें';

  @override
  String progressWeightLabel(String unit) {
    return 'वज़न ($unit)';
  }

  @override
  String get progressLogDate => 'तारीख';

  @override
  String get progressSaveWeight => 'सहेजें';

  @override
  String get reassessmentTitle => 'मासिक चेक-इन';

  @override
  String get reassessmentSubtitle =>
      'अपना वज़न, गतिविधि और ट्रेनिंग सेटअप अपडेट करें ताकि हम आपका कार्यक्रम सटीक रख सकें।';

  @override
  String get reassessmentLater => 'बाद में';

  @override
  String get reassessmentSubmit => 'मेरा प्लान अपडेट करें';

  @override
  String get reassessmentSummaryTitle => 'क्या बदला';

  @override
  String get reassessmentSummarySubtitle => 'आपके पिछले चेक-इन की तुलना में';

  @override
  String reassessmentPhaseUpdated(int phase) {
    return 'प्रोग्राम फेज़ को फेज़ $phase में अपडेट किया गया';
  }

  @override
  String get reassessmentNoPhaseChange =>
      'प्रोग्राम में किसी बदलाव की आवश्यकता नहीं है — ऐसे ही जारी रखें!';

  @override
  String get paywallTitle => 'Vireo Premium';

  @override
  String get paywallHeadline => 'अपनी पूरी क्षमता को अनलॉक करें';

  @override
  String get paywallSubtitle =>
      'प्रीमियम आपको असीमित स्कैन, पूर्ण प्रोग्राम फेज़ और गहन प्रगति इनसाइट्स देता है।';

  @override
  String get paywallBestValue => 'सर्वोत्तम मूल्य';

  @override
  String get paywallPlanMonthly => 'मासिक';

  @override
  String get paywallPlanAnnual => 'वार्षिक';

  @override
  String get paywallPlanLifetime => 'लाइफटाइम';

  @override
  String get paywallFeatureUnlimitedScans => 'असीमित तुरंत प्लेट स्कैन';

  @override
  String get paywallFeatureFullProgram =>
      'पूर्ण प्रोग्राम फेज़ और प्रगतिशील वर्कआउट';

  @override
  String get paywallFeatureCloudSync => 'सभी डिवाइसों पर क्लाउड सिंक';

  @override
  String get paywallFeatureProgressAnalytics => 'उन्नत प्रगति विश्लेषण';

  @override
  String get paywallSubscribe => 'सदस्यता लें';

  @override
  String get paywallRestorePurchases => 'खरीदारी पुनर्स्थापित करें';

  @override
  String get paywallPurchaseSuccess => 'प्रीमियम में आपका स्वागत है!';

  @override
  String get paywallPurchaseError =>
      'खरीदारी विफल रही। कृपया पुनः प्रयास करें।';

  @override
  String get paywallRestoreSuccess => 'खरीदारी सफलतापूर्वक पुनर्स्थापित की गई।';

  @override
  String get paywallRestoreEmpty =>
      'इस खाते के लिए कोई सक्रिय सदस्यता नहीं मिली।';

  @override
  String get paywallRestoreError =>
      'खरीदारी पुनर्स्थापित नहीं की जा सकी। बाद में पुनः प्रयास करें।';

  @override
  String get paywallNotConfigured => 'इस बिल्ड में सदस्यता उपलब्ध नहीं है।';

  @override
  String get paywallSubscriptionExpiredMessage =>
      'आपकी सदस्यता समाप्त हो गई है। प्रीमियम सुविधाएं अनलॉक करने के लिए फिर से सदस्यता लें।';

  @override
  String get trialEndedTitle => 'आपका ट्रायल समाप्त हो गया है';

  @override
  String get trialEndedBody =>
      'Vireo Premium आज़माने के लिए धन्यवाद। असीमित स्कैन, पूर्ण प्रोग्राम फेज़ और क्लाउड सिंक बनाए रखने के लिए सदस्यता लें।';

  @override
  String get trialEndedViewPlans => 'प्लान देखें';

  @override
  String subscriptionTrialDaysRemaining(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'आपके मुफ़्त ट्रायल में $days दिन शेष हैं',
      one: 'आपके मुफ़्त ट्रायल में 1 दिन शेष है',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionExpiredBanner =>
      'सदस्यता समाप्त हो गई — प्रीमियम एक्सेस नवीनीकृत करने के लिए टैप करें';

  @override
  String get subscriptionPremiumActive => 'प्रीमियम सक्रिय';

  @override
  String get subscriptionFreeTier => 'मुफ़्त प्लान';

  @override
  String get subscriptionUpgrade => 'अपग्रेड करें';

  @override
  String get settingsManageSubscription =>
      'प्लान देखें, सदस्यता लें या खरीदारी पुनर्स्थापित करें';

  @override
  String workoutPhaseLockedTitle(int phase) {
    return 'फेज़ $phase लॉक है';
  }

  @override
  String get workoutPhaseLockedBody =>
      'अपना पूरा ट्रेनिंग प्रोग्राम जारी रखने के लिए पुनः सदस्यता लें। बुनियादी ट्रैकिंग मुफ़्त प्लान पर उपलब्ध रहेगी।';

  @override
  String homeGreeting(String name) {
    return 'नमस्ते $name 👋';
  }

  @override
  String homeDayPhase(int day, String phase) {
    return 'दिन $day · $phase फेज़';
  }

  @override
  String get homeGuestBanner =>
      'आप अतिथि मोड में हैं — अपनी प्रगति सहेजने के लिए साइन अप करें';

  @override
  String get homeGuestSignUp => 'साइन अप करें';

  @override
  String get homeGuestCta => 'अभी साइन अप करें — 7 दिनों के लिए मुफ़्त';

  @override
  String homeStreakDays(int days) {
    return '$days दिन की स्ट्रीक';
  }

  @override
  String get homeStartStreak => 'आज ही अपनी स्ट्रीक शुरू करें';

  @override
  String get homeTodayWorkoutTitle => 'आज का वर्कआउट';

  @override
  String get homeStartWorkout => 'वर्कआउट शुरू करें';

  @override
  String get homeRestDay => 'सक्रिय विश्राम दिवस 🧘';

  @override
  String get homeBreakfast => 'नाश्ता';

  @override
  String get homeMealConfirmed => 'पुष्टि की गई ✓';

  @override
  String get homeMealPending => 'लंबित';

  @override
  String homeWalkingSteps(int current, int goal) {
    return '$current / $goal कदम';
  }

  @override
  String homeWeeklyProgress(int completed) {
    return '$completed / 7 दिन पूर्ण';
  }

  @override
  String get homeCheckInBanner => '⏱️ साप्ताहिक चेक-इन तैयार — केवल एक मिनट';

  @override
  String get homeRecoveryScore => 'रिकवरी स्कोर';

  @override
  String get homeRecoveryReady => 'आपका शरीर ट्रेनिंग के लिए तैयार है';

  @override
  String get homeGuestName => 'चैंपियन';

  @override
  String get homePhaseFoundation => 'फाउंडेशन';

  @override
  String get nutritionFilterAll => 'सभी';

  @override
  String get nutritionFilterQuick => 'झटपट';

  @override
  String get nutritionFilterLowCalorie => 'कम कैलोरी';

  @override
  String nutritionMacroSummary(int calories, int protein) {
    return '$calories कैलोरी · ${protein}g प्रोटीन';
  }

  @override
  String get nutritionMacroBar => 'कैलोरी | प्रोटीन | कार्ब्स | फैट';

  @override
  String get nutritionMealConfirmed => 'पुष्टि की गई ✓';

  @override
  String nutritionFridgeBanner(int remaining) {
    return '📷 अपना फ्रिज स्कैन करें — इस महीने $remaining स्कैन शेष हैं';
  }

  @override
  String get nutritionFridgeScanCta => 'स्कैन';

  @override
  String get workoutWarmUpStep1 => 'शोल्डर सर्कल्स — 30 सेकंड';

  @override
  String get workoutWarmUpStep2 => 'एक ही जगह मार्च करें — 60 सेकंड';

  @override
  String get workoutWarmUpStep3 => 'हल्के स्क्वैट्स — 10 रेप्स';

  @override
  String get workoutSkipWarmUp => 'वॉर्म-अप छोड़ें';

  @override
  String get workoutStartMainWorkout => 'मुख्य वर्कआउट शुरू करें';

  @override
  String get workoutWarmUpComplete => 'वॉर्म-अप पूरा — तैयार!';

  @override
  String homeProgramDay(int day, int total) {
    return 'दिन $day / $total';
  }

  @override
  String get homeStartProgram => 'अपना कार्यक्रम शुरू करें';

  @override
  String get nutritionDailyCalorieGoal => 'आपका दैनिक कैलोरी लक्ष्य';

  @override
  String nutritionCalorieTargetSummary(
    int calories,
    int protein,
    int carbs,
    int fat,
  ) {
    return 'लक्ष्य: $calories कैलोरी — ${protein}g प्रोटीन, ${carbs}g कार्ब्स, ${fat}g फैट';
  }

  @override
  String nutritionCalorieProgress(int consumed, int target) {
    return 'आज $consumed / $target कैलोरी';
  }

  @override
  String get nutritionEditCalorieGoal => 'कैलोरी लक्ष्य संपादित करें';

  @override
  String get nutritionCalorieHint => 'दैनिक कैलोरी';

  @override
  String get settingsThemeTitle => 'थीम';

  @override
  String get settingsThemeDark => 'डार्क मोड';

  @override
  String get settingsThemeLight => 'लाइट मोड';

  @override
  String get settingsThemeSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get progressAxisDate => 'तारीख';

  @override
  String get progressAxisWeight => 'वज़न (किग्रा)';

  @override
  String get progressAxisEnergy => 'ऊर्जा (1–10)';

  @override
  String get progressAllChartsTitle => 'आपकी प्रगति का अवलोकन';

  @override
  String get profileGuestAvatar => 'अतिथि';

  @override
  String get profileStatProgramDays => 'प्रोग्राम के दिन';

  @override
  String get profileStatsSection => 'आपके आंकड़े';

  @override
  String get profileGoalWeight => 'लक्ष्य वज़न';

  @override
  String get profileCurrentBmi => 'वर्तमान BMI';

  @override
  String get profileActivityLevel => 'गतिविधि स्तर';

  @override
  String get profileEditProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get profileBmiUnderweight => 'कम वज़न';

  @override
  String get profileBmiHealthy => 'स्वस्थ वज़न';

  @override
  String get profileBmiOverweight => 'अधिक वज़न';

  @override
  String get profileBmiObese => 'मोटापा';

  @override
  String get profileBmiTooltip =>
      'BMI (बॉडी मास इंडेक्स) कद और वज़न के आधार पर शरीर की चर्बी का अनुमान लगाता है। यह एक सामान्य मार्गदर्शिका है — चिकित्सीय निदान नहीं।';

  @override
  String get workoutSplitChestTriceps => 'चेस्ट और ट्राइसेप्स';

  @override
  String get workoutSplitBackBiceps => 'बैक और बाइसेप्स';

  @override
  String get workoutSplitLegs => 'लेग्स';

  @override
  String get workoutSplitCardio => 'कार्डियो';

  @override
  String get workoutSplitShoulders => 'शोल्डर्स';

  @override
  String get workoutSplitFullBody => 'फुल बॉडी';

  @override
  String get workoutSplitRest => 'विश्राम दिवस';

  @override
  String get habitsTitle => 'दैनिक आदतें';

  @override
  String get habitsEmpty =>
      'अभी कोई आदत नहीं है — अपनी पहली आदत जोड़ने के लिए + पर टैप करें';

  @override
  String get habitsAddTitle => 'नई आदत';

  @override
  String get habitsAddHint => 'आदत का नाम';

  @override
  String get habitsAddConfirm => 'जोड़ें';

  @override
  String habitsStreak(int days) {
    return '$days दिन की स्ट्रीक';
  }

  @override
  String get habitsRetry => 'पुनः प्रयास करें';

  @override
  String get habitsErrorTitle => 'आदतें लोड नहीं की जा सकीं';

  @override
  String homeRecoveryExplain(int score) {
    return '$score% का रिकवरी स्कोर नींद की गुणवत्ता, विश्राम के दिनों और मांसपेशियों की थकान का संयोजन है। अधिक स्कोर का अर्थ है कि आपका शरीर कड़ी ट्रेनिंग के लिए तैयार है।';
  }

  @override
  String get homeRecoveryFactorSleep => 'नींद की गुणवत्ता';

  @override
  String get homeRecoveryFactorRest => 'विश्राम के दिन';

  @override
  String get homeRecoveryFactorMuscle => 'मांसपेशियों की थकान';

  @override
  String get homeRecoveryTipSleep => 'आज रात 7–9 घंटे की नींद का लक्ष्य रखें';

  @override
  String get homeRecoveryTipRest =>
      'सप्ताह में कम से कम एक पूरा विश्राम दिवस रखें';

  @override
  String get homeRecoveryTipMuscle =>
      'यदि मांसपेशियों में दर्द अधिक हो तो तीव्रता कम करें';

  @override
  String get homeRecoveryImproveTitle => 'सुधार के उपाय';

  @override
  String get homeRecoveryImproveBody =>
      'नींद को प्राथमिकता दें, पर्याप्त पानी पिएं, और थकान बढ़ने पर कठिन सत्र के स्थान पर मोबिलिटी व्यायाम करें।';

  @override
  String get walkingMetricsTitle => 'आज के वॉकिंग आंकड़े';

  @override
  String get walkingDistance => 'दूरी';

  @override
  String get walkingSpeed => 'गति';

  @override
  String get walkingPace => 'पेस';

  @override
  String get walkingCalories => 'बर्न की गई कैलोरी';

  @override
  String walkingWeightLoss(String kg) {
    return 'अनुमानित फैट बर्न ≈ $kg किग्रा';
  }

  @override
  String walkingCadence(int spm) {
    return 'कैडेंस ≈ $spm कदम/मिनट';
  }

  @override
  String get walkingMetricsEstimatedNote =>
      'Health Connect अनुपलब्ध है — स्टेप काउंट से अनुमानित आंकड़े दिखाए जा रहे हैं।';

  @override
  String get mealBuilderTitle => 'सामग्रियां कस्टमाइज़ करें';

  @override
  String mealBuilderTitleFor(String meal) {
    return '$meal को कस्टमाइज़ करें';
  }

  @override
  String get mealBuilderSubtitle =>
      'प्रोटीन, कुकिंग फैट और अतिरिक्त चीज़ें समायोजित करें — मैक्रोज़ रीयल-टाइम में अपडेट होंगे।';

  @override
  String get mealBuilderEggs => 'अंडे';

  @override
  String mealBuilderEggCount(int count) {
    return '$count अंडे';
  }

  @override
  String mealBuilderPortionCount(int count) {
    return '$count हिस्से';
  }

  @override
  String get mealBuilderProteinLunch => 'प्रोटीन के हिस्से';

  @override
  String get mealBuilderProteinDinner => 'डिनर प्रोटीन';

  @override
  String get mealBuilderProteinSnack => 'स्नैक प्रोटीन';

  @override
  String get mealBuilderFatSource => 'फैट का स्रोत';

  @override
  String get mealBuilderFatButter => 'मक्खन';

  @override
  String get mealBuilderFatGhee => 'घी';

  @override
  String get mealBuilderFatOliveOil => 'जैतून का तेल';

  @override
  String get mealBuilderFatSpray => 'ऑयल स्प्रे';

  @override
  String get mealBuilderAddOns => 'अतिरिक्त सामग्रियां';

  @override
  String get mealBuilderAddonCheese => 'पनीर / चीज़';

  @override
  String get mealBuilderAddonVeggies => 'सब्जियां';

  @override
  String get mealBuilderAddonBread => 'होल ग्रेन ब्रेड';

  @override
  String get mealBuilderAddonRice => 'चावल';

  @override
  String get mealBuilderAddonYogurt => 'दही';

  @override
  String get mealBuilderLiveMacros => 'लाइव मैक्रोज़';

  @override
  String get weeklyCheckInTitle => 'साप्ताहिक चेक-इन';

  @override
  String get weeklyCheckInBanner =>
      'आपके साप्ताहिक मूल्यांकन का समय — वज़न और ऊर्जा अपडेट करें';

  @override
  String get weeklyCheckInSubtitle =>
      'हम अगले सप्ताह के लिए आपके BMR/TDEE और मैक्रोज़ की पुनः गणना करेंगे।';

  @override
  String get weeklyCheckInWeight => 'वर्तमान वज़न';

  @override
  String get weeklyCheckInWaist => 'कमर का माप';

  @override
  String get weeklyCheckInEnergy => 'ऊर्जा स्तर (1–5)';

  @override
  String weeklyCheckInAdherence(int pct) {
    return 'ट्रेनिंग निरंतरता: $pct%';
  }

  @override
  String get weeklyCheckInSubmit => 'मेरे लक्ष्य अपडेट करें';

  @override
  String get weeklyCheckInDoneTitle => 'लक्ष्य अपडेट किए गए';

  @override
  String weeklyCheckInDoneBody(
    int prev,
    int next,
    int protein,
    int carbs,
    int fat,
  ) {
    return 'कैलोरी $prev → $next किलोकैलोरी। मैक्रोज़: ${protein}g प्रोटीन, ${carbs}g कार्ब्स, ${fat}g फैट।';
  }

  @override
  String get settingsAccentTitle => 'एक्सेंट रंग';

  @override
  String get settingsAccentOrange => 'नारंगी';

  @override
  String get settingsAccentEmerald => 'पन्ना हरा';

  @override
  String get settingsAccentBlue => 'समुद्री नीला';

  @override
  String get settingsAccentViolet => 'बैंगनी';

  @override
  String get settingsSkinTitle => 'कलर थीम स्किन';

  @override
  String get settingsSkinStandard => 'मानक';

  @override
  String get settingsSkinStandardDesc => 'क्लासिक Vireo डार्क / लाइट';

  @override
  String get settingsSkinAmoled => 'AMOLED प्योर ब्लैक';

  @override
  String get settingsSkinAmoledDesc =>
      'गोल्ड और सियान एक्सेंट के साथ ट्रू ब्लैक';

  @override
  String get settingsSkinNavy => 'डीप नेवी ब्लू';

  @override
  String get settingsSkinNavyDesc => 'आइस ब्लू और टील के साथ नेवी #0B192C';

  @override
  String get settingsAccentLockedHint =>
      'AMOLED / Navy स्किन सक्रिय होने पर एक्सेंट रंग लॉक रहते हैं।';

  @override
  String get workoutSwapWarmUp => 'वॉर्म-अप व्यायाम बदलें';

  @override
  String get workoutSwapWarmUpTitle => 'वॉर्म-अप का वैकल्पिक व्यायाम चुनें';

  @override
  String get workoutSwapWarmUpSubtitle =>
      'आपके ट्रेनिंग वातावरण के लिए मोबिलिटी और लो-इम्पैक्ट विकल्प।';

  @override
  String get profileBmiExplainShort =>
      'BMI कद के अनुपात में वज़न का आकलन करता है।';

  @override
  String get profileBmiExplainFull =>
      'बॉडी मास इंडेक्स (BMI) कद के अनुपात में वज़न का आकलन करने का एक पैमाना है। यह एक सामान्य स्क्रीनिंग टूल है — कोई चिकित्सीय निदान नहीं।';

  @override
  String get mealBuilderCheeseTitle => 'चीज़ / पनीर';

  @override
  String get mealBuilderCheeseNone => 'चीज़ नहीं';

  @override
  String get mealBuilderCheeseCottage => 'कॉटेज चीज़ (पनीर)';

  @override
  String get mealBuilderCheeseCheddar => 'चेडर';

  @override
  String get mealBuilderCheeseMozzarella => 'मोज़ेरेला';

  @override
  String get mealBuilderCheeseFeta => 'फेटा';

  @override
  String mealBuilderCheeseGrams(int grams) {
    return 'मात्रा: ${grams}g';
  }

  @override
  String get homeRecoveryFormulaExplain =>
      'रिकवरी = विश्राम के दिन (40%) + स्टेप लक्ष्य (30%) + भोजन/वर्कआउट निरंतरता (30%)।';

  @override
  String get homeRecoveryFactorRestDays => 'विश्राम के दिन';

  @override
  String get homeRecoveryFactorSteps => 'स्टेप काउंट लक्ष्य';

  @override
  String get homeRecoveryFactorConsistency => 'भोजन और वर्कआउट निरंतरता';

  @override
  String homeRecoveryRestDetail(int days) {
    return 'इस सप्ताह $days विश्राम दिवस';
  }

  @override
  String homeRecoveryStepsDetail(int current, int goal) {
    return 'आज $current / $goal कदम';
  }

  @override
  String homeRecoveryConsistencyDetail(
    int mealsDone,
    int mealsTotal,
    int wDone,
    int wTotal,
  ) {
    return 'भोजन $mealsDone/$mealsTotal · वर्कआउट $wDone/$wTotal';
  }

  @override
  String get homeRecoveryTipSteps =>
      'इस स्कोर को बढ़ाने के लिए अपने दैनिक स्टेप लक्ष्य को पूरा करें';

  @override
  String get homeRecoveryTipConsistency =>
      'भोजन की पुष्टि करें और निर्धारित वर्कआउट पूरे करें';

  @override
  String homeRecoveryMathLine(int rest, int steps, int consistency, int total) {
    return '$rest + $steps + $consistency = $total%';
  }

  @override
  String get cardioTitle => 'कार्डियो और दैनिक गतिविधि';

  @override
  String get cardioSubtitle =>
      'तेज़ चाल, दौड़ और अन्य गतिविधियां लॉग करें — कैलोरी MET × वज़न × समय से आंकी जाती है।';

  @override
  String get cardioSelectActivity => 'गतिविधि';

  @override
  String cardioDuration(int minutes) {
    return 'अवधि: $minutes मिनट';
  }

  @override
  String cardioEstimatedBurn(int kcal) {
    return 'अनुमानित बर्न: $kcal किलोकैलोरी';
  }

  @override
  String cardioMetHint(String met) {
    return 'MET $met · सूत्र: MET × किग्रा × घंटे';
  }

  @override
  String get cardioLogButton => 'गतिविधि लॉग करें';

  @override
  String get cardioLoggedSnack => 'कार्डियो सत्र लॉग किया गया';

  @override
  String cardioTodayTotal(int kcal) {
    return 'आज बर्न किया: $kcal किलोकैलोरी';
  }

  @override
  String get cardioEmpty =>
      'अभी कोई कार्डियो लॉग नहीं हुआ — ऊपर अपना पहला सत्र जोड़ें।';

  @override
  String cardioLogSubtitle(int minutes, int kcal) {
    return '$minutes मिनट · $kcal किलोकैलोरी';
  }

  @override
  String get cardioLogCta => 'कार्डियो गतिविधि लॉग करें';

  @override
  String get cardioBriskWalking => 'तेज़ चाल (ब्रिस्क वॉक)';

  @override
  String get cardioRunning => 'दौड़ना';

  @override
  String get cardioCycling => 'साइकिल चलाना';

  @override
  String get cardioSwimming => 'तैराकी';

  @override
  String get cardioJumpRope => 'रस्सी कूदना';

  @override
  String get cardioHiit => 'HIIT';

  @override
  String get cardioElliptical => 'एलिप्टिकल';

  @override
  String workoutGoalPlanLabel(String goal) {
    return 'प्लान: $goal';
  }

  @override
  String get aiScanTitle => 'AI मील स्कैनर';

  @override
  String get aiScanPrompt =>
      'अपने भोजन की तस्वीर लें — AI हिस्से के आकार से कैलोरी और मैक्रोज़ का अनुमान लगाता है।';

  @override
  String get aiScanCamera => 'कैमरा';

  @override
  String get aiScanGallery => 'गैलरी';

  @override
  String get aiScanAnalyzing => 'भोजन का विश्लेषण किया जा रहा है…';

  @override
  String get aiScanOffline =>
      'इंटरनेट कनेक्शन नहीं है। अपना नेटवर्क जांचें और पुनः प्रयास करें।';

  @override
  String get aiScanFailed => 'स्कैन विफल रहा। कृपया पुनः प्रयास करें।';

  @override
  String get aiScanParseError =>
      'विश्लेषण पढ़ा नहीं जा सका। दूसरी फ़ोटो आज़माएं या मैन्युअल रूप से दर्ज करें।';

  @override
  String get aiScanConfigError =>
      'AI स्कैनर अभी उपलब्ध नहीं है। कृपया बाद में पुनः प्रयास करें।';

  @override
  String get aiDailyLimitReached =>
      'आप आज की AI सीमा तक पहुँच चुके हैं। उच्च दैनिक सीमा के लिए अपग्रेड करें।';

  @override
  String get aiUpgradeCta => 'अपग्रेड करें';

  @override
  String get aiScanTryAgain => 'पुनः प्रयास करें';

  @override
  String get aiScanManualEntry => 'मैन्युअल प्रविष्टि';

  @override
  String get aiScanCardTitle => 'AI से अपना भोजन स्कैन करें';

  @override
  String get aiScanCardSubtitle =>
      'फ़ोटो लें — तुरंत कैलोरी, मैक्रोज़ और स्मार्ट विकल्प पाएं।';

  @override
  String get aiScanSaveToLog => 'लॉग में सहेजें';

  @override
  String get aiScanSavedSnack => 'भोजन आज के लॉग में सहेजा गया';

  @override
  String get aiScanMacroProtein => 'प्रोटीन';

  @override
  String get aiScanMacroCarbs => 'कार्ब्स';

  @override
  String get aiScanMacroFats => 'फैट्स';

  @override
  String get aiScanSmartSwaps => 'स्मार्ट विकल्प';

  @override
  String aiScanCaloriesChip(int calories) {
    return '$calories किलोकैलोरी';
  }

  @override
  String get aiCoachTitle => 'Vireo AI';

  @override
  String get aiCoachFabLabel => 'Vireo AI';

  @override
  String get aiCoachInputHint =>
      'भोजन, मैक्रोज़ या ट्रेनिंग के बारे में पूछें…';

  @override
  String get aiCoachOfflineBanner =>
      'आप ऑफ़लाइन हैं — कैश्ड संदेश दिखाए जा रहे हैं।';

  @override
  String get aiCoachChipDinner => 'डिनर के लिए भोजन सुझाएं';

  @override
  String get aiCoachChipProtein => 'मैं प्रोटीन कैसे बढ़ाऊं?';

  @override
  String get aiCoachChipDessert => 'स्वस्थ मीठा विकल्प';

  @override
  String waterAddOneGlass(int ml) {
    return '+1 ग्लास ($ml मिली)';
  }

  @override
  String get waterLongPressHint => 'अन्य मात्राओं के लिए देर तक दबाएं';

  @override
  String get waterQuickAmountsTitle => 'त्वरित मात्राएं';

  @override
  String get waterDefaultCupTitle => 'डिफ़ॉल्ट कप का आकार';

  @override
  String get waterCustomMl => 'कस्टम मात्रा';

  @override
  String get waterAddCustom => 'जोड़ें';

  @override
  String get waterTrackerTitle => 'पानी का सेवन';

  @override
  String waterTrackerSummary(double current, double goal, int percent) {
    return '${current}L / ${goal}L — $percent% पूर्ण';
  }

  @override
  String get weeklyDeficitChartTitle => 'साप्ताहिक कैलोरी संतुलन';

  @override
  String get weeklyDeficitSubtitle =>
      'TDEE − भोजन + कार्डियो बर्न (पिछले 7 दिन)';

  @override
  String weeklyDeficitTotal(int kcal) {
    return 'साप्ताहिक शुद्ध संतुलन: $kcal किलोकैलोरी';
  }

  @override
  String get weeklyDeficitEmpty =>
      'अपना साप्ताहिक कैलोरी संतुलन देखने के लिए भोजन या कार्डियो लॉग करें।';

  @override
  String get weeklyDeficitInProgress => 'आज (प्रगति पर)';

  @override
  String get progressTrendEmpty => 'अपना रुझान देखने के लिए 3 दिन लॉग करें';

  @override
  String get adaptiveCalorieCardTitle => 'Adaptive Calorie Target';

  @override
  String get adaptiveCalorieExplainMath => 'Explain the math';

  @override
  String get adaptiveCalorieAccept => 'Accept Change';

  @override
  String get adaptiveCalorieDismiss => 'Not Now';

  @override
  String get weeklyReportTitle => 'Weekly Progress Report';

  @override
  String get weeklyReportSubtitle => 'Friday breakdown & weekly highlights';

  @override
  String get weeklyReportShareCta => 'Share Report';

  @override
  String get progressPhotosTitle => 'Progress Photos';

  @override
  String get photosPrivacyNote =>
      'Your photos are stored locally on this phone only. They never leave your device unless you enable cloud backup.';

  @override
  String get photosCompareSideBySide => 'Side-by-Side Compare';

  @override
  String get photosNeedTwoToCompare =>
      'Take at least 2 photos to compare before & after';

  @override
  String get photoBeforeLabel => 'Before';

  @override
  String get photoAfterLabel => 'After';

  @override
  String get photoMissingFile => 'Image file not found';

  @override
  String get photoSourceCamera => 'Take Photo';

  @override
  String get photoSourceGallery => 'Choose from Gallery';

  @override
  String get bodyCircumferenceTitle => 'Body Circumference';

  @override
  String get achievementsTitle => 'Achievements & Badges';

  @override
  String get achievementsUnlocked => 'Unlocked';

  @override
  String get cookMethodRaw => 'कच्चा';

  @override
  String get cookMethodBoiled => 'उबला हुआ';

  @override
  String get cookMethodGrilled => 'ग्रिल्ड';

  @override
  String get cookMethodFried => 'तला हुआ';

  @override
  String get cookMethodBaked => 'बेक किया हुआ';

  @override
  String get cookMethodSteamed => 'भाप में पकाया (स्टीम्ड)';

  @override
  String get cookMethodOther => 'अन्य';

  @override
  String weeklyDeficitTooltip(int net, int consumed, int burned) {
    return '$net किलोकैलोरी\nइन: $consumed · आउट: $burned';
  }

  @override
  String uxGoodMorning(String name) {
    return 'सुप्रभात, $name';
  }

  @override
  String uxGoodAfternoon(String name) {
    return 'शुभ दोपहर, $name';
  }

  @override
  String uxGoodEvening(String name) {
    return 'शुभ संध्या, $name';
  }

  @override
  String get uxTodayOverline => 'आज';

  @override
  String get uxCaloriesLeft => 'किलोकैलोरी शेष';

  @override
  String get uxCaloriesOver => 'किलोकैलोरी अधिक';

  @override
  String get uxGoal => 'लक्ष्य';

  @override
  String get uxEaten => 'खाया गया';

  @override
  String get uxBurned => 'बर्न किया';

  @override
  String get uxActionScan => 'भोजन स्कैन करें';

  @override
  String get uxActionTrain => 'ट्रेनिंग करें';

  @override
  String get uxActionCoach => 'AI कोच';

  @override
  String get uxSectionTraining => 'आज की ट्रेनिंग';

  @override
  String get uxSectionThisWeek => 'इस सप्ताह';

  @override
  String get uxSectionTodayLog => 'आज का लॉग';

  @override
  String get uxAddMeal => '+ भोजन जोड़ें';

  @override
  String get uxAiScanned => 'AI स्कैन';

  @override
  String get uxMealRemoved => 'भोजन हटाया गया';

  @override
  String get uxLogEmptyTitle => 'अभी कुछ भी लॉग नहीं किया गया';

  @override
  String get uxLogEmptyBody =>
      'अपने भोजन की तस्वीर लें — AI कुछ ही सेकंड में कैलोरी और मैक्रोज़ गिन लेता है।';

  @override
  String get uxRestDayHint =>
      'रिकवरी भी ट्रेनिंग का हिस्सा है। वॉक करें, स्ट्रेच करें और प्रोटीन लक्ष्य पूरा करें।';

  @override
  String uxWorkoutMinutes(int minutes) {
    return '~$minutes मिनट';
  }

  @override
  String get uxWater => 'पानी';

  @override
  String get uxGlassSize => '250 मिली';

  @override
  String uxWaterAdded(String liters) {
    return '+250 मिली · आज $liters L';
  }

  @override
  String get uxWaterGoalDone => 'पानी का लक्ष्य पूरा हुआ 💧 बहुत बढ़िया!';

  @override
  String get uxUndo => 'पूर्ववत करें';

  @override
  String get uxCopied => 'कॉपी किया गया';

  @override
  String get uxSend => 'भेजें';

  @override
  String get uxQuickLogTitle => 'त्वरित लॉग';

  @override
  String get uxQuickLogSubtitle => 'एक टैप में कुछ भी लॉग करें।';

  @override
  String get uxQuickScanTitle => 'AI से भोजन स्कैन करें';

  @override
  String get uxQuickScanSub => 'सेकंडों में कैलोरी और मैक्रोज़';

  @override
  String get uxQuickWater => 'पानी';

  @override
  String get uxQuickWaterSub => '+1 ग्लास · 250 मिली';

  @override
  String get uxQuickWeight => 'वज़न';

  @override
  String get uxQuickWeightSub => 'आज का वज़न दर्ज करें';

  @override
  String get uxQuickCardio => 'कार्डियो';

  @override
  String get uxQuickCardioSub => 'वॉक, रन, साइकिल…';

  @override
  String get uxQuickCoach => 'कोच से पूछें';

  @override
  String get uxQuickCoachSub => 'व्यक्तिगत AI सलाह';

  @override
  String get uxCoachOnline => 'ऑनलाइन · आपके मैक्रोज़ से अवगत';

  @override
  String get uxCoachTyping => 'टाइप कर रहा है…';

  @override
  String get uxCoachNewChat => 'नई चैट';

  @override
  String get uxCoachClearConfirm =>
      'नई बातचीत शुरू करें? वर्तमान संदेश हटा दिए जाएंगे।';

  @override
  String get uxCoachHeroTitle => 'आपका व्यक्तिगत AI कोच';

  @override
  String get uxCoachHeroBody =>
      'भोजन, प्रोटीन, क्रेविंग्स या ट्रेनिंग के बारे में पूछें। प्रत्येक उत्तर आज के आपके आंकड़ों पर आधारित है।';

  @override
  String uxCoachKcalLeft(int kcal) {
    return '$kcal किलोकैलोरी शेष';
  }

  @override
  String uxCoachProteinLeft(int grams) {
    return '${grams}g प्रोटीन शेष';
  }

  @override
  String get uxCoachChipWorkout => 'ट्रेनिंग से पहले मुझे क्या खाना चाहिए?';

  @override
  String get uxProtein => 'प्रोटीन';

  @override
  String get uxCarbs => 'कार्ब्स';

  @override
  String get uxFat => 'फैट';

  @override
  String get aiScanAnalysisTitle => 'AI विश्लेषण';

  @override
  String get diaryAddMeal => 'भोजन जोड़ें';

  @override
  String get diaryAddWorkout => 'वर्कआउट जोड़ें';

  @override
  String get diaryCaloriesIn => 'कैलोरी इन';

  @override
  String get diaryCaloriesOut => 'कैलोरी आउट';

  @override
  String diaryKcal(int kcal) {
    return '$kcal किलोकैलोरी';
  }

  @override
  String diaryLastUpdated(String count) {
    return 'अंतिम अपडेट $count';
  }

  @override
  String diaryMealCalories(int calories) {
    return '$calories किलोकैलोरी';
  }

  @override
  String get diaryNetBalance => 'शुद्ध संतुलन';

  @override
  String get diaryNoEntries => 'इस दिन के लिए कोई प्रविष्टि नहीं';

  @override
  String get diaryProtein => 'प्रोटीन';

  @override
  String diaryProteinProgress(int current, int goal) {
    return '$current / $goal g';
  }

  @override
  String get diarySetGoalsCta => 'लक्ष्य निर्धारित करें';

  @override
  String get diarySetGoalsFirst => 'पहले अपने लक्ष्य निर्धारित करें';

  @override
  String get diaryTimeline => 'टाइमलाइन';

  @override
  String get diaryTitle => 'मेरी डायरी';

  @override
  String get diaryToday => 'आज';

  @override
  String get diaryWater => 'पानी';

  @override
  String diaryWaterAmount(int amount) {
    return '$amount मिली';
  }

  @override
  String diaryWaterProgress(int current, int goal) {
    return '$current / $goal मिली';
  }

  @override
  String diaryWorkoutSubtitle(int minutes, int calories) {
    return '$minutes मिनट · $calories किलोकैलोरी';
  }

  @override
  String get exerciseAdvanced => 'उन्नत';

  @override
  String get exerciseBeginner => 'शुरुआती';

  @override
  String get exerciseComplete => 'सेट पूरा करें';

  @override
  String get exerciseDifficulty => 'कठिनाई';

  @override
  String get exerciseEquipment => 'उपकरण';

  @override
  String get exerciseIntermediate => 'मध्यवर्ती';

  @override
  String get exerciseLoadingDemo => 'व्यायाम डेमो लोड हो रहा है...';

  @override
  String get exerciseMistakes => 'सामान्य गलतियाँ';

  @override
  String get exerciseReps => 'रेप्स';

  @override
  String get exerciseRest => 'विश्राम';

  @override
  String get exerciseSets => 'सेट';

  @override
  String get exerciseSteps => 'चरण';

  @override
  String get exerciseTips => 'प्रो टिप्स';

  @override
  String get exerciseViewBack => 'पीछे';

  @override
  String get exerciseViewFront => 'आगे';

  @override
  String get measurements30Days => '30 दिन';

  @override
  String get measurements3Months => '3 महीने';

  @override
  String get measurements7Days => '7 दिन';

  @override
  String get measurementsAdd => 'माप जोड़ें';

  @override
  String get measurementsAddFirst => 'अपना पहला माप दर्ज करें';

  @override
  String get measurementsAll => 'सभी';

  @override
  String get measurementsArms => 'बांहें';

  @override
  String get measurementsBodyFat => 'शरीर की चर्बी %';

  @override
  String get measurementsChest => 'छाती';

  @override
  String get measurementsDate => 'तारीख';

  @override
  String get measurementsDelete => 'हटाएं';

  @override
  String get measurementsDeleteConfirm => 'क्या यह माप हटाएं?';

  @override
  String get measurementsHistory => 'इतिहास';

  @override
  String measurementsLastUpdated(String date) {
    return 'अपडेट किया गया $date';
  }

  @override
  String get measurementsNeedMoreData =>
      'रुझान देखने के लिए अधिक प्रविष्टियां लॉग करें';

  @override
  String get measurementsNoData => 'अभी कोई माप नहीं है';

  @override
  String get measurementsNotes => 'नोट्स';

  @override
  String get measurementsSave => 'सहेजें';

  @override
  String get measurementsThighs => 'जांघें';

  @override
  String get measurementsTitle => 'शरीर का माप';

  @override
  String get measurementsTrendDeclining => 'ध्यान देने की आवश्यकता';

  @override
  String get measurementsTrendImproving => 'सुधार हो रहा है';

  @override
  String get measurementsTrendStable => 'स्थिर';

  @override
  String get measurementsWaist => 'कमर';

  @override
  String get measurementsWeight => 'वज़न';

  @override
  String get measurementsWeightInvalid => 'एक मान्य वज़न दर्ज करें';

  @override
  String get muscleBack => 'पीठ';

  @override
  String get muscleBiceps => 'बाइसेप्स';

  @override
  String get muscleCalves => 'पिंडलियां (काव्स)';

  @override
  String get muscleChest => 'छाती (चेस्ट)';

  @override
  String get muscleCore => 'कोर';

  @override
  String get muscleForearms => 'फोरआर्म्स';

  @override
  String get muscleGlutes => 'ग्लूट्स';

  @override
  String get muscleHamstrings => 'हैमस्ट्रिंग्स';

  @override
  String get muscleHipFlexors => 'हिप फ्लेक्सर्स';

  @override
  String get muscleQuads => 'क्वाड्स';

  @override
  String get muscleShoulders => 'कंधे (शोल्डर्स)';

  @override
  String get muscleTriceps => 'ट्राइसेप्स';

  @override
  String get notificationsBreakfast => 'नाश्ता रिमाइंडर';

  @override
  String get notificationsDinner => 'रात के भोजन का रिमाइंडर';

  @override
  String get notificationsLunch => 'दोपहर के भोजन का रिमाइंडर';

  @override
  String get notificationsOpenSettings => 'सेटिंग्स खोलें';

  @override
  String get notificationsPermissionBanner =>
      'ट्रैक पर रहने के लिए सूचनाएं (नोटिफिकेशन) सक्षम करें';

  @override
  String get notificationsPreWorkout => 'प्री-वर्कआउट रिमाइंडर';

  @override
  String get notificationsPreWorkoutSubtitle => 'ट्रेनिंग के लिए तैयार हो जाएं';

  @override
  String get notificationsSleep => 'नींद का रिमाइंडर';

  @override
  String get notificationsSleepSubtitle => 'बेहतर रिकवरी के लिए आराम करें';

  @override
  String get notificationsTest => 'परीक्षण सूचना भेजें';

  @override
  String get notificationsTestBody => 'Vireo रिमाइंडर ठीक से काम कर रहे हैं';

  @override
  String get notificationsTitle => 'सूचनाएं (नोटिफिकेशन)';

  @override
  String get notificationsWater => 'पानी का रिमाइंडर';

  @override
  String get notificationsWaterSubtitle => 'दिन भर हाइड्रेटेड रहें';

  @override
  String get notificationsWeeklyReport => 'साप्ताहिक रिपोर्ट';

  @override
  String get notificationsWeeklyReportSubtitle =>
      'देखें कि आपका सप्ताह कैसा रहा';

  @override
  String get notificationsFastingOpen => 'Fasting window opens';

  @override
  String get notificationsFastingOpenSubtitle =>
      'Time to start your eating window';

  @override
  String get notificationsFastingClose => 'Fasting window closes';

  @override
  String get notificationsFastingCloseSubtitle =>
      'Time to wind down meals and hydrate';

  @override
  String get notificationsStepsNudge => 'Steps nudge';

  @override
  String get notificationsStepsNudgeSubtitle =>
      'Nudge at 18:00 if under 50% of your goal';

  @override
  String get notificationsStreakProtection => 'Streak protection';

  @override
  String get notificationsStreakProtectionSubtitle =>
      'Gentle nudge at 21:00 if nothing logged today';

  @override
  String get notificationsQuietHoursTitle => 'Quiet hours';

  @override
  String notificationsQuietHoursSubtitle(String start, String end) {
    return '$start to $end — no notifications will sound';
  }

  @override
  String get notificationsMaxDailyTitle => 'Daily notification limit';

  @override
  String notificationsMaxDailySubtitle(int count) {
    return 'Up to $count notifications per day';
  }

  @override
  String get notificationsPermissionDialogTitle =>
      'Stay in your flow with reminders';

  @override
  String get notificationsPermissionDialogBody =>
      'Vireo sends gentle, supportive nudges for hydration, workouts, and meals. We respect your quiet hours and never spam you.';

  @override
  String get notificationsPermissionAllow => 'Allow reminders';

  @override
  String get notificationsPermissionNotNow => 'Not now';

  @override
  String get vitality12WeekProgram => '12-सप्ताह का कार्यक्रम';

  @override
  String vitalityArticleCount(int count) {
    return '$count लेख';
  }

  @override
  String get vitalityArticleDisclaimer =>
      'केवल शैक्षिक उद्देश्य के लिए। व्यक्तिगत सलाह के लिए पेशेवर से परामर्श लें।';

  @override
  String get vitalityArticlesSection => 'लेख';

  @override
  String get vitalityBadgesTitle => 'बैज';

  @override
  String vitalityBreathingCount(int count) {
    return '$count सत्र';
  }

  @override
  String get vitalityBreathingLog => 'श्वास (ब्रीदिंग)';

  @override
  String get vitalityCategoryAdvanced => 'उन्नत';

  @override
  String get vitalityCategoryEnvironmental => 'वातावरण';

  @override
  String get vitalityCategoryLifestyle => 'जीवनशैली';

  @override
  String get vitalityCategoryNutrition => 'पोषण';

  @override
  String get vitalityCategoryTraining => 'ट्रेनिंग';

  @override
  String get vitalityCheckProtein => 'प्रोटीन लक्ष्य पूरा करें';

  @override
  String get vitalityCheckSleep => 'गुणवत्तापूर्ण नींद';

  @override
  String get vitalityCheckSunlight => 'सुबह की धूप';

  @override
  String get vitalityCheckWorkout => 'गतिविधि / ट्रेनिंग';

  @override
  String get vitalityCheckZincVitD => 'जिंक / विटामिन D';

  @override
  String vitalityDailyChecklistProgress(int done, int total) {
    return '$done/$total पूर्ण';
  }

  @override
  String get vitalityDailyChecklistTitle => 'आज की चेकलिस्ट';

  @override
  String get vitalityDailyTipLabel => 'दैनिक सुझाव';

  @override
  String get vitalityHubSubtitle =>
      'ऊर्जा और रिकवरी के लिए विज्ञान-सम्मत आदतें';

  @override
  String get vitalityHubTitle => 'वाइटैलिटी हब';

  @override
  String get vitalityLegendBadge => 'लीजेंड';

  @override
  String get vitalityLinkCopied => 'लिंक कॉपी किया गया';

  @override
  String get vitalityLogSection => 'लॉग';

  @override
  String get vitalityMarkRead => 'पढ़ा हुआ चिह्नित करें';

  @override
  String get vitalityMarkReadDone => 'पढ़ा गया';

  @override
  String get vitalityMarkReadSuccess => 'पढ़ा हुआ चिह्नित किया गया';

  @override
  String get vitalityMedicalDisclaimer =>
      'केवल शैक्षिक सामग्री — चिकित्सीय सलाह नहीं।';

  @override
  String get vitalityMetricsEmpty => 'अभी कोई मेट्रिक्स नहीं हैं';

  @override
  String get vitalityMetricsLast7Days => 'पिछले 7 दिन';

  @override
  String vitalityMetricsLastEntry(int score) {
    return 'अंतिम प्रविष्टि · ऊर्जा $score/10';
  }

  @override
  String get vitalityMetricsSave => 'मेट्रिक्स सहेजें';

  @override
  String get vitalityMetricsSaved => 'सहेजा गया';

  @override
  String get vitalityMetricsTapToLog => 'लॉग करने के लिए टैप करें';

  @override
  String get vitalityMetricsTitle => 'दैनिक मेट्रिक्स';

  @override
  String get vitalityMorningEnergy => 'सुबह की ऊर्जा';

  @override
  String get vitalityMyProgram => 'मेरा प्रोग्राम';

  @override
  String get vitalityNotLogged => 'लॉग नहीं किया गया';

  @override
  String get vitalityPhaseFoundation => 'फाउंडेशन';

  @override
  String get vitalityPhaseOptimization => 'ऑप्टिमाइज़ेशन';

  @override
  String get vitalityPhasePeak => 'पीक';

  @override
  String get vitalityProgramAllWeeks => 'सभी सप्ताह';

  @override
  String get vitalityProgramComplete => 'प्रोग्राम पूर्ण';

  @override
  String get vitalityProgramContinue => 'जारी रखें';

  @override
  String get vitalityProgramDisclaimer =>
      'शैक्षिक कार्यक्रम — चिकित्सीय उपचार नहीं।';

  @override
  String get vitalityProgramDone => 'पूर्ण';

  @override
  String get vitalityProgramOverallProgress => 'कुल प्रगति';

  @override
  String get vitalityProgramStartCta => 'प्रोग्राम शुरू करें';

  @override
  String get vitalityProgramSubtitle =>
      'बेहतर ऊर्जा, नींद और रिकवरी के लिए 12 सप्ताह';

  @override
  String get vitalityProgramTitle => 'वाइटैलिटी ट्रांसफॉर्मेशन';

  @override
  String get vitalityProtocolBadgeEarned => 'बैज अनलॉक हुआ!';

  @override
  String get vitalityProtocolCompleteDay => 'दिन पूरा करें';

  @override
  String vitalityProtocolStreak(int days) {
    return '$days-दिन की स्ट्रीक';
  }

  @override
  String get vitalityProtocolTitle => 'प्रोटोकॉल';

  @override
  String vitalityReadingTime(int minutes) {
    return '$minutes मिनट का पठन';
  }

  @override
  String get vitalityReportCompletion => 'पूर्णता';

  @override
  String get vitalityReportImproving =>
      'आप सुधार कर रहे हैं — स्ट्रीक जारी रखें।';

  @override
  String get vitalityReportKeepGoing =>
      'छोटे कदम भी मायने रखते हैं। आज कुछ कार्य पूरे करें।';

  @override
  String get vitalityScientificSources => 'स्रोत';

  @override
  String vitalityScoreBreakdown(
    int sleep,
    int workout,
    int protein,
    int stress,
  ) {
    return 'नींद $sleep · ट्रेनिंग $workout · प्रोटीन $protein · तनाव $stress';
  }

  @override
  String get vitalityScoreLabel => 'वाइटैलिटी';

  @override
  String get vitalitySleepHint => 'आपकी नींद कैसी रही?';

  @override
  String vitalitySleepHours(num hours) {
    return '$hours घंटे';
  }

  @override
  String get vitalitySleepLog => 'नींद';

  @override
  String get vitalitySleepQuality => 'गुणवत्ता';

  @override
  String vitalityStreak(int days) {
    return '$days-दिन की स्ट्रीक';
  }

  @override
  String get vitalityStressLevel => 'तनाव';

  @override
  String get vitalityUnlockNextWeek => 'अगला सप्ताह अनलॉक करें';

  @override
  String vitalityWeekProgress(int percent) {
    return '$percent%';
  }

  @override
  String get vitalityWeekReport => 'साप्ताहिक रिपोर्ट';

  @override
  String vitalityWeekX(int week) {
    return 'सप्ताह $week';
  }

  @override
  String vitalityWeekXOf12(int week) {
    return '12 में से सप्ताह $week';
  }

  @override
  String get vitalityWorkoutDone => 'ट्रेनिंग की';

  @override
  String get vitalityWorkoutLog => 'वर्कआउट';

  @override
  String get vitalityWorkoutPending => 'विश्राम / अभी नहीं';

  @override
  String get vitalityWorkoutPerformance => 'प्रदर्शन';

  @override
  String walkingEstimatedMinutes(int minutes) {
    return '~$minutes मिनट';
  }

  @override
  String get walkingHealthBanner => 'इस फ़ोन के पेडोमीटर से लाइव कदम';

  @override
  String get walkingManualStepsLabel => 'आज के कदम';

  @override
  String get walkingUpdateSteps => 'कदम अपडेट करें';

  @override
  String get walkingWebManualBanner => 'वेब पर, कदम मैन्युअल रूप से दर्ज करें';

  @override
  String get vitalityKeyTakeaway => 'मुख्य निष्कर्ष';

  @override
  String get dietMyPlan => 'मेरा डाइट प्लान';

  @override
  String get dietProgramsTitle => 'डाइट प्रोग्राम्स';

  @override
  String get dietQuizTitle => 'डाइट प्लान क्विज़';

  @override
  String get dietQuizContinue => 'मैं समझता/समझती हूँ — जारी रखें';

  @override
  String get dietQuizYes => 'हाँ';

  @override
  String get dietQuizNo => 'नहीं';

  @override
  String dietQuizHealthStep(int current, int total) {
    return '$total में से स्वास्थ्य $current';
  }

  @override
  String dietQuizPrefStep(int current, int total) {
    return '$total में से प्राथमिकताएं $current';
  }

  @override
  String get dietPrefBreadRice => 'क्या आपको रोटी और चावल पसंद हैं?';

  @override
  String get dietPrefSkipBreakfast => 'क्या आप आसानी से नाश्ता छोड़ सकते हैं?';

  @override
  String get dietPrefSimpleRules => 'क्या आप भोजन के सरल नियम पसंद करते हैं?';

  @override
  String get dietPrefEatsOut => 'क्या आप अक्सर बाहर खाना खाते हैं?';

  @override
  String get dietPrefWeights => 'क्या आप नियमित रूप से वेट ट्रेनिंग करते हैं?';

  @override
  String get dietRecommendedBadge => 'आपके लिए अनुशंसित';

  @override
  String get dietActiveBadge => 'सक्रिय';

  @override
  String get dietNeedsDoctor => 'डॉक्टर की अनुमति आवश्यक';

  @override
  String get dietReadWarning => 'चेतावनी पढ़ें';

  @override
  String dietCardMacros(int kcal, int protein) {
    return '$kcal किलोकैलोरी · ${protein}g प्रोटीन';
  }

  @override
  String get dietHowItWorks => 'यह कैसे काम करता है';

  @override
  String get dietYourTargets => 'आपके लक्ष्य';

  @override
  String get dietBestFor => 'इनके लिए सर्वोत्तम';

  @override
  String get dietNotIdealFor => 'इनके लिए उपयुक्त नहीं';

  @override
  String get dietRules => 'नियम';

  @override
  String get dietAllowedFoods => 'अनुमत खाद्य पदार्थ';

  @override
  String get dietLimitFoods => 'इन्हें सीमित करें';

  @override
  String get dietSampleDay => 'उदाहरण दिन';

  @override
  String get dietSideEffects => 'दुष्प्रभाव';

  @override
  String get dietTips => 'सुझाव';

  @override
  String get dietEvidence => 'प्रमाण';

  @override
  String get dietStopSigns => 'रुकने के संकेत';

  @override
  String get dietDisclaimer => 'अस्वीकरण';

  @override
  String get dietStartProgram => 'यह प्रोग्राम शुरू करें';

  @override
  String get dietDoctorGateTitle => 'डॉक्टर की मंज़ूरी आवश्यक';

  @override
  String get dietAckWarning => 'मैंने चेतावनी पढ़ ली है';

  @override
  String get dietMustAckWarning =>
      'कृपया पहले पुष्टि करें कि आपने चेतावनी पढ़ ली है';

  @override
  String get dietStartedToast => 'डाइट प्रोग्राम शुरू हो गया';

  @override
  String get dietClose => 'बंद करें';

  @override
  String dietCarbsMax(int grams) {
    return 'कार्ब्स की सीमा: $grams g';
  }

  @override
  String dietWeeklyLoss(String kg) {
    return 'अनुमानित साप्ताहिक कमी ≈ $kg किग्रा';
  }

  @override
  String get dietChoosePlanCard => 'अपना डाइट प्लान चुनें';

  @override
  String dietFastingLeft(String time) {
    return 'उपवास (फास्टिंग) — $time शेष';
  }

  @override
  String dietEatingWindowLeft(String time) {
    return 'खाने की अवधि — $time में समाप्त';
  }

  @override
  String dietWindowStartsAt(int hour) {
    return 'खाने की अवधि $hour:00 बजे शुरू होती है';
  }

  @override
  String get dietEditWindow => 'शुरुआती समय बदलें';

  @override
  String get dietCarbsLimitLabel => 'कार्ब्स की सीमा';

  @override
  String dietCarbsLimitProgress(int current, int max) {
    return '$current / $max g कार्ब्स';
  }

  @override
  String get todayPlanTitle => 'आज का प्लान';

  @override
  String todayPlanProgressSummary(int percent, int done, int total) {
    return 'आपने अपने दिन का $percent% पूरा कर लिया है · $done/$total कार्य';
  }

  @override
  String get todayPlanNow => 'अब';

  @override
  String get todayPlanPro => 'PRO';

  @override
  String todayPlanWaterReminder(int index, int total) {
    return '$total में से पानी का रिमाइंडर $index';
  }

  @override
  String todayPlanWaterGoalLine(int ml) {
    return 'दैनिक लक्ष्य $ml मिली';
  }

  @override
  String get todayPlanFastingOpen => 'खाने की अवधि शुरू';

  @override
  String todayPlanFastingOpenSubtitle(int hours) {
    return '$hours घंटे की खाने की अवधि शुरू';
  }

  @override
  String get todayPlanFastingClose => 'खाने की अवधि समाप्त';

  @override
  String todayPlanFastingCloseSubtitle(int hours) {
    return '$hours घंटे का उपवास शुरू';
  }

  @override
  String get todayPlanWorkout => 'आज का वर्कआउट';

  @override
  String get todayPlanSteps => 'कदमों का लक्ष्य';

  @override
  String todayPlanStepsProgress(int current, int goal) {
    return '$current / $goal कदम';
  }

  @override
  String get todayPlanVitalitySleepSubtitle =>
      'वाइटैलिटी में 7.5+ घंटे लॉग करें';

  @override
  String get todayPlanVitalityProteinSubtitle =>
      'अपना प्रोटीन लक्ष्य पूरा करें';

  @override
  String get todayPlanVitalitySunSubtitle => 'सुबह की धूप लें';

  @override
  String get todayPlanVitalityStress => 'तनाव रीसेट';

  @override
  String get todayPlanVitalityStressSubtitle => 'श्वास सत्र लॉग करें';

  @override
  String get todayPlanVitalityZincSubtitle => 'आहार से जिंक और विटामिन D';

  @override
  String get todayPlanSleepTarget => 'नींद का लक्ष्य';

  @override
  String get todayPlanSleepTargetSubtitle =>
      'गुणवत्तापूर्ण नींद के लिए आराम करें';

  @override
  String get todayPlanProtocolItem => 'वाइटैलिटी प्रोटोकॉल';

  @override
  String get todayPlanAiSuggestion => 'AI कोच का सुझाव';

  @override
  String get todayPlanAiSuggestionSubtitle => 'आज के लिए व्यक्तिगत सुझाव';

  @override
  String waterGoalBasedOnWeight(int kg) {
    return 'आपके वज़न ($kg किग्रा) के आधार पर';
  }

  @override
  String get authErrorEmailRateLimit =>
      'बहुत अधिक ईमेल, एक घंटे बाद पुनः प्रयास करें';

  @override
  String get profileMyBody => 'मेरा शरीर';

  @override
  String get profileGuestProgressHint => 'अतिथि — प्रगति सहेजी नहीं गई';

  @override
  String get profilePlanPro => 'प्रो';

  @override
  String get profilePlanFree => 'मुफ़्त';

  @override
  String profileMemberSince(String date) {
    return '$date से सदस्य';
  }

  @override
  String get profileSaveProgressCta => 'अपनी प्रगति सहेजें';

  @override
  String get profileMyPlanSection => 'मेरा प्लान';

  @override
  String get profileChangeDietPlan => 'प्लान बदलें';

  @override
  String get profileBodyMetricsSaved => 'बॉडी मेट्रिक्स अपडेट किए गए';

  @override
  String get profileSaveBodyMetrics => 'सहेजें';

  @override
  String get profileEditDisplayName => 'प्रदर्शित नाम';

  @override
  String get profileDisplayNameHint => 'आपका नाम';

  @override
  String get profileFitnessGoal => 'लक्ष्य';

  @override
  String get activityHubTitle => 'गतिविधि और स्वास्थ्य';

  @override
  String get activityHubSubtitle =>
      'GPS वर्कआउट, वियरेबल मेट्रिक्स और गाइडेड ब्रीदिंग — फ़ोन-आधारित, स्मार्टवॉच-सक्षम।';

  @override
  String get activityHealthHomeCardTitle => 'गतिविधि और स्वास्थ्य';

  @override
  String get activityHealthHomeCardSubtitle =>
      'अपनी वॉच कनेक्ट करें या आउटडोर वर्कआउट शुरू करें';

  @override
  String get outdoorWorkoutTitle => 'आउटडोर वर्कआउट';

  @override
  String get outdoorWorkoutSubtitle =>
      'GPS मैप और वॉयस संकेतों के साथ वॉक, रन या साइकिल चलाएं';

  @override
  String get outdoorPickTitle => 'गतिविधि चुनें';

  @override
  String get outdoorPickSubtitle =>
      'GPS ट्रैकिंग केवल आपके सत्र के दौरान चलती है।';

  @override
  String get outdoorTypeWalk => 'वॉक';

  @override
  String get outdoorTypeRun => 'दौड़ना';

  @override
  String get outdoorTypeCycle => 'साइकिल';

  @override
  String get outdoorGo => 'शुरू करें!';

  @override
  String get outdoorLocationDenied =>
      'GPS वर्कआउट के लिए स्थान (लोकेशन) अनुमति आवश्यक है।';

  @override
  String get outdoorDistance => 'दूरी';

  @override
  String get outdoorDuration => 'अवधि';

  @override
  String get outdoorPace => 'पेस';

  @override
  String get outdoorSpeed => 'गति';

  @override
  String outdoorPaceMinKm(int min, int sec) {
    return '$min:$sec / किमी';
  }

  @override
  String outdoorSpeedKmh(String speed) {
    return '$speed किमी/घंटा';
  }

  @override
  String outdoorCalories(int kcal) {
    return '$kcal किलोकैलोरी बर्न की गई';
  }

  @override
  String get outdoorPause => 'रोकें';

  @override
  String get outdoorResume => 'फिर शुरू करें';

  @override
  String get outdoorHoldToStop => 'रोकने के लिए दबाकर रखें';

  @override
  String get outdoorStopTitle => 'वर्कआउट समाप्त करें?';

  @override
  String get outdoorStopBody => 'आपका मार्ग और आंकड़े सहेजे जाएंगे।';

  @override
  String get outdoorStopConfirm => 'समाप्त करें';

  @override
  String get outdoorPaused => 'रुका हुआ';

  @override
  String get outdoorAutoPause => 'निष्क्रिय होने पर स्वतः रोकें';

  @override
  String get outdoorHistoryTitle => 'वर्कआउट इतिहास';

  @override
  String get outdoorHistorySubtitle => 'पिछले GPS सत्र';

  @override
  String get outdoorHistoryEmpty => 'अभी कोई आउटडोर वर्कआउट नहीं हुआ।';

  @override
  String get outdoorDetailTitle => 'वर्कआउट विवरण';

  @override
  String get outdoorSplitsTitle => 'किलोमीटर स्प्लिट्स';

  @override
  String outdoorSplitKm(int km) {
    return 'किमी $km';
  }

  @override
  String get uxQuickOutdoor => 'आउटडोर वर्कआउट';

  @override
  String get uxQuickOutdoorSub => 'GPS वॉक, रन या राइड';

  @override
  String get healthHubTitle => 'स्वास्थ्य';

  @override
  String get healthHubCardSubtitle => 'आपकी वॉच से हृदय गति, नींद, SpO₂';

  @override
  String get healthHubProgressSubtitle => 'वियरेबल मेट्रिक्स और स्लीप स्कोर';

  @override
  String get healthNotMedical =>
      'चिकित्सीय उपयोग के लिए नहीं। मेट्रिक्स Health Connect / Apple Health के माध्यम से आपकी वॉच से आते हैं।';

  @override
  String get healthFromWatch => 'आपकी वॉच से';

  @override
  String get healthConnectWatchTitle => 'अपनी वॉच कनेक्ट करें';

  @override
  String get healthConnectWatchBody =>
      'Health Connect या Apple Health की अनुमति दें ताकि Vireo हृदय गति, नींद, कदम आदि दिखा सके। हम कभी भी फ़ोन से वाइटल्स का अनुमान नहीं लगाते।';

  @override
  String get healthGrantPermission => 'स्वास्थ्य अनुमति दें';

  @override
  String get healthMetricHeartRate => 'हृदय गति';

  @override
  String get healthMetricRestingHr => 'विश्राम हृदय गति (RHR)';

  @override
  String get healthMetricHrv => 'HRV (RMSSD)';

  @override
  String get healthMetricSpO2 => 'रक्त ऑक्सीजन (SpO₂)';

  @override
  String get healthMetricSleep => 'नींद';

  @override
  String get healthMetricWeight => 'वज़न';

  @override
  String get healthMetricWorkout => 'वर्कआउट';

  @override
  String get healthMetricSteps => 'कदम';

  @override
  String get healthManualSleepTitle => 'मैन्युअल स्लीप लॉग';

  @override
  String get healthManualSleepHint =>
      'कोई वियरेबल स्लीप डेटा नहीं — सोने का समय और गुणवत्ता लॉग करने के लिए टैप करें';

  @override
  String healthSleepScore(int score) {
    return 'स्लीप स्कोर $score';
  }

  @override
  String get healthBedtime => 'सोने का समय';

  @override
  String get healthWakeTime => 'जागने का समय';

  @override
  String get healthSleepQuality => 'गुणवत्ता (1–5)';

  @override
  String get healthStressTitle => 'तनाव स्तर (HRV)';

  @override
  String get healthStressLow => 'कम';

  @override
  String get healthStressMedium => 'मध्यम';

  @override
  String get healthStressHigh => 'उच्च';

  @override
  String healthHrvDetail(int today, int baseline) {
    return 'आज $today ms बनाम 14-दिन का बेसलाइन $baseline ms';
  }

  @override
  String get breathingHubTitle => 'श्वास (ब्रीदिंग)';

  @override
  String get breathingHubSubtitle => 'तनाव से रिकवरी के लिए निर्देशित सत्र';

  @override
  String get breathingBoxTitle => 'बॉक्स ब्रीदिंग 4-4-4-4';

  @override
  String get breathingBoxSubtitle => 'समान सांस लें, रोकें, छोड़ें, रोकें';

  @override
  String get breathing478Title => '4-7-8 विश्राम';

  @override
  String get breathing478Subtitle => 'सोने से पहले शांतिदायक पैटर्न';

  @override
  String breathingMinutes(int min) {
    return '$min मिनट';
  }

  @override
  String get breathingSessionTitle => 'ब्रीदिंग सत्र';

  @override
  String get breathingInhale => 'सांस लें';

  @override
  String get breathingHold => 'रोकें';

  @override
  String get breathingExhale => 'सांस छोड़ें';

  @override
  String get breathingRest => 'विश्राम';

  @override
  String get mealReviewTitle => 'भोजन की समीक्षा करें';

  @override
  String get mealReviewAddItem => 'वस्तु जोड़ें';

  @override
  String get mealReviewSlot => 'भोजन';

  @override
  String mealReviewRemaining(int kcal) {
    return 'शेष बजट: $kcal किलोकैलोरी';
  }

  @override
  String get mealReviewEstimated => 'अनुमानित';

  @override
  String get mealReviewCheckAmount => 'मात्रा जांचें';

  @override
  String get mealReviewSearchFood => 'खाद्य पदार्थ खोजें…';

  @override
  String get mealReviewLogByText => 'इसके बजाय टेक्स्ट द्वारा लॉग करें';

  @override
  String get mealLogTextTitle => 'टेक्स्ट द्वारा भोजन लॉग करें';

  @override
  String get mealLogTextHint =>
      'आपने क्या खाया उसका विवरण लिखें — हिंदी या अंग्रेज़ी में।';

  @override
  String get mealLogTextPlaceholder => 'मैंने 2 अंडे, 1 रोटी और एक कप चाय ली';

  @override
  String get mealLogTextAnalyze => 'विश्लेषण करें';

  @override
  String get mealVoiceStart => 'आवाज़';

  @override
  String get mealVoiceListening => 'सुन रहा है…';

  @override
  String get mealVoiceUnavailable => 'इस डिवाइस पर वॉयस इनपुट अनुपलब्ध है';

  @override
  String get mealBarcodeTitle => 'बारकोड स्कैन करें';

  @override
  String get mealBarcodeFailed =>
      'वह बारकोड खोजा नहीं जा सका। पुनः प्रयास करें या टेक्स्ट से लॉग करें।';

  @override
  String get mealScanHintLabel => 'कुछ शब्द जोड़ें (वैकल्पिक)';

  @override
  String get mealScanHintPlaceholder => 'तेल? सॉस? ब्रेड का प्रकार?';

  @override
  String get mealHowCalculated => 'हमने इसकी गणना कैसे की';

  @override
  String get plateSizeAskTitle => 'आपकी थाली का सामान्य आकार क्या है?';

  @override
  String get plateSizeSmall => 'छोटी';

  @override
  String get plateSizeMedium => 'मध्यम';

  @override
  String get plateSizeLarge => 'बड़ी';

  @override
  String get inbodyScanTitle => 'InBody रिपोर्ट स्कैन करें';

  @override
  String get inbodyReviewTitle => 'InBody परिणाम की समीक्षा करें';

  @override
  String get inbodyBodyTitle => 'शरीर की संरचना';

  @override
  String get inbodyAddResult => 'InBody परिणाम जोड़ें';

  @override
  String get inbodyPickPdf => 'PDF चुनें';

  @override
  String get inbodyFrameHint => 'पूरी रिपोर्ट शीट को फ़्रेम के अंदर रखें';

  @override
  String get inbodyAnalyzing => 'आपकी रिपोर्ट पढ़ी जा रही है…';

  @override
  String get inbodyUnreadable =>
      'वह शीट पढ़ी नहीं जा सकी। अधिक स्पष्ट तस्वीर आज़माएं।';

  @override
  String get inbodyScanFailed => 'InBody स्कैन विफल रहा। पुनः प्रयास करें।';

  @override
  String get inbodySaved => 'InBody परिणाम सहेजा गया';

  @override
  String get inbodyMedicalNote =>
      'चिकित्सीय उपयोग के लिए नहीं — केवल फिटनेस ट्रैकिंग के लिए।';

  @override
  String get inbodyTestDate => 'परीक्षण की तारीख';

  @override
  String get inbodyDevice => 'डिवाइस';

  @override
  String get inbodyWeight => 'वज़न (किग्रा)';

  @override
  String get inbodySmm => 'कंकाल की मांसपेशियां (किग्रा)';

  @override
  String get inbodyFatMass => 'फैट मास (किग्रा)';

  @override
  String get inbodyPbf => 'शरीर की चर्बी %';

  @override
  String get inbodyBmi => 'BMI';

  @override
  String get inbodyVisceral => 'विसरल फैट स्तर';

  @override
  String get inbodyBmr => 'BMR (किलोकैलोरी)';

  @override
  String get inbodyScore => 'InBody स्कोर';

  @override
  String get inbodySave => 'परिणाम सहेजें';

  @override
  String get inbodyEmpty =>
      'अभी कोई शारीरिक संरचना रिपोर्ट नहीं है। शुरू करने के लिए InBody शीट स्कैन करें।';

  @override
  String get inbodyLatestTitle => 'नवीनतम रिपोर्ट';

  @override
  String get inbodyCompareTitle => 'दो रिपोर्टों की तुलना करें';

  @override
  String get inbodySyncHealth => 'Health Connect सिंक करें';

  @override
  String get inbodySyncedLabel => 'Health Connect से सिंक किया गया';

  @override
  String inbodySyncResult(int count) {
    return '$count Health Connect रीडिंग आयात की गईं';
  }

  @override
  String inbodyFromDateLabel(String date) {
    return '$date को आपके InBody से';
  }

  @override
  String get uxQuickInbody => 'InBody रिपोर्ट';

  @override
  String get uxQuickInbodySub => 'परिणाम शीट स्कैन करें';

  @override
  String get mealScanHeroTitle => 'अपना भोजन स्कैन करें';

  @override
  String get mealScanHeroSubtitle =>
      'AI खाद्य पदार्थों की पहचान करता है — आप ग्राम की पुष्टि करते हैं';

  @override
  String get mealScanTipAbove => 'ऊपर से फ़ोटो लें';

  @override
  String get mealScanTipWholePlate => 'पूरी थाली दिखाई दे';

  @override
  String get mealScanTipLight => 'अच्छी रोशनी';

  @override
  String get mealScanFlashOn => 'फ़्लैश चालू';

  @override
  String get mealScanFlashOff => 'फ़्लैश बंद';

  @override
  String get uxQuickMealText => 'टेक्स्ट भोजन';

  @override
  String get uxQuickMealTextSub => 'आपने क्या खाया टाइप करें';

  @override
  String get uxQuickBarcode => 'बारकोड';

  @override
  String get uxQuickBarcodeSub => 'Open Food Facts में खोजें';

  @override
  String get mealFavoriteSave => 'पसंदीदा में सहेजें';

  @override
  String get mealFavoriteSaved => 'पसंदीदा में सहेजा गया';

  @override
  String get mealFavoritesTitle => 'पसंदीदा';

  @override
  String get mealRecentTitle => 'हाल के भोजन';

  @override
  String get mealRelog => 'दोबारा लॉग करें';

  @override
  String get appearanceTitle => 'थीम और दिखावट';

  @override
  String get themeModeSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get themeModeLight => 'लाइट मोड';

  @override
  String get themeModeDark => 'डार्क मोड';

  @override
  String get accentThemeTitle => 'एक्सेंट रंग';

  @override
  String get accentEmber => 'अंगार (डिफ़ॉल्ट)';

  @override
  String get accentOcean => 'समुद्र';

  @override
  String get accentForest => 'वन';

  @override
  String get accentRoyal => 'रॉयल';

  @override
  String detectedActivity(String activity) {
    return 'पहचाना गया: $activity';
  }

  @override
  String get manualOverride => 'बदलें (ओवरराइड)';

  @override
  String get mealClarificationTitle => 'त्वरित स्पष्टीकरण';

  @override
  String get celebrationWaterTitle => 'हाइड्रेशन का लक्ष्य पूरा हुआ! 💧';

  @override
  String get celebrationProteinTitle => 'प्रोटीन का लक्ष्य हासिल किया! 💪';

  @override
  String get celebrationStepsTitle => 'कदमों का लक्ष्य पूरा हुआ! 🏃';

  @override
  String get celebrationWorkoutTitle => 'वर्कआउट समाप्त हुआ! 🔥';

  @override
  String fatEquivalentApprox(String amount) {
    return '≈ $amount फैट';
  }

  @override
  String fatEquivalentBurned(String amount) {
    return '≈ $amount फैट बर्न किया';
  }

  @override
  String fatEquivalentTodayDeficit(String amount) {
    return 'आज का डेफिसिट ≈ $amount फैट';
  }

  @override
  String fatEquivalentTodaySurplus(int kcal) {
    return 'सरप्लस +$kcal kcal';
  }

  @override
  String fatEquivalentDietPlanRate(String daily, String weekly) {
    return '≈ $daily फैट/दिन • ≈ $weekly/सप्ताह';
  }

  @override
  String fatEquivalentThisWeek(String amount) {
    return 'इस सप्ताह ≈ $amount फैट';
  }

  @override
  String get fatEquivalentInfoTitle => 'फैट समतुल्य';

  @override
  String get fatEquivalentInfoBody =>
      'पैमाने पर वास्तविक वजन पानी और ग्लाइकोजन से भी बदलता है, इसलिए दैनिक वजन अलग दिख सकता है। यह वसा का ऊर्जा समतुल्य है।';

  @override
  String get fatEquivalentInfoDismiss => 'समझ गया';

  @override
  String get legalTerms => 'शर्तें';

  @override
  String get legalPrivacy => 'गोपनीयता';

  @override
  String get legalMedicalDisclaimer => 'चिकित्सीय अस्वीकरण';

  @override
  String get welcomeTagline =>
      'पुरुषों के लिए विशेष रूप से डिज़ाइन किया गया स्मार्ट पोषण और फ़िटनेस।';

  @override
  String get welcomePillarScannerTitle => 'तुरंत प्लेट स्कैनर';

  @override
  String get welcomePillarScannerDesc =>
      'भोजन की फ़ोटो लें, 2 सेकंड में सटीक कैलोरी और प्रोटीन जानें';

  @override
  String get welcomePillarPlanTitle => 'व्यक्तिगत दैनिक योजना';

  @override
  String get welcomePillarPlanDesc =>
      'आपके शरीर और लक्ष्य के अनुसार वैज्ञानिक लक्ष्य';

  @override
  String get welcomePillarSafetyTitle => 'चिकित्सकीय रूप से सुरक्षित पोषण';

  @override
  String get welcomePillarSafetyDesc =>
      'मार्गदर्शन जो आपके चयापचय और समग्र स्वास्थ्य की रक्षा करता है';

  @override
  String get onboardingGoalTitle => 'आपका प्राथमिक लक्ष्य क्या है?';

  @override
  String get onboardingGoalSubtitle =>
      'जो सबसे महत्वपूर्ण है उसे चुनें। हम उसी के अनुसार आपके दैनिक लक्ष्य बनाएंगे।';

  @override
  String get goalLoseFatTitle => 'चर्बी घटाना';

  @override
  String get goalLoseFatSubtitle =>
      'कमाई हुई मांसपेशियों को बनाए रखते हुए जिद्दी चर्बी जलाएं';

  @override
  String get goalBuildMuscleTitle => 'मांसपेशियां बढ़ाना';

  @override
  String get goalBuildMuscleSubtitle =>
      'अनुकूलित प्रोटीन और प्रगतिशील भार के साथ मांसपेशियों का विकास करें';

  @override
  String get goalMoreEnergyTitle => 'अधिक ऊर्जा';

  @override
  String get goalMoreEnergySubtitle =>
      'दिन के बीच की थकान मिटाएं और रोज़मर्रा की ऊर्जा बढ़ाएं';

  @override
  String get goalAllOfAboveTitle => 'उपरोक्त सभी';

  @override
  String get goalAllOfAboveSubtitle =>
      'शरीर का संपूर्ण पुनर्गठन: चर्बी घटाएं, ताकत पाएं और ऊर्जावान रहें';

  @override
  String get onboardingBodyTitle => 'आपका शारीरिक प्रोफ़ाइल';

  @override
  String get onboardingBodySubtitle =>
      'सटीक माप हमें आपकी कैलोरी बर्न और दैनिक लक्ष्यों की सटीक गणना करने में मदद करते हैं।';

  @override
  String get sexMale => 'पुरुष';

  @override
  String get sexFemale => 'महिला';

  @override
  String get unitMetric => 'मीट्रिक';

  @override
  String get unitImperial => 'इंपीरियल (lb)';

  @override
  String get bodyMetricAge => 'आयु';

  @override
  String bodyMetricYears(int age) {
    return '$age वर्ष';
  }

  @override
  String get selectAgeTitle => 'आयु चुनें';

  @override
  String ageYearsSuffix(int age) {
    return '$age वर्ष';
  }

  @override
  String get bodyMetricHeight => 'लंबाई';

  @override
  String get selectHeightTitle => 'लंबाई चुनें';

  @override
  String get bodyMetricCurrentWeight => 'वर्तमान वजन';

  @override
  String get selectCurrentWeightTitle => 'वर्तमान वजन चुनें';

  @override
  String get bodyMetricTargetWeight => 'लक्ष्य वजन';

  @override
  String get selectTargetWeightTitle => 'लक्ष्य वजन चुनें';

  @override
  String get pickerDone => 'हो गया';

  @override
  String get onboardingActivityTitle => 'गतिविधि और प्रशिक्षण स्थान';

  @override
  String get onboardingActivitySubtitle =>
      'हम दैनिक कैलोरी खर्च की गणना करते हैं और सर्वोत्तम वर्कआउट सुझाते हैं।';

  @override
  String get dailyActivityLevelHeader => 'दैनिक गतिविधि स्तर';

  @override
  String get activitySedentaryTitle => 'कम सक्रिय / डेस्क कार्य';

  @override
  String get activitySedentarySubtitle => 'कम चलना, डेस्क जॉब, 5,000 से कम कदम';

  @override
  String get activityModeratelyActiveTitle => 'मध्यम सक्रिय';

  @override
  String get activityModeratelyActiveSubtitle =>
      'नियमित गतिशीलता, 6,000–10,000 दैनिक कदम';

  @override
  String get activityVeryActiveTitle => 'अत्यधिक सक्रिय / शारीरिक कार्य';

  @override
  String get activityVeryActiveSubtitle => 'लगातार सक्रिय या 12,000+ दैनिक कदम';

  @override
  String get trainingPlaceHeader => 'आप कहाँ कसरत करने की योजना बना रहे हैं?';

  @override
  String get trainingPlaceGymTitle => 'जिम';

  @override
  String get trainingPlaceGymSubtitle =>
      'बारबेल, मशीनों और डम्बल तक पूरी पहुंच';

  @override
  String get trainingPlaceHomeTitle => 'घर पर';

  @override
  String get trainingPlaceHomeSubtitle =>
      'शरीर का भार, रेसिस्टेंस बैंड या हल्के डम्बल';

  @override
  String get trainingPlaceWalkingTitle => 'पैदल चलना';

  @override
  String get trainingPlaceWalkingSubtitle => 'कार्डियो कदम और आउटडोर वॉक';

  @override
  String get onboardingHealthSafetyTitle => 'स्वास्थ्य सुरक्षा जांच';

  @override
  String get onboardingHealthSafetySubtitle =>
      'लागू होने वाली स्थितियाँ चुनें ताकि हमारा इंजन आपकी सुरक्षा कर सके।';

  @override
  String get healthSafetyNoneApply => 'इनमें से कोई भी मुझ पर लागू नहीं होता';

  @override
  String get healthSafetyOrSelect => 'या जो लागू हो उसे चुनें';

  @override
  String get onboardingTryScanTitle => 'तुरंत स्कैनिंग का अनुभव करें';

  @override
  String get onboardingTryScanSubtitle =>
      'देखें कि कैसे Vireo आसानी से भोजन को कैलोरी और पोषक तत्वों में बदलता है।';

  @override
  String get tryScanSamplePlateTitle => 'उच्च प्रोटीन प्लेट का नमूना';

  @override
  String get tryScanSamplePlateDesc => 'ग्रिल्ड चिकन, सफेद चावल और हरा सलाद';

  @override
  String get tryScanAnalyzing => 'प्लेट का विश्लेषण हो रहा है...';

  @override
  String get tryScanSampleCta => 'नमूना प्लेट स्कैन करें (तुरंत)';

  @override
  String get tryScanOrTestLive => 'या लाइव आज़माएं';

  @override
  String get tryScanOwnMealTitle => 'अपना भोजन स्कैन करें';

  @override
  String get tryScanOwnMealDesc => 'अपनी वर्तमान प्लेट की एक लाइव तस्वीर लें';

  @override
  String get onboardingPlanRevealTitle => 'आपकी व्यक्तिगत रूपरेखा';

  @override
  String get onboardingPlanRevealSubtitle =>
      'आपके चयापचय और फिटनेस लक्ष्य के लिए विशेष रूप से तैयार।';

  @override
  String get planRevealStartPlan => 'मेरी योजना शुरू करें';

  @override
  String get planRevealProjectedPace => 'अनुमानित गति';

  @override
  String get planRevealSteadyRecomp => 'शरीर का स्थिर पुनर्गठन';

  @override
  String planRevealFatLossPace(String amount) {
    return '-$amount किग्रा / सप्ताह चर्बी कम';
  }

  @override
  String planRevealLeanMassPace(String amount) {
    return '+$amount किग्रा / सप्ताह मांसपेशियों का विकास';
  }

  @override
  String get planRevealDailyCalories => 'दैनिक कैलोरी लक्ष्य';

  @override
  String get planRevealPersonalizedBadge => 'व्यक्तिगत';

  @override
  String get planRevealKcalPerDay => 'किलोकेलोरी / दिन';

  @override
  String get planRevealDailyProtein => 'दैनिक प्रोटीन';

  @override
  String get planRevealGramPerDay => 'ग्राम / दिन';

  @override
  String get planRevealHydration => 'जलयोजन (पानी)';

  @override
  String get planRevealDailySteps => 'दैनिक कदम';

  @override
  String get planRevealStepsPerDay => 'कदम / दिन';

  @override
  String get planRevealDietProtocol => 'आहार प्रोटोकॉल';

  @override
  String get planRevealOptimalMatch => 'सर्वोत्तम मिलान';

  @override
  String get planRevealBalancedPlanDefault => 'संतुलित घाटा योजना';

  @override
  String get onboardingNotificationsTitle => 'कोई भी लक्ष्य न चूकें';

  @override
  String get onboardingNotificationsSubtitle =>
      'हल्के रिमाइंडर आपके पोषण, पानी और वर्कआउट को ट्रैक पर रखते हैं।';

  @override
  String get notificationsHeroTitle =>
      'जवाबदेही के लिए बनाया गया, स्पैम के लिए नहीं';

  @override
  String get notificationsHeroBody =>
      'रिमाइंडर सक्षम करने वाले उपयोगकर्ताओं के लक्ष्य तक पहुंचने की संभावना 3.4 गुना अधिक होती है।';

  @override
  String get notificationsMealLoggingTitle => 'भोजन ट्रैकिंग';

  @override
  String get notificationsMealLoggingDesc =>
      'दोपहर और रात के खाने पर समय पर रिमाइंडर';

  @override
  String get notificationsWorkoutSessionTitle => 'दैनिक वर्कआउट सत्र';

  @override
  String get notificationsWorkoutSessionDesc =>
      'अपने कसरत कार्यक्रम के प्रति प्रतिबद्ध रहें';

  @override
  String get notificationsWeeklyReviewTitle => 'साप्ताहिक प्रगति समीक्षा';

  @override
  String get notificationsWeeklyReviewDesc => 'साप्ताहिक वजन और समायोजन सारांश';

  @override
  String get notificationsEnableButton => 'रिमाइंडर चालू करें';

  @override
  String get notificationsMaybeLater => 'शायद बाद में';

  @override
  String get onboardingPaywallTitle => 'अपने परिणामों में तेज़ी लाएं';

  @override
  String get onboardingPaywallSubtitle =>
      'असीमित स्कैन, AI वर्कआउट और उन्नत विश्लेषण अनलॉक करें।';

  @override
  String get paywallProBadge => 'VIREO PRO';

  @override
  String get paywallFeatureUnlimitedScansDesc => 'दैनिक सीमा की चिंता किए बिना';

  @override
  String get paywallFeatureSmartSub => 'AI स्मार्ट भोजन प्रतिस्थापन';

  @override
  String get paywallFeatureSmartSubDesc =>
      'स्थानीय व्यंजनों के लिए तुरंत मैक्रो-फ्रेंडली विकल्प';

  @override
  String get paywallFeatureAdaptiveSplits => 'अनुकूलित वर्कआउट कार्यक्रम';

  @override
  String get paywallFeatureAdaptiveSplitsDesc =>
      'जिम या घर के लिए प्रोग्रेसिव ओवरलोड ट्रैकिंग';

  @override
  String get paywallPlanAnnualPrice => '\$4.99 / माह';

  @override
  String get paywallPlanAnnualSubtext => 'वार्षिक बिल (50% बचत)';

  @override
  String get paywallBadgeBestValue => 'सर्वोत्तम मूल्य';

  @override
  String get paywallPlanMonthlyPrice => '\$9.99 / माह';

  @override
  String get paywallPlanMonthlySubtext => 'मासिक बिल';

  @override
  String get paywallStartTrialCta => '7-दिवसीय नि:शुल्क परीक्षण शुरू करें';

  @override
  String get paywallContinueFreeTier => 'मुफ़्त संस्करण के साथ जारी रखें';

  @override
  String get appInitErrorFailed => 'ऐप सेवाएं प्रारंभ करने में विफल।';

  @override
  String get appInitRetry => 'पुनः प्रयास करें';

  @override
  String get privacyExportTitle => 'मेरा डेटा निर्यात करें';

  @override
  String get privacyExportReady =>
      'आपका डेटा पैकेज JSON और CSV प्रारूपों में तैयार है:';

  @override
  String get weeklyProgressShareFailed => 'साझा करने वाली छवि नहीं बनाई जा सकी';

  @override
  String get adaptiveCalorieCurrentTarget => 'वर्तमान लक्ष्य';

  @override
  String get adaptiveCalorieSuggestedTarget => 'सुझाया गया लक्ष्य';

  @override
  String get adaptiveCalorieWindowSpan => 'समय अवधि';

  @override
  String get adaptiveCalorieFoodLogsCount => 'भोजन दर्ज किए गए दिन';

  @override
  String get adaptiveCalorieWeighInsCount => 'वजन मापने की संख्या';

  @override
  String get adaptiveCalorieAverageIntake => 'औसत सेवन';

  @override
  String get adaptiveCalorieTrendWeightChange => 'वजन प्रवृत्ति में बदलाव';

  @override
  String get adaptiveCalorieEstimatedMaintenance => 'अनुमानित मेंटेनेंस';

  @override
  String get adaptiveCalorieWeeklyChangeCap => 'साप्ताहिक बदलाव की सीमा';

  @override
  String get adaptiveCalorieSafetyFloorApplied => 'सुरक्षा न्यूनतम लागू';

  @override
  String get chartSevenDayTrend => '7-दिवसीय रुझान';

  @override
  String get chartThirtyDayTrend => '30-दिवसीय रुझान';

  @override
  String get chartRawDot => 'माप बिंदु';

  @override
  String get chartTrendLine => 'रुझान रेखा';

  @override
  String get chartGoalLine => 'लक्ष्य रेखा';

  @override
  String get scanSourceSheetTitle => 'भोजन लॉग करने का तरीका चुनें';

  @override
  String get scanSourceCamera => 'कैमरे से फोटो लें';

  @override
  String get scanSourceGallery => 'गैलरी से चुनें';

  @override
  String get scanSourceText => 'खाना लिखें';

  @override
  String get scanSourceFridgeTitle => 'फ्रिज या किचन स्कैन करें';

  @override
  String get scanSourceInBodyTitle => 'इनबॉडी रिपोर्ट अपलोड करें';

  @override
  String get todayPlanMorning => 'सुबह';

  @override
  String get todayPlanAfternoon => 'दोपहर';

  @override
  String get todayPlanEvening => 'शाम';

  @override
  String get todayPlanWaterQuickAdd => '+250 मिली';

  @override
  String todayPlanWaterProgress(String current, String goal) {
    return '$current / $goal ली';
  }

  @override
  String get todayPlanSleepLogTitle => 'गुणवत्तापूर्ण नींद लॉग';

  @override
  String todayPlanSleepDuration(String hours) {
    return '$hours घंटे सोए';
  }

  @override
  String get todayPlanSleepLogSave => 'नींद सहेजें';

  @override
  String get todayPlanSleepMarkDone => 'पूर्ण (7+ घंटे नींद)';

  @override
  String get todayPlanSleepQuality => 'नींद की गुणवत्ता';

  @override
  String get todayPlanSupplements => 'दैनिक सप्लीमेंट्स';

  @override
  String get todayPlanBreathingAction => 'श्वास सत्र';

  @override
  String get stepsHeroTitle => 'आज के कदम';

  @override
  String get stepsEnableButton => 'कदम गणना सक्षम करें';

  @override
  String get stepsPermissionTitle => 'सटीक कदम ट्रैकिंग';

  @override
  String get stepsPermissionBody =>
      'Vireo आपकी बैटरी खर्च किए बिना दिन भर सटीक कदम गिनने के लिए आपके डिवाइस के मोशन सेंसर का उपयोग करता है।';

  @override
  String get stepsPermissionGrant => 'अभी सक्षम करें';

  @override
  String get stepsActiveMinutes => 'सक्रिय मिनट';

  @override
  String stepsFatBurned(String grams) {
    return '≈ $gramsग्रा वसा';
  }

  @override
  String stepsKm(String km) {
    return '$km किमी';
  }

  @override
  String get stepsDetailTitle => 'कदम और चलना';

  @override
  String get stepsHourlyTitle => 'प्रति घंटा विवरण';

  @override
  String stepsStreakDays(int days) {
    return '$days-दिनों का स्ट्रीक';
  }

  @override
  String stepsBestDay(String steps) {
    return 'सर्वश्रेष्ठ दिन: $steps कदम';
  }

  @override
  String get stepsWeekTab => 'सप्ताह';

  @override
  String get stepsMonthTab => 'महीना';

  @override
  String get mealReviewItemQty => 'मात्रा';

  @override
  String mealReviewConfidence(int pct) {
    return '$pct% सटीकता';
  }

  @override
  String get mealReviewSourceUsda => 'USDA डेटाबेस';

  @override
  String get mealReviewSourceEgypt => 'मिस्र खाद्य तालिका';

  @override
  String get mealReviewSourceAi => 'AI विज़न अनुमान';

  @override
  String get mealReviewUnitPiece => 'पीस';

  @override
  String get mealReviewUnitHandful => 'मुट्ठी';

  @override
  String get mealReviewUnitGrams => 'ग्रा';

  @override
  String get mealReviewCookingRaw => 'कच्चा';

  @override
  String get mealReviewCookingBoiled => 'उबला हुआ';

  @override
  String get mealReviewCookingGrilled => 'ग्रिल्ड';

  @override
  String get mealReviewCookingFried => 'तला हुआ (+तेल)';

  @override
  String get mealReviewCookingBaked => 'ओवन बेक्ड';

  @override
  String mealReviewCaloriesFormat(int count) {
    return '$count कैलोरी';
  }

  @override
  String mealReviewProteinFormat(int count) {
    return '$countग्रा प्रोटीन';
  }

  @override
  String mealReviewCarbsFormat(int count) {
    return '$countग्रा कार्ब्स';
  }

  @override
  String mealReviewFatFormat(int count) {
    return '$countग्रा फैट';
  }

  @override
  String get cuisineSettingTitle => 'व्यंजन शैली';

  @override
  String get cuisineEgyptian => 'मिस्री';

  @override
  String get cuisineSaudi => 'सऊदी और खाड़ी';

  @override
  String get cuisineLevantine => 'लेवेंटाइन';

  @override
  String get cuisineMoroccan => 'मोरक्कन';

  @override
  String get cuisineTurkish => 'तुर्की';

  @override
  String get cuisineIndian => 'भारतीय और पाकिस्तानी';

  @override
  String get cuisineIndonesian => 'इंडोनेशियाई';

  @override
  String get cuisineWestern => 'पश्चिमी / भूमध्यसागरीय';

  @override
  String dietProgramFitReason(String reason) {
    return 'आपके लक्ष्य के अनुकूल: $reason';
  }

  @override
  String get exerciseMusclesTargeted => 'लक्षित मांसपेशियां';

  @override
  String get exerciseStepsTitle => 'स्टेप-बाय-स्टेप कैसे करें';

  @override
  String get exerciseCommonMistakes => 'सामान्य गलतियां';

  @override
  String get exerciseBreathingCue => 'सांस लेने की तकनीक';

  @override
  String get exerciseEasierVariation => 'आसान विकल्प';

  @override
  String get exerciseHarderVariation => 'कठिन विकल्प';

  @override
  String get exerciseSafetyNote => 'सुरक्षा नोट';

  @override
  String get exerciseWarmUpHeader => 'वार्म-अप मूव्स';

  @override
  String get reassessmentLaterSnooze => 'बाद में (3 दिन बाद याद दिलाएं)';

  @override
  String get measurementsAddEntry => 'नया माप जोड़ें';
}
