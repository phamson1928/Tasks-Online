import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/data_model.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _task = [];
  int completedTaskCount = 0;

  List<Task> get task => _task;

  /// Thêm task vào danh sách và Firestore
  void addTask(String title, String description, DateTime dueDate, String note) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newTask = Task(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      note: note,
    );
    _task.add(newTask);
    notifyListeners();

    FirebaseFirestore.instance.collection('tasks').doc(id).set({
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'note': note,
    });
  }

  /// Xoá task khỏi danh sách và Firestore
  void removeTask(String id, {bool countAsCompleted = false}) async {
    final index = _task.indexWhere((t) => t.id == id);
    if (index != -1) {
      _task.removeAt(index);
      if (countAsCompleted) {
        completedTaskCount++;
      }
      notifyListeners();

      await FirebaseFirestore.instance.collection('tasks').doc(id).delete();
    }
  }

  /// Đánh dấu hoàn thành: xoá khỏi danh sách và tăng biến đếm
  void markTaskCompleted(String id) {
    removeTask(id, countAsCompleted: true);
  }

  /// Tải tất cả tasks từ Firestore vào provider
  Future<void> loadTasksFromFirebase() async {
    final snapshot = await FirebaseFirestore.instance.collection('tasks').get();
    _task = snapshot.docs.map((doc) {
      final data = doc.data();
      return Task(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        dueDate: DateTime.parse(data['dueDate']),
        note: data['note'],
      );
    }).toList();
    notifyListeners();
  }
}
