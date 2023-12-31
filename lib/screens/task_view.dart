import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:taskmanager/controllers/task_controller.dart';

import '../models/task.dart';

class TaskPageView extends StatefulWidget {
  const TaskPageView({super.key});

  @override
  State<TaskPageView> createState() => _TaskPageViewState();
}

class _TaskPageViewState extends State<TaskPageView> {
  // get db values
  final task = Get.arguments;
  final TaskController _taskController = Get.put(TaskController());

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? selectedCategory;
  String? updatedCategory;
  String selectedPriority = 'Low';
  String? updatedPriority;

  String? selectedReminder;
  String? updatedReminder;

  String? selectedFileName = '';
  String? selectedFilePath = '';
  String? relativePath;

  DateTime selectedDate = DateTime.now();
  DateTime? updatedDate;
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay? updatedTime;
  bool switchDateValue = true;
  bool switchTimeValue = true;
  bool isCompleted = false;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: updatedDate ?? selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        updatedDate = pickedDate!;
      });
    } else {
      switchDateValue = false;
    }
  }

  // for file storing relative path is considered
  Future<String> getAppStorageDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        updatedTime = pickedTime;
      });
    } else {
      switchTimeValue = false;
    }
  }

  //convert string to TimeOfDay
  TimeOfDay stringToTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return TimeOfDay(hour: hours, minute: minutes);
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = task.taskTitle;
    _descriptionController.text = task.taskDescription ?? "";
    selectedCategory = task.category;

    //convert string to DateTime
    String dateString = task.taskDate;
    DateFormat format = DateFormat("dd/M/yyyy");
    DateTime dateTime = format.parse(dateString);
    selectedDate = dateTime;
    isCompleted = task.isCompleted == 0 ? false : true;

    selectedTime = stringToTimeOfDay(task.taskTime);
    selectedPriority = task.priority;
    selectedReminder = task.remind;
    relativePath = task.attachment;

    selectedFileName = relativePath?.split('/').last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    "${task.taskTitle}",
                    style: const TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Icon(
                    Icons.rate_review,
                    size: 40,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _titleController,
                enabled: isCompleted ? false : true,
                decoration: const InputDecoration(
                  hintText: 'Enter task title',
                  hintStyle: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _descriptionController,
                enabled: isCompleted ? false : true,
                decoration: InputDecoration(
                  hintText: !isCompleted
                      ? 'Enter task description'
                      : 'No description',
                  hintStyle: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            //Select Category drop down
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.category,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    'Select Category',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: updatedCategory ?? selectedCategory,
                    hint: const Text("None"),
                    items: <String>[
                      'Health',
                      'Work',
                      'Finance',
                      'Education',
                      'Travel',
                      'Shopping',
                      'Entertainment',
                      'Other',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: !isCompleted
                        ? (String? value) {
                            setState(() {
                              updatedCategory =
                                  value; // Update the selected value
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    'Pick Date',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  _dueDateSwitch(),
                ],
              ),
            ),
            if ((selectedDate != null || updatedDate != null) &&
                switchDateValue == true)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  updatedDate != null
                      ? 'Date: ${updatedDate?.day}/${updatedDate?.month}/${updatedDate?.year}'
                      : 'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
            //Input field to select the time
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.alarm,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    'Pick Time',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  _dueTimeSwitch(),
                ],
              ),
            ),
            if (switchTimeValue == true)
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 16.0),
                child: Text(
                  updatedTime != null
                      ? 'Time: ${updatedTime?.hour}:${updatedTime?.minute}'
                      : 'Time: ${selectedTime.hour}:${selectedTime.minute}',
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
            //upload a file
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.attach_file,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    'Attachments',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: (selectedFileName == null ||
                              selectedFileName!.isEmpty)
                          ? Colors.grey[200]
                          : Colors.black,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    //button to upload a file
                    child: IgnorePointer(
                      ignoring: isCompleted ? true : false,
                      child: GestureDetector(
                        onTap: () {
                          _showUploadDialog(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 3.0,
                          ),
                          decoration: BoxDecoration(
                            color: (selectedFileName == null ||
                                    selectedFileName!.isEmpty)
                                ? Colors.grey[200]
                                : Colors.black,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          //upload Icon here
                          child: Icon(
                            Icons.upload_file,
                            color: (selectedFileName == null ||
                                    selectedFileName!.isEmpty)
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (selectedFileName != null && selectedFileName!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        final fileExtension =
                            selectedFileName!.toLowerCase().split('.').last;

                        fileExtension != "pdf"
                            ? Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) {
                                    return Scaffold(
                                      appBar: AppBar(),
                                      body: PhotoView(
                                        imageProvider: FileImage(File(
                                            selectedFilePath != ''
                                                ? selectedFilePath.toString()
                                                : relativePath!)),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) {
                                    return Scaffold(
                                      appBar: AppBar(),
                                      body: PDFView(
                                        filePath: selectedFilePath == ''
                                            ? relativePath
                                            : selectedFilePath,
                                      ),
                                    );
                                  },
                                ),
                              );
                      },
                      child: SizedBox(
                        width: 300,
                        child: Text(
                          selectedFileName!,
                          style: const TextStyle(fontSize: 15.0),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        !isCompleted
                            ? setState(() {
                                selectedFileName = '';
                                relativePath = null;
                              })
                            : null;
                      },
                    ),
                  ],
                ),
              ),
            //priority dropdown with a dot to indicate the priority
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.priority_high,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    'Priority',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: updatedPriority ?? selectedPriority,
                    items:
                        <String>['High', 'Medium', 'Low'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            if (value == 'High')
                              const Icon(
                                Icons.circle,
                                color: Colors.red,
                                size: 16.0,
                              ),
                            if (value == 'Medium')
                              const Icon(
                                Icons.circle,
                                color: Colors.yellow,
                                size: 16.0,
                              ),
                            if (value == 'Low')
                              const Icon(
                                Icons.circle,
                                color: Colors.green,
                                size: 16.0,
                              ),
                            const SizedBox(width: 8.0),
                            Text(
                              value,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: !isCompleted
                        ? (String? value) {
                            setState(() {
                              updatedPriority =
                                  value!; // Update the selected value
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ),
            //reminder drop down
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    'Remind',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: updatedReminder ?? selectedReminder,
                    hint: const Text("None"),
                    items: <String>[
                      '1 Day early',
                      '2 Days early',
                      '7 Days early'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: !isCompleted
                        ? (String? value) {
                            setState(() {
                              updatedReminder =
                                  value; // Update the selected value
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ),
            //update task button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  _validateForm();
                },
                child: !isCompleted
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Center(
                            child: Text(
                          'Update Task',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        )),
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
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
                  'Attach a file/image :',
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
                        _handleAttach(context);
                        Get.back(); // Close the dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child: (selectedFileName == null ||
                              selectedFileName!.isEmpty)
                          ? const Text('Browse')
                          : const Text("Change"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // attach a file to a task
  _handleAttach(BuildContext context) async {
    final appStorageDir = await getAppStorageDirectory();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      // Handle the selected file
      PlatformFile file = result.files.first;
      final File temp = File(file.path!);

      relativePath = '$appStorageDir/${file.name}';
      final fileCopy = File(relativePath!);
      try {
        await fileCopy.writeAsBytes(temp.readAsBytesSync());
      } catch (e) {
        null;
      }

      setState(() {
        selectedFileName = file.name;
        selectedFilePath = file.path;
      });
    } else {
      return;
    }
  }

  _validateForm() {
    if (_titleController.text.isNotEmpty) {
      _updateDatabase();
      _taskController.getTasks();
      Get.back();
    } else if (_titleController.text.isEmpty) {
      Get.snackbar("Required", "Please add a task title !",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          icon: const Icon(Icons.warning_amber_rounded));
    }
  }

  // update database
  _updateDatabase() async {
    await _taskController.updateTask(
        task: Task(
      taskId: task.taskId,
      taskTitle: _titleController.text,
      taskDescription: _descriptionController.text,
      category: updatedCategory ?? selectedCategory,
      taskDate: updatedDate != null
          ? "${updatedDate?.day}/${updatedDate?.month}/${updatedDate?.year}"
          : "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
      taskTime: updatedTime != null
          ? "${updatedTime?.hour}:${updatedTime?.minute}"
          : "${selectedTime.hour}:${selectedTime.minute}",
      attachment: relativePath,
      priority: updatedPriority ?? selectedPriority,
      remind: updatedReminder ?? selectedReminder,
      isCompleted: 0,
    ));
  }

  // toggle due date
  _dueDateSwitch() {
    return Switch(
      value: switchDateValue,
      activeColor: Colors.black,
      onChanged: (bool value) {
        if (!isCompleted) {
          setState(() {
            switchDateValue = value;
            if (value) {
              _selectDate(context);
            } else {
              updatedDate = DateTime.now();
            }
          });
        } else {
          null;
        }
      },
    );
  }

  // toggle due time
  _dueTimeSwitch() {
    return Switch(
      value: switchTimeValue,
      activeColor: Colors.black,
      onChanged: (bool value) {
        if (!isCompleted) {
          setState(() {
            switchTimeValue = value;
            if (value) {
              _selectTime(context);
            } else {
              updatedTime = TimeOfDay.now();
            }
          });
        } else {
          null;
        }
      },
    );
  }
}
