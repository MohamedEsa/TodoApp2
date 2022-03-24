import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class SqfLiteViewModel with ChangeNotifier {
  Database? dataBase;
  bool isFabPressed = false;
  var databasesPath;
  List<Map> tasksList = [];
  List<Map> doneList = [];
  List<Map> archivedList = [];

  //********************** */
  void changeBoolFab() {
    isFabPressed = !isFabPressed;
    notifyListeners();
  }

  SqfLiteViewModel() {
    createDataBase();
  }
  void createDataBase() async {
    notifyListeners();
    dataBase = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (dataBase, version) async {
        try {
          await dataBase.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)');
          print('data base created');
        } catch (e) {
          print(e);
        }
      },
      onOpen: (dataBase) {
        getDatafromDB(dataBase);
        print('database opend');
      },
    );
  }

  void insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    try {
      await dataBase?.transaction((txn) async {
        await txn.rawInsert(
          'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")',
        );
        getDatafromDB(dataBase);
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void updateDatainDB({required String status, required int id}) async {
    dataBase!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDatafromDB(dataBase);

      print('dataUpdated');
    });
    notifyListeners();
  }

  void getDatafromDB(dataBase) {
    tasksList = [];
    doneList = [];
    archivedList = [];
    dataBase!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          tasksList.add(element);
        } else if (element['status'] == 'done') {
          doneList.add(element);
        } else {
          archivedList.add(element);
        }

        notifyListeners();
      });
    });
  }

  void deleteDatafromDB({required int id}) async {
    dataBase!.rawDelete('DELETE FROM tasks  WHERE id = ?', [id]).then((value) {
      getDatafromDB(dataBase);

      print('dataUpdated');
    });
    notifyListeners();
  }
}
