import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneymanager/database/database.dart';
import 'package:moneymanager/database/model/category_model.dart';
import 'package:moneymanager/database/model/subcategory_model.dart';
import 'package:moneymanager/utilities/constants.dart';
import 'package:moneymanager/views/category_list.dart';

class CategorySelection extends StatefulWidget {
  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  // List<CategoryModel> categoryList = List();

  @override
  void initState() {
    super.initState();
    // getCategories();
  }

  Future<List<CategoryModel>> getCategories() async {
    List<CategoryModel> categoryList = await databaseHelper.getCategoryList();
    // setState(() {});
    return categoryList;
  }

  void choiceAction(String choice) {
    if (choice == 'Edit') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategoryListPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Category/Sub Category"),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return ['Edit'].map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ]),
      body: FutureBuilder<List<CategoryModel>>(
          future: getCategories(), //
          builder: (BuildContext context,
              AsyncSnapshot<List<CategoryModel>> snapshot) {
            return snapshot.hasData
                ? new ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return new ExpandableListView(
                          category: snapshot.data[index]);
                    },
                    itemCount: snapshot.data.length,
                  )
                : CircularProgressIndicator();
          }),
    );
  }
}

class ExpandableListView extends StatefulWidget {
  final CategoryModel category;

  ExpandableListView({Key key, this.category}) : super(key: key);

  @override
  _ExpandableListViewState createState() => new _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;

  Future<List<SubCategoryModel>> getSubCategories(int catId) async {
    List<SubCategoryModel> subCategoryList =
        await databaseHelper.getSubCategoryList(catId);
    return subCategoryList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: new ExpansionTile(
        onExpansionChanged: (isExpaded) async {
          List<SubCategoryModel> subCategoryList =
              await getSubCategories(widget.category.categoryId);
          if (subCategoryList.length == 0) {
            List<dynamic> selectedCategories = List();
            selectedCategories.add(widget.category);
            Navigator.pop(context, selectedCategories);
          }
        },
        title: Row(
          children: <Widget>[
            new Container(
              height: 40,
              width: 40,
              decoration: new BoxDecoration(
                  color: UniqueColorGenerator.getColor(),
                  borderRadius: new BorderRadius.all(
                    Radius.circular(40.0),
                  )),
              child: Center(
                  child: Text(
                '${widget.category.categoryName[0]}',
                style: new TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              )),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: new Text(
                widget.category.categoryName,
                style: new TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue),
              ),
            ),
          ],
        ),
        children: <Widget>[
          Column(
            children: <Widget>[
              FutureBuilder<List<SubCategoryModel>>(
                  future: getSubCategories(widget.category.categoryId),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<SubCategoryModel>> snapshot) {
                    return snapshot.hasData
                        ? new ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  debugPrint('Category : ' +
                                      widget.category.categoryName +
                                      ' Subcateogry : ' +
                                      snapshot.data[index].subCategoryName);
                                  List<dynamic> selectedCategories = List();
                                  selectedCategories.add(widget.category);
                                  selectedCategories.add(snapshot.data[index]);

                                  Navigator.pop(context, selectedCategories);
                                },
                                child: new Container(
                                  child: new ListTile(
                                    title: new Text(
                                      snapshot.data[index].subCategoryName,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black54),
                                    ),
                                    leading: new Icon(
                                      Icons.local_pizza,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: snapshot.data.length,
                          )
                        : Container();
                  })
            ],
          ),
        ],
      ),
    );
  }
}
