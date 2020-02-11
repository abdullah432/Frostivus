import 'dart:io';
import 'package:frostivus/models/order.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper databaseHelper;
  Database _database;
  DatabaseHelper.createInstance();

  String orderTable = 'order_table';
  String colId = 'id';
  String colOrderNo = 'orderno';
  String colFlavor = 'flavor';
  String colTopping = 'topping';
  String colTotal = 'total';
  String colChange = 'change';

  factory DatabaseHelper() {
    if (databaseHelper == null) {
      databaseHelper = DatabaseHelper.createInstance();
    }

    return databaseHelper;
  }

  Future<Database> initializeDatabase() async {
    //get directory path to both android and ios to store database
    Directory directory = await getApplicationDocumentsDirectory();

    //below line produce error in iOS
    // String path = directory.path + 'orders.db';
    String path = join(directory.path, 'orders.db');

    //open/create db at give path
    var orderDatabase = await openDatabase(path, version: 1, onCreate: createDb);
    return orderDatabase;
  }

  void createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $orderTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colOrderNo INTEGER, $colFlavor Text, $colTopping Text, $colTotal INTEGER, $colChange INTEGER)');
  }

  Future<Database> get database async {
    if (_database == null) _database = await initializeDatabase();

    return _database;
  }

  //Fetch operation. Get all note object from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    //get refrence to database
    Database db = await this.database;

    // var result = db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    //alternative of above query is
    var result = await db.query(orderTable, orderBy: '$colOrderNo ASC');
    return result;
  }

  //Insert Operation
  Future<int> insertOrder(Order order) async {
    //get refrence to database
    Database db = await this.database;

    //first convert note object into map
    var result = await db.insert(orderTable, order.toMap());
    return result;
  }

    //Update Operation
  Future<int> updateOrder(Order order) async {
    //get refrence to database
    Database db = await this.database;

    //first convert note object into map
    var result = await db.update(orderTable, order.toMap(), where: '$colId = ?', whereArgs: [order.id]);
    return result;
  }

      //Delete Operation
  Future<int> deleteOrder(int id) async {
    //get refrence to database
    Database db = await this.database;

    //first convert note object into map
    var result = await db.delete(orderTable, where: '$colId = $id');
    return result;
  }

    // var result = db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    //alternative of above query is
    // var result = await db.query(orderTable, orderBy: '$colOrderNo ASC');

    Future<List<Map<String, dynamic>>> checkExistingOrder(int orderNo) async{
          //get refrence to database
    Database db = await this.database;

    var result = await db.rawQuery('SELECT * FROM $orderTable WHERE $colOrderNo = $orderNo');
    return result;
}

      //Delete Operation
  Future<int> getCount() async {
    //get refrence to database
    Database db = await this.database;

    //first convert note object into map
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $orderTable');
    var result = Sqflite.firstIntValue(x);
    return result;
  }
  
  Future<List<Order>> getOrderList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Order> orderList = List<Order>();
    for (int i=0; i<count; i++){
      orderList.add(Order.fromMapObject(noteMapList[i]));
    }

    return orderList;
  }

    Future<Order> getExistingOrder(int orderNo) async {
    var noteMapList = await checkExistingOrder(orderNo);

    // List<Order> orderList = List<Order>();
    Order order = Order.fromMapObject(noteMapList[0]);

    return order;
  }

}
