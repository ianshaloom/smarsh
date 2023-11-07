import '../../../services/cloud/cloud_product.dart';
import '../../../services/cloud/firebase_cloud_storage.dart';
import '../../../services/hive/models/local_product_model/local_product_model.dart';
import '../../../services/hive/service/hive_service.dart';

mixin StockListMixin {
// Refresh Local data source for Localproduct
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
/* -------------------------------------------------------------------------- */
}
