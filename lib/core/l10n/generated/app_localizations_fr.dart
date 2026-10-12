// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Vireo';

  @override
  String get homeTitle => 'Accueil';

  @override
  String get onboardingTitle => 'Bienvenue';

  @override
  String get workoutTitle => 'Entraînement';

  @override
  String get nutritionTitle => 'Nutrition';

  @override
  String get progressTitle => 'Progrès';

  @override
  String get profileTitle => 'Profil';

  @override
  String get authTitle => 'Connexion';

  @override
  String get languageToggle => 'English';

  @override
  String get setupComplete => 'Vireo est prêt';

  @override
  String get continueButton => 'Continuer';

  @override
  String get skipButton => 'Passer';

  @override
  String get finishButton => 'Terminer';

  @override
  String get yesButton => 'Oui';

  @override
  String get noButton => 'Non';

  @override
  String onboardingStepProgress(int current, int total) {
    return 'Étape $current sur $total';
  }

  @override
  String get onboardingStep1Title => 'À propos de vous';

  @override
  String get onboardingStep1Subtitle =>
      'Nous personnaliserons votre programme à partir de ces informations de base.';

  @override
  String get onboardingStep2Title => 'Bilan de santé';

  @override
  String get onboardingStep2Subtitle =>
      'Répondez honnêtement — cela nous aide à garantir des entraînements plus sûrs.';

  @override
  String get onboardingStep3Title => 'Lieu d\'entraînement';

  @override
  String get onboardingStep3Subtitle =>
      'Nous n\'afficherons que les exercices adaptés à votre équipement.';

  @override
  String get onboardingStep4Title => 'Votre objectif';

  @override
  String get onboardingStep4Subtitle =>
      'Quel est votre objectif principal en ce moment ?';

  @override
  String get onboardingStep5Title => 'Avant de commencer';

  @override
  String get onboardingStep5Subtitle =>
      'Veuillez lire et accepter les conditions pour continuer.';

  @override
  String get onboardingStep6Title => 'Restez sur la bonne voie';

  @override
  String get onboardingStep6Subtitle =>
      'Rappels optionnels — vous pourrez les modifier ultérieurement.';

  @override
  String get unitsMetric => 'kg / cm';

  @override
  String get unitsImperial => 'lb / po';

  @override
  String get onboardingAge => 'Âge';

  @override
  String get onboardingHeight => 'Taille';

  @override
  String get onboardingWeight => 'Poids';

  @override
  String get onboardingActivityLevel => 'Niveau d\'activité';

  @override
  String get onboardingDietaryOptional =>
      'Restrictions alimentaires (optionnel)';

  @override
  String get activitySedentary => 'Plutôt sédentaire';

  @override
  String get activityModerate => 'Modérément actif';

  @override
  String get activityVeryActive => 'Très actif';

  @override
  String get dietHalal => 'Halal';

  @override
  String get dietVegetarian => 'Végétarien';

  @override
  String get dietVegan => 'Végétalien';

  @override
  String get dietGlutenFree => 'Sans gluten';

  @override
  String get dietDairyFree => 'Sans produits laitiers';

  @override
  String get dietLowSodium => 'Pauvre en sodium';

  @override
  String get dietLowCarb => 'Pauvre en glucides';

  @override
  String get dietDiabeticFriendly => 'Adapté au diabète';

  @override
  String get onboardingMedicalFlagNotice =>
      'Nous adapterons l\'intensité et afficherons des rappels de sécurité pendant vos séances.';

  @override
  String get healthQuestionHeart =>
      'Maladie cardiaque ou problème cardiovasculaire ?';

  @override
  String get healthQuestionDiabetes => 'Diabète ou trouble de la glycémie ?';

  @override
  String get healthQuestionBloodPressure =>
      'Hypertension ou hypotension artérielle ?';

  @override
  String get healthQuestionJoints =>
      'Blessures articulaires ou douleurs chroniques ?';

  @override
  String get healthQuestionMedications =>
      'Prenez-vous des médicaments réguliers actuellement ?';

  @override
  String get envHomeNoEquipment => 'À la maison — sans équipement';

  @override
  String get envHomeNoEquipmentDesc => 'Exercices au poids du corps uniquement';

  @override
  String get envHomeLightEquipment => 'À la maison — équipement léger';

  @override
  String get envHomeLightEquipmentDesc =>
      'Élastiques, haltères ou matériel similaire';

  @override
  String get envGymFull => 'Salle de sport complète';

  @override
  String get envGymFullDesc => 'Machines, barres, rack complet';

  @override
  String get envWalkingOnly => 'Marche uniquement';

  @override
  String get envWalkingOnlyDesc => 'Objectifs de pas et mobilité douce';

  @override
  String get goalWeightLoss => 'Perte de poids';

  @override
  String get goalWeightLossDesc =>
      'Perte de masse grasse avec un entraînement durable';

  @override
  String get goalMuscleGain => 'Prise de muscle';

  @override
  String get goalMuscleGainDesc => 'Focus sur la force et la masse musculaire';

  @override
  String get goalGeneralVitality => 'Vitalité générale';

  @override
  String get goalGeneralVitalityDesc =>
      'Énergie, régularité et bien-être général';

  @override
  String get goalAllOfAbove => 'Tout ce qui précède';

  @override
  String get goalAllOfAboveDesc =>
      'Programme équilibré combinant tous les objectifs';

  @override
  String get legalDisclaimerText =>
      'Vireo est un outil d\'accompagnement sportif et ne remplace en aucun cas un avis médical direct. Le contenu (entraînements, plans de repas et informations de santé) est fourni à titre indicatif uniquement.\n\nSi vous souffrez d\'une maladie chronique — telle qu\'une affection cardiaque, le diabète, l\'hypertension ou des blessures articulaires actuelles — ou si vous prenez des médicaments, consultez votre médecin avant de commencer tout programme d\'exercice ou de nutrition.\n\nLes compléments alimentaires et les conseils relatifs aux hormones (comme la testostérone) constituent de simples informations éducatives générales. Ils ne constituent pas des prescriptions médicales ni des recommandations de traitement.\n\nEn participant à un programme intégré à l\'application, je confirme avoir lu les conditions et comprendre que Vireo ne peut être tenu responsable des blessures ou complications médicales découlant de l\'utilisation de l\'application sans consultation médicale préalable.';

  @override
  String get legalDisclaimerSection1 =>
      'Vireo est un outil d\'accompagnement sportif et ne remplace en aucun cas un avis médical direct. Le contenu (entraînements, plans de repas et informations de santé) est fourni à titre indicatif uniquement.';

  @override
  String get legalDisclaimerSection2 =>
      'Si vous souffrez d\'une maladie chronique — telle qu\'une affection cardiaque, le diabète, l\'hypertension ou des blessures articulaires actuelles — ou si vous prenez des médicaments, consultez votre médecin avant de commencer tout programme d\'exercice ou de nutrition.';

  @override
  String get legalDisclaimerSection3 =>
      'Les compléments alimentaires constituent de simples informations éducatives générales. Ils ne constituent pas des prescriptions médicales ni des recommandations de traitement.';

  @override
  String get legalDisclaimerSection4 =>
      'Les conseils relatifs aux hormones (comme la testostérone) constituent des informations éducatives générales. Ils ne constituent pas une prescription médicale ni une recommandation de traitement.';

  @override
  String get legalDisclaimerSection5 =>
      'En participant à un programme dans l\'application, je confirme avoir lu les conditions et comprendre que Vireo n\'est pas responsable des blessures ou complications médicales résultant de l\'utilisation de l\'application sans avis médical.';

  @override
  String get languageArabic => 'Arabe';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get consentCheckboxLabel =>
      'J\'ai lu et j\'accepte les conditions générales et l\'avertissement de santé';

  @override
  String get notificationWorkoutTime => 'Heure d\'entraînement préférée';

  @override
  String get notificationWalkingReminder => 'Rappel quotidien de marche';

  @override
  String get notificationWeeklyCheckIn => 'Rappel de bilan hebdomadaire';

  @override
  String get notificationNotSet => 'Non défini';

  @override
  String get authWelcomeTitle => 'Bienvenue sur Vireo';

  @override
  String get authWelcomeSubtitle =>
      'Connectez-vous pour synchroniser vos progrès sur tous vos appareils, ou continuez en mode invité.';

  @override
  String get authSaveProgressTitle => 'Enregistrez vos progrès';

  @override
  String get authSaveProgressSubtitle =>
      'Associez un compte pour synchroniser votre programme, vos scans et vos échanges avec le coach.';

  @override
  String get signInWithApple => 'Se connecter avec Apple';

  @override
  String get signInWithGoogle => 'Se connecter avec Google';

  @override
  String get signInWithEmail => 'Se connecter avec un e-mail';

  @override
  String get authContinueApple => 'Continuer avec Apple';

  @override
  String get authContinueGoogle => 'Continuer avec Google';

  @override
  String get authContinueEmail => 'Continuer avec un e-mail';

  @override
  String get authSignInWithPassword => 'Se connecter avec un mot de passe';

  @override
  String get authSendCode => 'Envoyer le code';

  @override
  String get authVerifyCode => 'Vérifier le code';

  @override
  String get authResendCode => 'Renvoyer le code';

  @override
  String authResendIn(int seconds) {
    return 'Renvoyer dans $seconds s';
  }

  @override
  String authOtpSentTo(String email) {
    return 'Nous avons envoyé un code à 6 chiffres à $email';
  }

  @override
  String get authBack => 'Retour';

  @override
  String get continueAsGuest => 'Continuer en tant qu\'invité';

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Mot de passe';

  @override
  String get authSignIn => 'Se connecter';

  @override
  String get authSignUp => 'S\'inscrire';

  @override
  String get authHasAccount => 'Vous avez déjà un compte ?';

  @override
  String get authNoAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get authSignedIn => 'Connecté';

  @override
  String get authErrorGeneric =>
      'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get authErrorOffline =>
      'Aucune connexion Internet. Vérifiez votre réseau et réessayez.';

  @override
  String get authErrorWrongCode =>
      'Code incorrect. Vérifiez les chiffres et réessayez.';

  @override
  String get authErrorTooMany =>
      'Trop de tentatives. Veuillez réessayer dans une minute.';

  @override
  String get authErrorInvalidEmail =>
      'Veuillez saisir une adresse e-mail valide.';

  @override
  String get authErrorCancelled => 'La connexion a été annulée.';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get guestModeTitle => 'Mode invité';

  @override
  String get guestModeSubtitle =>
      'Vos progrès sont enregistrés uniquement sur cet appareil. Créez un compte pour synchroniser et vous abonner.';

  @override
  String get profileStatWorkoutsLabel => 'Séances terminées';

  @override
  String get profileStatStreakLabel => 'Jours consécutifs';

  @override
  String get saveProgressToCloud => 'Enregistrer les progrès sur le cloud';

  @override
  String get profileCloudSynced => 'Progrès synchronisés avec votre compte';

  @override
  String get authGateTitle => 'Créer un compte';

  @override
  String get authGateSaveProgress =>
      'Créez un compte gratuit pour enregistrer vos progrès sur le cloud et y accéder sur tous vos appareils.';

  @override
  String get authGateSubscribe =>
      'Créez un compte avant de vous abonner afin d\'associer votre abonnement Premium à votre profil.';

  @override
  String get authGateAiFeatures =>
      'Créez un compte gratuit pour utiliser le scan de repas par IA et le Coach Vireo. Vos échanges et vos scans seront synchronisés en toute sécurité.';

  @override
  String get authGateSignUp => 'S\'inscrire';

  @override
  String get authGateNotNow => 'Pas maintenant';

  @override
  String get deleteAccountTitle => 'Supprimer le compte';

  @override
  String get deleteAccountWarningTitle => 'Cette action est irréversible';

  @override
  String get deleteAccountWarningBody =>
      'Toutes les données de votre profil, vos historiques d\'entraînement, vos plans de repas et vos photos de progression seront définitivement supprimés de nos serveurs.';

  @override
  String get deleteAccountCancel => 'Annuler';

  @override
  String get deleteAccountContinue => 'Continuer';

  @override
  String get deleteAccountConfirmTitle => 'Confirmer la suppression';

  @override
  String get deleteAccountConfirmInstructions =>
      'Saisissez exactement le mot ci-dessous pour confirmer la suppression définitive de votre compte :';

  @override
  String get deleteConfirmationWord => 'SUPPRIMER';

  @override
  String get deleteAccountTypeHint => 'Tapez SUPPRIMER';

  @override
  String get deleteAccountConfirmButton =>
      'Supprimer définitivement mon compte';

  @override
  String get deleteAccountSuccess => 'Votre compte a été supprimé.';

  @override
  String get workoutMedicalWarning =>
      'Vous avez signalé un problème de santé lors de l\'inscription. Arrêtez-vous en cas de douleur, de vertige ou d\'essoufflement. Consultez votre médecin avant tout exercice intense.';

  @override
  String get workoutWarmUpTitle => 'Échauffement';

  @override
  String get workoutWarmUpSubtitle =>
      'Effectuez ces exercices de mobilité avant votre séance principale.';

  @override
  String get workoutCoolDownTitle => 'Retour au calme';

  @override
  String get workoutCoolDownSubtitle =>
      'Mobilité douce pour favoriser la récupération de votre corps.';

  @override
  String get workoutActiveTitle => 'Séance en cours';

  @override
  String get workoutBeginWorkout => 'Commencer la séance';

  @override
  String get workoutFinishCoolDown => 'Terminer le retour au calme';

  @override
  String get workoutStartButton => 'Commencer l\'entraînement du jour';

  @override
  String get workoutTodayTitle => 'Programme du jour';

  @override
  String workoutTodaySubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercices principaux',
      one: '1 exercice principal',
    );
    return '$_temp0';
  }

  @override
  String workoutPhaseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercices',
      one: '1 exercice',
    );
    return '$_temp0';
  }

  @override
  String get workoutExerciseProgress => 'Exercice';

  @override
  String get workoutStatSets => 'Séries';

  @override
  String get workoutStatReps => 'Répétitions';

  @override
  String get workoutStatRest => 'Repos';

  @override
  String get workoutSetsLabel => 'Séries';

  @override
  String workoutSetNumber(int number) {
    return 'Série $number';
  }

  @override
  String get workoutPrevious => 'Précédent';

  @override
  String get workoutNext => 'Suivant';

  @override
  String get workoutSwapExercise => 'Remplacer l\'exercice';

  @override
  String get workoutSwapTitle => 'Remplacer l\'exercice';

  @override
  String get workoutSwapSubtitle =>
      'Alternatives ciblant le même groupe musculaire et adaptées à votre environnement d\'entraînement.';

  @override
  String get workoutSwapEmpty =>
      'Aucune alternative disponible pour le moment.';

  @override
  String get workoutRestTitle => 'Repos';

  @override
  String get workoutRestSkip => 'Passer';

  @override
  String get workoutRestAdd15 => '+15 s';

  @override
  String get workoutPausedTitle => 'Séance en pause';

  @override
  String get workoutResume => 'Reprendre';

  @override
  String get workoutEndWorkout => 'Terminer la séance';

  @override
  String get workoutRestart => 'Recommencer la séance';

  @override
  String get workoutEndConfirmTitle => 'Terminer la séance ?';

  @override
  String get workoutEndConfirmBody =>
      'Votre progression dans cette séance ne sera pas enregistrée.';

  @override
  String get workoutFeedbackTitle => 'Comment s\'est passée cette séance ?';

  @override
  String get workoutFeedbackEasy => 'Facile';

  @override
  String get workoutFeedbackJustRight => 'Parfaite';

  @override
  String get workoutFeedbackHard => 'Difficile';

  @override
  String get workoutVideoUnavailable => 'Vidéo non disponible';

  @override
  String get workoutEmptyProgram => 'Aucun exercice prévu pour aujourd\'hui.';

  @override
  String get walkingTitle => 'Marche';

  @override
  String get walkingStepsToday => 'pas aujourd\'hui';

  @override
  String walkingDailyGoal(int steps) {
    return 'Objectif : $steps pas';
  }

  @override
  String walkingGoalProgress(int percent) {
    return '$percent % de l\'objectif d\'aujourd\'hui';
  }

  @override
  String get walkingWeeklyChartTitle => '7 derniers jours';

  @override
  String get walkingHealthSourceNote =>
      'Les pas sont comptés sur cet appareil. Si Santé Connect / Apple Santé est également disponible, Vireo affiche le nombre le plus élevé.';

  @override
  String get walkingPermissionTitle => 'Accès aux pas requis';

  @override
  String get walkingPermissionBody =>
      'Vireo compte vos pas grâce aux capteurs de mouvement de votre téléphone. Autorisez l\'accès à l\'activité physique pour un suivi précis de vos objectifs et de vos calories.';

  @override
  String get walkingOpenSettings => 'Ouvrir les Paramètres';

  @override
  String get walkingTryAgain => 'Réessayer';

  @override
  String get walkingUnavailableTitle => 'Suivi de marche non disponible';

  @override
  String get walkingUnavailableBody =>
      'Le suivi des pas fonctionne de manière optimale sur un smartphone iOS ou Android doté d\'un podomètre matériel.';

  @override
  String get walkingEnableTitle => 'Compter les pas sur ce téléphone';

  @override
  String get walkingEnableBody =>
      'Vireo utilise le capteur de pas de votre téléphone pour suivre votre marche en temps réel — distance, calories et objectif quotidien. Nous vous demanderons ensuite l\'autorisation d\'activité.';

  @override
  String get walkingEnableCta => 'Activer le comptage des pas';

  @override
  String get walkingActiveMinutes => 'Temps actif';

  @override
  String get nutritionTabBreakfast => 'Petit-déjeuner';

  @override
  String get nutritionTabLunch => 'Déjeuner';

  @override
  String get nutritionTabDinner => 'Dîner';

  @override
  String get nutritionTabSnack => 'Collation';

  @override
  String get nutritionNoMealPlanned => 'Aucun repas prévu aujourd\'hui.';

  @override
  String nutritionPrepMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get nutritionTagHighProtein => 'Riche en protéines';

  @override
  String get nutritionTagQuickEasy => 'Rapide & facile';

  @override
  String get nutritionTagLightEnergy => 'Énergie légère';

  @override
  String get nutritionScanFridge => 'Scanner votre frigo';

  @override
  String nutritionScansRemaining(int count) {
    return '$count scans de frigo restants ce mois-ci';
  }

  @override
  String get nutritionScanPrompt =>
      'Prenez une photo de votre réfrigérateur ou placard pour identifier les ingrédients.';

  @override
  String get nutritionTakePhoto => 'Prendre une photo';

  @override
  String get nutritionChoosePhoto => 'Choisir dans la galerie';

  @override
  String get nutritionScanning => 'Analyse des ingrédients…';

  @override
  String get nutritionScanFailed =>
      'Échec du scan. Réessayez ou ajoutez les ingrédients manuellement.';

  @override
  String get nutritionScanLimitReached =>
      'Limite mensuelle de scans atteinte. Passez à la version Premium pour des scans illimités.';

  @override
  String get nutritionConfirmIngredients => 'Confirmer les ingrédients';

  @override
  String get nutritionIngredientsHint =>
      'Supprimez les éléments incorrects et ajoutez les ingrédients manquants.';

  @override
  String get nutritionAddIngredient => 'Ajouter un ingrédient';

  @override
  String get nutritionGetRecipes => 'Obtenir des idées de recettes';

  @override
  String get nutritionNoIngredients => 'Ajoutez au moins un ingrédient.';

  @override
  String get nutritionRecipeSuggestions => 'Idées de recettes';

  @override
  String get nutritionRecipeSuggestionsSubtitle =>
      'Basées sur vos ingrédients, votre objectif et vos préférences alimentaires.';

  @override
  String get nutritionNoRecipesFound =>
      'Aucune recette correspondante trouvée.';

  @override
  String get nutritionManualEntry => 'Saisie manuelle';

  @override
  String get nutritionManualEntryHint =>
      'Indiquez ce que vous avez sous la main — nous vous proposerons des recettes adaptées à vos objectifs et préférences.';

  @override
  String get nutritionSwapMeal => 'Changer de repas';

  @override
  String get nutritionSwapMealSubtitle =>
      'Choisissez une autre recette — pas de répétition sous 14 jours.';

  @override
  String get nutritionSwapMealEmpty =>
      'Aucun autre repas disponible pour l\'instant.';

  @override
  String get nutritionDemoQuickMeals => 'Exemples de repas rapides et sains';

  @override
  String get nutritionTryDemoScan => 'Essayer le scan démo';

  @override
  String get homeWelcomeSubtitle => 'Votre espace fitness personnalisé.';

  @override
  String get homeWalkingCardSubtitle =>
      'Suivez vos pas quotidiens via Apple Santé ou Santé Connect.';

  @override
  String get homeDailyProgramTitle => 'Programme quotidien';

  @override
  String get homeTodayWorkout => 'Séance du jour';

  @override
  String get homeNextMeal => 'Prochain repas';

  @override
  String homeWorkoutExerciseCount(int count) {
    return '$count exercices';
  }

  @override
  String get progressTabWeight => 'Poids';

  @override
  String get progressTabAdherence => 'Assiduité';

  @override
  String get progressTabEnergy => 'Énergie';

  @override
  String get progressWeightChartTitle => 'Tendance du poids';

  @override
  String progressWeightGoalLine(String value, String unit) {
    return 'Objectif : $value $unit';
  }

  @override
  String get progressAdherenceChartTitle => 'Assiduité hebdomadaire';

  @override
  String get progressAdherenceSubtitle =>
      '% d\'entraînements complétés par semaine';

  @override
  String get progressEnergyChartTitle => 'Niveau d\'énergie';

  @override
  String get progressEnergySubtitle =>
      'Score d\'énergie du bilan hebdomadaire (1–10)';

  @override
  String get progressLogWeight => 'Enregistrer le poids';

  @override
  String progressWeightLabel(String unit) {
    return 'Poids ($unit)';
  }

  @override
  String get progressLogDate => 'Date';

  @override
  String get progressSaveWeight => 'Enregistrer';

  @override
  String get reassessmentTitle => 'Bilan mensuel';

  @override
  String get reassessmentSubtitle =>
      'Mettez à jour votre poids, votre niveau d\'activité et votre équipement afin que nous puissions affiner votre programme.';

  @override
  String get reassessmentLater => 'Plus tard';

  @override
  String get reassessmentSubmit => 'Mettre à jour mon programme';

  @override
  String get reassessmentSummaryTitle => 'Ce qui a changé';

  @override
  String get reassessmentSummarySubtitle => 'Par rapport à votre dernier bilan';

  @override
  String reassessmentPhaseUpdated(int phase) {
    return 'Phase du programme passée à la phase $phase';
  }

  @override
  String get reassessmentNoPhaseChange =>
      'Aucun changement requis — continuez sur votre lancée !';

  @override
  String get paywallTitle => 'Vireo Premium';

  @override
  String get paywallHeadline => 'Libérez tout votre potentiel';

  @override
  String get paywallSubtitle =>
      'La version Premium vous offre des scans illimités, toutes les phases du programme et des analyses détaillées de vos progrès.';

  @override
  String get paywallBestValue => 'Meilleure offre';

  @override
  String get paywallPlanMonthly => 'Mensuel';

  @override
  String get paywallPlanAnnual => 'Annuel';

  @override
  String get paywallPlanLifetime => 'À vie';

  @override
  String get paywallFeatureUnlimitedScans => 'Scans d\'assiettes illimités';

  @override
  String get paywallFeatureFullProgram =>
      'Phases de programme complètes et entraînements progressifs';

  @override
  String get paywallFeatureCloudSync =>
      'Synchronisation cloud sur tous vos appareils';

  @override
  String get paywallFeatureProgressAnalytics =>
      'Statistiques avancées de progression';

  @override
  String get paywallSubscribe => 'S\'abonner';

  @override
  String get paywallRestorePurchases => 'Restaurer les achats';

  @override
  String get paywallPurchaseSuccess => 'Bienvenue dans Premium !';

  @override
  String get paywallPurchaseError => 'Échec de l\'achat. Veuillez réessayer.';

  @override
  String get paywallRestoreSuccess => 'Achats restaurés avec succès.';

  @override
  String get paywallRestoreEmpty =>
      'Aucun abonnement actif trouvé pour ce compte.';

  @override
  String get paywallRestoreError =>
      'Impossible de restaurer les achats. Réessayez plus tard.';

  @override
  String get paywallNotConfigured =>
      'Les abonnements ne sont pas disponibles sur cette version.';

  @override
  String get paywallSubscriptionExpiredMessage =>
      'Votre abonnement a expiré. Réabonnez-vous pour débloquer les fonctionnalités premium.';

  @override
  String get trialEndedTitle => 'Votre période d\'essai est terminée';

  @override
  String get trialEndedBody =>
      'Merci d\'avoir essayé Vireo Premium. Abonnez-vous pour conserver les scans illimités, les programmes complets et la synchronisation cloud.';

  @override
  String get trialEndedViewPlans => 'Voir les abonnements';

  @override
  String subscriptionTrialDaysRemaining(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours restants dans votre essai gratuit',
      one: '1 jour restant dans votre essai gratuit',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionExpiredBanner =>
      'Abonnement expiré — appuyez pour renouveler l\'accès premium';

  @override
  String get subscriptionPremiumActive => 'Premium actif';

  @override
  String get subscriptionFreeTier => 'Formule gratuite';

  @override
  String get subscriptionUpgrade => 'Passer à Premium';

  @override
  String get settingsManageSubscription =>
      'Voir les formules, s\'abonner ou restaurer les achats';

  @override
  String workoutPhaseLockedTitle(int phase) {
    return 'Phase $phase verrouillée';
  }

  @override
  String get workoutPhaseLockedBody =>
      'Réabonnez-vous pour continuer votre programme complet. Le suivi de base reste disponible dans la version gratuite.';

  @override
  String homeGreeting(String name) {
    return 'Bonjour $name 👋';
  }

  @override
  String homeDayPhase(int day, String phase) {
    return 'Jour $day · Phase $phase';
  }

  @override
  String get homeGuestBanner =>
      'Vous êtes en mode invité — inscrivez-vous pour enregistrer vos progrès';

  @override
  String get homeGuestSignUp => 'S\'inscrire';

  @override
  String get homeGuestCta => 'Inscrivez-vous maintenant — 7 jours gratuits';

  @override
  String homeStreakDays(int days) {
    return '$days jours consécutifs';
  }

  @override
  String get homeStartStreak => 'Commencez votre série aujourd\'hui';

  @override
  String get homeTodayWorkoutTitle => 'Séance du jour';

  @override
  String get homeStartWorkout => 'Commencer l\'entraînement';

  @override
  String get homeRestDay => 'Jour de repos actif 🧘';

  @override
  String get homeBreakfast => 'Petit-déjeuner';

  @override
  String get homeMealConfirmed => 'Confirmé ✓';

  @override
  String get homeMealPending => 'En attente';

  @override
  String homeWalkingSteps(int current, int goal) {
    return '$current / $goal pas';
  }

  @override
  String homeWeeklyProgress(int completed) {
    return '$completed / 7 jours complétés';
  }

  @override
  String get homeCheckInBanner =>
      '⏱️ Bilan hebdomadaire prêt — une minute seulement';

  @override
  String get homeRecoveryScore => 'Score de récupération';

  @override
  String get homeRecoveryReady => 'Votre corps est prêt pour l\'entraînement';

  @override
  String get homeGuestName => 'Champion';

  @override
  String get homePhaseFoundation => 'Fondation';

  @override
  String get nutritionFilterAll => 'Tous';

  @override
  String get nutritionFilterQuick => 'Rapide';

  @override
  String get nutritionFilterLowCalorie => 'Faible en calories';

  @override
  String nutritionMacroSummary(int calories, int protein) {
    return '$calories kcal · $protein g de protéines';
  }

  @override
  String get nutritionMacroBar => 'Calories | Protéines | Glucides | Lipides';

  @override
  String get nutritionMealConfirmed => 'Confirmé ✓';

  @override
  String nutritionFridgeBanner(int remaining) {
    return '📷 Scannez votre frigo — $remaining scans restants ce mois-ci';
  }

  @override
  String get nutritionFridgeScanCta => 'Scanner';

  @override
  String get workoutWarmUpStep1 => 'Rotations des épaules — 30 secondes';

  @override
  String get workoutWarmUpStep2 => 'Marche sur place — 60 secondes';

  @override
  String get workoutWarmUpStep3 => 'Squats légers — 10 répétitions';

  @override
  String get workoutSkipWarmUp => 'Passer l\'échauffement';

  @override
  String get workoutStartMainWorkout => 'Commencer la séance principale';

  @override
  String get workoutWarmUpComplete => 'Échauffement terminé — prêt !';

  @override
  String homeProgramDay(int day, int total) {
    return 'Jour $day sur $total';
  }

  @override
  String get homeStartProgram => 'Démarrer votre programme';

  @override
  String get nutritionDailyCalorieGoal => 'Votre objectif calorique quotidien';

  @override
  String nutritionCalorieTargetSummary(
    int calories,
    int protein,
    int carbs,
    int fat,
  ) {
    return 'Objectif : $calories kcal — $protein g de protéines, $carbs g de glucides, $fat g de lipides';
  }

  @override
  String nutritionCalorieProgress(int consumed, int target) {
    return '$consumed / $target kcal aujourd\'hui';
  }

  @override
  String get nutritionEditCalorieGoal => 'Modifier l\'objectif calorique';

  @override
  String get nutritionCalorieHint => 'Calories quotidiennes';

  @override
  String get settingsThemeTitle => 'Apparence';

  @override
  String get settingsThemeDark => 'Mode sombre';

  @override
  String get settingsThemeLight => 'Mode clair';

  @override
  String get settingsThemeSystem => 'Par défaut du système';

  @override
  String get progressAxisDate => 'Date';

  @override
  String get progressAxisWeight => 'Poids (kg)';

  @override
  String get progressAxisEnergy => 'Énergie (1–10)';

  @override
  String get progressAllChartsTitle => 'Aperçu de vos progrès';

  @override
  String get profileGuestAvatar => 'Invité';

  @override
  String get profileStatProgramDays => 'Jours de programme';

  @override
  String get profileStatsSection => 'Vos statistiques';

  @override
  String get profileGoalWeight => 'Poids cible';

  @override
  String get profileCurrentBmi => 'IMC actuel';

  @override
  String get profileActivityLevel => 'Niveau d\'activité';

  @override
  String get profileEditProfile => 'Modifier le profil';

  @override
  String get profileBmiUnderweight => 'Insuffisance pondérale';

  @override
  String get profileBmiHealthy => 'Poids de forme';

  @override
  String get profileBmiOverweight => 'Surpoids';

  @override
  String get profileBmiObese => 'Obésité';

  @override
  String get profileBmiTooltip =>
      'L\'IMC (Indice de Masse Corporelle) estime la masse grasse à partir de la taille et du poids. Il s\'agit d\'un indicateur général — pas d\'un diagnostic médical.';

  @override
  String get workoutSplitChestTriceps => 'Pectoraux & Triceps';

  @override
  String get workoutSplitBackBiceps => 'Dos & Biceps';

  @override
  String get workoutSplitLegs => 'Jambes';

  @override
  String get workoutSplitCardio => 'Cardio';

  @override
  String get workoutSplitShoulders => 'Épaules';

  @override
  String get workoutSplitFullBody => 'Corps complet';

  @override
  String get workoutSplitRest => 'Jour de repos';

  @override
  String get habitsTitle => 'Habitudes quotidiennes';

  @override
  String get habitsEmpty =>
      'Aucune habitude — appuyez sur + pour ajouter votre première';

  @override
  String get habitsAddTitle => 'Nouvelle habitude';

  @override
  String get habitsAddHint => 'Nom de l\'habitude';

  @override
  String get habitsAddConfirm => 'Ajouter';

  @override
  String habitsStreak(int days) {
    return '$days jours consécutifs';
  }

  @override
  String get habitsRetry => 'Réessayer';

  @override
  String get habitsErrorTitle => 'Impossible de charger les habitudes';

  @override
  String homeRecoveryExplain(int score) {
    return 'Un score de récupération de $score% combine la qualité du sommeil, les jours de repos et la fatigue musculaire. Plus il est élevé, plus votre corps est prêt à s\'entraîner dur.';
  }

  @override
  String get homeRecoveryFactorSleep => 'Qualité du sommeil';

  @override
  String get homeRecoveryFactorRest => 'Jours de repos';

  @override
  String get homeRecoveryFactorMuscle => 'Fatigue musculaire';

  @override
  String get homeRecoveryTipSleep => 'Visez 7 à 9 heures cette nuit';

  @override
  String get homeRecoveryTipRest =>
      'Conservez au moins un jour de repos complet par semaine';

  @override
  String get homeRecoveryTipMuscle =>
      'Réduisez l\'intensité si vos courbatures sont importantes';

  @override
  String get homeRecoveryImproveTitle => 'Conseils d\'amélioration';

  @override
  String get homeRecoveryImproveBody =>
      'Privilégiez le sommeil, hydratez-vous et remplacez une séance intense par de la mobilité en cas de pic de fatigue.';

  @override
  String get walkingMetricsTitle => 'Indicateurs de marche du jour';

  @override
  String get walkingDistance => 'Distance';

  @override
  String get walkingSpeed => 'Vitesse';

  @override
  String get walkingPace => 'Allure';

  @override
  String get walkingCalories => 'Calories brûlées';

  @override
  String walkingWeightLoss(String kg) {
    return 'Graisse brûlée est. ≈ $kg kg';
  }

  @override
  String walkingCadence(int spm) {
    return 'Cadence ≈ $spm pas/min';
  }

  @override
  String get walkingMetricsEstimatedNote =>
      'Health Connect indisponible — indicateurs estimés d\'après le nombre de pas.';

  @override
  String get mealBuilderTitle => 'Personnaliser les ingrédients';

  @override
  String mealBuilderTitleFor(String meal) {
    return 'Personnaliser $meal';
  }

  @override
  String get mealBuilderSubtitle =>
      'Ajustez les protéines, les matières grasses et les ajouts — les macros s\'actualisent en direct.';

  @override
  String get mealBuilderEggs => 'Œufs';

  @override
  String mealBuilderEggCount(int count) {
    return '$count œufs';
  }

  @override
  String mealBuilderPortionCount(int count) {
    return '$count portions';
  }

  @override
  String get mealBuilderProteinLunch => 'Portions de protéines';

  @override
  String get mealBuilderProteinDinner => 'Protéines du dîner';

  @override
  String get mealBuilderProteinSnack => 'Protéines de la collation';

  @override
  String get mealBuilderFatSource => 'Source de matière grasse';

  @override
  String get mealBuilderFatButter => 'Beurre';

  @override
  String get mealBuilderFatGhee => 'Ghee';

  @override
  String get mealBuilderFatOliveOil => 'Huile d\'olive';

  @override
  String get mealBuilderFatSpray => 'Spray d\'huile';

  @override
  String get mealBuilderAddOns => 'Ajouts';

  @override
  String get mealBuilderAddonCheese => 'Fromage';

  @override
  String get mealBuilderAddonVeggies => 'Légumes';

  @override
  String get mealBuilderAddonBread => 'Pain complet';

  @override
  String get mealBuilderAddonRice => 'Riz';

  @override
  String get mealBuilderAddonYogurt => 'Yaourt';

  @override
  String get mealBuilderLiveMacros => 'Macros en direct';

  @override
  String get weeklyCheckInTitle => 'Bilan hebdomadaire';

  @override
  String get weeklyCheckInBanner =>
      'L\'heure de votre bilan hebdo — mettez à jour votre poids et votre niveau d\'énergie';

  @override
  String get weeklyCheckInSubtitle =>
      'Nous recalculerons votre MB/DEJT et vos macros pour la semaine à venir.';

  @override
  String get weeklyCheckInWeight => 'Poids actuel';

  @override
  String get weeklyCheckInWaist => 'Tour de taille';

  @override
  String get weeklyCheckInEnergy => 'Niveau d\'énergie (1–5)';

  @override
  String weeklyCheckInAdherence(int pct) {
    return 'Assiduité à l\'entraînement : $pct%';
  }

  @override
  String get weeklyCheckInSubmit => 'Mettre à jour mes objectifs';

  @override
  String get weeklyCheckInDoneTitle => 'Objectifs mis à jour';

  @override
  String weeklyCheckInDoneBody(
    int prev,
    int next,
    int protein,
    int carbs,
    int fat,
  ) {
    return 'Calories : $prev → $next kcal. Macros : ${protein}g de protéines, ${carbs}g de glucides, ${fat}g de lipides.';
  }

  @override
  String get settingsAccentTitle => 'Couleur d\'accentuation';

  @override
  String get settingsAccentOrange => 'Orange';

  @override
  String get settingsAccentEmerald => 'Émeraude';

  @override
  String get settingsAccentBlue => 'Océan';

  @override
  String get settingsAccentViolet => 'Violet';

  @override
  String get settingsSkinTitle => 'Thèmes de couleur';

  @override
  String get settingsSkinStandard => 'Standard';

  @override
  String get settingsSkinStandardDesc => 'Vireo classique sombre / clair';

  @override
  String get settingsSkinAmoled => 'AMOLED Noir pur';

  @override
  String get settingsSkinAmoledDesc => 'Noir absolu avec touches dorées & cyan';

  @override
  String get settingsSkinNavy => 'Bleu marine profond';

  @override
  String get settingsSkinNavyDesc =>
      'Bleu nuit #0B192C avec bleu glacier & sarcelle';

  @override
  String get settingsAccentLockedHint =>
      'Les couleurs d\'accentuation sont verrouillées lorsque le thème AMOLED ou Bleu marine est actif.';

  @override
  String get workoutSwapWarmUp => 'Changer d\'échauffement';

  @override
  String get workoutSwapWarmUpTitle =>
      'Choisir une alternative d\'échauffement';

  @override
  String get workoutSwapWarmUpSubtitle =>
      'Options de mobilité et à faible impact adaptées à votre environnement d\'entraînement.';

  @override
  String get profileBmiExplainShort =>
      'L\'IMC évalue le poids par rapport à la taille.';

  @override
  String get profileBmiExplainFull =>
      'L\'Indice de Masse Corporelle (IMC) permet d\'évaluer le poids en fonction de la taille. Il s\'agit d\'un indicateur indicatif général — pas d\'un diagnostic médical.';

  @override
  String get mealBuilderCheeseTitle => 'Fromage';

  @override
  String get mealBuilderCheeseNone => 'Sans fromage';

  @override
  String get mealBuilderCheeseCottage => 'Cottage cheese';

  @override
  String get mealBuilderCheeseCheddar => 'Cheddar';

  @override
  String get mealBuilderCheeseMozzarella => 'Mozzarella';

  @override
  String get mealBuilderCheeseFeta => 'Féta';

  @override
  String mealBuilderCheeseGrams(int grams) {
    return 'Quantité : ${grams}g';
  }

  @override
  String get homeRecoveryFormulaExplain =>
      'Récupération = Jours de repos (40%) + Objectif de pas (30%) + Régularité repas/séances (30%).';

  @override
  String get homeRecoveryFactorRestDays => 'Jours de repos';

  @override
  String get homeRecoveryFactorSteps => 'Objectif de pas';

  @override
  String get homeRecoveryFactorConsistency => 'Régularité repas & entraînement';

  @override
  String homeRecoveryRestDetail(int days) {
    return '$days jour(s) de repos cette semaine';
  }

  @override
  String homeRecoveryStepsDetail(int current, int goal) {
    return '$current / $goal pas aujourd\'hui';
  }

  @override
  String homeRecoveryConsistencyDetail(
    int mealsDone,
    int mealsTotal,
    int wDone,
    int wTotal,
  ) {
    return 'Repas : $mealsDone/$mealsTotal · Séances : $wDone/$wTotal';
  }

  @override
  String get homeRecoveryTipSteps =>
      'Atteignez votre objectif de pas quotidien pour stimuler ce pilier';

  @override
  String get homeRecoveryTipConsistency =>
      'Validez vos repas et terminez vos entraînements prévus';

  @override
  String homeRecoveryMathLine(int rest, int steps, int consistency, int total) {
    return '$rest + $steps + $consistency = $total%';
  }

  @override
  String get cardioTitle => 'Cardio & activité quotidienne';

  @override
  String get cardioSubtitle =>
      'Enregistrez marche rapide, course, etc. — calcul des calories : MET × poids × durée.';

  @override
  String get cardioSelectActivity => 'Activité';

  @override
  String cardioDuration(int minutes) {
    return 'Durée : $minutes min';
  }

  @override
  String cardioEstimatedBurn(int kcal) {
    return 'Dépense est. : $kcal kcal';
  }

  @override
  String cardioMetHint(String met) {
    return 'MET $met · formule : MET × kg × heures';
  }

  @override
  String get cardioLogButton => 'Enregistrer l\'activité';

  @override
  String get cardioLoggedSnack => 'Séance cardio enregistrée';

  @override
  String cardioTodayTotal(int kcal) {
    return 'Brûlé aujourd\'hui : $kcal kcal';
  }

  @override
  String get cardioEmpty =>
      'Aucun cardio enregistré — ajoutez votre première séance ci-dessus.';

  @override
  String cardioLogSubtitle(int minutes, int kcal) {
    return '$minutes min · $kcal kcal';
  }

  @override
  String get cardioLogCta => 'Enregistrer une activité cardio';

  @override
  String get cardioBriskWalking => 'Marche rapide';

  @override
  String get cardioRunning => 'Course à pied';

  @override
  String get cardioCycling => 'Cyclisme';

  @override
  String get cardioSwimming => 'Natation';

  @override
  String get cardioJumpRope => 'Corde à sauter';

  @override
  String get cardioHiit => 'HIIT';

  @override
  String get cardioElliptical => 'Vélo elliptique';

  @override
  String workoutGoalPlanLabel(String goal) {
    return 'Programme pour : $goal';
  }

  @override
  String get aiScanTitle => 'Scanner de repas IA';

  @override
  String get aiScanPrompt =>
      'Photographiez votre plat — l\'IA estime les calories et macros selon la taille de la portion.';

  @override
  String get aiScanCamera => 'Appareil photo';

  @override
  String get aiScanGallery => 'Galerie';

  @override
  String get aiScanAnalyzing => 'Analyse du repas en cours…';

  @override
  String get aiScanOffline =>
      'Aucune connexion Internet. Vérifiez votre réseau et réessayez.';

  @override
  String get aiScanFailed => 'Échec de l\'analyse. Veuillez réessayer.';

  @override
  String get aiScanParseError =>
      'Impossible de lire l\'analyse. Essayez une autre photo ou entrez les données manuellement.';

  @override
  String get aiScanConfigError =>
      'Le scanner IA est indisponible actuellement. Veuillez réessayer plus tard.';

  @override
  String get aiDailyLimitReached =>
      'Vous avez atteint votre limite quotidienne d\'analyses IA. Passez à la formule supérieure pour une limite plus élevée.';

  @override
  String get aiUpgradeCta => 'Mettre à niveau';

  @override
  String get aiScanTryAgain => 'Réessayer';

  @override
  String get aiScanManualEntry => 'Saisie manuelle';

  @override
  String get aiScanCardTitle => 'Scannez votre repas avec l\'IA';

  @override
  String get aiScanCardSubtitle =>
      'Prenez une photo — obtenez instantanément calories, macros et alternatives saines.';

  @override
  String get aiScanSaveToLog => 'Enregistrer dans le journal';

  @override
  String get aiScanSavedSnack => 'Repas enregistré dans le journal du jour';

  @override
  String get aiScanMacroProtein => 'Protéines';

  @override
  String get aiScanMacroCarbs => 'Glucides';

  @override
  String get aiScanMacroFats => 'Lipides';

  @override
  String get aiScanSmartSwaps => 'Alternatives intelligentes';

  @override
  String aiScanCaloriesChip(int calories) {
    return '$calories kcal';
  }

  @override
  String get aiCoachTitle => 'Vireo IA';

  @override
  String get aiCoachFabLabel => 'Vireo IA';

  @override
  String get aiCoachInputHint =>
      'Posez une question sur vos repas, macros ou entraînements…';

  @override
  String get aiCoachOfflineBanner =>
      'Vous êtes hors ligne — affichage des messages en cache.';

  @override
  String get aiCoachChipDinner => 'Propose-moi un dîner équilibré';

  @override
  String get aiCoachChipProtein => 'Comment augmenter mes protéines ?';

  @override
  String get aiCoachChipDessert => 'Alternative saine pour le dessert';

  @override
  String waterAddOneGlass(int ml) {
    return '+1 verre ($ml ml)';
  }

  @override
  String get waterLongPressHint => 'Appui long pour d\'autres quantités';

  @override
  String get waterQuickAmountsTitle => 'Quantités rapides';

  @override
  String get waterDefaultCupTitle => 'Taille du verre par défaut';

  @override
  String get waterCustomMl => 'Quantité personnalisée';

  @override
  String get waterAddCustom => 'Ajouter';

  @override
  String get waterTrackerTitle => 'Consommation d\'eau';

  @override
  String waterTrackerSummary(double current, double goal, int percent) {
    return '${current}L / ${goal}L — $percent% atteints';
  }

  @override
  String get weeklyDeficitChartTitle => 'Bilan calorique hebdomadaire';

  @override
  String get weeklyDeficitSubtitle =>
      'DEJT − repas + dépense cardio (7 derniers jours)';

  @override
  String weeklyDeficitTotal(int kcal) {
    return 'Bilan net hebdomadaire : $kcal kcal';
  }

  @override
  String get weeklyDeficitEmpty =>
      'Enregistrez vos repas ou votre cardio pour voir votre équilibre calorique hebdomadaire.';

  @override
  String get weeklyDeficitInProgress => 'Aujourd\'hui (en cours)';

  @override
  String get progressTrendEmpty =>
      'Enregistrez 3 jours pour voir votre tendance';

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
  String get cookMethodRaw => 'Cru';

  @override
  String get cookMethodBoiled => 'Bouilli';

  @override
  String get cookMethodGrilled => 'Grillé';

  @override
  String get cookMethodFried => 'Frit';

  @override
  String get cookMethodBaked => 'Au four';

  @override
  String get cookMethodSteamed => 'À la vapeur';

  @override
  String get cookMethodOther => 'Autre';

  @override
  String weeklyDeficitTooltip(int net, int consumed, int burned) {
    return '$net kcal\nEntrées : $consumed · Dépenses : $burned';
  }

  @override
  String uxGoodMorning(String name) {
    return 'Bonjour, $name';
  }

  @override
  String uxGoodAfternoon(String name) {
    return 'Bon après-midi, $name';
  }

  @override
  String uxGoodEvening(String name) {
    return 'Bonsoir, $name';
  }

  @override
  String get uxTodayOverline => 'AUJOURD\'HUI';

  @override
  String get uxCaloriesLeft => 'kcal restantes';

  @override
  String get uxCaloriesOver => 'kcal en trop';

  @override
  String get uxGoal => 'Objectif';

  @override
  String get uxEaten => 'Consommé';

  @override
  String get uxBurned => 'Brûlé';

  @override
  String get uxActionScan => 'Scanner repas';

  @override
  String get uxActionTrain => 'S\'entraîner';

  @override
  String get uxActionCoach => 'Coach IA';

  @override
  String get uxSectionTraining => 'Entraînement du jour';

  @override
  String get uxSectionThisWeek => 'Cette semaine';

  @override
  String get uxSectionTodayLog => 'Journal d\'aujourd\'hui';

  @override
  String get uxAddMeal => '+ Ajouter un repas';

  @override
  String get uxAiScanned => 'Scan IA';

  @override
  String get uxMealRemoved => 'Repas supprimé';

  @override
  String get uxLogEmptyTitle => 'Rien d\'enregistré pour l\'instant';

  @override
  String get uxLogEmptyBody =>
      'Prenez votre plat en photo — l\'IA calcule calories et macros en quelques secondes.';

  @override
  String get uxRestDayHint =>
      'La récupération fait partie de l\'entraînement. Marchez, étirez-vous et atteignez votre quota de protéines.';

  @override
  String uxWorkoutMinutes(int minutes) {
    return '~$minutes min';
  }

  @override
  String get uxWater => 'Eau';

  @override
  String get uxGlassSize => '250 ml';

  @override
  String uxWaterAdded(String liters) {
    return '+250 ml · $liters L aujourd\'hui';
  }

  @override
  String get uxWaterGoalDone => 'Objectif d\'eau atteint 💧 Bravo !';

  @override
  String get uxUndo => 'Annuler';

  @override
  String get uxCopied => 'Copié';

  @override
  String get uxSend => 'Envoyer';

  @override
  String get uxQuickLogTitle => 'Ajout rapide';

  @override
  String get uxQuickLogSubtitle => 'Enregistrez tout en un seul geste.';

  @override
  String get uxQuickScanTitle => 'Scanner un repas avec l\'IA';

  @override
  String get uxQuickScanSub => 'Calories & macros en secondes';

  @override
  String get uxQuickWater => 'Eau';

  @override
  String get uxQuickWaterSub => '+1 verre · 250 ml';

  @override
  String get uxQuickWeight => 'Poids';

  @override
  String get uxQuickWeightSub => 'Enregistrer la pesée du jour';

  @override
  String get uxQuickCardio => 'Cardio';

  @override
  String get uxQuickCardioSub => 'Marche, course, vélo…';

  @override
  String get uxQuickCoach => 'Demander au coach';

  @override
  String get uxQuickCoachSub => 'Conseil IA personnalisé';

  @override
  String get uxCoachOnline => 'En ligne · connaît vos macros';

  @override
  String get uxCoachTyping => 'Écrit…';

  @override
  String get uxCoachNewChat => 'Nouvelle conversation';

  @override
  String get uxCoachClearConfirm =>
      'Commencer une nouvelle conversation ? Les messages actuels seront effacés.';

  @override
  String get uxCoachHeroTitle => 'Votre coach IA personnel';

  @override
  String get uxCoachHeroBody =>
      'Posez des questions sur vos repas, vos protéines, vos fringales ou votre entraînement. Chaque réponse s\'adapte à vos données du jour.';

  @override
  String uxCoachKcalLeft(int kcal) {
    return '$kcal kcal restantes';
  }

  @override
  String uxCoachProteinLeft(int grams) {
    return '${grams}g de protéines restantes';
  }

  @override
  String get uxCoachChipWorkout =>
      'Que devrais-je manger avant l\'entraînement ?';

  @override
  String get uxProtein => 'Protéines';

  @override
  String get uxCarbs => 'Glucides';

  @override
  String get uxFat => 'Lipides';

  @override
  String get aiScanAnalysisTitle => 'Analyse IA';

  @override
  String get diaryAddMeal => 'Ajouter un repas';

  @override
  String get diaryAddWorkout => 'Ajouter une séance';

  @override
  String get diaryCaloriesIn => 'Calories consommées';

  @override
  String get diaryCaloriesOut => 'Calories brûlées';

  @override
  String diaryKcal(int kcal) {
    return '$kcal kcal';
  }

  @override
  String diaryLastUpdated(String count) {
    return 'Mis à jour il y a $count';
  }

  @override
  String diaryMealCalories(int calories) {
    return '$calories kcal';
  }

  @override
  String get diaryNetBalance => 'Bilan net';

  @override
  String get diaryNoEntries => 'Aucune entrée pour ce jour';

  @override
  String get diaryProtein => 'Protéines';

  @override
  String diaryProteinProgress(int current, int goal) {
    return '$current / $goal g';
  }

  @override
  String get diarySetGoalsCta => 'Définir les objectifs';

  @override
  String get diarySetGoalsFirst => 'Définissez d\'abord vos objectifs';

  @override
  String get diaryTimeline => 'Chronologie';

  @override
  String get diaryTitle => 'Mon journal';

  @override
  String get diaryToday => 'Aujourd\'hui';

  @override
  String get diaryWater => 'Eau';

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
  String get exerciseAdvanced => 'Avancé';

  @override
  String get exerciseBeginner => 'Débutant';

  @override
  String get exerciseComplete => 'Valider la série';

  @override
  String get exerciseDifficulty => 'Difficulté';

  @override
  String get exerciseEquipment => 'Équipement';

  @override
  String get exerciseIntermediate => 'Intermédiaire';

  @override
  String get exerciseLoadingDemo => 'Chargement de la démonstration...';

  @override
  String get exerciseMistakes => 'Erreurs courantes';

  @override
  String get exerciseReps => 'Répétitions';

  @override
  String get exerciseRest => 'Repos';

  @override
  String get exerciseSets => 'Séries';

  @override
  String get exerciseSteps => 'Étapes';

  @override
  String get exerciseTips => 'Conseils de pro';

  @override
  String get exerciseViewBack => 'Dos';

  @override
  String get exerciseViewFront => 'Face';

  @override
  String get measurements30Days => '30 jours';

  @override
  String get measurements3Months => '3 mois';

  @override
  String get measurements7Days => '7 jours';

  @override
  String get measurementsAdd => 'Ajouter une mesure';

  @override
  String get measurementsAddFirst => 'Enregistrez votre première mesure';

  @override
  String get measurementsAll => 'Tout';

  @override
  String get measurementsArms => 'Bras';

  @override
  String get measurementsBodyFat => '% masse grasse';

  @override
  String get measurementsChest => 'Poitrine';

  @override
  String get measurementsDate => 'Date';

  @override
  String get measurementsDelete => 'Supprimer';

  @override
  String get measurementsDeleteConfirm => 'Supprimer cette mesure ?';

  @override
  String get measurementsHistory => 'Historique';

  @override
  String measurementsLastUpdated(String date) {
    return 'Mis à jour le $date';
  }

  @override
  String get measurementsNeedMoreData =>
      'Ajoutez d\'autres mesures pour voir les tendances';

  @override
  String get measurementsNoData => 'Aucune mesure pour l\'instant';

  @override
  String get measurementsNotes => 'Notes';

  @override
  String get measurementsSave => 'Enregistrer';

  @override
  String get measurementsThighs => 'Cuisses';

  @override
  String get measurementsTitle => 'Mesures corporelles';

  @override
  String get measurementsTrendDeclining => 'À surveiller';

  @override
  String get measurementsTrendImproving => 'En progrès';

  @override
  String get measurementsTrendStable => 'Stable';

  @override
  String get measurementsWaist => 'Tour de taille';

  @override
  String get measurementsWeight => 'Poids';

  @override
  String get measurementsWeightInvalid => 'Saisissez un poids valide';

  @override
  String get muscleBack => 'Dos';

  @override
  String get muscleBiceps => 'Biceps';

  @override
  String get muscleCalves => 'Mollets';

  @override
  String get muscleChest => 'Pectoraux';

  @override
  String get muscleCore => 'Sangle abdominale';

  @override
  String get muscleForearms => 'Avant-bras';

  @override
  String get muscleGlutes => 'Fessiers';

  @override
  String get muscleHamstrings => 'Ischio-jambiers';

  @override
  String get muscleHipFlexors => 'Fléchisseurs de hanche';

  @override
  String get muscleQuads => 'Quadriceps';

  @override
  String get muscleShoulders => 'Épaules';

  @override
  String get muscleTriceps => 'Triceps';

  @override
  String get notificationsBreakfast => 'Rappel petit-déjeuner';

  @override
  String get notificationsDinner => 'Rappel dîner';

  @override
  String get notificationsLunch => 'Rappel déjeuner';

  @override
  String get notificationsOpenSettings => 'Ouvrir les paramètres';

  @override
  String get notificationsPermissionBanner =>
      'Activez les notifications pour rester sur la bonne voie';

  @override
  String get notificationsPreWorkout => 'Rappel avant entraînement';

  @override
  String get notificationsPreWorkoutSubtitle =>
      'Préparez-vous pour votre séance';

  @override
  String get notificationsSleep => 'Rappel de coucher';

  @override
  String get notificationsSleepSubtitle =>
      'Détendez-vous pour une meilleure récupération';

  @override
  String get notificationsTest => 'Envoyer une notification test';

  @override
  String get notificationsTestBody =>
      'Les rappels Vireo fonctionnent correctement';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsWater => 'Rappel d\'hydratation';

  @override
  String get notificationsWaterSubtitle =>
      'Restez bien hydraté tout au long de la journée';

  @override
  String get notificationsWeeklyReport => 'Rapport hebdomadaire';

  @override
  String get notificationsWeeklyReportSubtitle =>
      'Découvrez le récapitulatif de votre semaine';

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
  String get vitality12WeekProgram => 'Programme 12 semaines';

  @override
  String vitalityArticleCount(int count) {
    return '$count articles';
  }

  @override
  String get vitalityArticleDisclaimer =>
      'À titre informatif uniquement. Consultez un professionnel de santé pour un avis personnalisé.';

  @override
  String get vitalityArticlesSection => 'Articles';

  @override
  String get vitalityBadgesTitle => 'Badges';

  @override
  String vitalityBreathingCount(int count) {
    return '$count séances';
  }

  @override
  String get vitalityBreathingLog => 'Respiration';

  @override
  String get vitalityCategoryAdvanced => 'Avancé';

  @override
  String get vitalityCategoryEnvironmental => 'Environnement';

  @override
  String get vitalityCategoryLifestyle => 'Mode de vie';

  @override
  String get vitalityCategoryNutrition => 'Nutrition';

  @override
  String get vitalityCategoryTraining => 'Entraînement';

  @override
  String get vitalityCheckProtein => 'Objectif protéines';

  @override
  String get vitalityCheckSleep => 'Sommeil de qualité';

  @override
  String get vitalityCheckSunlight => 'Lumière matinale';

  @override
  String get vitalityCheckWorkout => 'Bouger / S\'entraîner';

  @override
  String get vitalityCheckZincVitD => 'Zinc / Vit D';

  @override
  String vitalityDailyChecklistProgress(int done, int total) {
    return '$done/$total complétés';
  }

  @override
  String get vitalityDailyChecklistTitle => 'Liste du jour';

  @override
  String get vitalityDailyTipLabel => 'Conseil du jour';

  @override
  String get vitalityHubSubtitle =>
      'Habitudes scientifiquement prouvées pour l\'énergie et la récupération';

  @override
  String get vitalityHubTitle => 'Espace Vitalité';

  @override
  String get vitalityLegendBadge => 'Légende';

  @override
  String get vitalityLinkCopied => 'Lien copié';

  @override
  String get vitalityLogSection => 'Journal';

  @override
  String get vitalityMarkRead => 'Marquer comme lu';

  @override
  String get vitalityMarkReadDone => 'Lu';

  @override
  String get vitalityMarkReadSuccess => 'Marqué comme lu';

  @override
  String get vitalityMedicalDisclaimer =>
      'Contenu éducatif uniquement — ne constitue pas un avis médical.';

  @override
  String get vitalityMetricsEmpty => 'Aucune mesure pour l\'instant';

  @override
  String get vitalityMetricsLast7Days => '7 derniers jours';

  @override
  String vitalityMetricsLastEntry(int score) {
    return 'Dernière saisie · énergie $score/10';
  }

  @override
  String get vitalityMetricsSave => 'Enregistrer les métriques';

  @override
  String get vitalityMetricsSaved => 'Enregistré';

  @override
  String get vitalityMetricsTapToLog => 'Appuyez pour enregistrer';

  @override
  String get vitalityMetricsTitle => 'Métriques quotidiennes';

  @override
  String get vitalityMorningEnergy => 'Énergie matinale';

  @override
  String get vitalityMyProgram => 'Mon programme';

  @override
  String get vitalityNotLogged => 'Non enregistré';

  @override
  String get vitalityPhaseFoundation => 'Fondation';

  @override
  String get vitalityPhaseOptimization => 'Optimisation';

  @override
  String get vitalityPhasePeak => 'Sommet';

  @override
  String get vitalityProgramAllWeeks => 'Toutes les semaines';

  @override
  String get vitalityProgramComplete => 'Programme terminé';

  @override
  String get vitalityProgramContinue => 'Continuer';

  @override
  String get vitalityProgramDisclaimer =>
      'Programme éducatif — ne remplace pas un traitement médical.';

  @override
  String get vitalityProgramDone => 'Terminé';

  @override
  String get vitalityProgramOverallProgress => 'Progression globale';

  @override
  String get vitalityProgramStartCta => 'Commencer le programme';

  @override
  String get vitalityProgramSubtitle =>
      '12 semaines pour optimiser votre énergie, sommeil et récupération';

  @override
  String get vitalityProgramTitle => 'Transformation Vitalité';

  @override
  String get vitalityProtocolBadgeEarned => 'Badge débloqué !';

  @override
  String get vitalityProtocolCompleteDay => 'Journée complétée';

  @override
  String vitalityProtocolStreak(int days) {
    return 'Série de $days jours';
  }

  @override
  String get vitalityProtocolTitle => 'Protocoles';

  @override
  String vitalityReadingTime(int minutes) {
    return '$minutes min de lecture';
  }

  @override
  String get vitalityReportCompletion => 'Achèvement';

  @override
  String get vitalityReportImproving =>
      'Vous progressez — poursuivez sur cette lancée.';

  @override
  String get vitalityReportKeepGoing =>
      'Chaque petit pas compte. Terminez quelques objectifs aujourd\'hui.';

  @override
  String get vitalityScientificSources => 'Sources';

  @override
  String vitalityScoreBreakdown(
    int sleep,
    int workout,
    int protein,
    int stress,
  ) {
    return 'Sommeil $sleep · Entraînement $workout · Protéines $protein · Stress $stress';
  }

  @override
  String get vitalityScoreLabel => 'Vitalité';

  @override
  String get vitalitySleepHint => 'Comment avez-vous dormi ?';

  @override
  String vitalitySleepHours(num hours) {
    return '$hours h';
  }

  @override
  String get vitalitySleepLog => 'Sommeil';

  @override
  String get vitalitySleepQuality => 'Qualité';

  @override
  String vitalityStreak(int days) {
    return 'Série de $days jours';
  }

  @override
  String get vitalityStressLevel => 'Stress';

  @override
  String get vitalityUnlockNextWeek => 'Débloquer la semaine suivante';

  @override
  String vitalityWeekProgress(int percent) {
    return '$percent%';
  }

  @override
  String get vitalityWeekReport => 'Rapport de la semaine';

  @override
  String vitalityWeekX(int week) {
    return 'Semaine $week';
  }

  @override
  String vitalityWeekXOf12(int week) {
    return 'Semaine $week sur 12';
  }

  @override
  String get vitalityWorkoutDone => 'Entraînement fait';

  @override
  String get vitalityWorkoutLog => 'Séance';

  @override
  String get vitalityWorkoutPending => 'Repos / Pas encore';

  @override
  String get vitalityWorkoutPerformance => 'Performance';

  @override
  String walkingEstimatedMinutes(int minutes) {
    return '~$minutes min';
  }

  @override
  String get walkingHealthBanner => 'Pas en direct du podomètre du téléphone';

  @override
  String get walkingManualStepsLabel => 'Pas aujourd\'hui';

  @override
  String get walkingUpdateSteps => 'Mettre à jour les pas';

  @override
  String get walkingWebManualBanner =>
      'Sur le Web, entrez les pas manuellement';

  @override
  String get vitalityKeyTakeaway => 'À retenir';

  @override
  String get dietMyPlan => 'Mon plan alimentaire';

  @override
  String get dietProgramsTitle => 'Programmes nutritionnels';

  @override
  String get dietQuizTitle => 'Quiz de plan alimentaire';

  @override
  String get dietQuizContinue => 'J\'ai compris — continuer';

  @override
  String get dietQuizYes => 'Oui';

  @override
  String get dietQuizNo => 'Non';

  @override
  String dietQuizHealthStep(int current, int total) {
    return 'Santé $current sur $total';
  }

  @override
  String dietQuizPrefStep(int current, int total) {
    return 'Préférences $current sur $total';
  }

  @override
  String get dietPrefBreadRice => 'Aimez-vous le pain et le riz ?';

  @override
  String get dietPrefSkipBreakfast =>
      'Pouvez-vous sauter le petit-déjeuner facilement ?';

  @override
  String get dietPrefSimpleRules =>
      'Préférez-vous des règles alimentaires simples ?';

  @override
  String get dietPrefEatsOut => 'Mangez-vous souvent à l\'extérieur ?';

  @override
  String get dietPrefWeights =>
      'Vous entraînez-vous régulièrement avec des charges ?';

  @override
  String get dietRecommendedBadge => 'Recommandé pour vous';

  @override
  String get dietActiveBadge => 'Actif';

  @override
  String get dietNeedsDoctor => 'Avis médical requis';

  @override
  String get dietReadWarning => 'Lire l\'avertissement';

  @override
  String dietCardMacros(int kcal, int protein) {
    return '$kcal kcal · ${protein}g de protéines';
  }

  @override
  String get dietHowItWorks => 'Comment ça marche';

  @override
  String get dietYourTargets => 'Vos objectifs';

  @override
  String get dietBestFor => 'Idéal pour';

  @override
  String get dietNotIdealFor => 'Non recommandé pour';

  @override
  String get dietRules => 'Règles';

  @override
  String get dietAllowedFoods => 'Aliments recommandés';

  @override
  String get dietLimitFoods => 'Aliments à limiter';

  @override
  String get dietSampleDay => 'Exemple de journée';

  @override
  String get dietSideEffects => 'Effets secondaires';

  @override
  String get dietTips => 'Conseils';

  @override
  String get dietEvidence => 'Données scientifiques';

  @override
  String get dietStopSigns => 'Signaux d\'arrêt';

  @override
  String get dietDisclaimer => 'Avertissement';

  @override
  String get dietStartProgram => 'Démarrer ce programme';

  @override
  String get dietDoctorGateTitle => 'Avis médical nécessaire';

  @override
  String get dietAckWarning => 'J\'ai lu l\'avertissement';

  @override
  String get dietMustAckWarning =>
      'Veuillez d\'abord confirmer que vous avez lu l\'avertissement';

  @override
  String get dietStartedToast => 'Programme nutritionnel démarré';

  @override
  String get dietClose => 'Fermer';

  @override
  String dietCarbsMax(int grams) {
    return 'Limite glucides : $grams g';
  }

  @override
  String dietWeeklyLoss(String kg) {
    return 'Perte hebdo est. ≈ $kg kg';
  }

  @override
  String get dietChoosePlanCard => 'Choisissez votre plan alimentaire';

  @override
  String dietFastingLeft(String time) {
    return 'Jeûne — $time restant';
  }

  @override
  String dietEatingWindowLeft(String time) {
    return 'Période de prise alimentaire — fin dans $time';
  }

  @override
  String dietWindowStartsAt(int hour) {
    return 'Début de la période de repas à $hour:00';
  }

  @override
  String get dietEditWindow => 'Modifier l\'heure de début';

  @override
  String get dietCarbsLimitLabel => 'Limite de glucides';

  @override
  String dietCarbsLimitProgress(int current, int max) {
    return '$current / $max g de glucides';
  }

  @override
  String get todayPlanTitle => 'PLAN DU JOUR';

  @override
  String todayPlanProgressSummary(int percent, int done, int total) {
    return 'Vous avez complété $percent% de votre journée · $done/$total éléments';
  }

  @override
  String get todayPlanNow => 'En ce moment';

  @override
  String get todayPlanPro => 'PRO';

  @override
  String todayPlanWaterReminder(int index, int total) {
    return 'Rappel d\'eau $index sur $total';
  }

  @override
  String todayPlanWaterGoalLine(int ml) {
    return 'Objectif quotidien : $ml ml';
  }

  @override
  String get todayPlanFastingOpen => 'Ouverture de la fenêtre de repas';

  @override
  String todayPlanFastingOpenSubtitle(int hours) {
    return 'Début de la période de repas (${hours}h)';
  }

  @override
  String get todayPlanFastingClose => 'Fermeture de la fenêtre de repas';

  @override
  String todayPlanFastingCloseSubtitle(int hours) {
    return 'Début du jeûne (${hours}h)';
  }

  @override
  String get todayPlanWorkout => 'Séance du jour';

  @override
  String get todayPlanSteps => 'Objectif de pas';

  @override
  String todayPlanStepsProgress(int current, int goal) {
    return '$current / $goal pas';
  }

  @override
  String get todayPlanVitalitySleepSubtitle =>
      'Enregistrez au moins 7,5 h dans Vitalité';

  @override
  String get todayPlanVitalityProteinSubtitle =>
      'Atteignez votre objectif de protéines';

  @override
  String get todayPlanVitalitySunSubtitle => 'Exposition à la lumière du matin';

  @override
  String get todayPlanVitalityStress => 'Gestion du stress';

  @override
  String get todayPlanVitalityStressSubtitle =>
      'Faites une séance de respiration';

  @override
  String get todayPlanVitalityZincSubtitle =>
      'Priorité au zinc et à la vitamine D dans l\'assiette';

  @override
  String get todayPlanSleepTarget => 'Objectif de sommeil';

  @override
  String get todayPlanSleepTargetSubtitle =>
      'Détendez-vous pour une nuit réparatrice';

  @override
  String get todayPlanProtocolItem => 'Protocole vitalité';

  @override
  String get todayPlanAiSuggestion => 'Suggestion du coach IA';

  @override
  String get todayPlanAiSuggestionSubtitle =>
      'Conseil personnalisé pour aujourd\'hui';

  @override
  String waterGoalBasedOnWeight(int kg) {
    return 'Basé sur votre poids ($kg kg)';
  }

  @override
  String get authErrorEmailRateLimit =>
      'Trop d\'e-mails envoyés, réessayez dans une heure';

  @override
  String get profileMyBody => 'Mon corps';

  @override
  String get profileGuestProgressHint => 'Invité — progrès non sauvegardés';

  @override
  String get profilePlanPro => 'Pro';

  @override
  String get profilePlanFree => 'Gratuit';

  @override
  String profileMemberSince(String date) {
    return 'Membre depuis le $date';
  }

  @override
  String get profileSaveProgressCta => 'Sauvegardez vos progrès';

  @override
  String get profileMyPlanSection => 'Mon programme';

  @override
  String get profileChangeDietPlan => 'Changer de plan';

  @override
  String get profileBodyMetricsSaved => 'Mensurations mises à jour';

  @override
  String get profileSaveBodyMetrics => 'Enregistrer';

  @override
  String get profileEditDisplayName => 'Nom d\'affichage';

  @override
  String get profileDisplayNameHint => 'Votre nom';

  @override
  String get profileFitnessGoal => 'Objectif';

  @override
  String get activityHubTitle => 'Activité & Santé';

  @override
  String get activityHubSubtitle =>
      'Séances GPS, métriques des montres et respiration guidée — sur mobile, connecté à votre montre.';

  @override
  String get activityHealthHomeCardTitle => 'Activité & Santé';

  @override
  String get activityHealthHomeCardSubtitle =>
      'Connectez votre montre ou lancez une sortie en plein air';

  @override
  String get outdoorWorkoutTitle => 'Séance en extérieur';

  @override
  String get outdoorWorkoutSubtitle =>
      'Marche, course ou vélo avec suivi GPS et guidage vocal';

  @override
  String get outdoorPickTitle => 'Choisir l\'activité';

  @override
  String get outdoorPickSubtitle =>
      'Le suivi GPS fonctionne uniquement pendant votre session.';

  @override
  String get outdoorTypeWalk => 'Marche';

  @override
  String get outdoorTypeRun => 'Course';

  @override
  String get outdoorTypeCycle => 'Cyclisme';

  @override
  String get outdoorGo => 'C\'est parti !';

  @override
  String get outdoorLocationDenied =>
      'L\'autorisation de localisation est requise pour les séances GPS.';

  @override
  String get outdoorDistance => 'Distance';

  @override
  String get outdoorDuration => 'Durée';

  @override
  String get outdoorPace => 'Allure';

  @override
  String get outdoorSpeed => 'Vitesse';

  @override
  String outdoorPaceMinKm(int min, int sec) {
    return '$min:$sec / km';
  }

  @override
  String outdoorSpeedKmh(String speed) {
    return '$speed km/h';
  }

  @override
  String outdoorCalories(int kcal) {
    return '$kcal kcal brûlées';
  }

  @override
  String get outdoorPause => 'Pause';

  @override
  String get outdoorResume => 'Reprendre';

  @override
  String get outdoorHoldToStop => 'Maintenez pour arrêter';

  @override
  String get outdoorStopTitle => 'Terminer la séance ?';

  @override
  String get outdoorStopBody =>
      'Votre itinéraire et vos statistiques seront enregistrés.';

  @override
  String get outdoorStopConfirm => 'Terminer';

  @override
  String get outdoorPaused => 'En pause';

  @override
  String get outdoorAutoPause => 'Pause automatique à l\'arrêt';

  @override
  String get outdoorHistoryTitle => 'Historique des séances';

  @override
  String get outdoorHistorySubtitle => 'Séances GPS précédentes';

  @override
  String get outdoorHistoryEmpty =>
      'Aucune séance en extérieur pour le moment.';

  @override
  String get outdoorDetailTitle => 'Détails de la séance';

  @override
  String get outdoorSplitsTitle => 'Temps intermédiaires au kilomètre';

  @override
  String outdoorSplitKm(int km) {
    return 'Km $km';
  }

  @override
  String get uxQuickOutdoor => 'Séance extérieure';

  @override
  String get uxQuickOutdoorSub => 'Marche, course ou vélo GPS';

  @override
  String get healthHubTitle => 'Santé';

  @override
  String get healthHubCardSubtitle =>
      'Fréquence cardiaque, sommeil, SpO₂ depuis votre montre';

  @override
  String get healthHubProgressSubtitle =>
      'Métriques de la montre et score de sommeil';

  @override
  String get healthNotMedical =>
      'Usage non médical. Les données proviennent de votre montre via Health Connect / Apple Santé.';

  @override
  String get healthFromWatch => 'Depuis votre montre';

  @override
  String get healthConnectWatchTitle => 'Connectez votre montre';

  @override
  String get healthConnectWatchBody =>
      'Autorisez l\'accès à Health Connect ou Apple Santé pour que Vireo affiche le rythme cardiaque, le sommeil, les pas et plus encore. Nous n\'estimons jamais les données vitales depuis le téléphone.';

  @override
  String get healthGrantPermission => 'Autoriser l\'accès santé';

  @override
  String get healthMetricHeartRate => 'Fréquence cardiaque';

  @override
  String get healthMetricRestingHr => 'FC au repos';

  @override
  String get healthMetricHrv => 'VFC (RMSSD)';

  @override
  String get healthMetricSpO2 => 'Oxygène sanguin';

  @override
  String get healthMetricSleep => 'Sommeil';

  @override
  String get healthMetricWeight => 'Poids';

  @override
  String get healthMetricWorkout => 'Séances';

  @override
  String get healthMetricSteps => 'Pas';

  @override
  String get healthManualSleepTitle => 'Journal de sommeil manuel';

  @override
  String get healthManualSleepHint =>
      'Pas de données de montre — appuyez pour saisir coucher et qualité';

  @override
  String healthSleepScore(int score) {
    return 'Score de sommeil $score';
  }

  @override
  String get healthBedtime => 'Heure du coucher';

  @override
  String get healthWakeTime => 'Heure du réveil';

  @override
  String get healthSleepQuality => 'Qualité (1–5)';

  @override
  String get healthStressTitle => 'Niveau de stress (VFC)';

  @override
  String get healthStressLow => 'Faible';

  @override
  String get healthStressMedium => 'Modéré';

  @override
  String get healthStressHigh => 'Élevé';

  @override
  String healthHrvDetail(int today, int baseline) {
    return 'Aujourd\'hui $today ms vs moyenne sur 14 jours $baseline ms';
  }

  @override
  String get breathingHubTitle => 'Respiration';

  @override
  String get breathingHubSubtitle => 'Séances guidées pour apaiser le stress';

  @override
  String get breathingBoxTitle => 'Respiration carrée 4-4-4-4';

  @override
  String get breathingBoxSubtitle =>
      'Inspiration, rétention, expiration, rétention égales';

  @override
  String get breathing478Title => 'Relaxation 4-7-8';

  @override
  String get breathing478Subtitle => 'Schéma relaxant avant de dormir';

  @override
  String breathingMinutes(int min) {
    return '$min min';
  }

  @override
  String get breathingSessionTitle => 'Séance de respiration';

  @override
  String get breathingInhale => 'Inspirez';

  @override
  String get breathingHold => 'Bloquez';

  @override
  String get breathingExhale => 'Expirez';

  @override
  String get breathingRest => 'Pause';

  @override
  String get mealReviewTitle => 'Vérifier le repas';

  @override
  String get mealReviewAddItem => 'Ajouter un aliment';

  @override
  String get mealReviewSlot => 'Repas';

  @override
  String mealReviewRemaining(int kcal) {
    return 'Budget restant : $kcal kcal';
  }

  @override
  String get mealReviewEstimated => 'estimé';

  @override
  String get mealReviewCheckAmount => 'vérifiez la quantité';

  @override
  String get mealReviewSearchFood => 'Rechercher un aliment…';

  @override
  String get mealReviewLogByText => 'Saisir sous forme de texte';

  @override
  String get mealLogTextTitle => 'Enregistrer par texte';

  @override
  String get mealLogTextHint =>
      'Décrivez ce que vous avez mangé — en français ou en anglais.';

  @override
  String get mealLogTextPlaceholder =>
      'Ex. : 2 œufs, une tranche de pain complet et un thé sans sucre';

  @override
  String get mealLogTextAnalyze => 'Analyser';

  @override
  String get mealVoiceStart => 'Voix';

  @override
  String get mealVoiceListening => 'Écoute en cours…';

  @override
  String get mealVoiceUnavailable =>
      'Entrée vocale indisponible sur cet appareil';

  @override
  String get mealBarcodeTitle => 'Scanner un code-barres';

  @override
  String get mealBarcodeFailed =>
      'Impossible de trouver ce produit. Réessayez ou ajoutez par texte.';

  @override
  String get mealScanHintLabel => 'Ajoutez une précision (optionnel)';

  @override
  String get mealScanHintPlaceholder => 'Huile ? Sauce ? Type de pain ?';

  @override
  String get mealHowCalculated => 'Méthode de calcul';

  @override
  String get plateSizeAskTitle =>
      'Quelle est la taille habituelle de votre assiette ?';

  @override
  String get plateSizeSmall => 'Petite';

  @override
  String get plateSizeMedium => 'Moyenne';

  @override
  String get plateSizeLarge => 'Grande';

  @override
  String get inbodyScanTitle => 'Scanner le bilan InBody';

  @override
  String get inbodyReviewTitle => 'Vérifier le résultat InBody';

  @override
  String get inbodyBodyTitle => 'Composition corporelle';

  @override
  String get inbodyAddResult => 'Ajouter un résultat InBody';

  @override
  String get inbodyPickPdf => 'Choisir un PDF';

  @override
  String get inbodyFrameHint => 'Cadrez l\'ensemble de la feuille de résultats';

  @override
  String get inbodyAnalyzing => 'Lecture de votre bilan en cours…';

  @override
  String get inbodyUnreadable =>
      'Feuille illisible. Essayez avec une photo plus nette.';

  @override
  String get inbodyScanFailed => 'Échec de l\'analyse InBody. Réessayez.';

  @override
  String get inbodySaved => 'Résultat InBody enregistré';

  @override
  String get inbodyMedicalNote =>
      'Usage non médical — suivi de condition physique uniquement.';

  @override
  String get inbodyTestDate => 'Date du test';

  @override
  String get inbodyDevice => 'Appareil';

  @override
  String get inbodyWeight => 'Poids (kg)';

  @override
  String get inbodySmm => 'Masse musculaire squelettique (kg)';

  @override
  String get inbodyFatMass => 'Masse grasse (kg)';

  @override
  String get inbodyPbf => '% masse grasse';

  @override
  String get inbodyBmi => 'IMC';

  @override
  String get inbodyVisceral => 'Niveau de graisse viscérale';

  @override
  String get inbodyBmr => 'Métabolisme de base (kcal)';

  @override
  String get inbodyScore => 'Score InBody';

  @override
  String get inbodySave => 'Enregistrer le résultat';

  @override
  String get inbodyEmpty =>
      'Aucun bilan de composition corporelle. Scannez une feuille InBody pour commencer.';

  @override
  String get inbodyLatestTitle => 'Dernier bilan';

  @override
  String get inbodyCompareTitle => 'Comparer deux bilans';

  @override
  String get inbodySyncHealth => 'Synchroniser Health Connect';

  @override
  String get inbodySyncedLabel => 'Synchronisé depuis Health Connect';

  @override
  String inbodySyncResult(int count) {
    return '$count mesure(s) Health Connect importée(s)';
  }

  @override
  String inbodyFromDateLabel(String date) {
    return 'd\'après votre InBody du $date';
  }

  @override
  String get uxQuickInbody => 'Bilan InBody';

  @override
  String get uxQuickInbodySub => 'Scanner une feuille de résultats';

  @override
  String get mealScanHeroTitle => 'Scannez votre repas';

  @override
  String get mealScanHeroSubtitle =>
      'L\'IA identifie les aliments — vous validez les quantités';

  @override
  String get mealScanTipAbove => 'Prenez la photo du dessus';

  @override
  String get mealScanTipWholePlate => 'Assiette entière visible';

  @override
  String get mealScanTipLight => 'Bon éclairage';

  @override
  String get mealScanFlashOn => 'Flash activé';

  @override
  String get mealScanFlashOff => 'Flash désactivé';

  @override
  String get uxQuickMealText => 'Repas par texte';

  @override
  String get uxQuickMealTextSub => 'Tapez ce que vous avez mangé';

  @override
  String get uxQuickBarcode => 'Code-barres';

  @override
  String get uxQuickBarcodeSub => 'Recherche Open Food Facts';

  @override
  String get mealFavoriteSave => 'Ajouter aux favoris';

  @override
  String get mealFavoriteSaved => 'Enregistré dans les favoris';

  @override
  String get mealFavoritesTitle => 'Favoris';

  @override
  String get mealRecentTitle => 'Repas récents';

  @override
  String get mealRelog => 'Enregistrer à nouveau';

  @override
  String get appearanceTitle => 'Apparence';

  @override
  String get themeModeSystem => 'Par défaut du système';

  @override
  String get themeModeLight => 'Mode clair';

  @override
  String get themeModeDark => 'Mode sombre';

  @override
  String get accentThemeTitle => 'Couleur d\'accentuation';

  @override
  String get accentEmber => 'Braise (Défaut)';

  @override
  String get accentOcean => 'Océan';

  @override
  String get accentForest => 'Forêt';

  @override
  String get accentRoyal => 'Royal';

  @override
  String detectedActivity(String activity) {
    return 'Détecté : $activity';
  }

  @override
  String get manualOverride => 'Remplacer';

  @override
  String get mealClarificationTitle => 'Précision rapide';

  @override
  String get celebrationWaterTitle => 'Objectif d\'hydratation atteint ! 💧';

  @override
  String get celebrationProteinTitle => 'Objectif de protéines pulvérisé ! 💪';

  @override
  String get celebrationStepsTitle => 'Objectif de pas accompli ! 🏃';

  @override
  String get celebrationWorkoutTitle => 'Séance terminée ! 🔥';

  @override
  String fatEquivalentApprox(String amount) {
    return '≈ $amount de graisse';
  }

  @override
  String fatEquivalentBurned(String amount) {
    return 'Brûlé ≈ $amount de graisse';
  }

  @override
  String fatEquivalentTodayDeficit(String amount) {
    return 'Déficit du jour ≈ $amount de graisse';
  }

  @override
  String fatEquivalentTodaySurplus(int kcal) {
    return 'Surplus +$kcal kcal';
  }

  @override
  String fatEquivalentDietPlanRate(String daily, String weekly) {
    return '≈ $daily graisse/jour • ≈ $weekly/sem.';
  }

  @override
  String fatEquivalentThisWeek(String amount) {
    return '≈ $amount de graisse cette semaine';
  }

  @override
  String get fatEquivalentInfoTitle => 'Équivalent en graisse';

  @override
  String get fatEquivalentInfoBody =>
      'Le poids réel sur la balance varie aussi avec l\'eau et le glycogène, donc le poids quotidien peut évoluer différemment. Ceci est l\'équivalent énergétique de la graisse.';

  @override
  String get fatEquivalentInfoDismiss => 'Compris';

  @override
  String get legalTerms => 'Conditions';

  @override
  String get legalPrivacy => 'Confidentialité';

  @override
  String get legalMedicalDisclaimer => 'Avis médical';

  @override
  String get welcomeTagline =>
      'Nutrition intelligente et fitness sur mesure conçus pour les hommes.';

  @override
  String get welcomePillarScannerTitle => 'Scanner d\'assiette instantané';

  @override
  String get welcomePillarScannerDesc =>
      'Prenez votre plat en photo, obtenez calories et protéines en 2 secondes';

  @override
  String get welcomePillarPlanTitle => 'Plan quotidien personnalisé';

  @override
  String get welcomePillarPlanDesc =>
      'Objectifs scientifiques adaptés à votre morphologie et vos buts';

  @override
  String get welcomePillarSafetyTitle => 'Nutrition médicalement sûre';

  @override
  String get welcomePillarSafetyDesc =>
      'Des conseils qui préservent votre métabolisme et votre santé';

  @override
  String get onboardingGoalTitle => 'Quel est votre objectif principal ?';

  @override
  String get onboardingGoalSubtitle =>
      'Choisissez ce qui compte le plus. Nous adapterons vos objectifs quotidiens.';

  @override
  String get goalLoseFatTitle => 'Perdre du gras';

  @override
  String get goalLoseFatSubtitle =>
      'Brûlez les graisses tenaces tout en préservant votre masse musculaire';

  @override
  String get goalBuildMuscleTitle => 'Prendre du muscle';

  @override
  String get goalBuildMuscleSubtitle =>
      'Maximisez la prise de muscle sec avec un apport optimal en protéines';

  @override
  String get goalMoreEnergyTitle => 'Plus d\'énergie';

  @override
  String get goalMoreEnergySubtitle =>
      'Éliminez les coups de fatigue et boostez votre vitalité quotidienne';

  @override
  String get goalAllOfAboveTitle => 'Tout ce qui précède';

  @override
  String get goalAllOfAboveSubtitle =>
      'Recomposition corporelle totale : moins de gras, plus de force et vitalité';

  @override
  String get onboardingBodyTitle => 'Votre profil corporel';

  @override
  String get onboardingBodySubtitle =>
      'Des mesures précises nous permettent de calculer vos dépenses caloriques exactes.';

  @override
  String get sexMale => 'Homme';

  @override
  String get sexFemale => 'Femme';

  @override
  String get unitMetric => 'Métrique';

  @override
  String get unitImperial => 'Impérial (lb)';

  @override
  String get bodyMetricAge => 'Âge';

  @override
  String bodyMetricYears(int age) {
    return '$age ans';
  }

  @override
  String get selectAgeTitle => 'Sélectionnez l\'âge';

  @override
  String ageYearsSuffix(int age) {
    return '$age ans';
  }

  @override
  String get bodyMetricHeight => 'Taille';

  @override
  String get selectHeightTitle => 'Sélectionnez la taille';

  @override
  String get bodyMetricCurrentWeight => 'Poids actuel';

  @override
  String get selectCurrentWeightTitle => 'Sélectionnez le poids actuel';

  @override
  String get bodyMetricTargetWeight => 'Poids cible';

  @override
  String get selectTargetWeightTitle => 'Sélectionnez le poids cible';

  @override
  String get pickerDone => 'Terminé';

  @override
  String get onboardingActivityTitle => 'Activité et lieu d\'entraînement';

  @override
  String get onboardingActivitySubtitle =>
      'Nous ajustons vos dépenses caloriques et recommandons des entraînements optimaux.';

  @override
  String get dailyActivityLevelHeader => 'NIVEAU D\'ACTIVITÉ QUOTIDIENNE';

  @override
  String get activitySedentaryTitle => 'Sédentaire / Travail de bureau';

  @override
  String get activitySedentarySubtitle =>
      'Peu de marche, travail assis, moins de 5 000 pas';

  @override
  String get activityModeratelyActiveTitle => 'Modérément actif';

  @override
  String get activityModeratelyActiveSubtitle =>
      'Régulièrement debout, de 6 000 à 10 000 pas par jour';

  @override
  String get activityVeryActiveTitle => 'Très actif / Métier physique';

  @override
  String get activityVeryActiveSubtitle =>
      'Toujours en mouvement ou plus de 12 000 pas par jour';

  @override
  String get trainingPlaceHeader => 'OÙ COMPTEZ-VOUS VOUS ENTRAÎNER ?';

  @override
  String get trainingPlaceGymTitle => 'Salle de sport';

  @override
  String get trainingPlaceGymSubtitle =>
      'Accès complet aux barres, machines et haltères';

  @override
  String get trainingPlaceHomeTitle => 'À la maison';

  @override
  String get trainingPlaceHomeSubtitle =>
      'Poids du corps, bandes élastiques ou haltères légers';

  @override
  String get trainingPlaceWalkingTitle => 'Marche';

  @override
  String get trainingPlaceWalkingSubtitle =>
      'Séances de marche cardio en plein air';

  @override
  String get onboardingHealthSafetyTitle => 'Bilan de sécurité sanitaire';

  @override
  String get onboardingHealthSafetySubtitle =>
      'Indiquez vos conditions médicales pour un programme 100% sûr.';

  @override
  String get healthSafetyNoneApply => 'Aucun de ces éléments ne me concerne';

  @override
  String get healthSafetyOrSelect => 'OU SÉLECTIONNEZ CE QUI S\'APPLIQUE';

  @override
  String get onboardingTryScanTitle => 'Découvrez le scan instantané';

  @override
  String get onboardingTryScanSubtitle =>
      'Voyez comment Vireo décompose vos repas en calories et macros en un instant.';

  @override
  String get tryScanSamplePlateTitle =>
      'Exemple d\'assiette riche en protéines';

  @override
  String get tryScanSamplePlateDesc =>
      'Poulet grillé, riz blanc et salade fraîche';

  @override
  String get tryScanAnalyzing => 'Analyse du plat en cours...';

  @override
  String get tryScanSampleCta => 'Scanner l\'assiette exemple (Instantané)';

  @override
  String get tryScanOrTestLive => 'OU TESTEZ EN DIRECT';

  @override
  String get tryScanOwnMealTitle => 'Scannez votre propre repas';

  @override
  String get tryScanOwnMealDesc => 'Prenez une photo de votre plat actuel';

  @override
  String get onboardingPlanRevealTitle => 'Votre plan personnalisé';

  @override
  String get onboardingPlanRevealSubtitle =>
      'Conçu pour votre métabolisme et votre objectif physique.';

  @override
  String get planRevealStartPlan => 'Commencer mon plan';

  @override
  String get planRevealProjectedPace => 'RYTHME PRÉVU';

  @override
  String get planRevealSteadyRecomp => 'Recomposition corporelle progressive';

  @override
  String planRevealFatLossPace(String amount) {
    return '-$amount kg / semaine de perte de gras';
  }

  @override
  String planRevealLeanMassPace(String amount) {
    return '+$amount kg / semaine de muscle sec';
  }

  @override
  String get planRevealDailyCalories => 'OBJECTIF CALORIQUE QUOTIDIEN';

  @override
  String get planRevealPersonalizedBadge => 'Personnalisé';

  @override
  String get planRevealKcalPerDay => 'kcal / jour';

  @override
  String get planRevealDailyProtein => 'PROTÉINES DU JOUR';

  @override
  String get planRevealGramPerDay => 'g / jour';

  @override
  String get planRevealHydration => 'HYDRATATION';

  @override
  String get planRevealDailySteps => 'PAS QUOTIDIENS';

  @override
  String get planRevealStepsPerDay => 'pas / jour';

  @override
  String get planRevealDietProtocol => 'PROTOCOLE NUTRITION';

  @override
  String get planRevealOptimalMatch => 'Choix optimal';

  @override
  String get planRevealBalancedPlanDefault => 'Plan de déficit équilibré';

  @override
  String get onboardingNotificationsTitle => 'Ne manquez aucun objectif';

  @override
  String get onboardingNotificationsSubtitle =>
      'De discrets rappels pour garder le cap sur vos repas, hydratation et sport.';

  @override
  String get notificationsHeroTitle =>
      'Conçu pour la régularité, pas pour le spam';

  @override
  String get notificationsHeroBody =>
      'Les utilisateurs qui activent les rappels ont 3,4 fois plus de chances d\'atteindre leur poids idéal.';

  @override
  String get notificationsMealLoggingTitle => 'Suivi des repas et assiettes';

  @override
  String get notificationsMealLoggingDesc =>
      'Rappels aux heures du déjeuner et du dîner';

  @override
  String get notificationsWorkoutSessionTitle => 'Séance de sport quotidienne';

  @override
  String get notificationsWorkoutSessionDesc =>
      'Restez fidèle à votre planning sportif';

  @override
  String get notificationsWeeklyReviewTitle => 'Bilan hebdomadaire';

  @override
  String get notificationsWeeklyReviewDesc =>
      'Pesée du dimanche et ajustement de votre plan';

  @override
  String get notificationsEnableButton => 'Activer les rappels';

  @override
  String get notificationsMaybeLater => 'Peut-être plus tard';

  @override
  String get onboardingPaywallTitle => 'Accélérez vos résultats';

  @override
  String get onboardingPaywallSubtitle =>
      'Scans illimités, programmes d\'entraînement IA complets et analyses avancées.';

  @override
  String get paywallProBadge => 'VIREO PRO';

  @override
  String get paywallFeatureUnlimitedScansDesc =>
      'Oubliez les limites ou quotas quotidiens';

  @override
  String get paywallFeatureSmartSub =>
      'Substitutions intelligentes par IA et meal prep';

  @override
  String get paywallFeatureSmartSubDesc =>
      'Échanges instantanés adaptés à vos macros pour vos plats';

  @override
  String get paywallFeatureAdaptiveSplits =>
      'Programmes d\'entraînement adaptatifs sur mesure';

  @override
  String get paywallFeatureAdaptiveSplitsDesc =>
      'Suivi de la surcharge progressive en salle ou chez soi';

  @override
  String get paywallPlanAnnualPrice => '4,99 \$ / mois';

  @override
  String get paywallPlanAnnualSubtext =>
      'Facturé annuellement (Économisez 50 %)';

  @override
  String get paywallBadgeBestValue => 'MEILLEURE OFFRE';

  @override
  String get paywallPlanMonthlyPrice => '9,99 \$ / mois';

  @override
  String get paywallPlanMonthlySubtext => 'Facturé mensuellement';

  @override
  String get paywallStartTrialCta => 'Essai gratuit de 7 jours';

  @override
  String get paywallContinueFreeTier => 'Continuer avec la version gratuite';

  @override
  String get appInitErrorFailed => 'Échec de l\'initialisation des services.';

  @override
  String get appInitRetry => 'Réessayer';

  @override
  String get privacyExportTitle => 'Exporter mes données';

  @override
  String get privacyExportReady =>
      'Votre fichier de données est prêt aux formats JSON et CSV :';

  @override
  String get weeklyProgressShareFailed =>
      'Impossible de générer l\'image à partager';

  @override
  String get adaptiveCalorieCurrentTarget => 'Cible actuelle';

  @override
  String get adaptiveCalorieSuggestedTarget => 'Cible suggérée';

  @override
  String get adaptiveCalorieWindowSpan => 'Période';

  @override
  String get adaptiveCalorieFoodLogsCount => 'Jours de repas enregistrés';

  @override
  String get adaptiveCalorieWeighInsCount => 'Nombre de pesées';

  @override
  String get adaptiveCalorieAverageIntake => 'Apport moyen';

  @override
  String get adaptiveCalorieTrendWeightChange => 'Tendance de poids';

  @override
  String get adaptiveCalorieEstimatedMaintenance => 'Maintenance estimée';

  @override
  String get adaptiveCalorieWeeklyChangeCap =>
      'Plafond de variation hebdomadaire';

  @override
  String get adaptiveCalorieSafetyFloorApplied => 'Seuil de sécurité appliqué';

  @override
  String get chartSevenDayTrend => 'Tendance 7 jours';

  @override
  String get chartThirtyDayTrend => 'Tendance 30 jours';

  @override
  String get chartRawDot => 'Mesure brute';

  @override
  String get chartTrendLine => 'Ligne de tendance';

  @override
  String get chartGoalLine => 'Ligne d\'objectif';
}
