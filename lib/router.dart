import 'package:docuflex/features/home/home_screen.dart';
import 'package:docuflex/onboarding/main_screen.dart';
import 'package:docuflex/onboarding/onboarding_screen.dart';
import 'package:docuflex/onboarding/splash_screen.dart';
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

    case HomeScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
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
