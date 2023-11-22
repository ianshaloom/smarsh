import 'package:hive_flutter/hive_flutter.dart';

part 'local_product_model.g.dart';


@HiveType(typeId: 2)
class LocalProduct extends HiveObject {
  @HiveField(0)
  final String documentId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final double buyingPrice;

  @HiveField(3)
  final double sellingPrice;

  @HiveField(4)
  final int stockCount;

  // required constructor
  LocalProduct({
    required this.documentId,
    required this.productName,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.stockCount,
  });
}
