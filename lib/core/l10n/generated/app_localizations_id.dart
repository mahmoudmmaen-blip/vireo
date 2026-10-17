// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Vireo';

  @override
  String get homeTitle => 'Beranda';

  @override
  String get onboardingTitle => 'Selamat Datang';

  @override
  String get workoutTitle => 'Latihan';

  @override
  String get nutritionTitle => 'Nutrisi';

  @override
  String get progressTitle => 'Kemajuan';

  @override
  String get profileTitle => 'Profil';

  @override
  String get authTitle => 'Masuk';

  @override
  String get languageToggle => 'English';

  @override
  String get setupComplete => 'Vireo sudah siap';

  @override
  String get continueButton => 'Lanjutkan';

  @override
  String get skipButton => 'Lewati';

  @override
  String get finishButton => 'Selesai';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get saveButton => 'Save';

  @override
  String get yesButton => 'Ya';

  @override
  String get noButton => 'Tidak';

  @override
  String onboardingStepProgress(int current, int total) {
    return 'Langkah $current dari $total';
  }

  @override
  String get onboardingStep1Title => 'Tentang Anda';

  @override
  String get onboardingStep1Subtitle =>
      'Kami akan mempersonalisasi rencana Anda dari data dasar ini.';

  @override
  String get onboardingStep2Title => 'Pemeriksaan kesehatan';

  @override
  String get onboardingStep2Subtitle =>
      'Jawab dengan jujur — ini membantu kami menjaga latihan tetap aman.';

  @override
  String get onboardingStep3Title => 'Tempat latihan Anda';

  @override
  String get onboardingStep3Subtitle =>
      'Kami hanya akan menampilkan latihan yang sesuai dengan peralatan Anda.';

  @override
  String get onboardingStep4Title => 'Tujuan Anda';

  @override
  String get onboardingStep4Subtitle => 'Apa yang paling penting saat ini?';

  @override
  String get onboardingStep5Title => 'Sebelum kita mulai';

  @override
  String get onboardingStep5Subtitle =>
      'Harap baca dan setujui untuk melanjutkan.';

  @override
  String get onboardingStep6Title => 'Tetap konsisten';

  @override
  String get onboardingStep6Subtitle =>
      'Pengingat opsional — Anda dapat mengubahnya nanti.';

  @override
  String get unitsMetric => 'kg / cm';

  @override
  String get unitsImperial => 'lb / in';

  @override
  String get onboardingAge => 'Usia';

  @override
  String get onboardingHeight => 'Tinggi badan';

  @override
  String get onboardingWeight => 'Berat badan';

  @override
  String get onboardingActivityLevel => 'Tingkat aktivitas';

  @override
  String get onboardingDietaryOptional => 'Batasan pola makan (opsional)';

  @override
  String get activitySedentary => 'Sebagian besar tidak aktif';

  @override
  String get activityModerate => 'Cukup aktif';

  @override
  String get activityVeryActive => 'Sangat aktif';

  @override
  String get dietHalal => 'Halal';

  @override
  String get dietVegetarian => 'Vegetarian';

  @override
  String get dietVegan => 'Vegan';

  @override
  String get dietGlutenFree => 'Bebas gluten';

  @override
  String get dietDairyFree => 'Bebas produk susu';

  @override
  String get dietLowSodium => 'Rendah natrium';

  @override
  String get dietLowCarb => 'Rendah karbohidrat';

  @override
  String get dietDiabeticFriendly => 'Ramah diabetes';

  @override
  String get onboardingMedicalFlagNotice =>
      'Kami akan menyesuaikan intensitas dan menampilkan pengingat keselamatan saat latihan.';

  @override
  String get healthQuestionHeart =>
      'Penyakit jantung atau kondisi kardiovaskular?';

  @override
  String get healthQuestionDiabetes =>
      'Diabetes atau masalah kadar gula darah?';

  @override
  String get healthQuestionBloodPressure => 'Tekanan darah tinggi atau rendah?';

  @override
  String get healthQuestionJoints => 'Cedera sendi atau nyeri kronis?';

  @override
  String get healthQuestionMedications =>
      'Sedang mengonsumsi obat-obatan rutin?';

  @override
  String get envHomeNoEquipment => 'Rumah — tanpa alat';

  @override
  String get envHomeNoEquipmentDesc => 'Latihan beban tubuh saja';

  @override
  String get envHomeLightEquipment => 'Rumah — alat ringan';

  @override
  String get envHomeLightEquipmentDesc =>
      'Resistance band, dumbbell, atau sejenisnya';

  @override
  String get envGymFull => 'Gym lengkap';

  @override
  String get envGymFullDesc => 'Mesin, barbell, akses rak lengkap';

  @override
  String get envWalkingOnly => 'Jalan kaki saja';

  @override
  String get envWalkingOnlyDesc => 'Target langkah dan mobilitas ringan';

  @override
  String get goalWeightLoss => 'Penurunan berat badan';

  @override
  String get goalWeightLossDesc =>
      'Pembakaran lemak dengan latihan yang berkelanjutan';

  @override
  String get goalMuscleGain => 'Membentuk otot';

  @override
  String get goalMuscleGainDesc => 'Fokus kekuatan dan massa otot tanpa lemak';

  @override
  String get goalGeneralVitality => 'Kebugaran umum';

  @override
  String get goalGeneralVitalityDesc =>
      'Energi, konsistensi, dan merasa lebih bugar';

  @override
  String get goalAllOfAbove => 'Semua hal di atas';

  @override
  String get goalAllOfAboveDesc => 'Rencana seimbang untuk semua tujuan';

  @override
  String get legalDisclaimerText =>
      'Vireo adalah alat kebugaran organisasi dan bukan pengganti saran medis langsung. Konten (latihan, rencana makan, dan informasi kesehatan) hanya untuk panduan umum.\n\nJika Anda memiliki kondisi kronis — seperti penyakit jantung, diabetes, tekanan darah tinggi, atau cedera sendi saat ini — atau mengonsumsi obat-obatan, konsultasikan dengan dokter Anda sebelum memulai program olahraga atau nutrisi apa pun.\n\nSuplemen makanan dan panduan terkait hormon (seperti testosteron) hanyalah informasi edukasi umum. Ini bukan resep medis atau rekomendasi perawatan.\n\nDengan berpartisipasi dalam program apa pun di dalam aplikasi, saya menyatakan telah membaca persyaratan dan memahami bahwa Vireo tidak bertanggung jawab atas cedera atau komplikasi kesehatan akibat penggunaan aplikasi tanpa konsultasi medis.';

  @override
  String get legalDisclaimerSection1 =>
      'Vireo adalah alat kebugaran organisasi dan bukan pengganti saran medis langsung. Konten (latihan, rencana makan, dan informasi kesehatan) hanya untuk panduan umum.';

  @override
  String get legalDisclaimerSection2 =>
      'Jika Anda memiliki kondisi kronis — seperti penyakit jantung, diabetes, tekanan darah tinggi, atau cedera sendi saat ini — atau mengonsumsi obat-obatan, konsultasikan dengan dokter Anda sebelum memulai program olahraga atau nutrisi apa pun.';

  @override
  String get legalDisclaimerSection3 =>
      'Suplemen makanan hanyalah informasi edukasi umum. Ini bukan resep medis atau rekomendasi perawatan.';

  @override
  String get legalDisclaimerSection4 =>
      'Panduan terkait hormon (seperti testosteron) hanyalah informasi edukasi umum. Ini bukan resep medis atau rekomendasi perawatan.';

  @override
  String get legalDisclaimerSection5 =>
      'Dengan berpartisipasi dalam program apa pun di dalam aplikasi, saya menyatakan telah membaca persyaratan dan memahami bahwa Vireo tidak bertanggung jawab atas cedera atau komplikasi kesehatan akibat penggunaan aplikasi tanpa konsultasi medis.';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get consentCheckboxLabel =>
      'Saya telah membaca dan menyetujui syarat serta penafian kesehatan';

  @override
  String get notificationWorkoutTime => 'Waktu latihan pilihan';

  @override
  String get notificationWalkingReminder => 'Pengingat jalan kaki harian';

  @override
  String get notificationWeeklyCheckIn => 'Pengingat evaluasi mingguan';

  @override
  String get notificationNotSet => 'Belum diatur';

  @override
  String get authWelcomeTitle => 'Selamat datang di Vireo';

  @override
  String get authWelcomeSubtitle =>
      'Masuk untuk menyinkronkan kemajuan di semua perangkat, atau lanjutkan secara lokal sebagai tamu.';

  @override
  String get authSaveProgressTitle => 'Simpan kemajuan Anda';

  @override
  String get authSaveProgressSubtitle =>
      'Hubungkan akun agar rencana, pindaian, dan percakapan Anda tersinkronisasi di semua perangkat.';

  @override
  String get signInWithApple => 'Masuk dengan Apple';

  @override
  String get signInWithGoogle => 'Masuk dengan Google';

  @override
  String get signInWithEmail => 'Masuk dengan email';

  @override
  String get authContinueApple => 'Lanjutkan dengan Apple';

  @override
  String get authContinueGoogle => 'Lanjutkan dengan Google';

  @override
  String get authContinueEmail => 'Lanjutkan dengan email';

  @override
  String get authSignInWithPassword => 'Masuk dengan kata sandi';

  @override
  String get authSendCode => 'Kirim kode';

  @override
  String get authVerifyCode => 'Verifikasi kode';

  @override
  String get authResendCode => 'Kirim ulang kode';

  @override
  String authResendIn(int seconds) {
    return 'Kirim ulang dalam $seconds dtk';
  }

  @override
  String authOtpSentTo(String email) {
    return 'Kami telah mengirim kode 6 digit ke $email';
  }

  @override
  String get authBack => 'Kembali';

  @override
  String get continueAsGuest => 'Lanjutkan sebagai Tamu';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Kata sandi';

  @override
  String get authSignIn => 'Masuk';

  @override
  String get authSignUp => 'Daftar';

  @override
  String get authHasAccount => 'Sudah punya akun?';

  @override
  String get authNoAccount => 'Belum punya akun?';

  @override
  String get authSignedIn => 'Sudah masuk';

  @override
  String get authErrorGeneric => 'Terjadi kesalahan. Silakan coba lagi.';

  @override
  String get authErrorOffline =>
      'Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.';

  @override
  String get authErrorWrongCode => 'Kode salah. Periksa angka dan coba lagi.';

  @override
  String get authErrorTooMany =>
      'Terlalu banyak percobaan, coba lagi dalam satu menit.';

  @override
  String get authErrorInvalidEmail => 'Masukkan alamat email yang valid.';

  @override
  String get authErrorCancelled => 'Proses masuk dibatalkan.';

  @override
  String get signOut => 'Keluar';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get guestModeTitle => 'Mode tamu';

  @override
  String get guestModeSubtitle =>
      'Kemajuan Anda hanya disimpan di perangkat ini. Buat akun untuk menyinkronkan dan berlangganan.';

  @override
  String get profileStatWorkoutsLabel => 'Latihan selesai';

  @override
  String get profileStatStreakLabel => 'Rentetan hari';

  @override
  String get saveProgressToCloud => 'Simpan kemajuan ke cloud';

  @override
  String get profileCloudSynced => 'Kemajuan tersinkronisasi ke akun Anda';

  @override
  String get authGateTitle => 'Buat akun';

  @override
  String get authGateSaveProgress =>
      'Buat akun gratis untuk menyimpan kemajuan Anda ke cloud dan mengaksesnya di perangkat apa pun.';

  @override
  String get authGateSubscribe =>
      'Buat akun sebelum berlangganan agar akses premium Anda terhubung ke akun Anda.';

  @override
  String get authGateAiFeatures =>
      'Buat akun gratis untuk menggunakan pemindai makanan AI dan Vireo Coach. Obrolan dan pindaian Anda tersinkronisasi dengan aman ke akun Anda.';

  @override
  String get authGateSignUp => 'Daftar';

  @override
  String get authGateNotNow => 'Nanti saja';

  @override
  String get deleteAccountTitle => 'Hapus akun';

  @override
  String get deleteAccountWarningTitle => 'Tindakan ini tidak dapat dibatalkan';

  @override
  String get deleteAccountWarningBody =>
      'Semua data profil, riwayat latihan, rencana makan, dan foto kemajuan Anda akan dihapus secara permanen dari server kami.';

  @override
  String get deleteAccountCancel => 'Batal';

  @override
  String get deleteAccountContinue => 'Lanjutkan';

  @override
  String get deleteAccountConfirmTitle => 'Konfirmasi penghapusan';

  @override
  String get deleteAccountConfirmInstructions =>
      'Ketik kata di bawah ini persis sama untuk mengonfirmasi penghapusan akun permanen:';

  @override
  String get deleteConfirmationWord => 'DELETE';

  @override
  String get deleteAccountTypeHint => 'Ketik DELETE';

  @override
  String get deleteAccountConfirmButton => 'Hapus akun saya secara permanen';

  @override
  String get deleteAccountSuccess => 'Akun Anda telah dihapus.';

  @override
  String get workoutMedicalWarning =>
      'Anda mengindikasikan adanya kondisi kesehatan saat orientasi. Hentikan jika Anda merasa nyeri, pusing, atau sesak napas. Konsultasikan dengan dokter Anda sebelum latihan intens.';

  @override
  String get workoutWarmUpTitle => 'Pemanasan';

  @override
  String get workoutWarmUpSubtitle =>
      'Selesaikan latihan mobilitas ini sebelum latihan utama Anda.';

  @override
  String get workoutCoolDownTitle => 'Pendinginan';

  @override
  String get workoutCoolDownSubtitle =>
      'Mobilitas lembut untuk membantu pemulihan tubuh Anda.';

  @override
  String get workoutActiveTitle => 'Latihan aktif';

  @override
  String get workoutBeginWorkout => 'Mulai latihan';

  @override
  String get workoutFinishCoolDown => 'Selesaikan pendinginan';

  @override
  String get workoutStartButton => 'Mulai latihan hari ini';

  @override
  String get workoutTodayTitle => 'Program hari ini';

  @override
  String workoutTodaySubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count latihan utama',
      one: '1 latihan utama',
    );
    return '$_temp0';
  }

  @override
  String workoutPhaseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count latihan',
      one: '1 latihan',
    );
    return '$_temp0';
  }

  @override
  String get workoutExerciseProgress => 'Latihan';

  @override
  String get workoutStatSets => 'Set';

  @override
  String get workoutStatReps => 'Rep';

  @override
  String get workoutStatRest => 'Istirahat';

  @override
  String get workoutSetsLabel => 'Set';

  @override
  String workoutSetNumber(int number) {
    return 'Set $number';
  }

  @override
  String get workoutPrevious => 'Sebelumnya';

  @override
  String get workoutNext => 'Berikutnya';

  @override
  String get workoutSwapExercise => 'Ganti latihan';

  @override
  String get workoutSwapTitle => 'Ganti latihan';

  @override
  String get workoutSwapSubtitle =>
      'Alternatif untuk kelompok otot yang sama dan lingkungan latihan Anda.';

  @override
  String get workoutSwapEmpty => 'Tidak ada alternatif yang tersedia saat ini.';

  @override
  String get workoutRestTitle => 'Istirahat';

  @override
  String get workoutRestSkip => 'Lewati';

  @override
  String get workoutRestAdd15 => '+15 dtk';

  @override
  String get workoutPausedTitle => 'Latihan dijeda';

  @override
  String get workoutResume => 'Lanjutkan';

  @override
  String get workoutEndWorkout => 'Akhiri latihan';

  @override
  String get workoutRestart => 'Mulai ulang latihan';

  @override
  String get workoutEndConfirmTitle => 'Akhiri latihan?';

  @override
  String get workoutEndConfirmBody =>
      'Kemajuan Anda dalam sesi ini tidak akan disimpan.';

  @override
  String get workoutFeedbackTitle => 'Bagaimana latihan tadi?';

  @override
  String get workoutFeedbackEasy => 'Mudah';

  @override
  String get workoutFeedbackJustRight => 'Pas';

  @override
  String get workoutFeedbackHard => 'Berat';

  @override
  String get workoutVideoUnavailable => 'Video tidak tersedia';

  @override
  String get workoutEmptyProgram =>
      'Tidak ada latihan yang dijadwalkan untuk hari ini.';

  @override
  String get walkingTitle => 'Jalan kaki';

  @override
  String get walkingStepsToday => 'langkah hari ini';

  @override
  String walkingDailyGoal(int steps) {
    return 'Target: $steps langkah';
  }

  @override
  String walkingGoalProgress(int percent) {
    return '$percent% dari target hari ini';
  }

  @override
  String get walkingWeeklyChartTitle => '7 hari terakhir';

  @override
  String get walkingHealthSourceNote =>
      'Langkah dihitung di perangkat ini. Jika Health Connect / Apple Health juga tersedia, Vireo menampilkan jumlah yang lebih tinggi.';

  @override
  String get walkingPermissionTitle => 'Akses langkah diperlukan';

  @override
  String get walkingPermissionBody =>
      'Vireo menghitung langkah dengan sensor gerak ponsel Anda. Izinkan akses aktivitas agar target langkah dan kalori tetap akurat.';

  @override
  String get walkingOpenSettings => 'Buka Pengaturan';

  @override
  String get walkingTryAgain => 'Coba lagi';

  @override
  String get walkingUnavailableTitle => 'Pelacak langkah tidak tersedia';

  @override
  String get walkingUnavailableBody =>
      'Pelacakan langkah berfungsi paling baik di ponsel fisik iOS atau Android dengan sensor penghitung langkah.';

  @override
  String get walkingEnableTitle => 'Hitung langkah di ponsel ini';

  @override
  String get walkingEnableBody =>
      'Vireo menggunakan sensor langkah ponsel Anda untuk melacak jalan kaki secara langsung — jarak, kalori, dan target harian Anda. Kami akan meminta izin aktivitas berikutnya.';

  @override
  String get walkingEnableCta => 'Aktifkan hitungan langkah';

  @override
  String get walkingActiveMinutes => 'Waktu aktif';

  @override
  String get nutritionTabBreakfast => 'Sarapan';

  @override
  String get nutritionTabLunch => 'Makan siang';

  @override
  String get nutritionTabDinner => 'Makan malam';

  @override
  String get nutritionTabSnack => 'Camilan';

  @override
  String get nutritionNoMealPlanned =>
      'Tidak ada makanan yang direncanakan untuk hari ini.';

  @override
  String nutritionPrepMinutes(int minutes) {
    return '$minutes mnt';
  }

  @override
  String get nutritionTagHighProtein => 'Tinggi protein';

  @override
  String get nutritionTagQuickEasy => 'Cepat & mudah';

  @override
  String get nutritionTagLightEnergy => 'Energi ringan';

  @override
  String get nutritionScanFridge => 'Pindai kulkas Anda';

  @override
  String nutritionScansRemaining(int count) {
    return 'Tersisa $count pemindaian kulkas bulan ini';
  }

  @override
  String get nutritionScanPrompt =>
      'Ambil foto kulkas atau dapur Anda untuk mendeteksi bahan makanan.';

  @override
  String get nutritionTakePhoto => 'Ambil foto';

  @override
  String get nutritionChoosePhoto => 'Pilih dari galeri';

  @override
  String get nutritionScanning => 'Memindai bahan makanan…';

  @override
  String get nutritionScanFailed =>
      'Pemindaian gagal. Coba lagi atau masukkan bahan secara manual.';

  @override
  String get nutritionScanLimitReached =>
      'Batas pemindaian bulanan tercapai. Tingkatkan akun untuk pemindaian tanpa batas.';

  @override
  String get nutritionConfirmIngredients => 'Konfirmasi bahan makanan';

  @override
  String get nutritionIngredientsHint =>
      'Hapus yang tidak sesuai dan tambahkan bahan yang kurang.';

  @override
  String get nutritionAddIngredient => 'Tambah bahan';

  @override
  String get nutritionGetRecipes => 'Dapatkan ide resep';

  @override
  String get nutritionNoIngredients => 'Tambahkan setidaknya satu bahan.';

  @override
  String get nutritionRecipeSuggestions => 'Ide resep';

  @override
  String get nutritionRecipeSuggestionsSubtitle =>
      'Berdasarkan bahan, tujuan, dan preferensi pola makan Anda.';

  @override
  String get nutritionNoRecipesFound => 'Tidak ditemukan resep yang cocok.';

  @override
  String get nutritionManualEntry => 'Masukkan manual';

  @override
  String get nutritionManualEntryHint =>
      'Ketik apa yang Anda miliki — kami akan menyarankan resep yang sesuai dengan tujuan dan preferensi pola makan Anda.';

  @override
  String get nutritionSwapMeal => 'Ganti makanan';

  @override
  String get nutritionSwapMealSubtitle =>
      'Pilih resep berbeda — tidak ada pengulangan dalam 14 hari.';

  @override
  String get nutritionSwapMealEmpty =>
      'Tidak ada pilihan makanan alternatif saat ini.';

  @override
  String get nutritionDemoQuickMeals => 'Contoh makanan sehat cepat saji';

  @override
  String get nutritionTryDemoScan => 'Coba demo pemindaian';

  @override
  String get homeWelcomeSubtitle => 'Pusat kebugaran pribadi Anda.';

  @override
  String get homeWalkingCardSubtitle =>
      'Lacak langkah harian dari Apple Health atau Health Connect.';

  @override
  String get homeDailyProgramTitle => 'Program harian';

  @override
  String get homeTodayWorkout => 'Latihan hari ini';

  @override
  String get homeNextMeal => 'Makanan berikutnya';

  @override
  String homeWorkoutExerciseCount(int count) {
    return '$count latihan';
  }

  @override
  String get progressTabWeight => 'Berat badan';

  @override
  String get progressTabAdherence => 'Kepatuhan';

  @override
  String get progressTabEnergy => 'Energi';

  @override
  String get progressWeightChartTitle => 'Tren berat badan';

  @override
  String progressWeightGoalLine(String value, String unit) {
    return 'Target: $value $unit';
  }

  @override
  String get progressAdherenceChartTitle => 'Kepatuhan mingguan';

  @override
  String get progressAdherenceSubtitle => '% penyelesaian latihan per minggu';

  @override
  String get progressEnergyChartTitle => 'Tingkat energi';

  @override
  String get progressEnergySubtitle => 'Skor energi evaluasi mingguan (1–10)';

  @override
  String get progressLogWeight => 'Catat berat badan';

  @override
  String progressWeightLabel(String unit) {
    return 'Berat badan ($unit)';
  }

  @override
  String get progressLogDate => 'Tanggal';

  @override
  String get progressSaveWeight => 'Simpan';

  @override
  String get reassessmentTitle => 'Evaluasi bulanan';

  @override
  String get reassessmentSubtitle =>
      'Perbarui berat badan, aktivitas, dan persiapan latihan Anda agar program tetap akurat.';

  @override
  String get reassessmentLater => 'Nanti';

  @override
  String get reassessmentSubmit => 'Perbarui rencana saya';

  @override
  String get reassessmentSummaryTitle => 'Perubahan';

  @override
  String get reassessmentSummarySubtitle =>
      'Dibandingkan dengan evaluasi terakhir Anda';

  @override
  String reassessmentPhaseUpdated(int phase) {
    return 'Fase program diperbarui ke fase $phase';
  }

  @override
  String get reassessmentNoPhaseChange =>
      'Tidak ada perubahan program yang diperlukan — teruskan!';

  @override
  String get paywallTitle => 'Vireo Premium';

  @override
  String get paywallHeadline => 'Buka potensi penuh Anda';

  @override
  String get paywallSubtitle =>
      'Premium memberi Anda pemindaian tanpa batas, fase program lengkap, dan wawasan kemajuan yang lebih mendalam.';

  @override
  String get paywallBestValue => 'Pilihan Terbaik';

  @override
  String get paywallPlanMonthly => 'Bulanan';

  @override
  String get paywallPlanAnnual => 'Tahunan';

  @override
  String get paywallPlanLifetime => 'Seumur Hidup';

  @override
  String get paywallFeatureUnlimitedScans =>
      'Pemindaian Piring Instan Tanpa Batas';

  @override
  String get paywallFeatureFullProgram =>
      'Fase program lengkap & latihan progresif';

  @override
  String get paywallFeatureCloudSync => 'Sinkronisasi cloud di semua perangkat';

  @override
  String get paywallFeatureProgressAnalytics => 'Analisis kemajuan lanjutan';

  @override
  String get paywallSubscribe => 'Berlangganan';

  @override
  String get paywallRestorePurchases => 'Pulihkan pembelian';

  @override
  String get paywallPurchaseSuccess => 'Selamat datang di Premium!';

  @override
  String get paywallPurchaseError => 'Pembelian gagal. Silakan coba lagi.';

  @override
  String get paywallRestoreSuccess => 'Pembelian berhasil dipulihkan.';

  @override
  String get paywallRestoreEmpty =>
      'Tidak ada langganan aktif yang ditemukan untuk akun ini.';

  @override
  String get paywallRestoreError =>
      'Tidak dapat memulihkan pembelian. Coba lagi nanti.';

  @override
  String get paywallNotConfigured =>
      'Langganan tidak tersedia dalam build ini.';

  @override
  String get paywallSubscriptionExpiredMessage =>
      'Langganan Anda telah berakhir. Berlangganan kembali untuk membuka fitur premium.';

  @override
  String get trialEndedTitle => 'Uji coba gratis Anda telah berakhir';

  @override
  String get trialEndedBody =>
      'Terima kasih telah mencoba Vireo Premium. Berlangganan untuk mempertahankan pemindaian tanpa batas, fase program lengkap, dan sinkronisasi cloud.';

  @override
  String get trialEndedViewPlans => 'Lihat paket';

  @override
  String subscriptionTrialDaysRemaining(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Tersisa $days hari dalam uji coba gratis Anda',
      one: 'Tersisa 1 hari dalam uji coba gratis Anda',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionExpiredBanner =>
      'Langganan berakhir — ketuk untuk memperpanjang akses premium';

  @override
  String get subscriptionPremiumActive => 'Premium aktif';

  @override
  String get subscriptionFreeTier => 'Paket gratis';

  @override
  String get subscriptionUpgrade => 'Tingkatkan';

  @override
  String get settingsManageSubscription =>
      'Lihat paket, berlangganan, atau pulihkan pembelian';

  @override
  String workoutPhaseLockedTitle(int phase) {
    return 'Fase $phase terkunci';
  }

  @override
  String get workoutPhaseLockedBody =>
      'Berlangganan kembali untuk melanjutkan program pelatihan lengkap Anda. Pelacakan dasar tetap tersedia di paket gratis.';

  @override
  String homeGreeting(String name) {
    return 'Halo $name 👋';
  }

  @override
  String homeDayPhase(int day, String phase) {
    return 'Hari $day · Fase $phase';
  }

  @override
  String get homeGuestBanner =>
      'Anda dalam mode tamu — daftar untuk menyimpan kemajuan Anda';

  @override
  String get homeGuestSignUp => 'Daftar';

  @override
  String get homeGuestCta => 'Daftar sekarang — gratis selama 7 hari';

  @override
  String homeStreakDays(int days) {
    return 'Rentetan $days hari';
  }

  @override
  String get homeStartStreak => 'Mulai rentetan Anda hari ini';

  @override
  String get homeTodayWorkoutTitle => 'Latihan hari ini';

  @override
  String get homeStartWorkout => 'Mulai latihan';

  @override
  String get homeRestDay => 'Hari istirahat aktif 🧘';

  @override
  String get homeBreakfast => 'Sarapan';

  @override
  String get homeMealConfirmed => 'Dikonfirmasi ✓';

  @override
  String get homeMealPending => 'Tertunda';

  @override
  String homeWalkingSteps(int current, int goal) {
    return '$current / $goal langkah';
  }

  @override
  String homeWeeklyProgress(int completed) {
    return '$completed / 7 hari selesai';
  }

  @override
  String get homeCheckInBanner =>
      '⏱️ Evaluasi mingguan siap — hanya satu menit';

  @override
  String get homeRecoveryScore => 'Skor pemulihan';

  @override
  String get homeRecoveryReady => 'Tubuh Anda siap untuk berlatih';

  @override
  String get homeGuestName => 'Juara';

  @override
  String get homePhaseFoundation => 'Fondasi';

  @override
  String get nutritionFilterAll => 'Semua';

  @override
  String get nutritionFilterQuick => 'Cepat';

  @override
  String get nutritionFilterLowCalorie => 'Rendah kalori';

  @override
  String nutritionMacroSummary(int calories, int protein) {
    return '$calories kkal · ${protein}g protein';
  }

  @override
  String get nutritionMacroBar => 'Kalori | Protein | Karbohidrat | Lemak';

  @override
  String get nutritionMealConfirmed => 'Dikonfirmasi ✓';

  @override
  String nutritionFridgeBanner(int remaining) {
    return '📷 Pindai kulkas Anda — tersisa $remaining pindaian bulan ini';
  }

  @override
  String get nutritionFridgeScanCta => 'Pindai';

  @override
  String get workoutWarmUpStep1 => 'Putaran bahu — 30 detik';

  @override
  String get workoutWarmUpStep2 => 'Jalan di tempat — 60 detik';

  @override
  String get workoutWarmUpStep3 => 'Squat ringan — 10 repetisi';

  @override
  String get workoutSkipWarmUp => 'Lewati pemanasan';

  @override
  String get workoutStartMainWorkout => 'Mulai latihan utama';

  @override
  String get workoutWarmUpComplete => 'Pemanasan selesai — siap!';

  @override
  String homeProgramDay(int day, int total) {
    return 'Hari $day dari $total';
  }

  @override
  String get homeStartProgram => 'Mulai program Anda';

  @override
  String get nutritionDailyCalorieGoal => 'Target kalori harian Anda';

  @override
  String nutritionCalorieTargetSummary(
    int calories,
    int protein,
    int carbs,
    int fat,
  ) {
    return 'Target: $calories kkal — ${protein}g protein, ${carbs}g karbohidrat, ${fat}g lemak';
  }

  @override
  String nutritionCalorieProgress(int consumed, int target) {
    return '$consumed / $target kkal hari ini';
  }

  @override
  String get nutritionEditCalorieGoal => 'Ubah target kalori';

  @override
  String get nutritionCalorieHint => 'Kalori harian';

  @override
  String get settingsThemeTitle => 'Tampilan';

  @override
  String get settingsThemeDark => 'Mode gelap';

  @override
  String get settingsThemeLight => 'Mode terang';

  @override
  String get settingsThemeSystem => 'Default sistem';

  @override
  String get progressAxisDate => 'Tanggal';

  @override
  String get progressAxisWeight => 'Berat badan (kg)';

  @override
  String get progressAxisEnergy => 'Energi (1–10)';

  @override
  String get progressAllChartsTitle => 'Ringkasan kemajuan Anda';

  @override
  String get profileGuestAvatar => 'Tamu';

  @override
  String get profileStatProgramDays => 'Hari program';

  @override
  String get profileStatsSection => 'Statistik Anda';

  @override
  String get profileGoalWeight => 'Target berat badan';

  @override
  String get profileCurrentBmi => 'BMI saat ini';

  @override
  String get profileActivityLevel => 'Tingkat aktivitas';

  @override
  String get profileEditProfile => 'Edit profil';

  @override
  String get profileBmiUnderweight => 'Berat badan kurang';

  @override
  String get profileBmiHealthy => 'Berat badan sehat';

  @override
  String get profileBmiOverweight => 'Kelebihan berat badan';

  @override
  String get profileBmiObese => 'Obesitas';

  @override
  String get profileBmiTooltip =>
      'BMI (Indeks Massa Tubuh) memperkirakan lemak tubuh dari tinggi dan berat badan. Ini adalah panduan umum — bukan diagnosis medis.';

  @override
  String get workoutSplitChestTriceps => 'Dada & Trisep';

  @override
  String get workoutSplitBackBiceps => 'Punggung & Bisep';

  @override
  String get workoutSplitLegs => 'Kaki';

  @override
  String get workoutSplitCardio => 'Kardio';

  @override
  String get workoutSplitShoulders => 'Bahu';

  @override
  String get workoutSplitFullBody => 'Seluruh Tubuh';

  @override
  String get workoutSplitRest => 'Hari istirahat';

  @override
  String get habitsTitle => 'Kebiasaan harian';

  @override
  String get habitsEmpty =>
      'Belum ada kebiasaan — ketuk + untuk menambahkan yang pertama';

  @override
  String get habitsAddTitle => 'Kebiasaan baru';

  @override
  String get habitsAddHint => 'Nama kebiasaan';

  @override
  String get habitsAddConfirm => 'Tambah';

  @override
  String habitsStreak(int days) {
    return 'Rentetan $days hari';
  }

  @override
  String get habitsRetry => 'Coba lagi';

  @override
  String get habitsErrorTitle => 'Gagal memuat kebiasaan';

  @override
  String homeRecoveryExplain(int score) {
    return 'Skor pemulihan $score% menggabungkan kualitas tidur, hari istirahat, dan kelelahan otot. Nilai lebih tinggi berarti tubuh Anda siap berlatih keras.';
  }

  @override
  String get homeRecoveryFactorSleep => 'Kualitas tidur';

  @override
  String get homeRecoveryFactorRest => 'Hari istirahat';

  @override
  String get homeRecoveryFactorMuscle => 'Kelelahan otot';

  @override
  String get homeRecoveryTipSleep => 'Targetkan 7–9 jam malam ini';

  @override
  String get homeRecoveryTipRest =>
      'Pertahankan setidaknya satu hari istirahat penuh setiap minggu';

  @override
  String get homeRecoveryTipMuscle =>
      'Kurangi intensitas jika nyeri otot masih tinggi';

  @override
  String get homeRecoveryImproveTitle => 'Tips untuk meningkatkan';

  @override
  String get homeRecoveryImproveBody =>
      'Prioritaskan tidur, penuhi cairan, dan ganti sesi berat dengan latihan mobilitas saat kelelahan meningkat.';

  @override
  String get walkingMetricsTitle => 'Metrik jalan kaki hari ini';

  @override
  String get walkingDistance => 'Jarak';

  @override
  String get walkingSpeed => 'Kecepatan';

  @override
  String get walkingPace => 'Kecepatan langkah (Pace)';

  @override
  String get walkingCalories => 'Kalori terbakar';

  @override
  String walkingWeightLoss(String kg) {
    return 'Est. pembakaran lemak ≈ $kg kg';
  }

  @override
  String walkingCadence(int spm) {
    return 'Kadensi ≈ $spm langkah/mnt';
  }

  @override
  String get walkingMetricsEstimatedNote =>
      'Health Connect tidak tersedia — menampilkan estimasi metrik dari hitungan langkah.';

  @override
  String get mealBuilderTitle => 'Sesuaikan bahan';

  @override
  String mealBuilderTitleFor(String meal) {
    return 'Sesuaikan $meal';
  }

  @override
  String get mealBuilderSubtitle =>
      'Sesuaikan protein, lemak memasak, dan tambahan — makronutrisi diperbarui langsung.';

  @override
  String get mealBuilderEggs => 'Telur';

  @override
  String mealBuilderEggCount(int count) {
    return '$count butir telur';
  }

  @override
  String mealBuilderPortionCount(int count) {
    return '$count porsi';
  }

  @override
  String get mealBuilderProteinLunch => 'Porsi protein';

  @override
  String get mealBuilderProteinDinner => 'Protein makan malam';

  @override
  String get mealBuilderProteinSnack => 'Protein camilan';

  @override
  String get mealBuilderFatSource => 'Sumber lemak';

  @override
  String get mealBuilderFatButter => 'Mentega (Butter)';

  @override
  String get mealBuilderFatGhee => 'Minyak samin (Ghee)';

  @override
  String get mealBuilderFatOliveOil => 'Minyak zaitun';

  @override
  String get mealBuilderFatSpray => 'Semprotan minyak (Oil spray)';

  @override
  String get mealBuilderAddOns => 'Tambahan';

  @override
  String get mealBuilderAddonCheese => 'Keju';

  @override
  String get mealBuilderAddonVeggies => 'Sayuran';

  @override
  String get mealBuilderAddonBread => 'Roti gandum utuh';

  @override
  String get mealBuilderAddonRice => 'Nasi';

  @override
  String get mealBuilderAddonYogurt => 'Yogurt';

  @override
  String get mealBuilderLiveMacros => 'Makro langsung';

  @override
  String get weeklyCheckInTitle => 'Evaluasi mingguan';

  @override
  String get weeklyCheckInBanner =>
      'Waktunya evaluasi mingguan — perbarui berat badan & energi';

  @override
  String get weeklyCheckInSubtitle =>
      'Kami akan menghitung ulang BMR/TDEE dan makronutrisi Anda untuk minggu depan.';

  @override
  String get weeklyCheckInWeight => 'Berat badan saat ini';

  @override
  String get weeklyCheckInWaist => 'Ukuran lingkar pinggang';

  @override
  String get weeklyCheckInEnergy => 'Tingkat energi (1–5)';

  @override
  String weeklyCheckInAdherence(int pct) {
    return 'Kepatuhan latihan: $pct%';
  }

  @override
  String get weeklyCheckInSubmit => 'Perbarui target saya';

  @override
  String get weeklyCheckInDoneTitle => 'Target diperbarui';

  @override
  String weeklyCheckInDoneBody(
    int prev,
    int next,
    int protein,
    int carbs,
    int fat,
  ) {
    return 'Kalori $prev → $next kkal. Makro: ${protein}g protein, ${carbs}g karbohidrat, ${fat}g lemak.';
  }

  @override
  String get settingsAccentTitle => 'Warna aksen';

  @override
  String get settingsAccentOrange => 'Oranye';

  @override
  String get settingsAccentEmerald => 'Zamrud';

  @override
  String get settingsAccentBlue => 'Samudra';

  @override
  String get settingsAccentViolet => 'Violet';

  @override
  String get settingsSkinTitle => 'Tema warna';

  @override
  String get settingsSkinStandard => 'Standar';

  @override
  String get settingsSkinStandardDesc => 'Vireo klasik gelap / terang';

  @override
  String get settingsSkinAmoled => 'AMOLED Hitam Pekat';

  @override
  String get settingsSkinAmoledDesc => 'Hitam pekat dengan aksen emas & sian';

  @override
  String get settingsSkinNavy => 'Biru Navy Tua';

  @override
  String get settingsSkinNavyDesc => 'Navy #0B192C dengan aksen biru es & teal';

  @override
  String get settingsAccentLockedHint =>
      'Pilihan aksen terkunci saat tema AMOLED / Navy aktif.';

  @override
  String get workoutSwapWarmUp => 'Ganti gerakan pemanasan';

  @override
  String get workoutSwapWarmUpTitle => 'Pilih alternatif pemanasan';

  @override
  String get workoutSwapWarmUpSubtitle =>
      'Pilihan mobilitas dan dampak rendah untuk lingkungan latihan Anda.';

  @override
  String get profileBmiExplainShort =>
      'BMI menilai berat badan relatif terhadap tinggi badan.';

  @override
  String get profileBmiExplainFull =>
      'Indeks Massa Tubuh (BMI) adalah ukuran untuk menilai berat badan relatif terhadap tinggi badan. Ini adalah alat penyaring umum — bukan diagnosis medis.';

  @override
  String get mealBuilderCheeseTitle => 'Keju';

  @override
  String get mealBuilderCheeseNone => 'Tanpa keju';

  @override
  String get mealBuilderCheeseCottage => 'Keju cottage';

  @override
  String get mealBuilderCheeseCheddar => 'Cheddar';

  @override
  String get mealBuilderCheeseMozzarella => 'Mozzarella';

  @override
  String get mealBuilderCheeseFeta => 'Feta';

  @override
  String mealBuilderCheeseGrams(int grams) {
    return 'Jumlah: ${grams}g';
  }

  @override
  String get homeRecoveryFormulaExplain =>
      'Pemulihan = Hari istirahat (40%) + Target langkah (30%) + Konsistensi makan/latihan (30%).';

  @override
  String get homeRecoveryFactorRestDays => 'Hari istirahat';

  @override
  String get homeRecoveryFactorSteps => 'Target jumlah langkah';

  @override
  String get homeRecoveryFactorConsistency => 'Konsistensi makan & latihan';

  @override
  String homeRecoveryRestDetail(int days) {
    return '$days hari istirahat minggu ini';
  }

  @override
  String homeRecoveryStepsDetail(int current, int goal) {
    return '$current / $goal langkah hari ini';
  }

  @override
  String homeRecoveryConsistencyDetail(
    int mealsDone,
    int mealsTotal,
    int wDone,
    int wTotal,
  ) {
    return 'Makanan $mealsDone/$mealsTotal · Latihan $wDone/$wTotal';
  }

  @override
  String get homeRecoveryTipSteps =>
      'Penuhi target langkah harian untuk meningkatkan pilar ini';

  @override
  String get homeRecoveryTipConsistency =>
      'Konfirmasi makanan dan selesaikan latihan terencana';

  @override
  String homeRecoveryMathLine(int rest, int steps, int consistency, int total) {
    return '$rest + $steps + $consistency = $total%';
  }

  @override
  String get cardioTitle => 'Kardio & aktivitas harian';

  @override
  String get cardioSubtitle =>
      'Catat jalan cepat, lari, dan lainnya — kalori menggunakan MET × berat × waktu.';

  @override
  String get cardioSelectActivity => 'Aktivitas';

  @override
  String cardioDuration(int minutes) {
    return 'Durasi: $minutes mnt';
  }

  @override
  String cardioEstimatedBurn(int kcal) {
    return 'Est. pembakaran: $kcal kkal';
  }

  @override
  String cardioMetHint(String met) {
    return 'MET $met · rumus: MET × kg × jam';
  }

  @override
  String get cardioLogButton => 'Catat aktivitas';

  @override
  String get cardioLoggedSnack => 'Sesi kardio berhasil dicatat';

  @override
  String cardioTodayTotal(int kcal) {
    return 'Terbakar hari ini: $kcal kkal';
  }

  @override
  String get cardioEmpty =>
      'Belum ada kardio yang dicatat — tambahkan sesi pertama Anda di atas.';

  @override
  String cardioLogSubtitle(int minutes, int kcal) {
    return '$minutes mnt · $kcal kkal';
  }

  @override
  String get cardioLogCta => 'Catat aktivitas kardio';

  @override
  String get cardioBriskWalking => 'Jalan cepat';

  @override
  String get cardioRunning => 'Lari';

  @override
  String get cardioCycling => 'Bersepeda';

  @override
  String get cardioSwimming => 'Berenang';

  @override
  String get cardioJumpRope => 'Lompat tali';

  @override
  String get cardioHiit => 'HIIT';

  @override
  String get cardioElliptical => 'Elliptical';

  @override
  String workoutGoalPlanLabel(String goal) {
    return 'Rencana untuk: $goal';
  }

  @override
  String get aiScanTitle => 'Pemindai Makanan AI';

  @override
  String get aiScanPrompt =>
      'Foto makanan Anda — AI memperkirakan kalori dan makronutrisi dari ukuran porsi.';

  @override
  String get aiScanCamera => 'Kamera';

  @override
  String get aiScanGallery => 'Galeri';

  @override
  String get aiScanAnalyzing => 'Menganalisis makanan…';

  @override
  String get aiScanOffline =>
      'Tidak ada koneksi internet. Periksa jaringan Anda dan coba lagi.';

  @override
  String get aiScanFailed => 'Pemindaian gagal. Silakan coba lagi.';

  @override
  String get aiScanParseError =>
      'Tidak dapat membaca hasil analisis. Coba foto lain atau masukkan secara manual.';

  @override
  String get aiScanConfigError =>
      'Pemindai AI tidak tersedia saat ini. Silakan coba lagi nanti.';

  @override
  String get aiDailyLimitReached =>
      'Anda telah mencapai batas AI harian hari ini. Tingkatkan untuk kuota harian yang lebih tinggi.';

  @override
  String get aiUpgradeCta => 'Tingkatkan';

  @override
  String get aiScanTryAgain => 'Coba lagi';

  @override
  String get aiScanManualEntry => 'Entri manual';

  @override
  String get aiScanCardTitle => 'Pindai makanan Anda dengan AI';

  @override
  String get aiScanCardSubtitle =>
      'Ambil foto — dapatkan kalori, makronutrisi, dan rekomendasi alternatif cerdas secara instan.';

  @override
  String get aiScanSaveToLog => 'Simpan ke catatan';

  @override
  String get aiScanSavedSnack => 'Makanan disimpan ke catatan hari ini';

  @override
  String get aiScanMacroProtein => 'Protein';

  @override
  String get aiScanMacroCarbs => 'Karbohidrat';

  @override
  String get aiScanMacroFats => 'Lemak';

  @override
  String get aiScanSmartSwaps => 'Penggantian cerdas';

  @override
  String aiScanCaloriesChip(int calories) {
    return '$calories kkal';
  }

  @override
  String get aiCoachTitle => 'Vireo AI';

  @override
  String get aiCoachFabLabel => 'Vireo AI';

  @override
  String get aiCoachInputHint =>
      'Tanyakan tentang makanan, makro, atau latihan…';

  @override
  String get aiCoachOfflineBanner =>
      'Anda sedang offline — menampilkan pesan tersimpan.';

  @override
  String get aiCoachChipDinner => 'Sarankan menu makan malam';

  @override
  String get aiCoachChipProtein => 'Bagaimana cara meningkatkan protein?';

  @override
  String get aiCoachChipDessert => 'Pengganti hidangan penutup yang sehat';

  @override
  String waterAddOneGlass(int ml) {
    return '+1 gelas ($ml ml)';
  }

  @override
  String get waterLongPressHint => 'Tekan lama untuk jumlah lainnya';

  @override
  String get waterQuickAmountsTitle => 'Pilihan cepat';

  @override
  String get waterDefaultCupTitle => 'Ukuran cangkir standar';

  @override
  String get waterCustomMl => 'Jumlah kustom';

  @override
  String get waterAddCustom => 'Tambah';

  @override
  String get waterTrackerTitle => 'Asupan air';

  @override
  String waterTrackerSummary(double current, double goal, int percent) {
    return '${current}L / ${goal}L — $percent% tercapai';
  }

  @override
  String get weeklyDeficitChartTitle => 'Keseimbangan kalori mingguan';

  @override
  String get weeklyDeficitSubtitle =>
      'TDEE − makanan + pembakaran kardio (7 hari terakhir)';

  @override
  String weeklyDeficitTotal(int kcal) {
    return 'Keseimbangan bersih mingguan: $kcal kkal';
  }

  @override
  String get weeklyDeficitEmpty =>
      'Catat makanan atau kardio untuk melihat keseimbangan kalori mingguan Anda.';

  @override
  String get weeklyDeficitInProgress => 'Hari ini (sedang berlangsung)';

  @override
  String get progressTrendEmpty => 'Catat 3 hari untuk melihat tren Anda';

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
  String get cookMethodRaw => 'Mentah';

  @override
  String get cookMethodBoiled => 'Rebus';

  @override
  String get cookMethodGrilled => 'Panggang (Grilled)';

  @override
  String get cookMethodFried => 'Goreng';

  @override
  String get cookMethodBaked => 'Panggang oven (Baked)';

  @override
  String get cookMethodSteamed => 'Kukus';

  @override
  String get cookMethodOther => 'Lainnya';

  @override
  String weeklyDeficitTooltip(int net, int consumed, int burned) {
    return '$net kkal\nMasuk: $consumed · Keluar: $burned';
  }

  @override
  String uxGoodMorning(String name) {
    return 'Selamat pagi, $name';
  }

  @override
  String uxGoodAfternoon(String name) {
    return 'Selamat siang, $name';
  }

  @override
  String uxGoodEvening(String name) {
    return 'Selamat malam, $name';
  }

  @override
  String get uxTodayOverline => 'HARI INI';

  @override
  String get uxCaloriesLeft => 'kkal tersisa';

  @override
  String get uxCaloriesOver => 'kkal lebih';

  @override
  String get uxGoal => 'Target';

  @override
  String get uxEaten => 'Dimakan';

  @override
  String get uxBurned => 'Terbakar';

  @override
  String get uxActionScan => 'Pindai makanan';

  @override
  String get uxActionTrain => 'Latihan';

  @override
  String get uxActionCoach => 'AI Coach';

  @override
  String get uxSectionTraining => 'Latihan hari ini';

  @override
  String get uxSectionThisWeek => 'Minggu ini';

  @override
  String get uxSectionTodayLog => 'Catatan hari ini';

  @override
  String get uxAddMeal => '+ Tambah makanan';

  @override
  String get uxAiScanned => 'Pindaian AI';

  @override
  String get uxMealRemoved => 'Makanan dihapus';

  @override
  String get uxLogEmptyTitle => 'Belum ada yang dicatat';

  @override
  String get uxLogEmptyBody =>
      'Ambil foto makanan Anda — AI menghitung kalori dan makronutrisi dalam hitungan detik.';

  @override
  String get uxRestDayHint =>
      'Pemulihan juga bagian dari latihan. Jalan kaki, lakukan peregangan, dan penuhi protein Anda.';

  @override
  String uxWorkoutMinutes(int minutes) {
    return '~$minutes mnt';
  }

  @override
  String get uxWater => 'Air';

  @override
  String get uxGlassSize => '250 ml';

  @override
  String uxWaterAdded(String liters) {
    return '+250 ml · $liters L hari ini';
  }

  @override
  String get uxWaterGoalDone => 'Target air tercapai 💧 kerja bagus!';

  @override
  String get uxUndo => 'Urungkan';

  @override
  String get uxCopied => 'Disalin';

  @override
  String get uxSend => 'Kirim';

  @override
  String get uxQuickLogTitle => 'Catat cepat';

  @override
  String get uxQuickLogSubtitle => 'Catat apa saja dalam satu ketukan.';

  @override
  String get uxQuickScanTitle => 'Pindai makanan dengan AI';

  @override
  String get uxQuickScanSub => 'Kalori & makro dalam hitungan detik';

  @override
  String get uxQuickWater => 'Air';

  @override
  String get uxQuickWaterSub => '+1 gelas · 250 ml';

  @override
  String get uxQuickWeight => 'Berat badan';

  @override
  String get uxQuickWeightSub => 'Catat timbangan hari ini';

  @override
  String get uxQuickCardio => 'Kardio';

  @override
  String get uxQuickCardioSub => 'Jalan, lari, sepeda…';

  @override
  String get uxQuickCoach => 'Tanya pelatih';

  @override
  String get uxQuickCoachSub => 'Saran AI pribadi';

  @override
  String get uxCoachOnline => 'Online · memahami makronutrisi Anda';

  @override
  String get uxCoachTyping => 'Sedang mengetik…';

  @override
  String get uxCoachNewChat => 'Obrolan baru';

  @override
  String get uxCoachClearConfirm =>
      'Mulai percakapan baru? Pesan saat ini akan dihapus.';

  @override
  String get uxCoachHeroTitle => 'Pelatih AI pribadi Anda';

  @override
  String get uxCoachHeroBody =>
      'Tanyakan tentang makanan, protein, keinginan makan (cravings), atau latihan. Setiap jawaban disesuaikan dengan data Anda hari ini.';

  @override
  String uxCoachKcalLeft(int kcal) {
    return 'Tersisa $kcal kkal';
  }

  @override
  String uxCoachProteinLeft(int grams) {
    return 'Tersisa ${grams}g protein';
  }

  @override
  String get uxCoachChipWorkout => 'Apa yang harus saya makan sebelum latihan?';

  @override
  String get uxProtein => 'Protein';

  @override
  String get uxCarbs => 'Karbohidrat';

  @override
  String get uxFat => 'Lemak';

  @override
  String get aiScanAnalysisTitle => 'Analisis AI';

  @override
  String get diaryAddMeal => 'Tambah Makanan';

  @override
  String get diaryAddWorkout => 'Tambah Latihan';

  @override
  String get diaryCaloriesIn => 'Kalori Masuk';

  @override
  String get diaryCaloriesOut => 'Kalori Keluar';

  @override
  String diaryKcal(int kcal) {
    return '$kcal kkal';
  }

  @override
  String diaryLastUpdated(String count) {
    return 'Terakhir diperbarui $count';
  }

  @override
  String diaryMealCalories(int calories) {
    return '$calories kkal';
  }

  @override
  String get diaryNetBalance => 'Keseimbangan Bersih';

  @override
  String get diaryNoEntries => 'Tidak ada entri untuk hari ini';

  @override
  String get diaryProtein => 'Protein';

  @override
  String diaryProteinProgress(int current, int goal) {
    return '$current / $goal g';
  }

  @override
  String get diarySetGoalsCta => 'Atur target';

  @override
  String get diarySetGoalsFirst => 'Atur target Anda terlebih dahulu';

  @override
  String get diaryTimeline => 'Linimasa';

  @override
  String get diaryTitle => 'Buku Harian Saya';

  @override
  String get diaryToday => 'Hari ini';

  @override
  String get diaryWater => 'Air';

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
    return '$minutes mnt · $calories kkal';
  }

  @override
  String get exerciseAdvanced => 'Tingkat Lanjut';

  @override
  String get exerciseBeginner => 'Pemula';

  @override
  String get exerciseComplete => 'Selesaikan Set';

  @override
  String get exerciseDifficulty => 'Tingkat Kesulitan';

  @override
  String get exerciseEquipment => 'Peralatan';

  @override
  String get exerciseIntermediate => 'Menengah';

  @override
  String get exerciseLoadingDemo => 'Memuat demo latihan...';

  @override
  String get exerciseMistakes => 'Kesalahan Umum';

  @override
  String get exerciseReps => 'Repetisi';

  @override
  String get exerciseRest => 'Istirahat';

  @override
  String get exerciseSets => 'Set';

  @override
  String get exerciseSteps => 'Langkah-langkah';

  @override
  String get exerciseTips => 'Tips Pro';

  @override
  String get exerciseViewBack => 'Belakang';

  @override
  String get exerciseViewFront => 'Depan';

  @override
  String get measurements30Days => '30 hari';

  @override
  String get measurements3Months => '3 bulan';

  @override
  String get measurements7Days => '7 hari';

  @override
  String get measurementsAdd => 'Tambah ukuran';

  @override
  String get measurementsAddFirst => 'Catat ukuran tubuh pertama Anda';

  @override
  String get measurementsAll => 'Semua';

  @override
  String get measurementsArms => 'Lengan';

  @override
  String get measurementsBodyFat => '% lemak tubuh';

  @override
  String get measurementsChest => 'Dada';

  @override
  String get measurementsDate => 'Tanggal';

  @override
  String get measurementsDelete => 'Hapus';

  @override
  String get measurementsDeleteConfirm => 'Hapus ukuran ini?';

  @override
  String get measurementsHistory => 'Riwayat';

  @override
  String measurementsLastUpdated(String date) {
    return 'Diperbarui $date';
  }

  @override
  String get measurementsNeedMoreData =>
      'Catat lebih banyak data untuk melihat tren';

  @override
  String get measurementsNoData => 'Belum ada data ukuran';

  @override
  String get measurementsNotes => 'Catatan';

  @override
  String get measurementsSave => 'Simpan';

  @override
  String get measurementsThighs => 'Paha';

  @override
  String get measurementsTitle => 'Ukuran Tubuh';

  @override
  String get measurementsTrendDeclining => 'Perlu perhatian';

  @override
  String get measurementsTrendImproving => 'Meningkat';

  @override
  String get measurementsTrendStable => 'Stabil';

  @override
  String get measurementsWaist => 'Pinggang';

  @override
  String get measurementsWeight => 'Berat badan';

  @override
  String get measurementsWeightInvalid => 'Masukkan berat badan yang valid';

  @override
  String get muscleBack => 'Punggung';

  @override
  String get muscleBiceps => 'Bisep';

  @override
  String get muscleCalves => 'Betis';

  @override
  String get muscleChest => 'Dada';

  @override
  String get muscleCore => 'Otot Inti (Core)';

  @override
  String get muscleForearms => 'Lengan Bawah';

  @override
  String get muscleGlutes => 'Bokong (Glutes)';

  @override
  String get muscleHamstrings => 'Paha Belakang (Hamstrings)';

  @override
  String get muscleHipFlexors => 'Fleksor Pinggul';

  @override
  String get muscleQuads => 'Paha Depan (Quads)';

  @override
  String get muscleShoulders => 'Bahu';

  @override
  String get muscleTriceps => 'Trisep';

  @override
  String get notificationsBreakfast => 'Pengingat sarapan';

  @override
  String get notificationsDinner => 'Pengingat makan malam';

  @override
  String get notificationsLunch => 'Pengingat makan siang';

  @override
  String get notificationsOpenSettings => 'Buka pengaturan';

  @override
  String get notificationsPermissionBanner =>
      'Aktifkan notifikasi agar tetap konsisten';

  @override
  String get notificationsPreWorkout => 'Pengingat pra-latihan';

  @override
  String get notificationsPreWorkoutSubtitle => 'Bersiap untuk berlatih';

  @override
  String get notificationsSleep => 'Pengingat tidur';

  @override
  String get notificationsSleepSubtitle =>
      'Mulai istirahat untuk pemulihan yang lebih baik';

  @override
  String get notificationsTest => 'Kirim notifikasi uji coba';

  @override
  String get notificationsTestBody => 'Pengingat Vireo berfungsi dengan baik';

  @override
  String get notificationsTitle => 'Notifikasi';

  @override
  String get notificationsWater => 'Pengingat minum air';

  @override
  String get notificationsWaterSubtitle => 'Tetap terhidrasi sepanjang hari';

  @override
  String get notificationsWeeklyReport => 'Laporan mingguan';

  @override
  String get notificationsWeeklyReportSubtitle => 'Lihat ringkasan minggu Anda';

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
  String get vitality12WeekProgram => 'Program 12 Minggu';

  @override
  String vitalityArticleCount(int count) {
    return '$count artikel';
  }

  @override
  String get vitalityArticleDisclaimer =>
      'Hanya untuk tujuan edukasi. Konsultasikan dengan profesional untuk saran pribadi.';

  @override
  String get vitalityArticlesSection => 'Artikel';

  @override
  String get vitalityBadgesTitle => 'Lencana';

  @override
  String vitalityBreathingCount(int count) {
    return '$count sesi';
  }

  @override
  String get vitalityBreathingLog => 'Pernapasan';

  @override
  String get vitalityCategoryAdvanced => 'Tingkat Lanjut';

  @override
  String get vitalityCategoryEnvironmental => 'Lingkungan';

  @override
  String get vitalityCategoryLifestyle => 'Gaya Hidup';

  @override
  String get vitalityCategoryNutrition => 'Nutrisi';

  @override
  String get vitalityCategoryTraining => 'Latihan';

  @override
  String get vitalityCheckProtein => 'Penuhi protein';

  @override
  String get vitalityCheckSleep => 'Tidur berkualitas';

  @override
  String get vitalityCheckSunlight => 'Cahaya matahari pagi';

  @override
  String get vitalityCheckWorkout => 'Bergerak / latihan';

  @override
  String get vitalityCheckZincVitD => 'Seng / Vit D';

  @override
  String vitalityDailyChecklistProgress(int done, int total) {
    return '$done/$total selesai';
  }

  @override
  String get vitalityDailyChecklistTitle => 'Daftar tugas hari ini';

  @override
  String get vitalityDailyTipLabel => 'Tips harian';

  @override
  String get vitalityHubSubtitle =>
      'Kebiasaan berbasis sains untuk energi dan pemulihan';

  @override
  String get vitalityHubTitle => 'Pusat Vitalitas';

  @override
  String get vitalityLegendBadge => 'Legenda';

  @override
  String get vitalityLinkCopied => 'Tautan disalin';

  @override
  String get vitalityLogSection => 'Catatan';

  @override
  String get vitalityMarkRead => 'Tandai sudah dibaca';

  @override
  String get vitalityMarkReadDone => 'Dibaca';

  @override
  String get vitalityMarkReadSuccess => 'Ditandai sudah dibaca';

  @override
  String get vitalityMedicalDisclaimer =>
      'Konten edukasi saja — bukan saran medis.';

  @override
  String get vitalityMetricsEmpty => 'Belum ada metrik';

  @override
  String get vitalityMetricsLast7Days => '7 hari terakhir';

  @override
  String vitalityMetricsLastEntry(int score) {
    return 'Entri terakhir · energi $score/10';
  }

  @override
  String get vitalityMetricsSave => 'Simpan metrik';

  @override
  String get vitalityMetricsSaved => 'Disimpan';

  @override
  String get vitalityMetricsTapToLog => 'Ketuk untuk mencatat';

  @override
  String get vitalityMetricsTitle => 'Metrik harian';

  @override
  String get vitalityMorningEnergy => 'Energi pagi';

  @override
  String get vitalityMyProgram => 'Program Saya';

  @override
  String get vitalityNotLogged => 'Belum dicatat';

  @override
  String get vitalityPhaseFoundation => 'Fondasi';

  @override
  String get vitalityPhaseOptimization => 'Optimalisasi';

  @override
  String get vitalityPhasePeak => 'Puncak';

  @override
  String get vitalityProgramAllWeeks => 'Semua minggu';

  @override
  String get vitalityProgramComplete => 'Program selesai';

  @override
  String get vitalityProgramContinue => 'Lanjutkan';

  @override
  String get vitalityProgramDisclaimer =>
      'Program edukasi — bukan perawatan medis.';

  @override
  String get vitalityProgramDone => 'Selesai';

  @override
  String get vitalityProgramOverallProgress => 'Kemajuan keseluruhan';

  @override
  String get vitalityProgramStartCta => 'Mulai program';

  @override
  String get vitalityProgramSubtitle =>
      '12 minggu menuju energi, tidur, dan pemulihan yang lebih baik';

  @override
  String get vitalityProgramTitle => 'Transformasi Vitalitas';

  @override
  String get vitalityProtocolBadgeEarned => 'Lencana terbuka!';

  @override
  String get vitalityProtocolCompleteDay => 'Selesaikan hari';

  @override
  String vitalityProtocolStreak(int days) {
    return 'Rentetan $days hari';
  }

  @override
  String get vitalityProtocolTitle => 'Protokol';

  @override
  String vitalityReadingTime(int minutes) {
    return '$minutes mnt baca';
  }

  @override
  String get vitalityReportCompletion => 'Penyelesaian';

  @override
  String get vitalityReportImproving =>
      'Anda mengalami peningkatan — pertahankan rentetan ini.';

  @override
  String get vitalityReportKeepGoing =>
      'Langkah kecil tetap berarti. Selesaikan beberapa tugas hari ini.';

  @override
  String get vitalityScientificSources => 'Sumber';

  @override
  String vitalityScoreBreakdown(
    int sleep,
    int workout,
    int protein,
    int stress,
  ) {
    return 'Tidur $sleep · Latihan $workout · Protein $protein · Stres $stress';
  }

  @override
  String get vitalityScoreLabel => 'Vitalitas';

  @override
  String get vitalitySleepHint => 'Bagaimana tidur Anda?';

  @override
  String vitalitySleepHours(num hours) {
    return '$hours jam';
  }

  @override
  String get vitalitySleepLog => 'Tidur';

  @override
  String get vitalitySleepQuality => 'Kualitas';

  @override
  String vitalityStreak(int days) {
    return 'Rentetan $days hari';
  }

  @override
  String get vitalityStressLevel => 'Stres';

  @override
  String get vitalityUnlockNextWeek => 'Buka minggu depan';

  @override
  String vitalityWeekProgress(int percent) {
    return '$percent%';
  }

  @override
  String get vitalityWeekReport => 'Laporan minggu';

  @override
  String vitalityWeekX(int week) {
    return 'Minggu $week';
  }

  @override
  String vitalityWeekXOf12(int week) {
    return 'Minggu $week dari 12';
  }

  @override
  String get vitalityWorkoutDone => 'Sudah latihan';

  @override
  String get vitalityWorkoutLog => 'Latihan';

  @override
  String get vitalityWorkoutPending => 'Istirahat / belum';

  @override
  String get vitalityWorkoutPerformance => 'Performa';

  @override
  String walkingEstimatedMinutes(int minutes) {
    return '~$minutes mnt';
  }

  @override
  String get walkingHealthBanner =>
      'Langkah langsung dari pedometer ponsel ini';

  @override
  String get walkingManualStepsLabel => 'Langkah hari ini';

  @override
  String get walkingUpdateSteps => 'Perbarui langkah';

  @override
  String get walkingWebManualBanner => 'Di web, masukkan langkah secara manual';

  @override
  String get vitalityKeyTakeaway => 'Poin penting';

  @override
  String get dietMyPlan => 'Rencana diet saya';

  @override
  String get dietProgramsTitle => 'Program diet';

  @override
  String get dietQuizTitle => 'Kuis rencana diet';

  @override
  String get dietQuizContinue => 'Saya mengerti — lanjutkan';

  @override
  String get dietQuizYes => 'Ya';

  @override
  String get dietQuizNo => 'Tidak';

  @override
  String dietQuizHealthStep(int current, int total) {
    return 'Kesehatan $current dari $total';
  }

  @override
  String dietQuizPrefStep(int current, int total) {
    return 'Preferensi $current dari $total';
  }

  @override
  String get dietPrefBreadRice => 'Apakah Anda suka roti dan nasi?';

  @override
  String get dietPrefSkipBreakfast =>
      'Bisakah Anda melewatkan sarapan dengan nyaman?';

  @override
  String get dietPrefSimpleRules =>
      'Apakah Anda lebih suka aturan makan yang sederhana?';

  @override
  String get dietPrefEatsOut => 'Apakah Anda sering makan di luar?';

  @override
  String get dietPrefWeights => 'Apakah Anda rutin latihan beban?';

  @override
  String get dietRecommendedBadge => 'Direkomendasikan untuk Anda';

  @override
  String get dietActiveBadge => 'Aktif';

  @override
  String get dietNeedsDoctor => 'Memerlukan persetujuan dokter';

  @override
  String get dietReadWarning => 'Baca peringatan';

  @override
  String dietCardMacros(int kcal, int protein) {
    return '$kcal kkal · ${protein}g protein';
  }

  @override
  String get dietHowItWorks => 'Cara kerja';

  @override
  String get dietYourTargets => 'Target Anda';

  @override
  String get dietBestFor => 'Paling cocok untuk';

  @override
  String get dietNotIdealFor => 'Kurang cocok untuk';

  @override
  String get dietRules => 'Aturan';

  @override
  String get dietAllowedFoods => 'Makanan yang dianjurkan';

  @override
  String get dietLimitFoods => 'Batasi ini';

  @override
  String get dietSampleDay => 'Contoh menu harian';

  @override
  String get dietSideEffects => 'Efek samping';

  @override
  String get dietTips => 'Tips';

  @override
  String get dietEvidence => 'Bukti ilmiah';

  @override
  String get dietStopSigns => 'Tanda harus berhenti';

  @override
  String get dietDisclaimer => 'Penafian';

  @override
  String get dietStartProgram => 'Mulai program ini';

  @override
  String get dietDoctorGateTitle => 'Persetujuan dokter diperlukan';

  @override
  String get dietAckWarning => 'Saya sudah membaca peringatan';

  @override
  String get dietMustAckWarning =>
      'Harap konfirmasi bahwa Anda telah membaca peringatan terlebih dahulu';

  @override
  String get dietStartedToast => 'Program diet dimulai';

  @override
  String get dietClose => 'Tutup';

  @override
  String dietCarbsMax(int grams) {
    return 'Batas karbohidrat: $grams g';
  }

  @override
  String dietWeeklyLoss(String kg) {
    return 'Est. penurunan mingguan ≈ $kg kg';
  }

  @override
  String get dietChoosePlanCard => 'Pilih rencana diet Anda';

  @override
  String dietFastingLeft(String time) {
    return 'Puasa — tersisa $time';
  }

  @override
  String dietEatingWindowLeft(String time) {
    return 'Jendela makan — berakhir dalam $time';
  }

  @override
  String dietWindowStartsAt(int hour) {
    return 'Jendela makan dimulai pukul $hour:00';
  }

  @override
  String get dietEditWindow => 'Ubah jam mulai';

  @override
  String get dietCarbsLimitLabel => 'Batas karbohidrat';

  @override
  String dietCarbsLimitProgress(int current, int max) {
    return '$current / $max g karbohidrat';
  }

  @override
  String get todayPlanTitle => 'RENCANA HARI INI';

  @override
  String todayPlanProgressSummary(int percent, int done, int total) {
    return 'Anda telah menyelesaikan $percent% hari Anda · $done/$total item';
  }

  @override
  String get todayPlanNow => 'Sekarang';

  @override
  String get todayPlanPro => 'PRO';

  @override
  String todayPlanWaterReminder(int index, int total) {
    return 'Pengingat minum air $index dari $total';
  }

  @override
  String todayPlanWaterGoalLine(int ml) {
    return 'Target harian $ml ml';
  }

  @override
  String get todayPlanFastingOpen => 'Jendela makan dibuka';

  @override
  String todayPlanFastingOpenSubtitle(int hours) {
    return 'Jendela makan $hours jam dimulai';
  }

  @override
  String get todayPlanFastingClose => 'Jendela makan ditutup';

  @override
  String todayPlanFastingCloseSubtitle(int hours) {
    return 'Puasa $hours jam dimulai';
  }

  @override
  String get todayPlanWorkout => 'Latihan hari ini';

  @override
  String get todayPlanSteps => 'Target langkah';

  @override
  String todayPlanStepsProgress(int current, int goal) {
    return '$current / $goal langkah';
  }

  @override
  String get todayPlanVitalitySleepSubtitle => 'Catat 7,5+ jam di Vitalitas';

  @override
  String get todayPlanVitalityProteinSubtitle => 'Capai target protein Anda';

  @override
  String get todayPlanVitalitySunSubtitle => 'Paparan sinar matahari pagi';

  @override
  String get todayPlanVitalityStress => 'Reset stres';

  @override
  String get todayPlanVitalityStressSubtitle => 'Catat sesi pernapasan';

  @override
  String get todayPlanVitalityZincSubtitle =>
      'Seng & vitamin D dari makanan alami';

  @override
  String get todayPlanSleepTarget => 'Target tidur';

  @override
  String get todayPlanSleepTargetSubtitle =>
      'Mulai rileks untuk tidur berkualitas';

  @override
  String get todayPlanProtocolItem => 'Protokol vitalitas';

  @override
  String get todayPlanAiSuggestion => 'Saran pelatih AI';

  @override
  String get todayPlanAiSuggestionSubtitle =>
      'Tips yang dipersonalisasi untuk hari ini';

  @override
  String waterGoalBasedOnWeight(int kg) {
    return 'Berdasarkan berat badan Anda ($kg kg)';
  }

  @override
  String get authErrorEmailRateLimit =>
      'Terlalu banyak email, coba lagi dalam satu jam';

  @override
  String get profileMyBody => 'Tubuh saya';

  @override
  String get profileGuestProgressHint => 'Tamu — kemajuan tidak disimpan';

  @override
  String get profilePlanPro => 'Pro';

  @override
  String get profilePlanFree => 'Gratis';

  @override
  String profileMemberSince(String date) {
    return 'Anggota sejak $date';
  }

  @override
  String get profileSaveProgressCta => 'Simpan kemajuan Anda';

  @override
  String get profileMyPlanSection => 'Rencana saya';

  @override
  String get profileChangeDietPlan => 'Ubah rencana';

  @override
  String get profileBodyMetricsSaved => 'Metrik tubuh diperbarui';

  @override
  String get profileSaveBodyMetrics => 'Simpan';

  @override
  String get profileEditDisplayName => 'Nama tampilan';

  @override
  String get profileDisplayNameHint => 'Nama Anda';

  @override
  String get profileFitnessGoal => 'Tujuan';

  @override
  String get activityHubTitle => 'Aktivitas & Kesehatan';

  @override
  String get activityHubSubtitle =>
      'Latihan GPS, metrik wearable, dan panduan pernapasan — di ponsel, didukung jam tangan.';

  @override
  String get activityHealthHomeCardTitle => 'Aktivitas & Kesehatan';

  @override
  String get activityHealthHomeCardSubtitle =>
      'Hubungkan jam tangan Anda atau mulai latihan luar ruangan';

  @override
  String get outdoorWorkoutTitle => 'Latihan luar ruangan';

  @override
  String get outdoorWorkoutSubtitle =>
      'Jalan kaki, lari, atau bersepeda dengan peta GPS dan panduan suara';

  @override
  String get outdoorPickTitle => 'Pilih aktivitas';

  @override
  String get outdoorPickSubtitle =>
      'Pelacakan GPS hanya berjalan selama sesi Anda.';

  @override
  String get outdoorTypeWalk => 'Jalan kaki';

  @override
  String get outdoorTypeRun => 'Lari';

  @override
  String get outdoorTypeCycle => 'Bersepeda';

  @override
  String get outdoorGo => 'Mulai!';

  @override
  String get outdoorLocationDenied =>
      'Izin lokasi diperlukan untuk latihan dengan GPS.';

  @override
  String get outdoorDistance => 'Jarak';

  @override
  String get outdoorDuration => 'Durasi';

  @override
  String get outdoorPace => 'Pace';

  @override
  String get outdoorSpeed => 'Kecepatan';

  @override
  String outdoorPaceMinKm(int min, int sec) {
    return '$min:$sec / km';
  }

  @override
  String outdoorSpeedKmh(String speed) {
    return '$speed km/j';
  }

  @override
  String outdoorCalories(int kcal) {
    return '$kcal kkal terbakar';
  }

  @override
  String get outdoorPause => 'Jeda';

  @override
  String get outdoorResume => 'Lanjutkan';

  @override
  String get outdoorHoldToStop => 'Tahan untuk berhenti';

  @override
  String get outdoorStopTitle => 'Akhiri latihan?';

  @override
  String get outdoorStopBody => 'Rute dan statistik Anda akan disimpan.';

  @override
  String get outdoorStopConfirm => 'Akhiri';

  @override
  String get outdoorPaused => 'Dijeda';

  @override
  String get outdoorAutoPause => 'Jeda otomatis saat berhenti';

  @override
  String get outdoorHistoryTitle => 'Riwayat latihan';

  @override
  String get outdoorHistorySubtitle => 'Sesi GPS sebelumnya';

  @override
  String get outdoorHistoryEmpty => 'Belum ada latihan luar ruangan.';

  @override
  String get outdoorDetailTitle => 'Detail latihan';

  @override
  String get outdoorSplitsTitle => 'Pecahan per kilometer';

  @override
  String outdoorSplitKm(int km) {
    return 'Km $km';
  }

  @override
  String get uxQuickOutdoor => 'Latihan luar ruangan';

  @override
  String get uxQuickOutdoorSub => 'Jalan, lari, atau bersepeda dengan GPS';

  @override
  String get healthHubTitle => 'Kesehatan';

  @override
  String get healthHubCardSubtitle =>
      'Detak jantung, tidur, SpO₂ dari jam tangan Anda';

  @override
  String get healthHubProgressSubtitle =>
      'Metrik perangkat wearable dan skor tidur';

  @override
  String get healthNotMedical =>
      'Bukan untuk penggunaan medis. Metrik berasal dari jam tangan Anda melalui Health Connect / Apple Health.';

  @override
  String get healthFromWatch => 'Dari jam tangan Anda';

  @override
  String get healthConnectWatchTitle => 'Hubungkan jam tangan Anda';

  @override
  String get healthConnectWatchBody =>
      'Berikan akses ke Health Connect atau Apple Health agar Vireo dapat menampilkan detak jantung, tidur, langkah, dan lainnya. Kami tidak pernah memperkirakan tanda vital dari ponsel.';

  @override
  String get healthGrantPermission => 'Berikan akses kesehatan';

  @override
  String get healthMetricHeartRate => 'Detak jantung';

  @override
  String get healthMetricRestingHr => 'Detak jantung istirahat';

  @override
  String get healthMetricHrv => 'HRV (RMSSD)';

  @override
  String get healthMetricSpO2 => 'Oksigen darah';

  @override
  String get healthMetricSleep => 'Tidur';

  @override
  String get healthMetricWeight => 'Berat badan';

  @override
  String get healthMetricWorkout => 'Latihan';

  @override
  String get healthMetricSteps => 'Langkah';

  @override
  String get healthManualSleepTitle => 'Catatan tidur manual';

  @override
  String get healthManualSleepHint =>
      'Tidak ada data tidur dari wearable — ketuk untuk mencatat waktu tidur dan kualitas';

  @override
  String healthSleepScore(int score) {
    return 'Skor tidur $score';
  }

  @override
  String get healthBedtime => 'Waktu tidur';

  @override
  String get healthWakeTime => 'Waktu bangun';

  @override
  String get healthSleepQuality => 'Kualitas (1–5)';

  @override
  String get healthStressTitle => 'Tingkat stres (HRV)';

  @override
  String get healthStressLow => 'Rendah';

  @override
  String get healthStressMedium => 'Sedang';

  @override
  String get healthStressHigh => 'Tinggi';

  @override
  String healthHrvDetail(int today, int baseline) {
    return 'Hari ini $today md vs acuan 14 hari $baseline md';
  }

  @override
  String get breathingHubTitle => 'Pernapasan';

  @override
  String get breathingHubSubtitle => 'Sesi terpandu untuk pemulihan stres';

  @override
  String get breathingBoxTitle => 'Box breathing 4-4-4-4';

  @override
  String get breathingBoxSubtitle =>
      'Tarik napas, tahan, hembuskan, tahan dengan durasi sama';

  @override
  String get breathing478Title => 'Relaksasi 4-7-8';

  @override
  String get breathing478Subtitle => 'Pola menenangkan sebelum tidur';

  @override
  String breathingMinutes(int min) {
    return '$min mnt';
  }

  @override
  String get breathingSessionTitle => 'Sesi pernapasan';

  @override
  String get breathingInhale => 'Tarik napas';

  @override
  String get breathingHold => 'Tahan';

  @override
  String get breathingExhale => 'Hembuskan';

  @override
  String get breathingRest => 'Istirahat';

  @override
  String get mealReviewTitle => 'Tinjau makanan';

  @override
  String get mealReviewAddItem => 'Tambah item';

  @override
  String get mealReviewSlot => 'Waktu makan';

  @override
  String mealReviewRemaining(int kcal) {
    return 'Sisa anggaran: $kcal kkal';
  }

  @override
  String get mealReviewEstimated => 'perkiraan';

  @override
  String mealReviewKcalApprox(int count) {
    return '≈ $count kcal';
  }

  @override
  String get mealReviewPortionLabel => 'Porsi';

  @override
  String get mealReviewOilPrefix => 'Minyak:';

  @override
  String get mealReviewOilLight => 'sedikit';

  @override
  String get mealReviewOilNormal => 'normal';

  @override
  String get mealReviewOilHeavy => 'banyak';

  @override
  String get mealReviewFamilyPlateToggle => 'Kami berbagi satu piring';

  @override
  String get mealReviewMyShare => 'Bagian saya';

  @override
  String get ramadanWaterTrackerQuestion =>
      'Berapa gelas sejak iftar hingga sahur?';

  @override
  String ramadanWaterGoalSplit(int iftarCups, int eveningCups, int suhoorCups) {
    return 'Iftar: $iftarCups · Malam: $eveningCups · Sahur: $suhoorCups gelas';
  }

  @override
  String get ramadanPrayerCityPickerTitle => 'Pilih kota waktu sholat';

  @override
  String get ramadanPrayerCityCustom => 'Kota lain';

  @override
  String get ramadanCustomCityName => 'Nama kota';

  @override
  String get ramadanCustomCityLat => 'Lintang';

  @override
  String get ramadanCustomCityLng => 'Bujur';

  @override
  String get notificationPostScanTitle => 'Ingin pengingat makan?';

  @override
  String get notificationPostScanBody =>
      'Pengingat lembut untuk makan siang & malam — maks 2/hari, hening 23.00–07.00.';

  @override
  String get notificationPostScanYes => 'Ya, ingatkan';

  @override
  String get notificationPostScanNotNow => 'Nanti saja';

  @override
  String get mealReviewCheckAmount => 'periksa jumlahnya';

  @override
  String get mealReviewSearchFood => 'Cari makanan…';

  @override
  String get mealReviewLogByText => 'Catat lewat teks saja';

  @override
  String get mealLogTextTitle => 'Catat makanan lewat teks';

  @override
  String get mealLogTextHint =>
      'Jelaskan apa yang Anda makan — Bahasa Indonesia atau Inggris.';

  @override
  String get mealLogTextPlaceholder =>
      'Makan 2 telur, roti gandum, dan secangkir teh manis';

  @override
  String get mealLogTextAnalyze => 'Analisis';

  @override
  String get mealVoiceStart => 'Suara';

  @override
  String get mealVoiceListening => 'Mendengarkan…';

  @override
  String get mealVoiceUnavailable =>
      'Input suara tidak tersedia di perangkat ini';

  @override
  String get mealBarcodeTitle => 'Pindai kode batang';

  @override
  String get mealBarcodeFailed =>
      'Tidak dapat menemukan kode batang tersebut. Coba lagi atau catat lewat teks.';

  @override
  String get mealScanHintLabel => 'Tambahkan beberapa kata (opsional)';

  @override
  String get mealScanHintPlaceholder => 'Minyak? Saus? Jenis roti?';

  @override
  String get mealHowCalculated => 'Cara kami menghitung ini';

  @override
  String get plateSizeAskTitle => 'Berapa ukuran piring Anda biasanya?';

  @override
  String get plateSizeSmall => 'Kecil';

  @override
  String get plateSizeMedium => 'Sedang';

  @override
  String get plateSizeLarge => 'Besar';

  @override
  String get inbodyScanTitle => 'Pindai laporan InBody';

  @override
  String get inbodyReviewTitle => 'Tinjau hasil InBody';

  @override
  String get inbodyBodyTitle => 'Komposisi tubuh';

  @override
  String get inbodyAddResult => 'Tambah hasil InBody';

  @override
  String get inbodyPickPdf => 'Pilih PDF';

  @override
  String get inbodyFrameHint =>
      'Posisikan seluruh lembar laporan di dalam bingkai';

  @override
  String get inbodyAnalyzing => 'Membaca laporan Anda…';

  @override
  String get inbodyUnreadable =>
      'Tidak dapat membaca lembar tersebut. Coba foto yang lebih jelas.';

  @override
  String get inbodyScanFailed => 'Pemindaian InBody gagal. Coba lagi.';

  @override
  String get inbodySaved => 'Hasil InBody disimpan';

  @override
  String get inbodyMedicalNote =>
      'Bukan untuk penggunaan medis — hanya untuk pelacakan kebugaran.';

  @override
  String get inbodyTestDate => 'Tanggal tes';

  @override
  String get inbodyDevice => 'Perangkat';

  @override
  String get inbodyWeight => 'Berat badan (kg)';

  @override
  String get inbodySmm => 'Otot rangka (kg)';

  @override
  String get inbodyFatMass => 'Massa lemak (kg)';

  @override
  String get inbodyPbf => '% lemak tubuh';

  @override
  String get inbodyBmi => 'BMI';

  @override
  String get inbodyVisceral => 'Tingkat lemak visceral';

  @override
  String get inbodyBmr => 'BMR (kkal)';

  @override
  String get inbodyScore => 'Skor InBody';

  @override
  String get inbodySave => 'Simpan hasil';

  @override
  String get inbodyEmpty =>
      'Belum ada laporan komposisi tubuh. Pindai lembar InBody untuk memulai.';

  @override
  String get inbodyLatestTitle => 'Laporan terbaru';

  @override
  String get inbodyCompareTitle => 'Bandingkan dua laporan';

  @override
  String get inbodySyncHealth => 'Sinkronkan Health Connect';

  @override
  String get inbodySyncedLabel => 'Disinkronkan dari Health Connect';

  @override
  String inbodySyncResult(int count) {
    return 'Berhasil mengimpor $count catatan Health Connect';
  }

  @override
  String inbodyFromDateLabel(String date) {
    return 'dari InBody Anda pada $date';
  }

  @override
  String get uxQuickInbody => 'Laporan InBody';

  @override
  String get uxQuickInbodySub => 'Pindai lembar hasil';

  @override
  String get mealScanHeroTitle => 'Pindai makanan Anda';

  @override
  String get mealScanHeroSubtitle =>
      'AI mengenali makanan — Anda mengonfirmasi berat gram';

  @override
  String get mealScanTipAbove => 'Ambil foto dari atas';

  @override
  String get mealScanTipWholePlate => 'Seluruh piring terlihat';

  @override
  String get mealScanTipLight => 'Pencahayaan yang cukup';

  @override
  String get mealScanFlashOn => 'Flash menyala';

  @override
  String get mealScanFlashOff => 'Flash mati';

  @override
  String get uxQuickMealText => 'Teks makanan';

  @override
  String get uxQuickMealTextSub => 'Ketik apa yang Anda makan';

  @override
  String get uxQuickBarcode => 'Kode batang';

  @override
  String get uxQuickBarcodeSub => 'Pencarian Open Food Facts';

  @override
  String get mealFavoriteSave => 'Simpan favorit';

  @override
  String get mealFavoriteSaved => 'Disimpan ke favorit';

  @override
  String get mealFavoritesTitle => 'Favorit';

  @override
  String get mealRecentTitle => 'Makanan terbaru';

  @override
  String get mealRelog => 'Catat lagi';

  @override
  String get appearanceTitle => 'Tampilan';

  @override
  String get themeModeSystem => 'Default sistem';

  @override
  String get themeModeLight => 'Mode terang';

  @override
  String get themeModeDark => 'Mode gelap';

  @override
  String get accentThemeTitle => 'Warna aksen';

  @override
  String get accentEmber => 'Ember (Default)';

  @override
  String get accentOcean => 'Samudra';

  @override
  String get accentForest => 'Hutan';

  @override
  String get accentRoyal => 'Royal';

  @override
  String detectedActivity(String activity) {
    return 'Terdeteksi: $activity';
  }

  @override
  String get manualOverride => 'Ubah manual';

  @override
  String get mealClarificationTitle => 'Klarifikasi cepat';

  @override
  String get celebrationWaterTitle => 'Target Hidrasi Tercapai! 💧';

  @override
  String get celebrationProteinTitle => 'Target Protein Terpenuhi! 💪';

  @override
  String get celebrationStepsTitle => 'Target Langkah Selesai! 🏃';

  @override
  String get celebrationWorkoutTitle => 'Latihan Selesai! 🔥';

  @override
  String fatEquivalentApprox(String amount) {
    return '≈ $amount lemak';
  }

  @override
  String fatEquivalentBurned(String amount) {
    return 'Membakar ≈ $amount lemak';
  }

  @override
  String fatEquivalentTodayDeficit(String amount) {
    return 'Defisit hari ini ≈ $amount lemak';
  }

  @override
  String fatEquivalentTodaySurplus(int kcal) {
    return 'Surplus +$kcal kkal';
  }

  @override
  String fatEquivalentDietPlanRate(String daily, String weekly) {
    return '≈ $daily lemak/hari • ≈ $weekly/minggu';
  }

  @override
  String fatEquivalentThisWeek(String amount) {
    return '≈ $amount lemak minggu ini';
  }

  @override
  String get fatEquivalentInfoTitle => 'Setara lemak';

  @override
  String get fatEquivalentInfoBody =>
      'Berat badan nyata di timbangan juga dipengaruhi air dan glikogen, jadi berat harian bisa bergerak berbeda. Ini adalah energi yang setara dengan lemak.';

  @override
  String get fatEquivalentInfoDismiss => 'Mengerti';

  @override
  String get legalTerms => 'Ketentuan';

  @override
  String get legalPrivacy => 'Privasi';

  @override
  String get legalMedicalDisclaimer => 'Penafian Medis';

  @override
  String get welcomeTagline =>
      'Nutrisi pintar dan kebugaran cerdas yang dirancang khusus untuk pria.';

  @override
  String get welcomePillarScannerTitle => 'Pemindai Piring Instan';

  @override
  String get welcomePillarScannerDesc =>
      'Foto makananmu, dapatkan kalori & protein akurat dalam 2 detik';

  @override
  String get welcomePillarPlanTitle => 'Rencana Harian yang Dipersonalisasi';

  @override
  String get welcomePillarPlanDesc =>
      'Target berbasis bukti yang disesuaikan dengan tubuh dan tujuanmu';

  @override
  String get welcomePillarSafetyTitle => 'Nutrisi yang Aman Secara Klinis';

  @override
  String get welcomePillarSafetyDesc =>
      'Panduan yang melindungi metabolisme dan kesehatan menyeluruh';

  @override
  String get onboardingGoalTitle => 'Apa fokus utama Anda?';

  @override
  String get onboardingGoalSubtitle =>
      'Pilih yang paling penting. Kami akan menyusun target harian Anda di sekitarnya.';

  @override
  String get goalLoseFatTitle => 'Membakar Lemak';

  @override
  String get goalLoseFatSubtitle =>
      'Bakar lemak membandel sambil menjaga massa otot yang berharga';

  @override
  String get goalBuildMuscleTitle => 'Membangun Otot';

  @override
  String get goalBuildMuscleSubtitle =>
      'Maksimalkan pertumbuhan otot tanpa lemak dengan protein optimal';

  @override
  String get goalMoreEnergyTitle => 'Lebih Banyak Energi';

  @override
  String get goalMoreEnergySubtitle =>
      'Hilangkan rasa lelah di siang hari dan tingkatkan stamina harian';

  @override
  String get goalAllOfAboveTitle => 'Semua di Atas';

  @override
  String get goalAllOfAboveSubtitle =>
      'Rekomposisi tubuh total: kurangi lemak, tambah kekuatan, dan bertenaga';

  @override
  String get onboardingBodyTitle => 'Profil Tubuh Anda';

  @override
  String get onboardingBodySubtitle =>
      'Metrik yang akurat memungkinkan kami menghitung pembakaran kalori harian Anda secara tepat.';

  @override
  String get sexMale => 'Pria';

  @override
  String get sexFemale => 'Wanita';

  @override
  String get unitMetric => 'Metrik';

  @override
  String get unitImperial => 'Imperial (lb)';

  @override
  String get bodyMetricAge => 'Usia';

  @override
  String bodyMetricYears(int age) {
    return '$age tahun';
  }

  @override
  String get selectAgeTitle => 'Pilih Usia';

  @override
  String ageYearsSuffix(int age) {
    return '$age thn';
  }

  @override
  String get bodyMetricHeight => 'Tinggi Badan';

  @override
  String get selectHeightTitle => 'Pilih Tinggi Badan';

  @override
  String get bodyMetricCurrentWeight => 'Berat Badan Saat Ini';

  @override
  String get selectCurrentWeightTitle => 'Pilih Berat Badan Saat Ini';

  @override
  String get bodyMetricTargetWeight => 'Target Berat Badan';

  @override
  String get selectTargetWeightTitle => 'Pilih Target Berat Badan';

  @override
  String get pickerDone => 'Selesai';

  @override
  String get onboardingActivityTitle => 'Aktivitas & Tempat Latihan';

  @override
  String get onboardingActivitySubtitle =>
      'Kami mengkalibrasi pembakaran kalori harian dan merekomendasikan latihan optimal.';

  @override
  String get dailyActivityLevelHeader => 'TINGKAT AKTIVITAS HARIAN';

  @override
  String get activitySedentaryTitle => 'Kurang Bergerak / Kerja Meja';

  @override
  String get activitySedentarySubtitle =>
      'Jarang berjalan, kerja di meja, kurang dari 5.000 langkah';

  @override
  String get activityModeratelyActiveTitle => 'Cukup Aktif';

  @override
  String get activityModeratelyActiveSubtitle =>
      'Sering berdiri/bergerak, 6.000–10.000 langkah sehari';

  @override
  String get activityVeryActiveTitle => 'Sangat Aktif / Kerja Fisik';

  @override
  String get activityVeryActiveSubtitle =>
      'Selalu aktif bergerak atau 12.000+ langkah per hari';

  @override
  String get trainingPlaceHeader => 'DI MANA RENCANA ANDA BERLATIH?';

  @override
  String get trainingPlaceGymTitle => 'Gym';

  @override
  String get trainingPlaceGymSubtitle =>
      'Akses penuh ke barbel, mesin & dumbel';

  @override
  String get trainingPlaceHomeTitle => 'Di Rumah';

  @override
  String get trainingPlaceHomeSubtitle =>
      'Beban tubuh, tali resistensi, atau dumbel ringan';

  @override
  String get trainingPlaceWalkingTitle => 'Jalan Kaki';

  @override
  String get trainingPlaceWalkingSubtitle =>
      'Langkah kardio & rutinitas jalan santai di luar ruangan';

  @override
  String get onboardingHealthSafetyTitle => 'Pemeriksaan Keamanan Kesehatan';

  @override
  String get onboardingHealthSafetySubtitle =>
      'Pilih kondisi yang sesuai agar mesin kami dapat menjaga keselamatan Anda.';

  @override
  String get healthSafetyNoneApply => 'Tidak ada yang berlaku untuk saya';

  @override
  String get healthSafetyOrSelect => 'ATAU PILIH YANG SESUAI';

  @override
  String get onboardingTryScanTitle => 'Rasakan Pemindaian Instan';

  @override
  String get onboardingTryScanSubtitle =>
      'Lihat betapa mudahnya Vireo membagi makanan menjadi kalori dan nutrisi.';

  @override
  String get tryScanSamplePlateTitle => 'Contoh Piring Tinggi Protein';

  @override
  String get tryScanSamplePlateDesc =>
      'Ayam Panggang, Nasi Putih & Salad Segar';

  @override
  String get tryScanAnalyzing => 'Menganalisis Piring...';

  @override
  String get tryScanSampleCta => 'Pindai Contoh Piring (Instan)';

  @override
  String get tryScanOrTestLive => 'ATAU COBA LANGSUNG';

  @override
  String get tryScanOwnMealTitle => 'Pindai Makanan Anda Sendiri';

  @override
  String get tryScanOwnMealDesc => 'Ambil foto langsung dari piring Anda';

  @override
  String get onboardingPlanRevealTitle => 'Rencana Khusus Anda';

  @override
  String get onboardingPlanRevealSubtitle =>
      'Dirancang khusus untuk profil metabolisme dan target kebugaran Anda.';

  @override
  String get planRevealStartPlan => 'Mulai Rencana Saya';

  @override
  String get planRevealProjectedPace => 'KECEPATAN YANG DIPERKIRAKAN';

  @override
  String get planRevealSteadyRecomp => 'Rekomposisi tubuh bertahap';

  @override
  String planRevealFatLossPace(String amount) {
    return '-$amount kg / minggu pembakaran lemak';
  }

  @override
  String planRevealLeanMassPace(String amount) {
    return '+$amount kg / minggu massa otot tanpa lemak';
  }

  @override
  String get planRevealDailyCalories => 'TARGET KALORI HARIAN';

  @override
  String get planRevealPersonalizedBadge => 'Dipersonalisasi';

  @override
  String get planRevealKcalPerDay => 'kkal / hari';

  @override
  String get planRevealDailyProtein => 'PROTEIN HARIAN';

  @override
  String get planRevealGramPerDay => 'g / hari';

  @override
  String get planRevealHydration => 'HIDRASI';

  @override
  String get planRevealDailySteps => 'LANGKAH HARIAN';

  @override
  String get planRevealStepsPerDay => 'langkah / hari';

  @override
  String get planRevealDietProtocol => 'PROTOKOL DIET';

  @override
  String get planRevealOptimalMatch => 'Pilihan paling optimal';

  @override
  String get planRevealBalancedPlanDefault => 'Rencana Defisit Seimbang';

  @override
  String get onboardingNotificationsTitle => 'Jangan Lewatkan Target';

  @override
  String get onboardingNotificationsSubtitle =>
      'Pengingat yang tepat menjaga catatan makanan, hidrasi, dan latihan Anda tetap sesuai jalur.';

  @override
  String get notificationsHeroTitle => 'Dibuat untuk Disiplin, Bukan Spam';

  @override
  String get notificationsHeroBody =>
      'Pengguna yang mengaktifkan pengingat 3,4 kali lebih mungkin mencapai target berat badan mereka.';

  @override
  String get notificationsMealLoggingTitle => 'Pencatatan Makanan';

  @override
  String get notificationsMealLoggingDesc =>
      'Pengingat tepat waktu sekitar makan siang dan malam';

  @override
  String get notificationsWorkoutSessionTitle => 'Sesi Latihan Harian';

  @override
  String get notificationsWorkoutSessionDesc =>
      'Tetap berkomitmen pada jadwal latihan Anda';

  @override
  String get notificationsWeeklyReviewTitle => 'Tinjauan Kemajuan Mingguan';

  @override
  String get notificationsWeeklyReviewDesc =>
      'Timbang badan mingguan & ringkasan penyesuaian';

  @override
  String get notificationsEnableButton => 'Aktifkan Pengingat';

  @override
  String get notificationsMaybeLater => 'Mungkin Nanti';

  @override
  String get onboardingPaywallTitle => 'Percepat Hasil Anda';

  @override
  String get onboardingPaywallSubtitle =>
      'Buka pemindaian piring tanpa batas, latihan AI lengkap, dan analitik tingkat lanjut.';

  @override
  String get paywallProBadge => 'Vireo Pro';

  @override
  String get paywallFeatureUnlimitedScansDesc =>
      'Tanpa khawatir tentang batasan harian';

  @override
  String get paywallFeatureSmartSub =>
      'Substitusi Cerdas AI & Persiapan Makanan';

  @override
  String get paywallFeatureSmartSubDesc =>
      'Pengganti ramah makro instan untuk hidangan lokal';

  @override
  String get paywallFeatureAdaptiveSplits => 'Program Latihan Adaptif Khusus';

  @override
  String get paywallFeatureAdaptiveSplitsDesc =>
      'Pelacakan beban progresif untuk gym atau rumah';

  @override
  String get paywallPlanAnnualPrice => '\$4.99 / bln';

  @override
  String get paywallPlanAnnualSubtext => 'Ditagih tahunan (Hemat 50%)';

  @override
  String get paywallBadgeBestValue => 'PENAWARAN TERBAIK';

  @override
  String get paywallPlanMonthlyPrice => '\$9.99 / bln';

  @override
  String get paywallPlanMonthlySubtext => 'Ditagih bulanan';

  @override
  String get paywallStartTrialCta => 'Mulai Uji Coba Gratis 7 Hari';

  @override
  String get paywallContinueFreeTier => 'Lanjutkan dengan Paket Gratis';

  @override
  String get appInitErrorFailed => 'Gagal menginisialisasi layanan aplikasi.';

  @override
  String get appInitRetry => 'Coba Lagi';

  @override
  String get privacyExportTitle => 'Ekspor Data Saya';

  @override
  String get privacyExportReady =>
      'Paket data Anda siap dalam format JSON & CSV:';

  @override
  String get weeklyProgressShareFailed =>
      'Tidak dapat membuat gambar untuk dibagikan';

  @override
  String get adaptiveCalorieCurrentTarget => 'Target Saat Ini';

  @override
  String get adaptiveCalorieSuggestedTarget => 'Target yang Disarankan';

  @override
  String get adaptiveCalorieWindowSpan => 'Rentang waktu';

  @override
  String get adaptiveCalorieFoodLogsCount => 'Jumlah hari log makanan';

  @override
  String get adaptiveCalorieWeighInsCount => 'Jumlah penimbangan';

  @override
  String get adaptiveCalorieAverageIntake => 'Asupan rata-rata';

  @override
  String get adaptiveCalorieTrendWeightChange => 'Perubahan tren berat badan';

  @override
  String get adaptiveCalorieEstimatedMaintenance => 'Estimasi pemeliharaan';

  @override
  String get adaptiveCalorieWeeklyChangeCap => 'Batas perubahan mingguan';

  @override
  String get adaptiveCalorieSafetyFloorApplied => 'Batas aman diterapkan';

  @override
  String get chartSevenDayTrend => 'Tren 7 Hari';

  @override
  String get chartThirtyDayTrend => 'Tren 30 Hari';

  @override
  String get chartRawDot => 'Titik Mentah';

  @override
  String get chartTrendLine => 'Garis Tren';

  @override
  String get chartGoalLine => 'Garis Sasaran';

  @override
  String get scanSourceSheetTitle => 'Pilih Metode Pencatatan';

  @override
  String get scanSourceCamera => 'Ambil foto dengan kamera';

  @override
  String get scanSourceGallery => 'Pilih dari galeri';

  @override
  String get scanSourceText => 'Tulis makanan';

  @override
  String get scanSourceFridgeTitle => 'Pindai Kulkas atau Dapur';

  @override
  String get scanSourceInBodyTitle => 'Unggah Laporan InBody';

  @override
  String get todayPlanMorning => 'Pagi';

  @override
  String get todayPlanAfternoon => 'Siang';

  @override
  String get todayPlanEvening => 'Malam';

  @override
  String get todayPlanWaterQuickAdd => '+250 ml';

  @override
  String todayPlanWaterProgress(String current, String goal) {
    return '$current / $goal L';
  }

  @override
  String get todayPlanSleepLogTitle => 'Catatan Tidur Berkualitas';

  @override
  String todayPlanSleepDuration(String hours) {
    return '$hours jam tidur';
  }

  @override
  String get todayPlanSleepLogSave => 'Simpan Tidur';

  @override
  String get todayPlanSleepMarkDone => 'Selesai (7+ jam tidur)';

  @override
  String get todayPlanSleepQuality => 'Kualitas Tidur';

  @override
  String get todayPlanSupplements => 'Suplemen Harian';

  @override
  String get todayPlanBreathingAction => 'Sesi Pernapasan';

  @override
  String get stepsHeroTitle => 'Langkah Hari Ini';

  @override
  String get stepsEnableButton => 'Aktifkan Penghitung Langkah';

  @override
  String get stepsPermissionTitle => 'Pelacakan Langkah Akurat';

  @override
  String get stepsPermissionBody =>
      'Vireo menggunakan sensor gerak bawaan perangkat Anda untuk menghitung langkah secara akurat sepanjang hari tanpa menguras baterai.';

  @override
  String get stepsPermissionGrant => 'Aktifkan Sekarang';

  @override
  String get stepsActiveMinutes => 'Menit Aktif';

  @override
  String stepsFatBurned(String grams) {
    return '≈ ${grams}g Lemak';
  }

  @override
  String stepsKm(String km) {
    return '$km km';
  }

  @override
  String get stepsDetailTitle => 'Langkah & Berjalan';

  @override
  String get stepsHourlyTitle => 'Rincian Per Jam';

  @override
  String stepsStreakDays(int days) {
    return 'Streak $days Hari';
  }

  @override
  String stepsBestDay(String steps) {
    return 'Hari Terbaik: $steps langkah';
  }

  @override
  String get stepsWeekTab => 'Minggu';

  @override
  String get stepsMonthTab => 'Bulan';

  @override
  String get mealReviewItemQty => 'Jumlah';

  @override
  String mealReviewConfidence(int pct) {
    return '$pct% keyakinan';
  }

  @override
  String get mealReviewSourceUsda => 'Basis Data USDA';

  @override
  String get mealReviewSourceEgypt => 'Tabel Makanan Mesir';

  @override
  String get mealReviewSourceAi => 'Estimasi AI Vision';

  @override
  String get mealReviewUnitPiece => 'buah';

  @override
  String get mealReviewUnitHandful => 'genggam';

  @override
  String get mealReviewUnitGrams => 'g';

  @override
  String get mealReviewCookingRaw => 'Mentah';

  @override
  String get mealReviewCookingBoiled => 'Rebus';

  @override
  String get mealReviewCookingGrilled => 'Panggang';

  @override
  String get mealReviewCookingFried => 'Goreng (+minyak)';

  @override
  String get mealReviewCookingBaked => 'Panggang Oven';

  @override
  String mealReviewCaloriesFormat(int count) {
    return '$count kkal';
  }

  @override
  String mealReviewProteinFormat(int count) {
    return '${count}g protein';
  }

  @override
  String mealReviewCarbsFormat(int count) {
    return '${count}g karbohidrat';
  }

  @override
  String mealReviewFatFormat(int count) {
    return '${count}g lemak';
  }

  @override
  String get cuisineSettingTitle => 'Masakan';

  @override
  String get cuisineEgyptian => 'Mesir';

  @override
  String get cuisineSaudi => 'Saudi & Teluk';

  @override
  String get cuisineLevantine => 'Levant';

  @override
  String get cuisineMoroccan => 'Maroko & Maghribi';

  @override
  String get cuisineTurkish => 'Turki';

  @override
  String get cuisineIndian => 'India & Pakistan';

  @override
  String get cuisineIndonesian => 'Indonesia';

  @override
  String get cuisineWestern => 'Barat / Mediterania';

  @override
  String dietProgramFitReason(String reason) {
    return 'Sesuai dengan target Anda: $reason';
  }

  @override
  String get exerciseMusclesTargeted => 'Otot Target';

  @override
  String get exerciseStepsTitle => 'Langkah Gerakan';

  @override
  String get exerciseCommonMistakes => 'Kesalahan Umum';

  @override
  String get exerciseBreathingCue => 'Teknik Pernapasan';

  @override
  String get exerciseEasierVariation => 'Variasi Lebih Mudah';

  @override
  String get exerciseHarderVariation => 'Variasi Lebih Sulit';

  @override
  String get exerciseSafetyNote => 'Catatan Keselamatan';

  @override
  String get exerciseWarmUpHeader => 'Gerakan Pemanasan';

  @override
  String get reassessmentLaterSnooze => 'Nanti (ingatkan dalam 3 hari)';

  @override
  String get measurementsAddEntry => 'Tambah Pengukuran Baru';

  @override
  String get walkingStopSessionTitle => 'Stop walking session?';

  @override
  String get walkingStopSessionDesc =>
      'Would you like to save or end the current walking session?';

  @override
  String get walkingSessionContinue => 'Continue';

  @override
  String get walkingSessionEnd => 'End Session';

  @override
  String get walkingEditGoalTitle => 'Edit Daily Step Goal';

  @override
  String get walkingTargetStepsLabel => 'Target Steps';

  @override
  String get walkingStepsSuffix => 'steps';

  @override
  String get walkingScreenTitle => 'Walking & Activity';

  @override
  String get walkingDiagnosticsTooltip => 'Step Diagnostics';

  @override
  String get walkingRefreshTooltip => 'Refresh';

  @override
  String get walkingStartGps => 'Start GPS';

  @override
  String get walkingActivityHistory => 'Movement & Step History';

  @override
  String get walkingFilterDay => 'Day';

  @override
  String get walkingFilterWeek => 'Week';

  @override
  String get walkingFilterMonth => 'Month';

  @override
  String get walkingAchievementsTitle => 'Achievements & Records 🏆';

  @override
  String get stepToggleError =>
      'Gagal mengubah status penghitung langkah, silakan coba lagi';

  @override
  String get scoreInsightsTitle => 'Skor & Wawasan Pintar 🎯';

  @override
  String scoreInsightsTodaySummary(int eaten, int target) {
    return 'Hari ini: mengonsumsi $eaten dari $target kkal';
  }

  @override
  String scoreInsightsWeekFatSummary(int grams) {
    return 'Minggu ini: turun ≈ ${grams}g lemak';
  }

  @override
  String scoreInsightsGoalWeeksSummary(String weeks) {
    return 'Capai target dalam ≈ $weeks minggu';
  }

  @override
  String get scoreInsightsActionLogProtein => 'Catat makanan tinggi protein';

  @override
  String get scoreInsightsActionWalk => 'Mulai berjalan menuju target';

  @override
  String get scoreInsightsActionWater => 'Minum segelas air sekarang';

  @override
  String get scoreInsightsPredictionsTitle => 'Prediksi Pintar (Perkiraan 🔮)';

  @override
  String get scoreInsightsPredictionsSubtitle =>
      'Berdasarkan defisit kalori dan laju metabolisme';

  @override
  String scoreInsightsNeedData(int days) {
    return 'Perlu minimal 3 hari lengkap ($days tercatat)';
  }

  @override
  String get scoreInsightsWeeklyFatLoss => 'Penurunan Lemak Mingguan';

  @override
  String get scoreInsightsIn4Weeks => 'Dalam 4 Minggu';

  @override
  String get scoreInsightsIn8Weeks => 'Dalam 8 Minggu';

  @override
  String get scoreInsightsGoalHitIn => 'Capai Target Dalam';

  @override
  String get scoreInsightsClampWarning =>
      '⚠️ Penurunan dibatasi hingga ≤1% berat badan per minggu untuk menjaga otot.';

  @override
  String get scoreInsightsAggressiveDeficitWarning =>
      '⚠️ Defisit melebihi 1.000 kkal/hari. Makan sedikit lebih banyak untuk menjaga metabolisme.';

  @override
  String get scoreInsightsHowCalculatedTitle =>
      'Bagaimana ini dihitung? (Mifflin-St Jeor)';

  @override
  String scoreInsightsHowCalculatedBmr(String bmr) {
    return '• Laju Metabolisme Basal (BMR): $bmr kkal';
  }

  @override
  String scoreInsightsHowCalculatedTdee(String tdee) {
    return '• Pengeluaran Energi Harian Total (TDEE): $tdee kkal';
  }

  @override
  String get scoreInsightsHowCalculatedFat =>
      '• Defisit 7.700 kkal ≈ 1 kg lemak tubuh.';

  @override
  String get scoreInsightsBodyCompTitle => 'Komposisi Tubuh';

  @override
  String get scoreInsightsBodyCompNewMeasure => 'Pengukuran Baru';

  @override
  String get scoreInsightsBodyCompPrompt =>
      'Pantau lemak dan otot dengan pita ukur atau InBody';

  @override
  String get scoreInsightsEnergyBalanceTitle =>
      'Keseimbangan Energi (Masuk vs Terbakar)';

  @override
  String get scoreInsightsEatenKcal => 'Masuk';

  @override
  String get scoreInsightsBurnedKcal => 'Terbakar';

  @override
  String get scoreInsightsMacrosTitle => 'Makro Hari Ini (Target vs Aktual)';

  @override
  String get scoreInsightsScoreTrendTitle => 'Tren Skor 7 Hari';

  @override
  String get scoreInsightsImmediateActionsTitle =>
      'Langkah cepat tingkatkan skor:';

  @override
  String stepMilestoneToast25(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'Strong start, champion! 👏',
      'other': 'Strong start, champion! 👏',
    });
    return '$_temp0';
  }

  @override
  String stepMilestoneToast50(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'Halfway there, champion! 💪',
      'other': 'Halfway there, champion! 💪',
    });
    return '$_temp0';
  }

  @override
  String stepMilestoneToast75(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'Almost there, champion! 🔥',
      'other': 'Almost there, champion! 🔥',
    });
    return '$_temp0';
  }

  @override
  String stepMilestoneToast100(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'Incredible job! Daily goal crushed 🏆',
      'other': 'Incredible job! Daily goal crushed 🏆',
    });
    return '$_temp0';
  }

  @override
  String get livingBackgroundsTitle => 'Living Backgrounds';

  @override
  String get livingBackgroundsSubtitle =>
      'Dynamic scenes evolving with your steps & rotating every 3 days';

  @override
  String get livingBackgroundsEnable => 'Enable Living Backgrounds';

  @override
  String get livingBackgroundsSceneLock => 'Lock Scene';

  @override
  String get livingBackgroundsAutoRotate => 'Rotate every 3 days';

  @override
  String get livingBackgroundsPreview => 'Live Scene Preview';

  @override
  String livingBackgroundsUnlockForCoins(int coins) {
    return 'Unlock for $coins coins';
  }

  @override
  String get livingBackgroundsUnlocked => 'Unlocked';

  @override
  String get workoutRpeSubtitle =>
      'Seberapa berat rasanya? 1 = sangat mudah, 10 = sangat berat';

  @override
  String workoutRpeLabel(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      '1': 'Sangat mudah',
      '2': 'Mudah',
      '3': 'Cukup mudah',
      '4': 'Ringan',
      '5': 'Sedang',
      '6': 'Agak berat',
      '7': 'Berat',
      '8': 'Sulit',
      '9': 'Sangat sulit',
      'other': 'Sangat berat',
    });
    return '$_temp0';
  }

  @override
  String get workoutRpeFeelingsTitle => 'Bagaimana perasaanmu?';

  @override
  String get workoutFeelTired => 'Kelelahan';

  @override
  String get workoutFeelJointPain => 'Nyeri sendi';

  @override
  String workoutFeelHappy(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'Senang',
      'other': 'Senang',
    });
    return '$_temp0';
  }

  @override
  String get workoutFeelEnergized => 'Energi tinggi';

  @override
  String get workoutRpeNoteHint => 'Tambahkan catatan (opsional)';

  @override
  String get workoutRpeSave => 'Simpan';

  @override
  String get workoutRpeDone => 'Selesai';

  @override
  String get workoutRpeSavedTitle => 'Tersimpan ✅';

  @override
  String get workoutRpeCommentJoint =>
      'Nyeri sendi adalah sinyal yang perlu dihargai. Ringankan beban di sesi berikutnya dan fokus pada teknik.';

  @override
  String get workoutRpeCommentHard =>
      'Latihan hari ini berat. Lain kali bebannya kita turunkan sedikit agar pemulihanmu baik.';

  @override
  String get workoutRpeCommentBetter =>
      'Performamu makin baik! Latihan yang sama terasa lebih ringan dari terakhir kali 💪';

  @override
  String get workoutRpeCommentEasy =>
      'Terasa mudah. Di sesi berikutnya bebannya kita naikkan sedikit.';

  @override
  String get workoutRpeCommentSteady =>
      'Usaha yang pas. Pertahankan ritme ini.';

  @override
  String get workoutRpeCommentPartial =>
      'Set yang sudah kamu selesaikan tetap dihitung. Kita kembali lebih kuat di sesi berikutnya.';

  @override
  String get foodFactCardTitle => 'Fakta makanan';

  @override
  String get foodFactShareHint => 'Ketuk untuk membagikan kartu';

  @override
  String get ramadanGuideTitle => 'Panduan Ramadan';

  @override
  String get ramadanGuideOpenHint => 'Peringkat sahur & tempo iftar — ketuk';

  @override
  String get ramadanSuhoorRankTitle => 'Peringkat kenyang sahur';

  @override
  String ramadanSuhoorRankSubtitle(int grams, int kcal) {
    return 'Contoh porsi $grams g · ≈ $kcal kkal';
  }

  @override
  String get ramadanIftarPaceTitle => 'Tempo iftar';

  @override
  String get ramadanIftarStep1 => 'Kurma + air dulu';

  @override
  String get ramadanIftarStep2 => 'Sup hangat';

  @override
  String get ramadanIftarStep3 => 'Tunggu 15 menit';

  @override
  String get ramadanIftarStep4 => 'Hidangan utama';

  @override
  String get ramadanReboundTitle => 'Setelah Ramadan';

  @override
  String ramadanReboundBody(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female':
          'Kembali pelan: protein sahur, catat iftar tanpa rasa bersalah, tambah jalan 10 menit seminggu sebelum potong kalori besar.',
      'other':
          'Kembali pelan: protein sahur, catat iftar tanpa rasa bersalah, tambah jalan 10 menit seminggu sebelum potong kalori besar.',
    });
    return '$_temp0';
  }

  @override
  String get settingsMySubscription => 'Langganan saya';

  @override
  String get settingsMySubscriptionBody =>
      'Batalkan atau ubah paket kapan saja di Google Play.';

  @override
  String get weeklyBurnShareTitle => 'Saldo bakar minggu ini';

  @override
  String get weeklyBurnShareSubtitle => 'Bagikan langkah & streak';

  @override
  String get weeklyBurnShareCaption => 'Minggu saya di Vireo';

  @override
  String get weeklyBurnShareAction => 'Bagikan kartu';

  @override
  String get weeklyBurnShareIncludeWeight => 'Sertakan perubahan berat';

  @override
  String get weeklyBurnShareStepsLabel => 'Langkah minggu ini';

  @override
  String get weeklyBurnShareStreakLabel => 'Streak';

  @override
  String get weeklyBurnShareWeightLabel => 'Perubahan berat';

  @override
  String get widgetCaloriesLeftLabel => 'Kalori tersisa';

  @override
  String get scanLimitTitle => 'Batas pemindaian harian tercapai';

  @override
  String get scanLimitBody => 'Tunggu besok, upgrade Pro, atau catat manual.';

  @override
  String get scanLimitProTitle => 'Vireo Pro';

  @override
  String get scanLimitProSubtitle =>
      'Pemindaian tak terbatas (40/hari), tanpa iklan';

  @override
  String get scanLimitProCta => 'Dapatkan Pro';

  @override
  String get scanLimitWaitTitle => 'Tunggu besok';

  @override
  String get scanLimitWaitSubtitle =>
      'Pemindaian gratis diperbarui tengah malam';

  @override
  String get scanLimitWaitCta => 'Oke, sampai besok';

  @override
  String get scanLimitManualTitle => 'Cari & catat manual';

  @override
  String get scanLimitManualSubtitle => 'Selalu gratis & tak terbatas';

  @override
  String get scanLimitManualCta => 'Catat manual';

  @override
  String get scanLimitAdRewardSnack => '+2 pemindaian ditambahkan hari ini';

  @override
  String get scanLimitAdFailedSnack => 'Iklan gagal dimuat';

  @override
  String get rebalanceCardTitle => 'Today\'s rebalance';

  @override
  String get rebalanceSafeDay => 'You\'re still in the safe zone today';

  @override
  String get rebalanceNeedsTap => 'Nothing changes until you tap an option';

  @override
  String get weeklyBalanceTitle => 'Weekly balance';

  @override
  String get weeklyBalanceEmpty => 'Log a few days to see your weekly balance';

  @override
  String weeklyBalanceOnTrack(int actual, int target) {
    return 'Still on track: weekly deficit $actual of $target';
  }

  @override
  String weeklyBalanceOffTrack(int actual, int target) {
    return 'This week: deficit $actual of $target — we can adjust';
  }

  @override
  String weeklyBalanceCumulative(int kcal) {
    return 'Cumulative: $kcal kcal';
  }

  @override
  String get energyLedgerTitle => 'Your burn balance';

  @override
  String get energyLedgerToday => 'Today';

  @override
  String get energyLedgerWeek => 'Week';

  @override
  String get energyLedgerMonth => 'Month';

  @override
  String get energyLedgerAllTime => 'All time';

  @override
  String energyLedgerBurned(int kcal, String fatKg) {
    return 'Burned $kcal kcal ≈ $fatKg kg fat';
  }

  @override
  String get energyLedgerBalanceNote =>
      'Activity kcal and balance-based fat are labeled separately (estimate)';

  @override
  String energyLedgerStepsDistance(int steps, String km) {
    return '$steps steps · $km km';
  }

  @override
  String get fingerprintTitle => 'Your Fingerprint — Vireo smart system';

  @override
  String get fingerprintSubtitle =>
      'Learned from your real habits after 14 days';

  @override
  String get fingerprintReset => 'Reset';

  @override
  String get fingerprintActivity => 'Your activity';

  @override
  String get fingerprintNutrition => 'Your eating';

  @override
  String get fingerprintTolerance => 'Your tolerance';

  @override
  String get fingerprintChronotype => 'Your timing';

  @override
  String get fingerprintStepsUnit => 'comfortable steps';

  @override
  String fingerprintMealsCount(int count) {
    return '$count meals / day';
  }

  @override
  String fingerprintDeficitValue(int kcal) {
    return 'Sustainable deficit ≈ $kcal kcal';
  }

  @override
  String fingerprintLogHour(int hour) {
    return 'Usually logs around $hour:00';
  }

  @override
  String get fingerprintActivityWhy => 'Why? Median of your best 70% step days';

  @override
  String get fingerprintNutritionWhy =>
      'Why? From your meal times and favorites';

  @override
  String get fingerprintToleranceWhy =>
      'Why? Deficit you sustain without rebound';

  @override
  String get fingerprintChronotypeWhy =>
      'Why? From your logging and walk hours';

  @override
  String get fingerprintEdit => 'Edit';

  @override
  String fingerprintNotReady(int days) {
    return 'Still learning — $days/14 days';
  }

  @override
  String get strideCalibratedBadge => 'Calibrated to your walk ✓';

  @override
  String stepSourceLabel(String source) {
    return 'Source: $source';
  }

  @override
  String get stepSourcePedometer => 'Phone sensor';

  @override
  String get stepSourceHealth => 'Health Connect';

  @override
  String get stepSourceManual => 'Manual';

  @override
  String get stepSourceNone => 'Unavailable';

  @override
  String get eatBackSettingTitle => 'Eat-back from exercise';

  @override
  String get eatBackHalf => '50% (default)';

  @override
  String get eatBackFull => '100%';

  @override
  String get eatBackNone => '0%';

  @override
  String get tdeeCheckInTitle => 'Your plan updated';

  @override
  String get tdeeCheckInUndo => 'Undo';

  @override
  String get missedStepsCardTitle => 'Yesterday\'s steps';

  @override
  String get outdoorNetKcalLabel => 'Net kcal';

  @override
  String get outdoorCadenceLabel => 'Cadence';

  @override
  String get weeklyReviewTitle => 'Weekly review';

  @override
  String get adaptiveTdeeBlendNote => 'Blended from your logs + formula';

  @override
  String get uxStateEmptyTitle => 'Nothing here yet';

  @override
  String get uxStateEmptyMessage =>
      'When you add something, it will show up here.';

  @override
  String get uxStateErrorTitle => 'Something went wrong';

  @override
  String get uxStateErrorMessage => 'We could not load this. Please try again.';

  @override
  String get uxStateOfflineTitle => 'You are offline';

  @override
  String get uxStateOfflineMessage => 'Check your connection, then try again.';

  @override
  String get uxStateRetry => 'Try again';

  @override
  String get designSystemTitle => 'Design system';

  @override
  String get paywallFeatureFairUseScans => '40 plate scans / day (fair use)';

  @override
  String get paywallFeatureFairUseScansDesc =>
      'Unlimited feel for daily logging — fair-use cap of 40 AI scans/day';

  @override
  String get paywallHonestSubtitle =>
      'Pro unlocks fair-use AI scans (40/day), adaptive coach, full Burn Balance history, and an ad-free experience.';

  @override
  String get adaptiveCalorieBasedOnResponse =>
      'Based on your real metabolic response';

  @override
  String adaptiveCalorieDeltaPerDay(String sign, int kcal) {
    return '$sign$kcal kcal/d';
  }

  @override
  String adaptiveCalorieMaintenanceLine(int kcal, int days) {
    return 'Estimated real maintenance: $kcal kcal/day from $days days tracking.';
  }

  @override
  String adaptiveCalorieUpdatedSnack(int kcal) {
    return 'Calorie target updated to $kcal kcal';
  }

  @override
  String get adaptiveCalorieMathFormula =>
      'Maintenance = Avg Intake − (Weight Change kg × 7700 ÷ Days)';

  @override
  String get adaptiveCalorieFloorYes => 'Yes (minimum safety floor)';

  @override
  String get adaptiveCalorieFloorNo => 'No (above safety floor)';

  @override
  String get caloriesEstimatedHint => 'estimated';

  @override
  String homeAteOfGoal(String eaten, String goal) {
    return 'Ate $eaten of $goal';
  }

  @override
  String homeKcalLeft(String kcal) {
    return '$kcal kcal left';
  }

  @override
  String homeKcalOver(String kcal) {
    return '$kcal kcal over';
  }

  @override
  String get cameraPermissionRationaleTitle => 'Akses kamera';

  @override
  String get cameraPermissionRationaleBody =>
      'Vireo memakai kamera hanya saat Anda memotret makanan, InBody, atau progres. Foto dianalisis dan tidak disimpan di server kami setelahnya.';

  @override
  String get microphonePermissionRationaleTitle => 'Akses mikrofon';

  @override
  String get microphonePermissionRationaleBody =>
      'Vireo memakai mikrofon hanya saat pencatatan makanan lewat suara. Audio tetap di perangkat; hanya teks yang dikirim.';

  @override
  String get settingsAboutTitle => 'Tentang';

  @override
  String get settingsDeleteAccountWeb => 'Hapus akun saya (langkah web)';

  @override
  String settingsAppVersionLabel(String version) {
    return 'Versi $version';
  }
}
