import 'package:flutter/material.dart';

import '../utils/global_variables.dart';

class Slogan extends StatelessWidget {
  const Slogan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Transform, Share, and Secure - All in a Flex',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: GlobalVariables.deepPurple,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
