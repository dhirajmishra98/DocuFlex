import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';

import 'pdf_viewer_screen.dart';

class PdfOptionsScreen extends StatelessWidget {
  final String pdfFilePath;
  final TextEditingController fileNameController;
  final Function onSave;

  const PdfOptionsScreen({
    super.key,
    required this.pdfFilePath,
    required this.fileNameController,
    required this.onSave,
  });

//if user click on back give warning that all progress will be lost
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Hide keyboard and cursor
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text("Scanned Document"),
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () => onSave(),
                icon: const Icon(
                  Icons.save,
                ),
              ),
            ]),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: PDFView(
                  filePath: pdfFilePath,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: true,
                  pageSnap: true,
                  fitEachPage: true,
                  onViewCreated: (controller) async {
                    await controller.setPage(0); // Preview first page
                  },
                ),
              ),
              const Gap(10),
              TextField(
                controller: fileNameController,
                decoration: const InputDecoration(
                    hintText: "Enter file name", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => onSave(),
                    icon: const Icon(Icons.location_on_outlined),
                    label: const Text("change document location"),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Share.shareXFiles([XFile(pdfFilePath)],
                              text: 'Scanned PDF Document');
                        },
                        child: const Icon(Icons.share),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>
                                PDFViewerScreen(pdfFilePath: pdfFilePath),
                          ));
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text("View PDF"),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
