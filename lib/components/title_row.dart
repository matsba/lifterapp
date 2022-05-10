import 'package:flutter/material.dart';

class TitleRow extends StatelessWidget {
  final String title;
  final bool isHeading;

  const TitleRow(this.title, {Key? key, this.isHeading = false})
      : super(key: key);

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
          padding: const EdgeInsets.only(bottom: padding, top: padding)),
    );
  }
}
