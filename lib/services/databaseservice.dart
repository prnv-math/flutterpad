import 'package:flutterpad/models/note.dart';
import 'package:flutterpad/models/tag.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  //Use a singleton pattern (to make sure only one instance of this object is present)
  //instead of making static database variable inside an abstract class
  static final DatabaseService _instance = DatabaseService._internal();
  DatabaseService._internal();
  static DatabaseService get instance => _instance;

  static Database? _database;

  //DATABASE_CODE
  Future<Database> get database async {
    if (_database != null) {
      // print("fetch existing db");
      return _database!;
    }
    // print("initialize db");
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'tagpad.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    print("oncreate() called");
    await db.execute('''
      CREATE TABLE Note (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        date_created TEXT,
        date_modified TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Tag (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE NoteTagRecords (
        note_id INTEGER,
        tag_id INTEGER,
        PRIMARY KEY (note_id, tag_id),
        FOREIGN KEY (note_id) REFERENCES Note(id) ON DELETE CASCADE,
        FOREIGN KEY (tag_id) REFERENCES Tag(id) ON DELETE CASCADE
      )
    ''');
    print("seeding data");
    await insertSeedData(db);
    print("data Seeded");
  }

  Future<void> insertSeedData(Database db) async {
    final count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM Note')) ??
            0;
    if (count > 0) return;

    int note1Id = await db.insert('Note',
        {'title': 'Welcome Note', 'content': 'This is your first note!'});
    int note2Id = await db.insert('Note', {
      'title': 'TagPad Features',
      'content': 'You can add tags to your notes.'
    });

    int tag1Id = await db.insert('Tag', {'name': 'Important'});
    int tag2Id = await db.insert('Tag', {'name': 'Ideas'});

    await db.insert('NoteTagRecords', {'note_id': note1Id, 'tag_id': tag1Id});
    await db.insert('NoteTagRecords', {'note_id': note2Id, 'tag_id': tag2Id});
  }

  // CRUD code
  Future<int> createNote(Note note) async {
    final db = await database;
    return await db.insert('Note', note.toMap());
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Note');
    return maps.map((e) => Note.fromMap(e)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'Note',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'Note',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // **CRUD for Tags**
  Future<int> createTag(Tag tag) async {
    final db = await database;
    return await db.insert('Tag', tag.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<Tag>> getAllTags() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Tag');
    return maps.map((e) => Tag.fromMap(e)).toList();
  }

  Future<int> deleteTag(int id) async {
    final db = await database;
    return await db.delete(
      'Tag',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // **CRUD for NoteTag (Associating Notes and Tags)**
  Future<void> addTagToNote(int noteId, int tagId) async {
    final db = await database;
    await db.insert('NoteTagRecords', {'note_id': noteId, 'tag_id': tagId});
  }

  Future<List<Tag>> getTagsForNote(int noteId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT Tag.* FROM Tag
      JOIN NoteTagRecords ON Tag.id = NoteTagRecords.tag_id
      WHERE NoteTagRecords.note_id = ?
    ''', [noteId]);

    return maps.map((e) => Tag.fromMap(e)).toList();
  }

  Future<void> removeTagFromNote(int noteId, int tagId) async {
    final db = await database;
    await db.delete(
      'NoteTagRecords',
      where: 'note_id = ? AND tag_id = ?',
      whereArgs: [noteId, tagId],
    );
  }
}
