import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // INIT
  static Future<void> init() async {
    // Fix: use tzData alias to avoid conflict with tz alias
    tzData.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Manila'));

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await notificationsPlugin.initialize(initSettings);
  }

  // CANCEL NOTIFICATION
  static Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }

  // CANCEL ALL NOTIFICATIONS
  static Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  // SCHEDULE NOTIFICATION
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    // Don't schedule if date is in the past
    if (scheduledDate.isBefore(DateTime.now())) return;

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Reminders',
          channelDescription: 'Notification channel for task reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime, // ← add this back
    );
  }
}
