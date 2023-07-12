import 'package:isar/isar.dart';

part 'logger.g.dart';

@Collection()
class Logger {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  @Index(type: IndexType.value)
  String? message;
}
