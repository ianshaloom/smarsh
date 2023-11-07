import 'package:cloud_firestore/cloud_firestore.dart';

class CloudNonPosted {
  final String id;
  final String name;
  final int expectedCount;
  final int recentCount;
  final double sellingsPrice;
  // final int lastCount;
  // final int sales;
  // final int purchases;
  int? _nonPosted;
  double? _totalNonPosted;

  int get nonPosted {
    _nonPosted = recentCount - expectedCount;

    return _nonPosted!;
  }

  double get totalNonPosted {
    _totalNonPosted = sellingsPrice * nonPosted;

    return _totalNonPosted!;
  }

  // named constructor
  CloudNonPosted({
    required this.id,
    required this.name,
    required this.expectedCount,
    required this.recentCount,
    required this.sellingsPrice,
    // required this.lastCount,
    // required this.sales,
    // required this.purchases,
  });

  // from document snapshot
  CloudNonPosted.fromDocSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : id = documentSnapshot.id,
        name = documentSnapshot['name'],
        expectedCount = documentSnapshot['expectedCount'],
        recentCount = documentSnapshot['recentCount'],
        sellingsPrice = documentSnapshot['sellingsPrice']
  // lastCount = documentSnapshot['lastCount'],
  // sales = documentSnapshot['sales'],
  // purchases = documentSnapshot['purchases']

  ;

  // from query snapshot
  CloudNonPosted.fromQuerySnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : id = documentSnapshot.id,
        name = documentSnapshot['name'],
        expectedCount = documentSnapshot['expectedCount'],
        recentCount = documentSnapshot['recentCount'],
        sellingsPrice = documentSnapshot['sellingsPrice']
  // lastCount = documentSnapshot['lastCount'],
  // sales = documentSnapshot['sales'],
  // purchases = documentSnapshot['purchases']

  ;
}

