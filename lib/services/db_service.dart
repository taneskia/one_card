import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  static final DbService _dbService = DbService._private();
  Database? _database;

  DbService._private();

  factory DbService() {
    return _dbService;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDb();
    return _database!;
  }

  _initDb() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'cards.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE cards('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'market_name TEXT,'
          'barcode TEXT,'
          'barcode_type TEXT,'
          'image_path TEXT'
          ')',
        );
      },
      version: 1
    );
  }
}
