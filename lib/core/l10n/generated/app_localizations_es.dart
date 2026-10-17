// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Vireo';

  @override
  String get homeTitle => 'Inicio';

  @override
  String get onboardingTitle => 'Bienvenido';

  @override
  String get workoutTitle => 'Entrenamiento';

  @override
  String get nutritionTitle => 'Nutrición';

  @override
  String get progressTitle => 'Progreso';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get authTitle => 'Iniciar sesión';

  @override
  String get languageToggle => 'Español';

  @override
  String get setupComplete => 'Vireo está listo';

  @override
  String get continueButton => 'Continuar';

  @override
  String get skipButton => 'Omitir';

  @override
  String get finishButton => 'Finalizar';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get saveButton => 'Save';

  @override
  String get yesButton => 'Sí';

  @override
  String get noButton => 'No';

  @override
  String onboardingStepProgress(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String get onboardingStep1Title => 'Sobre ti';

  @override
  String get onboardingStep1Subtitle =>
      'Personalizaremos tu plan a partir de estos datos básicos.';

  @override
  String get onboardingStep2Title => 'Evaluación de salud';

  @override
  String get onboardingStep2Subtitle =>
      'Responde con sinceridad — esto nos ayuda a mantener tus entrenamientos más seguros.';

  @override
  String get onboardingStep3Title => 'Dónde entrenas';

  @override
  String get onboardingStep3Subtitle =>
      'Solo mostraremos ejercicios que se adapten a tu equipamiento.';

  @override
  String get onboardingStep4Title => 'Tu objetivo';

  @override
  String get onboardingStep4Subtitle =>
      '¿Qué es lo más importante en este momento?';

  @override
  String get onboardingStep5Title => 'Antes de comenzar';

  @override
  String get onboardingStep5Subtitle =>
      'Por favor lee y acepta para continuar.';

  @override
  String get onboardingStep6Title => 'Mantén el rumbo';

  @override
  String get onboardingStep6Subtitle =>
      'Recordatorios opcionales — puedes cambiarlos más adelante.';

  @override
  String get unitsMetric => 'kg / cm';

  @override
  String get unitsImperial => 'lb / in';

  @override
  String get onboardingAge => 'Edad';

  @override
  String get onboardingHeight => 'Estatura';

  @override
  String get onboardingWeight => 'Peso';

  @override
  String get onboardingActivityLevel => 'Nivel de actividad';

  @override
  String get onboardingDietaryOptional => 'Restricciones dietéticas (opcional)';

  @override
  String get activitySedentary => 'Mayormente sedentario';

  @override
  String get activityModerate => 'Moderadamente activo';

  @override
  String get activityVeryActive => 'Muy activo';

  @override
  String get dietHalal => 'Halal';

  @override
  String get dietVegetarian => 'Vegetariano';

  @override
  String get dietVegan => 'Vegano';

  @override
  String get dietGlutenFree => 'Sin gluten';

  @override
  String get dietDairyFree => 'Sin lácteos';

  @override
  String get dietLowSodium => 'Bajo en sodio';

  @override
  String get dietLowCarb => 'Bajo en carbohidratos';

  @override
  String get dietDiabeticFriendly => 'Apto para diabéticos';

  @override
  String get onboardingMedicalFlagNotice =>
      'Ajustaremos la intensidad y mostraremos recordatorios de seguridad durante el entrenamiento.';

  @override
  String get healthQuestionHeart =>
      '¿Enfermedad cardíaca o afección cardiovascular?';

  @override
  String get healthQuestionDiabetes =>
      '¿Diabetes o afección de glucosa en sangre?';

  @override
  String get healthQuestionBloodPressure => '¿Presión arterial alta o baja?';

  @override
  String get healthQuestionJoints => '¿Lesiones articulares o dolor crónico?';

  @override
  String get healthQuestionMedications => '¿Tomas medicamentos habitualmente?';

  @override
  String get envHomeNoEquipment => 'Casa — sin equipo';

  @override
  String get envHomeNoEquipmentDesc => 'Solo ejercicios con peso corporal';

  @override
  String get envHomeLightEquipment => 'Casa — equipo ligero';

  @override
  String get envHomeLightEquipmentDesc => 'Bandas, mancuernas o similar';

  @override
  String get envGymFull => 'Gimnasio completo';

  @override
  String get envGymFullDesc => 'Máquinas, barras y acceso a rack completo';

  @override
  String get envWalkingOnly => 'Solo caminata';

  @override
  String get envWalkingOnlyDesc => 'Objetivos de pasos y movilidad ligera';

  @override
  String get goalWeightLoss => 'Pérdida de peso';

  @override
  String get goalWeightLossDesc =>
      'Pérdida de grasa con entrenamiento sostenible';

  @override
  String get goalMuscleGain => 'Ganancia muscular';

  @override
  String get goalMuscleGainDesc => 'Enfoque en fuerza y masa magra';

  @override
  String get goalGeneralVitality => 'Vitalidad general';

  @override
  String get goalGeneralVitalityDesc => 'Energía, constancia y sentirse mejor';

  @override
  String get goalAllOfAbove => 'Todo lo anterior';

  @override
  String get goalAllOfAboveDesc => 'Plan equilibrado entre todos los objetivos';

  @override
  String get legalDisclaimerText =>
      'Vireo es una herramienta de organización de fitness y no sustituye el asesoramiento médico profesional. El contenido (entrenamientos, planes de comidas e información sobre salud) es solo para orientación general.\n\nSi padeces alguna afección crónica — como cardiopatías, diabetes, hipertensión o lesiones articulares actuales — o tomas medicación, consulta a tu médico antes de iniciar cualquier programa de ejercicio o nutrición.\n\nLa información sobre suplementos dietéticos y pautas hormonales (como la testosterona) es únicamente de carácter educativo general. No constituye una prescripción médica ni una recomendación de tratamiento.\n\nAl participar en cualquier programa de la aplicación, confirmo que he leído los términos y comprendo que Vireo no se responsabiliza por lesiones o complicaciones de salud derivadas del uso de la aplicación sin consulta médica.';

  @override
  String get legalDisclaimerSection1 =>
      'Vireo es una herramienta de organización de fitness y no sustituye el asesoramiento médico profesional. El contenido (entrenamientos, planes de comidas e información sobre salud) es solo para orientación general.';

  @override
  String get legalDisclaimerSection2 =>
      'Si padeces alguna afección crónica — como cardiopatías, diabetes, hipertensión o lesiones articulares actuales — o tomas medicación, consulta a tu médico antes de iniciar cualquier programa de ejercicio o nutrición.';

  @override
  String get legalDisclaimerSection3 =>
      'Los suplementos dietéticos son únicamente información educativa general. No constituyen prescripciones médicas ni recomendaciones de tratamiento.';

  @override
  String get legalDisclaimerSection4 =>
      'La información relacionada con hormonas (como la testosterona) es únicamente de carácter educativo general. No constituye una prescripción médica ni una recomendación de tratamiento.';

  @override
  String get legalDisclaimerSection5 =>
      'Al participar en cualquier programa de la aplicación, confirmo que he leído los términos y comprendo que Vireo no se responsabiliza por lesiones o complicaciones de salud derivadas del uso de la aplicación sin consulta médica.';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get consentCheckboxLabel =>
      'He leído y acepto los términos y el aviso legal de salud';

  @override
  String get notificationWorkoutTime => 'Hora preferida de entrenamiento';

  @override
  String get notificationWalkingReminder => 'Recordatorio diario de caminata';

  @override
  String get notificationWeeklyCheckIn => 'Recordatorio de revisión semanal';

  @override
  String get notificationNotSet => 'No configurado';

  @override
  String get authWelcomeTitle => 'Te damos la bienvenida a Vireo';

  @override
  String get authWelcomeSubtitle =>
      'Inicia sesión para sincronizar tu progreso entre dispositivos, o continúa localmente como invitado.';

  @override
  String get authSaveProgressTitle => 'Guarda tu progreso';

  @override
  String get authSaveProgressSubtitle =>
      'Vincula una cuenta para que tu plan, escaneos y chats se sincronicen entre dispositivos.';

  @override
  String get signInWithApple => 'Iniciar sesión con Apple';

  @override
  String get signInWithGoogle => 'Iniciar sesión con Google';

  @override
  String get signInWithEmail => 'Iniciar sesión con correo electrónico';

  @override
  String get authContinueApple => 'Continuar con Apple';

  @override
  String get authContinueGoogle => 'Continuar con Google';

  @override
  String get authContinueEmail => 'Continuar con correo electrónico';

  @override
  String get authSignInWithPassword => 'Iniciar sesión con contraseña';

  @override
  String get authSendCode => 'Enviar código';

  @override
  String get authVerifyCode => 'Verificar código';

  @override
  String get authResendCode => 'Reenviar código';

  @override
  String authResendIn(int seconds) {
    return 'Reenviar en ${seconds}s';
  }

  @override
  String authOtpSentTo(String email) {
    return 'Enviamos un código de 6 dígitos a $email';
  }

  @override
  String get authBack => 'Atrás';

  @override
  String get continueAsGuest => 'Continuar como invitado';

  @override
  String get authEmail => 'Correo electrónico';

  @override
  String get authPassword => 'Contraseña';

  @override
  String get authSignIn => 'Iniciar sesión';

  @override
  String get authSignUp => 'Registrarse';

  @override
  String get authHasAccount => '¿Ya tienes una cuenta?';

  @override
  String get authNoAccount => '¿No tienes una cuenta?';

  @override
  String get authSignedIn => 'Sesión iniciada';

  @override
  String get authErrorGeneric =>
      'Algo salió mal. Por favor, inténtalo de nuevo.';

  @override
  String get authErrorOffline =>
      'Sin internet. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get authErrorWrongCode =>
      'Código incorrecto. Comprueba los dígitos e inténtalo de nuevo.';

  @override
  String get authErrorTooMany =>
      'Demasiados intentos, vuelve a intentarlo en un minuto.';

  @override
  String get authErrorInvalidEmail =>
      'Introduce una dirección de correo válida.';

  @override
  String get authErrorCancelled => 'Se canceló el inicio de sesión.';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get guestModeTitle => 'Modo invitado';

  @override
  String get guestModeSubtitle =>
      'Tu progreso se guarda solo en este dispositivo. Crea una cuenta para sincronizar y suscribirte.';

  @override
  String get profileStatWorkoutsLabel => 'Entrenamientos completados';

  @override
  String get profileStatStreakLabel => 'Racha de días';

  @override
  String get saveProgressToCloud => 'Guardar progreso en la nube';

  @override
  String get profileCloudSynced => 'Progreso sincronizado con tu cuenta';

  @override
  String get authGateTitle => 'Crea una cuenta';

  @override
  String get authGateSaveProgress =>
      'Crea una cuenta gratuita para guardar tu progreso en la nube y acceder desde cualquier dispositivo.';

  @override
  String get authGateSubscribe =>
      'Crea una cuenta antes de suscribirte para que tu acceso premium quede vinculado a ti.';

  @override
  String get authGateAiFeatures =>
      'Crea una cuenta gratuita para usar el escaneo de comidas con IA y Vireo Coach. Tus chats y escaneos se sincronizan de forma segura con tu cuenta.';

  @override
  String get authGateSignUp => 'Registrarse';

  @override
  String get authGateNotNow => 'Ahora no';

  @override
  String get deleteAccountTitle => 'Eliminar cuenta';

  @override
  String get deleteAccountWarningTitle => 'Esta acción no se puede deshacer';

  @override
  String get deleteAccountWarningBody =>
      'Todos los datos de tu perfil, registros de entrenamiento, planes de comidas y fotos de progreso se eliminarán permanentemente de nuestros servidores.';

  @override
  String get deleteAccountCancel => 'Cancelar';

  @override
  String get deleteAccountContinue => 'Continuar';

  @override
  String get deleteAccountConfirmTitle => 'Confirmar eliminación';

  @override
  String get deleteAccountConfirmInstructions =>
      'Escribe la palabra a continuación exactamente para confirmar la eliminación permanente de la cuenta:';

  @override
  String get deleteConfirmationWord => 'ELIMINAR';

  @override
  String get deleteAccountTypeHint => 'Escribe ELIMINAR';

  @override
  String get deleteAccountConfirmButton => 'Eliminar mi cuenta permanentemente';

  @override
  String get deleteAccountSuccess => 'Tu cuenta ha sido eliminada.';

  @override
  String get workoutMedicalWarning =>
      'Indicaste una afección de salud durante el registro. Detén el ejercicio si sientes dolor, mareos o falta de aire. Consulta a tu médico antes de realizar ejercicio intenso.';

  @override
  String get workoutWarmUpTitle => 'Calentamiento';

  @override
  String get workoutWarmUpSubtitle =>
      'Completa estos ejercicios de movilidad antes de tu entrenamiento principal.';

  @override
  String get workoutCoolDownTitle => 'Enfriamiento';

  @override
  String get workoutCoolDownSubtitle =>
      'Movilidad suave para ayudar a tu cuerpo a recuperarse.';

  @override
  String get workoutActiveTitle => 'Entrenamiento activo';

  @override
  String get workoutBeginWorkout => 'Comenzar entrenamiento';

  @override
  String get workoutFinishCoolDown => 'Finalizar enfriamiento';

  @override
  String get workoutStartButton => 'Comenzar entrenamiento de hoy';

  @override
  String get workoutTodayTitle => 'Programa de hoy';

  @override
  String workoutTodaySubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ejercicios principales',
      one: '1 ejercicio principal',
    );
    return '$_temp0';
  }

  @override
  String workoutPhaseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ejercicios',
      one: '1 ejercicio',
    );
    return '$_temp0';
  }

  @override
  String get workoutExerciseProgress => 'Ejercicio';

  @override
  String get workoutStatSets => 'Series';

  @override
  String get workoutStatReps => 'Reps';

  @override
  String get workoutStatRest => 'Descanso';

  @override
  String get workoutSetsLabel => 'Series';

  @override
  String workoutSetNumber(int number) {
    return 'Serie $number';
  }

  @override
  String get workoutPrevious => 'Anterior';

  @override
  String get workoutNext => 'Siguiente';

  @override
  String get workoutSwapExercise => 'Cambiar ejercicio';

  @override
  String get workoutSwapTitle => 'Cambiar ejercicio';

  @override
  String get workoutSwapSubtitle =>
      'Alternativas para el mismo grupo muscular y tu entorno de entrenamiento.';

  @override
  String get workoutSwapEmpty =>
      'No hay alternativas disponibles en este momento.';

  @override
  String get workoutRestTitle => 'Descanso';

  @override
  String get workoutRestSkip => 'Omitir';

  @override
  String get workoutRestAdd15 => '+15s';

  @override
  String get workoutPausedTitle => 'Entrenamiento en pausa';

  @override
  String get workoutResume => 'Reanudar';

  @override
  String get workoutEndWorkout => 'Finalizar entrenamiento';

  @override
  String get workoutRestart => 'Reiniciar entrenamiento';

  @override
  String get workoutEndConfirmTitle => '¿Finalizar entrenamiento?';

  @override
  String get workoutEndConfirmBody =>
      'Tu progreso en esta sesión no se guardará.';

  @override
  String get workoutFeedbackTitle => '¿Cómo estuvo este entrenamiento?';

  @override
  String get workoutFeedbackEasy => 'Fácil';

  @override
  String get workoutFeedbackJustRight => 'Adecuado';

  @override
  String get workoutFeedbackHard => 'Difícil';

  @override
  String get workoutVideoUnavailable => 'Video no disponible';

  @override
  String get workoutEmptyProgram => 'No hay ejercicios programados para hoy.';

  @override
  String get walkingTitle => 'Caminata';

  @override
  String get walkingStepsToday => 'pasos hoy';

  @override
  String walkingDailyGoal(int steps) {
    return 'Objetivo: $steps pasos';
  }

  @override
  String walkingGoalProgress(int percent) {
    return '$percent% del objetivo de hoy';
  }

  @override
  String get walkingWeeklyChartTitle => 'Últimos 7 días';

  @override
  String get walkingHealthSourceNote =>
      'Los pasos se cuentan en este dispositivo. Si Health Connect / Apple Health también están disponibles, Vireo muestra el conteo más alto.';

  @override
  String get walkingPermissionTitle => 'Acceso a pasos requerido';

  @override
  String get walkingPermissionBody =>
      'Vireo cuenta los pasos con los sensores de movimiento de tu teléfono. Permite el acceso a la actividad para que los objetivos de caminata y las calorías sean precisos.';

  @override
  String get walkingOpenSettings => 'Abrir Ajustes';

  @override
  String get walkingTryAgain => 'Intentar de nuevo';

  @override
  String get walkingUnavailableTitle => 'Seguimiento de caminata no disponible';

  @override
  String get walkingUnavailableBody =>
      'El seguimiento de pasos funciona mejor en un teléfono físico iOS o Android con sensor de podómetro.';

  @override
  String get walkingEnableTitle => 'Contar pasos en este teléfono';

  @override
  String get walkingEnableBody =>
      'Vireo utiliza el sensor de pasos de tu teléfono para registrar tu caminata en vivo: distancia, calorías y tu objetivo diario. A continuación te pediremos permiso de actividad física.';

  @override
  String get walkingEnableCta => 'Activar conteo de pasos';

  @override
  String get walkingActiveMinutes => 'Tiempo activo';

  @override
  String get nutritionTabBreakfast => 'Desayuno';

  @override
  String get nutritionTabLunch => 'Almuerzo';

  @override
  String get nutritionTabDinner => 'Cena';

  @override
  String get nutritionTabSnack => 'Snack';

  @override
  String get nutritionNoMealPlanned => 'No hay comida planificada para hoy.';

  @override
  String nutritionPrepMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get nutritionTagHighProtein => 'Alto en proteína';

  @override
  String get nutritionTagQuickEasy => 'Rápido y fácil';

  @override
  String get nutritionTagLightEnergy => 'Energía ligera';

  @override
  String get nutritionScanFridge => 'Escanear tu refrigerador';

  @override
  String nutritionScansRemaining(int count) {
    return 'Quedan $count escaneos de refrigerador este mes';
  }

  @override
  String get nutritionScanPrompt =>
      'Toma una foto de tu refrigerador o despensa para detectar ingredientes.';

  @override
  String get nutritionTakePhoto => 'Tomar foto';

  @override
  String get nutritionChoosePhoto => 'Elegir de la galería';

  @override
  String get nutritionScanning => 'Escaneando ingredientes…';

  @override
  String get nutritionScanFailed =>
      'Error al escanear. Inténtalo de nuevo o ingresa los ingredientes manualmente.';

  @override
  String get nutritionScanLimitReached =>
      'Límite mensual de escaneos alcanzado. Pasa a Premium para escaneos ilimitados.';

  @override
  String get nutritionConfirmIngredients => 'Confirmar ingredientes';

  @override
  String get nutritionIngredientsHint =>
      'Elimina lo que no sea correcto y agrega los artículos que falten.';

  @override
  String get nutritionAddIngredient => 'Agregar ingrediente';

  @override
  String get nutritionGetRecipes => 'Obtener ideas de recetas';

  @override
  String get nutritionNoIngredients => 'Agrega al menos un ingrediente.';

  @override
  String get nutritionRecipeSuggestions => 'Ideas de recetas';

  @override
  String get nutritionRecipeSuggestionsSubtitle =>
      'Según tus ingredientes, objetivo y preferencias dietéticas.';

  @override
  String get nutritionNoRecipesFound =>
      'No se encontraron recetas coincidentes.';

  @override
  String get nutritionManualEntry => 'Ingresar manualmente';

  @override
  String get nutritionManualEntryHint =>
      'Escribe lo que tienes a mano: te sugeriremos recetas adaptadas a tu objetivo y preferencias dietéticas.';

  @override
  String get nutritionSwapMeal => 'Cambiar comida';

  @override
  String get nutritionSwapMealSubtitle =>
      'Elige una receta diferente: sin repetir en 14 días.';

  @override
  String get nutritionSwapMealEmpty =>
      'No hay comidas alternativas disponibles en este momento.';

  @override
  String get nutritionDemoQuickMeals =>
      'Comidas de muestra rápidas y saludables';

  @override
  String get nutritionTryDemoScan => 'Probar escaneo de prueba';

  @override
  String get homeWelcomeSubtitle => 'Tu centro personalizado de fitness.';

  @override
  String get homeWalkingCardSubtitle =>
      'Registra tus pasos diarios desde Apple Health o Health Connect.';

  @override
  String get homeDailyProgramTitle => 'Programa diario';

  @override
  String get homeTodayWorkout => 'Entrenamiento de hoy';

  @override
  String get homeNextMeal => 'Próxima comida';

  @override
  String homeWorkoutExerciseCount(int count) {
    return '$count ejercicios';
  }

  @override
  String get progressTabWeight => 'Peso';

  @override
  String get progressTabAdherence => 'Constancia';

  @override
  String get progressTabEnergy => 'Energía';

  @override
  String get progressWeightChartTitle => 'Tendencia de peso';

  @override
  String progressWeightGoalLine(String value, String unit) {
    return 'Objetivo: $value $unit';
  }

  @override
  String get progressAdherenceChartTitle => 'Constancia semanal';

  @override
  String get progressAdherenceSubtitle =>
      '% de entrenamientos completados por semana';

  @override
  String get progressEnergyChartTitle => 'Niveles de energía';

  @override
  String get progressEnergySubtitle =>
      'Puntuación de energía de la revisión semanal (1–10)';

  @override
  String get progressLogWeight => 'Registrar peso';

  @override
  String progressWeightLabel(String unit) {
    return 'Peso ($unit)';
  }

  @override
  String get progressLogDate => 'Fecha';

  @override
  String get progressSaveWeight => 'Guardar';

  @override
  String get reassessmentTitle => 'Revisión mensual';

  @override
  String get reassessmentSubtitle =>
      'Actualiza tu peso, actividad y equipamiento de entrenamiento para mantener tu programa preciso.';

  @override
  String get reassessmentLater => 'Más tarde';

  @override
  String get reassessmentSubmit => 'Actualizar mi plan';

  @override
  String get reassessmentSummaryTitle => 'Qué cambió';

  @override
  String get reassessmentSummarySubtitle =>
      'En comparación con tu última revisión';

  @override
  String reassessmentPhaseUpdated(int phase) {
    return 'Fase del programa actualizada a la fase $phase';
  }

  @override
  String get reassessmentNoPhaseChange =>
      'No se necesitan cambios en el programa: ¡sigue adelante!';

  @override
  String get paywallTitle => 'Vireo Premium';

  @override
  String get paywallHeadline => 'Desbloquea todo tu potencial';

  @override
  String get paywallSubtitle =>
      'Premium te ofrece escaneos ilimitados, fases completas de programas y análisis más profundos de tu progreso.';

  @override
  String get paywallBestValue => 'Mejor opción';

  @override
  String get paywallPlanMonthly => 'Mensual';

  @override
  String get paywallPlanAnnual => 'Anual';

  @override
  String get paywallPlanLifetime => 'De por vida';

  @override
  String get paywallFeatureUnlimitedScans => 'Escaneo ilimitado de platos';

  @override
  String get paywallFeatureFullProgram =>
      'Fases completas de programas y entrenamientos progresivos';

  @override
  String get paywallFeatureCloudSync =>
      'Sincronización en la nube entre dispositivos';

  @override
  String get paywallFeatureProgressAnalytics =>
      'Análisis avanzados de progreso';

  @override
  String get paywallSubscribe => 'Suscribirse';

  @override
  String get paywallRestorePurchases => 'Restaurar compras';

  @override
  String get paywallPurchaseSuccess => '¡Te damos la bienvenida a Premium!';

  @override
  String get paywallPurchaseError =>
      'Error en la compra. Por favor, inténtalo de nuevo.';

  @override
  String get paywallRestoreSuccess => 'Compras restauradas correctamente.';

  @override
  String get paywallRestoreEmpty =>
      'No se encontró ninguna suscripción activa para esta cuenta.';

  @override
  String get paywallRestoreError =>
      'No se pudieron restaurar las compras. Inténtalo de nuevo más tarde.';

  @override
  String get paywallNotConfigured =>
      'Las suscripciones no están disponibles en esta versión.';

  @override
  String get paywallSubscriptionExpiredMessage =>
      'Tu suscripción ha caducado. Vuelve a suscribirte para desbloquear las funciones premium.';

  @override
  String get trialEndedTitle => 'Tu prueba ha terminado';

  @override
  String get trialEndedBody =>
      'Gracias por probar Vireo Premium. Suscríbete para mantener escaneos ilimitados, fases completas de programas y sincronización en la nube.';

  @override
  String get trialEndedViewPlans => 'Ver planes';

  @override
  String subscriptionTrialDaysRemaining(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Quedan $days días de tu prueba gratuita',
      one: 'Queda 1 día de tu prueba gratuita',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionExpiredBanner =>
      'Suscripción caducada: toca para renovar el acceso premium';

  @override
  String get subscriptionPremiumActive => 'Premium activo';

  @override
  String get subscriptionFreeTier => 'Plan gratuito';

  @override
  String get subscriptionUpgrade => 'Mejorar plan';

  @override
  String get settingsManageSubscription =>
      'Ver planes, suscribirse o restaurar compras';

  @override
  String workoutPhaseLockedTitle(int phase) {
    return 'Fase $phase bloqueada';
  }

  @override
  String get workoutPhaseLockedBody =>
      'Vuelve a suscribirte para continuar tu programa completo de entrenamiento. El seguimiento básico sigue disponible en el plan gratuito.';

  @override
  String homeGreeting(String name) {
    return 'Hola, $name 👋';
  }

  @override
  String homeDayPhase(int day, String phase) {
    return 'Día $day · Fase $phase';
  }

  @override
  String get homeGuestBanner =>
      'Estás en modo invitado: regístrate para guardar tu progreso';

  @override
  String get homeGuestSignUp => 'Registrarse';

  @override
  String get homeGuestCta => 'Regístrate ahora: gratis durante 7 días';

  @override
  String homeStreakDays(int days) {
    return 'Racha de $days días';
  }

  @override
  String get homeStartStreak => 'Comienza tu racha hoy';

  @override
  String get homeTodayWorkoutTitle => 'Entrenamiento de hoy';

  @override
  String get homeStartWorkout => 'Comenzar entrenamiento';

  @override
  String get homeRestDay => 'Día de descanso activo 🧘';

  @override
  String get homeBreakfast => 'Desayuno';

  @override
  String get homeMealConfirmed => 'Confirmado ✓';

  @override
  String get homeMealPending => 'Pendiente';

  @override
  String homeWalkingSteps(int current, int goal) {
    return '$current / $goal pasos';
  }

  @override
  String homeWeeklyProgress(int completed) {
    return '$completed / 7 días completados';
  }

  @override
  String get homeCheckInBanner =>
      '⏱️ Revisión semanal lista: solo toma un minuto';

  @override
  String get homeRecoveryScore => 'Puntuación de recuperación';

  @override
  String get homeRecoveryReady => 'Tu cuerpo está listo para entrenar';

  @override
  String get homeGuestName => 'Campeón';

  @override
  String get homePhaseFoundation => 'Fundamentos';

  @override
  String get nutritionFilterAll => 'Todo';

  @override
  String get nutritionFilterQuick => 'Rápido';

  @override
  String get nutritionFilterLowCalorie => 'Bajo en calorías';

  @override
  String nutritionMacroSummary(int calories, int protein) {
    return '$calories cal · ${protein}g proteína';
  }

  @override
  String get nutritionMacroBar => 'Cal | Proteína | Carbos | Grasa';

  @override
  String get nutritionMealConfirmed => 'Confirmado ✓';

  @override
  String nutritionFridgeBanner(int remaining) {
    return '📷 Escanea tu refrigerador: quedan $remaining escaneos este mes';
  }

  @override
  String get nutritionFridgeScanCta => 'Escanear';

  @override
  String get workoutWarmUpStep1 => 'Círculos con hombros — 30 segundos';

  @override
  String get workoutWarmUpStep2 => 'Marcha en el lugar — 60 segundos';

  @override
  String get workoutWarmUpStep3 => 'Sentadillas ligeras — 10 reps';

  @override
  String get workoutSkipWarmUp => 'Omitir calentamiento';

  @override
  String get workoutStartMainWorkout => 'Iniciar entrenamiento principal';

  @override
  String get workoutWarmUpComplete => 'Calentamiento listo — ¡a entrenar!';

  @override
  String homeProgramDay(int day, int total) {
    return 'Día $day de $total';
  }

  @override
  String get homeStartProgram => 'Iniciar tu programa';

  @override
  String get nutritionDailyCalorieGoal => 'Tu objetivo diario de calorías';

  @override
  String nutritionCalorieTargetSummary(
    int calories,
    int protein,
    int carbs,
    int fat,
  ) {
    return 'Objetivo: $calories cal — ${protein}g proteína, ${carbs}g carbohidratos, ${fat}g grasa';
  }

  @override
  String nutritionCalorieProgress(int consumed, int target) {
    return '$consumed / $target cal hoy';
  }

  @override
  String get nutritionEditCalorieGoal => 'Editar objetivo de calorías';

  @override
  String get nutritionCalorieHint => 'Calorías diarias';

  @override
  String get settingsThemeTitle => 'Apariencia';

  @override
  String get settingsThemeDark => 'Modo oscuro';

  @override
  String get settingsThemeLight => 'Modo claro';

  @override
  String get settingsThemeSystem => 'Predeterminado del sistema';

  @override
  String get progressAxisDate => 'Fecha';

  @override
  String get progressAxisWeight => 'Peso (kg)';

  @override
  String get progressAxisEnergy => 'Energía (1–10)';

  @override
  String get progressAllChartsTitle => 'Resumen de tu progreso';

  @override
  String get profileGuestAvatar => 'Invitado';

  @override
  String get profileStatProgramDays => 'Días del programa';

  @override
  String get profileStatsSection => 'Tus estadísticas';

  @override
  String get profileGoalWeight => 'Peso objetivo';

  @override
  String get profileCurrentBmi => 'IMC actual';

  @override
  String get profileActivityLevel => 'Nivel de actividad';

  @override
  String get profileEditProfile => 'Editar perfil';

  @override
  String get profileBmiUnderweight => 'Bajo peso';

  @override
  String get profileBmiHealthy => 'Peso saludable';

  @override
  String get profileBmiOverweight => 'Sobrepeso';

  @override
  String get profileBmiObese => 'Obesidad';

  @override
  String get profileBmiTooltip =>
      'El IMC (Índice de Masa Corporal) estima la grasa corporal a partir de la estatura y el peso. Es una guía general, no un diagnóstico.';

  @override
  String get workoutSplitChestTriceps => 'Pecho y tríceps';

  @override
  String get workoutSplitBackBiceps => 'Espalda y bíceps';

  @override
  String get workoutSplitLegs => 'Piernas';

  @override
  String get workoutSplitCardio => 'Cardio';

  @override
  String get workoutSplitShoulders => 'Hombros';

  @override
  String get workoutSplitFullBody => 'Cuerpo completo';

  @override
  String get workoutSplitRest => 'Día de descanso';

  @override
  String get habitsTitle => 'Hábitos diarios';

  @override
  String get habitsEmpty =>
      'No hay hábitos aún — toca + para agregar el primero';

  @override
  String get habitsAddTitle => 'Nuevo hábito';

  @override
  String get habitsAddHint => 'Nombre del hábito';

  @override
  String get habitsAddConfirm => 'Agregar';

  @override
  String habitsStreak(int days) {
    return 'Racha de $days días';
  }

  @override
  String get habitsRetry => 'Reintentar';

  @override
  String get habitsErrorTitle => 'No se pudieron cargar los hábitos';

  @override
  String homeRecoveryExplain(int score) {
    return 'Una puntuación de recuperación de $score% combina la calidad del sueño, los días de descanso y la fatiga muscular. Cuanto mayor sea, más preparado estará tu cuerpo para entrenar duro.';
  }

  @override
  String get homeRecoveryFactorSleep => 'Calidad del sueño';

  @override
  String get homeRecoveryFactorRest => 'Días de descanso';

  @override
  String get homeRecoveryFactorMuscle => 'Fatiga muscular';

  @override
  String get homeRecoveryTipSleep => 'Apunta a 7–9 horas esta noche';

  @override
  String get homeRecoveryTipRest =>
      'Mantén al menos un día completo de descanso por semana';

  @override
  String get homeRecoveryTipMuscle =>
      'Reduce la intensidad si el dolor muscular es alto';

  @override
  String get homeRecoveryImproveTitle => 'Consejos para mejorar';

  @override
  String get homeRecoveryImproveBody =>
      'Prioriza el sueño, hidrátate y cambia una sesión intensa por movilidad cuando aumente la fatiga.';

  @override
  String get walkingMetricsTitle => 'Métricas de caminata de hoy';

  @override
  String get walkingDistance => 'Distancia';

  @override
  String get walkingSpeed => 'Velocidad';

  @override
  String get walkingPace => 'Ritmo';

  @override
  String get walkingCalories => 'Calorías quemadas';

  @override
  String walkingWeightLoss(String kg) {
    return 'Quema est. de grasa ≈ $kg kg';
  }

  @override
  String walkingCadence(int spm) {
    return 'Cadencia ≈ $spm pasos/min';
  }

  @override
  String get walkingMetricsEstimatedNote =>
      'Health Connect no disponible — mostrando métricas estimadas a partir del conteo de pasos.';

  @override
  String get mealBuilderTitle => 'Personalizar ingredientes';

  @override
  String mealBuilderTitleFor(String meal) {
    return 'Personalizar $meal';
  }

  @override
  String get mealBuilderSubtitle =>
      'Ajusta la proteína, la grasa de cocción y los complementos — los macros se actualizan en vivo.';

  @override
  String get mealBuilderEggs => 'Huevos';

  @override
  String mealBuilderEggCount(int count) {
    return '$count huevos';
  }

  @override
  String mealBuilderPortionCount(int count) {
    return '$count porciones';
  }

  @override
  String get mealBuilderProteinLunch => 'Porciones de proteína';

  @override
  String get mealBuilderProteinDinner => 'Proteína de la cena';

  @override
  String get mealBuilderProteinSnack => 'Proteína del snack';

  @override
  String get mealBuilderFatSource => 'Fuente de grasa';

  @override
  String get mealBuilderFatButter => 'Mantequilla';

  @override
  String get mealBuilderFatGhee => 'Ghee';

  @override
  String get mealBuilderFatOliveOil => 'Aceite de oliva';

  @override
  String get mealBuilderFatSpray => 'Aceite en aerosol';

  @override
  String get mealBuilderAddOns => 'Complementos';

  @override
  String get mealBuilderAddonCheese => 'Queso';

  @override
  String get mealBuilderAddonVeggies => 'Verduras';

  @override
  String get mealBuilderAddonBread => 'Pan integral';

  @override
  String get mealBuilderAddonRice => 'Arroz';

  @override
  String get mealBuilderAddonYogurt => 'Yogur';

  @override
  String get mealBuilderLiveMacros => 'Macros en vivo';

  @override
  String get weeklyCheckInTitle => 'Revisión semanal';

  @override
  String get weeklyCheckInBanner =>
      'Momento de tu evaluación semanal — actualiza tu peso y energía';

  @override
  String get weeklyCheckInSubtitle =>
      'Recalcularemos tu TMB/GETD y macros para la próxima semana.';

  @override
  String get weeklyCheckInWeight => 'Peso actual';

  @override
  String get weeklyCheckInWaist => 'Medida de cintura';

  @override
  String get weeklyCheckInEnergy => 'Nivel de energía (1–5)';

  @override
  String weeklyCheckInAdherence(int pct) {
    return 'Constancia en el entrenamiento: $pct%';
  }

  @override
  String get weeklyCheckInSubmit => 'Actualizar mis objetivos';

  @override
  String get weeklyCheckInDoneTitle => 'Objetivos actualizados';

  @override
  String weeklyCheckInDoneBody(
    int prev,
    int next,
    int protein,
    int carbs,
    int fat,
  ) {
    return 'Calorías $prev → $next kcal. Macros: ${protein}g proteína, ${carbs}g carbohidratos, ${fat}g grasa.';
  }

  @override
  String get settingsAccentTitle => 'Color de acento';

  @override
  String get settingsAccentOrange => 'Naranja';

  @override
  String get settingsAccentEmerald => 'Esmeralda';

  @override
  String get settingsAccentBlue => 'Océano';

  @override
  String get settingsAccentViolet => 'Violeta';

  @override
  String get settingsSkinTitle => 'Temas visuales';

  @override
  String get settingsSkinStandard => 'Estándar';

  @override
  String get settingsSkinStandardDesc => 'Clásico Vireo oscuro / claro';

  @override
  String get settingsSkinAmoled => 'AMOLED Negro Puro';

  @override
  String get settingsSkinAmoledDesc => 'Negro puro con acentos dorados y cian';

  @override
  String get settingsSkinNavy => 'Azul Marino Profundo';

  @override
  String get settingsSkinNavyDesc =>
      'Marino #0B192C con azul hielo y verde azulado';

  @override
  String get settingsAccentLockedHint =>
      'Los colores de acento están bloqueados mientras el tema AMOLED / Marino esté activo.';

  @override
  String get workoutSwapWarmUp => 'Cambiar ejercicio de calentamiento';

  @override
  String get workoutSwapWarmUpTitle => 'Elige una alternativa de calentamiento';

  @override
  String get workoutSwapWarmUpSubtitle =>
      'Opciones de movilidad y bajo impacto para tu entorno de entrenamiento.';

  @override
  String get profileBmiExplainShort =>
      'El IMC evalúa el peso en relación con la estatura.';

  @override
  String get profileBmiExplainFull =>
      'El Índice de Masa Corporal (IMC) es una medida para evaluar el peso en relación con la estatura. Es una herramienta de evaluación general, no un diagnóstico médico.';

  @override
  String get mealBuilderCheeseTitle => 'Queso';

  @override
  String get mealBuilderCheeseNone => 'Sin queso';

  @override
  String get mealBuilderCheeseCottage => 'Queso cottage';

  @override
  String get mealBuilderCheeseCheddar => 'Cheddar';

  @override
  String get mealBuilderCheeseMozzarella => 'Mozzarella';

  @override
  String get mealBuilderCheeseFeta => 'Feta';

  @override
  String mealBuilderCheeseGrams(int grams) {
    return 'Cantidad: ${grams}g';
  }

  @override
  String get homeRecoveryFormulaExplain =>
      'Recuperación = Días de descanso (40%) + Meta de pasos (30%) + Constancia en comidas/entrenamiento (30%).';

  @override
  String get homeRecoveryFactorRestDays => 'Días de descanso';

  @override
  String get homeRecoveryFactorSteps => 'Meta de pasos';

  @override
  String get homeRecoveryFactorConsistency =>
      'Constancia en comidas y entrenamientos';

  @override
  String homeRecoveryRestDetail(int days) {
    return '$days día(s) de descanso esta semana';
  }

  @override
  String homeRecoveryStepsDetail(int current, int goal) {
    return '$current / $goal pasos hoy';
  }

  @override
  String homeRecoveryConsistencyDetail(
    int mealsDone,
    int mealsTotal,
    int wDone,
    int wTotal,
  ) {
    return 'Comidas $mealsDone/$mealsTotal · Entrenamientos $wDone/$wTotal';
  }

  @override
  String get homeRecoveryTipSteps =>
      'Alcanza tu objetivo diario de pasos para subir este pilar';

  @override
  String get homeRecoveryTipConsistency =>
      'Confirma tus comidas y completa los entrenamientos planificados';

  @override
  String homeRecoveryMathLine(int rest, int steps, int consistency, int total) {
    return '$rest + $steps + $consistency = $total%';
  }

  @override
  String get cardioTitle => 'Cardio y actividad diaria';

  @override
  String get cardioSubtitle =>
      'Registra caminatas rápidas, carreras y más — las calorías usan MET × peso × tiempo.';

  @override
  String get cardioSelectActivity => 'Actividad';

  @override
  String cardioDuration(int minutes) {
    return 'Duración: $minutes min';
  }

  @override
  String cardioEstimatedBurn(int kcal) {
    return 'Quema est.: $kcal kcal';
  }

  @override
  String cardioMetHint(String met) {
    return 'MET $met · fórmula: MET × kg × horas';
  }

  @override
  String get cardioLogButton => 'Registrar actividad';

  @override
  String get cardioLoggedSnack => 'Sesión de cardio registrada';

  @override
  String cardioTodayTotal(int kcal) {
    return 'Quemadas hoy: $kcal kcal';
  }

  @override
  String get cardioEmpty =>
      'No hay cardio registrado todavía — añade tu primera sesión arriba.';

  @override
  String cardioLogSubtitle(int minutes, int kcal) {
    return '$minutes min · $kcal kcal';
  }

  @override
  String get cardioLogCta => 'Registrar actividad de cardio';

  @override
  String get cardioBriskWalking => 'Caminata rápida';

  @override
  String get cardioRunning => 'Carrera';

  @override
  String get cardioCycling => 'Ciclismo';

  @override
  String get cardioSwimming => 'Natación';

  @override
  String get cardioJumpRope => 'Salto de cuerda';

  @override
  String get cardioHiit => 'HIIT';

  @override
  String get cardioElliptical => 'Elíptica';

  @override
  String workoutGoalPlanLabel(String goal) {
    return 'Plan para: $goal';
  }

  @override
  String get aiScanTitle => 'Escáner de comidas con IA';

  @override
  String get aiScanPrompt =>
      'Fotografía tu comida — la IA estima las calorías y macros según el tamaño de la porción.';

  @override
  String get aiScanCamera => 'Cámara';

  @override
  String get aiScanGallery => 'Galería';

  @override
  String get aiScanAnalyzing => 'Analizando comida…';

  @override
  String get aiScanOffline =>
      'Sin conexión a internet. Comprueba tu red e inténtalo de nuevo.';

  @override
  String get aiScanFailed =>
      'Error al escanear. Por favor, inténtalo de nuevo.';

  @override
  String get aiScanParseError =>
      'No se pudo leer el análisis. Prueba con otra foto o ingresa manualmente.';

  @override
  String get aiScanConfigError =>
      'El escáner con IA no está disponible en este momento. Inténtalo de nuevo más tarde.';

  @override
  String get aiDailyLimitReached =>
      'Has alcanzado el límite diario de IA. Pasa a Premium para una cuota diaria superior.';

  @override
  String get aiUpgradeCta => 'Mejorar plan';

  @override
  String get aiScanTryAgain => 'Intentar de nuevo';

  @override
  String get aiScanManualEntry => 'Ingreso manual';

  @override
  String get aiScanCardTitle => 'Escanea tu comida con IA';

  @override
  String get aiScanCardSubtitle =>
      'Toma una foto — obtén calorías, macros y alternativas inteligentes al instante.';

  @override
  String get aiScanSaveToLog => 'Guardar en el registro';

  @override
  String get aiScanSavedSnack => 'Comida guardada en el registro de hoy';

  @override
  String get aiScanMacroProtein => 'Proteína';

  @override
  String get aiScanMacroCarbs => 'Carbos';

  @override
  String get aiScanMacroFats => 'Grasas';

  @override
  String get aiScanSmartSwaps => 'Cambios inteligentes';

  @override
  String aiScanCaloriesChip(int calories) {
    return '$calories kcal';
  }

  @override
  String get aiCoachTitle => 'Vireo AI';

  @override
  String get aiCoachFabLabel => 'Vireo AI';

  @override
  String get aiCoachInputHint =>
      'Pregunta sobre comidas, macros o entrenamiento…';

  @override
  String get aiCoachOfflineBanner =>
      'Estás sin conexión — mostrando mensajes en caché.';

  @override
  String get aiCoachChipDinner => 'Sugiéreme una cena';

  @override
  String get aiCoachChipProtein => '¿Cómo aumento mi proteína?';

  @override
  String get aiCoachChipDessert => 'Alternativa saludable de postre';

  @override
  String waterAddOneGlass(int ml) {
    return '+1 vaso ($ml ml)';
  }

  @override
  String get waterLongPressHint => 'Mantén presionado para ver más opciones';

  @override
  String get waterQuickAmountsTitle => 'Cantidades rápidas';

  @override
  String get waterDefaultCupTitle => 'Tamaño de vaso predeterminado';

  @override
  String get waterCustomMl => 'Cantidad personalizada';

  @override
  String get waterAddCustom => 'Agregar';

  @override
  String get waterTrackerTitle => 'Consumo de agua';

  @override
  String waterTrackerSummary(double current, double goal, int percent) {
    return '${current}L / ${goal}L — $percent% completado';
  }

  @override
  String get weeklyDeficitChartTitle => 'Balance calórico semanal';

  @override
  String get weeklyDeficitSubtitle =>
      'GETD − comidas + quema de cardio (últimos 7 días)';

  @override
  String weeklyDeficitTotal(int kcal) {
    return 'Balance neto semanal: $kcal kcal';
  }

  @override
  String get weeklyDeficitEmpty =>
      'Registra comidas o cardio para ver tu balance calórico semanal.';

  @override
  String get weeklyDeficitInProgress => 'Hoy (en progreso)';

  @override
  String get progressTrendEmpty => 'Registra 3 días para ver tu tendencia';

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
  String get cookMethodRaw => 'Crudo';

  @override
  String get cookMethodBoiled => 'Hervido';

  @override
  String get cookMethodGrilled => 'A la parrilla';

  @override
  String get cookMethodFried => 'Frito';

  @override
  String get cookMethodBaked => 'Horneado';

  @override
  String get cookMethodSteamed => 'Al vapor';

  @override
  String get cookMethodOther => 'Otro';

  @override
  String weeklyDeficitTooltip(int net, int consumed, int burned) {
    return '$net kcal\nConsumidas: $consumed · Quemadas: $burned';
  }

  @override
  String uxGoodMorning(String name) {
    return 'Buenos días, $name';
  }

  @override
  String uxGoodAfternoon(String name) {
    return 'Buenas tardes, $name';
  }

  @override
  String uxGoodEvening(String name) {
    return 'Buenas noches, $name';
  }

  @override
  String get uxTodayOverline => 'HOY';

  @override
  String get uxCaloriesLeft => 'kcal restantes';

  @override
  String get uxCaloriesOver => 'kcal en exceso';

  @override
  String get uxGoal => 'Meta';

  @override
  String get uxEaten => 'Consumidas';

  @override
  String get uxBurned => 'Quemadas';

  @override
  String get uxActionScan => 'Escanear comida';

  @override
  String get uxActionTrain => 'Entrenar';

  @override
  String get uxActionCoach => 'Coach IA';

  @override
  String get uxSectionTraining => 'Entrenamiento de hoy';

  @override
  String get uxSectionThisWeek => 'Esta semana';

  @override
  String get uxSectionTodayLog => 'Registro de hoy';

  @override
  String get uxAddMeal => '+ Agregar comida';

  @override
  String get uxAiScanned => 'Escaneo IA';

  @override
  String get uxMealRemoved => 'Comida eliminada';

  @override
  String get uxLogEmptyTitle => 'Nada registrado aún';

  @override
  String get uxLogEmptyBody =>
      'Toma una foto de tu comida — la IA cuenta las calorías y macros en segundos.';

  @override
  String get uxRestDayHint =>
      'La recuperación también es entrenamiento. Camina, estira y alcanza tu meta de proteína.';

  @override
  String uxWorkoutMinutes(int minutes) {
    return '~$minutes min';
  }

  @override
  String get uxWater => 'Agua';

  @override
  String get uxGlassSize => '250 ml';

  @override
  String uxWaterAdded(String liters) {
    return '+250 ml · $liters L hoy';
  }

  @override
  String get uxWaterGoalDone => 'Meta de agua alcanzada 💧 ¡excelente trabajo!';

  @override
  String get uxUndo => 'Deshacer';

  @override
  String get uxCopied => 'Copiado';

  @override
  String get uxSend => 'Enviar';

  @override
  String get uxQuickLogTitle => 'Registro rápido';

  @override
  String get uxQuickLogSubtitle => 'Registra cualquier cosa con un solo toque.';

  @override
  String get uxQuickScanTitle => 'Escanear comida con IA';

  @override
  String get uxQuickScanSub => 'Calorías y macros en segundos';

  @override
  String get uxQuickWater => 'Agua';

  @override
  String get uxQuickWaterSub => '+1 vaso · 250 ml';

  @override
  String get uxQuickWeight => 'Peso';

  @override
  String get uxQuickWeightSub => 'Registrar pesaje de hoy';

  @override
  String get uxQuickCardio => 'Cardio';

  @override
  String get uxQuickCardioSub => 'Caminar, correr, bici…';

  @override
  String get uxQuickCoach => 'Consultar al coach';

  @override
  String get uxQuickCoachSub => 'Consejos personalizados de IA';

  @override
  String get uxCoachOnline => 'En línea · conoce tus macros';

  @override
  String get uxCoachTyping => 'Escribiendo…';

  @override
  String get uxCoachNewChat => 'Nuevo chat';

  @override
  String get uxCoachClearConfirm =>
      '¿Iniciar una nueva conversación? Se borrarán los mensajes actuales.';

  @override
  String get uxCoachHeroTitle => 'Tu coach personal con IA';

  @override
  String get uxCoachHeroBody =>
      'Pregunta sobre comidas, proteína, antojos o entrenamientos. Cada respuesta se basa en tus números de hoy.';

  @override
  String uxCoachKcalLeft(int kcal) {
    return '$kcal kcal restantes';
  }

  @override
  String uxCoachProteinLeft(int grams) {
    return '${grams}g de proteína restantes';
  }

  @override
  String get uxCoachChipWorkout => '¿Qué debería comer antes de entrenar?';

  @override
  String get uxProtein => 'Proteína';

  @override
  String get uxCarbs => 'Carbos';

  @override
  String get uxFat => 'Grasa';

  @override
  String get aiScanAnalysisTitle => 'Análisis de IA';

  @override
  String get diaryAddMeal => 'Agregar comida';

  @override
  String get diaryAddWorkout => 'Agregar entrenamiento';

  @override
  String get diaryCaloriesIn => 'Calorías ingeridas';

  @override
  String get diaryCaloriesOut => 'Calorías quemadas';

  @override
  String diaryKcal(int kcal) {
    return '$kcal kcal';
  }

  @override
  String diaryLastUpdated(String count) {
    return 'Última actualización $count';
  }

  @override
  String diaryMealCalories(int calories) {
    return '$calories kcal';
  }

  @override
  String get diaryNetBalance => 'Balance neto';

  @override
  String get diaryNoEntries => 'No hay entradas para este día';

  @override
  String get diaryProtein => 'Proteína';

  @override
  String diaryProteinProgress(int current, int goal) {
    return '$current / $goal g';
  }

  @override
  String get diarySetGoalsCta => 'Establecer metas';

  @override
  String get diarySetGoalsFirst => 'Establece tus objetivos primero';

  @override
  String get diaryTimeline => 'Cronología';

  @override
  String get diaryTitle => 'Mi diario';

  @override
  String get diaryToday => 'Hoy';

  @override
  String get diaryWater => 'Agua';

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
  String get exerciseAdvanced => 'Avanzado';

  @override
  String get exerciseBeginner => 'Principiante';

  @override
  String get exerciseComplete => 'Completar serie';

  @override
  String get exerciseDifficulty => 'Dificultad';

  @override
  String get exerciseEquipment => 'Equipamiento';

  @override
  String get exerciseIntermediate => 'Intermedio';

  @override
  String get exerciseLoadingDemo => 'Cargando demostración del ejercicio...';

  @override
  String get exerciseMistakes => 'Errores comunes';

  @override
  String get exerciseReps => 'Reps';

  @override
  String get exerciseRest => 'Descanso';

  @override
  String get exerciseSets => 'Series';

  @override
  String get exerciseSteps => 'Pasos';

  @override
  String get exerciseTips => 'Consejos pro';

  @override
  String get exerciseViewBack => 'Espalda';

  @override
  String get exerciseViewFront => 'Frente';

  @override
  String get measurements30Days => '30 días';

  @override
  String get measurements3Months => '3 meses';

  @override
  String get measurements7Days => '7 días';

  @override
  String get measurementsAdd => 'Agregar medida';

  @override
  String get measurementsAddFirst => 'Registra tu primera medida';

  @override
  String get measurementsAll => 'Todo';

  @override
  String get measurementsArms => 'Brazos';

  @override
  String get measurementsBodyFat => '% de grasa corporal';

  @override
  String get measurementsChest => 'Pecho';

  @override
  String get measurementsDate => 'Fecha';

  @override
  String get measurementsDelete => 'Eliminar';

  @override
  String get measurementsDeleteConfirm => '¿Eliminar esta medida?';

  @override
  String get measurementsHistory => 'Historial';

  @override
  String measurementsLastUpdated(String date) {
    return 'Actualizado el $date';
  }

  @override
  String get measurementsNeedMoreData =>
      'Registra más entradas para ver tendencias';

  @override
  String get measurementsNoData => 'Sin medidas aún';

  @override
  String get measurementsNotes => 'Notas';

  @override
  String get measurementsSave => 'Guardar';

  @override
  String get measurementsThighs => 'Muslos';

  @override
  String get measurementsTitle => 'Medidas';

  @override
  String get measurementsTrendDeclining => 'Requiere atención';

  @override
  String get measurementsTrendImproving => 'Mejorando';

  @override
  String get measurementsTrendStable => 'Estable';

  @override
  String get measurementsWaist => 'Cintura';

  @override
  String get measurementsWeight => 'Peso';

  @override
  String get measurementsWeightInvalid => 'Introduce un peso válido';

  @override
  String get muscleBack => 'Espalda';

  @override
  String get muscleBiceps => 'Bíceps';

  @override
  String get muscleCalves => 'Pantorrillas';

  @override
  String get muscleChest => 'Pecho';

  @override
  String get muscleCore => 'Core';

  @override
  String get muscleForearms => 'Antebrazos';

  @override
  String get muscleGlutes => 'Glúteos';

  @override
  String get muscleHamstrings => 'Isquiotibiales';

  @override
  String get muscleHipFlexors => 'Flexores de cadera';

  @override
  String get muscleQuads => 'Cuádriceps';

  @override
  String get muscleShoulders => 'Hombros';

  @override
  String get muscleTriceps => 'Tríceps';

  @override
  String get notificationsBreakfast => 'Recordatorio de desayuno';

  @override
  String get notificationsDinner => 'Recordatorio de cena';

  @override
  String get notificationsLunch => 'Recordatorio de almuerzo';

  @override
  String get notificationsOpenSettings => 'Abrir ajustes';

  @override
  String get notificationsPermissionBanner =>
      'Activa las notificaciones para mantener la constancia';

  @override
  String get notificationsPreWorkout => 'Recordatorio pre-entrenamiento';

  @override
  String get notificationsPreWorkoutSubtitle => 'Prepárate para entrenar';

  @override
  String get notificationsSleep => 'Recordatorio de sueño';

  @override
  String get notificationsSleepSubtitle =>
      'Desconéctate para una mejor recuperación';

  @override
  String get notificationsTest => 'Enviar notificación de prueba';

  @override
  String get notificationsTestBody =>
      'Los recordatorios de Vireo funcionan correctamente';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get notificationsWater => 'Recordatorio de agua';

  @override
  String get notificationsWaterSubtitle =>
      'Mantente hidratado a lo largo del día';

  @override
  String get notificationsWeeklyReport => 'Informe semanal';

  @override
  String get notificationsWeeklyReportSubtitle => 'Revisa cómo fue tu semana';

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
  String get vitality12WeekProgram => 'Programa de 12 semanas';

  @override
  String vitalityArticleCount(int count) {
    return '$count artículos';
  }

  @override
  String get vitalityArticleDisclaimer =>
      'Solo con fines educativos. Consulta a un profesional para asesoramiento individual.';

  @override
  String get vitalityArticlesSection => 'Artículos';

  @override
  String get vitalityBadgesTitle => 'Insignias';

  @override
  String vitalityBreathingCount(int count) {
    return '$count sesiones';
  }

  @override
  String get vitalityBreathingLog => 'Respiración';

  @override
  String get vitalityCategoryAdvanced => 'Avanzado';

  @override
  String get vitalityCategoryEnvironmental => 'Entorno';

  @override
  String get vitalityCategoryLifestyle => 'Estilo de vida';

  @override
  String get vitalityCategoryNutrition => 'Nutrición';

  @override
  String get vitalityCategoryTraining => 'Entrenamiento';

  @override
  String get vitalityCheckProtein => 'Cumplir con la proteína';

  @override
  String get vitalityCheckSleep => 'Sueño de calidad';

  @override
  String get vitalityCheckSunlight => 'Luz solar matutina';

  @override
  String get vitalityCheckWorkout => 'Moverse / entrenar';

  @override
  String get vitalityCheckZincVitD => 'Zinc / Vitamina D';

  @override
  String vitalityDailyChecklistProgress(int done, int total) {
    return '$done/$total completados';
  }

  @override
  String get vitalityDailyChecklistTitle => 'Lista de verificación de hoy';

  @override
  String get vitalityDailyTipLabel => 'Consejo diario';

  @override
  String get vitalityHubSubtitle =>
      'Hábitos respaldados por la ciencia para energía y recuperación';

  @override
  String get vitalityHubTitle => 'Centro de Vitalidad';

  @override
  String get vitalityLegendBadge => 'Leyenda';

  @override
  String get vitalityLinkCopied => 'Enlace copiado';

  @override
  String get vitalityLogSection => 'Registro';

  @override
  String get vitalityMarkRead => 'Marcar como leído';

  @override
  String get vitalityMarkReadDone => 'Leído';

  @override
  String get vitalityMarkReadSuccess => 'Marcado como leído';

  @override
  String get vitalityMedicalDisclaimer =>
      'Contenido educativo únicamente — no constituye asesoramiento médico.';

  @override
  String get vitalityMetricsEmpty => 'Sin métricas aún';

  @override
  String get vitalityMetricsLast7Days => 'Últimos 7 días';

  @override
  String vitalityMetricsLastEntry(int score) {
    return 'Último registro · energía $score/10';
  }

  @override
  String get vitalityMetricsSave => 'Guardar métricas';

  @override
  String get vitalityMetricsSaved => 'Guardado';

  @override
  String get vitalityMetricsTapToLog => 'Toca para registrar';

  @override
  String get vitalityMetricsTitle => 'Métricas diarias';

  @override
  String get vitalityMorningEnergy => 'Energía matutina';

  @override
  String get vitalityMyProgram => 'Mi programa';

  @override
  String get vitalityNotLogged => 'No registrado';

  @override
  String get vitalityPhaseFoundation => 'Fundamentos';

  @override
  String get vitalityPhaseOptimization => 'Optimización';

  @override
  String get vitalityPhasePeak => 'Cúspide';

  @override
  String get vitalityProgramAllWeeks => 'Todas las semanas';

  @override
  String get vitalityProgramComplete => 'Programa completado';

  @override
  String get vitalityProgramContinue => 'Continuar';

  @override
  String get vitalityProgramDisclaimer =>
      'Programa educativo — no es un tratamiento médico.';

  @override
  String get vitalityProgramDone => 'Completado';

  @override
  String get vitalityProgramOverallProgress => 'Progreso general';

  @override
  String get vitalityProgramStartCta => 'Comenzar programa';

  @override
  String get vitalityProgramSubtitle =>
      '12 semanas para mejorar tu energía, sueño y recuperación';

  @override
  String get vitalityProgramTitle => 'Transformación de Vitalidad';

  @override
  String get vitalityProtocolBadgeEarned => '¡Insignia desbloqueada!';

  @override
  String get vitalityProtocolCompleteDay => 'Completar día';

  @override
  String vitalityProtocolStreak(int days) {
    return 'Racha de $days días';
  }

  @override
  String get vitalityProtocolTitle => 'Protocolos';

  @override
  String vitalityReadingTime(int minutes) {
    return '$minutes min de lectura';
  }

  @override
  String get vitalityReportCompletion => 'Finalización';

  @override
  String get vitalityReportImproving => 'Estás mejorando — mantén la racha.';

  @override
  String get vitalityReportKeepGoing =>
      'Los pequeños pasos cuentan. Completa un par de tareas hoy.';

  @override
  String get vitalityScientificSources => 'Fuentes';

  @override
  String vitalityScoreBreakdown(
    int sleep,
    int workout,
    int protein,
    int stress,
  ) {
    return 'Sueño $sleep · Entreno $workout · Proteína $protein · Estrés $stress';
  }

  @override
  String get vitalityScoreLabel => 'Vitalidad';

  @override
  String get vitalitySleepHint => '¿Cómo dormiste?';

  @override
  String vitalitySleepHours(num hours) {
    return '$hours h';
  }

  @override
  String get vitalitySleepLog => 'Sueño';

  @override
  String get vitalitySleepQuality => 'Calidad';

  @override
  String vitalityStreak(int days) {
    return 'Racha de $days días';
  }

  @override
  String get vitalityStressLevel => 'Estrés';

  @override
  String get vitalityUnlockNextWeek => 'Desbloquear la próxima semana';

  @override
  String vitalityWeekProgress(int percent) {
    return '$percent%';
  }

  @override
  String get vitalityWeekReport => 'Informe semanal';

  @override
  String vitalityWeekX(int week) {
    return 'Semana $week';
  }

  @override
  String vitalityWeekXOf12(int week) {
    return 'Semana $week de 12';
  }

  @override
  String get vitalityWorkoutDone => 'Entrenado';

  @override
  String get vitalityWorkoutLog => 'Entrenamiento';

  @override
  String get vitalityWorkoutPending => 'Descanso / pendiente';

  @override
  String get vitalityWorkoutPerformance => 'Rendimiento';

  @override
  String walkingEstimatedMinutes(int minutes) {
    return '~$minutes min';
  }

  @override
  String get walkingHealthBanner =>
      'Pasos en vivo desde el podómetro de este teléfono';

  @override
  String get walkingManualStepsLabel => 'Pasos hoy';

  @override
  String get walkingUpdateSteps => 'Actualizar pasos';

  @override
  String get walkingWebManualBanner =>
      'En la web, ingresa los pasos manualmente';

  @override
  String get vitalityKeyTakeaway => 'Punto clave';

  @override
  String get dietMyPlan => 'Mi plan de alimentación';

  @override
  String get dietProgramsTitle => 'Programas de alimentación';

  @override
  String get dietQuizTitle => 'Cuestionario de plan de dieta';

  @override
  String get dietQuizContinue => 'Entiendo — continuar';

  @override
  String get dietQuizYes => 'Sí';

  @override
  String get dietQuizNo => 'No';

  @override
  String dietQuizHealthStep(int current, int total) {
    return 'Salud $current de $total';
  }

  @override
  String dietQuizPrefStep(int current, int total) {
    return 'Preferencias $current de $total';
  }

  @override
  String get dietPrefBreadRice => '¿Te encantan el pan y el arroz?';

  @override
  String get dietPrefSkipBreakfast =>
      '¿Puedes saltarte el desayuno cómodamente?';

  @override
  String get dietPrefSimpleRules => '¿Prefieres reglas de comida simples?';

  @override
  String get dietPrefEatsOut => '¿Comes fuera con frecuencia?';

  @override
  String get dietPrefWeights => '¿Entrenas con pesas con regularidad?';

  @override
  String get dietRecommendedBadge => 'Recomendado para ti';

  @override
  String get dietActiveBadge => 'Activo';

  @override
  String get dietNeedsDoctor => 'Requiere aprobación médica';

  @override
  String get dietReadWarning => 'Leer advertencia';

  @override
  String dietCardMacros(int kcal, int protein) {
    return '$kcal kcal · ${protein}g proteína';
  }

  @override
  String get dietHowItWorks => 'Cómo funciona';

  @override
  String get dietYourTargets => 'Tus objetivos';

  @override
  String get dietBestFor => 'Ideal para';

  @override
  String get dietNotIdealFor => 'No recomendado para';

  @override
  String get dietRules => 'Reglas';

  @override
  String get dietAllowedFoods => 'Alimentos permitidos';

  @override
  String get dietLimitFoods => 'Limitar estos';

  @override
  String get dietSampleDay => 'Día de ejemplo';

  @override
  String get dietSideEffects => 'Efectos secundarios';

  @override
  String get dietTips => 'Consejos';

  @override
  String get dietEvidence => 'Evidencia científica';

  @override
  String get dietStopSigns => 'Señales de alerta';

  @override
  String get dietDisclaimer => 'Aviso legal';

  @override
  String get dietStartProgram => 'Comenzar este programa';

  @override
  String get dietDoctorGateTitle => 'Se requiere aprobación médica';

  @override
  String get dietAckWarning => 'He leído la advertencia';

  @override
  String get dietMustAckWarning =>
      'Confirma primero que has leído la advertencia';

  @override
  String get dietStartedToast => 'Programa de alimentación iniciado';

  @override
  String get dietClose => 'Cerrar';

  @override
  String dietCarbsMax(int grams) {
    return 'Límite de carbos: $grams g';
  }

  @override
  String dietWeeklyLoss(String kg) {
    return 'Pérdida semanal est. ≈ $kg kg';
  }

  @override
  String get dietChoosePlanCard => 'Elige tu plan de alimentación';

  @override
  String dietFastingLeft(String time) {
    return 'Ayuno — queda $time';
  }

  @override
  String dietEatingWindowLeft(String time) {
    return 'Ventana de comida — termina en $time';
  }

  @override
  String dietWindowStartsAt(int hour) {
    return 'La ventana de comida empieza a las $hour:00';
  }

  @override
  String get dietEditWindow => 'Editar hora de inicio';

  @override
  String get dietCarbsLimitLabel => 'Límite de carbohidratos';

  @override
  String dietCarbsLimitProgress(int current, int max) {
    return '$current / $max g carbos';
  }

  @override
  String get todayPlanTitle => 'PLAN DE HOY';

  @override
  String todayPlanProgressSummary(int percent, int done, int total) {
    return 'Has completado el $percent% de tu día · $done/$total actividades';
  }

  @override
  String get todayPlanNow => 'Ahora';

  @override
  String get todayPlanPro => 'PRO';

  @override
  String todayPlanWaterReminder(int index, int total) {
    return 'Recordatorio de agua $index de $total';
  }

  @override
  String todayPlanWaterGoalLine(int ml) {
    return 'Meta diaria $ml ml';
  }

  @override
  String get todayPlanFastingOpen => 'Inicia la ventana de comida';

  @override
  String todayPlanFastingOpenSubtitle(int hours) {
    return 'Comienza la ventana de comida de ${hours}h';
  }

  @override
  String get todayPlanFastingClose => 'Cierra la ventana de comida';

  @override
  String todayPlanFastingCloseSubtitle(int hours) {
    return 'Comienza el ayuno de ${hours}h';
  }

  @override
  String get todayPlanWorkout => 'Entrenamiento de hoy';

  @override
  String get todayPlanSteps => 'Meta de pasos';

  @override
  String todayPlanStepsProgress(int current, int goal) {
    return '$current / $goal pasos';
  }

  @override
  String get todayPlanVitalitySleepSubtitle =>
      'Registra 7.5+ horas en Vitalidad';

  @override
  String get todayPlanVitalityProteinSubtitle =>
      'Alcanza tu objetivo de proteína';

  @override
  String get todayPlanVitalitySunSubtitle =>
      'Exposición a la luz solar matutina';

  @override
  String get todayPlanVitalityStress => 'Reinicio de estrés';

  @override
  String get todayPlanVitalityStressSubtitle =>
      'Registra una sesión de respiración';

  @override
  String get todayPlanVitalityZincSubtitle =>
      'Zinc y vitamina D a través de alimentos';

  @override
  String get todayPlanSleepTarget => 'Objetivo de sueño';

  @override
  String get todayPlanSleepTargetSubtitle =>
      'Desconéctate para un sueño de calidad';

  @override
  String get todayPlanProtocolItem => 'Protocolo de Vitalidad';

  @override
  String get todayPlanAiSuggestion => 'Sugerencia del coach IA';

  @override
  String get todayPlanAiSuggestionSubtitle => 'Consejo personalizado para hoy';

  @override
  String waterGoalBasedOnWeight(int kg) {
    return 'Basado en tu peso ($kg kg)';
  }

  @override
  String get authErrorEmailRateLimit =>
      'Demasiados correos, inténtalo de nuevo en una hora';

  @override
  String get profileMyBody => 'Mi cuerpo';

  @override
  String get profileGuestProgressHint => 'Invitado — el progreso no se guarda';

  @override
  String get profilePlanPro => 'Pro';

  @override
  String get profilePlanFree => 'Gratis';

  @override
  String profileMemberSince(String date) {
    return 'Miembro desde $date';
  }

  @override
  String get profileSaveProgressCta => 'Guarda tu progreso';

  @override
  String get profileMyPlanSection => 'Mi plan';

  @override
  String get profileChangeDietPlan => 'Cambiar plan';

  @override
  String get profileBodyMetricsSaved => 'Métricas corporales actualizadas';

  @override
  String get profileSaveBodyMetrics => 'Guardar';

  @override
  String get profileEditDisplayName => 'Nombre visible';

  @override
  String get profileDisplayNameHint => 'Tu nombre';

  @override
  String get profileFitnessGoal => 'Objetivo';

  @override
  String get activityHubTitle => 'Actividad y Salud';

  @override
  String get activityHubSubtitle =>
      'Entrenamientos con GPS, métricas de reloj inteligente y respiración guiada — en tu teléfono y potenciado por tu reloj.';

  @override
  String get activityHealthHomeCardTitle => 'Actividad y Salud';

  @override
  String get activityHealthHomeCardSubtitle =>
      'Conecta tu reloj o inicia un entrenamiento al aire libre';

  @override
  String get outdoorWorkoutTitle => 'Entrenamiento al aire libre';

  @override
  String get outdoorWorkoutSubtitle =>
      'Camina, corre o pedalea con mapas GPS e indicaciones por voz';

  @override
  String get outdoorPickTitle => 'Elige actividad';

  @override
  String get outdoorPickSubtitle =>
      'El seguimiento por GPS solo funciona durante tu sesión.';

  @override
  String get outdoorTypeWalk => 'Caminar';

  @override
  String get outdoorTypeRun => 'Correr';

  @override
  String get outdoorTypeCycle => 'Ciclismo';

  @override
  String get outdoorGo => '¡Iniciar!';

  @override
  String get outdoorLocationDenied =>
      'Se requiere permiso de ubicación para entrenamientos con GPS.';

  @override
  String get outdoorDistance => 'Distancia';

  @override
  String get outdoorDuration => 'Duración';

  @override
  String get outdoorPace => 'Ritmo';

  @override
  String get outdoorSpeed => 'Velocidad';

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
    return '$kcal kcal quemadas';
  }

  @override
  String get outdoorPause => 'Pausa';

  @override
  String get outdoorResume => 'Reanudar';

  @override
  String get outdoorHoldToStop => 'Mantén presionado para detener';

  @override
  String get outdoorStopTitle => '¿Finalizar entrenamiento?';

  @override
  String get outdoorStopBody => 'Tu ruta y estadísticas se guardarán.';

  @override
  String get outdoorStopConfirm => 'Finalizar';

  @override
  String get outdoorPaused => 'En pausa';

  @override
  String get outdoorAutoPause => 'Pausa automática al detenerte';

  @override
  String get outdoorHistoryTitle => 'Historial de entrenamientos';

  @override
  String get outdoorHistorySubtitle => 'Sesiones previas de GPS';

  @override
  String get outdoorHistoryEmpty => 'Aún no hay entrenamientos al aire libre.';

  @override
  String get outdoorDetailTitle => 'Detalle del entrenamiento';

  @override
  String get outdoorSplitsTitle => 'Parciales por kilómetro';

  @override
  String outdoorSplitKm(int km) {
    return 'Km $km';
  }

  @override
  String get uxQuickOutdoor => 'Entrenamiento al aire libre';

  @override
  String get uxQuickOutdoorSub => 'Caminata, carrera o bici con GPS';

  @override
  String get healthHubTitle => 'Salud';

  @override
  String get healthHubCardSubtitle =>
      'Frecuencia cardíaca, sueño y SpO₂ desde tu reloj';

  @override
  String get healthHubProgressSubtitle =>
      'Métricas de reloj y puntuación de sueño';

  @override
  String get healthNotMedical =>
      'No apto para uso médico. Las métricas provienen de tu reloj a través de Health Connect / Apple Health.';

  @override
  String get healthFromWatch => 'Desde tu reloj';

  @override
  String get healthConnectWatchTitle => 'Conecta tu reloj';

  @override
  String get healthConnectWatchBody =>
      'Otorga acceso a Health Connect o Apple Health para que Vireo pueda mostrar tu frecuencia cardíaca, sueño, pasos y más. Nunca estimamos signos vitales desde el teléfono.';

  @override
  String get healthGrantPermission => 'Permitir acceso a salud';

  @override
  String get healthMetricHeartRate => 'Frecuencia cardíaca';

  @override
  String get healthMetricRestingHr => 'Frecuencia cardíaca en reposo';

  @override
  String get healthMetricHrv => 'VFC (RMSSD)';

  @override
  String get healthMetricSpO2 => 'Oxígeno en sangre';

  @override
  String get healthMetricSleep => 'Sueño';

  @override
  String get healthMetricWeight => 'Peso';

  @override
  String get healthMetricWorkout => 'Entrenamientos';

  @override
  String get healthMetricSteps => 'Pasos';

  @override
  String get healthManualSleepTitle => 'Registro manual de sueño';

  @override
  String get healthManualSleepHint =>
      'Sin datos de reloj inteligente — toca para registrar horas de sueño y calidad';

  @override
  String healthSleepScore(int score) {
    return 'Puntuación de sueño $score';
  }

  @override
  String get healthBedtime => 'Hora de acostarse';

  @override
  String get healthWakeTime => 'Hora de levantarse';

  @override
  String get healthSleepQuality => 'Calidad (1–5)';

  @override
  String get healthStressTitle => 'Nivel de estrés (VFC)';

  @override
  String get healthStressLow => 'Bajo';

  @override
  String get healthStressMedium => 'Medio';

  @override
  String get healthStressHigh => 'Alto';

  @override
  String healthHrvDetail(int today, int baseline) {
    return 'Hoy $today ms vs línea base de 14 días $baseline ms';
  }

  @override
  String get breathingHubTitle => 'Respiración';

  @override
  String get breathingHubSubtitle =>
      'Sesiones guiadas para recuperación del estrés';

  @override
  String get breathingBoxTitle => 'Respiración cuadrada 4-4-4-4';

  @override
  String get breathingBoxSubtitle =>
      'Inhalación, retención, exhalación y pausa iguales';

  @override
  String get breathing478Title => 'Relajación 4-7-8';

  @override
  String get breathing478Subtitle => 'Patrón calmante antes de dormir';

  @override
  String breathingMinutes(int min) {
    return '$min min';
  }

  @override
  String get breathingSessionTitle => 'Sesión de respiración';

  @override
  String get breathingInhale => 'Inhala';

  @override
  String get breathingHold => 'Mantén';

  @override
  String get breathingExhale => 'Exhala';

  @override
  String get breathingRest => 'Descansa';

  @override
  String get mealReviewTitle => 'Revisar comida';

  @override
  String get mealReviewAddItem => 'Agregar alimento';

  @override
  String get mealReviewSlot => 'Comida';

  @override
  String mealReviewRemaining(int kcal) {
    return 'Presupuesto restante: $kcal kcal';
  }

  @override
  String get mealReviewEstimated => 'estimado';

  @override
  String mealReviewKcalApprox(int count) {
    return '≈ $count kcal';
  }

  @override
  String get mealReviewPortionLabel => 'Porción';

  @override
  String get mealReviewOilPrefix => 'Aceite:';

  @override
  String get mealReviewOilLight => 'poco';

  @override
  String get mealReviewOilNormal => 'normal';

  @override
  String get mealReviewOilHeavy => 'abundante';

  @override
  String get mealReviewFamilyPlateToggle => 'Compartimos un plato';

  @override
  String get mealReviewMyShare => 'Mi parte';

  @override
  String get ramadanWaterTrackerQuestion =>
      '¿Cuántos vasos desde el iftar hasta el suhur?';

  @override
  String ramadanWaterGoalSplit(int iftarCups, int eveningCups, int suhoorCups) {
    return 'Iftar: $iftarCups · Noche: $eveningCups · Suhur: $suhoorCups vasos';
  }

  @override
  String get ramadanPrayerCityPickerTitle => 'Elige ciudad de oración';

  @override
  String get ramadanPrayerCityCustom => 'Otra ciudad';

  @override
  String get ramadanCustomCityName => 'Nombre de la ciudad';

  @override
  String get ramadanCustomCityLat => 'Latitud';

  @override
  String get ramadanCustomCityLng => 'Longitud';

  @override
  String get notificationPostScanTitle => '¿Quieres recordatorios de comidas?';

  @override
  String get notificationPostScanBody =>
      'Avisos suaves para almuerzo y cena — máx. 2/día, silencio 23:00–07:00.';

  @override
  String get notificationPostScanYes => 'Sí, recuérdame';

  @override
  String get notificationPostScanNotNow => 'Ahora no';

  @override
  String get mealReviewCheckAmount => 'comprueba la cantidad';

  @override
  String get mealReviewSearchFood => 'Buscar alimentos…';

  @override
  String get mealReviewLogByText => 'Registrar por texto en su lugar';

  @override
  String get mealLogTextTitle => 'Registrar comida por texto';

  @override
  String get mealLogTextHint => 'Describe lo que comiste: en español o inglés.';

  @override
  String get mealLogTextPlaceholder =>
      'Comí 2 huevos, pan tostado y café con leche';

  @override
  String get mealLogTextAnalyze => 'Analizar';

  @override
  String get mealVoiceStart => 'Voz';

  @override
  String get mealVoiceListening => 'Escuchando…';

  @override
  String get mealVoiceUnavailable =>
      'Entrada de voz no disponible en este dispositivo';

  @override
  String get mealBarcodeTitle => 'Escanear código de barras';

  @override
  String get mealBarcodeFailed =>
      'No se pudo encontrar ese código de barras. Inténtalo de nuevo o regístralo por texto.';

  @override
  String get mealScanHintLabel => 'Agrega unas palabras (opcional)';

  @override
  String get mealScanHintPlaceholder => '¿Aceite? ¿Salsa? ¿Tipo de pan?';

  @override
  String get mealHowCalculated => 'Cómo calculamos esto';

  @override
  String get plateSizeAskTitle => '¿Cuál es tu tamaño habitual de plato?';

  @override
  String get plateSizeSmall => 'Pequeño';

  @override
  String get plateSizeMedium => 'Mediano';

  @override
  String get plateSizeLarge => 'Grande';

  @override
  String get inbodyScanTitle => 'Escanear informe InBody';

  @override
  String get inbodyReviewTitle => 'Revisar resultado InBody';

  @override
  String get inbodyBodyTitle => 'Composición corporal';

  @override
  String get inbodyAddResult => 'Agregar resultado InBody';

  @override
  String get inbodyPickPdf => 'Elegir PDF';

  @override
  String get inbodyFrameHint =>
      'Ajusta la hoja completa del informe dentro del marco';

  @override
  String get inbodyAnalyzing => 'Leyendo tu informe…';

  @override
  String get inbodyUnreadable =>
      'No se pudo leer la hoja. Prueba con una foto más clara.';

  @override
  String get inbodyScanFailed =>
      'Error al escanear InBody. Inténtalo de nuevo.';

  @override
  String get inbodySaved => 'Resultado de InBody guardado';

  @override
  String get inbodyMedicalNote =>
      'No apto para uso médico — solo para seguimiento físico.';

  @override
  String get inbodyTestDate => 'Fecha de la prueba';

  @override
  String get inbodyDevice => 'Dispositivo';

  @override
  String get inbodyWeight => 'Peso (kg)';

  @override
  String get inbodySmm => 'Masa muscular esquelética (kg)';

  @override
  String get inbodyFatMass => 'Masa grasa (kg)';

  @override
  String get inbodyPbf => '% de grasa corporal';

  @override
  String get inbodyBmi => 'IMC';

  @override
  String get inbodyVisceral => 'Nivel de grasa visceral';

  @override
  String get inbodyBmr => 'TMB (kcal)';

  @override
  String get inbodyScore => 'Puntuación InBody';

  @override
  String get inbodySave => 'Guardar resultado';

  @override
  String get inbodyEmpty =>
      'No hay informes de composición corporal aún. Escanea una hoja de InBody para comenzar.';

  @override
  String get inbodyLatestTitle => 'Último informe';

  @override
  String get inbodyCompareTitle => 'Comparar dos informes';

  @override
  String get inbodySyncHealth => 'Sincronizar Health Connect';

  @override
  String get inbodySyncedLabel => 'Sincronizado desde Health Connect';

  @override
  String inbodySyncResult(int count) {
    return 'Se importaron $count lectura(s) de Health Connect';
  }

  @override
  String inbodyFromDateLabel(String date) {
    return 'de tu InBody el $date';
  }

  @override
  String get uxQuickInbody => 'Informe InBody';

  @override
  String get uxQuickInbodySub => 'Escanear hoja de resultados';

  @override
  String get mealScanHeroTitle => 'Escanea tu comida';

  @override
  String get mealScanHeroSubtitle =>
      'La IA identifica los alimentos — tú confirmas los gramos';

  @override
  String get mealScanTipAbove => 'Toma la foto desde arriba';

  @override
  String get mealScanTipWholePlate => 'Plato completo visible';

  @override
  String get mealScanTipLight => 'Buena iluminación';

  @override
  String get mealScanFlashOn => 'Flash activado';

  @override
  String get mealScanFlashOff => 'Flash desactivado';

  @override
  String get uxQuickMealText => 'Comida por texto';

  @override
  String get uxQuickMealTextSub => 'Escribe lo que comiste';

  @override
  String get uxQuickBarcode => 'Código de barras';

  @override
  String get uxQuickBarcodeSub => 'Búsqueda en Open Food Facts';

  @override
  String get mealFavoriteSave => 'Guardar en favoritos';

  @override
  String get mealFavoriteSaved => 'Guardado en favoritos';

  @override
  String get mealFavoritesTitle => 'Favoritos';

  @override
  String get mealRecentTitle => 'Comidas recientes';

  @override
  String get mealRelog => 'Registrar de nuevo';

  @override
  String get appearanceTitle => 'Apariencia';

  @override
  String get themeModeSystem => 'Predeterminado del sistema';

  @override
  String get themeModeLight => 'Modo claro';

  @override
  String get themeModeDark => 'Modo oscuro';

  @override
  String get accentThemeTitle => 'Color de acento';

  @override
  String get accentEmber => 'Ámbar (Predeterminado)';

  @override
  String get accentOcean => 'Océano';

  @override
  String get accentForest => 'Bosque';

  @override
  String get accentRoyal => 'Real';

  @override
  String detectedActivity(String activity) {
    return 'Detectado: $activity';
  }

  @override
  String get manualOverride => 'Modificar manualmente';

  @override
  String get mealClarificationTitle => 'Aclaración rápida';

  @override
  String get celebrationWaterTitle => '¡Meta de hidratación alcanzada! 💧';

  @override
  String get celebrationProteinTitle => '¡Meta de proteína superada! 💪';

  @override
  String get celebrationStepsTitle => '¡Meta de pasos completada! 🏃';

  @override
  String get celebrationWorkoutTitle => '¡Entrenamiento completado! 🔥';

  @override
  String fatEquivalentApprox(String amount) {
    return '≈ $amount de grasa';
  }

  @override
  String fatEquivalentBurned(String amount) {
    return 'Quemaste ≈ $amount de grasa';
  }

  @override
  String fatEquivalentTodayDeficit(String amount) {
    return 'Déficit de hoy ≈ $amount de grasa';
  }

  @override
  String fatEquivalentTodaySurplus(int kcal) {
    return 'Superávit +$kcal kcal';
  }

  @override
  String fatEquivalentDietPlanRate(String daily, String weekly) {
    return '≈ $daily grasa/día • ≈ $weekly/sem.';
  }

  @override
  String fatEquivalentThisWeek(String amount) {
    return '≈ $amount de grasa esta semana';
  }

  @override
  String get fatEquivalentInfoTitle => 'Equivalente de grasa';

  @override
  String get fatEquivalentInfoBody =>
      'El peso real en la báscula también varía con el agua y el glucógeno, por lo que el peso diario puede cambiar de forma distinta. Este es el equivalente energético de la grasa.';

  @override
  String get fatEquivalentInfoDismiss => 'Entendido';

  @override
  String get legalTerms => 'Términos';

  @override
  String get legalPrivacy => 'Privacidad';

  @override
  String get legalMedicalDisclaimer => 'Aviso médico';

  @override
  String get welcomeTagline =>
      'Nutrición inteligente y fitness adaptado diseñado especialmente para hombres.';

  @override
  String get welcomePillarScannerTitle => 'Escáner instantáneo de platos';

  @override
  String get welcomePillarScannerDesc =>
      'Foto a tu comida, calorías y proteínas precisas en 2 segundos';

  @override
  String get welcomePillarPlanTitle => 'Plan diario personalizado';

  @override
  String get welcomePillarPlanDesc =>
      'Objetivos científicos adaptados a tu cuerpo y objetivo';

  @override
  String get welcomePillarSafetyTitle => 'Nutrición clínicamente segura';

  @override
  String get welcomePillarSafetyDesc =>
      'Orientación que protege tu metabolismo y salud general';

  @override
  String get onboardingGoalTitle => '¿Cuál es tu objetivo principal?';

  @override
  String get onboardingGoalSubtitle =>
      'Elige lo más importante. Diseñaremos tus objetivos diarios en torno a esto.';

  @override
  String get goalLoseFatTitle => 'Perder grasa';

  @override
  String get goalLoseFatSubtitle =>
      'Quema grasa rebelde manteniendo tu masa muscular';

  @override
  String get goalBuildMuscleTitle => 'Ganar músculo';

  @override
  String get goalBuildMuscleSubtitle =>
      'Maximiza la hipertrofia limpia con proteína optimizada y sobrecarga progresiva';

  @override
  String get goalMoreEnergyTitle => 'Más energía';

  @override
  String get goalMoreEnergySubtitle =>
      'Elimina los bajones a mitad del día y eleva tu resistencia y vitalidad';

  @override
  String get goalAllOfAboveTitle => 'Todo lo anterior';

  @override
  String get goalAllOfAboveSubtitle =>
      'Recomposición corporal total: baja grasa, gana fuerza y energía';

  @override
  String get onboardingBodyTitle => 'Tu perfil corporal';

  @override
  String get onboardingBodySubtitle =>
      'Las métricas precisas nos permiten calcular tu gasto calórico exacto.';

  @override
  String get sexMale => 'Hombre';

  @override
  String get sexFemale => 'Mujer';

  @override
  String get unitMetric => 'Métrico';

  @override
  String get unitImperial => 'Imperial (lb)';

  @override
  String get bodyMetricAge => 'Edad';

  @override
  String bodyMetricYears(int age) {
    return '$age años';
  }

  @override
  String get selectAgeTitle => 'Selecciona tu edad';

  @override
  String ageYearsSuffix(int age) {
    return '$age años';
  }

  @override
  String get bodyMetricHeight => 'Altura';

  @override
  String get selectHeightTitle => 'Selecciona tu altura';

  @override
  String get bodyMetricCurrentWeight => 'Peso actual';

  @override
  String get selectCurrentWeightTitle => 'Selecciona tu peso actual';

  @override
  String get bodyMetricTargetWeight => 'Peso objetivo';

  @override
  String get selectTargetWeightTitle => 'Selecciona tu peso objetivo';

  @override
  String get pickerDone => 'Listo';

  @override
  String get onboardingActivityTitle => 'Actividad y lugar de entrenamiento';

  @override
  String get onboardingActivitySubtitle =>
      'Calibramos el gasto calórico diario y recomendamos entrenamientos óptimos.';

  @override
  String get dailyActivityLevelHeader => 'NIVEL DE ACTIVIDAD DIARIA';

  @override
  String get activitySedentaryTitle => 'Sedentario / Trabajo de oficina';

  @override
  String get activitySedentarySubtitle =>
      'Caminar poco, trabajo de escritorio, menos de 5,000 pasos';

  @override
  String get activityModeratelyActiveTitle => 'Moderadamente activo';

  @override
  String get activityModeratelyActiveSubtitle =>
      'En movimiento regularmente, 6,000–10,000 pasos diarios';

  @override
  String get activityVeryActiveTitle => 'Muy activo / Trabajo físico';

  @override
  String get activityVeryActiveSubtitle =>
      'En movimiento constante o más de 12,000 pasos diarios';

  @override
  String get trainingPlaceHeader => '¿DÓNDE TIENES PENSADO ENTRENAR?';

  @override
  String get trainingPlaceGymTitle => 'Gimnasio';

  @override
  String get trainingPlaceGymSubtitle =>
      'Acceso completo a barras, máquinas y mancuernas';

  @override
  String get trainingPlaceHomeTitle => 'En casa';

  @override
  String get trainingPlaceHomeSubtitle =>
      'Peso corporal, bandas elásticas o mancuernas ligeras';

  @override
  String get trainingPlaceWalkingTitle => 'Caminar';

  @override
  String get trainingPlaceWalkingSubtitle =>
      'Pasos de cardio y caminatas al aire libre';

  @override
  String get onboardingHealthSafetyTitle => 'Evaluación de seguridad médica';

  @override
  String get onboardingHealthSafetySubtitle =>
      'Selecciona las condiciones que apliquen para garantizar tu seguridad.';

  @override
  String get healthSafetyNoneApply => 'Ninguna de estas condiciones me aplica';

  @override
  String get healthSafetyOrSelect => 'O SELECCIONA LAS QUE APLIQUEN';

  @override
  String get onboardingTryScanTitle => 'Prueba el escaneo instantáneo';

  @override
  String get onboardingTryScanSubtitle =>
      'Mira con qué facilidad Vireo desglosa tu comida en macros y calorías.';

  @override
  String get tryScanSamplePlateTitle => 'Ejemplo de plato alto en proteínas';

  @override
  String get tryScanSamplePlateDesc =>
      'Pollo a la plancha, arroz blanco y ensalada';

  @override
  String get tryScanAnalyzing => 'Analizando el plato...';

  @override
  String get tryScanSampleCta => 'Escanear plato de muestra (Instantáneo)';

  @override
  String get tryScanOrTestLive => 'O PRUEBA EN VIVO';

  @override
  String get tryScanOwnMealTitle => 'Escanea tu propia comida';

  @override
  String get tryScanOwnMealDesc => 'Toma una foto en directo de tu plato';

  @override
  String get onboardingPlanRevealTitle => 'Tu plan personalizado';

  @override
  String get onboardingPlanRevealSubtitle =>
      'Diseñado para tu metabolismo y objetivo de acondicionamiento físico.';

  @override
  String get planRevealStartPlan => 'Comenzar mi plan';

  @override
  String get planRevealProjectedPace => 'RITMO PROYECTADO';

  @override
  String get planRevealSteadyRecomp => 'Recomposición corporal constante';

  @override
  String planRevealFatLossPace(String amount) {
    return '-$amount kg / semana de pérdida de grasa';
  }

  @override
  String planRevealLeanMassPace(String amount) {
    return '+$amount kg / semana de masa magra';
  }

  @override
  String get planRevealDailyCalories => 'OBJETIVO CALÓRICO DIARIO';

  @override
  String get planRevealPersonalizedBadge => 'Personalizado';

  @override
  String get planRevealKcalPerDay => 'kcal / día';

  @override
  String get planRevealDailyProtein => 'PROTEÍNA DIARIA';

  @override
  String get planRevealGramPerDay => 'g / día';

  @override
  String get planRevealHydration => 'HIDRATACIÓN';

  @override
  String get planRevealDailySteps => 'PASOS DIARIOS';

  @override
  String get planRevealStepsPerDay => 'pasos / día';

  @override
  String get planRevealDietProtocol => 'PROTOCOLO DIETÉTICO';

  @override
  String get planRevealOptimalMatch => 'Opción óptima';

  @override
  String get planRevealBalancedPlanDefault => 'Plan de déficit equilibrado';

  @override
  String get onboardingNotificationsTitle => 'No te pierdas ningún objetivo';

  @override
  String get onboardingNotificationsSubtitle =>
      'Recordatorios oportunos para mantener tu nutrición, agua y entrenamientos al día.';

  @override
  String get notificationsHeroTitle =>
      'Diseñado para la constancia, no para molestar';

  @override
  String get notificationsHeroBody =>
      'Los usuarios con recordatorios activos tienen 3.4 veces más probabilidades de lograr su peso objetivo.';

  @override
  String get notificationsMealLoggingTitle => 'Registro de comidas';

  @override
  String get notificationsMealLoggingDesc =>
      'Avisos puntuales para almuerzo y cena';

  @override
  String get notificationsWorkoutSessionTitle =>
      'Sesión diaria de entrenamiento';

  @override
  String get notificationsWorkoutSessionDesc =>
      'Mantén el compromiso con tu rutina';

  @override
  String get notificationsWeeklyReviewTitle => 'Revisión semanal de progreso';

  @override
  String get notificationsWeeklyReviewDesc =>
      'Pesaje dominical y resumen de ajustes semanales';

  @override
  String get notificationsEnableButton => 'Activar recordatorios';

  @override
  String get notificationsMaybeLater => 'Quizás más tarde';

  @override
  String get onboardingPaywallTitle => 'Acelera tus resultados';

  @override
  String get onboardingPaywallSubtitle =>
      'Escaneos ilimitados, generación de entrenamientos por IA y analítica avanzada.';

  @override
  String get paywallProBadge => 'Vireo Pro';

  @override
  String get paywallFeatureUnlimitedScansDesc =>
      'Sin preocuparte por límites o cuotas diarias';

  @override
  String get paywallFeatureSmartSub =>
      'Sustituciones inteligentes con IA y preparación de comidas';

  @override
  String get paywallFeatureSmartSubDesc =>
      'Sustitutos adaptados a tus macros al instante';

  @override
  String get paywallFeatureAdaptiveSplits =>
      'Rutinas de entrenamiento adaptativas a medida';

  @override
  String get paywallFeatureAdaptiveSplitsDesc =>
      'Sobrecarga progresiva para gimnasio o casa';

  @override
  String get paywallPlanAnnualPrice => '4,99 \$ / mes';

  @override
  String get paywallPlanAnnualSubtext => 'Facturado anualmente (Ahorra 50%)';

  @override
  String get paywallBadgeBestValue => 'MEJOR VALOR';

  @override
  String get paywallPlanMonthlyPrice => '9,99 \$ / mes';

  @override
  String get paywallPlanMonthlySubtext => 'Facturado mensualmente';

  @override
  String get paywallStartTrialCta => 'Prueba gratis de 7 días';

  @override
  String get paywallContinueFreeTier => 'Continuar con la versión gratuita';

  @override
  String get appInitErrorFailed =>
      'Error al inicializar los servicios de la aplicación.';

  @override
  String get appInitRetry => 'Reintentar';

  @override
  String get privacyExportTitle => 'Exportar mis datos';

  @override
  String get privacyExportReady =>
      'Tu paquete de datos está listo en formatos JSON y CSV:';

  @override
  String get weeklyProgressShareFailed =>
      'No se pudo generar la imagen para compartir';

  @override
  String get adaptiveCalorieCurrentTarget => 'Objetivo actual';

  @override
  String get adaptiveCalorieSuggestedTarget => 'Objetivo sugerido';

  @override
  String get adaptiveCalorieWindowSpan => 'Ventana de tiempo';

  @override
  String get adaptiveCalorieFoodLogsCount => 'Días con comidas registradas';

  @override
  String get adaptiveCalorieWeighInsCount => 'Veces pesado';

  @override
  String get adaptiveCalorieAverageIntake => 'Ingesta promedio';

  @override
  String get adaptiveCalorieTrendWeightChange => 'Tendencia de peso';

  @override
  String get adaptiveCalorieEstimatedMaintenance => 'Mantenimiento estimado';

  @override
  String get adaptiveCalorieWeeklyChangeCap => 'Límite de cambio semanal';

  @override
  String get adaptiveCalorieSafetyFloorApplied =>
      'Mínimo de seguridad aplicado';

  @override
  String get chartSevenDayTrend => 'Tendencia 7 días';

  @override
  String get chartThirtyDayTrend => 'Tendencia 30 días';

  @override
  String get chartRawDot => 'Dato puntual';

  @override
  String get chartTrendLine => 'Línea de tendencia';

  @override
  String get chartGoalLine => 'Línea de objetivo';

  @override
  String get scanSourceSheetTitle => 'Elige el método de registro';

  @override
  String get scanSourceCamera => 'Tomar foto con la cámara';

  @override
  String get scanSourceGallery => 'Elegir de la galería';

  @override
  String get scanSourceText => 'Escribir comida';

  @override
  String get scanSourceFridgeTitle => 'Escanear nevera o despensa';

  @override
  String get scanSourceInBodyTitle => 'Subir informe InBody';

  @override
  String get todayPlanMorning => 'Mañana';

  @override
  String get todayPlanAfternoon => 'Tarde';

  @override
  String get todayPlanEvening => 'Noche';

  @override
  String get todayPlanWaterQuickAdd => '+250 ml';

  @override
  String todayPlanWaterProgress(String current, String goal) {
    return '$current / $goal L';
  }

  @override
  String get todayPlanSleepLogTitle => 'Registro de sueño de calidad';

  @override
  String todayPlanSleepDuration(String hours) {
    return '$hours h de sueño';
  }

  @override
  String get todayPlanSleepLogSave => 'Guardar sueño';

  @override
  String get todayPlanSleepMarkDone => 'Completado (7+ h de sueño)';

  @override
  String get todayPlanSleepQuality => 'Calidad del sueño';

  @override
  String get todayPlanSupplements => 'Suplementos diarios';

  @override
  String get todayPlanBreathingAction => 'Sesión de respiración';

  @override
  String get stepsHeroTitle => 'Pasos de hoy';

  @override
  String get stepsEnableButton => 'Activar contador de pasos';

  @override
  String get stepsPermissionTitle => 'Seguimiento preciso de pasos';

  @override
  String get stepsPermissionBody =>
      'Vireo utiliza el sensor de movimiento integrado de tu dispositivo para contar pasos con precisión durante todo el día sin agotar la batería.';

  @override
  String get stepsPermissionGrant => 'Activar ahora';

  @override
  String get stepsActiveMinutes => 'Minutos activos';

  @override
  String stepsFatBurned(String grams) {
    return '≈ ${grams}g grasa';
  }

  @override
  String stepsKm(String km) {
    return '$km km';
  }

  @override
  String get stepsDetailTitle => 'Pasos y caminata';

  @override
  String get stepsHourlyTitle => 'Desglose por horas';

  @override
  String stepsStreakDays(int days) {
    return 'Racha de $days días';
  }

  @override
  String stepsBestDay(String steps) {
    return 'Mejor día: $steps pasos';
  }

  @override
  String get stepsWeekTab => 'Semana';

  @override
  String get stepsMonthTab => 'Mes';

  @override
  String get mealReviewItemQty => 'Cantidad';

  @override
  String mealReviewConfidence(int pct) {
    return '$pct% de confianza';
  }

  @override
  String get mealReviewSourceUsda => 'Base de datos USDA';

  @override
  String get mealReviewSourceEgypt => 'Tabla de alimentos egipcia';

  @override
  String get mealReviewSourceAi => 'Estimación por IA';

  @override
  String get mealReviewUnitPiece => 'pieza';

  @override
  String get mealReviewUnitHandful => 'puñado';

  @override
  String get mealReviewUnitGrams => 'g';

  @override
  String get mealReviewCookingRaw => 'Crudo';

  @override
  String get mealReviewCookingBoiled => 'Hervido';

  @override
  String get mealReviewCookingGrilled => 'A la plancha / asado';

  @override
  String get mealReviewCookingFried => 'Frito (+aceite)';

  @override
  String get mealReviewCookingBaked => 'Al horno';

  @override
  String mealReviewCaloriesFormat(int count) {
    return '$count kcal';
  }

  @override
  String mealReviewProteinFormat(int count) {
    return '${count}g proteína';
  }

  @override
  String mealReviewCarbsFormat(int count) {
    return '${count}g carbohidratos';
  }

  @override
  String mealReviewFatFormat(int count) {
    return '${count}g grasa';
  }

  @override
  String get cuisineSettingTitle => 'Cocina';

  @override
  String get cuisineEgyptian => 'Egipcia';

  @override
  String get cuisineSaudi => 'Saudí y del Golfo';

  @override
  String get cuisineLevantine => 'Levantina';

  @override
  String get cuisineMoroccan => 'Marroquí y del Magreb';

  @override
  String get cuisineTurkish => 'Turca';

  @override
  String get cuisineIndian => 'India y Pakistaní';

  @override
  String get cuisineIndonesian => 'Indonesia';

  @override
  String get cuisineWestern => 'Occidental / Mediterránea';

  @override
  String dietProgramFitReason(String reason) {
    return 'Se adapta a tu objetivo: $reason';
  }

  @override
  String get exerciseMusclesTargeted => 'Músculos objetivo';

  @override
  String get exerciseStepsTitle => 'Cómo realizarlo paso a paso';

  @override
  String get exerciseCommonMistakes => 'Errores comunes';

  @override
  String get exerciseBreathingCue => 'Respiración';

  @override
  String get exerciseEasierVariation => 'Variación más fácil';

  @override
  String get exerciseHarderVariation => 'Variación más difícil';

  @override
  String get exerciseSafetyNote => 'Nota de seguridad';

  @override
  String get exerciseWarmUpHeader => 'Movimientos de calentamiento';

  @override
  String get reassessmentLaterSnooze => 'Más tarde (recordar en 3 días)';

  @override
  String get measurementsAddEntry => 'Registrar nueva medida';

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
      'No se pudo cambiar el estado del podómetro, inténtalo de nuevo';

  @override
  String get scoreInsightsTitle => 'Puntuación y Predicciones Inteligentes 🎯';

  @override
  String scoreInsightsTodaySummary(int eaten, int target) {
    return 'Hoy: consumiste $eaten de $target kcal';
  }

  @override
  String scoreInsightsWeekFatSummary(int grams) {
    return 'Esta semana: perdiste ≈ ${grams}g de grasa';
  }

  @override
  String scoreInsightsGoalWeeksSummary(String weeks) {
    return 'Alcanza tu meta en ≈ $weeks semanas';
  }

  @override
  String get scoreInsightsActionLogProtein =>
      'Registra una comida rica en proteínas';

  @override
  String get scoreInsightsActionWalk => 'Comienza a caminar hacia tu meta';

  @override
  String get scoreInsightsActionWater => 'Registra un vaso de agua ahora';

  @override
  String get scoreInsightsPredictionsTitle =>
      'Predicciones Inteligentes (Estimado 🔮)';

  @override
  String get scoreInsightsPredictionsSubtitle =>
      'Basado en déficit calórico y tasa metabólica';

  @override
  String scoreInsightsNeedData(int days) {
    return 'Se necesitan al menos 3 días completos ($days registrados)';
  }

  @override
  String get scoreInsightsWeeklyFatLoss => 'Pérdida semanal de grasa';

  @override
  String get scoreInsightsIn4Weeks => 'En 4 Semanas';

  @override
  String get scoreInsightsIn8Weeks => 'En 8 Semanas';

  @override
  String get scoreInsightsGoalHitIn => 'Meta en';

  @override
  String get scoreInsightsClampWarning =>
      '⚠️ Pérdida limitada a ≤1% de peso por semana para proteger masa muscular.';

  @override
  String get scoreInsightsAggressiveDeficitWarning =>
      '⚠️ El déficit supera 1,000 kcal/día. Consume un poco más para preservar el metabolismo.';

  @override
  String get scoreInsightsHowCalculatedTitle =>
      '¿Cómo se calculó? (Mifflin-St Jeor)';

  @override
  String scoreInsightsHowCalculatedBmr(String bmr) {
    return '• Tasa Metabólica Basal (TMB): $bmr kcal';
  }

  @override
  String scoreInsightsHowCalculatedTdee(String tdee) {
    return '• Gasto Energético Diario Total (TDEE): $tdee kcal';
  }

  @override
  String get scoreInsightsHowCalculatedFat =>
      '• Déficit de 7,700 kcal ≈ 1 kg de grasa corporal.';

  @override
  String get scoreInsightsBodyCompTitle => 'Composición Corporal';

  @override
  String get scoreInsightsBodyCompNewMeasure => 'Nueva Medida';

  @override
  String get scoreInsightsBodyCompPrompt =>
      'Evalúa grasa y masa muscular con cinta o InBody';

  @override
  String get scoreInsightsEnergyBalanceTitle =>
      'Balance Energético (Consumido vs Quemado)';

  @override
  String get scoreInsightsEatenKcal => 'Consumido';

  @override
  String get scoreInsightsBurnedKcal => 'Quemado';

  @override
  String get scoreInsightsMacrosTitle => 'Macros de Hoy (Objetivo vs Real)';

  @override
  String get scoreInsightsScoreTrendTitle =>
      'Tendencia de Puntuación de 7 Días';

  @override
  String get scoreInsightsImmediateActionsTitle =>
      'Consejos inmediatos para mejorar:';

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
      '¿Qué tan duro se sintió? 1 = muy fácil, 10 = muy difícil';

  @override
  String workoutRpeLabel(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      '1': 'Muy fácil',
      '2': 'Fácil',
      '3': 'Bastante fácil',
      '4': 'Ligero',
      '5': 'Moderado',
      '6': 'Algo duro',
      '7': 'Intenso',
      '8': 'Duro',
      '9': 'Muy duro',
      'other': 'Muy difícil',
    });
    return '$_temp0';
  }

  @override
  String get workoutRpeFeelingsTitle => '¿Cómo te sientes?';

  @override
  String get workoutFeelTired => 'Cansancio';

  @override
  String get workoutFeelJointPain => 'Dolor articular';

  @override
  String workoutFeelHappy(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'De buen humor',
      'other': 'De buen humor',
    });
    return '$_temp0';
  }

  @override
  String get workoutFeelEnergized => 'Mucha energía';

  @override
  String get workoutRpeNoteHint => 'Añade una nota (opcional)';

  @override
  String get workoutRpeSave => 'Guardar';

  @override
  String get workoutRpeDone => 'Listo';

  @override
  String get workoutRpeSavedTitle => 'Guardado ✅';

  @override
  String get workoutRpeCommentJoint =>
      'El dolor articular es una señal que hay que respetar. Reduce la carga en la próxima sesión y cuida la técnica.';

  @override
  String get workoutRpeCommentHard =>
      'Fue una sesión exigente. Bajaremos un poco la carga la próxima vez para que te recuperes bien.';

  @override
  String get workoutRpeCommentBetter =>
      '¡Tu rendimiento mejora! Se sintió más ligero que la última vez 💪';

  @override
  String get workoutRpeCommentEasy =>
      'Se sintió fácil. En la próxima sesión subiremos un poco la carga.';

  @override
  String get workoutRpeCommentSteady => 'Esfuerzo justo. Mantén este ritmo.';

  @override
  String get workoutRpeCommentPartial =>
      'Lo que hiciste cuenta. Volveremos más fuertes en la próxima sesión.';

  @override
  String get foodFactCardTitle => 'Dato sobre tu comida';

  @override
  String get foodFactShareHint => 'Toca para compartir la tarjeta';

  @override
  String get ramadanGuideTitle => 'Guía de Ramadán';

  @override
  String get ramadanGuideOpenHint =>
      'Ranking del suhur y ritmo del iftar — toca';

  @override
  String get ramadanSuhoorRankTitle => 'Ranking de saciedad en suhur';

  @override
  String ramadanSuhoorRankSubtitle(int grams, int kcal) {
    return 'Porción ejemplo $grams g · ≈ $kcal kcal';
  }

  @override
  String get ramadanIftarPaceTitle => 'Ritmo del iftar';

  @override
  String get ramadanIftarStep1 => 'Dátiles + agua primero';

  @override
  String get ramadanIftarStep2 => 'Sopa caliente';

  @override
  String get ramadanIftarStep3 => 'Espera 15 minutos';

  @override
  String get ramadanIftarStep4 => 'Plato principal';

  @override
  String get ramadanReboundTitle => 'Después de Ramadán';

  @override
  String ramadanReboundBody(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female':
          'Vuelve con calma: proteína en suhur, registra el iftar sin culpa y suma 10 min de caminata una semana antes de bajar mucho las calorías.',
      'other':
          'Vuelve con calma: proteína en suhur, registra el iftar sin culpa y suma 10 min de caminata una semana antes de bajar mucho las calorías.',
    });
    return '$_temp0';
  }

  @override
  String get settingsMySubscription => 'Mi suscripción';

  @override
  String get settingsMySubscriptionBody =>
      'Cancela o cambia tu plan en Google Play cuando quieras.';

  @override
  String get weeklyBurnShareTitle => 'Tu balance de quema esta semana';

  @override
  String get weeklyBurnShareSubtitle => 'Comparte pasos y racha';

  @override
  String get weeklyBurnShareCaption => 'Mi balance semanal en Vireo';

  @override
  String get weeklyBurnShareAction => 'Compartir tarjeta';

  @override
  String get weeklyBurnShareIncludeWeight => 'Incluir cambio de peso';

  @override
  String get weeklyBurnShareStepsLabel => 'Pasos de la semana';

  @override
  String get weeklyBurnShareStreakLabel => 'Racha';

  @override
  String get weeklyBurnShareWeightLabel => 'Cambio de peso';

  @override
  String get widgetCaloriesLeftLabel => 'Calorías restantes';

  @override
  String get scanLimitTitle => 'Límite diario de escaneo alcanzado';

  @override
  String get scanLimitBody =>
      'Espera hasta mañana, pásate a Pro o registra manualmente.';

  @override
  String get scanLimitProTitle => 'Vireo Pro';

  @override
  String get scanLimitProSubtitle =>
      'Escaneos ilimitados (40/día), sin anuncios';

  @override
  String get scanLimitProCta => 'Obtener Pro';

  @override
  String get scanLimitWaitTitle => 'Espera hasta mañana';

  @override
  String get scanLimitWaitSubtitle =>
      'Tus escaneos gratis se renuevan a medianoche';

  @override
  String get scanLimitWaitCta => 'Vale, hasta mañana';

  @override
  String get scanLimitManualTitle => 'Búsqueda y registro manual';

  @override
  String get scanLimitManualSubtitle => 'Siempre gratis e ilimitado';

  @override
  String get scanLimitManualCta => 'Registrar manualmente';

  @override
  String get scanLimitAdRewardSnack => '+2 escaneos añadidos hoy';

  @override
  String get scanLimitAdFailedSnack => 'No se pudo cargar el anuncio';

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
}
