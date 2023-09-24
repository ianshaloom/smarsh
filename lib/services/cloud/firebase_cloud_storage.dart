import 'package:cloud_firestore/cloud_firestore.dart';

import 'cloud_product.dart';
import 'cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final stock = FirebaseFirestore.instance.collection('stock');

  Future<CloudProduct> createProduct({
    required String documentId,
    required String productName,
    required double buyingPrice,
    required double sellingPrice,
    required int stockCount,
  }) async {
    String customDocumentId = documentId;
    final document = {
      'productId': customDocumentId,
      'productName': productName,
      'buyingPrice': buyingPrice,
      'sellingPrice': sellingPrice,
      'stockCount': stockCount,
    };

    try {
      stock.doc(customDocumentId).set(document).then((value) {
        print("Product Added");
      }).catchError((error) {
        print("Failed to add product: $error");
      });

      //  final document = await stock.add({
      //     'documentId': documentId,
      //     'productName': productName,
      //     'buyingPrice': buyingPrice,
      //     'sellingPrice': sellingPrice,
      //     'stockCount': stockCount,
      //   });

      final fetchedProduct = await stock.doc(customDocumentId).get();

      return CloudProduct(
        documentId: fetchedProduct.id,
        productName: fetchedProduct['productName'],
        buyingPrice: fetchedProduct['buyingPrice'],
        sellingPrice: fetchedProduct['sellingPrice'],
        stockCount: fetchedProduct['stockCount'],
      );
    } catch (e) {
      throw CouldNotCreateProductException();
    }
  }

  // update product
  Future<CloudProduct> updateProduct({
    required String documentId,
    required String productName,
    required double buyingPrice,
    required double sellingPrice,
    required int stockCount,
  }) async {
    try {
      await stock.doc(documentId).update({
        'productName': productName,
        'buyingPrice': buyingPrice,
        'sellingPrice': sellingPrice,
        'stockCount': stockCount,
      });

      final fetchedProduct = await stock.doc(documentId).get();
      return CloudProduct(
        documentId: fetchedProduct.id,
        productName: fetchedProduct['productName'],
        buyingPrice: fetchedProduct['buyingPrice'],
        sellingPrice: fetchedProduct['sellingPrice'],
        stockCount: fetchedProduct['stockCount'],
      );
    } catch (e) {
      throw CouldNotUpdateProductException();
    }
  }

  // delete product
  Future<void> deleteProduct({required String documentId}) async {
    try {
      await stock.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteProductException();
    }
  }

  // get all products
  Stream<List<CloudProduct>> allProducts() {
    final allProducts = stock.snapshots().map((event) => event.docs
        .map((doc) => CloudProduct.fromSnapshot(documentSnapshot: doc))
        .toList());
    return allProducts;
  }

  Future<List<CloudProduct>> getAllStock() async {
    final snapShot = await stock.get();
    final fetchedProducts = snapShot.docs
        .map((doc) => CloudProduct.fromSnapshot(documentSnapshot: doc))
        .toList();

    return fetchedProducts;
  }

  // Future<void> deleteProduct({required String documentId}) async {
  //   try {
  //     await stock.doc(documentId).delete();
  //   } catch (e) {
  //     throw CouldNotDeleteNoteException();
  //   }
  // }

  // Future<void> updateProduct({
  //   required String documentId,
  //   required String text,
  // }) async {
  //   try {
  //     await stock.doc(documentId).update({textFieldName: text});
  //   } catch (e) {
  //     throw CouldNotUpdateNoteException();
  //   }
  // }

  // Stream<Iterable<CloudProduct>> allProducts({required String ownerUserId}) {
  //   final allNotes = stock
  //       .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
  //       .snapshots()
  //       .map((event) => event.docs.map((doc) => CloudProduct.fromSnapshot(doc)));
  //   return allNotes;
  // }

  // Future<CloudProduct> addProduct({required String documentId}) async {
  //   final document = await product.add({
  //     ownerUserIdFieldName: ownerUserId,
  //     textFieldName: '',
  //   });
  //   final fetchedNote = await document.get();
  //   return CloudProduct(
  //     documentId: fetchedNote.id,
  //     ownerUserId: ownerUserId,
  //     text: '',
  //   );
  // }

  FirebaseCloudStorage._sharedInstance();
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
