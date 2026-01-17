import 'package:flutter/material.dart';

import '../core/i18n/l10n_ext.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      builder: (context) => Scaffold(
        body: Center(
          child: Text(context.l10n.routeNotFound),
        ),
      ),
    );
  }
}
