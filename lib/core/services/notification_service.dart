import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/home/domain/entities/habit_entity.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
          macOS: initializationSettingsDarwin,
        );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {},
    );
  }

  Future<void> requestPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<void> cancelHabitReminder(String habitId) async {
    await _notificationsPlugin.cancel(id: habitId.hashCode);
  }

  Future<void> scheduleHabitReminder(HabitEntity habit) async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('notification_enabled') ?? true;

    // Only schedule if globally enabled and the habit is not completed
    if (!isEnabled || habit.isCompleted) {
      await cancelHabitReminder(habit.id);
      return;
    }

    final scheduledDate = tz.TZDateTime.from(habit.targetDateTime, tz.local);

    // Don't schedule if the time has already passed
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      await cancelHabitReminder(habit.id);
      return;
    }

    await _notificationsPlugin.zonedSchedule(
      id: habit.id.hashCode,
      title: 'Habitly Reminder 🎯',
      body: 'Time for your habit: ${habit.title}!',
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_reminder_channel',
          'Habit Reminders',
          channelDescription: 'Reminds you to complete your specific habits',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
