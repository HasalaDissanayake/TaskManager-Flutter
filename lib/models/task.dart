class Task {
  int? taskId;
  String? taskTitle;
  String? taskDescription;
  String? category;
  String? taskDate;
  String? taskTime;
  String? priority;
  String? remind;
  int? isCompleted;
  String? attachment;

  Task({
    this.taskId,
    required this.taskTitle,
    this.taskDescription,
    this.category,
    required this.taskDate,
    required this.taskTime,
    required this.priority,
    this.remind,
    required this.isCompleted,
    this.attachment,
  });

  // convert from json
  Task.fromJson(Map<String, dynamic> json) {
    taskId = json['task_id'];
    taskTitle = json['task_title'];
    taskDescription = json['task_description'];
    category = json['category'];
    taskDate = json['task_date'];
    taskTime = json['task_time'];
    priority = json['priority'];
    remind = json['remind'];
    isCompleted = json['is_completed'];
    attachment = json['attachment'];
  }

  // map retrieved data to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['task_id'] = taskId;
    data['task_title'] = taskTitle;
    data['task_description'] = taskDescription;
    data['category'] = category;
    data['task_date'] = taskDate;
    data['task_time'] = taskTime;
    data['priority'] = priority;
    data['remind'] = remind;
    data['is_completed'] = isCompleted;
    data['attachment'] = attachment;
    return data;
  }
}
