// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../global/helpers/snacks.dart';
import '../../../../services/hive/models/processed_stock_model/processed_stock.dart';
import '../../../../global/utils/shared_classes.dart';
import '../../../../services/cloud/cloud_product.dart';
import '../../../../services/hive/service/hive_service.dart';

mixin ProcessedDataMixin {
  // Fetch file
  Stream<int> importingPr(
      List<CloudProduct> products, BuildContext context) async* {
    try {
      // clear product box
      await HiveProcessedData().deleteAllProcessedData();

      // pick file from device
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      // work with file
      if (result != null) {
        File file = File(result.files.single.path!);
        String csv = file.readAsStringSync();

        var listOne = csv.split('\n');
        listOne.removeLast();

        List listTwo = [];
        for (var element in listOne) {
          listTwo.add(element.split(','));
        }

        for (int i = 0; i < listTwo.length; i++) {
          var row = listTwo[i];

          final String productName = row[0].toString().trim();
          final int stockCount = int.parse(row[1].toString().trim());

          final localProduct = ProcessedData(
            documentId: getProductId(products, productName),
            productName: productName,
            stockCount: stockCount,
          );

          await HiveProcessedData().addProcessedData(localProduct);
          yield ((i / listTwo.length) * 100).round();

          if (i == listTwo.length - 1) {
            Snack().showSnackBar(
              context: context,
              message: 'Imported ${listTwo.length} Items',
            );
          }
        }
      } else {
        Snack().showSnackBar(
          context: context,
          message: 'No file selected',
        );
      }
    } catch (e) {
      //
    }
  }

  String getProductId(List<CloudProduct> pr, String productName) {
    final CloudProduct cp = pr.firstWhere(
        (element) => element.productName.trim() == productName.trim(),
        orElse: () => CloudProduct(
              documentId: '${Processors.generateCode(10)}-new',
              productName: productName,
              buyingPrice: 0,
              sellingPrice: 0,
              stockCount: 0,
            ));

    return cp.documentId;
  }

  // return bool if ProcessedData id contains 'new'
  bool isNew(String id) {
    return id.contains('new');
  }

  // add products to cloud
  // Stream<int> uploadingPr(
  //     List<LocalProduct> products, BuildContext context) async* {
  //   try {
  //     for (int i = 0; i < products.length; i++) {
  //       final LocalProduct product = products[i];
  //       await FirebaseCloudStorage().createProduct(
  //         documentId: product.documentId,
  //         productName: product.productName,
  //         buyingPrice: product.buyingPrice,
  //         sellingPrice: product.sellingPrice,
  //         stockCount: product.stockCount,
  //       );

  //       // pop context on last iteration
  //       yield ((i / products.length) * 100).round();
  //     }
  //   } on CouldNotCreateException {
  //     Snack().showSnackBar(context: context, message: 'Could not syn to cloud');
  //   }
  // }

  Future confirmClearProcessed(BuildContext context) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Processed Data'),
        content: const Text(
          'Are you sure you want to clear all processed data?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await HiveProcessedData().deleteAllProcessedData();
    }
  }

  // snack bar
  void pleaseClear(BuildContext context) {
    Snack().showSnackBar(
      context: context,
      message: 'Please clear imported data before importing new data',
    );
  }
}
