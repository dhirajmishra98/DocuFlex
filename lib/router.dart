import 'features/scanner/doc_scanner_screen.dart';
import 'onboarding/main_screen.dart';
import 'onboarding/onboarding_screen.dart';
import 'onboarding/splash_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SplashScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );

    case OnboardingScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const OnboardingScreen(),
      );

    case MainScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const MainScreen(),
      );

    case DocScannerScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const DocScannerScreen(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Error Occurred'),
          ),
        ),
      );
  }
}
