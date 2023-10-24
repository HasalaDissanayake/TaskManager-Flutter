import 'dart:io';

import 'package:archive/archive.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskmanager/controllers/task_controller.dart';
import 'package:taskmanager/models/task.dart';
import 'package:taskmanager/screens/add_new_task.dart';
import 'package:taskmanager/screens/faq.dart';
import 'package:taskmanager/screens/task_view.dart';
import 'package:taskmanager/services/notification_service.dart';
import 'package:uuid/uuid.dart';

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

  File? zipFile;
  File? existingFile;

  DateTime? selectedDate = DateTime.now();
  int? selectedPriority;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _taskController.getTasks();
  }

  // for file storing relative path is considered
  Future<String> getAppStorageDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  // export database
  Future<void> exportDatabase() async {
    // Get the path to the current database file
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'task_database.db');

    // Copy the database file to a location accessible
    final externalStorageDir = await getExternalStorageDirectory();
    final backupPath = join(externalStorageDir!.path, 'backup.db');
    await File(path).copy(backupPath);

    print('Database exported to: $backupPath');
  }

  // export attachments
  Future<void> copyImagesToExportDirectory(List<Task> taskList) async {
    // Get directory where images are stored
    final originalDirectory = await getAppStorageDirectory();
    final externalStorageDir = await getExternalStorageDirectory();

    for (final task in taskList!) {
      if (task.attachment != null) {
        final taskAttachmentName = task.attachment?.split('/').last;
        final sourceFile = File('$originalDirectory/$taskAttachmentName');
        final destinationFile =
            File('${externalStorageDir!.path}/$taskAttachmentName');

        if (await sourceFile.exists()) {
          await sourceFile.copy(destinationFile.path);
        }
      }
    }
    print('Attachments exported to: ${externalStorageDir!.path}');
  }

  // to create a zip file with db and attachments
  Future<String> createZipArchive(List<Task> taskList) async {
    final externalStorageDir = await getExternalStorageDirectory();
    final archive = Archive();

    // Add the SQLite database to the archive
    final dbFile = File('${externalStorageDir!.path}/backup.db');
    final dbData = await dbFile.readAsBytes();
    archive.addFile(ArchiveFile('backup.db', dbData.length, dbData));

    for (final task in taskList) {
      if (task.attachment != null) {
        final taskAttachmentName = task.attachment?.split('/').last;
        final attachment =
            File('${externalStorageDir!.path}/$taskAttachmentName');
        final attachmentData = await attachment.readAsBytes();
        archive.addFile(ArchiveFile(
            taskAttachmentName!, attachmentData.length, attachmentData));
      }
    }

    // to store the zip file in the Download folder
    Directory downloadDirectory;

    if (Platform.isIOS) {
      downloadDirectory = await getApplicationDocumentsDirectory();
    } else {
      downloadDirectory = Directory('/storage/emulated/0/Download');
      if (!await downloadDirectory.exists()) {
        downloadDirectory = externalStorageDir;
      }
    }
    var uuid = const Uuid();

    // Create the ZIP file
    zipFile = File('${downloadDirectory!.path}/task_data_${uuid.v4()}.zip');

    if (await zipFile!.exists()) {
      await zipFile?.delete();
    }
    await zipFile?.writeAsBytes(ZipEncoder().encode(archive) ?? <int>[]);

    print('ZIP archive created at: ${zipFile?.path}');
    return zipFile!.path;
  }

  // when importing zip, unzip and copy content to app storage
  Future<void> importDatabaseAndAttachments(FilePickerResult result) async {
    if (result.files.isNotEmpty) {
      final dbFilePath = await getDatabasesPath();
      final zipFile = File(result.files.first.path!);

      final archive = ZipDecoder().decodeBytes(zipFile.readAsBytesSync());

      // Iterate through the entries
      for (final file in archive) {
        if (file.isFile) {
          final data = file.content;
          // find the DB
          if (file.name == 'backup.db') {
            final dbPath = '$dbFilePath/task_database.db';
            final dbFile = File(dbPath);
            await dbFile.writeAsBytes(data);
            print('Database imported to: $dbPath');
          } else {
            final originalDirectory = await getAppStorageDirectory();
            final attachmentPath = '$originalDirectory/${file.name}';
            final attachmentFile = File(attachmentPath);
            await attachmentFile.writeAsBytes(data, flush: true);
            print('Attachment imported to: $attachmentPath');
          }
        }
      }
      print('ZIP archive imported Success');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(context), body: _todoScreen(context));
  }

  // private function for appbar
  _appBar(BuildContext context) {
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
            Container(
              height: 35,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: PopupMenuButton<String>(
                icon: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                  size: 20,
                ),
                onSelected: (String value) {
                  setState(() {
                    if (value == selectedCategory) {
                      selectedCategory = null;
                    } else {
                      selectedCategory = value;
                    }
                  });
                },
                itemBuilder: (context) {
                  return categoryIcons.keys.map((String category) {
                    return PopupMenuItem<String>(
                      value: category,
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedCategory == category
                              ? Colors.grey[300]
                              : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Icon(
                                categoryIcons[category],
                                color: Colors.black,
                              ),
                              const SizedBox(width: 8),
                              Text(category),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ],
        ),
      ],
      toolbarHeight: 75,
      elevation: 0.0,
    );
  }

  //private function for todolist
  _todoScreen(BuildContext context) {
    return Stack(
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
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
                        size: 20.0,
                      ),
                      SizedBox(
                        width: 4,
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
                        size: 20.0,
                      ),
                      SizedBox(
                        width: 4,
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
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 150.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    var incompleteTasks = _taskController.taskList
                        .where((task) => task.isCompleted == 0)
                        .toList();
                    // for notification schedule
                    _scheduleNotificationsForDueTasks(incompleteTasks);
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
                          .where((task) => task.taskTitle!
                              .toLowerCase()
                              .contains(searchQuery))
                          .toList();
                    }

                    // to filter based on category
                    if (selectedCategory != null) {
                      if (selectedCategory == 'Health') {
                        incompleteTasks = incompleteTasks
                            .where((task) => task.category == "Health")
                            .toList();
                      }
                      if (selectedCategory == 'Work') {
                        incompleteTasks = incompleteTasks
                            .where((task) => task.category == "Work")
                            .toList();
                      }
                      if (selectedCategory == 'Finance') {
                        incompleteTasks = incompleteTasks
                            .where((task) => task.category == "Finance")
                            .toList();
                      }
                      if (selectedCategory == 'Education') {
                        incompleteTasks = incompleteTasks
                            .where((task) => task.category == "Education")
                            .toList();
                      }
                      if (selectedCategory == 'Travel') {
                        incompleteTasks = incompleteTasks
                            .where((task) => task.category == "Travel")
                            .toList();
                      }
                      if (selectedCategory == 'Shopping') {
                        incompleteTasks = incompleteTasks
                            .where((task) => task.category == "Shopping")
                            .toList();
                      }
                      if (selectedCategory == 'Entertainment') {
                        incompleteTasks = incompleteTasks
                            .where((task) => task.category == "Entertainment")
                            .toList();
                      }
                      if (selectedCategory == 'Other') {
                        incompleteTasks = incompleteTasks
                            .where((task) => task.category == "Other")
                            .toList();
                      }
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
                                print(task.toJson());
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                      // for the icon shown in task list for descriptions and attachemnts
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          if (task.taskDescription!
                                                  .isNotEmpty &&
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
                                            const Row(children: [
                                              Icon(
                                                Icons.menu,
                                                color: Colors.black,
                                                size: 12,
                                              ),
                                              SizedBox(width: 15),
                                              Icon(
                                                Icons.attachment,
                                                color: Colors.black,
                                                size: 12,
                                              ),
                                            ]),
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
                      onPressed: () async {
                        // Handle import logic
                        int imported = await _attachTaskFile();
                        Get.back();
                        if (imported == 1) {
                          Get.snackbar(
                            "Success",
                            "Task List Imported !",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.white,
                            icon: const Icon(Icons.warning_amber_rounded),
                            margin: const EdgeInsets.all(25.0),
                          );
                        }
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
                onPressed: () async {
                  // Handle export logic
                  String? path = await _exportTaskFile(context);
                  Get.back();
                  path != null
                      ? Get.snackbar(
                          "Success",
                          "Task List Exported to $path",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.white,
                          icon: const Icon(Icons.warning_amber_rounded),
                          margin: const EdgeInsets.all(25.0),
                        )
                      : Get.snackbar(
                          "Permission Denied",
                          "Please provide storage access permission",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.white,
                          icon: const Icon(Icons.warning_amber_rounded),
                          margin: const EdgeInsets.all(25.0),
                        );
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

  // to import db file
  Future<int> _attachTaskFile() async {
    // to delete cache if its there
    final directory = await getTemporaryDirectory();
    final filePickerPath = Directory("${directory.path}/file_picker");
    filePickerPath.delete(recursive: true);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    // if nothing selected
    if (result == null || result.files.first.extension != 'zip') {
      return 0;
    }

    await importDatabaseAndAttachments(result);
    _taskController.getTasks();
    result = null;
    return 1;
  }

  // to export db file
  Future<String?> _exportTaskFile(BuildContext context) async {
    //check the sdk version
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await plugin.androidInfo;
    //see if the permission is already granted
    if (androidDeviceInfo.version.sdkInt < 33) {
      var status = await Permission.storage.status;
      if (status.isGranted) {
        await exportDatabase();
        await copyImagesToExportDirectory(_taskController.taskList);
        return await createZipArchive(_taskController.taskList);
      } else {
        var request = await Permission.storage.request();
        if (request.isGranted) {
          await exportDatabase();
          await copyImagesToExportDirectory(_taskController.taskList);
          return await createZipArchive(_taskController.taskList);
        } else {
          return null;
        }
      }
    } else {
      await exportDatabase();
      await copyImagesToExportDirectory(_taskController.taskList);
      return await createZipArchive(_taskController.taskList);
    }
  }

  _scheduleNotificationsForDueTasks(List<Task>? taskList) {
    for (Task task in taskList!) {
      if (task.remind == null) {
        continue;
      }
      List<String>? dateParts = task.taskDate?.split('/');
      List<String>? timeParts = task.taskTime?.split(':');
      int day = int.parse(dateParts![0]);
      int month = int.parse(dateParts![1]);
      int year = int.parse(dateParts![2]);
      int hour = int.parse(timeParts![0]);
      int minutes = int.parse(timeParts[1]);
      DateTime taskDate = DateTime(year, month, day, hour, minutes);
      int remindDays = int.parse(task.remind!.split(' ')[0]);

      // Calculate the notification date based on the remindDays
      DateTime notificationDateTime =
          taskDate.subtract(Duration(days: remindDays));
      print(taskDate);
      print(notificationDateTime);
      // Schedule the notification for this task
      if (DateTime.now().isBefore(notificationDateTime)) {
        NotifyHelper().scheduleNotification(
            task.taskId, task.taskTitle, task.taskDate, notificationDateTime);
      }
    }
  }
}
