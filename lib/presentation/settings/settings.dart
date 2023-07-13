import 'package:crypto_app/data/isar_entity/settings.dart';
import 'package:crypto_app/presentation/common/custom_input_field.dart';
import 'package:crypto_app/presentation/settings/settings_cubit.dart';
import 'package:crypto_app/presentation/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:telephony/telephony.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
    return BlocBuilder<SettingsCubit, SettingsState>(builder: (_, state) {
      final cubit = context.read<SettingsCubit>();
      // final settings = state.settings;
      final telegram = state.telegram;
      final privateApi = state.privateApi;
      final publicApi = state.publicApi;
      final url = state.url;
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Enter data :'),
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
              ], controller: _conttrtollerUrl, title: url ?? 'no url Settings' //url,
                  ),
              Text('$url'),
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
              ], controller: _conttrtollerPublicApi,// title: publicApi ?? 'No publicApi Settings' //publicApi,
                  ),
              Text('$publicApi'),
             // Text('${publicApi ?? 'No public Api'}'),
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
              ], controller: _conttrtollerPrivateApi,// title: privateApi ?? 'no privat Settings' //privateApi,
                  ),
              Text('$privateApi'),
            //  Text('PrivateApi'),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Telegram :'),
                ],
              ),
              CustomTextField(formatter: [
              //  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
              ], controller: _conttrtollerUserTelegram, title: telegram ?? 'no telegram Settings' //telegram,
                  ),
              Text('$telegram'),
              const SizedBox(
                height: 15,
              ),
            //  Text('Telegram'),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    print('URL = ${_conttrtollerUrl.text}');
                    final newSettings = UserSettings()
                      ..url = _conttrtollerUrl.text
                      ..privateApi = _conttrtollerPrivateApi.text
                      ..publicApi = _conttrtollerPublicApi.text
                      ..telegram = _conttrtollerUserTelegram.text;
                    cubit.setUserInfo(newSettings);
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
      );
    });
  }
}
