import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager/controllers/task_controller.dart';
import 'package:taskmanager/screens/add_new_task.dart';
import 'package:taskmanager/screens/faq.dart';
import 'package:taskmanager/screens/task_view.dart';

import 'completed_tasks_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _taskController = Get.put(TaskController());

  final _searchController = TextEditingController();

  //icons for the categories
  final categoryIcons = {
    'Health': Icons.health_and_safety,
    'Work': Icons.work,
    'Finance': Icons.account_balance_wallet,
    'Education': Icons.school,
    'Travel': Icons.hiking,
    'Shopping': Icons.shopping_cart,
    'Entertainment': Icons.sports_esports,
    'Other': Icons.more_horiz,
  };

  //colors for the categories
  final priorityColors = {
    'High': Colors.red,
    'Medium': Colors.orange,
    'Low': Colors.green,
  };

  DateTime? selectedDate = DateTime.now();
  int? selectedPriority;

  @override
  void initState() {
    super.initState();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _todoScreen());
  }

  // private function for appbar
  _appBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 0.0, top: 5.0, bottom: 5.0, right: 0.0),
            child: Text(
              DateFormat('MMM d, y').format(DateTime.now()),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  background: Paint()..color = Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 0.0, top: 5.0, bottom: 5.0, right: 0.0),
            child: Text(
              'Today',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  background: Paint()..color = Colors.black),
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                width: 180, // Adjust the width as needed
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchController.text = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    contentPadding: const EdgeInsets.only(
                        left: 10.0, right: 10, top: 5, bottom: 5),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
            IconButton(
              padding: const EdgeInsets.only(right: 20.0, left: 10.0),
              icon: const Icon(
                Icons.filter_list,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
      toolbarHeight: 75,
      elevation: 0.0,
    );
  }

  //private function for todolist
  _todoScreen() {
    return Stack(
      children: [
        ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                      color: Colors.black, // Left half is black
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // date-picker widget for scrollable date timeline
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                          child: DatePicker(
                            DateTime.now(),
                            initialSelectedDate: selectedDate,
                            selectionColor: Colors.white,
                            selectedTextColor: Colors.black,
                            dateTextStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            monthTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            dayTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            onDateChange: (date) {
                              // New date selected
                              setState(() {
                                selectedDate = date;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Three Circles for Priority and two buttons
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Wrap(
                        children: List<Widget>.generate(
                          3,
                          (int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (selectedPriority != null &&
                                      selectedPriority == index) {
                                    selectedPriority = null;
                                  } else {
                                    selectedPriority = index;
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: CircleAvatar(
                                  radius: 10, // Corrected typo here
                                  backgroundColor: index == 0
                                      ? Colors.red
                                      : index == 1
                                          ? Colors.orange
                                          : Colors.green,
                                  child: selectedPriority == index
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0.0,
                            ),
                            onPressed: () {
                              Get.to(() => const CompletedTaskPage());
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.task_alt,
                                  color: Colors.black,
                                  size: 24.0,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Completed",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, elevation: 0.0),
                            onPressed: () {
                              _showUploadDialog(context);
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.import_export,
                                  color: Colors.black,
                                  size: 24.0,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Import/Export",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  var incompleteTasks = _taskController.taskList
                      .where((task) => task.isCompleted == 0)
                      .toList();
                  var searchQuery = _searchController.text.toLowerCase();

                  if (selectedPriority != null) {
                    if (selectedPriority == 0) {
                      incompleteTasks = incompleteTasks
                          .where((task) => task.priority == "High")
                          .toList();
                    } else if (selectedPriority == 1) {
                      incompleteTasks = incompleteTasks
                          .where((task) => task.priority == "Medium")
                          .toList();
                    } else if (selectedPriority == 2) {
                      incompleteTasks = incompleteTasks
                          .where((task) => task.priority == "Low")
                          .toList();
                    }
                  }

                  // to catch the search phrase
                  if (searchQuery.isNotEmpty) {
                    incompleteTasks = incompleteTasks
                        .where((task) =>
                            task.taskTitle!.toLowerCase().contains(searchQuery))
                        .toList();
                  }

                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: incompleteTasks.length,
                      itemBuilder: (context, index) {
                        final task = incompleteTasks[index];
                        print(task.toJson());
                        if (task.taskDate ==
                            "${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}") {
                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                () => const TaskPageView(),
                                arguments: task,
                              );
                            },
                            child: Slidable(
                              actionPane: const SlidableDrawerActionPane(),
                              actionExtentRatio: 0.15,
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.black,
                                  icon: Icons.delete,
                                  onTap: () {
                                    _taskController.deleteTask(task);
                                    _taskController.getTasks();
                                  },
                                ),
                              ],
                              child: ListTile(
                                leading: Transform.scale(
                                  scale: 1.4,
                                  child: Checkbox(
                                    value: false,
                                    checkColor: Colors.white,
                                    activeColor: Colors.black,
                                    shape: const CircleBorder(),
                                    onChanged: (bool? ticked) {
                                      _taskController
                                          .markTaskCompleted(task.taskId);
                                      _taskController.getTasks();
                                    },
                                  ),
                                ),
                                title: Text(
                                  "${task.taskTitle}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                subtitle: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 5,
                                      width: 24,
                                      decoration: BoxDecoration(
                                        color: priorityColors[task.priority],
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          task.taskDescription!.isNotEmpty
                                              ? Icons.menu
                                              : null,
                                          color: Colors.black,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 15),
                                        Icon(
                                          task.attachment != null
                                              ? Icons.attachment
                                              : null,
                                          color: Colors.black,
                                          size: 12,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Icon(
                                  categoryIcons[task.category],
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      });
                }),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 16.0, // Adjust the position as needed
          right: 16.0, // Adjust the position as needed
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  Get.to(() => const FaqPage());
                },
                tooltip: 'FAQ',
                backgroundColor: Colors.black,
                heroTag: "faqBtn",
                child: const Icon(Icons.help),
              ),
              const SizedBox(width: 16.0), // Add some spacing between buttons
              FloatingActionButton(
                onPressed: () async {
                  await Get.to(() => const AddTaskPage());
                  _taskController.getTasks();
                },
                tooltip: 'Add a new task',
                backgroundColor: Colors.black,
                heroTag: "addTaskBtn",
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'Import To-Do List :',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                color: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(
                    horizontal: 60.0, vertical: 20.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.file_copy_outlined,
                      size: 50,
                      color: Colors.grey,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle import logic
                        Get.back(); // Close the dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child: const Text('Browse'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const ListTile(
                title: Text(
                  'Export To-Do List :',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle export logic
                  Get.back(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                ),
                child: const Text('Export'),
              ),
            ],
          ),
        );
      },
    );
  }
}
