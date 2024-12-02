import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/global_variables.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_button.dart';
import 'pdf_viewer_screen.dart';

class PdfOptionsScreen extends StatefulWidget {
  final String pdfFilePath;
  final TextEditingController fileNameController;
  final Function onSave;
  final Function onChangeLocationAndSave;
  final Function onResumeScanning;
  final List<String>? scannedImagesPaths;

  const PdfOptionsScreen({
    super.key,
    required this.pdfFilePath,
    required this.fileNameController,
    required this.onSave,
    required this.onChangeLocationAndSave,
    required this.onResumeScanning,
    required this.scannedImagesPaths,
  });

  @override
  State<PdfOptionsScreen> createState() => _PdfOptionsScreenState();
}

class _PdfOptionsScreenState extends State<PdfOptionsScreen> {
  late PDFViewController _pdfViewController;
  int _totalPages = 0;
  int _currentPage = 0;
  late String filePath;

  Future<void> _renameFileIfNeeded() async {
    final currentFile = File(filePath);
    final newFileName = widget.fileNameController.text;

    if (newFileName.isNotEmpty && newFileName != currentFile.path) {
      final newPath = '${currentFile.parent.path}/$newFileName.pdf';
      await currentFile.rename(newPath);

      // Update the pdfFilePath to the new path
      setState(() {
        filePath = newPath;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final pdfFile = File(
        "${widget.pdfFilePath}/${getFileNameWithExtension(widget.fileNameController.text)}");
    filePath = pdfFile.path;
  }

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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                widget.onResumeScanning();
                Navigator.pop(
                    context); // This will pop back to the ScannerSection
              },
            ),
            actions: [
              IconButton(
                onPressed: () => widget.onSave(widget.fileNameController.text),
                icon: const Icon(
                  Icons.save,
                ),
              ),
            ]),
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    PDFView(
                      filePath: filePath,
                      enableSwipe: true,
                      swipeHorizontal: true,
                      autoSpacing: true,
                      pageSnap: true,
                      fitEachPage: true,
                      onViewCreated: (controller) async {
                        await controller.setPage(0); // Preview first page
                        _pdfViewController = controller;
                      },
                      onRender: (pages) {
                        setState(() {
                          _totalPages = pages!;
                        });
                      },
                      onPageChanged: (page, total) {
                        setState(() {
                          _currentPage = page!;
                        });
                      },
                    ),
                    Positioned(
                      bottom: -10,
                      left: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: GlobalVariables.deepPurple.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                if (_currentPage > 0) {
                                  await _pdfViewController
                                      .setPage(_currentPage - 1);
                                }
                              },
                            ),
                            Text(
                              "${_currentPage + 1} / $_totalPages",
                              style: const TextStyle(color: Colors.white),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                if (_currentPage < _totalPages - 1) {
                                  await _pdfViewController
                                      .setPage(_currentPage + 1);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // const Gap(10),
              TextField(
                controller: widget.fileNameController,
                decoration: const InputDecoration(
                    hintText: "Enter file name", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomButton(
                    onPressed: ()=> widget.onChangeLocationAndSave(
                        widget.fileNameController.text),
                    iconData: Icons.location_on_outlined,
                    label: "change document location",
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await _renameFileIfNeeded();

                          Share.shareXFiles([XFile(filePath)]);
                        },
                        child: const Icon(Icons.share),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => PDFViewerScreen(
                              pdfFilePath: filePath,
                              fileName: widget.fileNameController.text,
                              onSave: widget.onSave,
                            ),
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
