import 'package:flutter/widgets.dart';

import '../../../services/hive/models/local_product_model/local_product_model.dart';
import '../../../services/hive/service/hive_constants.dart';
import '../../../global/helpers/snacks.dart';
import '../../../services/cloud/cloud_entities.dart';
import '../../../services/cloud/cloud_storage_services.dart';
import '../../../services/hive/service/hive_service.dart';

class NonPostLocalDataSrcRd {
  // factory constructor
  NonPostLocalDataSrcRd._();
  static final instance = NonPostLocalDataSrcRd._();
  factory NonPostLocalDataSrcRd() => instance;

  // Get all products from local data source
  Future<List<LocalProduct>> getProducts(
      BuildContext context, bool refresh) async {
    try {
      List<LocalProduct> products = [];
      //
      if (GetMeFromHive.getAllLocalProducts.isEmpty && !refresh) {
        List<CloudProduct> cproducts = [];
        List<LocalProduct> lproducts = [];
        cproducts = await FirestoreProducts().getAllStock();

        for (var pr in cproducts) {
          final localProduct = LocalProduct(
            productName: pr.productName,
            retail: pr.buyingPrice,
            wholesale: pr.sellingPrice,
            lastCount: pr.stockCount,
            documentId: pr.documentId,
            todaysCount: pr.totalCount,
          );

          lproducts.add(localProduct);
          await HiveLocalProduct().addProduct(localProduct);
        }

        products = lproducts;
        // sort products by name
        lproducts.sort((a, b) => a.productName.compareTo(b.productName));
        return lproducts;
      } else if (refresh) {
        //clear hive
        await HiveLocalProduct().deleteAllProducts();

        List<CloudProduct> cproducts = [];
        List<LocalProduct> lproducts = [];
        cproducts = await FirestoreProducts().getAllStock();

        for (var pr in cproducts) {
          final localProduct = LocalProduct(
            productName: pr.productName,
            retail: pr.buyingPrice,
            wholesale: pr.sellingPrice,
            lastCount: pr.stockCount,
            documentId: pr.documentId,
            todaysCount: pr.totalCount,
          );

          lproducts.add(localProduct);
          await HiveLocalProduct().addProduct(localProduct);
        }

        products = lproducts;
        // sort products by name
        lproducts.sort((a, b) => a.productName.compareTo(b.productName));
        return lproducts;
      } else {
        products = GetMeFromHive.getAllLocalProducts;
        // sort products by name
        products.sort((a, b) => a.productName.compareTo(b.productName));
        return products;
      }
    } on Exception catch (_) {
      Snack().showSnackBar(
          context: context, message: 'Failed to Fetch Stock List');
      return [];
    }
  }

  
}
