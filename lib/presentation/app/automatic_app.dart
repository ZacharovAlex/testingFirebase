
import 'package:crypto_app/data/isar_service.dart';
import 'package:crypto_app/presentation/app/app_theme.dart';
import 'package:crypto_app/presentation/app/main_cubit.dart';
import 'package:crypto_app/presentation/app/main_state.dart';
import 'package:crypto_app/presentation/home/home_screen.dart';
import 'package:crypto_app/presentation/onboarding/registration/registration.dart';
import 'package:crypto_app/presentation/onboarding/registration/registration_by_qr.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../di/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AutomaticConfirmApp extends StatelessWidget {
  const AutomaticConfirmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt.get<MainCubit>(), child: _View());
  }
}

class _View extends StatefulWidget {
  const _View({Key? key}) : super(key: key);

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  // Notifications? _notifications;
  // StreamSubscription<NotificationEvent>? _subscription;
  IsarService service = IsarService();

  // Future<void> initListenAnotherPush() async {
  //
  //   startListening();
  // }
//   void onData(NotificationEvent? event) {
//     // setState(() {
//     //   _log.add(event);
//     // });
// if (event!=null) {
//       print('LISTEN ANOTHER PUSH : ${event.toString()}');
//       print('Title : ${event.title.toString()}');
//       print('message : ${event.message.toString()}');
//       print('packedge : ${event.packageName.toString()}');
//       print('time : ${event.timeStamp.toString()}');
//     }
//     // print('packedge : ${event?.packageName.toString()}');
//   }
  // void startListening() {
  //   _notifications = Notifications();
  //   try {
  //     print('try listen');
  //     _subscription = _notifications!.notificationStream!.listen(onData);
  //     print('listen on!!!');
  //     // setState(() => started = true);
  //   } catch (exception) {
  //     print(exception);
  //   }
  // }


  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message){ ///Listten normal push
      print('When surfeis');
    });
    FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails().then((value){ ///Listten normal push
      if(value != null){
        print('when terminated');
        print('Message details = ${value.notificationResponse?.payload}');
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (_, state)
      {
        context.read<MainCubit>().isSettingsExist;
            return  MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: appTheme,
                  localizationsDelegates: const [
                    // S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  scrollBehavior: const CupertinoScrollBehavior(),
                  home:

                      state.isSettingExist!=null? HomeScreen() : OnBoarding()

                  );
            });
  }
}
