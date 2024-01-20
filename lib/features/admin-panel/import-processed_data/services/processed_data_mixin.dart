// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';

import '../../../../global/helpers/snacks.dart';
import '../../../../global/utils/shared_classes.dart';
import '../../../../services/cloud/cloud_storage_exceptions.dart';
import '../../../../services/cloud/cloud_storage_services.dart';
import '../../../../services/hive/models/local_product_model/local_product_model.dart';
import '../../../../services/hive/models/processed_stock_model/processed_stock.dart';
import '../../../../services/hive/service/hive_constants.dart';
import '../../../../services/hive/service/hive_service.dart';
import '../widgets/clear_processed_progress.dart';
import '../widgets/upload_product_progress.dart';

mixin ProcessedDataMixin {
  Stream<int> uploadingProcessed(BuildContext context) async* {
    try {
      List<ProcessedData> imported = GetMeFromHive.getAllProcessedData;

      for (int i = 0; i < imported.length; i++) {
        final ProcessedData p = imported[i];

        await FirestoreProcessed().createProcessed(
          documentId: p.documentId,
          productName: p.productName,
          expectedCount: p.stockCount,
        );

        yield ((i / imported.length) * 100).round();
      }
    } on CouldNotCreateException {
      Snack().showSnackBar(context: context, message: 'Could not syn to cloud');
    }
  }

  Stream<int> clearingProcessed(BuildContext context) async* {
    List<ProcessedData> imported = GetMeFromHive.getAllProcessedData;
    try {
      for (int i = 0; i < imported.length; i++) {
        final ProcessedData p = imported[i];
        await FirestoreProcessed().deleteProcessed(documentId: p.documentId);

        // pop context on last iteration
        yield ((i / imported.length) * 100).round();
      }
    } on CouldNotDeleteException {
      Snack().showSnackBar(
          context: context, message: 'Could not delete from cloud');
    }
  }

  String getProductId(List<LocalProduct> pr, String productName) {
    final LocalProduct cp = pr.firstWhere(
        (element) => element.productName.trim() == productName.trim(),
        orElse: () => LocalProduct(
              documentId: '${Processors.generateCode(3)}-new',
              productName: productName,
              wholesale: 0,
              retail: 0,
              todaysCount: 0,
              lastCount: 0,
            ));

    return cp.documentId;
  }

  // return bool if ProcessedData id contains 'new'
  bool isNew(String id) {
    return id.contains('new');
  }

  Future<void> clearProcessed(BuildContext context) async {
    try {
      if (HiveBoxes.getProcessedDataBox.isEmpty) return;

      await HiveProcessedData().deleteAllProcessedData();
    } on CouldNotDeleteException {
      Snack().showSnackBar(
          context: context, message: 'Could not delete from cloud');
    }
  }

  // snack bar
  void importPr(BuildContext context) async {
    List<LocalProduct> newProducts = await HiveLocalProduct().getAllProducts();

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      // work with file
      if (result != null) {
        File file = File(result.files.single.path!);
        String csv = file.readAsStringSync();

        var listOne = csv.split('\n');
        listOne.removeWhere((element) => element.isEmpty);

        List listTwo = [];
        for (var element in listOne) {
          listTwo.add(element.split(','));
        }

        for (int i = 0; i < listTwo.length; i++) {
          var row = listTwo[i];

          final String productName = row[0].toString().trim();
          final int expectedCount = int.parse(row[1].toString().trim());

          final localProduct = ProcessedData(
            documentId: getProductId(newProducts, productName),
            productName: productName,
            stockCount: expectedCount,
          );

          await HiveProcessedData().addProcessedData(localProduct);

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
      Snack().showSnackBar(
        context: context,
        message: e.toString(),
      );
    }
  }

  void confirmClear(BuildContext cxt) async {
    final bool confirm = await showDialog(
      context: cxt,
      builder: (context) => AlertDialog(
        title: const Text('Clear Processed'),
        content: const Text(
            'Are you sure you want to clear the cloud processed data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirm) {
      // reset stock-take
      showDialog(
        barrierColor: Colors.black38,
        context: cxt,
        barrierDismissible: false,
        builder: (_) => const ClearProcessedProgress(),
        // builder: (_) => const Center(),
      );
    }
  }

  void confirmUpload(BuildContext cxt) async {
    final bool confirm = await showDialog(
      context: cxt,
      builder: (context) => AlertDialog(
        title: const Text('Upload Processed'),
        content:
            const Text('Are you sure you want to upload cloud processed data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Upload'),
          ),
        ],
      ),
    );

    if (confirm) {
      // reset stock-take
      showDialog(
        barrierColor: Colors.black38,
        context: cxt,
        barrierDismissible: false,
        builder: (_) => const ProcessedUploadProgress(),
        // builder: (_) => const Center(),
      );
    }
  }
}
