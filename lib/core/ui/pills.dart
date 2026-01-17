import 'package:flutter/material.dart';

import '../theme/tokens.dart';

enum PillVariant { muted, success, warn, danger }

class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.label,
    this.icon,
    this.variant = PillVariant.muted,
  });

  final String label;
  final IconData? icon;
  final PillVariant variant;

  @override
  Widget build(BuildContext context) {
    final style = _pillStyle(variant);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: style.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: style.foreground),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: style.foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _PillStyle {
  const _PillStyle({required this.background, required this.border, required this.foreground});

  final Color background;
  final Color border;
  final Color foreground;
}

_PillStyle _pillStyle(PillVariant variant) {
  switch (variant) {
    case PillVariant.success:
      return const _PillStyle(
        background: Color(0x1A10B981),
        border: Color(0x3310B981),
        foreground: Color(0xFFD1FAE5),
      );
    case PillVariant.warn:
      return const _PillStyle(
        background: Color(0x1AF59E0B),
        border: Color(0x33F59E0B),
        foreground: Color(0xFFFDE68A),
      );
    case PillVariant.danger:
      return const _PillStyle(
        background: Color(0x1AF43F5E),
        border: Color(0x33F43F5E),
        foreground: Color(0xFFFBCFE8),
      );
    case PillVariant.muted:
    default:
      return const _PillStyle(
        background: Color(0x1AFFFFFF),
        border: AppTokens.borderLight,
        foreground: AppTokens.textSecondary,
      );
  }
}
