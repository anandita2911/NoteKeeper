import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:notekeeper/model/note_model.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._();
  static Database? _database;

  DatabaseProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'note_app.db');

    return await openDatabase(
      dbPath,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          body TEXT,
          creation_date TEXT
        )
      ''');
      },
      version: 3, // Increment the version number
    );
  }


  Future<void> addNewNote(NoteModel note) async {
    final db = await database;
    await db.insert(
      "notes",
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    return await db.query("notes");
  }
}

// Rest of the code...


