class Task {
  String? id;
  String? title;
  String? description;
  DateTime? dueDate;
  String? note;
  bool isCompleted = false;
  Task({required this.id, required this.title, required this.description, required this.dueDate, required this.note, this.isCompleted = false});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  // Chuyển từ Firestore JSON thành đối tượng Task
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      isCompleted: json['isCompleted'] as bool,
      note: json['note'] as String,
    );
  }

}