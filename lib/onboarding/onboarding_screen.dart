// ignore_for_file: use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:docuflex/models/onboarding_model.dart';
import 'package:docuflex/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/global_variables.dart';
import 'main_screen.dart';

final pages = [
   OnboardingModel(
    icon: Remix.graduation_cap_fill,
    title: "Welcome to DocuFlex!",
    description: "some description here...",
    bgColor: GlobalVariables.deepPurple,
    textColor: Colors.white,
  ),
   OnboardingModel(
    icon: Remix.pencil_fill,
    title: "onboarding screen 2",
    description: "some description here...",
    textColor: Colors.black,
    // bgColor: Colors.lightBlueAccent,
    bgColor: Colors.white,
    iconColor: GlobalVariables.deepMediumPurple,
  ),
   OnboardingModel(
      icon: Icons.hdr_weak,
      title: "onboarding screen 3",
      description: "some description here...",
      // bgColor: Colors.lime,
      bgColor: GlobalVariables.deepMediumPurple,
      textColor: Colors.white),
];

class OnboardingScreen extends StatelessWidget {
  static const String routeName = "/onboarding-screen";
  const OnboardingScreen({super.key});

    void _finishOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kOnboardingComplete, true);
    Navigator.pushReplacementNamed(context, MainScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
   final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ConcentricPageView(
        onFinish: () => _finishOnboarding(context),
        colors: pages.map((p) => p.bgColor).toList(),
        radius: screenWidth * 0.1,
        curve: Curves.ease,
        nextButtonBuilder: (context) => Padding(
          padding: const EdgeInsets.only(left: 3), // visual center
          child: Icon(
            Icons.navigate_next,
            size: screenWidth * 0.08,
          ),
        ),
        duration: const Duration(milliseconds: 1500),
        opacityFactor: 2.0,
        scaleFactor: 0.2,
        verticalPosition: 0.7,
        direction: Axis.vertical,
        itemCount: pages.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (index) {
          final page = pages[index % pages.length];
          return SafeArea(
            child: _Page(page: page),
          );
        },
      ),
    );
  }
}

class _Page extends StatelessWidget {
  final OnboardingModel page;

  const _Page({required this.page});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    space(double p) => SizedBox(height: screenHeight * p / 100);
    return Column(
      children: [
        space(10),
        _Image(
          page: page,
          size: 190,
          iconSize: 170,
        ),
        space(8),
        _Text(
          page: page,
          isTitle: true,
          style: TextStyle(
            fontSize: screenHeight * 0.036,
          ),
        ),
        space(35),
        _Text(
          page: page,
          isTitle: false,
          style: TextStyle(
            fontSize: screenHeight * 0.026,
          ),
        ),
      ],
    );
  }
}

class _Text extends StatelessWidget {
  const _Text({
    required this.page,
    this.style,
    required this.isTitle,
  });

  final OnboardingModel page;
  final TextStyle? style;
  final bool isTitle;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      isTitle ? page.title ?? "" : page.description ?? '',
      style: TextStyle(
        color: page.textColor,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.0,
        fontSize: 18,
        height: 1.2,
      ).merge(style),
      textAlign: TextAlign.center,
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({
    required this.page,
    required this.size,
    required this.iconSize,
  });

  final OnboardingModel page;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Icon(
      page.icon,
      size: iconSize,
      color: page.iconColor,
    );
  }
}
