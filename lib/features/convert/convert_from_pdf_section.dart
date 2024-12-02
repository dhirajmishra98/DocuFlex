// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:docuflex/widgets/internet_checker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/utils.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_card.dart';

class ConvertFromPdfSection extends StatefulWidget {
  const ConvertFromPdfSection({super.key});

  @override
  State<ConvertFromPdfSection> createState() => _ConvertFromPdfSectionState();
}

class _ConvertFromPdfSectionState extends State<ConvertFromPdfSection> {
  String? _secondFormat;

  Future<void> _launchUrl() async {
    if (_secondFormat == null) return;
    if (!await InternetChecker.isInternetAvailable()) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "No Internet",
        desc: "Please check internet connection",
        btnOkText: "Ok",
        btnOkOnPress: () {},
      ).show();
      return;
    }

    // Construct the URL dynamically based on selected formats
    final Uri url = Uri.parse(
      "https://smallpdf.com/pdf-to-${_secondFormat!.toLowerCase()}",
    );

    if (!await launchUrl(url)) {
      showSnackbar(context, 'Could not launch $url', Colors.red);
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
      _secondFormat != null && _secondFormat != "PDF";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                          tileText: "PDF",
                          iconPath: "assets/icons/pdf.png",
                          onTap: () {}),
                    ),
                  ],
                ),
              ),
              const Text(
                "→",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: CustomCard(
                        tileText: _secondFormat ?? "To",
                        iconPath: _secondFormat != null
                            ? "assets/icons/${_secondFormat!.toLowerCase()}.png"
                            : "assets/icons/format.png",
                        onTap: () => _showFormatOptions(context, (format) {
                          setState(() {
                            _secondFormat = format;
                          });
                        }),
                      ),
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
