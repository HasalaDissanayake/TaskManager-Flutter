import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:taskmanager/services/notification_service.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pdfLib;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Map<String, dynamic>> taskList = [
    {
      'title': 'Go for a run',
      'category': 'Health',
      'time': '6:00 AM',
      'priority': 'High',
      'isDone': false,
    },
    {
      'title': 'Buy groceries',
      'category': 'Shopping',
      'time': '8:00 AM',
      'priority': 'Medium',
      'isDone': false,
    },
    {
      'title': 'Finish the design',
      'category': 'Work',
      'time': '10:00 AM',
      'priority': 'High',
      'isDone': false,
    },
    {
      'title': 'Finish the presentation',
      'category': 'Work',
      'time': '2:00 PM',
      'priority': 'Medium',
      'isDone': false,
    },
    {
      'title': 'Go to the gym',
      'category': 'Health',
      'time': '4:00 PM',
      'priority': 'Low',
      'isDone': false,
    },
    {
      'title': 'Watch a movie',
      'category': 'Entertainment',
      'time': '6:00 PM',
      'priority': 'Low',
      'isDone': false,
    },
    {
      'title': 'Read a book',
      'category': 'Education',
      'time': '8:00 PM',
      'priority': 'Low',
      'isDone': false,
    },
    {
      'title': 'Go to sleep',
      'category': 'Health',
      'time': '10:00 PM',
      'priority': 'High',
      'isDone': false,
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: GestureDetector(
        onTap: () {
          Slidable.of(context)?.close();
        },
        child: _todoScreen(),
      )
    );
  }

  // private function for appbar
  _appBar() {
    return AppBar(
      title:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:0.0,top:5.0,bottom:5.0,right:0.0),
            child: Text(
              DateFormat('MMM d, y').format(DateTime.now()),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  background: Paint()..color = Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:0.0,top:5.0,bottom:5.0,right:0.0),
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
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              width: 180, // Adjust the width as needed
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  contentPadding: const EdgeInsets.only(left: 10.0, right: 10, top: 5, bottom: 5),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            IconButton(
              padding: const EdgeInsets.only(right: 20.0,left: 10.0),
              icon: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                  size: 25,
              ),
              onPressed: () {

              },
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

    final now = DateTime.now();
    final startOfWeek = now;
    final weekDates = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
    final weekDaysName = weekDates.map((date) => DateFormat('E').format(date)).toList();

    return Stack(
      children: [
        ListView(
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
                    // Display the days of the week with dates in a grid
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 60,
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7, // 2 columns
                          ),
                          itemCount: weekDaysName.length,
                          itemBuilder: (context, index) {
                            final dayName = weekDaysName[index];
                            final date = weekDates[index].day.toString();

                            final isToday = date ==
                                now.day
                                    .toString(); // Check if it's today's date

                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: isToday
                                        ? Colors.white
                                        : Colors
                                        .black, // Highlighted background color
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        dayName,
                                        style: TextStyle(
                                          color: isToday
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: isToday
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        date,
                                        style: TextStyle(
                                          color: isToday
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: isToday
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Three Circles for Priority
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
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
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0)
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/completedTasks');
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
                                  style: TextStyle(
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0.0
                            ),
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
                                  style: TextStyle(
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    final task = taskList[index];
                    return Slidable(
                      actionPane: const SlidableDrawerActionPane(),
                      actionExtentRatio: 0.15,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.black,
                          icon: Icons.delete,
                          onTap: () {
                            setState(() {
                              taskList.removeAt(index);
                            });
                          },
                        ),
                      ],
                      child: ListTile(
                        leading: Transform.scale(
                          scale: 1.4,
                          child: Checkbox(
                            value: task['isDone'],
                            checkColor: Colors.white,
                            activeColor: Colors.black,
                            shape: const CircleBorder(),
                            onChanged: (bool? newValue) {
                              setState(() {
                                task['isDone'] = newValue ??
                                    false;
                              });
                            },
                          ),
                        ),
                        title: Text(
                          "${task['title']}",
                          style: TextStyle(
                            color: task['isDone'] ? Colors.grey : Colors.black,
                            fontSize: 20.0,
                            decoration: task['isDone']
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 5,
                              width: 24,
                              decoration: BoxDecoration(
                                color: priorityColors[task['priority']],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          categoryIcons[task['category']],
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
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
                  Navigator.pushNamed(context, '/faq');
                },
                tooltip: 'FAQ',
                backgroundColor: Colors.black,
                heroTag: "faqBtn",
                child: const Icon(Icons.help),
              ),
              const SizedBox(width: 16.0), // Add some spacing between buttons
              FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/addNewTask');
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
                padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.file_upload,
                      size: 50,
                      color: Colors.grey,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle import logic
                        Navigator.pop(context); // Close the dialog
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
                  Navigator.pop(context); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)
                  ),
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

