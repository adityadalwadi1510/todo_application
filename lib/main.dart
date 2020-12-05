import 'package:flutter/material.dart';
import 'package:todo_application/screens/Home.dart';
import 'package:todo_application/screens/NoteDetails.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ToDO App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Home(),
    );
  }


}

