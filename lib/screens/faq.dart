import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Help & Support',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: 10.0),
                  Icon(
                    Icons.quiz,
                    size: 40,
                  ),
                ],
              ),
            ),
            Accordion(
              children: generateAccordionSections(),
            ),
          ],
        ));
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

  List<AccordionSection> generateAccordionSections() {
    const List<String> questions = [
      'What is the purpose of this app?',
      'How do I create a new task?',
      'Can I categorize my tasks?',
      'How do I set reminders for my tasks?',
      'Can I attach files or images to tasks?',
    ];

    const List<String> answers = [
      'This app is designed to help users efficiently manage and organize their tasks, ensuring they stay on top of their to-do lists and priorities.',
      'You can create a task using + icon in the bottom of the home.',
      'Yes, You can categorize your task using "Select Category" dropdown menu.',
      'This app is designed to help users efficiently manage and organize their tasks, ensuring they stay on top of their to-do lists and priorities.',
      'Yes, You can attach files to your tasks.',
    ];

    // generate a list of FAQs
    return List<AccordionSection>.generate(questions.length, (index) {
      return AccordionSection(
        rightIcon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black26,
          size: 30,
        ),
        isOpen: false,
        headerBackgroundColor: Colors.transparent,
        headerPadding: const EdgeInsets.only(left: 10, top: 15),
        paddingBetweenClosedSections: 15,
        contentVerticalPadding: 20,
        contentBorderWidth: 0,
        contentBorderColor: Colors.transparent,
        header: Text(
          '${index + 1}. ${questions[index]}',
          style: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Text(
          answers[index],
          textAlign: TextAlign.left,
          style: const TextStyle(
              color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal),
        ),
      );
    });
  }
}
