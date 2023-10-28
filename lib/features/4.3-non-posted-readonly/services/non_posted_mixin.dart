import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:to_csv/to_csv.dart' as exportCSV;

import '../../../constants/hive_constants.dart';
import '../../../global/helpers/snacks.dart';
import '../../../services/hive/models/item_count/filter_model.dart';
import '../../../services/hive/models/local_product/local_product_model.dart';
import '../entities/cloud_nonposted.dart';
import 'filter_hive_service.dart';

mixin NonPostedMixin {
  final List<LocalProduct> stock = GetMeFromHive.getAllLocalProducts;

  double totalForAllItems(List<CloudNonPosted> non) {
    double total = 0;
    for (var e in non) {
      for (var element in stock) {
        if (element.documentId == e.id) {
          double t = element.buyingPrice * e.nonPosted;
          total += t;
        }
      }
    }
    return total;
  }

  double totalForOneItem(CloudNonPosted non) {
    final LocalProduct p =
        stock.firstWhere((element) => element.documentId == non.id);
    double t = p.buyingPrice * non.nonPosted;

    return t;
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
        data.add(totalForOneItem(e).toStringAsFixed(2));
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
