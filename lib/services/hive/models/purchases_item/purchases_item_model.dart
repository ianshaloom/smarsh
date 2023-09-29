import 'package:hive_flutter/hive_flutter.dart';

part 'purchases_item_model.g.dart';

@HiveType(typeId: 6)
class PurchasesModel extends HiveObject{
  
  @HiveField(0)
  final String documentId;
  
  @HiveField(1)
  final String productName;
  
  @HiveField(2)
  int? totalQuantity;
  
  PurchasesModel({
    required this.documentId,
    required this.productName,
    this.totalQuantity,
  });
}