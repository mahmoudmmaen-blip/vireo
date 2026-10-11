// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Vireo';

  @override
  String get homeTitle => 'Ana Sayfa';

  @override
  String get onboardingTitle => 'Hoş Geldiniz';

  @override
  String get workoutTitle => 'Antrenman';

  @override
  String get nutritionTitle => 'Beslenme';

  @override
  String get progressTitle => 'İlerleme';

  @override
  String get profileTitle => 'Profil';

  @override
  String get authTitle => 'Giriş Yap';

  @override
  String get languageToggle => 'English';

  @override
  String get setupComplete => 'Vireo hazır';

  @override
  String get continueButton => 'Devam Et';

  @override
  String get skipButton => 'Atla';

  @override
  String get finishButton => 'Bitir';

  @override
  String get yesButton => 'Evet';

  @override
  String get noButton => 'Hayır';

  @override
  String onboardingStepProgress(int current, int total) {
    return 'Adım $current / $total';
  }

  @override
  String get onboardingStep1Title => 'Senin hakkında';

  @override
  String get onboardingStep1Subtitle =>
      'Programını bu temel bilgilere göre kişiselleştireceğiz.';

  @override
  String get onboardingStep2Title => 'Sağlık taraması';

  @override
  String get onboardingStep2Subtitle =>
      'Dürüstçe yanıtla — bu, antrenmanları daha güvenli tutmamıza yardımcı olur.';

  @override
  String get onboardingStep3Title => 'Nerede antrenman yapıyorsun?';

  @override
  String get onboardingStep3Subtitle =>
      'Yalnızca senin ortamına uygun egzersizleri göstereceğiz.';

  @override
  String get onboardingStep4Title => 'Hedefin';

  @override
  String get onboardingStep4Subtitle =>
      'Şu anda senin için en önemli olan nedir?';

  @override
  String get onboardingStep5Title => 'Başlamadan önce';

  @override
  String get onboardingStep5Subtitle =>
      'Devam etmek için lütfen oku ve kabul et.';

  @override
  String get onboardingStep6Title => 'Hedefinde kal';

  @override
  String get onboardingStep6Subtitle =>
      'İsteğe bağlı hatırlatıcılar — bunları daha sonra değiştirebilirsin.';

  @override
  String get unitsMetric => 'kg / cm';

  @override
  String get unitsImperial => 'lb / in';

  @override
  String get onboardingAge => 'Yaş';

  @override
  String get onboardingHeight => 'Boy';

  @override
  String get onboardingWeight => 'Kilo';

  @override
  String get onboardingActivityLevel => 'Aktivite düzeyi';

  @override
  String get onboardingDietaryOptional =>
      'Beslenme kısıtlamaları (isteğe bağlı)';

  @override
  String get activitySedentary => 'Genellikle hareketsiz';

  @override
  String get activityModerate => 'Orta derecede aktif';

  @override
  String get activityVeryActive => 'Çok aktif';

  @override
  String get dietHalal => 'Helal';

  @override
  String get dietVegetarian => 'Vejetaryen';

  @override
  String get dietVegan => 'Vegan';

  @override
  String get dietGlutenFree => 'Glütensiz';

  @override
  String get dietDairyFree => 'Süt ürünü içermeyen';

  @override
  String get dietLowSodium => 'Düşük sodyumlu';

  @override
  String get dietLowCarb => 'Düşük karbonhidratlı';

  @override
  String get dietDiabeticFriendly => 'Diyabete uygun';

  @override
  String get onboardingMedicalFlagNotice =>
      'Yoğunluğu ayarlayacağız ve antrenman sırasında güvenlik hatırlatıcıları göstereceğiz.';

  @override
  String get healthQuestionHeart =>
      'Kalp hastalığı veya kardiyovasküler bir rahatsızlığınız var mı?';

  @override
  String get healthQuestionDiabetes =>
      'Diyabet veya kan şekeri rahatsızlığınız var mı?';

  @override
  String get healthQuestionBloodPressure =>
      'Yüksek veya düşük tansiyonunuz var mı?';

  @override
  String get healthQuestionJoints =>
      'Eklem sakatlığı veya kronik ağrınız var mı?';

  @override
  String get healthQuestionMedications =>
      'Düzenli olarak ilaç kullanıyor musunuz?';

  @override
  String get envHomeNoEquipment => 'Ev — ekipmansız';

  @override
  String get envHomeNoEquipmentDesc => 'Yalnızca vücut ağırlığı egzersizleri';

  @override
  String get envHomeLightEquipment => 'Ev — hafif ekipmanlı';

  @override
  String get envHomeLightEquipmentDesc => 'Direnç bandı, dambıl veya benzeri';

  @override
  String get envGymFull => 'Tam donanımlı salon';

  @override
  String get envGymFullDesc => 'Makineler, halterler, squat rack erişimi';

  @override
  String get envWalkingOnly => 'Yalnızca yürüyüş';

  @override
  String get envWalkingOnlyDesc => 'Adım hedefleri ve hafif mobilite';

  @override
  String get goalWeightLoss => 'Kilo verme';

  @override
  String get goalWeightLossDesc => 'Sürdürülebilir antrenmanla yağ kaybı';

  @override
  String get goalMuscleGain => 'Kas kazanımı';

  @override
  String get goalMuscleGainDesc => 'Güç ve yağsız kas kütlesi odaklı';

  @override
  String get goalGeneralVitality => 'Genel zindelik';

  @override
  String get goalGeneralVitalityDesc =>
      'Enerji, süreklilik ve daha iyi hissetme';

  @override
  String get goalAllOfAbove => 'Hepsi';

  @override
  String get goalAllOfAboveDesc => 'Tüm hedefleri kapsayan dengeli bir plan';

  @override
  String get legalDisclaimerText =>
      'Vireo organizasyonel bir fitness aracıdır ve doğrudan tıbbi tavsiye yerine geçmez. İçerik (antrenmanlar, beslenme planları ve sağlık bilgileri) yalnızca genel rehberlik amaçlıdır.\n\nKalp hastalığı, diyabet, yüksek tansiyon veya mevcut eklem yaralanmaları gibi kronik bir rahatsızlığınız varsa ya da ilaç kullanıyorsanız, herhangi bir egzersiz veya beslenme programına başlamadan önce doktorunuza danışın.\n\nBesin takviyeleri ve hormonla ilgili rehberlik (örneğin testosteron) yalnızca genel eğitim amaçlı bilgilerdir. Tıbbi reçete veya tedavi önerisi değildir.\n\nUygulama içi herhangi bir programa katılarak şartları okuduğumu ve Vireo\'nun tıbbi danışmanlık almadan uygulamanın kullanımından kaynaklanan yaralanma veya sağlık komplikasyonlarından sorumlu olmadığını anladığımı onaylıyorum.';

  @override
  String get legalDisclaimerSection1 =>
      'Vireo organizasyonel bir fitness aracıdır ve doğrudan tıbbi tavsiye yerine geçmez. İçerik (antrenmanlar, beslenme planları ve sağlık bilgileri) yalnızca genel rehberlik amaçlıdır.';

  @override
  String get legalDisclaimerSection2 =>
      'Kalp hastalığı, diyabet, yüksek tansiyon veya mevcut eklem yaralanmaları gibi kronik bir rahatsızlığınız varsa ya da ilaç kullanıyorsanız, herhangi bir egzersiz veya beslenme programına başlamadan önce doktorunuza danışın.';

  @override
  String get legalDisclaimerSection3 =>
      'Besin takviyeleri yalnızca genel bilgilendirme amaçlıdır. Tıbbi reçete veya tedavi önerisi değildir.';

  @override
  String get legalDisclaimerSection4 =>
      'Hormonla ilgili yönlendirmeler (örneğin testosteron) yalnızca genel bilgilendirme amaçlıdır. Tıbbi reçete veya tedavi önerisi değildir.';

  @override
  String get legalDisclaimerSection5 =>
      'Uygulama içi herhangi bir programa katılarak şartları okuduğumu ve Vireo\'nun tıbbi danışmanlık almadan uygulamanın kullanımından kaynaklanan yaralanma veya sağlık komplikasyonlarından sorumlu olmadığını anladığımı onaylıyorum.';

  @override
  String get languageArabic => 'Arapça';

  @override
  String get languageEnglish => 'İngilizce';

  @override
  String get consentCheckboxLabel =>
      'Şartları ve sağlık feragatnamesini okudum ve kabul ediyorum';

  @override
  String get notificationWorkoutTime => 'Tercih edilen antrenman saati';

  @override
  String get notificationWalkingReminder => 'Günlük yürüyüş hatırlatıcısı';

  @override
  String get notificationWeeklyCheckIn => 'Haftalık kontrol hatırlatıcısı';

  @override
  String get notificationNotSet => 'Ayarlanmadı';

  @override
  String get authWelcomeTitle => 'Vireo\'ya Hoş Geldiniz';

  @override
  String get authWelcomeSubtitle =>
      'İlerlemenizi cihazlar arasında eşitlemek için giriş yapın veya misafir olarak cihazınızda devam edin.';

  @override
  String get authSaveProgressTitle => 'İlerlemenizi kaydedin';

  @override
  String get authSaveProgressSubtitle =>
      'Planınızın, taramalarınızın ve sohbetlerinizin tüm cihazlarınızda eşitlenmesi için bir hesap bağlayın.';

  @override
  String get signInWithApple => 'Apple ile Giriş Yap';

  @override
  String get signInWithGoogle => 'Google ile Giriş Yap';

  @override
  String get signInWithEmail => 'E-posta ile Giriş Yap';

  @override
  String get authContinueApple => 'Apple ile Devam Et';

  @override
  String get authContinueGoogle => 'Google ile Devam Et';

  @override
  String get authContinueEmail => 'E-posta ile Devam Et';

  @override
  String get authSignInWithPassword => 'Şifre ile giriş yap';

  @override
  String get authSendCode => 'Kod gönder';

  @override
  String get authVerifyCode => 'Kodu doğrula';

  @override
  String get authResendCode => 'Kodu tekrar gönder';

  @override
  String authResendIn(int seconds) {
    return '$seconds sn içinde tekrar gönder';
  }

  @override
  String authOtpSentTo(String email) {
    return '$email adresine 6 haneli bir kod gönderdik';
  }

  @override
  String get authBack => 'Geri';

  @override
  String get continueAsGuest => 'Misafir Olarak Devam Et';

  @override
  String get authEmail => 'E-posta';

  @override
  String get authPassword => 'Şifre';

  @override
  String get authSignIn => 'Giriş Yap';

  @override
  String get authSignUp => 'Kayıt Ol';

  @override
  String get authHasAccount => 'Zaten bir hesabın var mı?';

  @override
  String get authNoAccount => 'Hesabın yok mu?';

  @override
  String get authSignedIn => 'Giriş yapıldı';

  @override
  String get authErrorGeneric =>
      'Bir şeyler ters gitti. Lütfen tekrar deneyin.';

  @override
  String get authErrorOffline =>
      'İnternet bağlantısı yok. Bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get authErrorWrongCode =>
      'Hatalı kod. Rakamları kontrol edip tekrar deneyin.';

  @override
  String get authErrorTooMany =>
      'Çok fazla deneme yapıldı, lütfen bir dakika sonra tekrar deneyin.';

  @override
  String get authErrorInvalidEmail => 'Geçerli bir e-posta adresi girin.';

  @override
  String get authErrorCancelled => 'Giriş işlemi iptal edildi.';

  @override
  String get signOut => 'Çıkış Yap';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get guestModeTitle => 'Misafir modu';

  @override
  String get guestModeSubtitle =>
      'İlerlemeniz yalnızca bu cihaza kaydedilir. Eşitlemek ve abone olmak için bir hesap oluşturun.';

  @override
  String get profileStatWorkoutsLabel => 'Tamamlanan antrenman';

  @override
  String get profileStatStreakLabel => 'Günlük seri';

  @override
  String get saveProgressToCloud => 'İlerlemeyi buluta kaydet';

  @override
  String get profileCloudSynced => 'İlerleme hesabınızla eşitlendi';

  @override
  String get authGateTitle => 'Hesap oluşturun';

  @override
  String get authGateSaveProgress =>
      'İlerlemenizi buluta kaydetmek ve dilediğiniz cihazdan erişmek için ücretsiz bir hesap oluşturun.';

  @override
  String get authGateSubscribe =>
      'Premium erişiminizin sizinle eşleşmesi için abone olmadan önce bir hesap oluşturun.';

  @override
  String get authGateAiFeatures =>
      'Yapay zeka öğün tarama ve Vireo Koç özelliklerini kullanmak için ücretsiz bir hesap oluşturun. Sohbetleriniz ve taramalarınız hesabınıza güvenle eşitlenir.';

  @override
  String get authGateSignUp => 'Kayıt Ol';

  @override
  String get authGateNotNow => 'Şimdi Değil';

  @override
  String get deleteAccountTitle => 'Hesabı sil';

  @override
  String get deleteAccountWarningTitle => 'Bu işlem geri alınamaz';

  @override
  String get deleteAccountWarningBody =>
      'Tüm profil verileriniz, antrenman kayıtlarınız, beslenme planlarınız ve ilerleme fotoğraflarınız sunucularımızdan kalıcı olarak silinecektir.';

  @override
  String get deleteAccountCancel => 'İptal';

  @override
  String get deleteAccountContinue => 'Devam Et';

  @override
  String get deleteAccountConfirmTitle => 'Silme işlemini onayla';

  @override
  String get deleteAccountConfirmInstructions =>
      'Kalıcı hesap silme işlemini onaylamak için aşağıdaki kelimeyi aynen yazın:';

  @override
  String get deleteConfirmationWord => 'SİL';

  @override
  String get deleteAccountTypeHint => 'SİL yazın';

  @override
  String get deleteAccountConfirmButton => 'Hesabımı kalıcı olarak sil';

  @override
  String get deleteAccountSuccess => 'Hesabınız silindi.';

  @override
  String get workoutMedicalWarning =>
      'İlk kurulumda bir sağlık durumu belirttiniz. Ağrı, baş dönmesi veya nefes darlığı hissederseniz durun. Yoğun egzersiz öncesinde doktorunuza danışın.';

  @override
  String get workoutWarmUpTitle => 'Isınma';

  @override
  String get workoutWarmUpSubtitle =>
      'Ana antrenmandan önce bu mobilite hareketlerini tamamlayın.';

  @override
  String get workoutCoolDownTitle => 'Soğuma';

  @override
  String get workoutCoolDownSubtitle =>
      'Vücudunuzun toparlanmasına yardımcı olacak hafif mobilite hareketleri.';

  @override
  String get workoutActiveTitle => 'Aktif antrenman';

  @override
  String get workoutBeginWorkout => 'Antrenmana başla';

  @override
  String get workoutFinishCoolDown => 'Soğumayı bitir';

  @override
  String get workoutStartButton => 'Bugünün antrenmanına başla';

  @override
  String get workoutTodayTitle => 'Günün programı';

  @override
  String workoutTodaySubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ana egzersiz',
      one: '1 ana egzersiz',
    );
    return '$_temp0';
  }

  @override
  String workoutPhaseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count egzersiz',
      one: '1 egzersiz',
    );
    return '$_temp0';
  }

  @override
  String get workoutExerciseProgress => 'Egzersiz';

  @override
  String get workoutStatSets => 'Set';

  @override
  String get workoutStatReps => 'Tekrar';

  @override
  String get workoutStatRest => 'Dinlenme';

  @override
  String get workoutSetsLabel => 'Setler';

  @override
  String workoutSetNumber(int number) {
    return 'Set $number';
  }

  @override
  String get workoutPrevious => 'Önceki';

  @override
  String get workoutNext => 'Sonraki';

  @override
  String get workoutSwapExercise => 'Egzersizi değiştir';

  @override
  String get workoutSwapTitle => 'Egzersizi değiştir';

  @override
  String get workoutSwapSubtitle =>
      'Aynı kas grubu ve antrenman ortamınız için alternatifler.';

  @override
  String get workoutSwapEmpty => 'Şu anda kullanılabilir alternatif yok.';

  @override
  String get workoutRestTitle => 'Dinlenme';

  @override
  String get workoutRestSkip => 'Atla';

  @override
  String get workoutRestAdd15 => '+15 sn';

  @override
  String get workoutPausedTitle => 'Antrenman duraklatıldı';

  @override
  String get workoutResume => 'Devam Et';

  @override
  String get workoutEndWorkout => 'Antrenmanı sonlandır';

  @override
  String get workoutRestart => 'Antrenmanı yeniden başlat';

  @override
  String get workoutEndConfirmTitle => 'Antrenman sonlandırılsın mı?';

  @override
  String get workoutEndConfirmBody =>
      'Bu oturumdaki ilerlemeniz kaydedilmeyecek.';

  @override
  String get workoutFeedbackTitle => 'Bu antrenman nasıldı?';

  @override
  String get workoutFeedbackEasy => 'Kolay';

  @override
  String get workoutFeedbackJustRight => 'Tam kıvamında';

  @override
  String get workoutFeedbackHard => 'Zor';

  @override
  String get workoutVideoUnavailable => 'Video kullanılamıyor';

  @override
  String get workoutEmptyProgram => 'Bugün için planlanmış egzersiz yok.';

  @override
  String get walkingTitle => 'Yürüyüş';

  @override
  String get walkingStepsToday => 'bugünkü adım';

  @override
  String walkingDailyGoal(int steps) {
    return 'Hedef: $steps adım';
  }

  @override
  String walkingGoalProgress(int percent) {
    return 'Bugünkü hedefin %$percent\'i';
  }

  @override
  String get walkingWeeklyChartTitle => 'Son 7 gün';

  @override
  String get walkingHealthSourceNote =>
      'Adımlar bu cihazda sayılır. Health Connect / Apple Health de mevcutsa Vireo daha yüksek olan sayıyı gösterir.';

  @override
  String get walkingPermissionTitle => 'Adım erişimi gerekiyor';

  @override
  String get walkingPermissionBody =>
      'Vireo adımları telefonunuzun hareket sensörleriyle sayar. Yürüyüş hedeflerinin ve kalorilerin doğru kalması için aktivite erişimine izin verin.';

  @override
  String get walkingOpenSettings => 'Ayarları Aç';

  @override
  String get walkingTryAgain => 'Tekrar dene';

  @override
  String get walkingUnavailableTitle => 'Yürüyüş takibi kullanılamıyor';

  @override
  String get walkingUnavailableBody =>
      'Adım takibi en iyi adım sayar sensörüne sahip fiziksel bir iOS veya Android telefonda çalışır.';

  @override
  String get walkingEnableTitle => 'Bu telefonda adımları say';

  @override
  String get walkingEnableBody =>
      'Vireo, yürüyüşünüzü canlı takip etmek için telefonunuzun adım sensörünü kullanır — mesafe, kalori ve günlük hedefiniz. Bir sonraki adımda aktivite izni isteyeceğiz.';

  @override
  String get walkingEnableCta => 'Adım saymayı etkinleştir';

  @override
  String get walkingActiveMinutes => 'Aktif süre';

  @override
  String get nutritionTabBreakfast => 'Kahvaltı';

  @override
  String get nutritionTabLunch => 'Öğle Yemeği';

  @override
  String get nutritionTabDinner => 'Akşam Yemeği';

  @override
  String get nutritionTabSnack => 'Ara Öğün';

  @override
  String get nutritionNoMealPlanned => 'Bugün için planlanmış öğün yok.';

  @override
  String nutritionPrepMinutes(int minutes) {
    return '$minutes dk';
  }

  @override
  String get nutritionTagHighProtein => 'Yüksek protein';

  @override
  String get nutritionTagQuickEasy => 'Hızlı ve pratik';

  @override
  String get nutritionTagLightEnergy => 'Hafif ve enerjik';

  @override
  String get nutritionScanFridge => 'Buzdolabını tara';

  @override
  String nutritionScansRemaining(int count) {
    return 'Bu ay $count buzdolabı taraması kaldı';
  }

  @override
  String get nutritionScanPrompt =>
      'Malzemeleri tespit etmek için buzdolabının veya kilerinin fotoğrafını çek.';

  @override
  String get nutritionTakePhoto => 'Fotoğraf çek';

  @override
  String get nutritionChoosePhoto => 'Galeriden seç';

  @override
  String get nutritionScanning => 'Malzemeler taranıyor…';

  @override
  String get nutritionScanFailed =>
      'Tarama başarısız oldu. Tekrar deneyin veya malzemeleri manuel girin.';

  @override
  String get nutritionScanLimitReached =>
      'Aylık tarama sınırına ulaşıldı. Sınırsız tarama için yükseltin.';

  @override
  String get nutritionConfirmIngredients => 'Malzemeleri onayla';

  @override
  String get nutritionIngredientsHint =>
      'Yanlış olanları kaldırın ve eksik olanları ekleyin.';

  @override
  String get nutritionAddIngredient => 'Malzeme ekle';

  @override
  String get nutritionGetRecipes => 'Tarif önerileri al';

  @override
  String get nutritionNoIngredients => 'En az bir malzeme ekleyin.';

  @override
  String get nutritionRecipeSuggestions => 'Tarif önerileri';

  @override
  String get nutritionRecipeSuggestionsSubtitle =>
      'Malzemelerinize, hedefinize ve beslenme tercihlerinize göre.';

  @override
  String get nutritionNoRecipesFound => 'Eşleşen tarif bulunamadı.';

  @override
  String get nutritionManualEntry => 'Manuel gir';

  @override
  String get nutritionManualEntryHint =>
      'Elinizdekileri yazın — hedefinize ve beslenme tercihlerinize uygun tarifler önerelim.';

  @override
  String get nutritionSwapMeal => 'Öğünü değiştir';

  @override
  String get nutritionSwapMealSubtitle =>
      'Farklı bir tarif seçin — 14 gün boyunca tekrarlanmaz.';

  @override
  String get nutritionSwapMealEmpty => 'Şu anda alternatif öğün bulunmuyor.';

  @override
  String get nutritionDemoQuickMeals => 'Hızlı ve sağlıklı demo öğünler';

  @override
  String get nutritionTryDemoScan => 'Demo taramayı dene';

  @override
  String get homeWelcomeSubtitle => 'Kişiselleştirilmiş fitness merkeziniz.';

  @override
  String get homeWalkingCardSubtitle =>
      'Apple Health veya Health Connect üzerinden günlük adımları takip edin.';

  @override
  String get homeDailyProgramTitle => 'Günlük program';

  @override
  String get homeTodayWorkout => 'Bugünün antrenmanı';

  @override
  String get homeNextMeal => 'Sonraki öğün';

  @override
  String homeWorkoutExerciseCount(int count) {
    return '$count egzersiz';
  }

  @override
  String get progressTabWeight => 'Kilo';

  @override
  String get progressTabAdherence => 'Bağlılık';

  @override
  String get progressTabEnergy => 'Enerji';

  @override
  String get progressWeightChartTitle => 'Kilo eğilimi';

  @override
  String progressWeightGoalLine(String value, String unit) {
    return 'Hedef: $value $unit';
  }

  @override
  String get progressAdherenceChartTitle => 'Haftalık bağlılık';

  @override
  String get progressAdherenceSubtitle => 'Haftalık antrenman tamamlama %';

  @override
  String get progressEnergyChartTitle => 'Enerji seviyeleri';

  @override
  String get progressEnergySubtitle => 'Haftalık kontrol enerji puanı (1–10)';

  @override
  String get progressLogWeight => 'Kilo kaydet';

  @override
  String progressWeightLabel(String unit) {
    return 'Kilo ($unit)';
  }

  @override
  String get progressLogDate => 'Tarih';

  @override
  String get progressSaveWeight => 'Kaydet';

  @override
  String get reassessmentTitle => 'Aylık kontrol';

  @override
  String get reassessmentSubtitle =>
      'Programınızı doğru tutabilmemiz için kilonuzu, aktivitenizi ve antrenman ortamınızı güncelleyin.';

  @override
  String get reassessmentLater => 'Daha sonra';

  @override
  String get reassessmentSubmit => 'Planımı güncelle';

  @override
  String get reassessmentSummaryTitle => 'Neler değişti';

  @override
  String get reassessmentSummarySubtitle =>
      'Son kontrolünüzle karşılaştırıldığında';

  @override
  String reassessmentPhaseUpdated(int phase) {
    return 'Program evresi Evre $phase olarak güncellendi';
  }

  @override
  String get reassessmentNoPhaseChange =>
      'Program değişikliğine gerek yok — aynen devam!';

  @override
  String get paywallTitle => 'Vireo Premium';

  @override
  String get paywallHeadline => 'Potansiyelini açığa çıkar';

  @override
  String get paywallSubtitle =>
      'Premium; sınırsız tarama, tüm program evreleri ve daha derinlemesine ilerleme analizleri sunar.';

  @override
  String get paywallBestValue => 'En İyi Değer';

  @override
  String get paywallPlanMonthly => 'Aylık';

  @override
  String get paywallPlanAnnual => 'Yıllık';

  @override
  String get paywallPlanLifetime => 'Ömür Boyu';

  @override
  String get paywallFeatureUnlimitedScans => 'Sınırsız buzdolabı taraması';

  @override
  String get paywallFeatureFullProgram =>
      'Tüm program evreleri ve aşamalı antrenmanlar';

  @override
  String get paywallFeatureCloudSync => 'Cihazlar arası bulut senkronizasyonu';

  @override
  String get paywallFeatureProgressAnalytics => 'Gelişmiş ilerleme analizleri';

  @override
  String get paywallSubscribe => 'Abone Ol';

  @override
  String get paywallRestorePurchases => 'Satın alımları geri yükle';

  @override
  String get paywallPurchaseSuccess => 'Premium\'a hoş geldiniz!';

  @override
  String get paywallPurchaseError =>
      'Satın alma başarısız oldu. Lütfen tekrar deneyin.';

  @override
  String get paywallRestoreSuccess => 'Satın alımlar başarıyla geri yüklendi.';

  @override
  String get paywallRestoreEmpty => 'Bu hesap için aktif abonelik bulunamadı.';

  @override
  String get paywallRestoreError =>
      'Satın alımlar geri yüklenemedi. Daha sonra tekrar deneyin.';

  @override
  String get paywallNotConfigured => 'Abonelikler bu sürümde kullanılamıyor.';

  @override
  String get paywallSubscriptionExpiredMessage =>
      'Aboneliğinizin süresi doldu. Premium özellikleri açmak için tekrar abone olun.';

  @override
  String get trialEndedTitle => 'Deneme süreniz sona erdi';

  @override
  String get trialEndedBody =>
      'Vireo Premium\'u denediğiniz için teşekkürler. Sınırsız tarama, tüm program evreleri ve bulut senkronizasyonunu korumak için abone olun.';

  @override
  String get trialEndedViewPlans => 'Planları görüntüle';

  @override
  String subscriptionTrialDaysRemaining(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Ücretsiz denemenizde $days gün kaldı',
      one: 'Ücretsiz denemenizde 1 gün kaldı',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionExpiredBanner =>
      'Abonelik süresi doldu — premium erişimi yenilemek için dokunun';

  @override
  String get subscriptionPremiumActive => 'Premium aktif';

  @override
  String get subscriptionFreeTier => 'Ücretsiz plan';

  @override
  String get subscriptionUpgrade => 'Yükselt';

  @override
  String get settingsManageSubscription =>
      'Planları görüntüle, abone ol veya satın alımları geri yükle';

  @override
  String workoutPhaseLockedTitle(int phase) {
    return 'Evre $phase kilitli';
  }

  @override
  String get workoutPhaseLockedBody =>
      'Tüm antrenman programınıza devam etmek için tekrar abone olun. Temel takip ücretsiz planda kullanılabilir.';

  @override
  String homeGreeting(String name) {
    return 'Merhaba $name 👋';
  }

  @override
  String homeDayPhase(int day, String phase) {
    return 'Gün $day · $phase evresi';
  }

  @override
  String get homeGuestBanner =>
      'Misafir modundasınız — ilerlemenizi kaydetmek için kaydolun';

  @override
  String get homeGuestSignUp => 'Kayıt Ol';

  @override
  String get homeGuestCta => 'Hemen kaydol — 7 gün ücretsiz';

  @override
  String homeStreakDays(int days) {
    return '$days günlük seri';
  }

  @override
  String get homeStartStreak => 'Serine bugün başla';

  @override
  String get homeTodayWorkoutTitle => 'Bugünün antrenmanı';

  @override
  String get homeStartWorkout => 'Antrenmana başla';

  @override
  String get homeRestDay => 'Aktif dinlenme günü 🧘';

  @override
  String get homeBreakfast => 'Kahvaltı';

  @override
  String get homeMealConfirmed => 'Onaylandı ✓';

  @override
  String get homeMealPending => 'Bekliyor';

  @override
  String homeWalkingSteps(int current, int goal) {
    return '$current / $goal adım';
  }

  @override
  String homeWeeklyProgress(int completed) {
    return '$completed / 7 gün tamamlandı';
  }

  @override
  String get homeCheckInBanner =>
      '⏱️ Haftalık kontrol hazır — sadece bir dakika';

  @override
  String get homeRecoveryScore => 'Toparlanma puanı';

  @override
  String get homeRecoveryReady => 'Vücudun antrenmana hazır';

  @override
  String get homeGuestName => 'Şampiyon';

  @override
  String get homePhaseFoundation => 'Temel';

  @override
  String get nutritionFilterAll => 'Tümü';

  @override
  String get nutritionFilterQuick => 'Hızlı';

  @override
  String get nutritionFilterLowCalorie => 'Düşük kalorili';

  @override
  String nutritionMacroSummary(int calories, int protein) {
    return '$calories kcal · ${protein}g protein';
  }

  @override
  String get nutritionMacroBar => 'Kal | Protein | Karb | Yağ';

  @override
  String get nutritionMealConfirmed => 'Onaylandı ✓';

  @override
  String nutritionFridgeBanner(int remaining) {
    return '📷 Buzdolabını tara — bu ay $remaining tarama kaldı';
  }

  @override
  String get nutritionFridgeScanCta => 'Tara';

  @override
  String get workoutWarmUpStep1 => 'Omuz çevirme — 30 saniye';

  @override
  String get workoutWarmUpStep2 => 'Olduğun yerde yürüme — 60 saniye';

  @override
  String get workoutWarmUpStep3 => 'Hafif squat — 10 tekrar';

  @override
  String get workoutSkipWarmUp => 'Isınmayı atla';

  @override
  String get workoutStartMainWorkout => 'Ana antrenmana başla';

  @override
  String get workoutWarmUpComplete => 'Isınma tamamlandı — hazır!';

  @override
  String homeProgramDay(int day, int total) {
    return '$total günün $day. günü';
  }

  @override
  String get homeStartProgram => 'Programına başla';

  @override
  String get nutritionDailyCalorieGoal => 'Günlük kalori hedefin';

  @override
  String nutritionCalorieTargetSummary(
    int calories,
    int protein,
    int carbs,
    int fat,
  ) {
    return 'Hedef: $calories kcal — ${protein}g protein, ${carbs}g karb, ${fat}g yağ';
  }

  @override
  String nutritionCalorieProgress(int consumed, int target) {
    return 'Bugün $consumed / $target kcal';
  }

  @override
  String get nutritionEditCalorieGoal => 'Kalori hedefini düzenle';

  @override
  String get nutritionCalorieHint => 'Günlük kalori';

  @override
  String get settingsThemeTitle => 'Görünüm';

  @override
  String get settingsThemeDark => 'Karanlık mod';

  @override
  String get settingsThemeLight => 'Aydınlık mod';

  @override
  String get settingsThemeSystem => 'Sistem varsayılanı';

  @override
  String get progressAxisDate => 'Tarih';

  @override
  String get progressAxisWeight => 'Kilo (kg)';

  @override
  String get progressAxisEnergy => 'Enerji (1–10)';

  @override
  String get progressAllChartsTitle => 'İlerleme genel bakışı';

  @override
  String get profileGuestAvatar => 'Misafir';

  @override
  String get profileStatProgramDays => 'Program günleri';

  @override
  String get profileStatsSection => 'İstatistikleriniz';

  @override
  String get profileGoalWeight => 'Hedef kilo';

  @override
  String get profileCurrentBmi => 'Mevcut VKİ';

  @override
  String get profileActivityLevel => 'Aktivite düzeyi';

  @override
  String get profileEditProfile => 'Profili düzenle';

  @override
  String get profileBmiUnderweight => 'Zayıf';

  @override
  String get profileBmiHealthy => 'Sağlıklı kilo';

  @override
  String get profileBmiOverweight => 'Fazla kilolu';

  @override
  String get profileBmiObese => 'Obez';

  @override
  String get profileBmiTooltip =>
      'VKİ (Vücut Kitle İndeksi), boy ve kilodan vücut yağını tahmin eder. Genel bir rehberdir — teşhis değildir.';

  @override
  String get workoutSplitChestTriceps => 'Göğüs ve Triceps';

  @override
  String get workoutSplitBackBiceps => 'Sırt ve Biceps';

  @override
  String get workoutSplitLegs => 'Bacak';

  @override
  String get workoutSplitCardio => 'Kardiyo';

  @override
  String get workoutSplitShoulders => 'Omuz';

  @override
  String get workoutSplitFullBody => 'Tüm Vücut';

  @override
  String get workoutSplitRest => 'Dinlenme günü';

  @override
  String get habitsTitle => 'Günlük alışkanlıklar';

  @override
  String get habitsEmpty =>
      'Henüz alışkanlık yok — ilkini eklemek için +\'ya dokunun';

  @override
  String get habitsAddTitle => 'Yeni alışkanlık';

  @override
  String get habitsAddHint => 'Alışkanlık adı';

  @override
  String get habitsAddConfirm => 'Ekle';

  @override
  String habitsStreak(int days) {
    return '$days günlük seri';
  }

  @override
  String get habitsRetry => 'Tekrar dene';

  @override
  String get habitsErrorTitle => 'Alışkanlıklar yüklenemedi';

  @override
  String homeRecoveryExplain(int score) {
    return '%$score toparlanma puanı; uyku kalitesi, dinlenme günleri ve kas yorgunluğunu harmanlar. Yüksek olması vücudunuzun sıkı antrenmana hazır olduğu anlamına gelir.';
  }

  @override
  String get homeRecoveryFactorSleep => 'Uyku kalitesi';

  @override
  String get homeRecoveryFactorRest => 'Dinlenme günleri';

  @override
  String get homeRecoveryFactorMuscle => 'Kas yorgunluğu';

  @override
  String get homeRecoveryTipSleep => 'Bu gece 7–9 saat hedefleyin';

  @override
  String get homeRecoveryTipRest => 'Haftada en az bir tam dinlenme günü tutun';

  @override
  String get homeRecoveryTipMuscle => 'Kas ağrısı yüksekse yoğunluğu azaltın';

  @override
  String get homeRecoveryImproveTitle => 'İyileştirme ipuçları';

  @override
  String get homeRecoveryImproveBody =>
      'Uykuyu önceliklendirin, bol su için ve yorgunluk arttığında ağır antrenman yerine mobiliteyi tercih edin.';

  @override
  String get walkingMetricsTitle => 'Bugünün yürüyüş metrikleri';

  @override
  String get walkingDistance => 'Mesafe';

  @override
  String get walkingSpeed => 'Hız';

  @override
  String get walkingPace => 'Tempo';

  @override
  String get walkingCalories => 'Yakılan kalori';

  @override
  String walkingWeightLoss(String kg) {
    return 'Tahmini yağ yakımı ≈ $kg kg';
  }

  @override
  String walkingCadence(int spm) {
    return 'Kadans ≈ $spm adım/dk';
  }

  @override
  String get walkingMetricsEstimatedNote =>
      'Health Connect kullanılamıyor — adım sayısından tahmin edilen metrikler gösteriliyor.';

  @override
  String get mealBuilderTitle => 'Malzemeleri özelleştir';

  @override
  String mealBuilderTitleFor(String meal) {
    return '$meal özelleştir';
  }

  @override
  String get mealBuilderSubtitle =>
      'Protein, pişirme yağı ve ek malzemeleri ayarlayın — makrolar anında güncellenir.';

  @override
  String get mealBuilderEggs => 'Yumurta';

  @override
  String mealBuilderEggCount(int count) {
    return '$count yumurta';
  }

  @override
  String mealBuilderPortionCount(int count) {
    return '$count porsiyon';
  }

  @override
  String get mealBuilderProteinLunch => 'Protein porsiyonları';

  @override
  String get mealBuilderProteinDinner => 'Akşam yemeği proteini';

  @override
  String get mealBuilderProteinSnack => 'Ara öğün proteini';

  @override
  String get mealBuilderFatSource => 'Yağ kaynağı';

  @override
  String get mealBuilderFatButter => 'Tereyağı';

  @override
  String get mealBuilderFatGhee => 'Sade yağ (Ghee)';

  @override
  String get mealBuilderFatOliveOil => 'Zeytinyağı';

  @override
  String get mealBuilderFatSpray => 'Sprey yağ';

  @override
  String get mealBuilderAddOns => 'Ek malzemeler';

  @override
  String get mealBuilderAddonCheese => 'Peynir';

  @override
  String get mealBuilderAddonVeggies => 'Sebzeler';

  @override
  String get mealBuilderAddonBread => 'Tam tahıllı ekmek';

  @override
  String get mealBuilderAddonRice => 'Pirinç';

  @override
  String get mealBuilderAddonYogurt => 'Yoğurt';

  @override
  String get mealBuilderLiveMacros => 'Canlı makrolar';

  @override
  String get weeklyCheckInTitle => 'Haftalık kontrol';

  @override
  String get weeklyCheckInBanner =>
      'Haftalık değerlendirme zamanı — kilonuzu ve enerjinizi güncelleyin';

  @override
  String get weeklyCheckInSubtitle =>
      'Önümüzdeki hafta için BMR/TDEE ve makrolarınızı yeniden hesaplayacağız.';

  @override
  String get weeklyCheckInWeight => 'Mevcut kilo';

  @override
  String get weeklyCheckInWaist => 'Bel ölçüsü';

  @override
  String get weeklyCheckInEnergy => 'Enerji düzeyi (1–5)';

  @override
  String weeklyCheckInAdherence(int pct) {
    return 'Antrenman bağlılığı: %$pct';
  }

  @override
  String get weeklyCheckInSubmit => 'Hedeflerimi güncelle';

  @override
  String get weeklyCheckInDoneTitle => 'Hedefler güncellendi';

  @override
  String weeklyCheckInDoneBody(
    int prev,
    int next,
    int protein,
    int carbs,
    int fat,
  ) {
    return 'Kalori $prev → $next kcal. Makrolar: ${protein}g protein, ${carbs}g karb, ${fat}g yağ.';
  }

  @override
  String get settingsAccentTitle => 'Vurgu rengi';

  @override
  String get settingsAccentOrange => 'Turuncu';

  @override
  String get settingsAccentEmerald => 'Zümrüt';

  @override
  String get settingsAccentBlue => 'Okyanus';

  @override
  String get settingsAccentViolet => 'Menekşe';

  @override
  String get settingsSkinTitle => 'Renk teması temaları';

  @override
  String get settingsSkinStandard => 'Standart';

  @override
  String get settingsSkinStandardDesc => 'Klasik Vireo koyu / açık';

  @override
  String get settingsSkinAmoled => 'AMOLED Saf Siyah';

  @override
  String get settingsSkinAmoledDesc =>
      'Altın ve camgöbeği vurgulu gerçek siyah';

  @override
  String get settingsSkinNavy => 'Derin Lacivert';

  @override
  String get settingsSkinNavyDesc =>
      'Buz mavisi ve deniz mavisi vurgulu lacivert #0B192C';

  @override
  String get settingsAccentLockedHint =>
      'AMOLED / Lacivert tema etkinken vurgu rengi örnekleri kilitlidir.';

  @override
  String get workoutSwapWarmUp => 'Isınma hareketini değiştir';

  @override
  String get workoutSwapWarmUpTitle => 'Isınma alternatifi seç';

  @override
  String get workoutSwapWarmUpSubtitle =>
      'Antrenman ortamınız için mobilite ve düşük etkili seçenekler.';

  @override
  String get profileBmiExplainShort =>
      'VKİ, kilonun boya göre durumunu değerlendirir.';

  @override
  String get profileBmiExplainFull =>
      'Vücut Kitle İndeksi (VKİ), kilonun boya oranını değerlendiren bir ölçüttür. Genel bir tarama aracıdır — tıbbi tanı değildir.';

  @override
  String get mealBuilderCheeseTitle => 'Peynir';

  @override
  String get mealBuilderCheeseNone => 'Peynir yok';

  @override
  String get mealBuilderCheeseCottage => 'Lor peyniri';

  @override
  String get mealBuilderCheeseCheddar => 'Cheddar';

  @override
  String get mealBuilderCheeseMozzarella => 'Mozzarella';

  @override
  String get mealBuilderCheeseFeta => 'Beyaz peynir';

  @override
  String mealBuilderCheeseGrams(int grams) {
    return 'Miktar: ${grams}g';
  }

  @override
  String get homeRecoveryFormulaExplain =>
      'Toparlanma = Dinlenme günleri (%40) + Adım hedefi (%30) + Öğün/antrenman tutarlılığı (%30).';

  @override
  String get homeRecoveryFactorRestDays => 'Dinlenme günleri';

  @override
  String get homeRecoveryFactorSteps => 'Adım sayısı hedefi';

  @override
  String get homeRecoveryFactorConsistency => 'Öğün ve antrenman tutarlılığı';

  @override
  String homeRecoveryRestDetail(int days) {
    return 'Bu hafta $days dinlenme günü';
  }

  @override
  String homeRecoveryStepsDetail(int current, int goal) {
    return 'Bugün $current / $goal adım';
  }

  @override
  String homeRecoveryConsistencyDetail(
    int mealsDone,
    int mealsTotal,
    int wDone,
    int wTotal,
  ) {
    return 'Öğünler $mealsDone/$mealsTotal · Antrenmanlar $wDone/$wTotal';
  }

  @override
  String get homeRecoveryTipSteps =>
      'Bu sütunu yükseltmek için günlük adım hedefinize ulaşın';

  @override
  String get homeRecoveryTipConsistency =>
      'Öğünleri onaylayın ve planlanan antrenmanları bitirin';

  @override
  String homeRecoveryMathLine(int rest, int steps, int consistency, int total) {
    return '$rest + $steps + $consistency = %$total';
  }

  @override
  String get cardioTitle => 'Kardiyo ve günlük aktivite';

  @override
  String get cardioSubtitle =>
      'Tempolu yürüyüşleri, koşuları ve fazlasını kaydedin — kaloriler MET × kilo × süre ile hesaplanır.';

  @override
  String get cardioSelectActivity => 'Aktivite';

  @override
  String cardioDuration(int minutes) {
    return 'Süre: $minutes dk';
  }

  @override
  String cardioEstimatedBurn(int kcal) {
    return 'Tahmini yakım: $kcal kcal';
  }

  @override
  String cardioMetHint(String met) {
    return 'MET $met · formül: MET × kg × saat';
  }

  @override
  String get cardioLogButton => 'Aktiviteyi kaydet';

  @override
  String get cardioLoggedSnack => 'Kardiyo oturumu kaydedildi';

  @override
  String cardioTodayTotal(int kcal) {
    return 'Bugün yakılan: $kcal kcal';
  }

  @override
  String get cardioEmpty =>
      'Henüz kaydedilmiş kardiyo yok — ilk oturumunuzu yukarıdan ekleyin.';

  @override
  String cardioLogSubtitle(int minutes, int kcal) {
    return '$minutes dk · $kcal kcal';
  }

  @override
  String get cardioLogCta => 'Kardiyo aktivitesi kaydet';

  @override
  String get cardioBriskWalking => 'Tempolu yürüyüş';

  @override
  String get cardioRunning => 'Koşu';

  @override
  String get cardioCycling => 'Bisiklet';

  @override
  String get cardioSwimming => 'Yüzme';

  @override
  String get cardioJumpRope => 'İp atlama';

  @override
  String get cardioHiit => 'HIIT';

  @override
  String get cardioElliptical => 'Eliptik bisiklet';

  @override
  String workoutGoalPlanLabel(String goal) {
    return 'Hedef: $goal';
  }

  @override
  String get aiScanTitle => 'Yapay Zeka Öğün Tarayıcı';

  @override
  String get aiScanPrompt =>
      'Öğününüzün fotoğrafını çekin — Yapay zeka porsiyon boyutundan kalori ve makroları tahmin eder.';

  @override
  String get aiScanCamera => 'Kamera';

  @override
  String get aiScanGallery => 'Galeri';

  @override
  String get aiScanAnalyzing => 'Öğün analiz ediliyor…';

  @override
  String get aiScanOffline =>
      'İnternet bağlantısı yok. Ağınızı kontrol edip tekrar deneyin.';

  @override
  String get aiScanFailed => 'Tarama başarısız oldu. Lütfen tekrar deneyin.';

  @override
  String get aiScanParseError =>
      'Analiz okunamadı. Başka bir fotoğraf deneyin veya manuel girin.';

  @override
  String get aiScanConfigError =>
      'Yapay zeka tarayıcı şu anda kullanılamıyor. Lütfen daha sonra tekrar deneyin.';

  @override
  String get aiDailyLimitReached =>
      'Bugünkü yapay zeka sınırınıza ulaştınız. Daha yüksek günlük limit için yükseltin.';

  @override
  String get aiUpgradeCta => 'Yükselt';

  @override
  String get aiScanTryAgain => 'Tekrar dene';

  @override
  String get aiScanManualEntry => 'Manuel giriş';

  @override
  String get aiScanCardTitle => 'Öğününüzü Yapay Zeka ile tarayın';

  @override
  String get aiScanCardSubtitle =>
      'Fotoğraf çekin — kalori, makrolar ve akıllı alternatifleri anında öğrenin.';

  @override
  String get aiScanSaveToLog => 'Günlüğe kaydet';

  @override
  String get aiScanSavedSnack => 'Öğün bugünkü günlüğe kaydedildi';

  @override
  String get aiScanMacroProtein => 'Protein';

  @override
  String get aiScanMacroCarbs => 'Karbonhidrat';

  @override
  String get aiScanMacroFats => 'Yağ';

  @override
  String get aiScanSmartSwaps => 'Akıllı alternatifler';

  @override
  String aiScanCaloriesChip(int calories) {
    return '$calories kcal';
  }

  @override
  String get aiCoachTitle => 'Vireo Yapay Zeka';

  @override
  String get aiCoachFabLabel => 'Vireo Yapay Zeka';

  @override
  String get aiCoachInputHint =>
      'Öğünler, makrolar veya antrenman hakkında sorun…';

  @override
  String get aiCoachOfflineBanner =>
      'Çevrimdışısınız — önbelleğe alınmış mesajlar gösteriliyor.';

  @override
  String get aiCoachChipDinner => 'Akşam yemeği öner';

  @override
  String get aiCoachChipProtein => 'Proteini nasıl artırırım?';

  @override
  String get aiCoachChipDessert => 'Sağlıklı tatlı alternatifi';

  @override
  String waterAddOneGlass(int ml) {
    return '+1 bardak ($ml ml)';
  }

  @override
  String get waterLongPressHint => 'Farklı miktarlar için basılı tutun';

  @override
  String get waterQuickAmountsTitle => 'Hızlı miktarlar';

  @override
  String get waterDefaultCupTitle => 'Varsayılan bardak boyutu';

  @override
  String get waterCustomMl => 'Özel miktar';

  @override
  String get waterAddCustom => 'Ekle';

  @override
  String get waterTrackerTitle => 'Su takibi';

  @override
  String waterTrackerSummary(double current, double goal, int percent) {
    return '${current}L / ${goal}L — %$percent tamamlandı';
  }

  @override
  String get weeklyDeficitChartTitle => 'Haftalık kalori dengesi';

  @override
  String get weeklyDeficitSubtitle =>
      'TDEE − öğünler + kardiyo yakımı (son 7 gün)';

  @override
  String weeklyDeficitTotal(int kcal) {
    return 'Haftalık net denge: $kcal kcal';
  }

  @override
  String get weeklyDeficitEmpty =>
      'Haftalık kalori dengenizi görmek için öğün veya kardiyo kaydedin.';

  @override
  String get weeklyDeficitInProgress => 'Bugün (devam ediyor)';

  @override
  String get progressTrendEmpty => 'Eğiliminizi görmek için 3 gün kaydedin';

  @override
  String get cookMethodRaw => 'Çiğ';

  @override
  String get cookMethodBoiled => 'Haşlanmış';

  @override
  String get cookMethodGrilled => 'Izgara';

  @override
  String get cookMethodFried => 'Kızarmış';

  @override
  String get cookMethodBaked => 'Fırınlanmış';

  @override
  String get cookMethodSteamed => 'Buharda';

  @override
  String get cookMethodOther => 'Diğer';

  @override
  String weeklyDeficitTooltip(int net, int consumed, int burned) {
    return '$net kcal\nAlınan: $consumed · Yakılan: $burned';
  }

  @override
  String uxGoodMorning(String name) {
    return 'Günaydın, $name';
  }

  @override
  String uxGoodAfternoon(String name) {
    return 'Tünaydın, $name';
  }

  @override
  String uxGoodEvening(String name) {
    return 'İyi akşamlar, $name';
  }

  @override
  String get uxTodayOverline => 'BUGÜN';

  @override
  String get uxCaloriesLeft => 'kcal kaldı';

  @override
  String get uxCaloriesOver => 'kcal aşıldı';

  @override
  String get uxGoal => 'Hedef';

  @override
  String get uxEaten => 'Alınan';

  @override
  String get uxBurned => 'Yakılan';

  @override
  String get uxActionScan => 'Öğün tara';

  @override
  String get uxActionTrain => 'Antrenman';

  @override
  String get uxActionCoach => 'YZ Koç';

  @override
  String get uxSectionTraining => 'Bugünün antrenmanı';

  @override
  String get uxSectionThisWeek => 'Bu hafta';

  @override
  String get uxSectionTodayLog => 'Bugünün günlüğü';

  @override
  String get uxAddMeal => '+ Öğün ekle';

  @override
  String get uxAiScanned => 'YZ taraması';

  @override
  String get uxMealRemoved => 'Öğün kaldırıldı';

  @override
  String get uxLogEmptyTitle => 'Henüz bir şey kaydedilmedi';

  @override
  String get uxLogEmptyBody =>
      'Öğününüzün fotoğrafını çekin — yapay zeka saniyeler içinde kalori ve makroları hesaplasın.';

  @override
  String get uxRestDayHint =>
      'Toparlanma da antrenmanın bir parçasıdır. Yürüyün, esneyin ve protein hedefinizi yakalayın.';

  @override
  String uxWorkoutMinutes(int minutes) {
    return '~$minutes dk';
  }

  @override
  String get uxWater => 'Su';

  @override
  String get uxGlassSize => '250 ml';

  @override
  String uxWaterAdded(String liters) {
    return '+250 ml · bugün $liters L';
  }

  @override
  String get uxWaterGoalDone => 'Su hedefine ulaşıldı 💧 harika iş!';

  @override
  String get uxUndo => 'Geri al';

  @override
  String get uxCopied => 'Kopyalandı';

  @override
  String get uxSend => 'Gönder';

  @override
  String get uxQuickLogTitle => 'Hızlı kayıt';

  @override
  String get uxQuickLogSubtitle => 'Tek dokunuşla dilediğinizi kaydedin.';

  @override
  String get uxQuickScanTitle => 'Yapay zeka ile öğün tara';

  @override
  String get uxQuickScanSub => 'Saniyeler içinde kalori ve makrolar';

  @override
  String get uxQuickWater => 'Su';

  @override
  String get uxQuickWaterSub => '+1 bardak · 250 ml';

  @override
  String get uxQuickWeight => 'Kilo';

  @override
  String get uxQuickWeightSub => 'Bugünkü tartıyı kaydet';

  @override
  String get uxQuickCardio => 'Kardiyo';

  @override
  String get uxQuickCardioSub => 'Yürüyüş, koşu, bisiklet…';

  @override
  String get uxQuickCoach => 'Koça sor';

  @override
  String get uxQuickCoachSub => 'Kişisel yapay zeka tavsiyesi';

  @override
  String get uxCoachOnline => 'Çevrim içi · makrolarınızı biliyor';

  @override
  String get uxCoachTyping => 'Yazıyor…';

  @override
  String get uxCoachNewChat => 'Yeni sohbet';

  @override
  String get uxCoachClearConfirm =>
      'Yeni bir konuşma başlatılsın mı? Mevcut mesajlar temizlenecektir.';

  @override
  String get uxCoachHeroTitle => 'Kişisel yapay zeka koçunuz';

  @override
  String get uxCoachHeroBody =>
      'Öğünler, protein, tatlı krizleri veya antrenman hakkında danışın. Her yanıt bugünkü verilerinize dayanır.';

  @override
  String uxCoachKcalLeft(int kcal) {
    return '$kcal kcal kaldı';
  }

  @override
  String uxCoachProteinLeft(int grams) {
    return '${grams}g protein kaldı';
  }

  @override
  String get uxCoachChipWorkout => 'Antrenmandan önce ne yemeliyim?';

  @override
  String get uxProtein => 'Protein';

  @override
  String get uxCarbs => 'Karb';

  @override
  String get uxFat => 'Yağ';

  @override
  String get aiScanAnalysisTitle => 'YZ analizi';

  @override
  String get diaryAddMeal => 'Öğün Ekle';

  @override
  String get diaryAddWorkout => 'Antrenman Ekle';

  @override
  String get diaryCaloriesIn => 'Alınan Kalori';

  @override
  String get diaryCaloriesOut => 'Yakılan Kalori';

  @override
  String diaryKcal(int kcal) {
    return '$kcal kcal';
  }

  @override
  String diaryLastUpdated(String count) {
    return 'Son güncelleme $count';
  }

  @override
  String diaryMealCalories(int calories) {
    return '$calories kcal';
  }

  @override
  String get diaryNetBalance => 'Net Denge';

  @override
  String get diaryNoEntries => 'Bu gün için kayıt yok';

  @override
  String get diaryProtein => 'Protein';

  @override
  String diaryProteinProgress(int current, int goal) {
    return '$current / $goal g';
  }

  @override
  String get diarySetGoalsCta => 'Hedefleri belirle';

  @override
  String get diarySetGoalsFirst => 'Önce hedeflerinizi belirleyin';

  @override
  String get diaryTimeline => 'Zaman Çizelgesi';

  @override
  String get diaryTitle => 'Günlüğüm';

  @override
  String get diaryToday => 'Bugün';

  @override
  String get diaryWater => 'Su';

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
    return '$minutes dk · $calories kcal';
  }

  @override
  String get exerciseAdvanced => 'İleri Seviye';

  @override
  String get exerciseBeginner => 'Başlangıç';

  @override
  String get exerciseComplete => 'Seti Tamamla';

  @override
  String get exerciseDifficulty => 'Zorluk';

  @override
  String get exerciseEquipment => 'Ekipman';

  @override
  String get exerciseIntermediate => 'Orta Seviye';

  @override
  String get exerciseLoadingDemo => 'Egzersiz demosu yükleniyor...';

  @override
  String get exerciseMistakes => 'Yaygın Hatalar';

  @override
  String get exerciseReps => 'Tekrar';

  @override
  String get exerciseRest => 'Dinlenme';

  @override
  String get exerciseSets => 'Set';

  @override
  String get exerciseSteps => 'Adımlar';

  @override
  String get exerciseTips => 'Uzman İpuçları';

  @override
  String get exerciseViewBack => 'Arka';

  @override
  String get exerciseViewFront => 'Ön';

  @override
  String get measurements30Days => '30 gün';

  @override
  String get measurements3Months => '3 ay';

  @override
  String get measurements7Days => '7 gün';

  @override
  String get measurementsAdd => 'Ölçüm ekle';

  @override
  String get measurementsAddFirst => 'İlk ölçümünüzü kaydedin';

  @override
  String get measurementsAll => 'Tümü';

  @override
  String get measurementsArms => 'Kollar';

  @override
  String get measurementsBodyFat => 'Vücut yağı %';

  @override
  String get measurementsChest => 'Göğüs';

  @override
  String get measurementsDate => 'Tarih';

  @override
  String get measurementsDelete => 'Sil';

  @override
  String get measurementsDeleteConfirm => 'Bu ölçüm silinsin mi?';

  @override
  String get measurementsHistory => 'Geçmiş';

  @override
  String measurementsLastUpdated(String date) {
    return 'Güncellendi $date';
  }

  @override
  String get measurementsNeedMoreData =>
      'Eğilimleri görmek için daha fazla kayıt girin';

  @override
  String get measurementsNoData => 'Henüz ölçüm yok';

  @override
  String get measurementsNotes => 'Notlar';

  @override
  String get measurementsSave => 'Kaydet';

  @override
  String get measurementsThighs => 'Uyluklar';

  @override
  String get measurementsTitle => 'Ölçümler';

  @override
  String get measurementsTrendDeclining => 'Dikkat gerekiyor';

  @override
  String get measurementsTrendImproving => 'Gelişiyor';

  @override
  String get measurementsTrendStable => 'Stabil';

  @override
  String get measurementsWaist => 'Bel';

  @override
  String get measurementsWeight => 'Kilo';

  @override
  String get measurementsWeightInvalid => 'Geçerli bir kilo girin';

  @override
  String get muscleBack => 'Sırt';

  @override
  String get muscleBiceps => 'Biceps';

  @override
  String get muscleCalves => 'Kalf';

  @override
  String get muscleChest => 'Göğüs';

  @override
  String get muscleCore => 'Core';

  @override
  String get muscleForearms => 'Ön Kol';

  @override
  String get muscleGlutes => 'Glute';

  @override
  String get muscleHamstrings => 'Hamstring';

  @override
  String get muscleHipFlexors => 'Kalça Fleksörleri';

  @override
  String get muscleQuads => 'Quadriceps';

  @override
  String get muscleShoulders => 'Omuz';

  @override
  String get muscleTriceps => 'Triceps';

  @override
  String get notificationsBreakfast => 'Kahvaltı hatırlatıcısı';

  @override
  String get notificationsDinner => 'Akşam yemeği hatırlatıcısı';

  @override
  String get notificationsLunch => 'Öğle yemeği hatırlatıcısı';

  @override
  String get notificationsOpenSettings => 'Ayarları aç';

  @override
  String get notificationsPermissionBanner =>
      'Hedefinizde kalmak için bildirimleri etkinleştirin';

  @override
  String get notificationsPreWorkout => 'Antrenman öncesi hatırlatıcı';

  @override
  String get notificationsPreWorkoutSubtitle => 'Antrenmana hazırlanın';

  @override
  String get notificationsSleep => 'Uyku hatırlatıcısı';

  @override
  String get notificationsSleepSubtitle =>
      'Daha iyi toparlanma için dinlenmeye geçin';

  @override
  String get notificationsTest => 'Test bildirimi gönder';

  @override
  String get notificationsTestBody => 'Vireo hatırlatıcıları çalışıyor';

  @override
  String get notificationsTitle => 'Bildirimler';

  @override
  String get notificationsWater => 'Su hatırlatıcısı';

  @override
  String get notificationsWaterSubtitle => 'Gün boyunca susuz kalmayın';

  @override
  String get notificationsWeeklyReport => 'Haftalık rapor';

  @override
  String get notificationsWeeklyReportSubtitle =>
      'Haftanızın nasıl geçtiğini görün';

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
  String get vitality12WeekProgram => '12 Haftalık Program';

  @override
  String vitalityArticleCount(int count) {
    return '$count makale';
  }

  @override
  String get vitalityArticleDisclaimer =>
      'Yalnızca eğitim amaçlıdır. Kişisel tavsiye için bir uzmana danışın.';

  @override
  String get vitalityArticlesSection => 'Makaleler';

  @override
  String get vitalityBadgesTitle => 'Rozetler';

  @override
  String vitalityBreathingCount(int count) {
    return '$count seans';
  }

  @override
  String get vitalityBreathingLog => 'Nefes';

  @override
  String get vitalityCategoryAdvanced => 'İleri Düzey';

  @override
  String get vitalityCategoryEnvironmental => 'Çevre';

  @override
  String get vitalityCategoryLifestyle => 'Yaşam Tarzı';

  @override
  String get vitalityCategoryNutrition => 'Beslenme';

  @override
  String get vitalityCategoryTraining => 'Antrenman';

  @override
  String get vitalityCheckProtein => 'Protein hedefini yakala';

  @override
  String get vitalityCheckSleep => 'Kaliteli uyku';

  @override
  String get vitalityCheckSunlight => 'Sabah güneşi';

  @override
  String get vitalityCheckWorkout => 'Hareket et / antrenman yap';

  @override
  String get vitalityCheckZincVitD => 'Çinko / D Vitamini';

  @override
  String vitalityDailyChecklistProgress(int done, int total) {
    return '$done/$total tamamlandı';
  }

  @override
  String get vitalityDailyChecklistTitle => 'Bugünün kontrol listesi';

  @override
  String get vitalityDailyTipLabel => 'Günün ipucu';

  @override
  String get vitalityHubSubtitle =>
      'Enerji ve toparlanma için bilime dayalı alışkanlıklar';

  @override
  String get vitalityHubTitle => 'Zindelik Merkezi';

  @override
  String get vitalityLegendBadge => 'Efsane';

  @override
  String get vitalityLinkCopied => 'Bağlantı kopyalandı';

  @override
  String get vitalityLogSection => 'Kayıt';

  @override
  String get vitalityMarkRead => 'Okundu olarak işaretle';

  @override
  String get vitalityMarkReadDone => 'Okundu';

  @override
  String get vitalityMarkReadSuccess => 'Okundu olarak işaretlendi';

  @override
  String get vitalityMedicalDisclaimer =>
      'Yalnızca eğitim amaçlıdır — tıbbi tavsiye değildir.';

  @override
  String get vitalityMetricsEmpty => 'Henüz metrik yok';

  @override
  String get vitalityMetricsLast7Days => 'Son 7 gün';

  @override
  String vitalityMetricsLastEntry(int score) {
    return 'Son giriş · enerji $score/10';
  }

  @override
  String get vitalityMetricsSave => 'Metrikleri kaydet';

  @override
  String get vitalityMetricsSaved => 'Kaydedildi';

  @override
  String get vitalityMetricsTapToLog => 'Kaydetmek için dokunun';

  @override
  String get vitalityMetricsTitle => 'Günlük metrikler';

  @override
  String get vitalityMorningEnergy => 'Sabah enerjisi';

  @override
  String get vitalityMyProgram => 'Programım';

  @override
  String get vitalityNotLogged => 'Kaydedilmedi';

  @override
  String get vitalityPhaseFoundation => 'Temel';

  @override
  String get vitalityPhaseOptimization => 'Optimizasyon';

  @override
  String get vitalityPhasePeak => 'Zirve';

  @override
  String get vitalityProgramAllWeeks => 'Tüm haftalar';

  @override
  String get vitalityProgramComplete => 'Program tamamlandı';

  @override
  String get vitalityProgramContinue => 'Devam Et';

  @override
  String get vitalityProgramDisclaimer =>
      'Eğitim programıdır — tıbbi bir tedavi değildir.';

  @override
  String get vitalityProgramDone => 'Tamamlandı';

  @override
  String get vitalityProgramOverallProgress => 'Genel ilerleme';

  @override
  String get vitalityProgramStartCta => 'Programa başla';

  @override
  String get vitalityProgramSubtitle =>
      'Daha iyi enerji, uyku ve toparlanma için 12 hafta';

  @override
  String get vitalityProgramTitle => 'Zindelik Dönüşümü';

  @override
  String get vitalityProtocolBadgeEarned => 'Rozet açıldı!';

  @override
  String get vitalityProtocolCompleteDay => 'Günü tamamla';

  @override
  String vitalityProtocolStreak(int days) {
    return '$days günlük seri';
  }

  @override
  String get vitalityProtocolTitle => 'Protokoller';

  @override
  String vitalityReadingTime(int minutes) {
    return '$minutes dk okuma';
  }

  @override
  String get vitalityReportCompletion => 'Tamamlama';

  @override
  String get vitalityReportImproving => 'Gelişiyorsunuz — seriyi bozmayın.';

  @override
  String get vitalityReportKeepGoing =>
      'Küçük adımlar da değerlidir. Bugün birkaç görevi tamamlayın.';

  @override
  String get vitalityScientificSources => 'Kaynaklar';

  @override
  String vitalityScoreBreakdown(
    int sleep,
    int workout,
    int protein,
    int stress,
  ) {
    return 'Uyku $sleep · Antrenman $workout · Protein $protein · Stres $stress';
  }

  @override
  String get vitalityScoreLabel => 'Zindelik';

  @override
  String get vitalitySleepHint => 'Nasıl uyudun?';

  @override
  String vitalitySleepHours(num hours) {
    return '$hours sa';
  }

  @override
  String get vitalitySleepLog => 'Uyku';

  @override
  String get vitalitySleepQuality => 'Kalite';

  @override
  String vitalityStreak(int days) {
    return '$days günlük seri';
  }

  @override
  String get vitalityStressLevel => 'Stres';

  @override
  String get vitalityUnlockNextWeek => 'Gelecek haftanın kilidini aç';

  @override
  String vitalityWeekProgress(int percent) {
    return '%$percent';
  }

  @override
  String get vitalityWeekReport => 'Haftalık rapor';

  @override
  String vitalityWeekX(int week) {
    return '$week. Hafta';
  }

  @override
  String vitalityWeekXOf12(int week) {
    return '$week / 12. Hafta';
  }

  @override
  String get vitalityWorkoutDone => 'Antrenman yapıldı';

  @override
  String get vitalityWorkoutLog => 'Antrenman';

  @override
  String get vitalityWorkoutPending => 'Dinlenme / henüz değil';

  @override
  String get vitalityWorkoutPerformance => 'Performans';

  @override
  String walkingEstimatedMinutes(int minutes) {
    return '~$minutes dk';
  }

  @override
  String get walkingHealthBanner => 'Bu telefonun adımsayarından canlı adımlar';

  @override
  String get walkingManualStepsLabel => 'Bugünkü adım';

  @override
  String get walkingUpdateSteps => 'Adımları güncelle';

  @override
  String get walkingWebManualBanner => 'Web sürümünde adımları manuel girin';

  @override
  String get vitalityKeyTakeaway => 'Önemli çıkarım';

  @override
  String get dietMyPlan => 'Diyet planım';

  @override
  String get dietProgramsTitle => 'Diyet programları';

  @override
  String get dietQuizTitle => 'Diyet planı testi';

  @override
  String get dietQuizContinue => 'Anladım — devam et';

  @override
  String get dietQuizYes => 'Evet';

  @override
  String get dietQuizNo => 'Hayır';

  @override
  String dietQuizHealthStep(int current, int total) {
    return 'Sağlık $current / $total';
  }

  @override
  String dietQuizPrefStep(int current, int total) {
    return 'Tercihler $current / $total';
  }

  @override
  String get dietPrefBreadRice => 'Ekmek ve pirinci sever misiniz?';

  @override
  String get dietPrefSkipBreakfast => 'Kahvaltıyı rahatça atlayabilir misiniz?';

  @override
  String get dietPrefSimpleRules =>
      'Basit beslenme kurallarını mı tercih edersiniz?';

  @override
  String get dietPrefEatsOut => 'Sık sık dışarıda yemek yer misiniz?';

  @override
  String get dietPrefWeights => 'Düzenli olarak ağırlık çalışıyor musunuz?';

  @override
  String get dietRecommendedBadge => 'Sizin için önerilen';

  @override
  String get dietActiveBadge => 'Aktif';

  @override
  String get dietNeedsDoctor => 'Doktor onayı gereklidir';

  @override
  String get dietReadWarning => 'Uyarıyı oku';

  @override
  String dietCardMacros(int kcal, int protein) {
    return '$kcal kcal · ${protein}g protein';
  }

  @override
  String get dietHowItWorks => 'Nasıl çalışır?';

  @override
  String get dietYourTargets => 'Hedefleriniz';

  @override
  String get dietBestFor => 'En uygun olanlar';

  @override
  String get dietNotIdealFor => 'Uygun olmayanlar';

  @override
  String get dietRules => 'Kurallar';

  @override
  String get dietAllowedFoods => 'İzin verilen besinler';

  @override
  String get dietLimitFoods => 'Sınırlandırılacak besinler';

  @override
  String get dietSampleDay => 'Örnek gün';

  @override
  String get dietSideEffects => 'Yan etkiler';

  @override
  String get dietTips => 'İpuçları';

  @override
  String get dietEvidence => 'Bilimsel dayanak';

  @override
  String get dietStopSigns => 'Bırakma belirtileri';

  @override
  String get dietDisclaimer => 'Feragatname';

  @override
  String get dietStartProgram => 'Bu programa başla';

  @override
  String get dietDoctorGateTitle => 'Doktor onayı gerekiyor';

  @override
  String get dietAckWarning => 'Uyarıyı okudum';

  @override
  String get dietMustAckWarning => 'Lütfen önce uyarıyı okuduğunuzu onaylayın';

  @override
  String get dietStartedToast => 'Diyet programı başlatıldı';

  @override
  String get dietClose => 'Kapat';

  @override
  String dietCarbsMax(int grams) {
    return 'Karb sınırı: $grams g';
  }

  @override
  String dietWeeklyLoss(String kg) {
    return 'Tahmini haftalık kayıp ≈ $kg kg';
  }

  @override
  String get dietChoosePlanCard => 'Diyet planınızı seçin';

  @override
  String dietFastingLeft(String time) {
    return 'Oruç — kalan süre $time';
  }

  @override
  String dietEatingWindowLeft(String time) {
    return 'Yeme aralığı — $time içinde kapanıyor';
  }

  @override
  String dietWindowStartsAt(int hour) {
    return 'Yeme aralığı saat $hour:00\'da başlıyor';
  }

  @override
  String get dietEditWindow => 'Başlangıç saatini düzenle';

  @override
  String get dietCarbsLimitLabel => 'Karb sınırı';

  @override
  String dietCarbsLimitProgress(int current, int max) {
    return '$current / $max g karb';
  }

  @override
  String get todayPlanTitle => 'GÜNLÜK PLAN';

  @override
  String todayPlanProgressSummary(int percent, int done, int total) {
    return 'Günün %$percent\'ini tamamladınız · $done/$total madde';
  }

  @override
  String get todayPlanNow => 'Şimdi';

  @override
  String get todayPlanPro => 'PRO';

  @override
  String todayPlanWaterReminder(int index, int total) {
    return 'Su hatırlatıcısı $index / $total';
  }

  @override
  String todayPlanWaterGoalLine(int ml) {
    return 'Günlük hedef $ml ml';
  }

  @override
  String get todayPlanFastingOpen => 'Yeme aralığı açılıyor';

  @override
  String todayPlanFastingOpenSubtitle(int hours) {
    return '$hours saatlik yeme aralığı başlıyor';
  }

  @override
  String get todayPlanFastingClose => 'Yeme aralığı kapanıyor';

  @override
  String todayPlanFastingCloseSubtitle(int hours) {
    return '$hours saatlik oruç başlıyor';
  }

  @override
  String get todayPlanWorkout => 'Bugünün antrenmanı';

  @override
  String get todayPlanSteps => 'Adım hedefi';

  @override
  String todayPlanStepsProgress(int current, int goal) {
    return '$current / $goal adım';
  }

  @override
  String get todayPlanVitalitySleepSubtitle =>
      'Zindelik bölümüne 7,5+ saat kaydedin';

  @override
  String get todayPlanVitalityProteinSubtitle => 'Protein hedefinize ulaşın';

  @override
  String get todayPlanVitalitySunSubtitle => 'Sabah güneş ışığı alma';

  @override
  String get todayPlanVitalityStress => 'Stres sıfırlama';

  @override
  String get todayPlanVitalityStressSubtitle => 'Bir nefes egzersizi kaydedin';

  @override
  String get todayPlanVitalityZincSubtitle => 'Besinlerden çinko ve D vitamini';

  @override
  String get todayPlanSleepTarget => 'Uyku hedefi';

  @override
  String get todayPlanSleepTargetSubtitle =>
      'Kaliteli uyku için dinlenmeye geçin';

  @override
  String get todayPlanProtocolItem => 'Zindelik protokolü';

  @override
  String get todayPlanAiSuggestion => 'Yapay zeka koçu önerisi';

  @override
  String get todayPlanAiSuggestionSubtitle =>
      'Bugün için kişiselleştirilmiş ipucu';

  @override
  String waterGoalBasedOnWeight(int kg) {
    return 'Kilonuza göre ($kg kg)';
  }

  @override
  String get authErrorEmailRateLimit =>
      'Çok fazla e-posta gönderildi, bir saat sonra tekrar deneyin';

  @override
  String get profileMyBody => 'Vücudum';

  @override
  String get profileGuestProgressHint => 'Misafir — ilerleme kaydedilmiyor';

  @override
  String get profilePlanPro => 'Pro';

  @override
  String get profilePlanFree => 'Ücretsiz';

  @override
  String profileMemberSince(String date) {
    return 'Üyelik tarihi: $date';
  }

  @override
  String get profileSaveProgressCta => 'İlerlemenizi kaydedin';

  @override
  String get profileMyPlanSection => 'Planım';

  @override
  String get profileChangeDietPlan => 'Planı değiştir';

  @override
  String get profileBodyMetricsSaved => 'Vücut metrikleri güncellendi';

  @override
  String get profileSaveBodyMetrics => 'Kaydet';

  @override
  String get profileEditDisplayName => 'Görünen ad';

  @override
  String get profileDisplayNameHint => 'Adınız';

  @override
  String get profileFitnessGoal => 'Hedef';

  @override
  String get activityHubTitle => 'Aktivite ve Sağlık';

  @override
  String get activityHubSubtitle =>
      'GPS antrenmanları, giyilebilir cihaz metrikleri ve rehberli nefes egzersizleri — telefon öncelikli, saat destekli.';

  @override
  String get activityHealthHomeCardTitle => 'Aktivite ve Sağlık';

  @override
  String get activityHealthHomeCardSubtitle =>
      'Saatinizi bağlayın veya açık hava antrenmanı başlatın';

  @override
  String get outdoorWorkoutTitle => 'Açık hava antrenmanı';

  @override
  String get outdoorWorkoutSubtitle =>
      'GPS haritası ve sesli yönlendirmelerle yürüyün, koşun veya bisiklete binin';

  @override
  String get outdoorPickTitle => 'Aktivite seç';

  @override
  String get outdoorPickSubtitle =>
      'GPS takibi yalnızca oturumunuz sırasında çalışır.';

  @override
  String get outdoorTypeWalk => 'Yürüyüş';

  @override
  String get outdoorTypeRun => 'Koşu';

  @override
  String get outdoorTypeCycle => 'Bisiklet';

  @override
  String get outdoorGo => 'Başla!';

  @override
  String get outdoorLocationDenied =>
      'GPS antrenmanları için konum izni gereklidir.';

  @override
  String get outdoorDistance => 'Mesafe';

  @override
  String get outdoorDuration => 'Süre';

  @override
  String get outdoorPace => 'Tempo';

  @override
  String get outdoorSpeed => 'Hız';

  @override
  String outdoorPaceMinKm(int min, int sec) {
    return '$min:$sec / km';
  }

  @override
  String outdoorSpeedKmh(String speed) {
    return '$speed km/s';
  }

  @override
  String outdoorCalories(int kcal) {
    return '$kcal kcal yakıldı';
  }

  @override
  String get outdoorPause => 'Duraklat';

  @override
  String get outdoorResume => 'Devam Et';

  @override
  String get outdoorHoldToStop => 'Bitirmek için basılı tutun';

  @override
  String get outdoorStopTitle => 'Antrenman sonlandırılsın mı?';

  @override
  String get outdoorStopBody => 'Rotanız ve istatistikleriniz kaydedilecek.';

  @override
  String get outdoorStopConfirm => 'Bitir';

  @override
  String get outdoorPaused => 'Duraklatıldı';

  @override
  String get outdoorAutoPause => 'Hareketsizken otomatik duraklat';

  @override
  String get outdoorHistoryTitle => 'Antrenman geçmişi';

  @override
  String get outdoorHistorySubtitle => 'Geçmiş GPS oturumları';

  @override
  String get outdoorHistoryEmpty => 'Henüz açık hava antrenmanı yok.';

  @override
  String get outdoorDetailTitle => 'Antrenman detayı';

  @override
  String get outdoorSplitsTitle => 'Kilometre aralıkları';

  @override
  String outdoorSplitKm(int km) {
    return '$km. Km';
  }

  @override
  String get uxQuickOutdoor => 'Açık hava antrenmanı';

  @override
  String get uxQuickOutdoorSub => 'GPS ile yürüyüş, koşu veya sürüş';

  @override
  String get healthHubTitle => 'Sağlık';

  @override
  String get healthHubCardSubtitle => 'Saatinizden nabız, uyku, SpO₂ verileri';

  @override
  String get healthHubProgressSubtitle =>
      'Giyilebilir cihaz metrikleri ve uyku puanı';

  @override
  String get healthNotMedical =>
      'Tıbbi kullanım için değildir. Metrikler Health Connect / Apple Health üzerinden saatinizden alınır.';

  @override
  String get healthFromWatch => 'Saatinizden';

  @override
  String get healthConnectWatchTitle => 'Saatinizi bağlayın';

  @override
  String get healthConnectWatchBody =>
      'Vireo\'nun nabız, uyku, adım ve daha fazlasını gösterebilmesi için Health Connect veya Apple Health erişimine izin verin. Yaşamsal bulguları asla telefondan tahmin etmeyiz.';

  @override
  String get healthGrantPermission => 'Sağlık erişimine izin ver';

  @override
  String get healthMetricHeartRate => 'Kalp atış hızı';

  @override
  String get healthMetricRestingHr => 'Dinlenme nabzı';

  @override
  String get healthMetricHrv => 'HRV (RMSSD)';

  @override
  String get healthMetricSpO2 => 'Kandaki oksijen';

  @override
  String get healthMetricSleep => 'Uyku';

  @override
  String get healthMetricWeight => 'Kilo';

  @override
  String get healthMetricWorkout => 'Antrenmanlar';

  @override
  String get healthMetricSteps => 'Adımlar';

  @override
  String get healthManualSleepTitle => 'Manuel uyku kaydı';

  @override
  String get healthManualSleepHint =>
      'Giyilebilir cihaz uyku verisi yok — yatış saatini ve kalitesini kaydetmek için dokunun';

  @override
  String healthSleepScore(int score) {
    return 'Uyku puanı $score';
  }

  @override
  String get healthBedtime => 'Yatış saati';

  @override
  String get healthWakeTime => 'Uyanma saati';

  @override
  String get healthSleepQuality => 'Kalite (1–5)';

  @override
  String get healthStressTitle => 'Stres düzeyi (HRV)';

  @override
  String get healthStressLow => 'Düşük';

  @override
  String get healthStressMedium => 'Orta';

  @override
  String get healthStressHigh => 'Yüksek';

  @override
  String healthHrvDetail(int today, int baseline) {
    return 'Bugün $today ms (14 günlük temel seviye: $baseline ms)';
  }

  @override
  String get breathingHubTitle => 'Nefes';

  @override
  String get breathingHubSubtitle =>
      'Stresten toparlanma için rehberli seanslar';

  @override
  String get breathingBoxTitle => 'Kutu nefesi 4-4-4-4';

  @override
  String get breathingBoxSubtitle => 'Eşit nefes al, tut, ver, tut';

  @override
  String get breathing478Title => '4-7-8 rahatlama';

  @override
  String get breathing478Subtitle => 'Uyku öncesi sakinleştirici nefes düzeni';

  @override
  String breathingMinutes(int min) {
    return '$min dk';
  }

  @override
  String get breathingSessionTitle => 'Nefes seansı';

  @override
  String get breathingInhale => 'Nefes al';

  @override
  String get breathingHold => 'Tut';

  @override
  String get breathingExhale => 'Nefes ver';

  @override
  String get breathingRest => 'Dinlen';

  @override
  String get mealReviewTitle => 'Öğünü incele';

  @override
  String get mealReviewAddItem => 'Öğe ekle';

  @override
  String get mealReviewSlot => 'Öğün';

  @override
  String mealReviewRemaining(int kcal) {
    return 'Kalan bütçe: $kcal kcal';
  }

  @override
  String get mealReviewEstimated => 'tahmini';

  @override
  String get mealReviewCheckAmount => 'miktarı kontrol edin';

  @override
  String get mealReviewSearchFood => 'Yemek ara…';

  @override
  String get mealReviewLogByText => 'Metinle kaydet';

  @override
  String get mealLogTextTitle => 'Öğünü metinle kaydet';

  @override
  String get mealLogTextHint => 'Ne yediğinizi yazın — Türkçe veya İngilizce.';

  @override
  String get mealLogTextPlaceholder =>
      '2 yumurta, 1 dilim tam buğday ekmeği ve bir fincan çay yedim';

  @override
  String get mealLogTextAnalyze => 'Analiz Et';

  @override
  String get mealVoiceStart => 'Ses';

  @override
  String get mealVoiceListening => 'Dinleniyor…';

  @override
  String get mealVoiceUnavailable => 'Sesli giriş bu cihazda kullanılamıyor';

  @override
  String get mealBarcodeTitle => 'Barkod tara';

  @override
  String get mealBarcodeFailed =>
      'Bu barkod bulunamadı. Tekrar deneyin veya metinle kaydedin.';

  @override
  String get mealScanHintLabel => 'Birkaç kelime ekleyin (isteğe bağlı)';

  @override
  String get mealScanHintPlaceholder => 'Yağ? Sos? Ekmek türü?';

  @override
  String get mealHowCalculated => 'Nasıl hesapladık?';

  @override
  String get plateSizeAskTitle => 'Normal tabak boyutunuz nedir?';

  @override
  String get plateSizeSmall => 'Küçük';

  @override
  String get plateSizeMedium => 'Orta';

  @override
  String get plateSizeLarge => 'Büyük';

  @override
  String get inbodyScanTitle => 'InBody raporunu tara';

  @override
  String get inbodyReviewTitle => 'InBody sonucunu incele';

  @override
  String get inbodyBodyTitle => 'Vücut kompozisyonu';

  @override
  String get inbodyAddResult => 'InBody sonucu ekle';

  @override
  String get inbodyPickPdf => 'PDF seç';

  @override
  String get inbodyFrameHint => 'Rapor sayfasının tamamını çerçeveye sığdırın';

  @override
  String get inbodyAnalyzing => 'Raporunuz okunuyor…';

  @override
  String get inbodyUnreadable =>
      'Sayfa okunamadı. Daha net bir fotoğraf deneyin.';

  @override
  String get inbodyScanFailed =>
      'InBody taraması başarısız oldu. Tekrar deneyin.';

  @override
  String get inbodySaved => 'InBody sonucu kaydedildi';

  @override
  String get inbodyMedicalNote =>
      'Tıbbi kullanım için değildir — yalnızca fitness takibi içindir.';

  @override
  String get inbodyTestDate => 'Test tarihi';

  @override
  String get inbodyDevice => 'Cihaz';

  @override
  String get inbodyWeight => 'Kilo (kg)';

  @override
  String get inbodySmm => 'İskelet kası (kg)';

  @override
  String get inbodyFatMass => 'Yağ kütlesi (kg)';

  @override
  String get inbodyPbf => 'Vücut yağı %';

  @override
  String get inbodyBmi => 'VKİ';

  @override
  String get inbodyVisceral => 'İç organ yağlanma seviyesi';

  @override
  String get inbodyBmr => 'BMR (kcal)';

  @override
  String get inbodyScore => 'InBody puanı';

  @override
  String get inbodySave => 'Sonucu kaydet';

  @override
  String get inbodyEmpty =>
      'Henüz vücut kompozisyonu raporu yok. Başlamak için bir InBody formu tarayın.';

  @override
  String get inbodyLatestTitle => 'En son rapor';

  @override
  String get inbodyCompareTitle => 'İki raporu karşılaştır';

  @override
  String get inbodySyncHealth => 'Health Connect eşitle';

  @override
  String get inbodySyncedLabel => 'Health Connect\'ten eşitlendi';

  @override
  String inbodySyncResult(int count) {
    return '$count Health Connect ölçümü içe aktarıldı';
  }

  @override
  String inbodyFromDateLabel(String date) {
    return '$date tarihli InBody raporunuzdan';
  }

  @override
  String get uxQuickInbody => 'InBody raporu';

  @override
  String get uxQuickInbodySub => 'Sonuç formunu tara';

  @override
  String get mealScanHeroTitle => 'Öğününüzü tarayın';

  @override
  String get mealScanHeroSubtitle =>
      'Yapay zeka besinleri tanır — siz gramajı onaylarsınız';

  @override
  String get mealScanTipAbove => 'Yukarıdan çekin';

  @override
  String get mealScanTipWholePlate => 'Bütün tabak görünsün';

  @override
  String get mealScanTipLight => 'İyi aydınlatma';

  @override
  String get mealScanFlashOn => 'Flaş açık';

  @override
  String get mealScanFlashOff => 'Flaş kapalı';

  @override
  String get uxQuickMealText => 'Metinle öğün';

  @override
  String get uxQuickMealTextSub => 'Ne yediğinizi yazın';

  @override
  String get uxQuickBarcode => 'Barkod';

  @override
  String get uxQuickBarcodeSub => 'Open Food Facts aramasını aç';

  @override
  String get mealFavoriteSave => 'Favorilere kaydet';

  @override
  String get mealFavoriteSaved => 'Favorilere kaydedildi';

  @override
  String get mealFavoritesTitle => 'Favoriler';

  @override
  String get mealRecentTitle => 'Son öğünler';

  @override
  String get mealRelog => 'Tekrar kaydet';

  @override
  String get appearanceTitle => 'Görünüm';

  @override
  String get themeModeSystem => 'Sistem varsayılanı';

  @override
  String get themeModeLight => 'Aydınlık mod';

  @override
  String get themeModeDark => 'Karanlık mod';

  @override
  String get accentThemeTitle => 'Vurgu rengi';

  @override
  String get accentEmber => 'Köz (Varsayılan)';

  @override
  String get accentOcean => 'Okyanus';

  @override
  String get accentForest => 'Orman';

  @override
  String get accentRoyal => 'Kraliyet';

  @override
  String detectedActivity(String activity) {
    return 'Algılanan: $activity';
  }

  @override
  String get manualOverride => 'Manuel geçersiz kıl';

  @override
  String get mealClarificationTitle => 'Hızlı netleştirme';

  @override
  String get celebrationWaterTitle => 'Su Hedefine Ulaşıldı! 💧';

  @override
  String get celebrationProteinTitle => 'Protein Hedefi Tamamlandı! 💪';

  @override
  String get celebrationStepsTitle => 'Adım Hedefi Başarıldı! 🏃';

  @override
  String get celebrationWorkoutTitle => 'Antrenman Tamamlandı! 🔥';
}
