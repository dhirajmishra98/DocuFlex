import 'package:flutter/material.dart';

import '../../../widgets/custom_card.dart';
import '../../../widgets/utils.dart';

class SecureDocsSection extends StatelessWidget {
  const SecureDocsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(headerText: "Secure"),
        SizedBox(
          height: 200, // Adjust the height to suit your design
          child: GridView.count(
            crossAxisCount: 3, // Adjust the number of columns
            childAspectRatio: 1.2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              CustomCard(
                tileText: "Lock PDF",
                iconPath: "assets/icons/lock.png", onTap: () {  },
              ),
              CustomCard(
                tileText: "Unlock PDF",
                iconPath: "assets/icons/unlock.png", onTap: () {  },
              ),
              CustomCard(
                tileText: "Flatten PDF",
                iconPath: "assets/icons/flatten.png", onTap: () {  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
