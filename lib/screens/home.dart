import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/services/file_service.dart';
import 'package:lista_de_tarefas/widgets/todo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _toDoList = <Map>[];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    super.initState();
    readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  TextEditingController _toDoController = TextEditingController();

  _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = {};
      newToDo["title"] = _toDoController.text;
      newToDo["ok"] = false;
      _toDoController.clear();
      _toDoList.add(newToDo);
      saveData(_toDoList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas!"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(17, 1, 7, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: "Nova Tarefa"),
                      controller: _toDoController,
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    onPressed: _addToDo,
                    child: Text("+"),
                  )
                ],
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10.0),
                  itemCount: _toDoList.length,
                  itemBuilder: (context, index) {
                    return ToDo(
                      title: _toDoList[index]["title"],
                      isDone: _toDoList[index]["ok"],
                      onChanged: (newVal) {
                        setState(() {
                          _toDoList[index]["ok"] = newVal;
                          saveData(_toDoList);
                        });
                      },
                      onDismissed: (direction) {
                        setState(() {
                          _lastRemoved = Map.from(_toDoList[index]);
                          _lastRemovedPos = index;
                          _toDoList.removeAt(index);

                          saveData(_toDoList);

                          final SnackBar snack = SnackBar(
                            content: Text(
                                "Tarefa: \"${_lastRemoved["title"]}\" removida!"),
                            action: SnackBarAction(
                              label: "Desfazer",
                              onPressed: () {
                                setState(() {
                                  _toDoList.insert(
                                      _lastRemovedPos, _lastRemoved);
                                  saveData(_toDoList);
                                });
                              },
                            ),
                            duration: Duration(seconds: 2),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snack);
                        });
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
