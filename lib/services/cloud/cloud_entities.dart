// import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../global/helpers/data_helper.dart';

class CloudProduct {
  final String documentId;

  final String productName;

  final double buyingPrice;

  final double sellingPrice;

  final int stockCount;

  List<dynamic> count;

  int get totalCount {
    int total;
    List<Map<String, dynamic>> counts = count.cast<Map<String, dynamic>>();
    counts.isEmpty ? total = 0 : total = DataHelper.countFromMap(counts);
    return total;
  }

  List<ItemCount> get itemsCount {
    List<Map<String, dynamic>> counts = count.cast<Map<String, dynamic>>();
    if (counts.isEmpty) {
      return [];
    }
    List<ItemCount> itemsCount = [];

    for (var e in counts) {
      itemsCount.add(ItemCount.fromMap(e));
    }
    return itemsCount;
  }

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
  final String signInProvider;
  final String color;

  // Color get colorValue {
  //   if (color == 'green') {
  //     return c1;
  //   } else if (color == 'blue') {
  //     return c2;
  //   } else if (color == 'orange') {
  //     return c3;
  //   } else {
  //     return c4;
  //   }
  // }

  static final CloudUser empty = CloudUser(
    userId: '',
    username: '',
    email: '',
    role: '',
    url: '',
    signInProvider: '',
    color: '',
  );

  CloudUser({
    required this.userId,
    required this.username,
    required this.email,
    required this.role,
    required this.url,
    required this.signInProvider,
    required this.color,
  });

  CloudUser.fromQuerySnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : userId = documentSnapshot.id,
        username = documentSnapshot['username'],
        email = documentSnapshot['email'],
        role = documentSnapshot['role'],
        url = documentSnapshot['url'],
        signInProvider = documentSnapshot['provider'],
        color = documentSnapshot['color'];

  CloudUser.fromDocSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : userId = documentSnapshot.id,
        username = documentSnapshot['username'],
        email = documentSnapshot['email'],
        role = documentSnapshot['role'],
        url = documentSnapshot['url'],
        signInProvider = documentSnapshot['provider'],
        color = documentSnapshot['color'];
}

class CloudProcessed{
  final String documentId;
  final String productName;
  final int expectedCount;

  CloudProcessed({
    required this.documentId,
    required this.productName,
    required this.expectedCount,
  });

  CloudProcessed.fromDocSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : documentId = documentSnapshot.id,
        productName = documentSnapshot['productName'],
        expectedCount = documentSnapshot['expectedCount'];

  CloudProcessed.fromQuerySnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : documentId = documentSnapshot.id,
        productName = documentSnapshot['productName'],
        expectedCount = documentSnapshot['expectedCount'];


}

class ItemCount {
  final String color;
  final int count;
  Color get colorValue {
    if (color == 'brown') {
      return c1;
    } else if (color == 'orange') {
      return c2;
    } else if (color == 'purple') {
      return c3;
    } else if (color == 'blue') {
      return c4;
    } else if (color == 'red') {
      return c6;
    } else {
      return c5;
    }
  }

  ItemCount({
    required this.color,
    required this.count,
  });

  ItemCount.fromMap(Map<String, dynamic> map)
      : color = map['color'],
        count = map['count'];
}
