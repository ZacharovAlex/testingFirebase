import 'dart:convert';
import 'package:crypto_app/data/isar_entity/messages.dart';
import 'package:crypto_app/data/isar_service.dart';
import 'package:crypto_app/utils/file_logger.dart';
import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
backgrounMessageHandler(SmsMessage message) async {
  IsarService service = IsarService();
  final settings = await service.getSettings();
  final startSessionTime = settings!.startSessionTime!;
  final telephony = Telephony.instance;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
  // final startSessionTimeBox = await Hive.openBox('authBox');
  // final startTime = startSessionTimeBox.get('timeStart');
  // print('Start time : ${(startTime as DateTime).millisecondsSinceEpoch}');
  Future<void> sendMessage(SmsMessage message) async {
    List<SmsMessage> messagesInbox = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.ID, SmsColumn.DATE],
        filter: SmsFilter.where(SmsColumn.DATE)
            .greaterThanOrEqualTo(startSessionTime.millisecondsSinceEpoch.toString())

        // sortOrder: [OrderBy(SmsColumn.ADDRESS, sort: Sort.ASC),
        //   OrderBy(SmsColumn.BODY)]
        );
    // startSessionTimeBox.close();
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
          ..incoming_number = message.address
          ..statusCode = 'in progress';
        service.addMessages(newMessage);
      }
    }

    // var messageDate = DateTime.fromMillisecondsSinceEpoch(message.date ?? 0);
    // var formatted = dateFormat.format(messageDate).toString();
    // Messages newMessage = Messages()
    //   ..body = message.body
    //   ..status = false
    //   ..date = formatted
    //   ..address = message.address;
    // service.addMessages(newMessage);

    final settings = await service.getSettings();
    final credentials = await service.getCredentials();
    final _urlHook = settings!.url ?? 'no Url';
    final _publicApi = settings.publicApi;
    final _privateApi = settings.privateApi;
    final _telegram = settings.telegram;
    final messageToSend = await service.getAllMessagesToSend();

    for (var sendingMessage in messageToSend) {
      try {
        // print('Start sending message');
        // await logger.write(
        //     'Start sending SMS with body ${message.body} to $_urlHook, publicApi $_publicApi, privateApi $_privateApi, telegram $_telegram');
        final response = await http.post(
          Uri.parse('${_urlHook ?? ''}/sms'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "user_api_public": _publicApi ?? 'no public',
            "user_api_private": _privateApi ?? "no private",
            "incoming_number": sendingMessage.incoming_number ?? "empty address",
            'message_body': sendingMessage.body ?? 'empty sms',
            "received_time": sendingMessage.date ?? 'no time', //message.date.toString(),
            "user_telegram_id": _telegram ?? 'no telegram',
            "user_agent": credentials?.deviceId ?? 'no device id',
            "device_id": credentials?.imei ?? 'no imei',
            "app_version": '2.0.0',
            "timestamp": sendingMessage.timestamp.toString()
          }),
        );
        print('body: ${response.body}');
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        print('result: $result');
        if (result['status'] != null) {
          print('status ne nuuuullll!!!');
          await service.updateMessageStatus(sendingMessage.id, true);
          await service.updateMessageStatusCode(sendingMessage.id, response.statusCode.toString());

          // await logger.write(
          //     'Sending message with body ${message.body} SUCCESS! with statuscode ${response.statusCode} and reasonPhrase ${response.reasonPhrase}!');
        }
        // else{
        //   service.updateMessageStatusCode(messageToSend.id, response.statusCode.toString());
        // }
        // if (response.statusCode == 200) {
        //   service.updateMessage(messageToSend.id, true);
        //   await logger.write(
        //       'Sending message with body ${message.body} SUCCESS! with statuscode ${response.statusCode} and reasonPhrase ${response.reasonPhrase}!');
        // } else {
        //   await logger.write(
        //       'Sending message with body ${message.body} FAILED with statuscode ${response.statusCode} and body ${response.body} and reasonPhrase ${response.reasonPhrase}!');
        // }
      } catch (e) {
        service.updateMessageStatusCode(sendingMessage.id, 'Exception');
        // error = 'Ошибка отправки данных';
        print('Exception Error! $e');
        //  await logger.write('Error sendind SMS with body ${message.body} $e');
      }
    }
  }

  sendMessage(message);
}
