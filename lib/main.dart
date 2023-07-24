import 'dart:convert';
import 'dart:io';

import 'package:android_power_manager/android_power_manager.dart';
import 'package:crypto_app/data/isar_service.dart';
import 'package:crypto_app/di/injectable.dart';
import 'package:crypto_app/presentation/app/automatic_app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';
import 'foreground_service/foreground_task.dart';
import 'firebase_options.dart';

/// Initialize the [FlutterLocalNotificationsPlugin] package.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('BACKGROUND 666'); ///FCM Push recieve background
 // IsarService service = IsarService();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
 // service.updateMessage('PUSH TERMINATED3');
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
 // print('BACKGROUNG MESSAGE firebase!!');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('launch_background');

  const initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  if (!kIsWeb) {
    flutterLocalNotificationsPlugin.show(
        message.hashCode,
        notification?.title??'TITLE',
        notification?.body??'BODY!',
        NotificationDetails(
          android: AndroidNotificationDetails(

            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',

          ),
        ),
        payload: jsonEncode(message.data));
  }
}
void onDidReceiveNotificationResponse(NotificationResponse details) { //WHEN FOREGROUND but not! TERMINATED!
  print('onDidReceiveNotificationResponse Message details = ${details.payload}');

}

/// Initialize the [FlutterLocalNotificationsPlugin] package.

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await batteryOptimizationAndPhoneRequest();

  configureDependencies();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Permission.notification.isDenied.then((value) {
  //  print('notification perm $value');
    if (value) {
     // print('notification perm $value');
      Permission.notification.request();
    }
  });
  if (!kIsWeb) {
    await setupFlutterNotifications();
  }
  runApp(const AutomaticConfirmApp());
}

Future<void> batteryOptimizationAndPhoneRequest() async {
  final telephony = Telephony.instance;
  await telephony.requestPhoneAndSmsPermissions;
  print('requestPhoneAndSmsPermissions');
  await Permission.phone.request();
  print('Phone Permissions');
  final status = await Permission.ignoreBatteryOptimizations.status;
//  print('STATUS! $status');
  if (status.isGranted) {
    final ignoring = await AndroidPowerManager.isIgnoringBatteryOptimizations;
    if (!ignoring!) {
      AndroidPowerManager.requestIgnoreBatteryOptimizations();
    }
  } else {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.ignoreBatteryOptimizations,
    ].request();
    if (statuses[Permission.ignoreBatteryOptimizations]!.isGranted) {
      AndroidPowerManager.requestIgnoreBatteryOptimizations();
    } else {
      exit(0);
    }
  }
  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
}
