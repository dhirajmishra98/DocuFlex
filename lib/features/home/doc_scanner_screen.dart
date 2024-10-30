import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class DocScannerScreen extends StatefulWidget {
  static const String routeName = "/doc-scanner-screen";
  const DocScannerScreen({super.key});

  @override
  State<DocScannerScreen> createState() => _DocScannerScreenState();
}

class _DocScannerScreenState extends State<DocScannerScreen> {
  List<File> scannedImages = [];
  String? pdfFilePath;

  Future<void> scanDocument() async {
    List<String>? paths = await CunningDocumentScanner.getPictures();

    if (paths != null && paths.isNotEmpty) {
      setState(() {
        scannedImages = paths.map((path) => File(path)).toList();
      });
      createPdf();
    }
  }

  Future<void> createPdf() async {
    final pdf = pw.Document();
    for (var image in scannedImages) {
      final imageFile = pw.MemoryImage(image.readAsBytesSync());
      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(imageFile),
        );
      }));
    }

    final output = await getApplicationDocumentsDirectory();
    final pdfFile = File("${output.path}/scanned_document.pdf");
    await pdfFile.writeAsBytes(await pdf.save());
    setState(() {
      pdfFilePath = pdfFile.path;
    });
  }

  void sharePdf() {
    if (pdfFilePath != null) {
      Share.share(pdfFilePath!, subject: 'Here is the scanned document!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: scanDocument,
            icon: const Icon(Icons.camera_alt),
            label: const Text("Scan Document"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: pdfFilePath != null ? sharePdf : null,
            icon: const Icon(Icons.share),
            label: const Text("Share PDF"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
          const SizedBox(height: 20),
          scannedImages.isNotEmpty
              ? Text("${scannedImages.length} pages scanned.")
              : const Text("No documents scanned yet."),
        ],
      ),
    );
  }
}
