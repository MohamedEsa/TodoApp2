import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todosqflite/shared/components/components.dart';
import 'package:todosqflite/view_model/sqflite_view_model.dart';

class DoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SqfLiteViewModel>(
      builder: (context, model, _) => ListView.separated(
          itemBuilder: (context, index) =>
              buildTaskItem(model.doneList, index, model),
          separatorBuilder: (context, index) => myDevider(),
          itemCount: model.doneList.length),
    );
  }
}
