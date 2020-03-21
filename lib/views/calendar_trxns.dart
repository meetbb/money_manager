import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWiseTransactions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CalendarWiseTransactionSate();
  }
}

class CalendarWiseTransactionSate extends State<CalendarWiseTransactions> {
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
        locale: 'en_US',
        calendarStyle: CalendarStyle(
          selectedColor: Colors.blueAccent[400],
          todayColor: Colors.blue[200],
          markersColor: Colors.white,
          weekdayStyle: TextStyle(color: Colors.black87),
          outsideStyle: TextStyle(color: Colors.grey),
          outsideDaysVisible: false,
        ),
        calendarController: _calendarController);
  }
}
