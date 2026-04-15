import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

  
  Future<void> addTask(String title, DateTime? reminder) async {
  final user = FirebaseAuth.instance.currentUser;
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('tasks')
      .add({
    'title': title,
    'reminder': reminder != null ? Timestamp.fromDate(reminder) : null,
    'isDone': false,
    'createdAt': Timestamp.now(),
  });
}

  Future<void> deleteTask(String taskId) async {
  final user = FirebaseAuth.instance.currentUser;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('tasks')
      .doc(taskId)
      .delete();
}

  
  Stream<QuerySnapshot> getTasks(String uid) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('tasks')
      .orderBy('createdAt', descending: true)
      .snapshots();
}
}