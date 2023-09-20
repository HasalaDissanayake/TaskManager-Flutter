import 'package:flutter/material.dart';

class CompletedTaskPage extends StatefulWidget {
  const CompletedTaskPage({super.key});

  @override
  State<CompletedTaskPage> createState() => _CompletedTaskPageState();
}

class _CompletedTaskPageState extends State<CompletedTaskPage> {

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
      body: _tasksList(),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0.0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/todo_white.png',
            width: 32.0,
            height: 32.0,
          ),
        ),
      ],
      toolbarHeight: 60,
    );
  }

  _tasksList() {
    return Stack(
      children: [
        ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'Completed List',
                    style: TextStyle(
                      fontSize: 42.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Icon(
                    Icons.task,
                    size: 50,
                  ),
                ],
              ),
            ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    final task = taskList[index];
                    return ListTile(
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                      );
                  },
                ),
              ],
        ),
      ]
    );
  }

}