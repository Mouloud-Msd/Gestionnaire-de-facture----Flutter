import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:reewayyfacture/DB/db.config.dart';

class Utils {
  static Future<void> exporterFacture(int factureId) async {
    final db = await DatabaseHelper.instance.database;

    final fontData =
        await rootBundle.load('assets/fonts/Roboto-VariableFont_wdth,wght.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    final facture = (await db.query(
      'facture',
      where: 'id = ?',
      whereArgs: [factureId],
    ))
        .first;

    final articles = await db.query(
      'article',
      where: 'facture_id = ?',
      whereArgs: [factureId],
    );

    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Facture', style: pw.TextStyle(font: ttf, fontSize: 24)),
            pw.SizedBox(height: 16),
            pw.Text('Client : ${facture['client_name']}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Email : ${facture['client_email']}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Date : ${facture['date']}',
                style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 24),
            pw.Table.fromTextArray(
              headers: ['Article', 'Quantité', 'Prix Unitaire', 'Total HT'],
              data: articles
                  .map((a) => [
                        a['name'],
                        '${a['quantity']}',
                        '${a['price_ht']}€',
                        '${a['total_ht']}€',
                      ])
                  .toList(),
              headerStyle: pw.TextStyle(font: ttf),
              cellStyle: pw.TextStyle(font: ttf),
            ),
            pw.SizedBox(height: 24),
            pw.Text('Total TTC : ${facture['total_ttc']}€',
                style: pw.TextStyle(font: ttf)),
          ],
        ),
      ),
    );
    await Printing.layoutPdf(
      onLayout: (format) async => doc.save(),
    );
  }

  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier(ThemeMode.light);

  static void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
