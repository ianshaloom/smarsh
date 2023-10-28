import 'package:hive_flutter/hive_flutter.dart';

part 'hive_object_model.g.dart';

@HiveType(typeId: 3)
class HiveObjectModel extends HiveObject {
  @HiveField(0)
  String? description;
  bool? trueOrFalse;
  int? number;
  double? doubleNumber;
  DateTime? date;
  List<dynamic>? dynamicList;
  Map<dynamic, dynamic>? stringMap;

  HiveObjectModel({
    this.description,
    this.trueOrFalse,
    this.number,
    this.doubleNumber,
    this.date,
    this.dynamicList,
    this.stringMap,
  });
}
