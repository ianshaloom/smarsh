// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../global/helpers/snacks.dart';
import '../../../../services/hive/models/local_product_model/local_product_model.dart';
import '../../../../services/hive/service/hive_constants.dart';
// import '../../../../global/utils/shared_classes.dart';
// import '../../../../services/cloud/cloud_product.dart';
import '../../../../services/cloud/cloud_storage_exceptions.dart';
import '../../../../services/cloud/cloud_storage_services.dart';
import '../../../../services/hive/service/hive_service.dart';

mixin ImportProcessedMixin {
  // Fetch file
  Future importProducts(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: const Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 10),
                Text('Importing data...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // clear product box
      await HiveTempProduct().deleteAllProducts();

      // pick file from device
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      // work with file
      if (result != null) {
        final File file = File(result.files.single.path!);
        final String csv = file.readAsStringSync();

        final listOne = csv.split('\n');
        listOne.removeWhere((element) => element.isEmpty);

        List listTwo = [];
        for (var element in listOne) {
          listTwo.add(element.split(','));
        }

        for (int i = 0; i < listTwo.length; i++) {
          final row = listTwo[i];

          final String productId = row[0].toString().trim();
          final String productName = row[1].toString().trim();
          final String retailPrice = row[2].toString().trim();
          final String wholesalePrice = row[3].toString().trim();
          final int stockCount = int.parse(row[4].toString().trim());


          final double r = double.parse(retailPrice);
          final double w = double.parse(wholesalePrice);

          final localProduct = LocalProduct(
            documentId: productId.toString(),
            productName: productName,
            retail: r,
            wholesale: w,
            lastCount: stockCount,
            todaysCount: 0,
          );

          await HiveTempProduct().addProduct(localProduct);

          if (i == listTwo.length - 1) {
            Navigator.of(context).pop();
            Snack().showSnackBar(
              context: context,
              message: 'Imported ${listTwo.length} products',
            );
          }
        }
      } else {
        Navigator.of(context).pop();
        Snack().showSnackBar(
          context: context,
          message: 'No file selected',
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      Snack().showSnackBar(
        context: context,
        message: 'Error importing products',
      );
      return;
    }
  }

  // String getProductId(List<CloudProduct> pr, String productName) {
  //   final CloudProduct cp = pr.firstWhere(
  //       (element) => element.productName.trim() == productName.trim(), orElse: () => CloudProduct(
  //         documentId: Processors.generateCode(10),
  //         productName: productName,
  //         buyingPrice: 0,
  //         sellingPrice: 0,
  //         stockCount: 0,
  //       ));

  //    return cp.documentId;
  // }

  // add products to cloud
  Stream<int> uploadingPr(
      List<LocalProduct> products, BuildContext context) async* {
    try {
      for (int i = 0; i < products.length; i++) {
        final LocalProduct product = products[i];
        await FirestoreProducts().createProduct(
          documentId: product.documentId,
          productName: product.productName,
          retailPrice: product.retail,
          wholesalePrice: product.wholesale,
          stockCount: product.lastCount,
        );

        // pop context on last iteration
        yield ((i / products.length) * 100).round();
      }
    } on CouldNotCreateException {
      Snack().showSnackBar(context: context, message: 'Could not syn to cloud');
    }
  }

  void confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear Imported Products'),
          content: const Text(
              'Are you sure you want to clear all imported products?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                HiveBoxes.getTempProductBox.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  // snack bar
  void pleaseClear(BuildContext context) {
    Snack().showSnackBar(
      context: context,
      message: 'Please clear imported products before importing new ones',
    );
  }

  // Stream<int> importingPr(BuildContext context) async* {
  //   try {
  //     List<LocalProduct> lproducts = GetMeFromHive.getAllTempProducts;

  //     for (var pr in lproducts) {
  //       await FirebaseCloudStorage().createProduct(
  //         documentId: pr.documentId,
  //         productName: pr.productName,
  //         buyingPrice: pr.buyingPrice,
  //         sellingPrice: pr.sellingPrice,
  //         stockCount: pr.stockCount,
  //       );

  //       yield ((lproducts.indexOf(pr) / lproducts.length) * 100).round();
  //     }
  //   } on CouldNotCreateException {
  //     Snack()
  //         .showSnackBar(context: context, message: 'Could not write to cloud');
  //   }
  // }
}
