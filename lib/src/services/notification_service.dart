import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  static const String _channelId = 'reminders_channel';
  static const String _channelName = 'Reminders';
  static const String _channelDescription = 'Lembretes e notificações do Reminders';

  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (_) {},
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    _initialized = true;
  }

  NotificationDetails get _notificationDetails {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    return const NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }

  Future<void> scheduleTaskReminder({
    required int notificationId,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    if (!_initialized) await initialize();

    if (scheduledDate.isBefore(DateTime.now())) return;

    await _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> cancelTaskReminder(int notificationId) async {
    await _plugin.cancel(notificationId);
  }

  Future<void> showPomodoroCompleteNotification() async {
    if (!_initialized) await initialize();

    await _plugin.show(
      9999,
      'Pomodoro concluído!',
      'Parabéns! Você completou uma sessão de foco de 25 minutos.',
      _notificationDetails,
    );
  }
}
