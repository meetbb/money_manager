import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneymanager/database/database.dart';
import 'package:moneymanager/database/model/category_model.dart';
import 'package:moneymanager/database/model/subcategory_model.dart';
import 'package:moneymanager/utilities/constants.dart';

class AddEditCategoryPage extends StatefulWidget {
  int categoryType;
  bool isEdit = false;
  bool isCategory = true;
  CategoryModel category;
  SubCategoryModel subCategory;

  // int editIndex = 0;
  // int categoryIndex = 0;

  AddEditCategoryPage(
      {Key key,
      @required this.isEdit,
      this.categoryType,
      this.isCategory,
      this.category,
      this.subCategory});

  @override
  _AddEditCategoryPageState createState() => _AddEditCategoryPageState();
}

class _AddEditCategoryPageState extends State<AddEditCategoryPage> {
  TextEditingController categoryNameController = new TextEditingController();
  bool saveButtonEnabled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isEdit == true) {
      if (widget.isCategory == true) {
        categoryNameController.text = widget.category.categoryName;
      } else {
        categoryNameController.text = widget.subCategory.subCategoryName;
      }
      saveButtonEnabled = true;
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isCategory == true
            ? 'Expenses Category'
            : 'Expenses Sub Category'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              maxLength: 50,
              controller: categoryNameController,
              onChanged: (text) {
                if (text.length == 0) {
                  saveButtonEnabled = false;
                } else {
                  saveButtonEnabled = true;
                }
                setState(() {});
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText:
                    widget.isCategory ? 'Enter Category' : 'Enter Sub Category',
                hintText:
                    widget.isCategory ? 'Enter Category' : 'Enter Sub Category',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.blue.withOpacity(0.5),
              disabledTextColor: Colors.white,
              padding: EdgeInsets.all(16.0),
              splashColor: Colors.blueAccent,
              onPressed: saveButtonEnabled == true
                  ? () async {
                      if (widget.isEdit) {
                        if (widget.isCategory == true) {
                          if (widget.category.categoryName !=
                              categoryNameController.text) {
                            // showAlert(context, 'Don\'t enter same name');
                            // return;
                            widget.category.categoryName =
                                categoryNameController.text;

                            databaseWrapper.editCategory(widget.category);
                          }

                          Navigator.pop(context, true);
                        } else {
                          if (widget.category.categoryName !=
                              categoryNameController.text) {
                            // showAlert(context, 'Don\'t enter same name');
                            // return;
                            widget.subCategory.subCategoryName =
                                categoryNameController.text;

                            databaseWrapper.editSubCategory(widget.subCategory);
                          }
                          Navigator.pop(context, true);
                        }
                      } else {
                        if (widget.isCategory == true) {
                          List<CategoryModel> categoryList =
                              await databaseWrapper.getCategoryList(widget.categoryType);

                          databaseHelper.addCategory(new CategoryModel(
                            categoryNameController.text,
                            widget.categoryType,
                            '',
                            categoryList.last.position + 1,
                          ));

                          Navigator.pop(context, true);
                        } else {
                          List<SubCategoryModel> subcategoryList =
                              await  databaseWrapper.getSubCategoryList(
                                  widget.category.categoryId);
                          int position = 0;
                          if (subcategoryList.length > 0) {
                            position = subcategoryList.last.position;
                          }
                          await  databaseHelper.addSubCategory(
                              new SubCategoryModel(
                                  categoryNameController.text,
                                  widget.category.categoryId,
                                  0,
                                  '',
                                  position + 1));

                          Navigator.pop(context, true);
                        }
                      }
                    }
                  : null,
              child: Text(
                "Save",
                style: TextStyle(fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
