import '../../../../services/hive/models/final_count_model/final_count_model.dart';
import '../../../../services/hive/models/local_product_model/local_product_model.dart';
import '../../../../services/hive/models/processed_stock_model/processed_stock.dart';
import '../../../../services/hive/service/hive_constants.dart';
import '../entities/cloud_nonposted.dart';

class NonPosted {
  NonPosted._();
  static final NonPosted _instance = NonPosted._();
  factory NonPosted() => _instance;

  List<CloudNonPost> get nonPostedItemsList => nonpostedItems();

  // Filter Getters
  List<CloudNonPost> get missingItems {
    List<CloudNonPost> missing = [];
    for (var e in nonpostedItems()) {
      if (e.nonPosted < 0) {
        missing.add(e);
      }
    }
    return missing;
  }

  List<CloudNonPost> get intactItems {
    List<CloudNonPost> intact = [];
    for (var e in nonpostedItems()) {
      if (e.nonPosted == 0) {
        intact.add(e);
      }
    }
    return intact;
  }

  List<CloudNonPost> get excessItems {
    List<CloudNonPost> excess = [];
    for (var e in nonpostedItems()) {
      if (e.nonPosted > 0) {
        excess.add(e);
      }
    }
    return excess;
  }

// return total non posted items
  double totalNonPosted(List<CloudNonPost> nonPost) {
    double total = 0;
    List<LocalProduct> stock = GetMeFromHive.getAllLocalProducts;
    for (var e in nonPost) {
      for (var element in stock) {
        if (element.documentId == e.id) {
          double t = element.retail * e.nonPosted;
          total += t;
        }
      }
    }
    return total;
  }

  // return a list of items with expected stock count
  // last stock - sales + purchases
  List<CloudNonPost> nonpostedItems() {
    List<LocalProduct> stock = GetMeFromHive.getAllLocalProducts;
    stock.sort((a, b) => a.productName.compareTo(b.productName));
    List<CloudNonPost> nonPostItems = [];

    if (stock.isEmpty) {
      return nonPostItems;
    }

    for (var e in stock) {
      // item id
      final String id = e.documentId;
      final String name = e.productName;
      // expected item count
      final int expectedCount = expectedStock(e);
      // const int expectedCount = 0;
      // recent item Count
      final int recentCount = finalCountModel(e.documentId);

      //item
      CloudNonPost i = CloudNonPost(
        id: id,
        name: name,
        expectedCount: expectedCount,
        recentCount: recentCount,
        sellingsPrice: e.wholesale,
      );

      nonPostItems.add(i);
    }
    nonPostItems.sort((a, b) => a.name.compareTo(b.name));
    return nonPostItems;
  }

  int expectedStock(LocalProduct e) {
    int expectedCount = 0;
    List<ProcessedData> temp = GetMeFromHive.getAllProcessedData;
    temp.sort((a, b) => a.productName.compareTo(b.productName));

    if (temp.isEmpty) {
      expectedCount = 403;
      return expectedCount;
    }

    final ProcessedData p =
        temp.firstWhere((element) => element.documentId == e.documentId,
            orElse: () => ProcessedData(
                  documentId: e.documentId,
                  productName: e.productName,
                  stockCount: 404,
                ));
    expectedCount = p.stockCount;
    return expectedCount;
  }

// get final count model by product id from hive
  int finalCountModel(String id) {
    int recentCount = 0;
    List<FinalCountModel> finalCount = GetMeFromHive.getAllFinalCounts;
    finalCount.sort((a, b) => a.productName.compareTo(b.productName));

    if (finalCount.isEmpty) {
      recentCount = 403;
      return recentCount;
    }

    final FinalCountModel f =
        finalCount.firstWhere((element) => element.productId == id,
            orElse: () => FinalCountModel(
                  date: DateTime.now(),
                  productName: '404',
                  productId: id,
                  count: 404,
                ));

    recentCount = f.count;

    return recentCount;
  }
}
