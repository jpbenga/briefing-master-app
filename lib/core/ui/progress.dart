import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 8,
        color: AppTokens.surfaceMuted,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: (value.clamp(0, 100)) / 100,
            child: Container(
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
