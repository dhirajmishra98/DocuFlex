
import 'package:flutter/material.dart';

import '../utils/global_variables.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.label,
    required this.iconData,
    required this.onPressed,
    this.isActiveButton = true,
  });

  String label;
  VoidCallback? onPressed;
  IconData iconData;
  bool isActiveButton;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(iconData),
      label: Text(label),
      
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: isActiveButton
            ? GlobalVariables.deepPurple.withOpacity(0.8)
            : GlobalVariables.deepPurple.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        
        padding: const EdgeInsets.symmetric(
            vertical: 12, horizontal: 20), // optional for spacing
      ),
    );
  }
}
