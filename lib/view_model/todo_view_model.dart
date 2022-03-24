import 'package:flutter/material.dart';
import 'package:todosqflite/screens/archived_screen.dart';
import 'package:todosqflite/screens/done_screen.dart';
import 'package:todosqflite/screens/tasks_screen.dart';
import 'package:provider/provider.dart';

class TodoViewModel with ChangeNotifier {
  int currentIndex = 0;

  List<Widget> screens = [
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];
  notifyListeners();

  List<String> titles = [
    'Task',
    'Done',
    'Archived',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
