import 'package:flutter/material.dart';

class InfoText extends StatelessWidget {
  final String text;

  const InfoText(this.text, {Key? super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
            style: const TextStyle(color: Colors.grey, fontSize: 12)));
  }
}
