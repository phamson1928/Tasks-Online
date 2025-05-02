import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/data_model.dart';

class Detail extends StatefulWidget {
  const Detail({super.key, required this.task});
  final Task task;

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.task.title!),
            Text(widget.task.description!),
            Text(widget.task.dueDate!.toString().split(" ")[0]),
            Text(widget.task.note!),
          ],
        ),
      )
    );
  }
}
