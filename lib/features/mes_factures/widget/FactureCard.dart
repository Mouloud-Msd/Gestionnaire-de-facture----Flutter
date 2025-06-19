import 'package:flutter/material.dart';
import 'package:reewayyfacture/DB/db.config.dart';
import 'package:reewayyfacture/Utils/Utils.dart';

class FactureCard extends StatelessWidget {
  final Map<String, dynamic> facture;
  final VoidCallback onDelete;
  final VoidCallback onExport;

  const FactureCard({
    Key? key,
    required this.facture,
    required this.onDelete,
    required this.onExport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(facture['client_name'] ?? 'Sans nom'),
        subtitle: Text(
          'Date : ${facture['date']?.toString().substring(0, 10) ?? 'N/A'}\n'
          'Total TTC : ${facture['total_ttc']?.toStringAsFixed(2) ?? '0'} €',
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.picture_as_pdf, color: Colors.blue),
              onPressed: onExport,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
