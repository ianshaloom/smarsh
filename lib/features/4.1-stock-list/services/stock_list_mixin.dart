import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:to_csv/to_csv.dart' as exportCSV;

import '../../../global/helpers/snacks.dart';
import '../../../services/cloud/cloud_product.dart';
import '../../../services/cloud/firebase_cloud_storage.dart';
import '../../../services/hive/models/local_product_model/local_product_model.dart';
import '../../../services/hive/service/hive_service.dart';

mixin StockListMixin {
// Refresh Local data source for Localproduct
  Stream<int> refreshingPr() async* {
    await HiveLocalProduct().deleteAllProducts();

    List<CloudProduct> cloudProducts =
        await FirebaseCloudStorage().getAllStock();

    for (var e in cloudProducts) {
      final localProduct = LocalProduct(
        productName: e.productName,
        buyingPrice: e.buyingPrice,
        sellingPrice: e.sellingPrice,
        stockCount: e.stockCount,
        documentId: e.documentId,
      );

      await HiveLocalProduct().addProduct(localProduct);

      yield (cloudProducts.indexOf(e) / cloudProducts.length * 100).round();
    }
  }
/* -------------------------------------------------------------------------- */

  Future exportToCsv(BuildContext context, List<LocalProduct> prs) async {
    try {
      final List<LocalProduct> toBeExported = prs;

      // sort by product name
      toBeExported.sort((a, b) => a.productName.compareTo(b.productName));

      List<List<String>> listOfLists = [];
      List<String> data = [];

      for (var e in toBeExported) {
        data.add(e.productName);
        data.add(e.buyingPrice.toStringAsFixed(2));
        data.add(e.sellingPrice.toStringAsFixed(2));
        data.add(e.stockCount.toString());
        listOfLists.add(data);
        data = [];
      }

      exportCSV.myCSV(_headers, listOfLists);
    } on Exception catch (e) {
      Snack().showSnackBar(context: context, message: e.toString());
    }
  }
}

const List<String> _headers = [
  'Product Name',
  'Buying Price',
  'Selling Price',
  'In Stock',
];
