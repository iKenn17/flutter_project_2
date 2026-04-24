import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/task.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import '../services/firestore_service.dart';
import '../services/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestoreService = FirestoreService();
  List<Task> tasks = [];
  DateTime? reminderDate;

  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}";
  }

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 204, 193, 177),
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (String value) {
              if (value == 'User') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              } else if (value == 'Settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'User',
                child: Text('User'),
              ),
              const PopupMenuItem<String>(
                value: 'Settings',
                child: Text('Settings'),
              ),
            ],
          ),
        ],
        title: const Text(
          'Questifie',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 40, 33, 31),
      ),
      body: SafeArea(
        child: user == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: firestoreService.getTasks(user.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text("Error: ${snapshot.error}"));
                        }

                        if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text("No tasks yet"));
                        }

                        var allTasks = snapshot.data!.docs;

                        var filteredTasks = allTasks.where((task) {
                          String title = task['title'].toString().toLowerCase();
                          return title.contains(searchQuery);
                        }).toList();

                        return ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            var task = filteredTasks[index];

                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 40, 33, 31),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: Checkbox(
                                  value: task.data().toString().contains('isDone')? task['isDone'] : false, 
                                  onChanged: (value) async {
                                    await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .collection('tasks')
                                    .doc(task.id)
                                    .update({
                                      'isDone' : value,
                                    });
                                    bool? confirm = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Complete Task"),
                                          content: const Text("Mark this task as done?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                                child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              child: const Text("Yes"),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirm == true) {
                                      await firestoreService.deleteTask(task.id);
                                    }
                                  },
                                ),
                                title: Text(
                                  task['title'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: task['reminder'] != null
                                  ? Text(
                                    "Reminder: ${formatDate(task['reminder'] as Timestamp)}",
                                    style: const TextStyle(color: Colors.white70),
                                  )
                                : null,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                const Color.fromARGB(255, 40, 33, 31),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: IconButton(
                            onPressed: () {
                              TextEditingController titleController =
                                  TextEditingController();

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor:
                                        const Color.fromARGB(255, 40, 33, 31),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Quest",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        TextField(
                                          controller: titleController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: "Enter Title...",
                                            hintStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                            filled: true,
                                            fillColor:
                                                const Color.fromARGB(
                                                    255, 204, 193, 177),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  fixedSize:
                                                      const Size(120, 20),
                                                  padding:
                                                      const EdgeInsets.all(
                                                          5)),
                                              onPressed: () async {
                                                DateTime? date =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate:
                                                      DateTime.now(),
                                                  firstDate: DateTime(2024),
                                                  lastDate: DateTime(2100),
                                                );

                                                if (date != null) {
                                                  TimeOfDay? time =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                  );

                                                  if (time != null) {
                                                    reminderDate = DateTime(
                                                      date.year,
                                                      date.month,
                                                      date.day,
                                                      time.hour,
                                                      time.minute,
                                                    );
                                                  }
                                                }
                                              },
                                              child: const Text(
                                                "Add Reminder",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 30),
                                            ElevatedButton(
                                              style:
                                                  ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.white,
                                                foregroundColor:
                                                    Colors.blue,
                                                shape:
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(20),
                                                ),
                                              ),
                                              onPressed: () async {
                                                String taskTitle = titleController.text;

                                                if (taskTitle.isNotEmpty) {
                                                  await firestoreService.addTask(taskTitle, reminderDate);

    
                                                  if (reminderDate != null) {
                                                    NotificationService.scheduleNotification(
                                                      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                                                      title: "Task Reminder",
                                                      body: taskTitle,
                                                      scheduledDate: reminderDate!,
                                                    );
                                                  }

                                                  reminderDate = null;
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: const Text(
                                                "Add Task",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.add,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}