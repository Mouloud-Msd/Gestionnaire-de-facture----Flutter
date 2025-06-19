import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _db;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  // fonction d'initiatin de la bd, des tabes ect..
  Future<Database> _initDb() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, 'factures.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE facture (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        client_name TEXT,
        client_email TEXT,
        date TEXT,
        total_ht REAL,
        total_ttc REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE article (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        facture_id INTEGER,
        name TEXT,
        quantity REAL,
        price_ht REAL,
        total_ht REAL,
        FOREIGN KEY(facture_id) REFERENCES facture(id)
      )
    ''');
  }

  //fonction pour ajouter une factures
  Future<int> insertFacture(Map<String, dynamic> facture) async {
    final db = await database;
    return await db.insert('facture', facture);
  }

  //fonction pour inserer des articles
  Future<void> insertArticles(List<Map<String, dynamic>> articles) async {
    final db = await database;
    Batch batch = db.batch();
    for (var article in articles) {
      batch.insert('article', article);
    }
    await batch.commit(noResult: true);
  }

  //fonction pour supprimer une facture et ses articles
  Future<void> deleteFacture(int id) async {
    final db = await database;
    await db.delete('article', where: 'facture_id = ?', whereArgs: [id]);
    await db.delete('facture', where: 'id = ?', whereArgs: [id]);
  }
}
