import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../services/cloud/cloud_storage_exceptions.dart';
import '../entities/cloud_nonposted.dart';

class NonPostRemoteDataSrcRd {
  final nonposted = FirebaseFirestore.instance.collection('non-posted');

  // update nonposted item
  Future updateNonPosted({
    required id,
    required expectedCount,
    required recentCount,
  }) async {
    try {
      await nonposted.doc(id).update({
        'expectedCount': expectedCount,
        'recentCount': recentCount,
      });
    } catch (e) {
      throw CouldNotUpdateException();
    }
  }
  
  // return a stream of type list of cloud nonposted
  Stream<List<CloudNonPosted>> excessStream() {
    return nonposted.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            return CloudNonPosted.fromQuerySnapshot(documentSnapshot: doc);
          })
          .where((element) => (element.recentCount - element.expectedCount) > 0)
          .toList();
    });
  }

  Stream<List<CloudNonPosted>> missingStream() {
    return nonposted.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            return CloudNonPosted.fromQuerySnapshot(documentSnapshot: doc);
          })
          .where((element) => (element.recentCount - element.expectedCount) < 0)
          .toList();
    });
  }

  Stream<List<CloudNonPosted>> intactStream() {
    return nonposted.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            return CloudNonPosted.fromQuerySnapshot(documentSnapshot: doc);
          })
          .where(
              (element) => (element.recentCount - element.expectedCount) == 0)
          .toList();
    });
  }

  Stream<List<CloudNonPosted>> nonpostStream() {
    return nonposted.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            return CloudNonPosted.fromQuerySnapshot(documentSnapshot: doc);
          })
          .where(
              (element) => (element.recentCount - element.expectedCount) != 0)
          .toList();
    });
  }

  // factory constructor
  NonPostRemoteDataSrcRd._();
  static final instance = NonPostRemoteDataSrcRd._();
  factory NonPostRemoteDataSrcRd() => instance;
}