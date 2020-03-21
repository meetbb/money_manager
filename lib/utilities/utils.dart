import 'package:flutter/material.dart';
import 'package:moneymanager/utilities/constants.dart';

void showAlert(BuildContext context, String message) {
  showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text(appName),
        content: new Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ));
}

void showAlertWithConfirmation(
    BuildContext context, String message, Function onConfirm) {
  showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text(appName),
        content: new Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
          )
        ],
      ));
}
