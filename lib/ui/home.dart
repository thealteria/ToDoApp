import 'package:flutter/material.dart';
import 'package:todoapp/ui/util/todo_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: new Text("ToDo App"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => debugPrint("Menu pressed"),
          ),
          backgroundColor: Colors.redAccent),
      body: ToDoScreen(),
    );
  }
}
