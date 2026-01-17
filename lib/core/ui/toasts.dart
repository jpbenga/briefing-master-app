import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class ToastMessage {
  const ToastMessage({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
  });

  final String id;
  final ToastType type;
  final String title;
  final String body;
}

enum ToastType { tip, warn, danger }

class ToastOverlay extends StatelessWidget {
  const ToastOverlay({super.key, required this.items, required this.onClear});

  final List<ToastMessage> items;
  final void Function(String id) onClear;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 12,
      right: 12,
      top: 56,
      child: Column(
        children: items.take(3).map((toast) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ToastCard(
              toast: toast,
              onClear: () => onClear(toast.id),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ToastCard extends StatelessWidget {
  const _ToastCard({required this.toast, required this.onClear});

  final ToastMessage toast;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final color = switch (toast.type) {
      ToastType.warn => const Color(0x1AF59E0B),
      ToastType.danger => const Color(0x1AF43F5E),
      ToastType.tip => AppTokens.surfaceGlass,
    };
    final border = switch (toast.type) {
      ToastType.warn => const Color(0x33F59E0B),
      ToastType.danger => const Color(0x33F43F5E),
      ToastType.tip => AppTokens.borderLight,
    };

    return AnimatedSlide(
      duration: const Duration(milliseconds: 180),
      offset: const Offset(0, 0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: 1,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppTokens.radiusMd),
            border: Border.all(color: border),
            boxShadow: const [AppTokens.softShadow],
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      toast.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      toast.body,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTokens.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClear,
                child: const Text(
                  '✕',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTokens.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
