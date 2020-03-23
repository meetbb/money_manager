import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneymanager/database/database.dart';
import 'package:moneymanager/database/model/category_model.dart';
import 'package:moneymanager/database/model/subcategory_model.dart';

class AddEditCategoryPage extends StatefulWidget {
  bool isEdit = false;
  bool isCategory = true;
  CategoryModel category;
  SubCategoryModel subCategory;

  // int editIndex = 0;
  // int categoryIndex = 0;

  AddEditCategoryPage(
      {Key key,
      @required this.isEdit,
      // this.editIndex,
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
        title: Text(widget.isCategory == true ? 'Expenses Category' : 'Expenses Sub Category'),
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
                  labelText: 'Enter Sub Category',
                  hintText: 'Enter Sub Category'),
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

                            await DatabaseHelper()
                                .editCategory(widget.category);
                          }

                          Navigator.pop(context, true);
                        } else {
                          if (widget.category.categoryName !=
                              categoryNameController.text) {
                            // showAlert(context, 'Don\'t enter same name');
                            // return;
                            widget.subCategory.subCategoryName =
                                categoryNameController.text;

                            await DatabaseHelper()
                                .editSubCategory(widget.subCategory);
                          }
                          Navigator.pop(context, true);
                        }
                      } else {
                        if (widget.isCategory == true) {
                          List<CategoryModel> categoryList =
                              await DatabaseHelper().getCategoryList();

                          await DatabaseHelper().addCategory(new CategoryModel(
                              categoryNameController.text,
                              categoryList.last.position + 1));

                          Navigator.pop(context, true);
                        } else {
                          List<SubCategoryModel> subcategoryList =
                              await DatabaseHelper().getSubCategoryList(
                                  widget.category.categoryId);
                          int position = 0;
                          if (subcategoryList.length > 0) {
                            position = subcategoryList.last.position;
                          }
                          await DatabaseHelper().addSubCategory(
                              new SubCategoryModel(
                                  categoryNameController.text,
                                  widget.category.categoryId,
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
