import 'package:flutter/material.dart';
import 'package:lifterapp/redux_app.dart';
import 'package:lifterapp/store/store.dart';

void main() {
  final store = createStore();
  runApp(ReduxApp(store: store));
}
