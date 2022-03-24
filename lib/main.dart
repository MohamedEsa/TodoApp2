import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todosqflite/layout/todo_layout.dart';
import 'package:todosqflite/view_model/sqflite_view_model.dart';
import 'package:todosqflite/view_model/todo_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoViewModel>(
          create: (context) => TodoViewModel(),
        ),
        ChangeNotifierProvider<SqfLiteViewModel>(
          create: (context) => SqfLiteViewModel()..createDataBase(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TodoLayout(),
      ),
    );
  }
}
