import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:taskmanager/screens/add_new_task.dart';
import 'package:taskmanager/screens/completed_tasks_list.dart';
import 'package:taskmanager/screens/faq.dart';
import 'package:taskmanager/screens/home_page.dart';
import 'package:taskmanager/screens/theme.dart';

Future<void> main() async {
  // await the initialization until GetStorage in setup
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
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
      routes: {
        '/faq' : (context) => const FaqPage(),
        '/addNewTask' : (context) => const AddTaskPage(),
        '/completedTasks' : (context) => const CompletedTaskPage()
      },
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

