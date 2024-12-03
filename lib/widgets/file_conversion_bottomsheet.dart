// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:docuflex/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gap/gap.dart';

class FileConversionBottomSheet extends StatefulWidget {
  final String title;
  final List<String>? allowedExtensions;
  final String invalidFormatWarningMessage;
  final String buttonLabel;
  final IconData buttonIcon;
  final Function(List<String> filePaths) callback;

  const FileConversionBottomSheet({
    super.key,
    required this.title,
    this.allowedExtensions,
    required this.invalidFormatWarningMessage,
    this.buttonLabel = "Convert",
    this.buttonIcon = Icons.loop,
    required this.callback,
  });

  @override
  State<FileConversionBottomSheet> createState() =>
      _FileConversionBottomSheetState();
}

class _FileConversionBottomSheetState extends State<FileConversionBottomSheet> {
  List<File> selectedFiles = [];

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: widget.allowedExtensions,
      allowMultiple: true,
      withData: true,
    );

    if (result != null) {
      final invalidFiles = <String>[];

      for (var file in result.files) {
        if (file.path != null) {
          final filePath = file.path!;
          final extension = filePath.split('.').last.toLowerCase();

          if (widget.allowedExtensions!.contains(extension)) {
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

      setState(() {});
      debugPrint(selectedFiles.length.toString());
    }
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
                                    await controller.setPage(0); // Thumbnail
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
                                icon: const Icon(Icons.remove_circle_outlined),
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
                  iconData: widget.buttonIcon,
                  label: widget.buttonLabel,
                  isActiveButton: selectedFiles.isEmpty ? false : true,
                  onPressed: selectedFiles.isEmpty
                      ? null
                      : () {
                          List<String> paths = [];
                          for (var file in selectedFiles) {
                            paths.add(file.path);
                          }
                          widget.callback(paths);
                          debugPrint("Dhiraj ${selectedFiles.length}");
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
