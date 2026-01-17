import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/i18n/l10n_ext.dart';
import '../../../core/theme/tokens.dart';

class FlipCardWidget extends StatefulWidget {
  const FlipCardWidget({
    super.key,
    required this.tier,
    required this.subtitle,
    required this.front,
    required this.back,
  });

  final String tier;
  final String subtitle;
  final String front;
  final String back;

  @override
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget> with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 420), vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (controller.status == AnimationStatus.completed) {
      controller.reverse();
    } else {
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final isFront = controller.value < 0.5;
          final rotation = controller.value * pi;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(rotation),
            child: isFront
                ? _FlipFace(
                    title: widget.tier,
                    subtitle: widget.subtitle,
                    body: widget.front,
                    isFront: true,
                  )
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationX(pi),
                    child: _FlipFace(
                      title: context.l10n.flipUpgradeSuggestion,
                      subtitle: context.l10n.flipExecutivePolish,
                      body: widget.back,
                      isFront: false,
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class _FlipFace extends StatelessWidget {
  const _FlipFace({
    required this.title,
    required this.subtitle,
    required this.body,
    required this.isFront,
  });

  final String title;
  final String subtitle;
  final String body;
  final bool isFront;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isFront ? AppTokens.surfaceGlass : AppTokens.surfaceMuted,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        border: Border.all(color: AppTokens.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 11, color: AppTokens.textMuted)),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                  ),
                ],
              ),
              Text(
                context.l10n.flipTapToFlip,
                style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '“$body”',
            style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.3),
          ),
        ],
      ),
    );
  }
}
