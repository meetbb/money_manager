import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/database/database.dart';
import 'package:moneymanager/database/model/budget_model.dart';
import 'package:moneymanager/utlis/asset_utils.dart';
import 'package:moneymanager/views/blocs/budget_bloc.dart';
import 'package:moneymanager/views/budget/budget_interactor.dart';
import 'package:moneymanager/views/budget/budget_screen.dart';
import 'package:moneymanager/views/budget/validator.dart';
import 'package:moneymanager/views/uiwidgets/category_icons.dart';

class AddBudgetScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AddBudgetScreenState();
  }
}

class AddBudgetScreenState extends State<AddBudgetScreen> {
  final selectCategoryBloc = new SelectCategoryBloc();
  final recurrenceBloc = new RecurrenceBloc();
  final startDateBloc = new StartDateBloc();
  final endDateBloc = new EndDateBloc();
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  TextEditingController budgetNameController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();
  List<String> categoryList = [
    "HomeExpense",
    "Food",
    "Rent",
    "Salary",
    "Shopping"
  ];
  List<String> categoeyIconList = [
    AssetUtils.HOME_WIDGET,
    AssetUtils.FOOD_WIDGET,
    AssetUtils.RENT_WIDGET,
    AssetUtils.SALARY_WIDGET,
    AssetUtils.SHOPPING_WIDGET
  ];

  List<String> recurrenceList = [
    "Daily",
    "Weekly",
    "Monthly",
    "Yearly",
  ];
  String budgetCategory = '';
  String budgetRecurrence = '';
  String budgetStartDate = '';
  String budgetEndDate = '';
  BudgetBloc _budgetBloc;
  StreamSubscription _subscription;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    createBudget();
    var dbHelper = new DatabaseHelper();
    _budgetBloc = BudgetBloc(BudgetInteractorImpl(dbHelper));
    _subscription = _budgetBloc.message$.listen(_handleBudgetMessage);
  }

  @override
  void dispose() {
    super.dispose();
    _budgetBloc.dispose();
    _subscription.cancel();
    selectCategoryBloc.dispose();
    recurrenceBloc.dispose();
    startDateBloc.dispose();
    endDateBloc.dispose();
  }

  Future<Null> _selectDate(
      BuildContext context, DateTime date, Function getPickedDate) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      getPickedDate(picked);
    }
  }

  void createBudget() {
    var dbHelper = new DatabaseHelper();
    dbHelper.createBudgetTable();
  }

  ///Helper method
  void _showSnackBar(String msg) {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Here, we can show SnackBar or navigate to other page based on [message]
  void _handleBudgetMessage(BudgetMessage message) async {
    if (message is BudgetSuccessMessage) {
      _showSnackBar('Budget added successfully');
      return;
    }
    if (message is BudgetErrorMessage) {
      return _showSnackBar(message.error.toString());
    }
    if (message is InvalidInformationMessage) {
      return _showSnackBar('Invalid information');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.5,
        title: Text(
          'ADD BUDGET',
          style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black87),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: StreamBuilder<Set<ValidationError>>(
                    stream: _budgetBloc.budgetNameError$,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: budgetNameController,
                        onChanged: _budgetBloc.budgetNameChanged,
                        decoration: InputDecoration(
                          hintText: 'Budget name',
                          errorText: _getErrorMessage(snapshot.data),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: SvgPicture.asset(
                              AssetUtils.BUDGET_WIDGET,
                              width: 12,
                              height: 12,
                              color: Colors.blue,
                            ),
                          ),
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 4.0),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        validator: (value) {
                          if (value.length == 0) {
                            return 'Budget name is empty!';
                          } else {
                            return null;
                          }
                        },
                      );
                    }),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: StreamBuilder<Set<ValidationError>>(
                    stream: _budgetBloc.budgetAmountError$,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: amountController,
                        onChanged: _budgetBloc.budgetAmountChanged,
                        decoration: InputDecoration(
                          hintText: 'Amount',
                          errorText: _getErrorMessage(snapshot.data),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: SvgPicture.asset(
                              AssetUtils.RUPEE_WIDGET,
                              width: 12,
                              height: 12,
                              color: Colors.blue,
                            ),
                          ),
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 4.0),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        validator: (value) {
                          if (value.length == 0) {
                            return 'Amount is empty!';
                          } else {
                            return null;
                          }
                        },
                      );
                    }),
              ),
              SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () {
                  showCategories(context, (selectedCategory) {
                    budgetCategory = selectedCategory;
                    _budgetBloc.budgetCategoryChanged(budgetCategory);
                    selectCategoryBloc.updateCategory(selectedCategory);
                  }, categoryList, isRecurrenceDialog: false);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 10.0),
                      child: SvgPicture.asset(
                        AssetUtils.BUDGET_WIDGET,
                        width: 20,
                        height: 20,
                        color: Colors.blue,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Budget for',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87),
                      ),
                    ),
                    StreamBuilder<String>(
                        stream: selectCategoryBloc.selectedCategoryStream,
                        builder: (context, snapshot) {
                          String category = '';
                          if (snapshot.hasData) {
                            category = '${snapshot.data} >';
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: <Widget>[
                                HeaderText(
                                  text: category,
                                  fontColor: Colors.blue,
                                ),
                              ],
                            ),
                          );
                        })
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () {
                  showCategories(context, (selectedCategory) {
                    budgetRecurrence = selectedCategory;
                    _budgetBloc.budgetRecurrenceChanged(selectedCategory);
                    recurrenceBloc.updateRecurrence(budgetRecurrence);
                  }, recurrenceList,
                      isRecurrenceDialog: true, header: "Recurrence");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 10.0),
                      child: SvgPicture.asset(
                        AssetUtils.FREQUENCY_WIDGET,
                        width: 22,
                        height: 22,
                        color: Colors.blue,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Recurrence',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87),
                      ),
                    ),
                    StreamBuilder<String>(
                        stream: recurrenceBloc.recurrenceStream,
                        builder: (context, snapshot) {
                          String category = '';
                          if (snapshot.hasData) {
                            category = '${snapshot.data} >';
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: HeaderText(
                              text: category,
                              fontColor: Colors.blue,
                            ),
                          );
                        })
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () {
                  _selectDate(context, selectedStartDate, (pickedDate) {
                    selectedStartDate = pickedDate;
                    String newFormattedDate =
                        new DateFormat("dd-MM-yyyy").format(pickedDate);
                    budgetStartDate = newFormattedDate;
                    _budgetBloc.budgetStartDateChanged(budgetStartDate);
                    startDateBloc.updateStartDate(budgetStartDate);
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 10.0),
                      child:
                          Icon(Icons.date_range, size: 20, color: Colors.blue),
                    ),
                    StreamBuilder<String>(
                      stream: startDateBloc.startDateStream,
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ?? 'Starting Date',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: Colors.black12,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  _selectDate(context, selectedEndDate, (pickedDate) {
                    selectedEndDate = pickedDate;
                    String newFormattedDate =
                        new DateFormat("dd-MM-yyyy").format(pickedDate);
                    budgetEndDate = newFormattedDate;
                    _budgetBloc.budgetEndDateChanged(budgetEndDate);
                    endDateBloc.updateEndDate(budgetEndDate);
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 10.0),
                      child:
                          Icon(Icons.date_range, size: 20, color: Colors.blue),
                    ),
                    StreamBuilder<String>(
                      stream: endDateBloc.endDateStream,
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ?? 'Ending Date',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: Colors.black12,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 10.0),
                    child: Icon(Icons.notifications_active,
                        size: 22, color: Colors.blue),
                  ),
                  Expanded(
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Switch(value: true, onChanged: (isSelected) {}),
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: Colors.black12,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: FlatButton(
                  color: Colors.blue,
                  onPressed: () {
                    _budgetBloc.submitBudget();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: Text(
                      'CREATE A BUDGET',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 19,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // void createNewBudget() async {
  //   BudgetModel model = new BudgetModel(
  //       0101,
  //       budgetNameController.text,
  //       amountController.text,
  //       budgetCategory,
  //       budgetRecurrence,
  //       budgetStartDate,
  //       budgetEndDate,
  //       "Yes");
  //   var dbHelper = new DatabaseHelper();
  //   int integerSaveBudget = await dbHelper.saveBudget(model);
  //   if (integerSaveBudget > 0) {
  //     debugPrint("Budget Saved Successfully");
  //   } else {}
  // }

  void showCategories(BuildContext context, Function _onCategorySelection,
      List<String> gridList,
      {bool isRecurrenceDialog = false, String header = "Select Category"}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(left: 16.0, top: 10.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: ValueText(text: header),
                ),
                (isRecurrenceDialog)
                    ? ListView.builder(
                        itemCount: gridList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            _onCategorySelection(gridList[index]);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              gridList[index],
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      )
                    : GridView.builder(
                        physics:
                            NeverScrollableScrollPhysics(), //kill scrollable
                        shrinkWrap: true,
                        itemCount: gridList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              _onCategorySelection(gridList[index]);
                            },
                            child: Card(
                              elevation: 0.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CategoryWidget(
                                      iconName: categoeyIconList[index],
                                      size: 60,
                                      padding: 15,
                                      iconSize: 20),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      categoryList[index],
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Here, we can return localized description from [errors]
  String _getErrorMessage(Set<ValidationError> errors) {
    if (errors == null || errors.isEmpty) {
      return null;
    }
    if (errors.contains(ValidationError.invalidBudgetName)) {
      return 'Invalid Budget Name';
    }
    if (errors.contains(ValidationError.invalidAmount)) {
      return 'Invalid amount added';
    }
    if (errors.contains(ValidationError.invalidCategory)) {
      return 'Invalid Category';
    }
    if (errors.contains(ValidationError.invalidRecurrence)) {
      return 'Invalid Recurrence';
    }
    if (errors.contains(ValidationError.invalidStartDate)) {
      return 'Invalid Start Date selected';
    }
    if (errors.contains(ValidationError.invalidEndDate)) {
      return 'Invalid End Date selected';
    }
    return null;
  }
}

class SelectCategoryBloc {
  StreamController<String> controller =
      new StreamController<String>.broadcast();

  void updateCategory(String counter) {
    controller.sink.add(counter);
  }

  void dispose() {
    controller.close();
  }

  Stream get selectedCategoryStream => controller.stream;
}

class RecurrenceBloc {
  StreamController<String> controller =
      new StreamController<String>.broadcast();

  void updateRecurrence(String counter) {
    controller.sink.add(counter);
  }

  void dispose() {
    controller.close();
  }

  Stream get recurrenceStream => controller.stream;
}

class StartDateBloc {
  StreamController<String> controller =
      new StreamController<String>.broadcast();

  void updateStartDate(String counter) {
    controller.sink.add(counter);
  }

  void dispose() {
    controller.close();
  }

  Stream get startDateStream => controller.stream;
}

class EndDateBloc {
  StreamController<String> controller =
      new StreamController<String>.broadcast();

  void updateEndDate(String counter) {
    controller.sink.add(counter);
  }

  void dispose() {
    controller.close();
  }

  Stream get endDateStream => controller.stream;
}
