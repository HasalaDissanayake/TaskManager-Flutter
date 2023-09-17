import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    'Create New Task',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                      width: 10.0), // Add spacing between text and image
                  Image.asset(
                    'assets/images/notebook.png',
                    width: 50.0,
                    height: 50.0,
                  ),
                ],
              ),
            ),
            // Input field to enter task title
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
            // Input area to enter task description
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
            // Row with date icon and date text and a switch to open the date picker
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
                    onSwitched: (value) {
                      setState(() {
                        switchValue = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            DatePickerSection(
              isDatePickerVisible: switchValue,
            ),
          ],
        ),
      ),
    );
  }
}

class DueDateSwitch extends StatefulWidget {
  final bool switchValue;
  final Function(bool) onSwitched;

  const DueDateSwitch({Key? key, required this.switchValue, required this.onSwitched});

  @override
  State<DueDateSwitch> createState() => _DueDateSwitchState();
}

class _DueDateSwitchState extends State<DueDateSwitch> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.switchValue,
      activeColor: Colors.black,
      onChanged: (bool value) {
        widget.onSwitched(value);
      },
    );
  }
}

class DatePickerSection extends StatelessWidget {
  final bool isDatePickerVisible;

  const DatePickerSection({Key? key, required this.isDatePickerVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isDatePickerVisible,
      child: DatePickerWidget(),
    );
  }
}

class DatePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2021),
              lastDate: DateTime(2022),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData.light(),
                  child: child!,
                );
              },
            );
          },
          child: const Text('Open Date Picker'),
        ),
      ),
    );
  }
}
