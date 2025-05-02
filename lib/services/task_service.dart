import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/data_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTask(String userId, Task task) async {
    await _firestore.collection('users').doc(userId).collection('tasks').doc(task.id).set(task.toJson());
  }

  Stream<List<Task>> getTasks(String userId) {
    return _firestore.collection('users').doc(userId).collection('tasks').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Task.fromJson(doc.data() as Map<String, dynamic>)).toList());
  }

  Future<void> deleteTask(String userId, String taskId) async {
    await _firestore.collection('users').doc(userId).collection('tasks').doc(taskId).delete();
  }
}