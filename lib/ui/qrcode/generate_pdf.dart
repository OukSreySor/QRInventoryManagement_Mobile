import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

Future<Uint8List> generateQrGridPdf({
  required List<Map<String, String>> items,
  required int columns,
  required int rows,
}) async {
  final pdf = pw.Document();
  final itemsPerPage = columns * rows;

  for (var pageIndex = 0; pageIndex < (items.length / itemsPerPage).ceil(); pageIndex++) {
    final pageItems = items.skip(pageIndex * itemsPerPage).take(itemsPerPage).toList();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(16),
        build: (context) {
          return pw.GridView(
            crossAxisCount: columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.9,
            children: [
              for (final item in pageItems)
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Container(
                      width: 80,
                      height: 80,
                      child: pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: item['qr'] ?? '',
                        width: 80,
                        height: 80,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      item['name'] ?? '',
                      style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      item['sn'] ?? '',
                      style: pw.TextStyle(fontSize: 9),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  return pdf.save();
}
