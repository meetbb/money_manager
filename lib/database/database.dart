
import 'dart:async';
import 'dart:io' as io;

import 'package:moneymanager/database/model/transaction_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;
  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "MoneyManagerDB.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE TransactionDetail(id INTEGER PRIMARY KEY, transactionname TEXT, transactionamount TEXT, transactiondate TEXT, transactioncategory TEXT)");
  }

  Future<int> saveTransaction(TransactionModel trxnModel) async {
    var dbClient = await db;
    int res = await dbClient.insert("TransactionDetail", trxnModel.toMap());
    return res;
  }

  Future<List<TransactionModel>> getTrxnList() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM TransactionDetail');
    List<TransactionModel> trxnList = new List();
    for (int i = 0; i < list.length; i++) {
      var trxnModel =
          new TransactionModel(list[i]["transactionname"], list[i]["transactionamount"], list[i]["transactiondate"], list[i]["transactioncategory"]);
      trxnModel.setUserId(list[i]["id"]);
      trxnList.add(trxnModel);
    }
    print(trxnList.length);
    return trxnList;
  }

  Future<int> deleteTrxn(TransactionModel trxnModel) async {
    var dbClient = await db;
    int res =
        await dbClient.rawDelete('DELETE FROM TransactionDetail WHERE id = ?', [trxnModel.trxnId]);
    return res;
  }

  Future<bool> update(TransactionModel trxnModel) async {
    var dbClient = await db;
    int res =   await dbClient.update("TransactionDetail", trxnModel.toMap(),
        where: "id = ?", whereArgs: <int>[trxnModel.trxnId]);
    return res > 0 ? true : false;
  }
}