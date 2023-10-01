import 'package:awesome_notifications/awesome_notifications.dart';

class NotifyHelper {
  scheduleNotification(
      int? id, String? title, String? taskDate, DateTime scheduleTime) async {
    bool isallowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isallowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    } else {
      //show notification
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id ?? 0,
          channelKey: 'ToDo',
          title: 'Task Reminder',
          body: 'Your task $title is due on $taskDate',
          wakeUpScreen: true,
        ),
        schedule: NotificationCalendar(
            day: scheduleTime.day,
            month: scheduleTime.month,
            year: scheduleTime.year,
            hour: scheduleTime.hour,
            minute: scheduleTime.minute),
      );
    }
  }
}
