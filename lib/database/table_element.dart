import 'package:sqflite/sqflite.dart';

abstract class TableElement {
  int? id;
  final String tableName;
  TableElement(this.id, this.tableName);
  Future createTable(Database db);
  Map<String, dynamic> toMap();

  static fromMap(Map i) {}
}
