import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = "/splash-screen";
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Splash Screen"),);
  }
}
