import 'package:flutter/material.dart';
import 'package:todoapp/ui/home.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false, //remove the debug tag from app
    title: "ToDo App",
    home: new Home(),
  ));
}
