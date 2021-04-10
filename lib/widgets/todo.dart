import 'package:flutter/material.dart';

class ToDo extends StatelessWidget {
  final Function onChanged;
  final String title;
  final bool isDone;
  final Function onDismissed;

  ToDo({this.title, this.isDone, this.onChanged, this.onDismissed});

  @override
  Widget build(BuildContext context) {
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
      onDismissed: onDismissed,
      child: CheckboxListTile(
        onChanged: onChanged,
        title: Text(title),
        value: isDone,
        secondary: CircleAvatar(
          child: Icon(
            isDone ? Icons.check : Icons.error,
          ),
        ),
      ),
    );
  }
}
