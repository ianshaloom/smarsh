// import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// @immutable
class CloudProduct {
  final String documentId;

  final String productName;

  final double buyingPrice;

  final double sellingPrice;

  final int stockCount;

  List<dynamic> count;

  // required constructor
  CloudProduct({
    required this.documentId,
    required this.productName,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.stockCount,
    this.count = const [],
  });

  CloudProduct.fromDocSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : documentId = documentSnapshot.id,
        productName = documentSnapshot['productName'],
        buyingPrice = documentSnapshot['buyingPrice'],
        sellingPrice = documentSnapshot['sellingPrice'],
        stockCount = documentSnapshot['stockCount'],
        count = documentSnapshot['count'];

  // from Querysnapshot
  CloudProduct.fromQuerySnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : documentId = documentSnapshot.id,
        productName = documentSnapshot['productName'],
        buyingPrice = documentSnapshot['buyingPrice'],
        sellingPrice = documentSnapshot['sellingPrice'],
        stockCount = documentSnapshot['stockCount'],
        count = documentSnapshot['count'];
}

class CloudUser {
  final String userId;
  final String username;
  final String email;
  final String role;
  final String url;

  CloudUser({
    required this.userId,
    required this.username,
    required this.email,
    required this.role,
    required this.url,
  });

  CloudUser.fromQuerySnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : userId = documentSnapshot.id,
        username = documentSnapshot['username'],
        email = documentSnapshot['email'],
        role = documentSnapshot['role'],
        url = documentSnapshot['url'];


  CloudUser.fromDocSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : userId = documentSnapshot.id,
        username = documentSnapshot['username'],
        email = documentSnapshot['email'],
        role = documentSnapshot['role'],
        url = documentSnapshot['url'];
}

