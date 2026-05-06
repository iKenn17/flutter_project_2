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
  // ─── Services & State ────────────────────────────────────────────────────────
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestoreService = FirestoreService();

  List<Task> tasks = [];
  DateTime? reminderDate;
  String selectedFilter = "All";
  String searchQuery = "";

  // ─── Helper: Format Firestore Timestamp to readable string ───────────────────
  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    int hour = date.hour;
    String minutes = date.minute.toString().padLeft(2, '0');
    String period = hour >= 12 ? 'PM' : 'AM';
    int hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return "${date.year}-${date.month}-${date.day} $hour12:$minutes $period";
  }

  // ─── Helper: Safely extract isDone from a Firestore document ─────────────────
  bool getIsDone(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return (data != null && data.containsKey('isDone'))
        ? data['isDone'] as bool
        : false;
  }

  // ─── Build task list for a given user ────────────────────────────────────────
  Widget _buildTaskList(User user) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getTasks(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No tasks yet"));
          }

          var filteredTasks = snapshot.data!.docs.where((task) {
            final title = task['title'].toString().toLowerCase();
            return title.contains(searchQuery);
          }).toList();

          if (selectedFilter == "Pending") {
            filteredTasks = filteredTasks
                .where((task) => getIsDone(task) == false)
                .toList();
          } else if (selectedFilter == "Completed") {
            filteredTasks = filteredTasks
                .where((task) => getIsDone(task) == true)
                .toList();
          }

          if (filteredTasks.isEmpty) {
            return Center(
              child: Text(
                "No $selectedFilter tasks",
                style: const TextStyle(color: Color.fromARGB(255, 40, 33, 31)),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              final isDone = getIsDone(task);

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 40, 33, 31),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 0,
                  ),
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -4,
                  ),
                  leading: Checkbox(
                    value: isDone,
                    activeColor: const Color.fromARGB(255, 204, 193, 177),
                    checkColor: const Color.fromARGB(255, 40, 33, 31),
                    onChanged: (value) async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('tasks')
                          .doc(task.id)
                          .update({'isDone': value});

                      if (value == true) {
                        setState(() => selectedFilter = "Completed");
                      } else {
                        setState(() => selectedFilter = "Pending");
                      }
                    },
                  ),
                  title: Text(
                    task['title'],
                    style: TextStyle(
                      color: Colors.white,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      decorationColor: Colors.white54,
                    ),
                  ),
                  subtitle: task['reminder'] != null
                      ? Text(
                          "Reminder: ${formatDate(task['reminder'] as Timestamp)}",
                          style: const TextStyle(color: Colors.white70),
                        )
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Edit Button ───────────────────────────────────
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white70,
                          size: 20,
                        ),
                        onPressed: () {
                          final editController = TextEditingController(
                            text: task['title'],
                          );
                          DateTime? editReminderDate = task['reminder'] != null
                              ? (task['reminder'] as Timestamp).toDate()
                              : null;

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: const Color.fromARGB(
                                255,
                                40,
                                33,
                                31,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Edit Quest",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  TextField(
                                    controller: editController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: "Enter Title...",
                                      hintStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      filled: true,
                                      fillColor: const Color.fromARGB(
                                        255,
                                        204,
                                        193,
                                        177,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: const Size(120, 20),
                                          padding: const EdgeInsets.all(5),
                                        ),
                                        onPressed: () async {
                                          DateTime? date = await showDatePicker(
                                            context: context,
                                            initialDate:
                                                editReminderDate ??
                                                DateTime.now(),
                                            firstDate: DateTime(2024),
                                            lastDate: DateTime(2100),
                                          );
                                          if (date != null) {
                                            TimeOfDay? time =
                                                await showTimePicker(
                                                  context: context,
                                                  initialTime:
                                                      editReminderDate != null
                                                      ? TimeOfDay.fromDateTime(
                                                          editReminderDate!,
                                                        )
                                                      : TimeOfDay.now(),
                                                );
                                            if (time != null) {
                                              editReminderDate = DateTime(
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
                                          "Edit Reminder",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          final newTitle = editController.text;
                                          if (newTitle.isNotEmpty) {
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(user.uid)
                                                .collection('tasks')
                                                .doc(task.id)
                                                .update({
                                                  'title': newTitle,
                                                  'reminder':
                                                      editReminderDate != null
                                                      ? Timestamp.fromDate(
                                                          editReminderDate!,
                                                        )
                                                      : null,
                                                });

                                            if (editReminderDate != null) {
                                              NotificationService.scheduleNotification(
                                                id:
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch ~/
                                                    1000,
                                                title: "Task Reminder",
                                                body: newTitle,
                                                scheduledDate:
                                                    editReminderDate!,
                                              );
                                            }

                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text(
                                          "Save",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      // ── Delete Button ─────────────────────────────────
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        onPressed: () async {
                          bool? confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Delete Task"),
                              content: const Text(
                                "Are you sure you want to delete this task?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await firestoreService.deleteTask(task.id);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 204, 193, 177),

      // ─── AppBar ──────────────────────────────────────────────────────────────
      appBar: AppBar(
        title: const Text('Questifie', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 40, 33, 31),
        actions: [
          PopupMenuButton<String>(
            color: const Color.fromARGB(255, 40, 33, 31),
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            offset: const Offset(0, 40),
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
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'User',
                child: Row(
                  children: const [
                    Icon(
                      Icons.person_outline,
                      color: Color.fromARGB(255, 204, 193, 177),
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'User',
                      style: TextStyle(
                        color: Color.fromARGB(255, 204, 193, 177),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'Settings',
                child: Row(
                  children: const [
                    Icon(
                      Icons.settings_outlined,
                      color: Color.fromARGB(255, 204, 193, 177),
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: Color.fromARGB(255, 204, 193, 177),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      // ─── Body: StreamBuilder waits for Firebase Auth to restore session ───────
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          // ✅ Wait for Firebase to restore persisted auth session
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ✅ Auth fully loaded — get the user
          final user = authSnapshot.data;

          // Should not happen (main.dart StreamBuilder guards this),
          // but just in case show a spinner instead of crashing
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // ✅ User confirmed — render the full UI
          return SafeArea(
            child: Column(
              children: [
                // ─── Filter Buttons (All / Pending / Completed) ───────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  child: Row(
                    children: ["All", "Pending", "Completed"].map((filter) {
                      final isSelected = selectedFilter == filter;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedFilter = filter),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color.fromARGB(255, 40, 33, 31)
                                  : Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color.fromARGB(255, 40, 33, 31),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // ─── Task List ────────────────────────────────────────────
                _buildTaskList(user),

                // ─── Add Task Button ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 40, 33, 31),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            final titleController = TextEditingController();

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  40,
                                  33,
                                  31,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        fillColor: const Color.fromARGB(
                                          255,
                                          204,
                                          193,
                                          177,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(120, 20),
                                            padding: const EdgeInsets.all(5),
                                          ),
                                          onPressed: () async {
                                            DateTime? date =
                                                await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
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
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed: () async {
                                            final taskTitle =
                                                titleController.text;
                                            if (taskTitle.isNotEmpty) {
                                              await firestoreService.addTask(
                                                taskTitle,
                                                reminderDate,
                                              );

                                              if (reminderDate != null) {
                                                NotificationService.scheduleNotification(
                                                  id:
                                                      DateTime.now()
                                                          .millisecondsSinceEpoch ~/
                                                      1000,
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
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Search Bar ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      onChanged: (value) =>
                          setState(() => searchQuery = value.toLowerCase()),
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
          );
        },
      ),
    );
  }
}
