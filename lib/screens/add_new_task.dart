import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/controllers/task_controller.dart';
import 'package:taskmanager/models/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  final _taskController = Get.put(TaskController());

  final  _titleController = TextEditingController();
  final  _descriptionController = TextEditingController();

  String? selectedCategory;
  String selectedPriority = 'Low';
  String? selectedReminder;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool switchDateValue = false;
  bool switchTimeValue = false;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate!;
      });
    }
    else{
      switchDateValue = false;
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
    else {
      switchTimeValue = false;
    }
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
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'Create New Task',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Icon(
                    Icons.description,
                    size: 50,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _titleController,
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
                decoration: const InputDecoration(
                  hintText: 'Enter task description',
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
                    value: selectedCategory,
                    hint: const Text("None"),
                    items: <String>[
                      'Health',
                      'Work',
                      'Education',
                      'Entertainment',
                      'Exercise',
                      'Food',
                      'Other'
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
                    onChanged: (String? value) {
                      setState(() {
                        selectedCategory = value; // Update the selected value
                      });
                    },
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
            if (selectedDate != null && switchDateValue == true)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
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
            if(selectedTime != null && switchTimeValue == true)
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 16.0),
                child: Text(
                  'Time: ${selectedTime.hour}:${selectedTime.minute}',
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
                  GestureDetector(
                    onTap: () {
                      // Implement file upload logic here
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      //button to upload a file
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
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          //upload Icon here
                          child: const Icon(
                            Icons.upload_file,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
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
                    value: selectedPriority, // Add this line to set the selected value
                    items: <String>['High', 'Medium', 'Low'].map((String value) {
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
                    onChanged: (String? value) {
                      setState(() {
                        selectedPriority = value!; // Update the selected value
                      });
                    },
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
                    value: selectedReminder, // Add this line to set the selected value
                    hint: const Text("None"),
                    items: <String>['5 mins early', '10 mins early', '15 mins early'].map((String value) {
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
                    onChanged: (String? value) {
                      setState(() {
                        selectedReminder = value; // Update the selected value
                      });
                    },
                  ),
                ],
              ),
            ),
            //create task button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  _validateForm();
                },
                child: Container(
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
                        'Create Task',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      )
                  ),
                ),
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
                padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0),
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
            ],
          ),
        );
      },
    );
  }

  // don't remove the below code needed for referencing

  // void _showUploadDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Upload File'),
  //         content: Text('Choose a file to upload.'),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () async {
  //               FilePickerResult? result = await FilePicker.platform.pickFiles();
  //               if (result != null) {
  //                 // Handle the selected file
  //                 PlatformFile file = result.files.first;
  //                 // TODO: Implement file upload logic
  //                 print('File picked: ${file.name}');
  //                 print('File path: ${file.path}');
  //               } else {
  //                 // User canceled the file picker
  //                 print('File selection canceled.');
  //               }
  //
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text('Choose a file'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text('Cancel'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  _validateForm() {
    if(_titleController.text.isNotEmpty){
      _addDataToDatabase();
      Get.back();
    } else if (_titleController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required !",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        icon: const Icon(
          Icons.warning_amber_rounded
        )
      );
    }

  }

  // adding data to database
  _addDataToDatabase() async {
    await _taskController.addTask(
      task: Task(
          taskTitle: _titleController.text,
          taskDescription: _descriptionController.text,
          category: selectedCategory,
          taskDate: "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
          taskTime: "${selectedTime.hour}:${selectedTime.minute}",
          attachment: null,
          priority: selectedPriority,
          remind: selectedReminder,
          isCompleted: 0,
      )
    );
  }

  _dueDateSwitch() {
    return Switch(
      value: switchDateValue,
      activeColor: Colors.black,
      onChanged: (bool value) {
        setState(() {
          switchDateValue = value;
          if (value) {
            _selectDate(context);
          }
          else{
            selectedDate = DateTime.now();
          }
        });
      },
    );
  }

  _dueTimeSwitch() {
    return Switch(
      value: switchTimeValue,
      activeColor: Colors.black,
      onChanged: (bool value) {
        setState(() {
          switchTimeValue = value;
          if (value) {
            _selectTime(context);
          }
          else{
            selectedTime = TimeOfDay.now();
          }
        });
      },
    );
  }

}


