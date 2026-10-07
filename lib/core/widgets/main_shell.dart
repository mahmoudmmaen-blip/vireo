import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/shell_navigation_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/diary/screens/diary_screen.dart';
import 'package:vireo/features/home/home_screen.dart';
import 'package:vireo/features/notifications/providers/notification_settings_provider.dart';
import 'package:vireo/features/nutrition/nutrition_screen.dart';
import 'package:vireo/features/profile/profile_screen.dart';
import 'package:vireo/features/progress/progress_screen.dart';
import 'package:vireo/features/progress/widgets/reassessment_gate.dart';
import 'package:vireo/features/quick_log/quick_log_sheet.dart';
import 'package:vireo/features/subscription/widgets/subscription_shell_gate.dart';
import 'package:vireo/features/workout/workout_screen.dart';

/// App shell: 4 primary tabs + a centre "+" quick-log action.
///
/// Bottom-bar destinations: 0 home, 1 workout, 2 nutrition, 3 progress.
/// Profile (4) is reached from the avatar on Home; Diary (5) stays available
/// via [ShellTabIndexNotifier.goDiary] / deep links.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  static const _screens = <Widget>[
    HomeScreen(),
    WorkoutScreen(),
    NutritionScreen(),
    ProgressScreen(),
    ProfileScreen(),
    DiaryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(shellTabIndexProvider);
    ref.watch(notificationBootstrapProvider);
    ref.listen(todayWorkoutProvider, (previous, next) {
      final settings = ref.read(notificationSettingsProvider);
      if (settings.hasAnyEnabled) {
        ref.read(notificationServiceProvider).scheduleAll(settings);
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
  });

  final int index;
  final ValueChanged<int> onSelect;
  final VoidCallback onQuickLog;

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
              tab(1, Icons.fitness_center_outlined, Icons.fitness_center_rounded,
                  l10n.workoutTitle),
              Expanded(child: Center(child: _QuickLogButton(onTap: onQuickLog))),
              tab(2, Icons.restaurant_outlined, Icons.restaurant_rounded,
                  l10n.nutritionTitle),
              tab(3, Icons.insights_outlined, Icons.insights_rounded,
                  l10n.progressTitle),
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
    final color = selected ? colors.ember : colors.textMute;

    return Semantics(
      selected: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: Pressable(
        onTap: onTap,
        haptic: false,
        scale: 0.92,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: VMotion.base,
              curve: VMotion.standard,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: selected
                    ? colors.ember.withValues(alpha: 0.14)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(VRadius.pill),
              ),
              child: AnimatedSwitcher(
                duration: VMotion.fast,
                child: Icon(
                  selected ? activeIcon : icon,
                  key: ValueKey<bool>(selected),
                  color: color,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLogButton extends StatelessWidget {
  const _QuickLogButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Tooltip(
      message: l10n.uxQuickLogTitle,
      child: Pressable(
        onTap: onTap,
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
