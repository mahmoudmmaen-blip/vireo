import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/features/home/home_screen.dart';
import 'package:vireo/features/nutrition/nutrition_screen.dart';
import 'package:vireo/features/profile/profile_screen.dart';
import 'package:vireo/features/progress/progress_screen.dart';
import 'package:vireo/features/progress/widgets/reassessment_gate.dart';
import 'package:vireo/features/subscription/widgets/subscription_shell_gate.dart';
import 'package:vireo/features/workout/workout_screen.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  /// Home is always the default tab (index 0).
  int _index = 0;

  static const _screens = <Widget>[
    HomeScreen(),
    WorkoutScreen(),
    NutritionScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SubscriptionShellGate(
        child: ReassessmentGate(
          child: IndexedStack(index: _index, children: _screens),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.homeTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.fitness_center_outlined),
            selectedIcon: const Icon(Icons.fitness_center),
            label: l10n.workoutTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.restaurant_outlined),
            selectedIcon: const Icon(Icons.restaurant),
            label: l10n.nutritionTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.trending_up_outlined),
            selectedIcon: const Icon(Icons.trending_up),
            label: l10n.progressTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.profileTitle,
          ),
        ],
      ),
    );
  }
}
