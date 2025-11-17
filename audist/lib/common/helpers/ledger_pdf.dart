import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'converter_helper.dart';
import 'package:audist/core/model/fetch_payment/fetch_payment_response.dart';

Future<void> generateLedgerPDF(List<CashCollection> collection) async {
  final pdf = pw.Document();

  // Load TTF fonts
  final regularFont = pw.Font.ttf(
    await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'),
  );
  final boldFont = pw.Font.ttf(
    await rootBundle.load('assets/fonts/NotoSans-Bold.ttf'),
  );

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(16),
      build: (context) {
        return [
          pw.Text(
            'Ledger Report',
            style: pw.TextStyle(fontSize: 20, font: boldFont),
          ),
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headers: ['Date', 'Description', 'Payment', 'Balance'],
            data: collection.map((e) {
              return [
                e.collectionDate != null
                    ? ConverterHelper.dateTimeToCustomString(
                        e.collectionDate!,
                        'dd/MM/yyyy',
                      )
                    : "N/A",
                e.description ?? "N/A",
                e.payment != null
                    ? ConverterHelper.formatCurrency(
                        ConverterHelper.objectToDouble(e.payment),
                      )
                    : "N/A",
                e.remainingAfterPayment != null
                    ? ConverterHelper.formatCurrency(
                        ConverterHelper.objectToDouble(e.remainingAfterPayment),
                      )
                    : "N/A",
              ];
            }).toList(),
            cellAlignment: pw.Alignment.centerLeft,
            headerStyle: pw.TextStyle(font: boldFont, color: PdfColors.white),
            headerDecoration: pw.BoxDecoration(color: PdfColors.blueAccent),
            cellHeight: 25,
            cellStyle: pw.TextStyle(font: regularFont),
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight,
            },
          ),
        ];
      },
    ),
  );

  // Save PDF to device
  final output = await getApplicationDocumentsDirectory();
  final file = File("${output.path}/ledger_report.pdf");
  await file.writeAsBytes(await pdf.save());

  // Open the PDF automatically
  await OpenFile.open(file.path);
}
