import 'package:flutter/material.dart';

import '../../../widgets/custom_card.dart';
import '../../../widgets/utils.dart';

class ScannerSection extends StatelessWidget {
  const ScannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(headerText: "Scan to PDF"),
        SizedBox(
          height: 100,
          width: 100,
          child: CustomCard(
            tileText: "scanner",
            iconPath: "assets/icons/scanner.png",
          ),
        ),
      ],
    );
  }
}
