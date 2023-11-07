import 'package:hive_flutter/hive_flutter.dart';

part 'filter_model.g.dart';

@HiveType(typeId: 0)
class FilterModel extends HiveObject {
  @HiveField(0)
  bool isMissing;

  @HiveField(1)
  bool isExcess;

  @HiveField(2)
  bool isIntact;

   @HiveField(3)
  bool isAll;

  FilterModel({
    required this.isAll,
    required this.isExcess,
    required this.isIntact,
    required this.isMissing,
  });
}
