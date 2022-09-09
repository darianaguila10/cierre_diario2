import 'package:cierre_diario2/database/table_element.dart';
import 'package:sqflite/sqlite_api.dart';

class DailyClosingModel extends TableElement {
  static const String TABLE_NAME = "daily_closing";
  String? name;
  double? cost;
  double? price;
  String? supplier;
  int? amount;

  DailyClosingModel({this.name, this.cost, this.price, this.amount=0, this.supplier='', id}) : super(id, TABLE_NAME);

  factory DailyClosingModel.fromMap(Map<dynamic, dynamic> map) {
    return DailyClosingModel(
      id: map["_id"],
      name: map["name"],
      cost: map["cost"],
      price: map["price"],
      supplier: map["supplier"],
      amount: map["amount"],
    );
  }

  @override
  createTable(Database db) async {
    await db
        .rawUpdate("CREATE TABLE ${TABLE_NAME}(_id integer primary key autoincrement, name varchar(30), supplier varchar(30), amount integer, cost real, price real)");
  }

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "name": name,
      "cost": cost,
      "price": price,
      "supplier": supplier,
      "amount": amount
    };
    if (id != null) {
      map["_id"] = id;
    }
    return map;
  }

  toJson() => {
        "_id": id,
        "name": name,
        "cost": cost,
        "price": price,
        "supplier": supplier,
        "amount": amount
      };

  factory DailyClosingModel.fromJson(Map<String, dynamic> json) {
    return DailyClosingModel(
      id: json["_id"],
      name: json["name"],
      cost: json["cost"],
      price: json["price"],
      supplier: json["supplier"],
      amount: json["amount"],
    );
  }
}
