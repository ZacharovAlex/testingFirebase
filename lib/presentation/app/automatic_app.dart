import 'dart:io';

import 'package:android_power_manager/android_power_manager.dart';
import 'package:crypto_app/data/isar_service.dart';
import 'package:crypto_app/presentation/app/app_theme.dart';
import 'package:crypto_app/presentation/app/main_cubit.dart';
import 'package:crypto_app/presentation/app/main_state.dart';
import 'package:crypto_app/presentation/home/home_screen.dart';
import 'package:crypto_app/presentation/onboarding/registration/registration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:telephony/telephony.dart';
import '../../di/injectable.dart';
import '../../generated/l10n.dart';
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
 // final telephony = Telephony.instance;
  IsarService service = IsarService();

  @override
  void initState() {
    super.initState();
   // batteryOptimizationAndPhoneRequest();
  }


  // void batteryOptimizationAndPhoneRequest() async {
  //   await telephony.requestPhoneAndSmsPermissions;
  //   print('requestPhoneAndSmsPermissions');
  //   await Permission.phone.request();
  //   print('Phone Permissions');
  //   final status = await Permission.ignoreBatteryOptimizations.status;
  //   print('STATUS! $status');
  //   if (status.isGranted) {
  //     final ignoring = await AndroidPowerManager.isIgnoringBatteryOptimizations;
  //     if (!ignoring!) {
  //       AndroidPowerManager.requestIgnoreBatteryOptimizations();
  //     }
  //   } else {
  //     Map<Permission, PermissionStatus> statuses = await [
  //       Permission.ignoreBatteryOptimizations,
  //     ].request();
  //     if (statuses[Permission.ignoreBatteryOptimizations]!.isGranted) {
  //       AndroidPowerManager.requestIgnoreBatteryOptimizations();
  //     } else {
  //       exit(0);
  //     }
  //   }
  // }

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
                      //state.isLogged ? OnBoarding() :
                      state.isSettingExist!=null? HomeScreen() : OnBoarding()

                  // PinCodeScreen(
                  //   isFirstOpen: true,
                  // )
                  //Registration() //VerifyEmail()// Registration(), //HomeScreen() : const Registration(),// HomeScreenSliver()// TEST()////  PinCodeScreen() //HomeScreenSliver3() //TEST()// HomeScreenSliver2()//HomeScreenSliver() // SliverAppBarRounded()//HomeScreenSliver()//
                  );
            });
  }
}
