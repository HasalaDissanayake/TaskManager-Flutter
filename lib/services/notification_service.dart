import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotifyHelper{

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("todo_black");

    final InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid
    );

    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: selectNotification
    );
  }

  // displayNotification({required String title, required String body}) async {
  //   print("doing test");
  //   var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
  //       'your channel id', 'your channel name',
  //       importance: Importance.max, priority: Priority.high);
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     title,
  //     body,
  //     platformChannelSpecifics,
  //     payload: 'It could be anything you pass',
  //   );
  // }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void selectNotification(NotificationResponse? notificationResponse) {
    if (notificationResponse != null && notificationResponse.payload != null) {
      print('notification payload: ${notificationResponse.payload}');
    } else {
      print("Notification Done");
    }
    Get.to(()=>Container(color: Colors.white,));
  }

  Future onDidReceiveLocalNotification( int id, String? title, String? body, String? payload) async {
    Get.dialog(const Text("Welcome To ToDo"));
  }
}