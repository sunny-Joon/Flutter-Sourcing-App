import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Models/RangeCategoryModel.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE RangeCategory(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cat_key TEXT,
            groupDescriptionEn TEXT,
            groupDescriptionHi TEXT,
            descriptionEn TEXT,
            descriptionHi TEXT,
            sortOrder INTEGER,
            code TEXT
          )
          ''',
        );
      },
    );
  }

  Future<void> insertRangeCategory(RangeCategoryDataModel datum) async {
    final db = await database;
    try {
      await db.insert(
        'RangeCategory',
        datum.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // Handle insertion error
      print('Error inserting range category: $e');
    }
  }

  Future<List<RangeCategoryDataModel>> getRangeCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('RangeCategory');

    return List.generate(maps.length, (i) {
      return RangeCategoryDataModel.fromJson(maps[i]);
    });
  }

  Future<void> clearRangeCategoryTable() async {
    final db = await database;
    await db.delete('RangeCategory');
  }

  Future<bool> isRangeCategoryDataExists() async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM RangeCategory'));
    return count != 0;
  }

  Future<List<RangeCategoryDataModel>> selectRangeCatData(String catKey) async {
    final db = await database;
    final res = await db.query("RangeCategory", where: "cat_key = ?", whereArgs: [catKey]);
    return res.isNotEmpty ? res.map((c) => RangeCategoryDataModel.fromJson(c)).toList() : [];
  }
}
