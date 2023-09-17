import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TaskForm(),
    );
  }
}

class TaskForm extends StatefulWidget {
  const TaskForm({Key? key}) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  bool switchValue = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedCategory;
  String? selectedPriority;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
            ),
          ),
          child: child!,
        );
      },
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        switchValue = false; // Hide the calendar after selecting a date
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
            ),
          ),
          child: child!,
        );
      },
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        switchValue = false; // Hide the calendar after selecting a date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text('ToDo'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            // Implement navigation back logic here
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
            'assets/images/todo_black.png',
            width: 32.0,
            height: 32.0,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'Create New Task',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 35.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Image.asset(
                  'assets/images/notebook.png',
                  width: 50.0,
                  height: 50.0,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter task title',
                  hintStyle: TextStyle(
                    fontFamily: 'Raleway',
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
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter task description',
                  hintStyle: TextStyle(
                    fontFamily: 'Raleway',
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
                      fontFamily: 'Raleway',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  DropdownButton<String>(
                    value: selectedCategory, // Add this line to set the selected value
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
                            fontFamily: 'Raleway',
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
                    'Pick Due Date',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  DueDateSwitch(
                    switchValue: switchValue,
                    onSwitched: (bool value) {
                      setState(() {
                        switchValue = value;
                        if (switchValue) {
                          _selectDate(context);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            if (selectedDate != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Due Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
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
                    'Pick Due Time',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  DueTimeSwitch(
                    switchValue: switchValue,
                    onSwitched: (bool value) {
                      setState(() {
                        switchValue = value;
                        if (switchValue) {
                          _selectTime(context);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            if(selectedTime != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 16.0),
                child: Text(
                  'Due Time: ${selectedTime!.hour}:${selectedTime!.minute}',
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
                    'Attach File',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
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
                      fontFamily: 'Raleway',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
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
                                fontFamily: 'Raleway',
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
                        selectedPriority = value; // Update the selected value
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
                  // Implement create task logic here
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
                          fontFamily: 'Raleway',
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

class DueDateSwitch extends StatefulWidget {
  final bool switchValue;
  final Function(bool) onSwitched;

  const DueDateSwitch({
    Key? key,
    required this.switchValue,
    required this.onSwitched,
  });

  @override
  State<DueDateSwitch> createState() => _DueDateSwitchState();
}

class _DueDateSwitchState extends State<DueDateSwitch> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.switchValue,
      activeColor: Colors.black,
      onChanged: widget.onSwitched,
    );
  }
}

class DueTimeSwitch extends StatefulWidget {
  final bool switchValue;
  final Function(bool) onSwitched;

  const DueTimeSwitch({
    Key? key,
    required this.switchValue,
    required this.onSwitched,
  });

  @override
  State<DueTimeSwitch> createState() => _DueTimeSwitchState();
}

class _DueTimeSwitchState extends State<DueTimeSwitch> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.switchValue,
      activeColor: Colors.black,
      onChanged: widget.onSwitched,
    );
  }
}

