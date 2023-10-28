import '../../../services/cloud/cloud_product.dart';
import '../../../services/cloud/firebase_cloud_storage.dart';

mixin AdminMixin{

  Stream<int> resetingC() async* {
    // list of cloud products
    List<CloudProduct> cloudProducts = await FirebaseCloudStorage().getAllStock();

    for (int i = 0; i < cloudProducts.length; i++) {
      final CloudProduct c = cloudProducts[i];

      await FirebaseCloudStorage().resetCount(documentId: c.documentId);

      yield ((i / cloudProducts.length) * 100).round();
    }
    

  }
}