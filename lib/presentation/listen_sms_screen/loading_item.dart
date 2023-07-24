import 'package:flutter/material.dart';

class LoadingItem extends StatelessWidget {
  const LoadingItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 56,
      width: double.infinity,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
