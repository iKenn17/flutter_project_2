import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/task.dart';
import 'profile_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Task> tasks = [];
  DateTime? reminderDate;

  Future<void> logout(BuildContext context) async {
    await auth.signOut();

    if (mounted) {
      setState(() {
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 204, 193, 177),
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (String value) {
              if (value == 'Profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              }

              else if (value == 'Log out') {
                logout(context); 
              }
              debugPrint(value);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Profile',
                child: Text('Profile'),
              ),
              const PopupMenuItem<String>(
                value: 'Settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem<String>(
                value: 'Log out',
                child: Text('Log out'),
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
        child: Column(
          children: [
            
            Expanded(
            child: tasks.isEmpty
              ? const Center(child: Text("No tasks yet"))
                : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 40, 33, 31), 
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(task.title,
                      style: TextStyle(
                        color: Colors.white
                      )),
                      subtitle: task.reminder != null
                      ? Text("Reminder: ${task.reminder}",
                      style: TextStyle(
                        color: Colors.white
                      ))
                      : null,
                      leading: const Icon(Icons.check_circle_outline,
                      color: Colors.white),
                    ),
                  );
                  },
                ),
),

            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
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
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      filled: true,
                                      fillColor:
                                          const Color.fromARGB(255, 204, 193, 177),
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
                                          fixedSize: Size(120,20),
                                          padding: EdgeInsets.all(5)
                                        ),
                                        onPressed: () async {
                                          DateTime? date = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2024),
                                            lastDate: DateTime(2100),
                                          );

                                          if (date != null) {
                                            TimeOfDay? time =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
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
                                        child: const Text("Add Reminder",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),),
                                      ),

                                      SizedBox(width: 30),

                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        onPressed: () {
                                          String taskTitle = titleController.text;
                                          debugPrint(taskTitle);

                                          if (taskTitle.isNotEmpty) {
                                            setState(() {
                                              tasks.add(Task(
                                                  title: taskTitle,
                                                  reminder: reminderDate));
                                              reminderDate = null;
                                            });
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text("Add Task",
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),

            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: SizedBox(
                height: 50,
                child: TextField(
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


/*
import 'package:flutter/material.dart';
import '../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Task> tasks = [];
  DateTime? reminderDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromARGB(255, 204, 193, 177),
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (String value) {

              debugPrint(value);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'User',
                child: Text('Users'),
              ),

              const PopupMenuItem<String>(
                value: 'Settings',
                child: Text('Settings'),
              ),

              const PopupMenuItem<String>(
                value: 'Log out',
                child: Text('Log out'),
              ),
            ]
          )
        ],
        title: Text('Questifie',
        style: TextStyle(
          color: Colors.white
        )),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 40, 33, 31),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Expanded(
              child: Container()
            ),

            Center(
              child: Column(
                children: [
                  Expanded(
                    child: tasks.isEmpty
                      ? Center(child: Text("No tasks yet")) // optional placeholder
                      : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return ListTile(
                              title: Text(task.title),
                              subtitle: task.reminder != null
                                ? Text("Reminder: ${task.reminder}")
                                : null,
                              leading: Icon(Icons.check_circle_outline),
                            );
                          },
                        ),
                    )
                ],
              )
            ),

            Expanded(
              child: Container()
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 40, 33, 31),
                      borderRadius: BorderRadius.circular(35
                      )
                    ),
                    padding: EdgeInsets.all(8),
                    child: IconButton(
                      onPressed: () {
                        TextEditingController titleController = TextEditingController();

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: const Color.fromARGB(255, 40, 33, 31),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                                  const Text("Quest",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),

                                  const SizedBox (height: 15),

                                  TextField(
                                    controller: titleController,
                                    decoration: InputDecoration(
                                      hintText: "Enter Title...",
                                      filled: true,
                                      fillColor: Color.fromARGB(255, 204, 193, 177),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: BorderSide.none,
                                      )
                                    )
                                  ),

                                  const SizedBox(height: 20),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      ElevatedButton(
                                        onPressed: () async {

                                          DateTime? date = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2024),
                                            lastDate: DateTime(2100),
                                          );

                                          if (date != null) {

                                            TimeOfDay? time = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
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
                                          };
                                        },
                                        child: Text("Add Reminder")
                                      ),

                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(255, 40, 33, 31),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadiusGeometry.circular(20),
                                          )
                                        ),
                                        onPressed: () {
                                          String taskTitle = titleController.text;
                                          debugPrint(taskTitle);

                                          if (taskTitle.isNotEmpty) {
                                            setState(() {
                                              tasks.add(Task(title: taskTitle, reminder: reminderDate));
                                              reminderDate = null;
                                            });
                                            
                                          };  
                                        },
                                        child: const Text("Add Task"),
                                      )
                                    ],
                                  )

                                ],
                              ),
                            );
                          }
                        );
                      }, 
                      icon: const Icon(Icons.add,
                      color: Colors.white))
                  )
                ],
              ),
            ),

            Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: SearchBar(
                      hintText: 'Search...',
                      leading: const Icon(Icons.search),
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                      elevation: WidgetStatePropertyAll(2.0),
                    )
                  )

          ],

          

        ),


    );
  }
}
*/