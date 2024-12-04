// ignore_for_file: use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:docuflex/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gap/gap.dart';
import 'package:pdf_manipulator/pdf_manipulator.dart';

import '../../../utils/pdf_utils.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/uploading_indicator.dart';

class RotatePdfBottomsheet extends StatefulWidget {
  const RotatePdfBottomsheet(
      {super.key, required this.title, required this.onRotateComplete});
  final String title;
  final Function(String) onRotateComplete;

  @override
  State<RotatePdfBottomsheet> createState() => _RotatePdfBottomsheetState();
}

class _RotatePdfBottomsheetState extends State<RotatePdfBottomsheet> {
  final TextEditingController _pageCountController = TextEditingController();
  final TextEditingController _angleController = TextEditingController();
  String? selectedFilePath;
  int? totalPageCount;
  bool _isUploading = false;
  bool isPageCountValid = true;

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
      allowMultiple: false,
      withData: true,
    );

    setState(() {
      _isUploading = true;
    });

    selectedFilePath = result?.files.first.path;
    totalPageCount = await getPdfPageCount(selectedFilePath!);

    setState(() {
      _isUploading = false;
    });
  }

  Future<void> _rotatePages() async {
    final pageNumber = int.tryParse(_pageCountController.text);
    final rotationAngle = int.tryParse(_angleController.text);

    try {
      String? rotatedPagesPdfPath = await PdfManipulator().pdfPageRotator(
        params: PDFPageRotatorParams(
          pdfPath: selectedFilePath!,
          pagesRotationInfo: [
            //can pass more PageRotationInfo for multiple pages rotation
            PageRotationInfo(
              pageNumber: pageNumber!,
              rotationAngle: rotationAngle!,
            ),
          ],
        ),
      );

      if (rotatedPagesPdfPath != null) {
        rotatedPagesPdfPath =
            await getCustomDocumentName(rotatedPagesPdfPath, "rotated.pdf");
        widget.onRotateComplete(rotatedPagesPdfPath);
      } else {
        showSnackbar(context, 'Failed to rotate pages.', Colors.red);
      }
    } catch (e) {
      showSnackbar(context, "Error $e", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(10),
            if (selectedFilePath != null) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _pageCountController,
                    decoration: InputDecoration(
                      labelText: "Enter a number (e.g., 5)",
                      border: const OutlineInputBorder(),
                      errorText: isPageCountValid ? null : "",
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        isPageCountValid =
                            validatePageCount(value, totalPageCount!);
                      });
                    },
                  ),
                  if (!isPageCountValid)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "Ensure the page count is a valid number and less than $totalPageCount.",
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _angleController,
                decoration: const InputDecoration(
                  labelText: 'Rotation Angle (e.g., 90, 180, 270)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
            const Gap(20),
            Expanded(
              child: selectedFilePath == null
                  ? Center(
                      child: Text(
                        "No file uploaded yet",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  : _isUploading
                      ? const UploadingIndicator()
                      : ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          titleAlignment: ListTileTitleAlignment.center,
                          dense: false,
                          tileColor: Colors.deepPurple.shade100,
                          contentPadding: EdgeInsets.zero,
                          leading: SizedBox(
                            width: 80,
                            height: 80,
                            child: PDFView(
                              filePath: selectedFilePath,
                              enableSwipe: false,
                              onViewCreated: (controller) async {
                                await controller.setPage(0); // Thumbnail
                              },
                            ),
                          ),
                          title: AutoSizeText(
                            selectedFilePath!.split('/').last,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle_outlined),
                            color: Colors.deepPurple.shade600,
                            onPressed: () {
                              setState(() {
                                selectedFilePath = null;
                              });
                            },
                          ),
                        ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomButton(
                  label: "Upload File",
                  iconData: Icons.upload,
                  onPressed: _pickFiles,
                ),
                const SizedBox(height: 10),
                CustomButton(
                  iconData: Icons.rotate_90_degrees_ccw,
                  label: "Rotate PDF",
                  isActiveButton: selectedFilePath != null &&
                      (_pageCountController.text.isNotEmpty &&
                          _angleController.text.isNotEmpty),
                  onPressed: selectedFilePath != null &&
                          (_pageCountController.text.isNotEmpty &&
                              _angleController.text.isNotEmpty)
                      ? _rotatePages
                      : null,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
