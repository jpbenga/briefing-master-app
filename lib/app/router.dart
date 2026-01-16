import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Route non trouvée'),
        ),
      ),
    );
  }
}
