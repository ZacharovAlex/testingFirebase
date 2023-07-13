import 'package:crypto_app/data/isar_entity/settings.dart';
import 'package:crypto_app/di/injectable.dart';
import 'package:crypto_app/presentation/common/custom_input_field.dart';
import 'package:crypto_app/presentation/home/home_screen.dart';
import 'package:crypto_app/presentation/onboarding/registration/registration_cubit.dart';
import 'package:crypto_app/presentation/onboarding/registration/registration_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:telephony/telephony.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt.get<RegistrationCubit>(), child: _View());
  }
}

class _View extends StatefulWidget {
  const _View({super.key});

  @override
  State<_View> createState() => __View();
}

class __View extends State<_View> {
  final telephony = Telephony.instance;
  TextEditingController _conttrtollerUrl = TextEditingController();
  TextEditingController _conttrtollerPublicApi = TextEditingController();
  TextEditingController _conttrtollerPrivateApi = TextEditingController();
  TextEditingController _conttrtollerUserTelegram = TextEditingController();

  @override
  void dispose() {
    _conttrtollerPrivateApi.dispose();
    _conttrtollerUrl.dispose();
    _conttrtollerPublicApi.dispose();
    _conttrtollerUserTelegram.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(builder: (_, state) {
      final cubit = context.read<RegistrationCubit>();
      return BlocListener<RegistrationCubit, RegistrationState>(
        listenWhen: (prev, curr) {
          return prev.isRegister != curr.isRegister;
        },
        listener: (prev, curr) {
          if (curr.isRegister) {
            Navigator.push(context, CupertinoPageRoute(builder: (_) => const HomeScreen()));
          }
        },
        child: Scaffold(
          body: Container(
            // decoration: BoxDecoration(gradient: LinearGradient(
            //   // begin: Alignment.topLeft,
            //   // end: Alignment.bottomRight,
            //   colors: <Color>[
            //     Colors.black54,
            //     Colors.white12,
            //   ],
            // ),),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Enter your data :',
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('URL :'),
                              ],
                            ),
                            CustomTextField(formatter: [
                              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z:/.-]")),
                            ], controller: _conttrtollerUrl, title: 'Enter url' //url,
                                ),
                            // Text('URL'),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Public Api :'),
                              ],
                            ),
                            CustomTextField(formatter: [
                              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                            ], controller: _conttrtollerPublicApi, title: 'Enter public Api' //publicApi,
                                ),
                            // Text('${publicApi??'No public Api'}'),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Private Api :'),
                              ],
                            ),
                            CustomTextField(formatter: [
                              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                            ], controller: _conttrtollerPrivateApi, title: 'Enter private Api' //privateApi,
                                ),
                            // Text('PrivateApi'),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Telegram :'),
                              ],
                            ),
                            CustomTextField(
                                formatter: [
                             // FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                            ],
                                controller: _conttrtollerUserTelegram, title: 'Enter telegram' //telegram,
                                ),
                            const SizedBox(
                              height: 15,
                            ),
                            // Text('Telegram'),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                                onPressed: () {
                                  // print('URL = ${_conttrtollerUrl.text}');
                                  final newSettings = UserSettings()
                                    ..url = _conttrtollerUrl.text
                                    ..privateApi = _conttrtollerPrivateApi.text
                                    ..publicApi = _conttrtollerPublicApi.text
                                    ..telegram = _conttrtollerUserTelegram.text;
                                  cubit.setSettings(newSettings);
                                  // cubit.setUserInfo(
                                  //     publicApi: _conttrtollerPublicApi.text,
                                  //     privateApi: _conttrtollerPrivateApi.text,
                                  //     telegram: _conttrtollerUserTelegram.text);
                                },
                                child: const Text('Save parameters')),
                            const SizedBox(
                              height: 15,
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 40),
                            //   child: ElevatedButton(
                            //       style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                            //       // style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                            //       onPressed: () {
                            //         toDefaultSettings();
                            //       },
                            //       child: const Text('To default settings')),
                            // ),
                            // Text('')
                            const SizedBox(
                              height: 20,
                            ),
                            // Text(widget.logText),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
