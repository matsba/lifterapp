import 'package:flutter/material.dart';

class InfoSnackbarBuilder {
  final String title;
  final String? subtitle;
  final bool isError;
  final IconData icon;

  InfoSnackbarBuilder(
      {required this.title,
      required this.icon,
      this.subtitle,
      this.isError = false});

  Text _title() {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Icon _icon() {
    return Icon(icon, color: Colors.white);
  }

  show(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: isError
          ? Colors.redAccent
          : Theme.of(context).snackBarTheme.backgroundColor,
      duration: const Duration(seconds: 2),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_icon(), const SizedBox(width: 8), _title()],
            ),
            subtitle != null ? Text(subtitle!) : const SizedBox()
          ],
        ),
      ),
    ));
  }
}
