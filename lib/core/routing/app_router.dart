import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routes.dart';

class AppRouteState {
  AppRouteState({required this.route, required this.history});

  final AppRoute route;
  final List<AppRoute> history;

  AppRouteState copyWith({AppRoute? route, List<AppRoute>? history}) {
    return AppRouteState(
      route: route ?? this.route,
      history: history ?? this.history,
    );
  }
}

class AppRouteController extends StateNotifier<AppRouteState> {
  AppRouteController()
      : super(AppRouteState(route: AppRoute.welcome, history: [AppRoute.welcome]));

  void goTo(AppRoute next) {
    state = state.copyWith(
      route: next,
      history: [...state.history, next],
    );
  }

  void back() {
    if (state.history.length <= 1) {
      return;
    }
    final nextHistory = [...state.history]..removeLast();
    state = state.copyWith(route: nextHistory.last, history: nextHistory);
  }
}

final appRouteProvider = StateNotifierProvider<AppRouteController, AppRouteState>(
  (ref) => AppRouteController(),
);

final currentRouteProvider = Provider<AppRoute>(
  (ref) => ref.watch(appRouteProvider).route,
);
