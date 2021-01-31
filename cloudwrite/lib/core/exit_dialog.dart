import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Function exitDialog(BuildContext context) {
  return () {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirm Exit"),
            content: Text("Are you sure you want to exit?"),
            actions: <Widget>[
              FlatButton(
                child: Text("YES"),
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
              FlatButton(
                child: Text("NO"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
    return Future.value(true);
  };
}
