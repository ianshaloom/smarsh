import 'package:hive_flutter/hive_flutter.dart';

part 'final_count_model.g.dart';

@HiveType(typeId: 2)
class FinalCountModel extends HiveObject {
  @HiveField(0)
  String productId;

  @HiveField(1)
  String productName;

  @HiveField(2)
  int count;

  @HiveField(3)
  DateTime date;

  FinalCountModel({
    required this.productName,
    required this.count,
    required this.productId,
    required this.date,
  });
}
