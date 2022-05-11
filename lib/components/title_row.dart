import 'package:flutter/material.dart';

class TitleRow extends StatelessWidget {
  final String title;
  final bool isHeading;
  final Color? color;

  const TitleRow(this.title, {this.isHeading = false, this.color});

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
                    ? Theme.of(context)
                        .textTheme
                        .headline1
                        ?.copyWith(color: color)
                    : Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(color: color),
              ),
            ],
          ),
          padding: const EdgeInsets.only(bottom: padding, top: padding)),
    );
  }
}
