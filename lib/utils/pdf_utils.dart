import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart' as pdf;

Future<pw.Document> generatePdf(List<File> scannedImages) async {
  final pdf = pw.Document();

  // Define standard page size and margin
  const pageSize = PdfPageFormat.a4;
  const margin = 5.0; // Margin for all pages

  for (var imageFile in scannedImages) {
    // Optimize the image using the `image` package
    final originalImage = img.decodeImage(imageFile.readAsBytesSync());
    if (originalImage == null) continue;

    final compressedImage = img.copyResize(
      originalImage,
      width:
          1080, // Resize to a max width of 1080px while maintaining aspect ratio
    );

    // Convert the optimized image to a MemoryImage for embedding in the PDF
    final optimizedImageBytes = img.encodeJpg(compressedImage, quality: 75);
    final image = pw.MemoryImage(optimizedImageBytes);

    // Calculate the image aspect ratio and scaling
    final imageAspectRatio =
        compressedImage.width / compressedImage.height.toDouble();
    final usableWidth = pageSize.width - margin * 2;
    final usableHeight = pageSize.height - margin * 2;

    double displayWidth, displayHeight;
    if (imageAspectRatio > usableWidth / usableHeight) {
      // Wider than the page
      displayWidth = usableWidth;
      displayHeight = usableWidth / imageAspectRatio;
    } else {
      // Taller than the page
      displayHeight = usableHeight;
      displayWidth = usableHeight * imageAspectRatio;
    }

    // Add page with watermark
    pdf.addPage(
      pw.Page(
        pageFormat: pageSize,
        margin: const pw.EdgeInsets.all(margin),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // Image centered on the page
              pw.Center(
                child: pw.Image(
                  image,
                  width: displayWidth,
                  height: displayHeight,
                  fit: pw.BoxFit.contain,
                ),
              ),
              // Watermark at the bottom-right of the margin area
              pw.Positioned(
                bottom: 0, // Place at the bottom of the margin area
                right: 0, // Align to the right edge of the page
                child: pw.Padding(
                  padding: const pw.EdgeInsets.only(right: 5, bottom: 5),
                  child: pw.Text(
                    "Scanned with DocuFlex",
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  return pdf;
}

Future<int> getPdfPageCount(String filePath) async {
  final pdfDocument =
      pdf.PdfDocument(inputBytes: await File(filePath).readAsBytes());

  int pageCount = pdfDocument.pages.count;
  pdfDocument.dispose(); // Always dispose the document
  return pageCount;
}
