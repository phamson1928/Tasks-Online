class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;
  String note;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.note,
    this.isCompleted = false,
  });

  /// Convert Task to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'note': note,
      'isCompleted': isCompleted,
    };
  }

  /// Convert Firestore JSON to Task object
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: DateTime.parse(json['dueDate']),
      note: json['note'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}