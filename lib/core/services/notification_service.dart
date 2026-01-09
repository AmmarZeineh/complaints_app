import 'dart:developer';
import 'package:complaints_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  // Global Navigator Key لاستخدامه في التنقل
  static GlobalKey<NavigatorState>? navigatorKey;

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await _initializedLocalNotification();
    await _showFlutterNotification(message);
  }

  static Future<void> initializeNotification({
    GlobalKey<NavigatorState>? navKey,
  }) async {
    navigatorKey = navKey;

    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // عند وصول إشعار والتطبيق مفتوح
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _showFlutterNotification(message);
    });

    // عند الضغط على الإشعار والتطبيق في الخلفية
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });

    await _getFcmToken();
    await _initializedLocalNotification();
    await _getInitialNotification();
    await _setupNotificationChannels();
  }

  static Future<void> _showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic> data = message.data;

    String title = notification?.title ?? data['title'] ?? 'No Title';
    String body = notification?.body ?? data['body'] ?? 'No body';

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'Notification channel for basic test',
      icon: 'notification_icon',
      priority: Priority.high,
      importance: Importance.high,
    );

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // تمرير الـ payload كـ JSON لاستخدامها عند الضغط
    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      title,
      body,
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  static Future<void> _initializedLocalNotification() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('notification_icon');

    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

    final InitializationSettings initSetting = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSetting,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // عند الضغط على الإشعار
        if (response.payload != null) {
          _handleLocalNotificationTap(response.payload!);
        }
      },
    );
  }

  static Future<void> _getInitialNotification() async {
    // عند فتح التطبيق من إشعار وهو مغلق تماماً
    RemoteMessage? message = await FirebaseMessaging.instance
        .getInitialMessage();
    if (message != null) {
      _handleNotificationTap(message);
    }
  }

  static void _handleNotificationTap(RemoteMessage message) {
    Map<String, dynamic> data = message.data;

    // فحص نوع الإشعار والتوجيه للصفحة المناسبة
    if (data.containsKey('type')) {
      String notificationType = data['type'];

      switch (notificationType) {
        case 'complaint':
          // الانتقال لصفحة الشكوى
          String? complaintId = data['complaint_id'];
          _navigateToPage('/complaint-details', arguments: complaintId);
          break;

        case 'message':
          // الانتقال لصفحة الرسائل
          String? chatId = data['chat_id'];
          _navigateToPage('/chat', arguments: chatId);
          break;

        case 'announcement':
          // الانتقال لصفحة الإعلانات
          _navigateToPage('/announcements');
          break;

        default:
          // الانتقال للصفحة الرئيسية
          _navigateToPage('/home');
      }
    }
  }

  static void _handleLocalNotificationTap(String payload) {
    log('Notification tapped with payload: $payload');
    // يمكنك تحليل الـ payload هنا إذا لزم الأمر
  }

  static void _navigateToPage(String route, {Object? arguments}) {
    if (navigatorKey?.currentState != null) {
      navigatorKey!.currentState!.pushNamed(route, arguments: arguments);
    } else {
      log('Navigator key is not set or currentState is null');
    }
  }

  static Future<void> _setupNotificationChannels() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      description: 'Notification channel for basic test',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _getFcmToken() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      log('FCM Token: $token');
      // يمكنك إرسال الـ token للـ backend هنا
    }

    _firebaseMessaging.onTokenRefresh.listen((String token) {
      log('FCM Token refreshed: $token');
      // يمكنك تحديث الـ token في الـ backend هنا
    });
  }

  static Future<String?> getFcmToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      log('FCM Token: ${token ?? "null"}');
      return token;
    } catch (e) {
      log('Error getting FCM token: $e');
      return null;
    }
  }
}
