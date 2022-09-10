import 'package:cierre_diario2/database/models/daily_closing.model.dart';
import 'package:cierre_diario2/database/table_element.dart';
import 'package:sqflite/sqflite.dart';

const String DB_FILE_NAME = "cierre_diario.db";

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  //se configura las relaciones entre las tablas
  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database!;
    }

    _database = (await open())!;

    return _database!;
  }

  Future<Database?> open() async {
    try {
      String databasesPath = await getDatabasesPath();
      String path = "$databasesPath/$DB_FILE_NAME";
      var db = await openDatabase(
        path,
        version: 1,
        onConfigure: _onConfigure,
        onCreate: (Database database, int version) async {
          
          await DailyClosingModel().createTable(database);
        },
      );
      return db;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<List<DailyClosingModel>> getDailyClosingList() async {
    Database dbClient = await db;

    String field = "daily_closing._id ,"
        "daily_closing.name,"
        "daily_closing.cost,"
        "daily_closing.price,"
        "daily_closing.supplier,"
        "daily_closing.amount";     
      

    List<Map> maps = await dbClient.rawQuery("select  $field "
        "FROM daily_closing order by daily_closing.supplier;");
        
    return maps
        .map((i) => DailyClosingModel.fromMap(i))
        .toList();
  }

  Future<int?> insert(TableElement element) async {
    var dbClient = await db;
    element.id = await dbClient.insert(element.tableName, element.toMap());
    return element.id;
  }

  Future<int> delete(TableElement element) async {
    var dbClient = await db;
    return await dbClient
        .delete(element.tableName, where: '_id = ?', whereArgs: [element.id]);
  }

  Future<int> deleteall(TableElement element) async {
    var dbClient = await db;
    return await dbClient.delete(element.tableName);
  }

  Future<int> update(TableElement element) async {
    var dbClient = await db;
    return await dbClient.update(element.tableName, element.toMap(),
        where: '_id = ?', whereArgs: [element.id]);
  }
}
