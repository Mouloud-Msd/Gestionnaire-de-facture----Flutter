import 'dart:ui';

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
                seedColor: Color.fromARGB(255, 7, 102, 180)),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: mode,
          home: const HomePage(),
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/factures.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Center(
              //child: ClipRRect(
              //borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  padding: const EdgeInsets.all(60),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 211, 212, 212).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => NewFacturePage()),
                          );
                        },
                        label: const Text(
                          'Nouvelle facture',
                          style: TextStyle(fontSize: 20),
                        ),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => MesFacturesPage()),
                          );
                        },
                        label: const Text(
                          'Mes factures',
                          style: TextStyle(fontSize: 20),
                        ),
                        icon: const Icon(Icons.receipt),
                      ),
                    ],
                  ),
                ),
              ),
              //),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
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
