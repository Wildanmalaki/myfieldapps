import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service untuk local notification aplikasi.
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _hourlyPromoNotificationId = 701;

  final List<String> _promoBodies = const [
    'Cek promo booking lapangan terbaru di MyField dan amankan slot favoritmu.',
    'Lagi cari teman main? Buka Community Event MyField, bisa jadi ada match seru hari ini.',
    'Jangan sampai kelewatan promo lapangan. Booking lebih cepat, main lebih hemat di MyField.',
    'Upload event olahraga kamu di MyField dan ajak pemain lain gabung setiap saat.',
  ];

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@drawable/ic_launcher_foreground',
    );
    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(initializationSettings);

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  Future<void> scheduleHourlyPromoNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'myfield_hourly_promo',
      'Promo MyField',
      channelDescription:
          'Notifikasi promo dan info aplikasi MyField tiap jam.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    final body = _promoBodies[Random().nextInt(_promoBodies.length)];

    await _plugin.periodicallyShow(
      _hourlyPromoNotificationId,
      'Promo MyField',
      body,
      RepeatInterval.hourly,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelHourlyPromoNotification() async {
    await _plugin.cancel(_hourlyPromoNotificationId);
  }
}
