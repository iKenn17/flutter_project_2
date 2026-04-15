import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  bool isDone;
  DateTime? reminder;

  Task({required this.id, required this.title, required this.isDone, required this.reminder,});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isDone': isDone,
    };
  }

  factory Task.fromMap(String id, Map<String, dynamic> data) {
    return Task(
      id: id,
      title: data['title'],
      isDone: data['isDone'],
      reminder : data['reminder'],
    );
  }
}