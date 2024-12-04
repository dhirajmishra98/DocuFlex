// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:docuflex/features/organize/widgets/rotate_pdf_bottomsheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/utils.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/utils.dart';
import '../scanner/pdf_options_screen.dart';
import 'widgets/merge_pdf_bottomsheet.dart';
import 'widgets/split_pdf_bottomsheet.dart';

class OrganizeSection extends StatefulWidget {
  const OrganizeSection({super.key});

  @override
  State<OrganizeSection> createState() => _OrganizeSectionState();
}

class _OrganizeSectionState extends State<OrganizeSection> {
  String? operatedPdfPath;

  Future<void> navigateToPdfOptionScreen(
      String pdfPath, String pageTitle) async {
    final output = await getTemporaryDirectory();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfOptionsScreen(
          pageTitle: pageTitle,
          pdfFilePath: output.path,
          fileNameController:
              TextEditingController(text: path.basename(pdfPath)),
          onSave: showSaveConfirmation,
          onChangeLocationAndSave: changeLocationAndSavePdfToDevice,
        ),
      ),
    );
  }

  Future<void> changeLocationAndSavePdfToDevice(String fileName) async {
    try {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        await Permission.manageExternalStorage.request();
      }
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (operatedPdfPath != null) {
        final pdfFile = File(operatedPdfPath!);

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
          operatedPdfPath = newFilePath;
        });

        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: "Document Saved",
          desc: "The document has been saved to: $operatedPdfPath",
          btnOkText: "Open",
          btnOkOnPress: () {
            OpenFile.open(operatedPdfPath);
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
    File(operatedPdfPath!).copySync(newFilePath);
    setState(() {
      operatedPdfPath = newFilePath;
    });

    // Display confirmation dialog
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: "Document Saved",
      desc: "The document has been saved to: $operatedPdfPath",
      btnOkText: "Open",
      btnOkOnPress: () {
        OpenFile.open(operatedPdfPath);
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
                  builder: (context) => MergePdfBottomSheet(
                    title: "Merge PDFs",
                    callback: (mergedPath) {
                      setState(() {
                        operatedPdfPath = mergedPath;
                      });
                      navigateToPdfOptionScreen(mergedPath, "Merged PDF");
                    },
                  ),
                ),
              ),
              CustomCard(
                tileText: "Split PDF",
                iconPath: "assets/icons/split.png",
                onTap: () => showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => SplitPdfBottomSheet(
                    title: "Split PDF",
                    onSplitComplete: (splitPath) {
                      setState(() {
                        operatedPdfPath = splitPath;
                      });
                      navigateToPdfOptionScreen(splitPath, "Splitted PDF");
                    },
                  ),
                ),
              ),
              CustomCard(
                tileText: "Rotate PDF",
                iconPath: "assets/icons/rotate.png",
                onTap: () => showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => RotatePdfBottomsheet(
                    title: "Rotate a PDF page",
                    onRotateComplete: (onRotateComplete) {
                      setState(() {
                        operatedPdfPath = onRotateComplete;
                      });
                      navigateToPdfOptionScreen(
                          onRotateComplete, "Rotated PDF");
                    },
                  ),
                ),
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
