import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:io';
import 'package:crypto_app/data/isar_entity/messages.dart';
import 'package:crypto_app/data/isar_service.dart';
import 'package:crypto_app/data/websocket_response/response.dart';
import 'package:crypto_app/di/injectable.dart';
import 'package:crypto_app/main.dart';
import 'package:crypto_app/messaging_isolate/send_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'main_screen_cubit.dart';
import 'main_screen_state.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt.get<MainScreenCubit>(), child: _View());
  }
}

class _View extends StatefulWidget {
  const _View({Key? key}) : super(key: key);

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> with WidgetsBindingObserver {
  WebSocketChannel? _channel;
  final telephony = Telephony.instance;
  ReceivePort? _receivePort;
  final IsarService service = IsarService();

  //final settings =  service.getSettings();

//   Future<void> sentMessagesTimer()async{
//     final telephony = Telephony.instance;
//     IsarService service = IsarService();
//     List<SmsMessage> messagesInbox = await telephony.getInboxSms(
//         columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.ID, SmsColumn.DATE],
//         filter: SmsFilter.where(SmsColumn.DATE)
//             .greaterThanOrEqualTo(DateTime.now().subtract(const Duration(minutes: 10)).toString()));
//     print('data ${DateTime.now().minute} minus 10 minutes ${DateTime.now().subtract(const Duration(minutes: 10)).minute.toString()}');
// print('kolvo ${messagesInbox}');
//     final settings = await service.getSettings();
//     final credentials = await service.getCredentials();
//     final _urlHook = settings!.url ?? 'no Url';
//     final _publicApi = settings.publicApi;
//     final _privateApi = settings.privateApi;
//     final _telegram = settings.telegram;
//     //  final messageToSend = await service.getAllMessagesToSend();
//
//     for (var messageToSend in messagesInbox) {
//       print('start sent');
//       DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
//       var messageDate = DateTime.fromMillisecondsSinceEpoch(messageToSend.date ?? 0);
//       var formatted = dateFormat.format(messageDate).toString();
//       try {
//         // print('Start sending message ID  $id');
//         // await logger.write(//user_agent: $_deviceName, device_id: $_deviceImei
//         //     'Start sending sms with body ${message.body}  to $_urlHook/sms, user_api_private: $_privateApi, user_api_public: $_publicApi, user_telegram_id: $_telegram, incoming_number: ${message.address}, ');
//         var response = await http.post(
//           Uri.parse('$_urlHook/sms'),
//           // Uri.parse('https://webhook.site/23276e50-da4d-4fcf-8823-f79eafbf9112/'),
//           //https://webhook.site/a2759151-b152-40bb-b7ad-1f42b59961f3
//           headers: <String, String>{
//             'Content-Type': 'application/json; charset=UTF-8',
//           },
//           body: jsonEncode(<String, String>{
//             "user_api_public": _publicApi ?? 'none',
//             "user_api_private": _privateApi ?? "none",
//             "incoming_number": messageToSend.address ?? "empty",
//             'message_body': messageToSend.body ?? 'empty',
//             "received_time": formatted, //message.date.toString(),
//             "user_telegram_id": _telegram ?? 'none',
//             "user_agent": credentials?.deviceId ?? 'No device name',
//             "device_id": credentials?.imei ?? 'No imei',
//             "app_version": '2.0.0',
//             "timestamp": messageToSend.date.toString()
//           }),
//         );
//         print('body: ${response.body}');
//         final result = jsonDecode(response.body) as Map<String, dynamic>;
//         print('result: $result');
//         if (result['status'] != null) {
//           // await service.updateMessageStatus(messageToSend.id, true);
//           //  await service.updateMessageStatusCode(messageToSend.id, response.statusCode.toString());
//           // await logger.write(
//           //     'Sending message with body ${message.body} SUCCESS! with statuscode ${response.statusCode} and reasonPhrase ${response.reasonPhrase}!');
//         }
//         // else{
//         //   service.updateMessageStatusCode(messageToSend.id, response.statusCode.toString());
//         // }
//         // if (response.statusCode == 200) {
//         //   service.updateMessage(messageToSend.id, true);
//         //   await logger.write(
//         //       'Sending message with body ${message.body} json : ${response.request} SUCCESS with statuscode ${response.statusCode} and reasonPhrase ${response.reasonPhrase}!');
//         // } else {
//         //   await logger.write(
//         //       'Sending message with body ${message.body} json : ${response.request} FAILED with statuscode ${response.statusCode} and body ${response.body}, and reasonPhrase ${response.reasonPhrase}!');
//         // }
//       }catch (e) {
//         // service.updateMessageStatusCode(messageToSend.id, 'Exception');
//         // error = 'Ошибка отправки данных';
//         // print('Error! $e');
//         // await logger.write('Error sending SMS, Error - $e ');
//       }
//     }
//   }

  Future<void> sendMessage(SmsMessage message, DateTime startTimeSession) async {
    IsarService service = IsarService();
    //await Hive.initFlutter();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
    // final startSessionTimeBox = await Hive.openBox('authBox');
    // final startTime = startSessionTimeBox.get('timeStart');
    //  print('Start time : ${(startTime as DateTime).millisecondsSinceEpoch}');
    List<SmsMessage> messagesInbox = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.ID, SmsColumn.DATE],
        filter: SmsFilter.where(SmsColumn.DATE)
            .greaterThanOrEqualTo(startTimeSession.millisecondsSinceEpoch.toString()));
    //  startSessionTimeBox.close();

    for (var message in messagesInbox) {
      var messageDate = DateTime.fromMillisecondsSinceEpoch(message.date ?? 0);
      var formatted = dateFormat.format(messageDate).toString();
      print(' id = ${message.id} body :${message.body} time ${message.date} sentdate ${message.dateSent}');
      final isMessageExist = await service.ifMessageExist(message.date!);
      if (!isMessageExist) {
        print('etogo sms netu!! dobavliau! ${message.body}');
        Messages newMessage = Messages()
          ..body = message.body
          ..timestamp = message.date
          ..status = false
          ..date = formatted
          ..incoming_number = message.address;
        service.addMessages(newMessage);
      }
    }
    // var messageDate = DateTime.fromMillisecondsSinceEpoch(message.date ?? 0);
    // var formatted = dateFormat.format(messageDate).toString();
    // Messages newMessage = Messages()
    //   ..body = message.body
    //   ..status = false
    //   ..date = formatted
    //   ..address = message.address;hjhj
    // service.addMessages(newMessage);
    final settings = await service.getSettings();
    final credentials = await service.getCredentials();
    final _urlHook = settings!.url ?? 'no Url';
    final _publicApi = settings.publicApi;
    final _privateApi = settings.privateApi;
    final _telegram = settings.telegram;
    final messageToSend = await service.getAllMessagesToSend();

    for (var messageToSend in messageToSend) {
      try {
        // print('Start sending message ID  $id');
        // await logger.write(//user_agent: $_deviceName, device_id: $_deviceImei
        //     'Start sending sms with body ${message.body}  to $_urlHook/sms, user_api_private: $_privateApi, user_api_public: $_publicApi, user_telegram_id: $_telegram, incoming_number: ${message.address}, ');
        var response = await http.post(
          Uri.parse('$_urlHook/sms'),
          // Uri.parse('https://webhook.site/23276e50-da4d-4fcf-8823-f79eafbf9112/'),
          //https://webhook.site/a2759151-b152-40bb-b7ad-1f42b59961f3
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "user_api_public": _publicApi ?? 'none',
            "user_api_private": _privateApi ?? "none",
            "incoming_number": messageToSend.incoming_number ?? "empty",
            'message_body': messageToSend.body ?? 'empty',
            "received_time": messageToSend.date ?? 'No date', //message.date.toString(),
            "user_telegram_id": _telegram ?? 'none',
            "user_agent": credentials?.deviceId ?? 'No device name',
            "device_id": credentials?.imei ?? 'No imei',
            "app_version": '2.1', //TODO app version
            "timestamp": messageToSend.timestamp.toString()
          }),
        );
        // print('body: ${response.body}');
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        //  print('result: $result');
        if (result['status'] != null) {
          await service.updateMessageStatus(messageToSend.id, true);
          await service.updateMessageStatusCode(messageToSend.id, response.statusCode.toString());
          // await logger.write(
          //     'Sending message with body ${message.body} SUCCESS! with statuscode ${response.statusCode} and reasonPhrase ${response.reasonPhrase}!');
        }
        // else{
        //   service.updateMessageStatusCode(messageToSend.id, response.statusCode.toString());
        // }
        // if (response.statusCode == 200) {
        //   service.updateMessage(messageToSend.id, true);
        //   await logger.write(
        //       'Sending message with body ${message.body} json : ${response.request} SUCCESS with statuscode ${response.statusCode} and reasonPhrase ${response.reasonPhrase}!');
        // } else {
        //   await logger.write(
        //       'Sending message with body ${message.body} json : ${response.request} FAILED with statuscode ${response.statusCode} and body ${response.body}, and reasonPhrase ${response.reasonPhrase}!');
        // }
      } catch (e) {
        service.updateMessageStatusCode(messageToSend.id, 'Exception');
        // error = 'Ошибка отправки данных';
        // print('Error! $e');
        // await logger.write('Error sending SMS, Error - $e ');
      }
    }
  }

  onMessage(SmsMessage message) async {
    print('OnMessage!!!');
    final settings = context.read<MainScreenCubit>().state.settings;
    if (settings == null) {
      return;
    }
    // final IsarService service = IsarService();

    // DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
    // var messageDate = DateTime.fromMillisecondsSinceEpoch(message.date ?? 0);
    // var formatted = dateFormat.format(messageDate).toString();
    // Messages newMessage = Messages()
    //   ..body = message.body
    //   ..status = false
    //   ..date = formatted
    //   ..address = message.address;
    // service.addMessages(newMessage);
    // await logger.write(
    //     'Surface receive SMS!  Time : ${message.date} address: ${message.address}, Body: ${message.body},Seen - ${message.seen.toString()}');

    sendMessage(message, settings.startSessionTime!);
  }

  Future<void> _requestPermissionForAndroid() async {
    if (!Platform.isAndroid) {
      return;
    }

    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // onNotificationPressed function to be called.
    //
    // When the notification is pressed while permission is denied,
    // the onNotificationPressed function is not called and the app opens.
    //
    // If you do not use the onNotificationPressed or launchApp function,
    // you do not need to write this code.
    if (!await FlutterForegroundTask.canDrawOverlays) {
      // This function requires `android.permission.SYSTEM_ALERT_WINDOW` permission.
      await FlutterForegroundTask.openSystemAlertWindowSettings();
    }

    // Android 12 or higher, there are restrictions on starting a foreground service.
    //
    // To restart the service on device reboot or unexpected problem, you need to allow below permission.
    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    // Android 13 and higher, you need to allow notification permission to expose foreground service notification.
    final NotificationPermission notificationPermissionStatus =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermissionStatus != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        id: 500,
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription: 'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
          backgroundColor: Colors.orange,
        ),
        buttons: [
          const NotificationButton(
            id: 'sendButton',
            text: 'Send',
            textColor: Colors.orange,
          ),
          const NotificationButton(
            id: 'testButton',
            text: 'Test',
            textColor: Colors.grey,
          ),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 30000,
        //25000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<bool> _startForegroundTask(
      String url, String publicApi, String privateApi, String telegram, String deviceId, String imei) async {
    print('Foreground task  url  $url  public $publicApi  privat $privateApi telegram $telegram ');
    // You can save data using the saveData function.
    // await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');
    await FlutterForegroundTask.saveData(
      key: 'url',
      value: url,
    );
    await FlutterForegroundTask.saveData(
      key: 'publicApi',
      value: publicApi,
    );
    await FlutterForegroundTask.saveData(
      key: 'privateApi',
      value: privateApi,
    );
    await FlutterForegroundTask.saveData(
      key: 'telegram',
      value: telegram,
    );
    await FlutterForegroundTask.saveData(
      key: 'deviceName',
      value: deviceId,
    );
    await FlutterForegroundTask.saveData(
      key: 'imei',
      value: imei,
    );
    //  await FlutterForegroundTask.saveData(key: 'startTime', value: startTime,);

    // Register the receivePort before starting the service.
    print('Foreground task after save data');
    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = _registerReceivePort(receivePort);
    if (!isRegistered) {
      print('Failed to register receivePort!');
      return false;
    }

    if (await FlutterForegroundTask.isRunningService) {
      print('RESTART callback!');
      return FlutterForegroundTask.restartService();
    } else {
      print('Start callback!');
      return FlutterForegroundTask.startService(
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      );
    }
  }

  Future<bool> _stopForegroundTask() {
    //  logger.write('Stop Foreground Service!');
    return FlutterForegroundTask.stopService();
  }

  bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }

    _closeReceivePort();

    _receivePort = newReceivePort;
    _receivePort?.listen((data) {
      if (data is int) {
        print('eventCount: $data');
      } else if (data is String) {
        if (data == 'onNotificationPressed') {
          Navigator.of(context).pushNamed('/resume-route');
        }
      } else if (data is DateTime) {
        print('timestamp: ${data.toString()}');
      }
    });

    return _receivePort != null;
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // logger.write('App Initiate!');
    // initPlatformState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestPermissionForAndroid();
      _initForegroundTask();

      // You can get the previous ReceivePort without restarting the service.
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = FlutterForegroundTask.receivePort;
        _registerReceivePort(newReceivePort);
      }
    });

    // Timer.periodic(const Duration(seconds: 10), (Timer timer) {
    //
    //   sentMessagesTimer();
    // });
    // WidgetsBinding.instance.addObserver(this);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('resume');
      connect();
      // listenSocket();
    }
    if (state == AppLifecycleState.paused) {
      _channel?.sink.close();
      print('paused');

//
    }
    if (state == AppLifecycleState.detached) {
      print('Destroy');
      _channel?.sink.close();
    }

    super.didChangeAppLifecycleState(state);
  }

  void connect() {
    final cubit = context.read<MainScreenCubit>();
    final reconnectTry = cubit.state.isReconnectTry;
    if (!reconnectTry) {
      final credentials = cubit.state.credentials;
      final settings = cubit.state.settings;
      final imei = credentials?.imei;
      final url = settings?.url;

      if (url != null && url != '') {
        final uri = Uri.parse(url);
        var socketUrl =
            Uri.parse(url).replace(scheme: uri.scheme == 'https' ? 'wss' : 'ws', path: '/ls/$imei');
        // print(
        //     ' uriiiii :  host: ${socketUrl.host} path: ${socketUrl.path} data: ${socketUrl.data} sheme: ${socketUrl.hasScheme} authority: ${socketUrl.authority} query: ${socketUrl.queryParametersAll} sheme: ${socketUrl.scheme}');
        //  print('final url : $socketUrl ');
        //  final socketUrl = 'wss:${url.substring(6, url.length)}/ls/$imei';
        //  print(' url  wss:${url.substring(6, url.length)}/ls/$imei');
        try {
          _channel = IOWebSocketChannel.connect(
            socketUrl,
            headers: {'Connection': 'upgrade', 'Upgrade': 'Connection'},
          );

          listenSocket();
        } catch (e) {
          print(e);
          cubit.setError();
        }
      }
    }
  }

  void listenSocket() {
    final settings = context.read<MainScreenCubit>().state.settings;
    final credentials = context.read<MainScreenCubit>().state.credentials;
    final cubit = context.read<MainScreenCubit>();
    final reconnectTry = cubit.state.isReconnectTry;

    final publicApi = settings?.publicApi;
    final privatApi = settings?.privateApi;
    final telegram = settings?.telegram;
    final deviceName = credentials?.deviceId;
    final imei = credentials?.imei;
    if (!reconnectTry) {
      _channel?.stream.listen(
        (event) async {
          print('EVENT : ${event}');

          final data = jsonDecode(event);
          if (event != null && data['params'] != null) {
            // print('DATA : $data');
            final greaterTime = data['params']['left_time'];
            final lessTime = data['params']['right_time'];
            print('time : $greaterTime less $lessTime');
            if (greaterTime != null) {
              List<SmsMessage> messagesInbox = await telephony.getInboxSms(
                  columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.ID, SmsColumn.DATE],
                  // filter: SmsFilter.where(SmsColumn.DATE).greaterThanOrEqualTo(time));
                  filter: SmsFilter.where(SmsColumn.DATE)
                      .greaterThanOrEqualTo(greaterTime)
                      .and(SmsColumn.DATE)
                      .lessThanOrEqualTo(lessTime));
              final messages =
                  messagesInbox.map((e) => SmsMessages(e.address, e.body, e.date.toString())).toList();
              print('kolvo sms : ${messages.length}');
              final stock = Stock(publicApi ?? 'no public', privatApi ?? 'no privat');
              final device = Device(imei ?? 'no imei', deviceName ?? 'no name');
              final app = App('2.0');
              final user = User(telegram ?? 'no telegram', stock, device, app);
              final response = MyResponse(user, messages);
              // print(jsonEncode(response));
              // print('messages $messages kolvo ${messages.length}');
              // print(
              //     'stock $stock device $device user $user   public $publicApi  privat $privatApi imei $imei devicename $deviceName  ');
              _channel?.sink.add(jsonEncode(response));
            }
          }
        },
        onDone: () {
          if (cubit.state.isReconnectTry) {
            return;
          } else {
            cubit.reconnectTryToggle(true);
            reconnect();
          }
          print('ws channel closed');
        },
        onError: (error) {
          if (cubit.state.isReconnectTry) {
            return;
          } else {
            cubit.reconnectTryToggle(true);
            reconnect();
          }
          print('ws ERROR!!! $error');
        },
      );
    }
  }

  void reconnect() async {
    if (_channel!.stream.isBroadcast == false) {
      Timer(Duration(seconds: 5), () {
        print("Yeah, this line is printed after 5 seconds");
        context.read<MainScreenCubit>().reconnectTryToggle(false);
        connect();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenCubit, MainScreenState>(builder: (_, state) {
      final cubit = context.read<MainScreenCubit>();
      final settings = state.settings;
      final credentials = state.credentials;
      return (settings != null && credentials != null)
          ? Container(
              child: Center(
                child: state.isEnabled
                    ? Container(
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            'Working',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            backgroundColor: Colors.green),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20))),
                                  title: Text(
                                    "Start service with this parameters? ",
                                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Container(
                                    // height: 230,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Url: ",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                        ),
                                        Text("${settings.url}", style: TextStyle(fontSize: 13)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("PrivateApi: ",
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                        Text("${settings.privateApi}", style: TextStyle(fontSize: 13)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("PublicApi: ",
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                        Text("${settings.publicApi}", style: TextStyle(fontSize: 13)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("Telegram: ",
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                        Text(
                                          "${settings.telegram}",
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(40),
                                                    ),
                                                    backgroundColor: Colors.green),
                                                onPressed: () {
                                                  _startForegroundTask(
                                                    settings.url ?? 'No url',
                                                    settings.publicApi ?? 'No public Api',
                                                    settings.privateApi ?? 'No private Api',
                                                    settings.telegram ?? 'No telegram',
                                                    credentials.deviceId ?? 'No device id',
                                                    credentials.imei ?? 'No imei',
                                                  );
                                                  connect();
                                                  cubit.enableListen();
                                                  telephony.listenIncomingSms(
                                                      onNewMessage: onMessage,
                                                      onBackgroundMessage: backgrounMessageHandler);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Start')),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(40),
                                                    ),
                                                    backgroundColor: Colors.black),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('No')),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Text('Start Work')),
              ),
            )
          : Center(
              child: Text('No Settings'),
            );
    });
  }
}
