import 'package:flutter/material.dart';

import '../../../widgets/custom_card.dart';
import '../../../widgets/utils.dart';

class ConvertFromPdfSection extends StatelessWidget {
  const ConvertFromPdfSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(headerText: "Convert from PDF"),
        SizedBox(
          height: 200, // Adjust the height to suit your design
          child: GridView.count(
            crossAxisCount: 3, // Adjust the number of columns
            childAspectRatio: 1.2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              CustomCard(
                tileText: "PDF to Word",
                iconPath: "assets/icons/word.png",
              ),
              CustomCard(
                tileText: "PDF to Excel",
                iconPath: "assets/icons/excel.png",
              ),
              CustomCard(
                tileText: "PDF to PPT",
                iconPath: "assets/icons/ppt.png",
              ),
              CustomCard(
                tileText: "PDF to JPG",
                iconPath: "assets/icons/jpg.png",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
