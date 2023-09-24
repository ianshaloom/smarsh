import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class CloudProduct {
  
  final String documentId;

  final String productName;

  final double buyingPrice;

  final double sellingPrice;

  final int stockCount;

  // required constructor
  const CloudProduct({
    required this.documentId,
    required this.productName,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.stockCount,
  });
  
  
  CloudProduct.fromSnapshot({required QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : documentId = documentSnapshot.id,
        productName = documentSnapshot['productName'],
        buyingPrice = documentSnapshot['buyingPrice'],
        sellingPrice = documentSnapshot['sellingPrice'],
        stockCount = documentSnapshot['stockCount'];
  
  
}
