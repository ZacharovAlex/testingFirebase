import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimestampItem extends StatelessWidget {
  final DateTime timestamp;
  final DateFormat dateFormatter;

  const TimestampItem(this.timestamp, {Key? key, required this.dateFormatter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24,left: 15),
      child: Text(_getStringDate(context)),
    );
  }

  String _getStringDate(BuildContext context) {
    DateTime now = DateTime.now();
    final diff = DateTime(timestamp.year, timestamp.month, timestamp.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (diff == 0) {
      return 'Today';
    }
    if (diff == -1) {
      return 'Yesterday';
    }
    return dateFormatter.format(timestamp);
  }
}
