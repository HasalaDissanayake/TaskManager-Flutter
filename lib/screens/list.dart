import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);
  static const taskCount = 3;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Hi Good Day!',
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.black,
          toolbarHeight: 40,
        ),
        body: const TodoScreen(),
      ),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
    //Task list for the day with it's categoty Health, Work, Education, Entertainment, Exercise, Food , Other
    final List<Map<String, dynamic>> taskList = [
      {
        'title': 'Go for a run',
        'category': 'Exercise',
        'time': '6:00 AM',
        'priority': 'High',
        'isDone': false,
      },
      {
        'title': 'Buy groceries',
        'category': 'Food',
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
        'category': 'Exercise',
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

    @override
    Widget build(BuildContext context) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final weekDates = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
    final weekDaysName = weekDates.map((date) => DateFormat('E').format(date)).toList();

    //icons for the categories
    final categoryIcons = {
      'Health': Icons.favorite,
      'Work': Icons.work,
      'Education': Icons.book,
      'Entertainment': Icons.tv,
      'Exercise': Icons.directions_run,
      'Food': Icons.fastfood,
      'Other': Icons.more_horiz,
    };

    //colors for the categories
    final priorityColors = {
      'High': Colors.red,
      'Medium': Colors.orange,
      'Low': Colors.green,
    };

    return ListView(
      children: [
        Container(
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
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'You have ${TodoApp.taskCount} tasks to complete today.',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  DateFormat.yMMMM().format(DateTime.now()),
                  style: TextStyle(color: Colors.white, fontSize: 24.0,background: Paint()..color = Colors.black),
                ),
              ),
              // Display the days of the week with dates in a grid
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 60,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7, // 2 columns
                    ),
                    itemCount: weekDaysName.length,
                    itemBuilder: (context, index) {
                      final dayName = weekDaysName[index];
                      final date = weekDates[index].day.toString();

                      final isToday = date == now.day.toString(); // Check if it's today's date

                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: isToday ? Colors.white : Colors.black, // Highlighted background color
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                Text(
                                  dayName,
                                  style: TextStyle(
                                    color: isToday ? Colors.black : Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  date,
                                  style: TextStyle(
                                    color: isToday ? Colors.black : Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
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
                Spacer(), // This will push the following Row to the right
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton(
                      mini: true,
                      onPressed: () {
                         _showUploadDialog(context);
                      },
                      child: const Icon(Icons.upload),
                      tooltip: 'Upload a task list',
                      backgroundColor: Colors.black,
                    ),
                    SizedBox(width: 16.0), // Add some spacing between buttons
                    FloatingActionButton(
                      mini: true,
                      onPressed: () {
                        // Handle download button press
                      },
                      child: const Icon(Icons.download),
                      tooltip: 'Download a task list',
                      backgroundColor: Colors.black,
                    ),
                    SizedBox(width: 16.0), // Add some spacing between buttons
                  ],
                ),
                )     
              ],
            ),
            //Add a search bar to search for tasks
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),

            // todo list with a delete button which shows when you slide the task to the left and strile through when you click on the task
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                final task = taskList[index];
                return Slidable(
                  actionPane: const SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
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
                    leading: 
                    Checkbox(
                      value: task['isDone'],
                      checkColor: Colors.white,
                      activeColor: Colors.black,
                      onChanged: (bool? newValue) {
                        setState(() {
                          task['isDone'] = newValue ?? false; // Update the 'isDone' property based on the new value
                        });
                      },
                    ),
                    title: Text(
                      "${task['title']}",
                      style: TextStyle(
                        color: task['isDone'] ? Colors.grey : Colors.black,
                        fontSize: 20.0,
                        decoration: task['isDone']? TextDecoration.lineThrough : TextDecoration.none,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft, 
                      child: FloatingActionButton(
                        onPressed: () {
                          // Handle FAQ button press
                        },
                        child: const Icon(Icons.help),
                        tooltip: 'FAQ',
                        backgroundColor: Colors.black,
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        // Handle add new task button press
                      },
                      child: const Icon(Icons.add),
                      tooltip: 'Add a new task',
                      backgroundColor: Colors.black,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
  void _showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload File'),
          content: Text('Choose a file to upload.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  // Handle the selected file
                  PlatformFile file = result.files.first;
                  // TODO: Implement file upload logic
                  print('File picked: ${file.name}');
                  print('File path: ${file.path}');
                } else {
                  // User canceled the file picker
                  print('File selection canceled.');
                }

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Choose a file'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
