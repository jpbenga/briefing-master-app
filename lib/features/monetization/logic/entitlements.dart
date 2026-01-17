import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PlanType { free, premium, sprint }

final planProvider = StateProvider<PlanType>((ref) => PlanType.free);

final hasPremiumProvider = Provider<bool>((ref) {
  final plan = ref.watch(planProvider);
  return plan != PlanType.free;
});
