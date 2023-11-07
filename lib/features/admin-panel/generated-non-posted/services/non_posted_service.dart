import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../services/cloud/cloud_storage_exceptions.dart';
import '../entities/cloud_nonposted.dart';

class AdminNonPostRemoteDataSrc {
  final nonposted = FirebaseFirestore.instance.collection('non-posted');

  Future createNonPosted({
    required id,
    required name,
    required expectedCount,
    required recentCount,
    required sellingsPrice,
  }) async {
    String customDocumentId = id;
    final document = {
      'id': customDocumentId,
      'name': name,
      'expectedCount': expectedCount,
      'recentCount': recentCount,
      'sellingsPrice': sellingsPrice,
    };

    try {
      await nonposted.doc(customDocumentId).set(document);
    } catch (e) {
      throw CouldNotCreateException();
    }
  }

  // future that returns a list of non-posted items
  Future<List<CloudNonPost>> getAllNonPosted() async {
    //print('getting all non-posted items');
    try {
      final snapshot = await nonposted.get();
      final nonPosted = snapshot.docs
          .map((doc) => CloudNonPost.fromDocSnapshot(documentSnapshot: doc))
          .toList();
      return nonPosted;
    } catch (e) {
      throw GenericCloudException();
    }
  }

  // delete non-posted item
  Future deleteNonPosted({required String id}) async {
    try {
      await nonposted.doc(id).delete();
    } catch (e) {
      throw CouldNotDeleteException();
    }
  }

  // factory constructor
  AdminNonPostRemoteDataSrc._();
  static final instance = AdminNonPostRemoteDataSrc._();
  factory AdminNonPostRemoteDataSrc() => instance;
}
