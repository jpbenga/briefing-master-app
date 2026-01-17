import 'package:flutter/material.dart';

class ScreenTransition extends StatelessWidget {
  const ScreenTransition({super.key, required this.child, required this.routeKey});

  final Widget child;
  final ValueKey<String> routeKey;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 0.02),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
      child: KeyedSubtree(
        key: routeKey,
        child: child,
      ),
    );
  }
}
