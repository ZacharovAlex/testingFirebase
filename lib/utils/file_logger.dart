// import 'dart:io';
//
// import 'package:collection/collection.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
//
// Future<File> _createLogFile() async {
//   final docDir = await getExternalStorageDirectories(type: StorageDirectory.documents);
//   final appDocPath = docDir?.firstOrNull?.path;
//   // print('file $appDocPath');
//   File file = File('$appDocPath/logs.txt');
//   return await file.create();
// }
//
// final _dateFormatter = DateFormat('d MMMM y, HH:mm');
//
// class FileOutput {
//   FileOutput();
//
//   File? _file;
//
//   Future<void> write(String line) async {
//     try {
//       _file ??= await _createLogFile();
//       await _file?.writeAsString("${_dateFormatter.format(DateTime.now()).toUpperCase()} ${line.toString()}\n",
//           mode: FileMode.writeOnlyAppend);
//     } catch (e) {
//       print(e);
//     }
//   }
//   Future<void> deleteFileLogs() async {
//     try {
//       final  directory = await getExternalStorageDirectories(type: StorageDirectory.documents);
//       final appDocPath = directory?.firstOrNull?.path;
//       if (await File('$appDocPath/logs.txt').exists()){
//         File('$appDocPath/logs.txt').delete();
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
// }
