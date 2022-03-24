import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todosqflite/view_model/sqflite_view_model.dart';

Widget defualtTextFormField(
        {TextEditingController? controller,
        TextInputType? keyboradType,
        String? Function(String?)? validator,
        String? label,
        Widget? prefixIcon,
        Widget? suffixIcon,
        void Function(String)? onSubmit,
        void Function(String)? onChanged,
        Function? onTap}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboradType,
      onTap: () {
        onTap!();
      },
      onChanged: onChanged,
      onFieldSubmitted: onSubmit,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        labelText: label,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );

Widget buildTaskItem(
        List<Map> model, int index, SqfLiteViewModel sqfLiteViewModel) =>
    Dismissible(
        key: Key(model[index]['id'].toString()),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40.0,
                child: Text('${model[index]['time']}'),
              ),
              SizedBox(
                width: 15.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model[index]['title']}',
                    style: TextStyle(fontSize: 23.0),
                  ),
                  Text(
                    '${model[index]['date']}',
                    style: TextStyle(fontSize: 15.0, color: Colors.grey),
                  )
                ],
              ),
              Spacer(),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        sqfLiteViewModel.updateDatainDB(
                            status: 'done', id: model[index]['id']);
                        print('done');
                      },
                      icon: Icon(
                        Icons.done_outline_sharp,
                        color: Colors.green,
                      )),
                  SizedBox(
                    width: 15.0,
                  ),
                  IconButton(
                    onPressed: () {
                      sqfLiteViewModel.updateDatainDB(
                          status: 'archived', id: model[index]['id']);
                      print('archived');
                    },
                    icon: Icon(Icons.archive_outlined),
                  )
                ],
              )
            ],
          ),
        ),
        onDismissed: (direction) {
          sqfLiteViewModel.deleteDatafromDB(id: model[index]['id']);
          model.removeAt(index);
        });

Widget myDevider() => Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Container(
        height: 1.0,
        color: Colors.grey[300],
      ),
    );
