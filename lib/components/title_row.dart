import 'package:flutter/material.dart';

class TitleRow extends StatelessWidget {
  String title;
  bool isHeading;

  TitleRow(this.title, {this.isHeading = false});

  @override
  Widget build(BuildContext context) {
    const double padding = 8.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
          child: Row(
            children: [
              Text(
                title,
                style: isHeading
                    ? Theme.of(context).textTheme.headline1
                    : Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
          padding: EdgeInsets.only(bottom: padding, top: padding)),
    );
  }
}
