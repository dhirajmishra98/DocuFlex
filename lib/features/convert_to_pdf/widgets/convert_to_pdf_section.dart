import 'package:flutter/material.dart';

import '../../../widgets/custom_card.dart';
import '../../../widgets/utils.dart';

class ConvertToPdfSection extends StatelessWidget {
  const ConvertToPdfSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(headerText: "Convert to PDF"),
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
                tileText: "Word to PDF",
                iconPath: "assets/icons/word.png", onTap: () {  },
              ),
              CustomCard(
                tileText: "Excel to PDF",
                iconPath: "assets/icons/excel.png", onTap: () {  },
              ),
              CustomCard(
                tileText: "PPT to PDF",
                iconPath: "assets/icons/ppt.png", onTap: () {  },
              ),
              CustomCard(
                tileText: "JPG to PDF",
                iconPath: "assets/icons/jpg.png", onTap: () {  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
