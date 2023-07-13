import 'dart:convert';
import 'dart:isolate';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

@injectable
class MyTaskHandler extends TaskHandler {
  // final logger = FileOutput();
  SendPort? _sendPort;
  int _eventCount = 1;
  int percent = 100;

  // String _messageCount = '0';
  String? url;
  String? publicApi;
  String? privateApi;
  String? telegram;
  String? deviceName;
  String? imei;
  int _goodChecksCount = 1;

  // Called when the task is started.
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    // await logger.write(
    //     'Foreground Service Start url: $url/healthcheck, publicApi: $publicApi, privateApi $privateApi, telegram: $telegram');
    _sendPort = sendPort;
    // print('ON START!!');
    //timestamp = DateTime.now();
    // You can use the getData function to get the stored data.
    // final customData = await FlutterForegroundTask.getData<String>(key: 'custom_data');
    url = await FlutterForegroundTask.getData<String>(key: 'url');
    publicApi = await FlutterForegroundTask.getData<String>(key: 'publicApi');
    privateApi = await FlutterForegroundTask.getData<String>(key: 'privateApi');
    telegram = await FlutterForegroundTask.getData<String>(key: 'telegram');
    deviceName = await FlutterForegroundTask.getData<String>(key: 'deviceName');
    imei = await FlutterForegroundTask.getData<String>(key: 'imei');
    //  startTime = await FlutterForegroundTask.getData<String>(key: 'startTime');
    // print('customData: $customData');
    // _messageCount = customData.toString();
  }

  String statusConnectionDifference(int shouldBe, int exactly) {
    print('start percent');
    // print('Shoud $shouldBe  exactly $exactly)');
    percent = ((exactly / shouldBe) * 100).toInt();
    print('percent $percent');
    if (percent >= 75) {
      return 'You\'re online now! You\'re great.';
    } else if (percent >= 50) {
      return 'Unstable work! Please check your internet';
    } else if (percent >= 20) {
      return 'Unstable work! Please check your internet';
    } else {
      return 'Unstable work! Please check your data!';
    }
  }

  //   if (shouldBe == exactly) {
  //     return 'You\'re online now! You\'re great.';
  //   }
  //   if (shouldBe - exactly > 2) {
  //     return 'Unstable work! Please check your data!';
  //   }
  //   return 'You\'re online now! You\'re great.';
  // }

  // Called every [interval] milliseconds in [ForegroundTaskOptions].
  @override
  Future<void> onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    sendPort?.send(_eventCount);
    // final DateTime timeStamp = DateTime.fromMillisecondsSinceEpoch(int.parse(startTime??'0') * 1000);
    // final shouldCountBeenChecks = startTime.difference(DateTime.now()).inSeconds ~/ 25;
    // print('VSEGO = $_eventCount');
    // print('Good = $_goodChecksCount');
    final statusConnectionString = statusConnectionDifference(_eventCount, _goodChecksCount);

    pingServer(
      _eventCount.toString(),
      _goodChecksCount.toString(),
      statusConnectionString,
    );

    if (_eventCount == 60) {
      _eventCount = 1;
      _goodChecksCount = 0;
    } else {
      _eventCount++;
    }
  }

  // Called when the notification button on the Android platform is pressed.
  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {}

  // Called when the notification button on the Android platform is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    print('onNotificationButtonPressed >> $id');
  }

  // Called when the notification itself on the Android platform is pressed.
  //
  // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
  // this function to be called.
  @override
  void onNotificationPressed() {
    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp("/resume-route");
    _sendPort?.send('onNotificationPressed');
  }

  Future<void> pingServer(String count, String goodChecksCount, String status) async {
    // try{
    //   final response = await _repository.pingHealthCheck(publicApi??'no publicApi', privateApi??'no PrivateApi', telegram??'no Telegram');
    //   _goodChecksCount++;
    //   FlutterForegroundTask.updateService(
    //     notificationTitle: status,
    //     // notificationText: 'Health check ($count / $goodChecksCount)',
    //     notificationText: 'Health check $percent%',
    //
    //   );
    //   await logger.write(
    //       'Good PING $count healthCheck ${response.status} ${response.description} url: $url/healthcheck, publicApi: $publicApi, privateApi $privateApi, telegram: $telegram');
    //
    // }catch (e){
    //
    // }

    try {
      // print("Try to ping!");
      final response = await http.post(
        Uri.parse('$url/healthcheck'),
        //https://webhook.site/a2759151-b152-40bb-b7ad-1f42b59961f3
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "user_api_public": publicApi ?? 'none',
          "user_api_private": privateApi ?? "none",
          "user_telegram_id": telegram ?? 'none',
          "user_agent": deviceName ?? 'no device id',
          "device_id": imei ?? 'no imei',
          "app_version": '2.1',//TODO app version
        }),
      );

      if (response.statusCode == 200) {
        _goodChecksCount++;
        FlutterForegroundTask.updateService(
          notificationTitle: status,
          notificationText: 'Health check $percent%',
        );
        // await logger.write(
        //     'Good PING $count healthCheck ${response.statusCode} ${response.body} url: $url/healthcheck, publicApi: $publicApi, privateApi $privateApi, telegram: $telegram');

        return;
      }
      if (response.statusCode == 500) {
        FlutterForegroundTask.updateService(
          notificationTitle: '$percent% Connection Error Processing Crypto',
          notificationText: 'Error accessing the server ${response.statusCode}',
        );
        // await logger.write(
        //     'Error PING $count healthCheck ${response.statusCode} ${response.body} url: $url/healthcheck, publicApi: $publicApi, privateApi $privateApi, telegram: $telegram');
      } else {
        FlutterForegroundTask.updateService(
          notificationTitle: status,
          notificationText: 'Health check $percent%',
        );
        // print('PING BAD ${response.statusCode}${response.body}');
        // await logger.write(
        //     'Error PING $count healthCheck ${response.statusCode} ${response.body} url: $url/healthcheck, publicApi: $publicApi, privateApi $privateApi, telegram: $telegram');
      }
      // FlutterForegroundTask.updateService(
      //   notificationTitle: status,
      //   notificationText: 'Health check ($count / $goodChecksCount)',
      // );
      // await logger.write(
      //     'Good PING $count healthCheck ${response.statusCode} ${response.body} url: $url/healthcheck, publicApi: $publicApi, privateApi $privateApi, telegram: $telegram');
    } catch (e) {
      FlutterForegroundTask.updateService(
        notificationTitle: '$percent% Connection Error Processing Crypto',
        notificationText: 'Looks you have a problem with your internet',
      );
    }
  }
}
