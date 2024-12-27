
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {


  static void initialize() {
    // Initialization  setting for android
    const InitializationSettings initializationSettingsAndroid =
    InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _notificationsPlugin.initialize(
      initializationSettingsAndroid,
      // to handle event when we receive notification
      onDidReceiveNotificationResponse: (details) {
        if (details.input != null) {}
      },
    );
  }

  // Instance of Flutternotification plugin
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> display(RemoteMessage message) async {
    // To display the notification in device

      print(message.notification!.title);
      final id = DateTime
          .now()
          .millisecondsSinceEpoch ~/ 1000;
      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            message.notification!.title!,
            message.notification!.body!,

            groupKey: "Sourcing APP",
            color: Colors.green,
            importance: Importance.max,

            styleInformation: MediaStyleInformation(
              htmlFormatTitle: true,
              htmlFormatContent: true

            ),
            // different sound for
            // different notification
            playSound: true,
            priority: Priority.high),
      );
      await _notificationsPlugin.show(id, message.notification?.title,
          message.notification?.body, notificationDetails);

  }

}