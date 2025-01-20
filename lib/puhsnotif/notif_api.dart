import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseApi() {
    initNotifications();
  }
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    await initLocalNotifications();

    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');

    initPushNotifications();
  }

  Future<void> initLocalNotifications() async {
    await AwesomeNotifications().initialize(
      null, // icon untuk notifikasi
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        )
      ],
    );
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }


  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    // Handle notification when app is opened from terminated state
  }

  Future initPushNotifications() async {
    // Handle notification when app is terminated
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // Handle notification when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // Handle notification when app is in foreground
    FirebaseMessaging.onMessage.listen((message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}