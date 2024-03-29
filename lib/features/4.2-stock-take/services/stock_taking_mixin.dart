// ignore: library_prefixes
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:to_csv/to_csv.dart' as exportCSV;

import '../../../services/cloud/cloud_storage_exceptions.dart';
import '../../../services/cloud/cloud_storage_services.dart';
import '../../../services/hive/models/final_count_model/final_count_model.dart';
import '../../../services/hive/models/processed_stock_model/processed_stock.dart';
import '../../../services/hive/service/hive_constants.dart';
import '../../../global/helpers/snacks.dart';
import '../../../services/cloud/cloud_entities.dart';
import '../../../services/hive/service/hive_service.dart';

mixin StockTakingMixin {
  final List<FinalCountModel> finalCount = GetMeFromHive.getAllFinalCounts;

  void addCount(
      List<dynamic> count, String productCode, BuildContext cxt) async {
    try {
      await FirestoreProducts()
          .updateCountListProduct(
            documentId: productCode,
            count: count,
          )
          .then((value) => Snack().cloudSuccess(0, cxt));
    } on CouldNotUpdateException {
      Snack().cloudError(0, cxt);
    }
  }

  void removeCount(
    List<dynamic> count,
    String productCode,
  ) async {
    // update cloud counted product with new list of counts
    await FirestoreProducts().updateCountListProduct(
      documentId: productCode,
      count: count,
    );
  }

  // export Cloud Product Count to final count model and save to device
  Stream<int> exportingFinal(
    BuildContext context,
    List<CloudProduct> cloudStock,
  ) async* {
    try {
      await HiveFinalCount().deleteAllProducts();
      final List<CloudProduct> cloudCount = cloudStock;

      for (int i = 0; i < cloudCount.length; i++) {
        final CloudProduct product = cloudCount[i];

        final FinalCountModel f = FinalCountModel(
          productId: product.documentId,
          productName: product.productName,
          count: product.totalCount,
          date: DateTime.now(),
        );

        await HiveFinalCount().addProduct(f);

        yield ((i / cloudCount.length) * 100).round();
      }
    } on Exception catch (_) {
      Snack().showSnackBar(
          context: context, message: 'Could not export to final count');
    }
  }

  Future exportToCsv(
      BuildContext context, List<CloudProduct> cloudStock) async {
    try {
      final List<String> headers = [
        'Product Name',
        'Previous Count',
        'Expected Count',
        'Counted',
        'Whole Price',
      ];
      final List<CloudProduct> cloudCount = cloudStock;

      // sort by product name
      cloudCount.sort((a, b) => a.productName.compareTo(b.productName));

      List<List<String>> listOfLists = [];
      List<String> data = [];

      for (var e in cloudCount) {
        data.add(e.productName);
        data.add(e.stockCount.toString());
        data.add(getExpectedCount(e.documentId).toString());
        data.add(e.totalCount.toString());
        data.add(e.sellingPrice.toString());
        listOfLists.add(data);
        data = [];
      }

      exportCSV.myCSV(headers, listOfLists);
    } on Exception catch (e) {
      Snack().showSnackBar(context: context, message: e.toString());
    }
  }

  int getExpectedCount(String productCode) {
    final List<ProcessedData> products = GetMeFromHive.getAllProcessedData;

    if (products.isEmpty) {
      return 403;
    }

    ProcessedData product = products
        .firstWhere((element) => element.documentId == productCode, orElse: () {
      return ProcessedData(
        documentId: productCode,
        productName: 'Product not found',
        stockCount: 404,
      );
    });
    // products.firstWhere((element) => element.documentId == productCode);
    return product.stockCount;
  }

  Stream<int> fetchingPr() async* {
    await HiveProcessedData().deleteAllProcessedData();
    //
    List<CloudProcessed> cproducts = [];
    List<ProcessedData> lproducts = [];
    cproducts = await FirestoreProcessed().getAllProcessed();

    for (var pr in cproducts) {
      final localProcessed = ProcessedData(
        documentId: pr.documentId,
        productName: pr.productName,
        stockCount: pr.expectedCount,
      );

      lproducts.add(localProcessed);
      await HiveProcessedData().addProcessedData(localProcessed);

      yield ((cproducts.indexOf(pr) / cproducts.length) * 100).round();
    }
  }
}
