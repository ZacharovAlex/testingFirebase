import 'package:intl/intl.dart';

String formatDate(int? time) {
  if (time != null) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
    final messageDate = DateTime.fromMillisecondsSinceEpoch(time);
    return dateFormat.format(messageDate).toString();
  } else {
    return 'No time';
  }
}
