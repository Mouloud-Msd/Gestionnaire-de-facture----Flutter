import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reewayyfacture/features/facture/widget/PreviewFacture.dart';

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
      articles[index].dispose(); // libérer les contrôleurs mémoire
      articles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New Facture'),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Text('Informations client',
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

                    // boutton visualise
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
                      onPressed: () {
                        setState(() {
                          articles.add(ArticleData());
                        });
                      },
                      icon: Icon(Icons.save),
                      label: Text('Sauvegarder la facture'),
                    ),
                    if (_showPreview)
                      PreviewFacture(
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
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
