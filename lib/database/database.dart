import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/cupertino.dart';
import 'package:moneymanager/database/model/category_model.dart';
import 'package:moneymanager/database/model/subcategory_model.dart';
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
        "CREATE TABLE TransactionDetail(id INTEGER PRIMARY KEY, transactionname TEXT, transactionamount TEXT, transactiondate TEXT, transactioncategory TEXT, iswithdrawal BOOLEAN)");
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
      var trxnModel = new TransactionModel(
          list[i]["transactionname"],
          list[i]["transactionamount"],
          list[i]["transactiondate"],
          list[i]["transactioncategory"],
          (list[i]["iswithdrawal"] == 1));
      trxnModel.setUserId(list[i]["id"]);
      trxnList.add(trxnModel);
    }
    print(trxnList.length);
    return trxnList;
  }

  Future<List<TransactionModel>> getTrxnByCategory(String category) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM TransactionDetail WHERE transactioncategory = ?',
        [category]);
    List<TransactionModel> trxnList = new List();
    for (int i = 0; i < list.length; i++) {
      var trxnModel = new TransactionModel(
          list[i]["transactionname"],
          list[i]["transactionamount"],
          list[i]["transactiondate"],
          list[i]["transactioncategory"],
          list[i]["iswithdrawal"]);
      trxnModel.setUserId(list[i]["id"]);
      trxnList.add(trxnModel);
    }
    print(trxnList.length);
    return trxnList;
  }

  Future<List<TransactionModel>> getDailyTrxnList(String currentdate) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM TransactionDetail WHERE transactiondate = ?',
        [currentdate]);
    List<TransactionModel> trxnList = new List();
    for (int i = 0; i < list.length; i++) {
      var trxnModel = new TransactionModel(
          list[i]["transactionname"],
          list[i]["transactionamount"],
          list[i]["transactiondate"],
          list[i]["transactioncategory"],
          list[i]["iswithdrawal"]);
      trxnModel.setUserId(list[i]["id"]);
      trxnList.add(trxnModel);
    }
    print(trxnList.length);
    return trxnList;
  }

  Future<List<TransactionModel>> getMonthlyTrxnList() async {
    var dbClient = await db;
    String sql =
        'SELECT * FROM TransactionDetail WHERE CAST(transactiondate AS DATE) >= \'10-03-2020\';';
    List<Map> list = await dbClient.rawQuery(sql);
    List<TransactionModel> trxnList = new List();
    for (int i = 0; i < list.length; i++) {
      var trxnModel = new TransactionModel(
          list[i]["transactionname"],
          list[i]["transactionamount"],
          list[i]["transactiondate"],
          list[i]["transactioncategory"],
          (list[i]["iswithdrawal"] == 1));
      trxnModel.setUserId(list[i]["id"]);
      trxnList.add(trxnModel);
    }
    print(trxnList.length);
    return trxnList;
  }

  Future<int> deleteTrxn(TransactionModel trxnModel) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete(
        'DELETE FROM TransactionDetail WHERE id = ?', [trxnModel.trxnId]);
    return res;
  }

  Future<bool> update(TransactionModel trxnModel) async {
    var dbClient = await db;
    int res = await dbClient.update("TransactionDetail", trxnModel.toMap(),
        where: "id = ?", whereArgs: <int>[trxnModel.trxnId]);
    return res > 0 ? true : false;
  }

  Future<bool> createCategoryTable(Database db) async {
    // await db.execute('DROP TABLE IF EXISTS Category;');
    // await db.execute('DROP TABLE IF EXISTS SubCategory;');
    try {
      await db.rawQuery('SELECT * FROM Category');
    } catch (e) {
      // await db.execute('DROP TABLE IF EXISTS Category;');
      await db.execute(
          "CREATE TABLE IF NOT EXISTS Category(category_Id INTEGER PRIMARY KEY AUTOINCREMENT, category_Name TEXT, category_type TEXT, logo TEXT, position INTEGER)");
      debugPrint('table created');

      await db.execute(
          "CREATE TABLE IF NOT EXISTS SubCategory(subcategory_id INTEGER PRIMARY KEY AUTOINCREMENT, subcategory_name TEXT,category_id INTEGER,subcategory_type TEXT, logo TEXT, position INTEGER)");

      await addCategoriesData();
    }
    return true;
  }

  Future<bool> addCategoriesData() async {
    int catId = 0;
    catId = await addCategory(new CategoryModel('Transportation', 1));
    await addSubCategory(new SubCategoryModel('Railways', catId, 1));
    await addSubCategory(new SubCategoryModel('Roadways', catId, 2));
    await addSubCategory(new SubCategoryModel('Airways', catId, 3));
    await addSubCategory(new SubCategoryModel('Waterways', catId, 4));
    await addSubCategory(new SubCategoryModel('Pipelines', catId, 5));

    catId = await addCategory(new CategoryModel('Food', 2));
    await addSubCategory(new SubCategoryModel('Lunch', catId, 1));
    await addSubCategory(new SubCategoryModel('Dinner', catId, 2));
    await addSubCategory(new SubCategoryModel('Eating out', catId, 3));
    await addSubCategory(new SubCategoryModel('Beverages', catId, 4));
    catId = await addCategory(new CategoryModel('Social Life', 3));
    await addSubCategory(new SubCategoryModel('Friend', catId, 1));
    await addSubCategory(new SubCategoryModel('Fellowship', catId, 2));
    await addSubCategory(new SubCategoryModel('Alumni', catId, 3));
    await addSubCategory(new SubCategoryModel('Dues', catId, 4));

    catId = await addCategory(new CategoryModel('Self-Development', 4));
    catId = await addCategory(new CategoryModel('Culture', 5));
    await addSubCategory(new SubCategoryModel('Books', catId, 1));
    await addSubCategory(new SubCategoryModel('Movie', catId, 2));
    await addSubCategory(new SubCategoryModel('Music', catId, 3));
    await addSubCategory(new SubCategoryModel('Apps', catId, 4));
    catId = await addCategory(new CategoryModel('Houserhold', 6));
    await addSubCategory(new SubCategoryModel('Appliances', catId, 1));
    await addSubCategory(new SubCategoryModel('Furniture', catId, 2));
    await addSubCategory(new SubCategoryModel('Kitchen', catId, 3));
    await addSubCategory(new SubCategoryModel('Toiletries', catId, 4));
    await addSubCategory(new SubCategoryModel('Chandlery', catId, 5));
    catId = await addCategory(new CategoryModel('Apparel', 7));

    await addSubCategory(new SubCategoryModel('Clothing', catId, 1));
    await addSubCategory(new SubCategoryModel('Fashion', catId, 2));
    await addSubCategory(new SubCategoryModel('Shoes', catId, 3));
    await addSubCategory(new SubCategoryModel('Laundry', catId, 4));
    catId = await addCategory(new CategoryModel('Beauty', 8));
    await addSubCategory(new SubCategoryModel('Cosmetics', catId, 1));
    await addSubCategory(new SubCategoryModel('Makeup', catId, 2));
    await addSubCategory(new SubCategoryModel('Accessories', catId, 3));
    await addSubCategory(new SubCategoryModel('Beauty', catId, 4));
    catId = await addCategory(new CategoryModel('Health', 9));
    await addSubCategory(new SubCategoryModel('Health', catId, 1));
    await addSubCategory(new SubCategoryModel('Yoga', catId, 2));
    await addSubCategory(new SubCategoryModel('Hospital', catId, 3));
    await addSubCategory(new SubCategoryModel('Medicine', catId, 4));
    catId = await addCategory(new CategoryModel('Education', 10));
    await addSubCategory(new SubCategoryModel('Schooling', catId, 1));
    await addSubCategory(new SubCategoryModel('Textbooks', catId, 2));
    await addSubCategory(new SubCategoryModel('School suppies', catId, 3));
    await addSubCategory(new SubCategoryModel('Academy', catId, 4));
    catId = await addCategory(new CategoryModel('Gift', 11));
    catId = await addCategory(new CategoryModel('Other', 12));
    await getCategoryList();

    return true;
  }

  Future<int> addCategory(CategoryModel categoryModel) async {
    var dbClient = await db;
    int res = await dbClient.insert("Category", categoryModel.toMap());
    return res;
  }

  Future<bool> editCategory(CategoryModel categoryModel) async {
    var dbClient = await db;
    int res = await dbClient.update("Category", categoryModel.toMap(),
        where: "categoryId = ?", whereArgs: <int>[categoryModel.categoryId]);
    return res > 0 ? true : false;
  }

  Future<int> deleteCategory(CategoryModel categoryModel) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete(
        'DELETE FROM Category WHERE categoryId = ?',
        [categoryModel.categoryId]);
    return res;
  }

  Future<List<CategoryModel>> getCategoryList() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Category');
    List<CategoryModel> categoryList = new List();
    for (int i = 0; i < list.length; i++) {
      var categoryModel = new CategoryModel(
        list[i]["categoryName"],
        list[i]["position"],
      );
      categoryModel.setCategoryId(list[i]["categoryId"]);
      print(list[i].toString());
      categoryList.add(categoryModel);
    }
    categoryList.sort((a, b) => a.position.compareTo(b.position));
    // print(categoryList.toString());
    return categoryList;
  }

  //subCategories

  Future<int> addSubCategory(SubCategoryModel subcategoryModel) async {
    var dbClient = await db;
    int res = await dbClient.insert("SubCategory", subcategoryModel.toMap());
    return res;
  }

  Future<bool> editSubCategory(SubCategoryModel subcategoryModel) async {
    var dbClient = await db;
    int res = await dbClient.update("SubCategory", subcategoryModel.toMap(),
        where: "subCategoryId = ?",
        whereArgs: <int>[subcategoryModel.subCategoryId]);
    return res > 0 ? true : false;
  }

  Future<int> deleteSubCategory(SubCategoryModel subcategoryModel) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete(
        'DELETE FROM SubCategory WHERE subCategoryId = ?',
        [subcategoryModel.subCategoryId]);
    return res;
  }

  Future<List<SubCategoryModel>> getSubCategoryList(int categoryId) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM SubCategory  WHERE categoryId = ?', [categoryId]);
    List<SubCategoryModel> subcategoryList = new List();
    for (int i = 0; i < list.length; i++) {
      var categoryModel = new SubCategoryModel(
        list[i]["subCategoryName"],
        list[i]["categoryId"],
        list[i]["position"],
      );
      categoryModel.setSubCategoryId(list[i]["subCategoryId"]);
      print(list[i].toString());
      subcategoryList.add(categoryModel);
    }
    subcategoryList.sort((a, b) => a.position.compareTo(b.position));
    // print(categoryList.toString());
    return subcategoryList;
  }
}
