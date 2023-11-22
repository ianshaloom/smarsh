// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../../global/helpers/snacks.dart';
import '../../../../services/cloud/cloud_product.dart';
import '../../../../services/cloud/cloud_storage_exceptions.dart';
import '../../../../services/cloud/firebase_cloud_storage.dart';
import '../../../../services/hive/models/local_product_model/local_product_model.dart';
import '../../../../services/hive/service/hive_constants.dart';
import '../../../../services/hive/service/hive_service.dart';
import '../entities/cloud_nonposted.dart';
import '../widgets/clear_cloud_nonposted_progress.dart';
import '../widgets/upload_nonposted_progress.dart';
import 'non_posted_service.dart';

mixin NonPostedMixin {
  final List<LocalProduct> stock = GetMeFromHive.getAllLocalProducts;

  double totalNonPosted(List<CloudNonPost> non) {
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

  Stream<int> uploadingNp(List<CloudNonPost> items) async* {
    try {
      for (int i = 0; i < items.length; i++) {
        final CloudNonPost item = items[i];
        await AdminNonPostRemoteDataSrc().createNonPosted(
          id: item.id,
          name: item.name,
          expectedCount: item.expectedCount,
          recentCount: item.recentCount,
          sellingsPrice: item.sellingsPrice,
        );

        yield (i / items.length * 100).round();
      }
    } on CouldNotCreateException {
      return;
    }
  }

  Stream<int> clearingNp(BuildContext context) async* {

    try {
      List<CloudNonPost> nonposted =
          await AdminNonPostRemoteDataSrc().getAllNonPosted();

      for (int i = 0; i < nonposted.length; i++) {
        final CloudNonPost product = nonposted[i];
        await AdminNonPostRemoteDataSrc().deleteNonPosted(id: product.id);

        // pop context on last iteration
        yield ((i / nonposted.length) * 100).round();
      }
    } on CouldNotDeleteException {
      Snack().showSnackBar(
          context: context, message: 'Could not delete from cloud');
    }
  }

  Future confirmClearNonposted(BuildContext context) async {
    final bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Non Posted'),
        content: const Text(
            'Are you sure you want to clear all non posted items in cloud storage?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await showDialog(
        barrierColor: Colors.black38,
        context: context,
        barrierDismissible: false,
        builder: (_) => const ClearNonpostedProgress(),
      );
    }
  }

  Future confirmUploadNonposted(
      BuildContext context, List<CloudNonPost> locals) async {
    final bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Non Posted'),
        content: const Text(
            'Are you sure you want to upload all non posted items to cloud storage?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Upload'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await showDialog(
        barrierColor: Colors.black38,
        context: context,
        barrierDismissible: false,
        builder: (_) => NonPostedUploadProgress(locals: locals),
      );
    }
  }
}
