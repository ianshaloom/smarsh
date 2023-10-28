import 'package:cloud_firestore/cloud_firestore.dart';

class CloudNonPosted {
  final String id;
  final String name;
  final int expectedCount;
  final int recentCount;
  // final int lastCount;
  // final int sales;
  // final int purchases;
  int? _nonPosted;

  int get nonPosted {
    _nonPosted = recentCount - expectedCount;

    return _nonPosted!;
  }

  // named constructor
  CloudNonPosted({
    required this.id,
    required this.name,
    required this.expectedCount,
    required this.recentCount,
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
        recentCount = documentSnapshot['recentCount']
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
        recentCount = documentSnapshot['recentCount']
        // lastCount = documentSnapshot['lastCount'],
        // sales = documentSnapshot['sales'],
        // purchases = documentSnapshot['purchases']
        
        ;
}
