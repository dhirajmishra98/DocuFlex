// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/pdf_utils.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/utils.dart';
import '../pdf_options_screen.dart';

class ScannerSection extends StatefulWidget {
  const ScannerSection({super.key});

  @override
  State<ScannerSection> createState() => _ScannerSectionState();
}

class _ScannerSectionState extends State<ScannerSection> {
  List<File> scannedImages = [];
  List<String>? scannedImagesPaths = [];
  String? pdfFilePath;
  TextEditingController fileNameController =
      TextEditingController(text: "scanned_document");

  Future<void> scanDocument() async {
    List<String>? paths =
        await CunningDocumentScanner.getPictures(isGalleryImportAllowed: true);

    if (paths != null && paths.isNotEmpty) {
      setState(() {
        scannedImages = paths.map((path) => File(path)).toList();
        scannedImagesPaths = paths;
      });
      // Create a pdf and proceed to save
      await createAndSavePdf();
    }
  }

  Future<void> createAndSavePdf() async {
    final pdf = await generatePdf(scannedImages);

    final output = await getTemporaryDirectory();
    final pdfFile = File(
        "${output.path}/${getFileNameWithExtension(fileNameController.text)}");
    await pdfFile.writeAsBytes(await pdf.save());

    setState(() {
      pdfFilePath = pdfFile.path;
    });

    // Navigate to options screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfOptionsScreen(
          pageTitle: "Scanned Document",
          pdfFilePath: output.path,
          scannedImagesPaths: scannedImagesPaths,
          fileNameController: fileNameController,
          onSave: showSaveConfirmation,
          onChangeLocationAndSave: changeLocationAndSavePdfToDevice,
          onResumeScanning: resumeScanning, // Pass resume function
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

      if (pdfFilePath != null) {
        final pdfFile = File(pdfFilePath!);

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
          pdfFilePath = newFilePath;
        });

        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: "Document Saved",
          desc: "The document has been saved to: $pdfFilePath",
          btnOkText: "Open",
          btnOkOnPress: () {
            OpenFile.open(pdfFilePath);
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
    File(pdfFilePath!).copySync(newFilePath);
    setState(() {
      pdfFilePath = newFilePath;
    });

    // Display confirmation dialog
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: "Document Saved",
      desc: "The document has been saved to: $pdfFilePath",
      btnOkText: "Open",
      btnOkOnPress: () {
        OpenFile.open(pdfFilePath);
      },
    ).show();
  }

  // Function to resume scanning
  Future<void> resumeScanning() async {
    // Allow the user to continue scanning if they have previously scanned
    List<String>? paths = await CunningDocumentScanner.getPictures(
            isGalleryImportAllowed: true) ??
        [];

    if (paths.isNotEmpty) {
      setState(() {
        scannedImages.addAll(paths.map((path) => File(path)).toList());
      });
      await createAndSavePdf();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(headerText: "Scanner"),
        SizedBox(
          height: 100,
          width: 100,
          child: CustomCard(
            tileText: "Scan Document",
            iconPath: "assets/icons/scanner.png",
            onTap: scanDocument,
          ),
        ),
      ],
    );
  }
}
