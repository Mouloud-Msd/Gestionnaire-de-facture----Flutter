import 'package:flutter/material.dart';
import 'package:reewayyfacture/DB/db.config.dart';

class MesFacturesPage extends StatefulWidget {
  const MesFacturesPage({super.key});

  @override
  State<MesFacturesPage> createState() => _MesFacturesPageState();
}

class _MesFacturesPageState extends State<MesFacturesPage> {
  List<Map<String, dynamic>> _factures = [];

  @override
  void initState() {
    super.initState();
    _loadFactures();
  }

  Future<void> _loadFactures() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('facture', orderBy: 'date DESC');

    setState(() {
      _factures = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mes factures')),
      body: ListView.builder(
        itemCount: _factures.length,
        itemBuilder: (context, index) {
          final facture = _factures[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(facture['client_name'] ?? 'Sans nom'),
              subtitle: Text(
                  'Date : ${facture['date']?.toString().substring(0, 10) ?? 'N/A'}\n'
                  'Total TTC : ${facture['total_ttc']?.toStringAsFixed(2) ?? '0'} €'),
              isThreeLine: true,
              onTap: () {
                //xsa
              },
            ),
          );
        },
      ),
    );
  }
}
