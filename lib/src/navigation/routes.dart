import 'package:flutter/material.dart';
import 'package:simple_firebase_crud_cubit/src/ui/home_screen.dart';
import 'package:simple_firebase_crud_cubit/src/ui/intro_screen.dart';
import 'package:simple_firebase_crud_cubit/src/ui/splash_screen.dart';

class Routes {
  static const splash = '/';
  static const intro = '/intro';
  static const home = '/home';

  static Route routes(RouteSettings settings) {
    MaterialPageRoute buildRoute(Widget widget) {
      return MaterialPageRoute(builder: (_) => widget, settings: settings);
    }

    switch (settings.name) {
      case splash:
        return buildRoute(const IntroScreen());
      case intro:
        return buildRoute(const IntroScreen());
      case home:
        return buildRoute(const HomeScreen());
      default:
        throw Exception('Route does not exists');
    }
  }
}
