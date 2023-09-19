import 'package:flutter/material.dart';

class completed_tasks_list extends StatelessWidget {
  const completed_tasks_list({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Container(
          height: 800,
          child: Column(
            children: [
              titleBar(),
              tasksList(),
              addTaskButton(),
            ],
          ),
        ),
      ),
    );
  }


  Widget titleBar() {
    return Container(
        margin: EdgeInsets.only(
          left: 20,
          bottom: 100,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Completed\nList',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 48,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: 1.68,
                ),
              ),
            ),
            Icon(
              Icons.task,
              color: Colors.black,
              size: 80,
            )
          ],
        ));
  }

  Widget sortButton() {
    return Container(
      margin: EdgeInsets.only(
        top: 30,
        left: 300,
        bottom: 50,
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            color: Colors.black,
            size: 30,
          ),
          Container(
            margin: EdgeInsets.only(
              left: 5,
            ),
            child: Text(
              'Sort',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 0,
                letterSpacing: -0.26,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget tasksList() {
    return Table(
      columnWidths: {
        0: FlexColumnWidth(1.05), // Adjust the width of the first column
        1: FlexColumnWidth(1.0), // Adjust the width of the second column
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            TableCell(
                child: Container(
                  // width: 100,
                  margin: EdgeInsets.only(left: 30),
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Sweep the floor/vacuum',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                          letterSpacing: -0.36,
                        ),
                      ),
                    ],
                  ),
                )),
            TableCell(
              child: Container(
                margin: EdgeInsets.only(
                  left: 140,
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(
                      Icons.cleaning_services,
                      color: Colors.black,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
                child: Container(
                  margin: EdgeInsets.only(left: 30),
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Clean the room',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                          letterSpacing: -0.36,
                        ),
                      ),
                    ],
                  ),
                )),
            TableCell(
              child: Container(
                margin: EdgeInsets.only(
                  left: 140,
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(
                      Icons.cleaning_services,
                      color: Colors.black,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
                child: Container(
                  margin: EdgeInsets.only(left: 30),
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Workout',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                          letterSpacing: -0.36,
                        ),
                      ),
                    ],
                  ),
                )),
            TableCell(
              child: Container(
                margin: EdgeInsets.only(
                  left: 140,
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(
                      Icons.fitness_center,
                      color: Colors.black,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
                child: Container(
                  margin: EdgeInsets.only(left: 30),
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Go shopping with friends',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                          letterSpacing: -0.36,
                        ),
                      ),
                    ],
                  ),
                )),
            TableCell(
              child: Container(
                margin: EdgeInsets.only(
                  left: 140,
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
                child: Container(
                  margin: EdgeInsets.only(left: 30),
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Study HCI',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                          letterSpacing: -0.36,
                        ),
                      ),
                    ],
                  ),
                )),
            TableCell(
              child: Container(
                margin: EdgeInsets.only(
                  left: 140,
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(
                      Icons.book,
                      color: Colors.black,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget addTaskButton() {
    return ClipOval(
      child: ElevatedButton(
        onPressed: () {
          // Add your logic to handle adding a new task here
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
          minimumSize: Size(20, 80),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white, // Color of the plus sign (white)
          size: 50,
        ),
      ),
    );
  }




  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 25,
          )
        ],
      ),
    );
  }
}
