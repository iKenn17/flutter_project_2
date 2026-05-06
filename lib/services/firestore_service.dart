import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  // Reference to the top-level 'tasks' collection (not currently used directly)
  final CollectionReference tasks = FirebaseFirestore.instance.collection(
    'tasks',
  );

  // Adds a new task under the current user's tasks collection
  Future<void> addTask(String title, DateTime? reminder) async {
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid) // Use the logged-in user's ID
        .collection('tasks')
        .add({
          'title': title,
          'reminder': reminder != null
              ? Timestamp.fromDate(reminder)
              : null, // Save reminder if set
          'isDone': false, // Task starts as not completed
          'createdAt': Timestamp.now(),
        });
  }

  // Deletes a specific task by its ID for the current user
  Future<void> deleteTask(String taskId) async {
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  // Returns a live stream of tasks for a user, newest first
  Stream<QuerySnapshot> getTasks(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .orderBy(
          'createdAt',
          descending: true,
        ) // Latest tasks appear at the top
        .snapshots(); // Listens for real-time updates
  }
}
