import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todosqflite/shared/components/components.dart';
import 'package:todosqflite/view_model/sqflite_view_model.dart';
import 'package:todosqflite/view_model/todo_view_model.dart';

class TodoLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoViewModel>(builder: (context, model, _) {
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('${model.titles[model.currentIndex]}'),
        ),
        body: model.screens[model.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: model.currentIndex,
          onTap: (index) {
            model.changeIndex(index);
          },
          items: [
            BottomNavigationBarItem(label: 'Tasks', icon: Icon(Icons.menu)),
            BottomNavigationBarItem(
                label: 'Done', icon: Icon(Icons.done_rounded)),
            BottomNavigationBarItem(
                label: 'Archived', icon: Icon(Icons.archive_outlined))
          ],
        ),
        floatingActionButton: Consumer<SqfLiteViewModel>(
          builder: (context, model, _) => FloatingActionButton(
            child: model.isFabPressed ? Icon(Icons.add) : Icon(Icons.edit),
            onPressed: () {
              if (model.isFabPressed) {
                if (formKey.currentState!.validate()) {
                  model.insertToDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text);
                  Navigator.pop(context);
                  model.isFabPressed = true;
                }
              } else {
                scaffoldKey.currentState
                    ?.showBottomSheet((context) => Container(
                          color: Colors.grey[200],
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defualtTextFormField(
                                  controller: titleController,
                                  onTap: () {
                                    print('title tapped');
                                  },
                                  prefixIcon: Icon(Icons.title),
                                  keyboradType: TextInputType.text,
                                  label: 'title',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'title must not be empty !';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                defualtTextFormField(
                                  controller: timeController,
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value!.format(context);
                                    });
                                  },
                                  prefixIcon: Icon(Icons.timelapse),
                                  keyboradType: TextInputType.datetime,
                                  label: 'Time',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return ' must not be empty !';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                defualtTextFormField(
                                  controller: dateController,
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2022-08-08'))
                                        .then((value) {
                                      dateController.text = DateFormat.yMMMEd()
                                          .format(value ?? DateTime.now());
                                    });
                                  },
                                  prefixIcon: Icon(Icons.calendar_today),
                                  keyboradType: TextInputType.datetime,
                                  label: 'Date',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return ' date must not be empty !';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ))
                    .closed
                    .then((value) {
                  model.changeBoolFab();
                });
                model.changeBoolFab();
              }
            },
          ),
        ),
      );
    });
  }
}
