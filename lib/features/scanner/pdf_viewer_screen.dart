import 'package:flutter/material.dart';

class PDFViewerScreen extends StatelessWidget {
  final String pdfFilePath;

  const PDFViewerScreen({super.key, required this.pdfFilePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View PDF")),
      body: Center(
        child: Text("PDF Viewer here - displaying: $pdfFilePath"),
      ),
    );
  }
}