import '../../../constants/hive_constants.dart';
import '../../../services/cloud/cloud_product.dart';
import '../../../services/cloud/firebase_cloud_storage.dart';
import '../../../services/hive/models/local_product/local_product_model.dart';
import '../../../services/hive/service/hive_service.dart';

mixin StockListMixin{
// Get all products from local data source
   Future<List<LocalProduct>> getProducts() async {
    List<LocalProduct> products = [];
    //
    if (GetMeFromHive.getAllLocalProducts.isEmpty) {
      List<CloudProduct> cproducts = [];
      List<LocalProduct> lproducts = [];
      cproducts = await FirebaseCloudStorage().getAllStock();

      for (var pr in cproducts) {
        final localProduct = LocalProduct(
          productName: pr.productName,
          buyingPrice: pr.buyingPrice,
          sellingPrice: pr.sellingPrice,
          stockCount: pr.stockCount,
          documentId: pr.documentId,
        );

        lproducts.add(localProduct);
        await HiveLocalProductService().addProduct(localProduct);
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
  }
/* -------------------------------------------------------------------------- */
// Refresh Local data source for Localproduct
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
/* -------------------------------------------------------------------------- */
}