import 'package:flutter/material.dart';
import 'package:reewayyfacture/DB/db.config.dart';
import 'package:reewayyfacture/Utils/Utils.dart';

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
      body: _factures.isEmpty
          ? Column(children: [
              Image.asset('assets/image/empty.jpg'),
              Text("Aucune facture n'est encore enregistrée")
            ])
          : ListView.builder(
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.picture_as_pdf, color: Colors.blue),
                          onPressed: () {
                            Utils.exporterFacture(facture['id']);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await DatabaseHelper.instance
                                .deleteFacture(facture['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
