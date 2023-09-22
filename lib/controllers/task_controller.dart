import 'package:get/get.dart';
import 'package:taskmanager/Database/db_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController{

  @override
  void onReady(){
    super.onReady();
  }

  // observable variable
  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async{
    return await DBHelper.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void deleteTask(Task task) async {
    await DBHelper.delete(task);
  }

  void markTaskCompleted(int? taskId) async{
    await DBHelper.updateState(taskId!);
  }

}