import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/services/file_service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _toDoList = <Map>[];

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
                    return CheckboxListTile(
                      onChanged: (newVal) {
                        setState(() {
                          _toDoList[index]["ok"] = newVal;
                          saveData(_toDoList);
                        });
                      },
                      title: Text(_toDoList[index]["title"]),
                      value: _toDoList[index]["ok"],
                      secondary: CircleAvatar(
                        child: Icon(
                          _toDoList[index]["ok"] ? Icons.check : Icons.error,
                        ),
                      ),
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
