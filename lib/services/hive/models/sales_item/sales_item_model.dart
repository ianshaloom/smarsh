import 'package:hive_flutter/hive_flutter.dart';

part 'sales_item_model.g.dart';

@HiveType(typeId: 5)
class SalesModel extends HiveObject {
  @HiveField(0)
  final String documentId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  double? totalSales;

  @HiveField(3)
  int? totalQuantity;

  SalesModel({
    required this.documentId,
    required this.productName,
    this.totalSales,
    this.totalQuantity,
  });
}
