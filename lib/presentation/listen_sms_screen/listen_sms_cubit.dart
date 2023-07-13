// import 'dart:async';
// import 'package:crypto_app/data/isar_service.dart';
// import 'package:crypto_app/presentation/base/base_cubit.dart';
// import 'package:crypto_app/presentation/listen_sms_screen/listen_sms_state.dart';
// import 'package:injectable/injectable.dart';
//
//
// @injectable
// class ListenSmsCubit extends BaseCubit<ListenSmsState> {
//   final IsarService service;
//
//   late StreamSubscription _subscriptionMessages;
//   late StreamSubscription _subscriptionBadMessages;
//
//   ListenSmsCubit(this.service) : super(ListenSmsState()) {
//     service.getAllMessages().then((value) => emit(state.copyWith(messages: value)));
//
//     _subscriptionMessages = service.listenToMessages().listen((event) {
//       print('Stream EVENT!! ${event}');
//
//       emit(state.copyWith(messages: event));
//     });
//     _subscriptionBadMessages = service.listenNotSendingMessages().listen((event) {
//       emit(state.copyWith(badMessages: event));
//     });
//   }
//
//  void changeShowMessages(MessagesToShow toShow)=>emit(state.copyWith(messagesToShow:toShow));
// // void stopListen()=>emit(state.copyWith(isEnabled:false));
// }
//
// enum MessagesToShow{allMessages,badMessages}
