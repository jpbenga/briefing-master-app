import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';

class AudioVisualizer extends StatefulWidget {
  const AudioVisualizer({super.key, required this.active});

  final bool active;

  @override
  State<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer> {
  double seed = 0.4;
  Timer? timer;

  @override
  void didUpdateWidget(covariant AudioVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && timer == null) {
      timer = Timer.periodic(const Duration(milliseconds: 140), (_) {
        setState(() => seed = 0.25 + Random().nextDouble() * 0.75);
      });
    } else if (!widget.active && timer != null) {
      timer?.cancel();
      timer = null;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bars = List.generate(18, (index) {
      final base = 0.25 + (sin((index + 1) * 0.9)).abs() * 0.45;
      final amp = widget.active ? seed : 0.18;
      return _clamp(base * amp * 100, 8, 100);
    });

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x26000000),
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        border: Border.all(color: AppTokens.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: bars
            .map(
              (height) => Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOut,
                  height: height / 100 * 40,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: Colors.white70.withOpacity(widget.active ? 0.95 : 0.45),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

double _clamp(double value, double min, double max) => value.clamp(min, max);
