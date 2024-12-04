// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:docuflex/widgets/custom_button.dart';
import 'package:docuflex/widgets/uploading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gap/gap.dart';
import 'package:pdf_manipulator/pdf_manipulator.dart';

import '../../../utils/utils.dart';

class MergePdfBottomSheet extends StatefulWidget {
  final String title;
  final Function(String) callback;

  const MergePdfBottomSheet({
    super.key,
    required this.title,
    required this.callback,
  });

  @override
  State<MergePdfBottomSheet> createState() => _MergePdfBottomSheetState();
}

class _MergePdfBottomSheetState extends State<MergePdfBottomSheet> {
  List<File> selectedFiles = [];
  bool _isUploading = false;

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
      allowMultiple: true,
      withData: true,
    );

    setState(() {
      _isUploading = true;
    });

    if (result != null) {
      final invalidFiles = <String>[];

      for (var file in result.files) {
        if (file.path != null) {
          final filePath = file.path!;
          final extension = filePath.split('.').last.toLowerCase();

          if (extension == "pdf") {
            selectedFiles.add(File(filePath));
            selectedFiles.sort((a, b) => a.path
                .split('/')
                .last
                .toLowerCase()
                .compareTo(b.path.split('/').last.toLowerCase()));
          } else {
            invalidFiles.add(filePath.split('/').last);
          }
        }
      }

      if (invalidFiles.isNotEmpty) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          title: "Invalid Documents",
          desc:
              "The following files are not supported:\n${invalidFiles.join('\n')}",
          btnOkText: "OK",
          btnOkOnPress: () {},
        ).show();
      }

      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<String?> _mergePdfs(List<String> pdfsPaths) async {
    String? mergedPdfPath = await PdfManipulator().mergePDFs(
      params: PDFMergerParams(pdfsPaths: pdfsPaths),
    );

    if (mergedPdfPath != null) {
      return await getCustomDocumentName(mergedPdfPath, "merged.pdf");
    }
    return null;
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
            Expanded(
              child: selectedFiles.isEmpty
                  ? Center(
                      child: Text(
                        "No files uploaded yet",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  : _isUploading
                      ? const UploadingIndicator()
                      : ReorderableListView(
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              // Adjust the newIndex when dragging an item downward
                              if (newIndex > oldIndex) {
                                newIndex -= 1;
                              }

                              final file = selectedFiles.removeAt(oldIndex);
                              selectedFiles.insert(newIndex, file);
                            });
                          },
                          children: [
                            for (int index = 0;
                                index < selectedFiles.length;
                                index++)
                              Card(
                                key: ValueKey(selectedFiles[index].path),
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
                                      filePath: selectedFiles[index].path,
                                      enableSwipe: false,
                                      onViewCreated: (controller) async {
                                        await controller
                                            .setPage(0); // Thumbnail
                                      },
                                    ),
                                  ),
                                  title: AutoSizeText(
                                    selectedFiles[index].path.split('/').last,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                        Icons.remove_circle_outlined),
                                    color: Colors.deepPurple.shade600,
                                    onPressed: () {
                                      setState(() {
                                        selectedFiles.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              )
                          ],
                        ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomButton(
                  label: "Upload Files",
                  iconData: Icons.upload,
                  onPressed: _pickFiles,
                ),
                const SizedBox(height: 10),
                CustomButton(
                  iconData: Icons.merge,
                  label: "Convert",
                  isActiveButton: selectedFiles.isEmpty ? false : true,
                  onPressed: selectedFiles.isEmpty
                      ? null
                      : () async {
                          List<String> paths = [];
                          for (var file in selectedFiles) {
                            paths.add(file.path);
                          }
                          String? mergedFilePath = await _mergePdfs(paths);
                          widget.callback(mergedFilePath!);
                        },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
