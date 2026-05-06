import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class NotificationService {
  // Single instance of the notifications plugin used throughout the app
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Sets up everything needed for notifications to work
  static Future<void> init() async {
    // Load all timezone data and set the local timezone to Manila
    tzData.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Manila'));

    // Initialize the plugin with the app's default icon for andorid
    await notificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    // Run setup steps for channel, alarm, and battery permissions
    await _createNotificationChannel();
    await _requestExactAlarmPermission();
    await _requestBatteryOptimization();
  }

  // Creates a notification channel required for android 8.0 and above
  static Future<void> _createNotificationChannel() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        'task_channel', // Channel ID
        'Task Reminders', // Channel name shown in settings
        description: 'Notification channel for task reminders',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      ),
    );

    debugPrint('✅ Notification channel created');
  }

  // Asks the user to allow scheduling exact-time alarms
  static Future<void> _requestExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    if (!status.isGranted) {
      final result = await Permission.scheduleExactAlarm.request();
      debugPrint('✅ Exact alarm permission: $result');
    } else {
      debugPrint('✅ Exact alarm already granted');
    }
  }

  // Asks the user to let the app run without battery-saving restrictions
  static Future<void> _requestBatteryOptimization() async {
    final status = await Permission.ignoreBatteryOptimizations.status;
    if (!status.isGranted) {
      final result = await Permission.ignoreBatteryOptimizations.request();
      debugPrint('✅ Battery optimization exemption: $result');
    } else {
      debugPrint('✅ Battery optimization already exempted');
    }
  }

  // Cancels a specific notification by its ID
  static Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }

  // Cancels all scheduled and active notifications
  static Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  // Schedules a notification to appear at a specific date and time
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    // Don't schedule if the date has already passed
    if (scheduledDate.isBefore(DateTime.now())) {
      debugPrint('❌ Skipped — date is in the past: $scheduledDate');
      return;
    }

    debugPrint('✅ Scheduling notification for: $scheduledDate');

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local), // Convert to local timezone
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Reminders',
          channelDescription: 'Notification channel for task reminders',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          fullScreenIntent: true, // Shows even when the phone is locked
        ),
      ),
      // Fire at exact time even if the device is in idle/doze mode
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    debugPrint('✅ Notification scheduled successfully');
  }
}
