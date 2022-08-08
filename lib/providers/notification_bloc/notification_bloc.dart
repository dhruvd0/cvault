import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvault/providers/notification_bloc/notification_state.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial()) {
    FirebaseAuth.instance.authStateChanges().asBroadcastStream().listen((user) {
      if (user != null) {
        _registerNotificationListener().then((value) => _registerFCMToken());
      }
    });
  }
  // ignore: long-method
  static NotificationDetails _initLocalNotification() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    // ignore: unused_local_variable
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: null,
    );

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      '0',
      'notifications',
      importance: Importance.high,
      enableLights: true,
      icon: "ic_launcher",
      playSound: true,
    );

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails(
      threadIdentifier: 'thread_id',
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    return notificationDetails;
  }

  static void showLocalNotification(String title, String body) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final notifDetails = _initLocalNotification();
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      notifDetails,
    );
  }

  Future<void> _registerNotificationListener() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message?.notification != null) {
        showLocalNotification(
          message!.notification!.title!,
          message.notification!.body!,
        );
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showLocalNotification(
          message.notification!.title!,
          message.notification!.body!,
        );
      }
    });
  }

  static const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  static const fcmKey =
      "AAAAV_QyJec:APA91bF56qJiLNc53wRxRSC6DkgE65uzPL82sl8R1NI8nwBV7jfJ1goeH8fsGELGhb8o0aY1DnslIcgOWzzrvga3UecjZrZUFlaUv4LNea7rFkWVs7426HSfFNzxvm76mgEiz_nW7V7V";

  static Future<void> _sendNotificationToFCMToken(
    String title,
    String body,
    String fcmToken,
  ) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$fcmKey',
    };
    var request = http.Request('POST', Uri.parse(fcmUrl));
    request.body =
        '''{"to":"$fcmToken","priority":"high","notification":{"title":"$title","body":"$body","sound": "default"}}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('notification sent');
    } else {
      log('error');
    }
  }

  static void sendNotificationToUser(
    String title,
    String body,
    String uid,
  ) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('fcm').doc(uid).get();

      final data = snapshot.data();
      if (data == null) {
        print('user not registered');

        FirebaseCrashlytics.instance.recordError(
          Exception('Tried to send a notification to an invalid fcm token'),
          StackTrace.current,
        );
        return;
      }

      final String token = data['token'];
      await _sendNotificationToFCMToken(title, body, token);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool> _hasValidFCMToken() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('fcm')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final data = snapshot.data();
    if (data == null) {
      return false;
    }
    try {
      final String token = data['token'];
      Timestamp timeGenerated = data['generated'];
      if (token.length > 3 &&
          DateTime.now().difference(timeGenerated.toDate()).inDays < 30) {
        emit(state.copyWith(currentToken: token));

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void _registerFCMToken() async {
    final newToken = await FirebaseMessaging.instance.getToken();
    emit(state.copyWith(currentToken: newToken));
    await FirebaseFirestore.instance
        .collection('fcm')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'token': newToken,
      'generated': Timestamp.fromDate(DateTime.now()),
    });
  }
}
