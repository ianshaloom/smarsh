import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:to_csv/to_csv.dart' as exportCSV;

import '../../../services/hive/models/filter_model/filter_model.dart';
import '../../../services/hive/models/local_product_model/local_product_model.dart';
import '../../../services/hive/service/hive_constants.dart';
import '../../../global/helpers/snacks.dart';
import '../entities/cloud_nonposted.dart';
import 'filter_hive_service.dart';

mixin NonPostedMixin {
  final List<LocalProduct> stock = GetMeFromHive.getAllLocalProducts;

  double totalForAllItems(List<CloudNonPosted> non) {
    non.sort((a, b) => a.name.compareTo(b.name));

    double total = 0;
    for (var e in non) {
      double t = e.totalNonPosted;
      total += t;
    }
    return total;
  }

  int lastStockTake(String id) {
    final LocalProduct p =
        stock.firstWhere((element) => element.documentId == id);
    return p.stockCount;
  }

  // Create Filter object for non-posted items
  Future createFilter() async {
    final bool isEmpty = HiveBoxes.getFilterBox().isEmpty;

    if (isEmpty) {
      final FilterModel filter = FilterModel(
        isAll: true,
        isExcess: false,
        isIntact: false,
        isMissing: false,
      );

      await FilterService().addProduct(filter);
    } else {
      final FilterModel filter = GetMeFromHive.getAllItemCounts.first;

      filter.isAll = true;
      filter.isExcess = false;
      filter.isIntact = false;
      filter.isMissing = false;

      await filter.save();
    }
  }

  // Export non-posted items to CSV
  Future exportToCsv(
      BuildContext context, List<CloudNonPosted> nonPosted) async {
    try {
      final List<CloudNonPosted> nonPost = nonPosted;

      // sort by product name
      nonPost.sort((a, b) => a.name.compareTo(b.name));

      List<List<String>> listOfLists = [];
      List<String> data = [];

      for (var e in nonPost) {
        data.add(e.name);
        data.add(e.nonPosted.toString());
        data.add(e.totalNonPosted.toStringAsFixed(2));
        listOfLists.add(data);
        data = [];
      }

      exportCSV.myCSV(headers, listOfLists, sharing: true);
    } on Exception catch (e) {
      Snack().showSnackBar(context: context, message: e.toString());
    }
  }
}

const List<String> headers = [
  'Product Name',
  'Quantity',
  'Amount',
];
