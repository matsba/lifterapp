import 'package:flutter/material.dart';

class InfoText extends StatelessWidget {
  String text;

  InfoText(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
            style: const TextStyle(color: Colors.grey, fontSize: 12)));
  }
}
