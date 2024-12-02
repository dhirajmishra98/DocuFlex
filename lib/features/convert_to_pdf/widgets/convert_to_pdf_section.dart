import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/utils.dart';

class ConvertToPdfSection extends StatefulWidget {
  const ConvertToPdfSection({super.key});

  @override
  State<ConvertToPdfSection> createState() => _ConvertToPdfSectionState();
}

class _ConvertToPdfSectionState extends State<ConvertToPdfSection> {
  String? _firstFormat;

  Future<void> _launchUrl() async {
    if (_firstFormat == null) return;

    // Construct the URL dynamically based on selected formats
    final Uri url = Uri.parse(
      "https://smallpdf.com/${_firstFormat!.toLowerCase()}-to-pdf",
    );

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void _showFormatOptions(
      BuildContext context, Function(String) onFormatSelected) {
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
                    tileText: "Word",
                    iconPath: "assets/icons/word.png",
                    onTap: () {
                      onFormatSelected("Word");
                      Navigator.pop(context);
                    }),
                CustomCard(
                    tileText: "Excel",
                    iconPath: "assets/icons/excel.png",
                    onTap: () {
                      onFormatSelected("Excel");
                      Navigator.pop(context);
                    }),
                CustomCard(
                    tileText: "PPT",
                    iconPath: "assets/icons/ppt.png",
                    onTap: () {
                      onFormatSelected("PPT");
                      Navigator.pop(context);
                    }),
                CustomCard(
                    tileText: "JPG",
                    iconPath: "assets/icons/jpg.png",
                    onTap: () {
                      onFormatSelected("JPG");
                      Navigator.pop(context);
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool get _isConvertButtonActive =>
      _firstFormat != null && _firstFormat != "PDF";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(headerText: "Convert To PDF"),
        SizedBox(
          height: 90, // Adjust the height to suit your design
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: CustomCard(
                        tileText: _firstFormat ?? "From",
                        iconPath: _firstFormat != null
                            ? "assets/icons/${_firstFormat!.toLowerCase()}.png"
                            : "assets/icons/word.png",
                        onTap: () => _showFormatOptions(context, (format) {
                          setState(() {
                            _firstFormat = format;
                          });
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: CustomCard(
                          tileText: "PDF",
                          iconPath: "assets/icons/pdf.png",
                          onTap: () {}),
                    ),
                  ],
                ),
              ),
              CustomButton(
                label: "Convert",
                iconData: Icons.loop,
                onPressed: _isConvertButtonActive ? _launchUrl : null,
                isActiveButton: _isConvertButtonActive,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
