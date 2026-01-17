import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dynamic_i18n_models.dart';
import 'dynamic_i18n_repository.dart';

final dynamicI18nRepositoryProvider = Provider<DynamicI18nRepository>((ref) {
  return DynamicI18nRepository();
});

final scenariosProvider = Provider<List<Scenario>>((ref) {
  return ref.watch(dynamicI18nRepositoryProvider).fetchScenarios();
});
