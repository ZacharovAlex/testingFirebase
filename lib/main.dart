
import 'dart:io';

import 'package:android_power_manager/android_power_manager.dart';
import 'package:crypto_app/di/injectable.dart';
import 'package:crypto_app/presentation/app/automatic_app.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';
import 'foreground_service/foreground_task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// late final Box authBox;
// const _authBox = 'authBox';

@pragma('vm:entry-point')
void startCallback() {
  print('FOREGROUND TASK START!!');
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await batteryOptimizationAndPhoneRequest();
 // await configureHive();
   configureDependencies();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 // batteryOptimizationRequest();
  runApp(const AutomaticConfirmApp());
}

// Future<void> configureHive() async {
//   await Hive.initFlutter();
//   authBox = await Hive.openBox(_authBox);
// }

Future<void> batteryOptimizationAndPhoneRequest() async {
  final telephony = Telephony.instance;
  await telephony.requestPhoneAndSmsPermissions;
  print('requestPhoneAndSmsPermissions');
  await Permission.phone.request();
  print('Phone Permissions');
  final status = await Permission.ignoreBatteryOptimizations.status;
  print('STATUS! $status');
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
}
