import 'package:cloudwrite/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasePageContainer extends StatelessWidget {
  final Widget child;

  const BasePageContainer({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Center(
            child: Container(
                width: context.screenWidth() * 0.9,
                child: child)));
  }
}
