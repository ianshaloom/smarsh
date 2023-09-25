import 'package:hive_flutter/hive_flutter.dart';

part 'item_count_model.g.dart';

@HiveType(typeId: 1)
class ItemCountModel extends HiveObject {
  @HiveField(0)
  String productId;

  @HiveField(1)
  String productName;

  @HiveField(2)
  List<int>? count;

  ItemCountModel({
    this.count,
    required this.productName,
    required this.productId,
  });
}
