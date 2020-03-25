import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneymanager/database/database.dart';
import 'package:moneymanager/views/budget/budget_screen.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 1.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.save,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.report_problem,
              color: Colors.black,
            ),
          )
        ],
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
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Budget name',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    child: SvgPicture.asset(
                      'assets/rupee.svg',
                      width: 12,
                      height: 12,
                      color: Colors.blue,
                    ),
                  ),
                  contentPadding:
                      new EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
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
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Amount',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    child: SvgPicture.asset(
                      'assets/rupee.svg',
                      width: 12,
                      height: 12,
                      color: Colors.blue,
                    ),
                  ),
                  contentPadding:
                      new EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
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
              ),
            ),
            SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: () {
                showCategories(context, (selectedCategory) {
                  selectCategoryBloc.updateCategory(selectedCategory);
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 10.0),
                    child: SvgPicture.asset(
                      'assets/rupee.svg',
                      width: 20,
                      height: 20,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    'Budget for',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87),
                  ),
                  StreamBuilder<String>(
                      stream: selectCategoryBloc.selectedCategoryStream,
                      builder: (context, snapshot) {
                        String category = '';
                        if (snapshot.hasData) {
                          category = '- ${snapshot.data}';
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
                showCategories(context, (selectedCategory) {
                  recurrenceBloc.updateRecurrence('Monthly');
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 10.0),
                    child: SvgPicture.asset(
                      'assets/rupee.svg',
                      width: 20,
                      height: 20,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    'Recurrence',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87),
                  ),
                  StreamBuilder<String>(
                      stream: recurrenceBloc.recurrenceStream,
                      builder: (context, snapshot) {
                        String category = '';
                        if (snapshot.hasData) {
                          category = '- ${snapshot.data}';
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
                  startDateBloc
                      .updateStartDate("${pickedDate.toLocal()}".split(' ')[0]);
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 10.0),
                    child: Icon(Icons.date_range, size: 20, color: Colors.blue),
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
                      }),
                  StreamBuilder<String>(
                      stream: recurrenceBloc.recurrenceStream,
                      builder: (context, snapshot) {
                        String category = '';
                        if (snapshot.hasData) {
                          category = '- ${snapshot.data}';
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
                  endDateBloc
                      .updateEndDate("${pickedDate.toLocal()}".split(' ')[0]);
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 10.0),
                    child: Icon(Icons.date_range, size: 20, color: Colors.blue),
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
                      }),
                  StreamBuilder<String>(
                      stream: recurrenceBloc.recurrenceStream,
                      builder: (context, snapshot) {
                        String category = '';
                        if (snapshot.hasData) {
                          category = '- ${snapshot.data}';
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
            InkWell(
              onTap: () {
                showCategories(context, (selectedCategory) {
                  recurrenceBloc.updateRecurrence('Monthly');
                });
              },
              child: Row(
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
                  var dbHelper = new DatabaseHelper();
                  dbHelper.createBudgetTable();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
      )),
    );
  }

  void showCategories(BuildContext context, Function _onCategorySelection) {
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
                    child: ValueText(text: 'Select Category'),
                  ),
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(), //kill scrollable
                    shrinkWrap: true,
                    itemCount: 9,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          _onCategorySelection('Shopping');
                        },
                        child: Card(
                          elevation: 0.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SalaryWidget(
                                size: 60,
                                padding: 15,
                                iconSize: 20,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  'Category',
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
        });
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
