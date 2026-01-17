import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'cards.dart';

class WhatToDoCard extends StatelessWidget {
  const WhatToDoCard({super.key, required this.title, required this.steps});

  final String title;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: const Color(0x1AFFFFFF),
      borderColor: AppTokens.borderLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
          ),
          const SizedBox(height: 8),
          Column(
            children: steps
                .asMap()
                .entries
                .map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(bottom: entry.key == steps.length - 1 ? 0 : 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: AppTokens.surfaceMuted,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppTokens.borderLight),
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTokens.textSecondary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
