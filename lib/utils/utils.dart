import 'package:flutter/material.dart';

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
