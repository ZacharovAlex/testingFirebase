import 'package:crypto_app/data/isar_entity/settings.dart';
import 'package:crypto_app/di/injectable.dart';
import 'package:crypto_app/presentation/common/custom_input_field.dart';
import 'package:crypto_app/presentation/home/home_screen.dart';
import 'package:crypto_app/presentation/onboarding/registration/registration_cubit.dart';
import 'package:crypto_app/presentation/onboarding/registration/registration_state.dart';
import 'package:crypto_app/presentation/onboarding/registration/scanner_screen.dart';
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

  @override
  void dispose() {

    super.dispose();
  }

  Future<void> _launchScanner() async {
    final cubit = context.read<RegistrationCubit>();
    final UserSettings? result =
    await Navigator.push(context, CupertinoPageRoute(builder: (_) => const ScannerScreen()));
    if (result != null && mounted) {
       print('RESULT OF SCANNING!!   - ${result.toString()}');
       await cubit.setSettings(result);
    }
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
          body: Center(child: ElevatedButton(
            onPressed: ()=>_launchScanner(),
            child: Text('SCAN'),),)
        ),
      );
    });
  }
}
