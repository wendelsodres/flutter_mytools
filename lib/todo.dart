import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final _todoController = TextEditingController();

  List _todoList = [];
  Map<String, dynamic> _lastRemove;
  int _lastRemovePos;

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        _todoList = json.decode(data);
      });
    });
  }

  void _addTask() {
    setState(() {
      Map<String, dynamic> newTask = Map();
      newTask["title"] = _todoController.text;
      _todoController.text = "";
      newTask['done'] = false;
      _todoList.add(newTask);
      _saveData();
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _todoList.sort((a, b) {
        if (a["done"] && !b["done"])
          return 1;
        else if (!a["done"] && b["done"])
          return -1;
        else
          return 0;
      });

      _saveData();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Todo List"),
          backgroundColor: Colors.red,
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                        labelText: "New",
                        labelStyle: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.red,
                    child: Text("Add"),
                    textColor: Colors.white,
                    onPressed: _addTask,
                  )
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemCount: _todoList.length,
                    itemBuilder: itemBuild),
              ),
            )
          ],
        ));
  }

  Widget itemBuild(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_todoList[index]["title"]),
        value: _todoList[index]["done"],
        secondary: CircleAvatar(
          child: Icon(_todoList[index]["done"] ? Icons.check : Icons.error),
          backgroundColor: Colors.black54,
          foregroundColor: Colors.white,
        ),
        onChanged: (c) {
          setState(() {
            _todoList[index]["done"] = c;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemove = Map.from(_todoList[index]);
          _lastRemovePos = index;
          _todoList.removeAt(index);

          _saveData();

          final snack = SnackBar(
            content: Text("Deleted \"${_lastRemove["title"]}\" task"),
            action: SnackBarAction(
              label: 'undo',
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  _todoList.insert(_lastRemovePos, _lastRemove);
                  _saveData();
                });
              },
            ),
            duration: Duration(seconds: 2),
          );
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_todoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
