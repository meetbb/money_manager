import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneymanager/database/database.dart';
import 'package:moneymanager/database/model/category_model.dart';
import 'package:moneymanager/database/model/subcategory_model.dart';
import 'package:moneymanager/utilities/constants.dart';
import 'package:moneymanager/utilities/utils.dart';
import 'package:moneymanager/views/add_edit_category.dart';
import 'package:moneymanager/views/subcategory_list.dart';

class CategoryListPage extends StatefulWidget {
  final int categoryType;
  CategoryListPage({
    Key key,
    this.categoryType,
  });

  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  List<CategoryModel> categoryList = List();
  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > categoryList.length) newIndex = categoryList.length;
        if (oldIndex < newIndex) newIndex--;
        final dynamic item = categoryList.removeAt(oldIndex);
        categoryList.insert(newIndex, item);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  getCategories() async {
    // await DatabaseHelper().createCategoryTable(await DatabaseHelper().db);
    categoryList = await databaseHelper.getCategoryList(widget.categoryType);

    setState(() {});
  }

  Future<String> getSubCategoryCount(index) async {
    List<SubCategoryModel> subcategoryList =
        await databaseHelper.getSubCategoryList(categoryList[index].categoryId);
    if (subcategoryList.length > 0) {
      return subcategoryList.length.toString();
    } else {
      return '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text( widget.categoryType ==0 ? 'Expenses Category': 'Income Category'),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () async {
                  var isAddOrEdit = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEditCategoryPage(
                              categoryType: widget.categoryType,
                              isEdit: false,
                              isCategory: true,
                            )),
                  );
                  if (isAddOrEdit != null) {
                    categoryList = await databaseHelper
                        .getCategoryList(widget.categoryType);

                    setState(() {});
                  }
                })
          ],
        ),
        body: SafeArea(
          child: categoryList.length == 0
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ReorderableListView(
                  onReorder: _onReorder,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  children: List.generate(categoryList.length, (index) {
                    return Container(
                      key: Key('$index'),
                      child: FutureBuilder<String>(
                          future: getSubCategoryCount(index), //
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            return GestureDetector(
                              onTap: () async {
                                // if (subCategories.length > 0) {
                                if (widget.categoryType == 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SubCategoryListPage(
                                              category: categoryList[index],
                                            )),
                                  );
                                }
                                // }
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          showAlertWithConfirmation(context,
                                              'Are you sure want to delete ?',
                                              () async {
                                            databaseHelper.deleteCategory(
                                                categoryList[index]);
                                            categoryList = await databaseHelper
                                                .getCategoryList(
                                                    widget.categoryType);
                                            // categoryList.removeAt(index);
                                            setState(() {});
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Icon(
                                            Icons.remove_circle,
                                            color: Colors.red.withOpacity(0.7),
                                            size: 28,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                          child: Text(
                                        snapshot.hasData
                                            ? categoryList[index].categoryName +
                                                ' (' +
                                                snapshot.data +
                                                ')'
                                            : categoryList[index].categoryName,
                                        style: TextStyle(fontSize: 16),
                                      )),
                                      GestureDetector(
                                        onTap: () async {
                                          //edit clicked
                                          var isAddOrEdit =
                                              await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddEditCategoryPage(
                                                      categoryType: widget.categoryType,
                                                      isEdit: true,
                                                      isCategory: true,
                                                      category:
                                                          categoryList[index],
                                                    )),
                                          );
                                          if (isAddOrEdit != null) {
                                            categoryList = await databaseHelper
                                                .getCategoryList(
                                                    widget.categoryType);
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {},
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Icon(
                                            Icons.list,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 0.5,
                                    color: Colors.grey.withOpacity(0.5),
                                  )
                                ],
                              ),
                            );
                          }),
                    );
                  }),
                ),
        ));
  }
}
