import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:reewayyfacture/DB/db.config.dart';

class Utils {
  static Future<void> exporterFacture(int factureId) async {
    final db = await DatabaseHelper.instance.database;

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
            pw.Text('Facture', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 16),
            pw.Text('Client : ${facture['client_name']}'),
            pw.Text('Email : ${facture['client_email']}'),
            pw.Text('Date : ${facture['date']}'),
            pw.SizedBox(height: 24),
            pw.Table.fromTextArray(
              headers: ['Article', 'Quantité', 'PU', 'Total HT'],
              data: articles
                  .map((a) => [
                        a['name'],
                        '${a['quantity']}',
                        '${a['price_ht']}€',
                        '${a['total_ht']}€',
                      ])
                  .toList(),
            ),
            pw.SizedBox(height: 24),
            pw.Text('Total TTC : ${facture['total_ttc']}€'),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => doc.save(),
    );
  }
}
