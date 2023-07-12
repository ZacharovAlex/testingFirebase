import 'package:flutter/material.dart';

class BottomBarItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  final _selectedTextStyle = const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500);

  const BottomBarItem(
      {Key? key, required this.icon, required this.title, required this.selected, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(opacity: selected ? 1 : 0.4, child: icon),
          const SizedBox(
            height: 11,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: selected
                ? _selectedTextStyle
                : _selectedTextStyle.copyWith(color: Colors.white.withOpacity(0.4)),
          )
        ],
      ),
    );
  }
}
