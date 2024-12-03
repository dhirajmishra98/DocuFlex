import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_manipulator/pdf_manipulator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:docuflex/widgets/file_conversion_bottomsheet.dart';

import '../../../utils/utils.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/utils.dart';
import '../../scanner/pdf_options_screen.dart';

class OrganizeSection extends StatefulWidget {
  const OrganizeSection({super.key});

  @override
  State<OrganizeSection> createState() => _OrganizeSectionState();
}

class _OrganizeSectionState extends State<OrganizeSection> {
  String? mergedPdfPath;

  Future<void> _mergePdfs(List<String> pdfsPaths) async {
    mergedPdfPath = await PdfManipulator().mergePDFs(
      params: PDFMergerParams(pdfsPaths: pdfsPaths),
    );

    if (mergedPdfPath != null) {
      final output = await getTemporaryDirectory();
      final mergedFile = File(mergedPdfPath!);

      // Define the new file name
      final newFilePath = path.join(output.path, "merged.pdf");

      // Rename the file
      final renamedFile = await mergedFile.rename(newFilePath);

      // Update the mergedPdfPath to the renamed file
      mergedPdfPath = renamedFile.path;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfOptionsScreen(
            pageTitle: "Merged Document",
            pdfFilePath: output.path,
            fileNameController:
                TextEditingController(text: path.basename(mergedPdfPath!)),
            onSave: showSaveConfirmation,
            onChangeLocationAndSave: changeLocationAndSavePdfToDevice,
          ),
        ),
      );
    }
  }

  Future<void> changeLocationAndSavePdfToDevice(String fileName) async {
    try {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        await Permission.manageExternalStorage.request();
      }
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (mergedPdfPath != null) {
        final pdfFile = File(mergedPdfPath!);

        String newFilePath = "";

        if (selectedDirectory == null) {
          Directory appSpecificDir = Directory('/storage/emulated/0/DocuFlex');
          if (!await appSpecificDir.exists()) {
            await appSpecificDir.create(recursive: true);
          }
          newFilePath =
              '${appSpecificDir.path}/${getFileNameWithExtension(fileName)}';
        } else {
          newFilePath =
              '$selectedDirectory/${getFileNameWithExtension(fileName)}';
        }

        await pdfFile.copy(newFilePath);
        setState(() {
          mergedPdfPath = newFilePath;
        });

        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: "Document Saved",
          desc: "The document has been saved to: $mergedPdfPath",
          btnOkText: "Open",
          btnOkOnPress: () {
            OpenFile.open(mergedPdfPath);
          },
        ).show();
      } else {
        throw Exception("Directory not writable");
      }
    } catch (e) {
      debugPrint("Error: $e");
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Error",
        desc: "Failed to save the document.\n $e",
        btnOkText: "Ok",
        btnOkOnPress: () {},
      ).show();
    }
  }

  void showSaveConfirmation(String fileName) async {
    final selectedDirectory = await getApplicationDocumentsDirectory();
    final newFilePath =
        '${selectedDirectory.path}/${getFileNameWithExtension(fileName)}';

    // Copy to the final destination in app documents directory
    File(mergedPdfPath!).copySync(newFilePath);
    setState(() {
      mergedPdfPath = newFilePath;
    });

    // Display confirmation dialog
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: "Document Saved",
      desc: "The document has been saved to: $mergedPdfPath",
      btnOkText: "Open",
      btnOkOnPress: () {
        OpenFile.open(mergedPdfPath);
      },
    ).show();
  }

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
                iconPath: "assets/icons/merge.png",
                onTap: () => showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => FileConversionBottomSheet(
                    title: "Merge Pdfs",
                    allowedExtensions: const ['pdf'],
                    invalidFormatWarningMessage: "Please select only PDFs",
                    buttonLabel: "Merge",
                    buttonIcon: Icons.merge,
                    callback: (filePaths) => _mergePdfs(filePaths),
                  ),
                ),
              ),
              CustomCard(
                tileText: "Split PDF",
                iconPath: "assets/icons/split.png",
                onTap: () {},
              ),
              CustomCard(
                tileText: "Rotate PDF",
                iconPath: "assets/icons/rotate.png",
                onTap: () {},
              ),
              CustomCard(
                tileText: "Delete PDF Pages",
                iconPath: "assets/icons/delete.png",
                onTap: () {},
              ),
              CustomCard(
                tileText: "Extract PDF Pages",
                iconPath: "assets/icons/extract.png",
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
