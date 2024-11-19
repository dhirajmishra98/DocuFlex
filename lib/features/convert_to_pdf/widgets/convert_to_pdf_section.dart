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

/*
//Another UI using bottomsheet
import 'package:flutter/material.dart';

import '../../../widgets/custom_card.dart';
import '../../../widgets/utils.dart';

class ConvertToPdfSection extends StatelessWidget {
  const ConvertToPdfSection({super.key});

  void _showFormatOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            const Text(
              "Choose Format to Convert",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0,
              children: [
                CustomCard(
                    tileText: "Word to PDF",
                    iconPath: "assets/icons/word.png",
                    onTap: () {}),
                CustomCard(
                    tileText: "Excel to PDF",
                    iconPath: "assets/icons/excel.png",
                    onTap: () {}),
                CustomCard(
                    tileText: "PPT to PDF",
                    iconPath: "assets/icons/ppt.png",
                    onTap: () {}),
                CustomCard(
                    tileText: "JPG to PDF",
                    iconPath: "assets/icons/jpg.png",
                    onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(headerText: "Convert to PDF"),
        SizedBox(
            height: 135, // Adjust the height to suit your design
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomCard(
                          tileText: "Choose Format",
                          iconPath: "assets/icons/word.png",
                          onTap: () => _showFormatOptions(context),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // Upload document functionality here
                        },
                        icon: const Icon(Icons.upload),
                        label: const Text("Upload"),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward, size: 40, color: Colors.teal),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomCard(
                          tileText: "PDF",
                          iconPath: "assets/icons/pdf.png",
                          onTap: () {}, // No need to change PDF option
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // Convert and Download functionality here
                        },
                        icon: const Icon(Icons.download),
                        label: const Text("Convert"),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
*/
