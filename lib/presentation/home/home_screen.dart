import 'package:crypto_app/di/injectable.dart';
import 'package:crypto_app/presentation/home/bottom_bar.dart';
import 'package:crypto_app/presentation/home/home_cubit.dart';
import 'package:crypto_app/presentation/home/home_state.dart';
import 'package:crypto_app/presentation/listen_sms_screen/listen_sms_screen.dart';
import 'package:crypto_app/presentation/main_screen/main_screen.dart';
import 'package:crypto_app/presentation/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../settings/settings_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt.get<HomeCubit>(),
      child: _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (_, state) {
      final cubit = context.read<HomeCubit>();
     // final publicApi = cubit.state.publicApi;
    //  final privateApi = cubit.state.privateApi;
      final telegram = cubit.state.telegram;
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Text(telegram??'No Telegram'),),
        backgroundColor: Color(0xFFF6F6F6),
        bottomNavigationBar: BottomBar(
          onChanged: context.read<HomeCubit>().moveTo,
        ),
        // floatingActionButton: keyboardIsOpened
        //     ? null
        //     : const Padding(
        //         padding: EdgeInsets.only(top: AppConstants.bigVerticalPadding),
        //         child: ScanButton(),
        //       ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child: Container(
            color: Colors.transparent, //ColorName.background,
            child: //Tabs(),
                const Column(
              children: [

                // CustomAppbar(
                //   name: name,
                //   email: email,
                //   photo: photo,
                // ),
                Expanded(child: Tabs())
              ],
            ),
          ),
        ),
      );
    });
  }
}

class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  @override
  Widget build(BuildContext context) {
    final index = context.select((HomeCubit cubit) => cubit.state.currentTab.index);
    return IndexedStack(
      index: index,
      children: [MainScreen(),ListenSmsScreen(), BlocProvider(create: (_) => getIt.get<SettingsCubit>(), child: Settings())],//TODO if listen sms add ListenSmsScreen(),
    );
  }
}
