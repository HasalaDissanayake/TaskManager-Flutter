import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:accordion/accordion.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  static const headerStyle = TextStyle(
      color: Color(0xff000000), fontSize: 20, fontWeight: FontWeight.bold);
  static const contentStyle = TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Positioned(
            // left: 100,
            top: 100,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Help &\nSupport',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 64,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, right: 20),
                      child: SvgPicture.asset(
                          'assets/icons/faq.svg',
                          width: 70,
                          height: 70,
                      ),
                    ),
                  ],
                )
              ),
          ),

          Accordion(
            children: generateAccordionSections(),
          ),
        ],
      )
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: GestureDetector(
        onTap: () {

        },
        child: Container(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            height: 40,
            width: 40,
          ),
        ),
      ),
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
          style: headerStyle,
        ),
        content: Text(
          answers[index],
          style: contentStyle,
        ),
      );
    });
  }

}
