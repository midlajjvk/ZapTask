import 'package:hive/hive.dart';

part 'remainder.g.dart';

@HiveType(typeId: 0)
class Remainder extends HiveObject {
  @HiveField(0)
  String task;

  @HiveField(1)
  DateTime dateTime;

  @HiveField(2)
  String priority;

  Remainder({
    required this.task,
    required this.dateTime,
    required this.priority,
  });
}
