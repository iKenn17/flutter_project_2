// Represents a single task in the app
class Task {
  String id;
  String title;
  bool isDone;
  DateTime? reminder; // Optional — not all tasks have a reminder

  Task({
    required this.id,
    required this.title,
    required this.isDone,
    required this.reminder,
  });

  // Converts the task to a map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {'title': title, 'isDone': isDone};
  }

  // Creates a Task object from Firestore data
  factory Task.fromMap(String id, Map<String, dynamic> data) {
    return Task(
      id: id,
      title: data['title'],
      isDone: data['isDone'],
      reminder: data['reminder'],
    );
  }
}
