import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

void showSnackbar(BuildContext context, String message, Color color) {
  final SnackBar snackbar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
    ),
    backgroundColor: color, // Change background color
    margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    dismissDirection: DismissDirection.horizontal,
    duration: const Duration(seconds: 5), // Set duration
    action: SnackBarAction(
      label: 'OK',
      textColor: Colors.black,
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

// Ensure filename has a ".pdf" extension
String getFileNameWithExtension(String name) {
  final fileName = name;
  return fileName.endsWith('.pdf') ? fileName : '$fileName.pdf';
}

bool validatePageCount(String value, int totalPageCount) {
  final int? count = int.tryParse(value);
  return count != null && count > 0 && count <= totalPageCount;
}

bool validateByteSize(String value) {
  final int? size = int.tryParse(value);
  return size != null && size > 0;
}

bool validatePageNumbers(String value, int totalPageCount) {
  final List<String> numbers = value.split(',');
  final Set<int> pageNumbers = {};

  for (var number in numbers) {
    final int? parsedNumber = int.tryParse(number.trim());
    if (parsedNumber == null ||
        parsedNumber <= 0 ||
        parsedNumber > totalPageCount ||
        !pageNumbers.add(parsedNumber)) {
      return false;
    }
  }
  return true;
}

Future<String> getCustomDocumentName(
    String filePath, String prefferedName) async {
  final output = await getTemporaryDirectory();
  final mergedFile = File(filePath);

  // Define the new file name
  final newFilePath = path.join(output.path, prefferedName);

  // Rename the file
  final renamedFile = await mergedFile.rename(newFilePath);

  // Update the mergedPdfPath to the renamed file
  return renamedFile.path;
}
