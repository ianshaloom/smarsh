import 'package:smarsh/services/cloud/cloud_storage_exceptions.dart';
import 'package:smarsh/services/cloud/firebase_cloud_storage.dart';
import 'package:smarsh/services/hive/service/hive_service.dart';

import '../../../../constants/hive_constants.dart';
import '../../../../services/cloud/cloud_product.dart';
import '../../../../services/hive/models/local_product/local_product_model.dart';
import '../../../4.3-non-posted-readonly/entities/cloud_nonposted.dart';
import '../entities/non_post_item.dart';
import 'non_posted_service.dart';

mixin NonPostedMixin {
  final List<LocalProduct> stock = GetMeFromHive.getAllLocalProducts;

  double totalNonPosted(List<CloudNonPosted> non) {
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
    await HiveLocalProductService().deleteAllProducts();

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

      await HiveLocalProductService().addProduct(localProduct);

      yield (cloudProducts.indexOf(e) / cloudProducts.length * 100).round();
    }
  }

  Stream<int> uploadingNp(List<Item> items) async* {
    try {
      for (int i = 0; i < items.length; i++) {
        final Item item = items[i];
        await AdminNonPostRemoteDataSrc().createNonPosted(
          id: item.id,
          name: item.name,
          expectedCount: item.expectedCount,
          recentCount: item.recentCount,
        );

        yield (i / items.length * 100).round();
      }
    } on CouldNotCreateException {
      return;
    }
  }
}
