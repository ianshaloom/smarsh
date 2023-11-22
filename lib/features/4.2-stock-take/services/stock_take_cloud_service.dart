import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCloudApp {
  final app = FirebaseFirestore.instance.collection('app');

  // returns a bool of app document by id
  Future<bool> isStockTakeDisabled(String id) async {
    final doc = await app.doc(id).get();
    return doc.get('isDisabled');
  }

  // set isDisabled to false
  Future<void> enableStockTake(String id) async {
    await app.doc(id).update({'isDisabled': false});
  }

  // set isDisabled to true
  Future<void> disableStockTake(String id) async {
    await app.doc(id).update({'isDisabled': true});
  }
}
