import 'package:flutter/material.dart';

import '../../../../services/cloud/cloud_entities.dart';
import '../../../../services/cloud/cloud_storage_exceptions.dart';
import '../../../../services/cloud/cloud_storage_services.dart';

mixin NewProductMixin {
  final FirestoreProducts _cloudStorage = FirestoreProducts();

  Future<CloudProduct> createProduct(
      CloudProduct product, BuildContext cxt) async {
    // save product to cloud
    try {
      showDialog(
        context: cxt,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop:  false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 75,
                width: 75,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Adding to cloud...',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
              ),
            ],
          ),
        ),
      );

      CloudProduct created = await _cloudStorage.createProduct(
        documentId: product.documentId,
        productName: product.productName,
        retailPrice: product.buyingPrice,
        wholesalePrice: product.sellingPrice,
        stockCount: product.stockCount,
      );

      return created;
    } catch (e) {
      throw CouldNotCreateException();
    }
  }
}
