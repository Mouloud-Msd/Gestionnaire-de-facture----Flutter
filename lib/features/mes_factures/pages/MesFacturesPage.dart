import 'package:flutter/material.dart';
import 'package:reewayyfacture/DB/db.config.dart';
import 'package:reewayyfacture/Utils/Utils.dart';

import '../widget/FactureCard.dart';

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
          ? SingleChildScrollView(
              child: Column(children: [
              Image.asset('assets/image/empty.jpg'),
              Text("Aucune facture n'est encore enregistrée")
            ]))
          : ListView.builder(
              itemCount: _factures.length,
              itemBuilder: (context, index) {
                final facture = _factures[index];
                return FactureCard(
                  facture: facture,
                  onExport: () {
                    Utils.exporterFacture(facture['id']);
                  },
                  onDelete: () async {
                    await DatabaseHelper.instance.deleteFacture(facture['id']);
                    _loadFactures();
                  },
                );
              },
            ),
    );
  }
}
