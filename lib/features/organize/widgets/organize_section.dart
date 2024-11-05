import 'package:flutter/material.dart';

import '../../../widgets/custom_card.dart';
import '../../../widgets/utils.dart';

class OrganizeSection extends StatelessWidget {
  const OrganizeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(headerText: "Organize"),
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
                tileText: "Merge PDF",
                iconPath: "assets/icons/merge.png", onTap: () {  },
              ),
              CustomCard(
                tileText: "Split PDF",
                iconPath: "assets/icons/split.png", onTap: () {  },
              ),
              CustomCard(
                tileText: "Rotate PDF",
                iconPath: "assets/icons/rotate.png", onTap: () {  },
              ),
              CustomCard(
                tileText: "Delete PDF Pages",
                iconPath: "assets/icons/delete.png", onTap: () {  },
              ),
              CustomCard(
                tileText: "Extract PDF Pages",
                iconPath: "assets/icons/extract.png", onTap: () {  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
