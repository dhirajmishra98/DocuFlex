import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String headerText;
  const SectionHeader({
    super.key,
    required this.headerText,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      headerText,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade700,
      ),
    );
  }
}
