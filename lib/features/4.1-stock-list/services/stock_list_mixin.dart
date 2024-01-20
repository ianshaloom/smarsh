import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:to_csv/to_csv.dart' as exportCSV;

import '../../../global/helpers/snacks.dart';
import '../../../services/cloud/cloud_entities.dart';
import '../../../services/cloud/cloud_storage_services.dart';
import '../../../services/hive/models/local_product_model/local_product_model.dart';
import '../../../services/hive/service/hive_service.dart';

mixin StockListMixin {
// Refresh Local data source for Localproduct
  Stream<int> refreshingPr() async* {
    await HiveLocalProduct().deleteAllProducts();

    List<CloudProduct> cloudProducts = await FirestoreProducts().getAllStock();

    for (var e in cloudProducts) {
      final localProduct = LocalProduct(
        productName: e.productName,
        retail: e.buyingPrice,
        wholesale: e.sellingPrice,
        lastCount: e.stockCount,
        documentId: e.documentId,
        todaysCount: e.totalCount,
      );

      await HiveLocalProduct().addProduct(localProduct);

      yield (cloudProducts.indexOf(e) / cloudProducts.length * 100).round();
    }
  }

/* -------------------------------------------------------------------------- */
  Future exportToCsv(BuildContext context) async {
    try {
      final List<CloudProduct> cloudProducts =
          await FirestoreProducts().getAllStock();

      // sort by product name
      cloudProducts.sort((a, b) => a.productName.compareTo(b.productName));

      List<List<String>> listOfLists = [];
      List<String> data = [];

      for (var e in cloudProducts) {
        data.add(e.documentId);
        data.add(e.productName);
        data.add(e.buyingPrice.toStringAsFixed(2));
        data.add(e.sellingPrice.toStringAsFixed(2));
        data.add(e.stockCount.toString());
        listOfLists.add(data);
        data = [];
      }

      exportCSV.myCSV(headers, listOfLists);
    } on Exception catch (e) {
      // ignore: use_build_context_synchronously
      Snack().showSnackBar(context: context, message: e.toString());
    }
  }
}

const List<String> headers = [
  'Product ID',
  'Product Name',
  'Buying Price',
  'Selling Price',
  'Quantity',
];
