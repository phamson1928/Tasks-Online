import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  void sendDueDateNotification(String title, String body) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.subscribeToTopic("due_date_notifications");

    // Gửi thông báo đến người dùng khi đến hạn công việc
    await FirebaseMessaging.instance.sendMessage(
      to: "/topics/due_date_notifications",
      data: {
        "title": title,
        "body": body,
      },
    );
  }

  Future<void> deleteTask(String userId, String taskId) async {
    await _firestore.collection('users').doc(userId).collection('tasks').doc(taskId).delete();
  }
}