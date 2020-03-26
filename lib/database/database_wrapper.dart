import 'package:moneymanager/database/model/category_model.dart';
import 'package:moneymanager/database/model/subcategory_model.dart';
import 'package:moneymanager/database/model/transaction_model.dart';
import 'package:moneymanager/utilities/constants.dart';

class DatabaseWrapper {
  // Transaction
  Future<List<TransactionModel>> getTrxnList() async {
    var dbClient = await databaseHelper.db;
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

  Future<List<TransactionModel>> getTrxnListByDate(
      String startDate, String endDate) async {
    var dbClient = await databaseHelper.db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM Transactions WHERE trxnDate BETWEEN ? AND ?;',
        [startDate, endDate]);
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
    var dbClient = await databaseHelper.db;
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

  Future<bool> updateTransaction(TransactionModel trxnModel) async {
    var dbClient = await databaseHelper.db;
    int res = await dbClient.update("Transactions", trxnModel.toMap(),
        where: "trxnId = ?", whereArgs: <int>[trxnModel.trxnId]);
    return res > 0 ? true : false;
  }

  // Category
  Future<bool> editCategory(CategoryModel categoryModel) async {
    var dbClient = await databaseHelper.db;
    int res = await dbClient.update("Category", categoryModel.toMap(),
        where: "categoryId = ?", whereArgs: <int>[categoryModel.categoryId]);
    return res > 0 ? true : false;
  }

  Future<CategoryModel> getCategory(int categoryId) async {
    var dbClient = await databaseHelper.db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM Category WHERE categoryId = ?', [categoryId]);
    List<CategoryModel> categoryList = new List();
    for (int i = 0; i < list.length; i++) {
      CategoryModel categoryModel = new CategoryModel(
        list[i]["categoryName"],
        list[i]["categoryType"],
        list[i]["logo"],
        list[i]["position"],
      );
      categoryModel.setCategoryId(list[i]["categoryId"]);
      categoryList.add(categoryModel);
    }
    if (categoryList.length == 0) {
      return null;
    }
    return categoryList[0];
  }

  Future<List<CategoryModel>> getCategoryList(int categoryType) async {
    var dbClient = await databaseHelper.db;
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


  // Sub Category
  Future<bool> editSubCategory(SubCategoryModel subcategoryModel) async {
    var dbClient = await databaseHelper.db;
    int res = await dbClient.update("SubCategory", subcategoryModel.toMap(),
        where: "subCategoryId = ?",
        whereArgs: <int>[subcategoryModel.subCategoryId]);
    return res > 0 ? true : false;
  }

  Future<List<SubCategoryModel>> getSubCategoryList(int categoryId) async {
    var dbClient = await databaseHelper.db;
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

  Future<SubCategoryModel> getSubCategory(int subCategoryId) async {
    var dbClient = await databaseHelper.db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM SubCategory WHERE subCategoryId = ?', [subCategoryId]);
    List<SubCategoryModel> subcategoryList = new List();
    for (int i = 0; i < list.length; i++) {
      SubCategoryModel categoryModel = new SubCategoryModel(
        list[i]["subCategoryName"],
        list[i]["categoryId"],
        list[i]["subCategoryType"],
        list[i]["logo"],
        list[i]["position"],
      );
      categoryModel.setSubCategoryId(list[i]["subCategoryId"]);
      subcategoryList.add(categoryModel);
    }
    if (subcategoryList.length == 0) {
      return null;
    }
    return subcategoryList[0];
  }

}
