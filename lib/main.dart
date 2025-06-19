import 'package:flutter/material.dart';
import 'package:reewayyfacture/Utils/Utils.dart';
import 'package:reewayyfacture/features/mes_factures/pages/MesFacturesPage.dart';

import 'features/creation_facture/widget/NewFacturePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: Utils.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FacTuDemo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Color.fromARGB(255, 180, 105, 7)),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: mode,
          home: const HomePage(), // ta page principale
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FacTuDemo'), actions: [
        IconButton(
          icon: Icon(Icons.brightness_6),
          onPressed: () {
            Utils.toggleTheme();
          },
        ),
      ]),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NewFacturePage()),
              );
            },
            label: Text('Nouvelle facture'),
            icon: (Icon(Icons.add_circle_outline)),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MesFacturesPage(),
                    ));
              },
              label: Text('Mes factures'),
              icon: (Icon(Icons.receipt))),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent, // ou couleur de fond si tu veux
        padding: EdgeInsets.all(8),
        child: Text(
          '© Mouloud MESSAD 2025',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.grey[600]),
        ),
      ),
    );
  }
}
