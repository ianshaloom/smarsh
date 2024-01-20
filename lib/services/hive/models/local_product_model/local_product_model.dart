import 'package:hive_flutter/hive_flutter.dart';

part 'local_product_model.g.dart';

@HiveType(typeId: 2)
class LocalProduct extends HiveObject {
  @HiveField(0)
  final String documentId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final double retail;

  @HiveField(3)
  final double wholesale;

  @HiveField(4)
  final int lastCount;

  @HiveField(5)
  final int todaysCount;

  // required constructor
  LocalProduct({
    required this.documentId,
    required this.productName,
    required this.retail,
    required this.wholesale,
    required this.lastCount,
    required this.todaysCount,
  });
}
