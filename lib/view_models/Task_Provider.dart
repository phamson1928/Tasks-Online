import 'package:flutter/material.dart';
import '../models/data_model.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _task = [];
  int completedTaskCount = 0;

  List<Task> get task => _task;

  void addTask(String title, String description, DateTime dueDate, String note) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _task.add(Task(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      note: note,
    ));
    notifyListeners();
  }

  /// Remove task and optionally increment counter if completed
  void removeTask(String id, {bool countAsCompleted = false}) {
    final index = _task.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _task.removeAt(index);
      if (countAsCompleted) {
        completedTaskCount++;
      }
      notifyListeners();
    }
  }

  /// Mark completed triggers immediate removal and count increment
  void markTaskCompleted(String id) {
    removeTask(id, countAsCompleted: true);
  }
}