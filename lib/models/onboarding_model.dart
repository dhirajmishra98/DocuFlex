import 'package:flutter/material.dart';

class OnboardingModel {
  final String? title;
  final String? description;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;
  final Color iconColor;

  OnboardingModel({
    this.title,
    this.description,
    this.icon,
    this.iconColor = Colors.white,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
  });
}
