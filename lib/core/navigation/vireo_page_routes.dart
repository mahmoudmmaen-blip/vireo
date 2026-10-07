import 'package:flutter/material.dart';

/// Slide from bottom 30px + fade — 300ms easeOutCubic.
class SlideUpRoute<T> extends PageRouteBuilder<T> {
  SlideUpRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        );

  final Widget page;
}

/// Opacity-only transition — 200ms.
class FadeRoute<T> extends PageRouteBuilder<T> {
  FadeRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 200),
          reverseTransitionDuration: const Duration(milliseconds: 180),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        );

  final Widget page;
}

extension VireoNavigator on NavigatorState {
  Future<T?> pushSlideUp<T>(Widget page) =>
      push<T>(SlideUpRoute<T>(page: page));

  Future<T?> pushFade<T>(Widget page) => push<T>(FadeRoute<T>(page: page));
}
