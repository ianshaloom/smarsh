import '../../../services/cloud/cloud_entities.dart';
import '../../../services/cloud/cloud_storage_services.dart';
// import '../generated-non-posted/entities/cloud_nonposted.dart';
// import '../generated-non-posted/services/non_posted_service.dart';

mixin AdminMixin {
  Stream<int> resetingC() async* {
    // list of cloud products
    List<CloudProduct> cloudProducts = await FirestoreProducts().getAllStock();

    for (int i = 0; i < cloudProducts.length; i++) {
      final CloudProduct c = cloudProducts[i];

      await FirestoreProducts().resetCount(documentId: c.documentId);

      yield ((i / cloudProducts.length) * 100).round();
    }
  }

  Stream<int> updatingS() async* {
    // list of cloud products
    List<CloudProduct> cloudProducts = await FirestoreProducts().getAllStock();
    cloudProducts.sort((a, b) => a.productName.compareTo(b.productName));
    for (int i = 0; i < cloudProducts.length; i++) {
      final CloudProduct c = cloudProducts[i];

      await FirestoreProducts().updateProductStockCount(
          documentId: c.documentId, stockCount: c.totalCount);

      yield ((i / cloudProducts.length) * 100).round();
    }
  }
}
