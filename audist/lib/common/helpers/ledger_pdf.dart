import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

Future<void> generateLoanLedgerPDF() async {
  final pdf = pw.Document();

  // Load Sinhala fonts
  final sinhalaRegular = pw.Font.ttf(
    await rootBundle.load('assets/fonts/AbhayaLibre-Regular.ttf'),
  );

  final sinhalaBold = pw.Font.ttf(
    await rootBundle.load('assets/fonts/AbhayaLibre-Bold.ttf'),
  );

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 26, vertical: 22),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // ------------------------- HEADER ----------------------------
            pw.Center(
              child: pw.Text(
                "LOAN LEDGER",
                style: pw.TextStyle(
                  font: sinhalaBold,
                  fontSize: 22,
                ),
              ),
            ),

            pw.SizedBox(height: 6),

            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "10/08/2025",
                style: pw.TextStyle(font: sinhalaBold, fontSize: 12),
              ),
            ),

            pw.SizedBox(height: 20),

            // ------------------------- U LAYOUT BLOCK ----------------------------
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // LEFT BLOCK
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("ණය අංකය        : 232",
                          style: pw.TextStyle(font: sinhalaRegular, fontSize: 12)),
                      pw.Text("අයදුම්කරු    : හෙළ අයදුම්කරු",
                          style: pw.TextStyle(font: sinhalaRegular, fontSize: 12)),
                      pw.Text("NIC                 : 200000000V",
                          style: pw.TextStyle(font: sinhalaRegular, fontSize: 12)),
                      pw.Text("ලිපිනය          : කොළඹ ශ්‍රී ලංකා",
                          style: pw.TextStyle(font: sinhalaRegular, fontSize: 12)),
                      pw.Text("දුරකථන       : 0771234567",
                          style: pw.TextStyle(font: sinhalaRegular, fontSize: 12)),
                    ],
                  ),
                ),

                pw.SizedBox(width: 30),

                // RIGHT BLOCK
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("ණය වර්ගය      : සාමාන්‍ය ණය",
                          style: pw.TextStyle(font: sinhalaRegular, fontSize: 12)),
                      pw.Text("මුදල             : 250,000.00",
                          style: pw.TextStyle(font: sinhalaRegular, fontSize: 12)),
                      pw.Text("වරප්‍රසාද      : 15%",
                          style: pw.TextStyle(font: sinhalaRegular, fontSize: 12)),
                      pw.Text("කාලය           : මාස 12",
                          style: pw.TextStyle(font: sinhalaRegular, fontSize: 12)),
                      pw.Text("ස්ථාවරය       : වාහනය",
                          style: pw.TextStyle(font: sinhalaRegular, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 25),

            // ------------------------- TABLE TITLE ----------------------------
            pw.Text(
              "ගෙවීම් වාර්තාව",
              style: pw.TextStyle(font: sinhalaBold, fontSize: 15),
            ),

            pw.SizedBox(height: 10),

            // ------------------------- TABLE ----------------------------
            pw.Table(
              border: pw.TableBorder.all(width: 0.8),
              columnWidths: {
                0: const pw.FlexColumnWidth(2),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(3),
                3: const pw.FlexColumnWidth(3),
                4: const pw.FlexColumnWidth(3),
              },
              children: [
                // Header row
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFEFEFEF)),
                  children: [
                    _tableHeader("දිනය", sinhalaBold),
                    _tableHeader("ගෙවූ මුදල", sinhalaBold),
                    _tableHeader("වෙතිරෙන මුදල", sinhalaBold),
                    _tableHeader("තිරසාරය", sinhalaBold),
                    _tableHeader("සටහන", sinhalaBold),
                  ],
                ),

                // Sample Data rows
                ...List.generate(
                  8,
                      (index) => pw.TableRow(
                    children: [
                      _tableCell("2025-08-${10 + index}", sinhalaRegular),
                      _tableCell("25,000.00", sinhalaRegular),
                      _tableCell("225,000.00", sinhalaRegular),
                      _tableCell("සම්පූර්ණයි", sinhalaRegular),
                      _tableCell("OK", sinhalaRegular),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 25),

            // ------------------------- FOOTER ----------------------------
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "මුළු ගෙවීම් : 250,000.00",
                style: pw.TextStyle(font: sinhalaBold, fontSize: 14),
              ),
            ),
          ],
        );
      },
    ),
  );

  final dir = await getApplicationDocumentsDirectory();
  final file = File("${dir.path}/Loan_Ledger.pdf");
  await file.writeAsBytes(await pdf.save());

  OpenFile.open(file.path);
}

// ----------------------------------------------------------------------
// Helper cell widgets
// ----------------------------------------------------------------------

pw.Widget _tableHeader(String text, pw.Font font) => pw.Padding(
  padding: const pw.EdgeInsets.all(5),
  child: pw.Text(
    text,
    style: pw.TextStyle(font: font, fontSize: 11),
    textAlign: pw.TextAlign.center,
  ),
);

pw.Widget _tableCell(String text, pw.Font font) => pw.Padding(
  padding: const pw.EdgeInsets.all(5),
  child: pw.Text(
    text,
    style: pw.TextStyle(font: font, fontSize: 10),
    textAlign: pw.TextAlign.center,
  ),
);