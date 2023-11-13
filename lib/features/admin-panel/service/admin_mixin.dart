import '../../../services/cloud/cloud_product.dart';
import '../../../services/cloud/firebase_cloud_storage.dart';
// import '../generated-non-posted/entities/cloud_nonposted.dart';
// import '../generated-non-posted/services/non_posted_service.dart';

mixin AdminMixin {
  Stream<int> resetingC() async* {
    // list of cloud products
    List<CloudProduct> cloudProducts =
        await FirebaseCloudStorage().getAllStock();

    for (int i = 0; i < cloudProducts.length; i++) {
      final CloudProduct c = cloudProducts[i];

      await FirebaseCloudStorage().resetCount(documentId: c.documentId);

      yield ((i / cloudProducts.length) * 100).round();
    }
  }

  Stream<int> updatingS() async* {
    // list of cloud products
    List<CloudProduct> cloudProducts =
        await FirebaseCloudStorage().getAllStock();
    cloudProducts.sort((a, b) => a.productName.compareTo(b.productName));

    /* List<CloudNonPost> cloudNonPosted =
        await AdminNonPostRemoteDataSrc().getAllNonPosted();
    cloudNonPosted.sort((a, b) => a.name.compareTo(b.name));

    if (cloudProducts.length != cloudNonPosted.length) {
      throw Exception('Cloud Products and Non Posted Products are not equal');
    }

    if (cloudProducts.isEmpty || cloudNonPosted.isEmpty) {
      throw Exception('Cloud Products is empty');
    }

    for (int i = 0; i < cloudProducts.length; i++) {
      final CloudProduct c = cloudProducts[i];
      final CloudNonPost f =
          cloudNonPosted.firstWhere((element) => element.id == c.documentId,
              orElse: () => CloudNonPost(
                    id: 'id',
                    name: 'name',
                    expectedCount: 404,
                    recentCount: 404,
                    sellingsPrice: 0,
                  ));

      await FirebaseCloudStorage().updateProductStockCount(
          documentId: c.documentId, stockCount: f.recentCount);

      yield ((i / cloudProducts.length) * 100).round();
    }*/

    for (int i = 0; i < cloudProducts.length; i++) {
      final CloudProduct c = cloudProducts[i];
      final int count = _getCount(c.count.cast<int>().toList());

      await FirebaseCloudStorage()
          .updateProductStockCount(documentId: c.documentId, stockCount: count);

      yield ((i / cloudProducts.length) * 100).round();
    }
  }

  int _getCount(List<int> counts) {
    if (counts.isEmpty) {
      return 0;
    }
    // add all integers in the list
    int count =
        counts.fold(0, (previousValue, element) => previousValue + element);
    return count;
  }
}
