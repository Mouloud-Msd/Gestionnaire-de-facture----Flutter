import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../article/data/ArticleData.dart';

//****** Ce composant sert juste pour visualiser la facture au fr et a mesur de sa creation*/
class PreviewFacture extends StatelessWidget {
  final String clientName;
  final String clientEmail;
  final DateTime? date;
  final List<ArticleData> articles;
  final VoidCallback onClose;

  PreviewFacture({
    required this.clientName,
    required this.clientEmail,
    required this.date,
    required this.articles,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    double totalHT = 0;
    for (var art in articles) {
      final qty = double.tryParse(art.quantityController.text) ?? 0;
      final pu = double.tryParse(art.priceController.text) ?? 0;
      totalHT += qty * pu;
    }
    final tva = totalHT * 0.20;
    final totalTTC = totalHT + tva;

    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Aperçu de la facture',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    IconButton(icon: Icon(Icons.close), onPressed: onClose),
                  ],
                ),
                Divider(),
                Text('Client : $clientName'),
                Text('Email : $clientEmail'),
                Text(
                    'Date : ${date != null ? DateFormat('dd/MM/yyyy').format(date!) : ''}'),
                SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Articles:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ...articles.map((art) {
                          final desc = art.nameController.text;
                          final qty = art.quantityController.text;
                          final pu = art.priceController.text;
                          final total = (double.tryParse(qty) ?? 0) *
                              (double.tryParse(pu) ?? 0);
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                                '$desc - Qté: $qty - PU HT: $pu - Total HT: ${total.toStringAsFixed(2)} €'),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                Divider(),
                Text('Total HT : ${totalHT.toStringAsFixed(2)} €'),
                Text('TVA (20%) : ${tva.toStringAsFixed(2)} €'),
                Text('Total TTC : ${totalTTC.toStringAsFixed(2)} €'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
