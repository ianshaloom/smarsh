import 'package:hive_flutter/hive_flutter.dart';

part 'processed_stock.g.dart';

@HiveType(typeId: 3)
class ProcessedData extends HiveObject {
  @HiveField(0)
  final String documentId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final int stockCount;

  // required constructor
  ProcessedData({
    required this.documentId,
    required this.productName,
    required this.stockCount,
  });
}
