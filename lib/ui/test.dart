import 'package:flutter/material.dart';
import 'package:epub/epub.dart';
import 'dart:io';

class TodoListView extends StatefulWidget {
  TodoListView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ToDoListState createState() => ToDoListState();
}

class ToDoListState extends State<TodoListView> {


  List<TaskModel> taskList = [
    TaskModel(id: '1', title: 'Test app 1', status: 'Completed', name: 'John'),
    TaskModel(id: '2', title: 'Test app 2', status: 'In progress', name: 'Jenny'),
    TaskModel(id: '3', title: 'Test app 3', status: 'Not started', name: 'Jane')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reorderable List'),
      ),
      body: buildBody(),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
//    setState(() {
//      if (newIndex > oldIndex) {
//        newIndex -= 1;
//      }
//      final TaskModel item = taskList.removeAt(oldIndex);
//      taskList.insert(newIndex, item);
//    });
  }


  Widget toDo(TaskModel todo) {
    return Container(
        key: Key(todo.id),
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle, // BoxShape.circle or BoxShape.retangle
            //color: const Color(0xFF66BB6A),
            boxShadow: [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 5.0,
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(
                10.0,
              ),
              child: Text(
                todo.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                ],
              ),
            )
          ],
        ));
  }

  void epubTest() async{
    var targetFile = new File("assets/sample.epub");
    List<int> bytes = await targetFile.readAsBytes();
  }

  Widget buildBody() {
    epubTest();

    return ReorderableListView(
      children: taskList.map((todo) {
        return toDo(todo);
      }).toList(),
      onReorder: _onReorder,
    );
  }
}

class TaskModel {
  String id;
  String title;
  String status;
  String name;

  TaskModel(
      {@required this.id,
        @required this.title,
        @required this.status,
        @required this.name});
}