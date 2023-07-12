import 'package:crypto_app/presentation/home/bottom_bar_item.dart';
import 'package:crypto_app/presentation/home/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomBar extends StatelessWidget {
  final ValueChanged<BottomTab> onChanged;

  const BottomBar({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final index = context.select((HomeCubit cubit) => cubit.state.currentTab.index);
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
      height: 70 + MediaQuery.of(context).viewPadding.bottom,
      color: Colors.black,
      child: Row(
        children: [
          Expanded(
            child: BottomBarItem(
              icon: const Icon(Icons.home,color: Colors.white,),
              title: 'Work',
              selected: index == 0,
              onTap: () {
                onChanged(BottomTab.home);
              },
            ),
          ),//TODO UNCOMMENT to show sms
          // Expanded(
          //   child: BottomBarItem(
          //     icon: const Icon(Icons.mail,color: Colors.white,),
          //     title: 'SMS',
          //     selected: index == 1,
          //     onTap: () {
          //       onChanged(BottomTab.listenSms);
          //     },
          //   ),
          // ),
          Expanded(
            child: BottomBarItem(
              icon: const Icon(Icons.settings,color: Colors.white,),
              title: 'Settings',
              selected: index == 1, //TODO change! if listen sms
              onTap: () {
                onChanged(BottomTab.settings);
              },
            ),
          ),
        ],
      ),
    );
  }
}
