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
  final Function(File file) onConvert;
  final List<String>? allowedExtensions;
  final String invalidFormatWarningMessage;

  const FileConversionBottomSheet({
    super.key,
    required this.title,
    required this.onConvert,
    this.allowedExtensions,
    required this.invalidFormatWarningMessage,
  });

  @override
  State<FileConversionBottomSheet> createState() =>
      _FileConversionBottomSheetState();
}

class _FileConversionBottomSheetState extends State<FileConversionBottomSheet> {
  File? selectedFile;
  bool isConverting = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: widget.allowedExtensions,
    );
    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final extension = filePath.split('.').last.toLowerCase();

      if (widget.allowedExtensions!.contains(extension)) {
        setState(() {
          selectedFile = File(filePath);
        });
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          title: "Invalid Document",
          desc: widget.invalidFormatWarningMessage,
          btnOkText: "OK",
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  Future<void> _convertFile() async {
    if (selectedFile == null) return;

    setState(() {
      isConverting = true;
    });

    // Simulate conversion delay
    // await Future.delayed(const Duration(seconds: 3));

    widget.onConvert(selectedFile!);

    setState(() {
      isConverting = false;
    });
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
              child: Center(
                child: selectedFile == null
                    ? Text(
                        "No file uploaded yet",
                        style: TextStyle(color: Colors.grey[600]),
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.4,
                            child: PDFView(
                              filePath: selectedFile?.path,
                              enableSwipe: false,
                              onViewCreated: (controller) async {
                                await controller
                                    .setPage(0); // Preview first page
                              },
                            ),
                          ),
                          const Gap(5),
                          AutoSizeText(
                            "Uploaded: ${selectedFile!.path.split('/').last}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomButton(
                  label: "Upload File",
                  iconData: Icons.upload,
                  onPressed: () => _pickFile(),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  iconData: Icons.loop,
                  label: "Convert",
                  isActiveButton: selectedFile == null ? false : true,
                  onPressed: () => selectedFile == null ? null : _convertFile(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
