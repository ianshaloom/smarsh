// ignore: library_prefixes
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:to_csv/to_csv.dart' as exportCSV;

import '../../../services/cloud/cloud_storage_exceptions.dart';
import '../../../services/cloud/firebase_cloud_storage.dart';
import '../../../services/hive/models/final_count_model/final_count_model.dart';
import '../../../services/hive/service/hive_constants.dart';
import '../../../global/helpers/snacks.dart';
import '../../../services/cloud/cloud_product.dart';
import '../../../services/hive/service/hive_service.dart';

mixin StockTakingMixin {
  final List<FinalCountModel> finalCount = GetMeFromHive.getAllFinalCounts;
  final List<String> headers = ['Product Code', 'Product Name', 'Counted'];

  void addCount(
      List<dynamic> count, String productCode, BuildContext cxt) async {
    try {
      await FirebaseCloudStorage()
          .updateCountListProduct(
            documentId: productCode,
            count: count,
          )
          .then((value) => Snack().cloudSuccess(0, cxt));
    } on CouldNotUpdateException {
      Snack().cloudError(0, cxt);
    }
  }

  int getCount(List<int> counts) {
    // add all integers in the list
    int count =
        counts.fold(0, (previousValue, element) => previousValue + element);
    return count;
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
        final List<int> count = product.count.cast<int>().toList();

        final FinalCountModel f = FinalCountModel(
          productId: product.documentId,
          productName: product.productName,
          count: getCount(count),
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
        'Counted'
      ];
      final List<CloudProduct> cloudCount = cloudStock;

      // sort by product name
      cloudCount.sort((a, b) => a.productName.compareTo(b.productName));

      List<List<String>> listOfLists = [];
      List<String> data = [];

      for (var e in cloudCount) {
        data.add(e.productName);
        data.add(e.stockCount.toString());
        data.add(getCount(e.count.cast<int>().toList()).toString());
        listOfLists.add(data);
        data = [];
      }

      exportCSV.myCSV(headers, listOfLists, sharing: true);
    } on Exception catch (e) {
      Snack().showSnackBar(context: context, message: e.toString());
    }
  }
}
