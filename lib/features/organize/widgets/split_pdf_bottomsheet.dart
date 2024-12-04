// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../../utils/pdf_utils.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/uploading_indicator.dart';
import '../../../widgets/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gap/gap.dart';
import 'package:pdf_manipulator/pdf_manipulator.dart';

import '../../../utils/utils.dart';

class SplitPdfBottomSheet extends StatefulWidget {
  final String title;
  final Function(String) onSplitComplete;

  const SplitPdfBottomSheet({
    super.key,
    required this.title,
    required this.onSplitComplete,
  });

  @override
  State<SplitPdfBottomSheet> createState() => _SplitPdfBottomSheetState();
}

class _SplitPdfBottomSheetState extends State<SplitPdfBottomSheet> {
  final TextEditingController pageCountController = TextEditingController();
  final TextEditingController byteSizeController = TextEditingController();
  final TextEditingController pageNumbersController = TextEditingController();

  bool isPageCountValid = true;
  bool isByteSizeValid = true;
  bool arePageNumbersValid = true;
  bool isUploading = false;

  int? totalPageCount;
  int? totalPdfSize;
  String selectedMethod = "Page Count"; // Default split method
  String? selectedFilePath;
  List<String>? splitPdfPaths;

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
      allowMultiple: false,
      withData: true,
    );

    setState(() {
      isUploading = true;
    });

    selectedFilePath = result?.files.first.path;
    totalPageCount = await getPdfPageCount(selectedFilePath!);
    totalPdfSize = File(selectedFilePath!).lengthSync();

    setState(() {
      isUploading = false;
    });
  }

  Future<void> _splitPdf() async {
    try {
      if (selectedMethod == "Page Count") {
        final pageCount = int.tryParse(pageCountController.text) ?? 1;
        splitPdfPaths = await PdfManipulator().splitPDF(
          params: PDFSplitterParams(
              pdfPath: selectedFilePath!, pageCount: pageCount),
        );
        debugPrint("Dhraj");
        debugPrint(splitPdfPaths.toString());
      } else if (selectedMethod == "Size") {
        final byteSize =
            int.tryParse(byteSizeController.text) ?? 1024 * 1024; // Default 1MB
        splitPdfPaths = await PdfManipulator().splitPDF(
          params:
              PDFSplitterParams(pdfPath: selectedFilePath!, byteSize: byteSize),
        );
      } else if (selectedMethod == "Page Numbers") {
        final pageNumbers = pageNumbersController.text
            .split(',')
            .map((e) => int.tryParse(e.trim()))
            .whereType<int>()
            .toList();
        splitPdfPaths = await PdfManipulator().splitPDF(
          params: PDFSplitterParams(
              pdfPath: selectedFilePath!, pageNumbers: pageNumbers),
        );
      }

      if (splitPdfPaths != null) {
        for (int i = 0; i < splitPdfPaths!.length; i++) {
          splitPdfPaths![i] = await getCustomDocumentName(
              splitPdfPaths![i], "split_${i + 1}.pdf");
        }

        setState(() {});
      }
    } catch (e) {
      debugPrint("Error during splitting: $e");
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Error",
        desc: "Failed to split the PDF.\n$e",
        btnOkText: "Ok",
        btnOkOnPress: () {},
      ).show();
    } finally {}
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
              DropdownButton<String>(
                value: selectedMethod,
                isExpanded: true,
                icon:
                    const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                iconSize: 24,
                dropdownColor: Colors.deepPurple.shade50,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.deepPurple,
                ),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurple,
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Page Count",
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Split by Page Count"),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Size",
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Split by Size"),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Page Numbers",
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Split by Page Numbers"),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedMethod = value!;
                  });
                },
              ),
              const Gap(10),
              if (selectedMethod == "Page Count")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: pageCountController,
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
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              if (selectedMethod == "Size")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: byteSizeController,
                      decoration: InputDecoration(
                        labelText: "size in bytes (e.g., 1024 for 1kB)",
                        border: const OutlineInputBorder(),
                        errorText: isByteSizeValid ? null : "",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          isByteSizeValid = validateByteSize(value);
                        });
                      },
                    ),
                    if (!isByteSizeValid)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "Ensure the page size is a valid number and less than $totalPdfSize.",
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              if (selectedMethod == "Page Numbers")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: pageNumbersController,
                      decoration: InputDecoration(
                        labelText: "Enter page numbers (e.g., 1,3,5)",
                        border: const OutlineInputBorder(),
                        errorText: arePageNumbersValid ? null : "",
                      ),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          arePageNumbersValid =
                              validatePageNumbers(value, totalPageCount!);
                        });
                      },
                    ),
                    if (!arePageNumbersValid)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "Ensure numbers are comma-separated, within range 1 to $totalPageCount, and not duplicated.",
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
            ],
            const Gap(20),
            splitPdfPaths == null
                ? Expanded(
                    child: selectedFilePath == null
                        ? Center(
                            child: Text(
                              "No file uploaded yet",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          )
                        : isUploading
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
                                  icon:
                                      const Icon(Icons.remove_circle_outlined),
                                  color: Colors.deepPurple.shade600,
                                  onPressed: () {
                                    setState(() {
                                      selectedFilePath = null;
                                    });
                                  },
                                ),
                              ),
                  )
                : selectedFilePath == null
                    ? Center(
                        child: Text(
                          "No file uploaded yet",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
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
            if (splitPdfPaths != null) ...[
              const Gap(20),
              const SectionHeader(headerText: "Splitted PDFs"),
              Expanded(
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      // Adjust the newIndex when dragging an item downward
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }

                      final file = splitPdfPaths!.removeAt(oldIndex);
                      splitPdfPaths!.insert(newIndex, file);
                    });
                  },
                  children: [
                    for (int index = 0; index < splitPdfPaths!.length; index++)
                      Card(
                        key: ValueKey(splitPdfPaths![index]),
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: ListTile(
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
                              filePath: splitPdfPaths![index],
                              enableSwipe: false,
                              onViewCreated: (controller) async {
                                await controller.setPage(0); // Thumbnail
                              },
                            ),
                          ),
                          title: AutoSizeText(
                            splitPdfPaths![index].split('/').last,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_red_eye),
                            color: Colors.deepPurple.shade600,
                            onPressed: () {
                              widget.onSplitComplete(splitPdfPaths![index]);
                            },
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
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
                  iconData: Icons.cut,
                  label: "Split PDF",
                  isActiveButton: selectedFilePath != null &&
                      (pageCountController.text.isNotEmpty ||
                          byteSizeController.text.isNotEmpty ||
                          pageNumbersController.text.isNotEmpty),
                  onPressed: selectedFilePath != null &&
                          (pageCountController.text.isEmpty &&
                              byteSizeController.text.isEmpty &&
                              pageNumbersController.text.isEmpty)
                      ? null
                      : _splitPdf,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
