import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:taskmanager/Database/db_helper.dart';
import 'package:taskmanager/screens/home_page.dart';
import 'package:taskmanager/screens/theme.dart';

Future<void> main() async {
  // await the initialization until GetStorage in setup
  WidgetsFlutterBinding.ensureInitialized();
  //init db
  await DBHelper.initDb();
  await GetStorage.init();
  //init notification service
  AwesomeNotifications().initialize('resource://drawable/app_icon', [
    NotificationChannel(
      channelGroupKey: 'ToDo',
      channelKey: 'ToDo',
      channelName: 'ToDo',
      channelDescription: 'Task due date reminder notification',
      channelShowBadge: true,
      importance: NotificationImportance.Max,
      enableVibration: true,
    ),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ToDo',
      debugShowCheckedModeBanner: false,
      theme: Themes.theme,
      home: const SplashScreen(),
    );
  }
}

// Splash Screen Window
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset('assets/images/todo_white.png'),
      nextScreen: const HomePage(),
      backgroundColor: Colors.black,
      splashIconSize: 250,
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
