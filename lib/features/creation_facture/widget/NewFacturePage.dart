import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reewayyfacture/DB/db.config.dart';
import 'package:reewayyfacture/Utils/Utils.dart';
import 'package:reewayyfacture/features/creation_facture/widget/PreviewFacture.dart';

import '../../article/data/ArticleData.dart';
import '../../article/widget/Article.dart';

class NewFacturePage extends StatefulWidget {
  const NewFacturePage({super.key});

  @override
  _NewFacturePageState createState() => _NewFacturePageState();
}

class _NewFacturePageState extends State<NewFacturePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientEmailController = TextEditingController();
  DateTime? _selectedDate;
  bool _showPreview = false;

  List<ArticleData> articles = [];

  @override
  void dispose() {
    _clientNameController.dispose();
    _clientEmailController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formattedDate() {
    if (_selectedDate == null) return 'Sélectionner une date';
    return DateFormat('dd/MM/yyyy').format(_selectedDate!);
  }

  void _removeArticle(int index) {
    setState(() {
      articles[index].dispose();
      articles.removeAt(index);
    });
  }

  double get totalHT {
    double sum = 0;
    for (var article in articles) {
      final qte = double.tryParse(article.quantityController.text) ?? 0;
      final prix = double.tryParse(article.priceController.text) ?? 0;
      sum += qte * prix;
    }
    return sum;
  }

  double get tva => totalHT * 0.20;
  double get totalTTC => totalHT + tva;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Nouvelle Facture'), actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              Utils.toggleTheme();
            },
          ),
        ]),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Text('Informations du client',
                        style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _clientNameController,
                      decoration: InputDecoration(labelText: 'Nom du client'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Champ requis'
                          : null,
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _clientEmailController,
                      decoration: InputDecoration(labelText: 'Email du client'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value == null || !value.contains('@')
                              ? 'Email invalide'
                              : null,
                    ),
                    SizedBox(height: 20),
                    Text('Date de facture',
                        style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _formattedDate(),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _pickDate,
                          child: Text('Choisir une date'),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Récap',
                              style: Theme.of(context).textTheme.titleMedium),
                          SizedBox(height: 8),
                          Text('Total HT : ${totalHT.toStringAsFixed(2)} €'),
                          Text('TVA (20 %) : ${tva.toStringAsFixed(2)} €'),
                          Text('Total TTC : ${totalTTC.toStringAsFixed(2)} €',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Divider(),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          articles.add(ArticleData());
                        });
                      },
                      icon: Icon(Icons.add),
                      label: Text('Ajouter un article'),
                    ),
                    SizedBox(height: 20),
                    ...articles.asMap().entries.map((entry) {
                      final index = entry.key;
                      final article = entry.value;

                      return ArticleItem(
                        nameController: article.nameController,
                        quantityController: article.quantityController,
                        priceController: article.priceController,
                        onRemove: () => _removeArticle(index),
                      );
                    }).toList(),

                    // boutton visualiser
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showPreview = true;
                        });
                      },
                      icon: Icon(Icons.document_scanner),
                      label: Text('Visualiser la facture'),
                    ),

                    // boutton sauvegarder facture
                    ElevatedButton.icon(
                      onPressed: () async {
                        double totalHT = 0;
                        List<Map<String, dynamic>> articleMaps = [];

                        for (var article in articles) {
                          final qte = double.tryParse(
                                  article.quantityController.text) ??
                              0;
                          final pu =
                              double.tryParse(article.priceController.text) ??
                                  0;
                          final total = qte * pu;
                          totalHT += total;

                          articleMaps.add({
                            'name': article.nameController.text,
                            'quantity': qte,
                            'price_ht': pu,
                            'total_ht': total,
                          });
                        }

                        final factureData = {
                          'client_name': _clientNameController.text,
                          'client_email': _clientEmailController.text,
                          'date': _selectedDate?.toIso8601String(),
                          'total_ht': totalHT,
                          'total_ttc': totalHT * 1.20,
                        };

                        final db = DatabaseHelper.instance;
                        final factureId = await db.insertFacture(factureData);

                        for (var article in articleMaps) {
                          article['facture_id'] = factureId;
                        }

                        await db.insertArticles(articleMaps);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Facture sauvegardée avec succès !')),
                        );
                      },
                      icon: Icon(Icons.save),
                      label: Text('Sauvegarder la facture'),
                    ),
                  ],
                ),
              ),
            ),
            // Controle de la visualisation
            if (_showPreview)
              Positioned.fill(
                child: PreviewFacture(
                  clientName: _clientNameController.text,
                  clientEmail: _clientEmailController.text,
                  date: _selectedDate,
                  articles: articles,
                  onClose: () {
                    setState(() {
                      _showPreview = false;
                    });
                  },
                ),
              ),
          ],
        ));
  }
}
