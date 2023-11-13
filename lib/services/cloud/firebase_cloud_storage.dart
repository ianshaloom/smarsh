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
      'count': [],
    };

    try {
      stock.doc(customDocumentId).set(document);

      final fetchedProduct = await stock.doc(customDocumentId).get();

      return CloudProduct(
        documentId: fetchedProduct.id,
        productName: fetchedProduct['productName'],
        buyingPrice: fetchedProduct['buyingPrice'],
        sellingPrice: fetchedProduct['sellingPrice'],
        stockCount: fetchedProduct['stockCount'],
        count: fetchedProduct['count'],
      );
    } catch (e) {
      throw CouldNotCreateException();
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
        count: fetchedProduct['count'],
      );
    } catch (e) {
      throw CouldNotUpdateException();
    }
  }

  // update product stock count
  Future<void> updateProductStockCount({
    required String documentId,
    required int stockCount,
  }) async {
    try {
      await stock.doc(documentId).update({
        'stockCount': stockCount,
      });
    } catch (e) {
      throw CouldNotUpdateException();
    }
  }

  // Update counted product
  Future<void> updateCountListProduct({
    required String documentId,
    required List<dynamic>? count,
  }) async {
    try {
      await stock.doc(documentId).update({
        'count': count,
      });
    } catch (e) {
      throw CouldNotUpdateException();
    }
  }

  // delete product
  Future<void> deleteProduct({required String documentId}) async {
    try {
      await stock.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteException();
    }
  }

// clear all products collection
  Future<void> clearAllProducts() async {
    try {
      await stock.get().then((value) async {
        for (var element in value.docs) {
          await stock.doc(element.id).delete();
        }
      });
    } catch (e) {
      throw CouldNotDeleteException();
    }
  }

  // get all products
  Stream<List<CloudProduct>> allProducts() {
    final allProducts = stock.snapshots().map((event) => event.docs
        .map((doc) => CloudProduct.fromDocSnapshot(documentSnapshot: doc))
        .toList());
    return allProducts;
  }

// stream a single cloudproduct
  Stream singleProductStream({required String documentId}) {
    return stock
        .doc(documentId)
        .snapshots()
        .map((event) => CloudProduct.fromDocSnapshot(documentSnapshot: event));
  }

  Future<List<CloudProduct>> getAllStock() async {
    final snapShot = await stock.get();
    final fetchedProducts = snapShot.docs
        .map((doc) => CloudProduct.fromDocSnapshot(documentSnapshot: doc))
        .toList();

    return fetchedProducts;
  }

  // check if collection is empty
  Future<bool> isCollectionEmpty() async {
    try {
      final snapShot = await stock.get();
      final fetchedProducts = snapShot.docs
          .map((doc) => CloudProduct.fromDocSnapshot(documentSnapshot: doc))
          .toList();

      if (fetchedProducts.isEmpty) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (_) {
      throw GenericCloudException();
    }
  }

  // reset Cloudproduct count by setting count to empty list
  Future resetCount({required String documentId}) async {
    try {
      final fetchedProduct = await stock.doc(documentId).get();
      final CloudProduct e =
          CloudProduct.fromDocSnapshot(documentSnapshot: fetchedProduct);

      if (e.count.isEmpty) {
        // got to next element
      } else {
        await stock.doc(e.documentId).update({
          'count': [],
        });
      }
    } catch (e) {
      throw CouldNotUpdateException();
    }
  }

  FirebaseCloudStorage._sharedInstance();
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}

// Same as above, but for CloudUsers

class FirebaseCloudUsers {
  final users = FirebaseFirestore.instance.collection('users');

  Future<CloudUser> createUser({
    required String userId,
    required String username,
    required String email,
    required String role,
    required String url,
    required String provider,
    required String color,
  }) async {
    String customDocumentId = userId;
    final document = {
      'userId': customDocumentId,
      'username': username,
      'email': email,
      'role': role,
      'url': url,
      'provider': provider,
      'color': color,
    };

    try {
      users.doc(customDocumentId).set(document);
      final fetchedUser = await users.doc(customDocumentId).get();

      return CloudUser(
        userId: fetchedUser.id,
        username: fetchedUser['username'],
        email: fetchedUser['email'],
        role: fetchedUser['role'],
        url: fetchedUser['url'],
        signInProvider: fetchedUser['provider'],
        color: fetchedUser['color'],
      );
    } catch (e) {
      throw CouldNotCreateException();
    }
  }

  // update user
  Future<CloudUser> updateUser({
    required String userId,
    required String username,
    required String email,
    required String role,
    required String url,
    required String provider,
    required String color,
  }) async {
    try {
      await users.doc(userId).update({
        'username': username,
        'email': email,
        'role': role,
        'url': url,
        'provider': provider,
        'color': color,
      });

      final fetchedUser = await users.doc(userId).get();
      return CloudUser(
        userId: fetchedUser.id,
        username: fetchedUser['username'],
        email: fetchedUser['email'],
        role: fetchedUser['role'],
        url: fetchedUser['url'],
        signInProvider: fetchedUser['provider'],
        color: fetchedUser['color'],
      );
    } catch (e) {
      throw CouldNotUpdateException();
    }
  }

  // delete user
  Future<void> deleteUser({required String documentId}) async {
    try {
      await users.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteException();
    }
  }

  // get all users
  Stream<List<CloudUser>> allUsers() {
    final allUsers = users.snapshots().map((event) => event.docs
        .map((doc) => CloudUser.fromQuerySnapshot(documentSnapshot: doc))
        .toList());
    return allUsers;
  }

  Future<List<CloudUser>> getAllUsers() async {
    final snapShot = await users.get();
    final fetchedUsers = snapShot.docs
        .map((doc) => CloudUser.fromQuerySnapshot(documentSnapshot: doc))
        .toList();

    return fetchedUsers;
  }

  // get a future of a single user by id fromdocsnapshot
  Future<CloudUser?> singleUser({required String documentId}) async {
    try {
      final fetchedUser = await users.doc(documentId).get();

      if (fetchedUser.exists) {
        return CloudUser(
          userId: fetchedUser.id,
          username: fetchedUser['username'],
          email: fetchedUser['email'],
          role: fetchedUser['role'],
          url: fetchedUser['url'],
          signInProvider: fetchedUser['provider'],
          color: fetchedUser['color'],
        );
      } else {
        return null;
      }
    } catch (e) {
      throw GenericCloudException();
    }
  }

  // stream a single user by id
  Stream singleUserStream({required String documentId}) {
    return users
        .doc(documentId)
        .snapshots()
        .map((event) => CloudUser.fromDocSnapshot(documentSnapshot: event));
  }

  FirebaseCloudUsers._sharedInstance();

  static final FirebaseCloudUsers _shared =
      FirebaseCloudUsers._sharedInstance();
  factory FirebaseCloudUsers() => _shared;
}
