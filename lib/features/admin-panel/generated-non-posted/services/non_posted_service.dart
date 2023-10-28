import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../services/cloud/cloud_storage_exceptions.dart';

class AdminNonPostRemoteDataSrc {
  final nonposted = FirebaseFirestore.instance.collection('non-posted');

  Future createNonPosted({
    required id,
    required name,
    required expectedCount,
    required recentCount,
  }) async {
    String customDocumentId = id;
    final document = {
      'id': customDocumentId,
      'name': name,
      'expectedCount': expectedCount,
      'recentCount': recentCount,
    };

    try {
      await nonposted.doc(customDocumentId).set(document);
    } catch (e) {
      throw CouldNotCreateException();
    }
  }

  // factory constructor
  AdminNonPostRemoteDataSrc._();
  static final instance = AdminNonPostRemoteDataSrc._();
  factory AdminNonPostRemoteDataSrc() => instance;
}
