import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

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
  String? pdfFilePath;
  TextEditingController fileNameController =
      TextEditingController(text: "scanned_document.pdf");

  Future<void> scanDocument() async {
    List<String>? paths = await CunningDocumentScanner.getPictures();

    if (paths != null && paths.isNotEmpty) {
      setState(() {
        scannedImages = paths.map((path) => File(path)).toList();
      });
      // Create a temporary PDF for preview
      await createTemporaryPdf();
      // Navigate to options screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfOptionsScreen(
            pdfFilePath: pdfFilePath!,
            fileNameController: fileNameController,
            onSave: savePdfToDevice,
          ),
        ),
      );
    }
  }

  Future<void> createTemporaryPdf() async {
    final pdf = pw.Document();
    for (var image in scannedImages) {
      final imageFile = pw.MemoryImage(image.readAsBytesSync());
      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Image(imageFile);
      }));
    }

    final output = await getTemporaryDirectory();
    final pdfFile = File("${output.path}/${fileNameController.text}.pdf");
    await pdfFile.writeAsBytes(await pdf.save());

    setState(() {
      pdfFilePath = pdfFile.path;
    });
  }

  Future<void> savePdfToDevice() async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      title: "Save Document",
      desc: "Document is saved at $pdfFilePath",
      btnOkText: "Save",
      btnCancelText: "Cancel",
      btnOkOnPress: () async {
        String? selectedDirectory =
            await FilePicker.platform.getDirectoryPath();
        if (selectedDirectory != null && pdfFilePath != null) {
          File pdfFile = File(pdfFilePath!);
          final newFilePath =
              '$selectedDirectory/${fileNameController.text}.pdf';
          await pdfFile.copy(newFilePath);
          setState(() {
            pdfFilePath = newFilePath;
          });
          showSaveConfirmation(newFilePath);
        }
      },
      btnCancelOnPress: () {},
    ).show();
  }

  void showSaveConfirmation(String path) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: "Document Saved",
      desc: "The document has been saved to:\n$path",
      btnOkText: "Open",
      btnOkOnPress: () => OpenFile.open(path),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(headerText: "Scan to PDF"),
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
