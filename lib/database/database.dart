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
    await db.execute('DROP TABLE IF EXISTS Transactions;');
    await db.execute('DROP TABLE IF EXISTS Category;');
    await db.execute('DROP TABLE IF EXISTS SubCategory;');

    await db.execute(
        "CREATE TABLE IF NOT EXISTS Transactions(trxnId INTEGER PRIMARY KEY AUTOINCREMENT, trxnAmount INTEGER, trxnDate TEXT, categoryId INTEGER, subCategoryId INTEGER , description TEXT, imagePath TEXT, entryDate TEXT, lastModifiedDate TEXT)");

    debugPrint('Transaction table created');
    // await db.execute(
    //     "CREATE TABLE IF NOT EXISTS Category(categoryId INTEGER PRIMARY KEY AUTOINCREMENT, categoryName TEXT, categoryType INTEGER , logo TEXT, position INTEGER)");
    // debugPrint('table created');

    // await db.execute(
    //     "CREATE TABLE IF NOT EXISTS SubCategory(subCategoryId INTEGER PRIMARY KEY AUTOINCREMENT, subCategoryName TEXT,categoryId INTEGER, subCategoryType INTEGER , logo TEXT, position INTEGER)");
    // await addCategoriesData();

    // await createCategoryTable(db);
  }

  Future<int> saveTransaction(TransactionModel trxnModel) async {
    var dbClient = await db;
    int res = await dbClient.insert("Transactions", trxnModel.toMap());
    return res;
  }

  Future<List<TransactionModel>> getTrxnList() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Transactions');
    List<TransactionModel> trxnList = new List();
    for (int i = 0; i < list.length; i++) {
      var trxnModel = new TransactionModel(
        list[i]["trxnAmount"],
        list[i]["trxnDate"],
        list[i]["categoryId"],
        list[i]["subCategoryId"],
        list[i]["description"],
        list[i]["imagePath"],
        list[i]["lastModifiedDate"],
      );
      trxnModel.setTrxnId(list[i]["trxnId"]);
      trxnList.add(trxnModel);
    }
    print(trxnList.length);
    return trxnList;
  }

  Future<List<TransactionModel>> getTrxnByCategory(String category) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Transactions');
    List<TransactionModel> trxnList = new List();
    for (int i = 0; i < list.length; i++) {
      var trxnModel = new TransactionModel(
        list[i]["trxnAmount"],
        list[i]["trxnDate"],
        list[i]["categoryId"],
        list[i]["subCategoryId"],
        list[i]["description"],
        list[i]["imagePath"],
        list[i]["lastModifiedDate"],
      );
      trxnModel.setTrxnId(list[i]["trxnId"]);
      trxnList.add(trxnModel);
    }
    print(trxnList.length);
    return trxnList;
  }

  Future<List<TransactionModel>> getDailyTrxnList(String currentdate) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM Transactions WHERE transactiondate = ?', [currentdate]);
    List<TransactionModel> trxnList = new List();
    for (int i = 0; i < list.length; i++) {
      var trxnModel = new TransactionModel(
        list[i]["trxnAmount"],
        list[i]["trxnDate"],
        list[i]["categoryId"],
        list[i]["subCategoryId"],
        list[i]["description"],
        list[i]["imagePath"],
        list[i]["lastModifiedDate"],
      );
      trxnModel.setTrxnId(list[i]["trxnId"]);
      trxnList.add(trxnModel);
    }
    print(trxnList.length);
    return trxnList;
  }

  Future<List<TransactionModel>> getMonthlyTrxnList() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Transactions');
    List<TransactionModel> trxnList = new List();
    for (int i = 0; i < list.length; i++) {
      var trxnModel = new TransactionModel(
        list[i]["trxnAmount"],
        list[i]["trxnDate"],
        list[i]["categoryId"],
        list[i]["subCategoryId"],
        list[i]["description"],
        list[i]["imagePath"],
        list[i]["lastModifiedDate"],
      );
      trxnModel.setTrxnId(list[i]["trxnId"]);
      trxnList.add(trxnModel);
    }
    print(trxnList.length);
    return trxnList;
  }

  Future<int> deleteTrxn(TransactionModel trxnModel) async {
    var dbClient = await db;
    int res = await dbClient
        .rawDelete('DELETE FROM Transactions WHERE id = ?', [trxnModel.trxnId]);
    return res;
  }

  Future<bool> update(TransactionModel trxnModel) async {
    var dbClient = await db;
    int res = await dbClient.update("Transactions", trxnModel.toMap(),
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
          "CREATE TABLE IF NOT EXISTS Category(categoryId INTEGER PRIMARY KEY AUTOINCREMENT, categoryName TEXT, categoryType INTEGER , logo TEXT, position INTEGER)");
      debugPrint('table created');

      await db.execute(
          "CREATE TABLE IF NOT EXISTS SubCategory(subCategoryId INTEGER PRIMARY KEY AUTOINCREMENT, subCategoryName TEXT,categoryId INTEGER, subCategoryType INTEGER , logo TEXT, position INTEGER)");

      await addCategoriesData();
    }
    return true;
  }

  Future<bool> addCategoriesData() async {
    int catId = 0;
    catId = await addCategory(new CategoryModel('Transportation', 0, '', 1));
    await addSubCategory(new SubCategoryModel('Railways', catId, 0, '', 1));
    await addSubCategory(new SubCategoryModel('Roadways', catId, 0, '', 2));
    await addSubCategory(new SubCategoryModel('Airways', catId, 0, '', 3));
    await addSubCategory(new SubCategoryModel('Waterways', catId, 0, '', 4));
    await addSubCategory(new SubCategoryModel('Pipelines', catId, 0, '', 5));

    catId = await addCategory(new CategoryModel('Food', 0, '', 2));
    await addSubCategory(new SubCategoryModel('Lunch', catId, 0, '', 1));
    await addSubCategory(new SubCategoryModel('Dinner', catId, 0, '', 2));
    await addSubCategory(new SubCategoryModel('Eating out', catId, 0, '', 3));
    await addSubCategory(new SubCategoryModel('Beverages', catId, 0, '', 4));
    catId = await addCategory(new CategoryModel('Social Life', 0, '', 3));
    await addSubCategory(new SubCategoryModel('Friend', catId, 0, '', 1));
    await addSubCategory(new SubCategoryModel('Fellowship', catId, 0, '', 2));
    await addSubCategory(new SubCategoryModel('Alumni', catId, 0, '', 3));
    await addSubCategory(new SubCategoryModel('Dues', catId, 0, '', 4));

    catId = await addCategory(new CategoryModel('Self-Development', 0, '', 4));
    catId = await addCategory(new CategoryModel('Culture', 0, '', 5));
    await addSubCategory(new SubCategoryModel('Books', catId, 0, '', 1));
    await addSubCategory(new SubCategoryModel('Movie', catId, 0, '', 2));
    await addSubCategory(new SubCategoryModel('Music', catId, 0, '', 3));
    await addSubCategory(new SubCategoryModel('Apps', catId, 0, '', 4));
    catId = await addCategory(new CategoryModel('Houserhold', 0, '', 6));
    await addSubCategory(new SubCategoryModel('Appliances', catId, 0, '', 1));
    await addSubCategory(new SubCategoryModel('Furniture', catId, 0, '', 2));
    await addSubCategory(new SubCategoryModel('Kitchen', catId, 0, '', 3));
    await addSubCategory(new SubCategoryModel('Toiletries', catId, 0, '', 4));
    await addSubCategory(new SubCategoryModel('Chandlery', catId, 0, '', 5));
    catId = await addCategory(new CategoryModel('Apparel', 0, '', 7));

    await addSubCategory(new SubCategoryModel('Clothing', catId, 0, '', 1));
    await addSubCategory(new SubCategoryModel('Fashion', catId, 0, '', 2));
    await addSubCategory(new SubCategoryModel('Shoes', catId, 0, '', 3));
    await addSubCategory(new SubCategoryModel('Laundry', catId, 0, '', 4));
    catId = await addCategory(new CategoryModel('Beauty', 0, '', 8));
    await addSubCategory(new SubCategoryModel('Cosmetics', catId, 0, '', 1));
    await addSubCategory(new SubCategoryModel('Makeup', catId, 0, '', 2));
    await addSubCategory(new SubCategoryModel('Accessories', catId, 0, '', 3));
    await addSubCategory(new SubCategoryModel('Beauty', catId, 0, '', 4));
    catId = await addCategory(new CategoryModel('Health', 0, '', 9));
    await addSubCategory(new SubCategoryModel('Health', catId, 0, '', 1));
    await addSubCategory(new SubCategoryModel('Yoga', catId, 0, '', 2));
    await addSubCategory(new SubCategoryModel('Hospital', catId, 0, '', 3));
    await addSubCategory(new SubCategoryModel('Medicine', catId, 0, '', 4));
    catId = await addCategory(new CategoryModel('Education', 0, '', 10));
    await addSubCategory(new SubCategoryModel('Schooling', catId, 0, '', 1));
    await addSubCategory(new SubCategoryModel('Textbooks', catId, 0, '', 2));
    await addSubCategory(
        new SubCategoryModel('School suppies', catId, 0, '', 3));
    await addSubCategory(new SubCategoryModel('Academy', catId, 0, '', 4));
    catId = await addCategory(new CategoryModel('Gift', 0, '', 11));
    catId = await addCategory(new CategoryModel('Other', 0, '', 12));

    catId = await addCategory(new CategoryModel('Salary', 1, '', 1));
    catId = await addCategory(new CategoryModel('Allowance', 1, '', 2));
    catId = await addCategory(new CategoryModel('Bonus', 1, '', 3));
    catId = await addCategory(new CategoryModel('Rent', 1, '', 4));
    catId = await addCategory(new CategoryModel('Pension', 1, '', 5));
    catId = await addCategory(new CategoryModel('Other', 1, '', 6));

    // await getCategoryList(1);

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

  Future<List<CategoryModel>> getCategoryList(int categoryType) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM Category WHERE categoryType = ?', [categoryType]);
    List<CategoryModel> categoryList = new List();
    for (int i = 0; i < list.length; i++) {
      var categoryModel = new CategoryModel(
        list[i]["categoryName"],
        list[i]["categoryType"],
        list[i]["logo"],
        list[i]["position"],
      );
      categoryModel.setCategoryId(list[i]["categoryId"]);
      // print(list[i].toString());
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
        list[i]["subCategoryType"],
        list[i]["logo"],
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
