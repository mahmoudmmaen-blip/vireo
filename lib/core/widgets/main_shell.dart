import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/ad_service.dart';
import 'package:vireo/core/services/shell_navigation_provider.dart';
import 'package:vireo/core/services/sync_engine.dart';
import 'package:vireo/core/services/user_sex_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:home_widget/home_widget.dart';
import 'package:vireo/core/services/home_widget_sync.dart';
import 'package:vireo/core/utils/connectivity_check.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/subscription/feature_gates.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/diary/screens/diary_screen.dart';
import 'package:vireo/features/diet_programs/data/diet_plan_storage.dart';
import 'package:vireo/features/diet_programs/screens/diet_quiz_screen.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/features/diet_programs/providers/diet_programs_provider.dart';
import 'package:vireo/features/home/home_screen.dart';
import 'package:vireo/features/notifications/providers/notification_settings_provider.dart';
import 'package:vireo/features/notifications/services/nurture_scheduler.dart';
import 'package:vireo/features/nutrition/nutrition_screen.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/profile/profile_screen.dart';
import 'package:vireo/features/progress/progress_screen.dart';
import 'package:vireo/features/progress/widgets/reassessment_gate.dart';
import 'package:vireo/features/ai_nutrition/screens/ai_scan_screen.dart';
import 'package:vireo/core/services/celebration_service.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';
import 'package:vireo/features/nutrition/providers/daily_nutrition_totals_provider.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';
import 'package:vireo/features/walking/providers/walking_tracker_provider.dart';
import 'package:vireo/features/water/providers/water_daily_goal_provider.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';
import 'package:vireo/features/quick_log/quick_log_sheet.dart';
import 'package:vireo/features/subscription/widgets/subscription_shell_gate.dart';
import 'package:vireo/features/walking/screens/full_walk_tab_screen.dart';
import 'package:vireo/features/workout/workout_screen.dart';

/// App shell: 4 primary tabs + a centre "+" quick-log action.
/// The 3 pillars: Home / Food / "+" / Walk / Workouts.
///
/// Bottom-bar destinations: 0 Home, 1 Food (Nutrition), 2 Workout, 3 Walk.
/// Progress (4), Profile (5) and Diary (6) remain available via notifier / deep links.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> with WidgetsBindingObserver {
  static const _screens = <Widget>[
    HomeScreen(),
    NutritionScreen(),
    FullWalkTabScreen(),
    WorkoutScreen(),
    ProgressScreen(),
    ProfileScreen(),
    DiaryScreen(),
  ];

  bool _offeredDietQuiz = false;
  Timer? _connectivityPollTimer;
  bool _wasConnected = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    HomeWidget.widgetClicked.listen((uri) {
      if (!mounted) return;
      _openFromWidgetUri(uri);
    });
    HomeWidget.initiallyLaunchedFromHomeWidget().then((uri) {
      if (!mounted || uri == null) return;
      _openFromWidgetUri(uri);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerSyncPull();
      _startConnectivityWatcher();
      // Ensure pedometer stream and step counter are booted silently if permitted
      ref.read(stepCounterBootstrapProvider);
      final isPro = ref.read(isProUserProvider);
      AdService.instance.initialize(isPro: isPro);
      if (mounted) syncHomeScreenWidget(ref, context: context);
    });
  }

  void _openFromWidgetUri(Uri? uri) {
    if (uri == null) return;
    if (uri.host == 'nutrition' && uri.path.contains('camera')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) AiScanScreen.openCamera(context, ref);
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivityPollTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _triggerSyncPull();
      _syncWidget();
      // Refresh steps on app resume
      StepCounterService.refresh();
    } else if (state == AppLifecycleState.paused) {
      _syncWidget();
    }
  }

  void _syncWidget() {
    if (!mounted) return;
    syncHomeScreenWidget(ref, context: context);
  }

  void _triggerSyncPull() {
    final auth = ref.read(authProvider).valueOrNull;
    final userId = auth?.user?.id;
    if (userId != null && !auth!.isGuest) {
      ref.read(syncEngineProvider).pullChanges(userId);
    }
  }

  void _startConnectivityWatcher() {
    _connectivityPollTimer?.cancel();
    _connectivityPollTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
      final isConnected = await hasNetworkConnection();
      if (isConnected && !_wasConnected) {
        ref.read(syncEngineProvider).pushQueue();
      }
      _wasConnected = isConnected;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_offeredDietQuiz) return;
    _offeredDietQuiz = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      if (!DietPlanStorage.readPendingQuiz()) return;
      await DietPlanStorage.setPendingQuiz(false);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const DietQuizScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(shellTabIndexProvider);
    ref.watch(notificationBootstrapProvider);
    ref.watch(nurtureBootstrapProvider);
    void markGoalHit() => ref.read(nurtureSchedulerProvider).markGoalHit();
    void rescheduleIfEnabled() {
      final settings = ref.read(notificationSettingsProvider);
      if (settings.hasAnyEnabled) {
        ref.read(notificationServiceProvider).scheduleAll(settings);
      }
    }

    ref.listen(todayWorkoutProvider, (prev, next) => rescheduleIfEnabled());
    ref.listen(activeDietProgramProvider, (prev, next) => rescheduleIfEnabled());
    ref.listen(effectiveTodayMealsProvider, (prev, next) => rescheduleIfEnabled());
    ref.listen(localeProvider, (prev, next) => rescheduleIfEnabled());

    // Celebrations: water goal, protein goal, step goal
    ref.listen(waterTrackerProvider, (prev, next) {
      final goal = ref.read(waterDailyGoalMlProvider);
      if (goal > 0 && next >= goal) {
        markGoalHit();
        CelebrationService.trigger(
          context,
          type: CelebrationType.water,
          message: AppLocalizations.of(context).celebrationWaterTitle,
        );
      }
    });

    final isFemale = ref.watch(isFemaleUserProvider);
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');

    ref.listen(dailyNutritionTotalsProvider, (prev, next) {
      final target = ref.read(calorieGoalProvider).proteinG;
      if (target > 0 && next.protein >= target) {
        markGoalHit();
        CelebrationService.trigger(
          context,
          type: CelebrationType.protein,
          message: isFemale && isArabic
              ? 'عاش يا بطلة! قفلتِ هدف البروتين 💪'
              : AppLocalizations.of(context).celebrationProteinTitle,
        );
      }
    });

    ref.listen(todayStepsProvider, (prev, next) {
      final goal = ref.read(walkingTrackerProvider).valueOrNull?.dailyGoal ?? 6000;
      if (goal > 0 && next >= goal) {
        markGoalHit();
        CelebrationService.trigger(
          context,
          type: CelebrationType.steps,
          message: AppLocalizations.of(context).celebrationStepsTitle,
        );
      }
    });

    ref.listen(vitalityDailyLogProvider, (prev, next) {
      if (next.workoutCompleted && (prev == null || !prev.workoutCompleted)) {
        markGoalHit();
        CelebrationService.trigger(
          context,
          type: CelebrationType.workout,
          message: isFemale && isArabic
              ? 'عاش يا بطلة! خلّصتِ تمرينك النهاردة بنجاح 🔥'
              : AppLocalizations.of(context).celebrationWorkoutTitle,
        );
      }
    });

    return PopScope(
      // Android back on a secondary tab returns Home instead of exiting.
      canPop: index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) ref.read(shellTabIndexProvider.notifier).goHome();
      },
      child: Scaffold(
        body: SubscriptionShellGate(
          child: ReassessmentGate(
            child: IndexedStack(
              index: index,
              sizing: StackFit.expand,
              children: [
                for (var i = 0; i < _screens.length; i++)
                  HeroMode(
                    enabled: i == index,
                    child: _screens[i],
                  ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _VireoBottomBar(
          index: index,
          onSelect: (value) {
            if (value == index) return;
            HapticFeedback.selectionClick();
            ref.read(shellTabIndexProvider.notifier).goTo(value);
          },
          onQuickLog: () => showQuickLogSheet(context, ref),
          onQuickLogLongPress: () => AiScanScreen.open(context, ref),
        ),
      ),
    );
  }
}

class _VireoBottomBar extends StatelessWidget {
  const _VireoBottomBar({
    required this.index,
    required this.onSelect,
    required this.onQuickLog,
    required this.onQuickLogLongPress,
  });

  final int index;
  final ValueChanged<int> onSelect;
  final VoidCallback onQuickLog;
  final VoidCallback onQuickLogLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    Widget tab(int i, IconData icon, IconData activeIcon, String label) {
      return Expanded(
        child: _NavItem(
          icon: icon,
          activeIcon: activeIcon,
          label: label,
          selected: index == i,
          onTap: () => onSelect(i),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.line.withValues(alpha: 0.6))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              tab(0, Icons.home_outlined, Icons.home_rounded, l10n.homeTitle),
              tab(1, Icons.restaurant_outlined, Icons.restaurant_rounded,
                  l10n.nutritionTitle),
              Expanded(
                child: Center(
                  child: _QuickLogButton(
                    onTap: onQuickLog,
                    onLongPress: onQuickLogLongPress,
                  ),
                ),
              ),
              tab(2, Icons.directions_walk_rounded, Icons.directions_walk_rounded,
                  l10n.walkingTitle),
              tab(3, Icons.fitness_center_outlined, Icons.fitness_center_rounded,
                  l10n.workoutTitle),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Semantics(
      selected: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: Pressable(
        onTap: onTap,
        haptic: false,
        scale: 0.94,
        child: Center(
          child: AnimatedContainer(
            duration: VMotion.base,
            curve: VMotion.standard,
            padding: EdgeInsets.symmetric(
              horizontal: selected ? 10 : 4,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? colors.ember.withValues(alpha: 0.16)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(VRadius.pill),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  selected ? activeIcon : icon,
                  color: selected ? colors.ember : colors.textMute,
                  size: 23,
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: TextStyle(
                      color: selected ? colors.ember : colors.textMute,
                      fontSize: 12.5,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickLogButton extends StatelessWidget {
  const _QuickLogButton({required this.onTap, required this.onLongPress});

  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Tooltip(
      message: l10n.uxQuickLogTitle,
      child: Pressable(
        onTap: onTap,
        onLongPress: onLongPress,
        haptic: false,
        scale: 0.9,
        semanticLabel: l10n.uxQuickLogTitle,
        child: Container(
          width: 54,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(VRadius.md),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(colors.ember, Colors.white, 0.12)!,
                colors.ember,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: colors.ember.withValues(alpha: 0.45),
                blurRadius: 16,
                spreadRadius: -4,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
