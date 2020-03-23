import 'package:flutter/cupertino.dart';
import 'package:moneymanager/database/database.dart';
import 'package:moneymanager/database/model/category_model.dart';
import 'package:moneymanager/database/model/subcategory_model.dart';

class CategorySelection extends StatefulWidget {
  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  List<CategoryModel> categoryList = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getCategories() async {
    categoryList = await DatabaseHelper().getCategoryList();
    setState(() {});
  }

  Future<List<SubCategoryModel>> getSubCategories(int catId) async {
    List<SubCategoryModel> subCategoryList =
        await DatabaseHelper().getSubCategoryList(catId);
    return subCategoryList;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
