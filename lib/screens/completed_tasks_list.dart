import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/controllers/task_controller.dart';
import 'package:taskmanager/screens/task_view.dart';

class CompletedTaskPage extends StatefulWidget {
  const CompletedTaskPage({super.key});

  @override
  State<CompletedTaskPage> createState() => _CompletedTaskPageState();
}

class _CompletedTaskPageState extends State<CompletedTaskPage> {
  final _taskController = Get.put(TaskController());

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
  void initState() {
    super.initState();
    _taskController.getTasks();
  }

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
          Get.back();
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
    return Stack(children: [
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
          Obx(() {
            final completedTasks = _taskController.taskList
                .where((task) => task.isCompleted == 1)
                .toList();

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: completedTasks.length,
              itemBuilder: (context, index) {
                final task = completedTasks[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(
                      () => const TaskPageView(),
                      arguments: task,
                    );
                  },
                  child: ListTile(
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
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (task.taskDescription!.isNotEmpty &&
                                task.attachment == null)
                              const Icon(
                                Icons.menu,
                                color: Colors.black,
                                size: 12,
                              ),
                            if (task.attachment != null &&
                                task.taskDescription!.isEmpty)
                              const Icon(
                                Icons.attachment,
                                color: Colors.black,
                                size: 12,
                              ),
                            if (task.attachment != null &&
                                task.taskDescription!.isNotEmpty)
                              const Icon(
                                Icons.menu,
                                color: Colors.black,
                                size: 12,
                              ),
                            const SizedBox(width: 15),
                            const Icon(
                              Icons.attachment,
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
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                  ),
                );
              },
            );
          }),
        ],
      ),
    ]);
  }
}
