import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/data_model.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _task = [];
  int completedTaskCount = 0;

  List<Task> get task => _task;


  void addTask(String title, String description, DateTime dueDate, String note) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final newTask = Task(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      note: note,
    );
    _task.add(newTask);
    notifyListeners();

    FirebaseFirestore.instance.collection('users').doc(uid).collection('tasks').doc(id).set({
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'note': note,
    });
  }

  void removeTask(String id, {bool countAsCompleted = false}) async {
    final index = _task.indexWhere((t) => t.id == id);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    if (index != -1) {
      _task.removeAt(index);
      if (countAsCompleted) {
        completedTaskCount++;
      }
      notifyListeners();
      await FirebaseFirestore.instance.collection('users').doc(uid).collection('tasks').doc(id).delete();
    }
  }

  Future<void> markTaskCompleted(String id) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    removeTask(id, countAsCompleted: true);
    await FirebaseFirestore.instance.collection('users').doc(uid).set({"count" :completedTaskCount });
  }

  Future<void> loadTasksFromFirebase() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).collection('tasks').get();
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
  Future<void> loadCompletedTaskCount() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        completedTaskCount = data?['count'] ?? 0;
      } else {
        completedTaskCount = 0;
      }
      notifyListeners();
    } catch (e) {
      print('Error loading count: $e');
      completedTaskCount = 0;
      notifyListeners();
    }
  }

}
