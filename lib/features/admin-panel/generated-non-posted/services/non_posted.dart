import '../../../../constants/hive_constants.dart';
import '../../../../services/hive/models/final_count/final_count_model.dart';
import '../../../../services/hive/models/local_product/local_product_model.dart';
import '../entities/non_post_item.dart';

class NonPosted {
  NonPosted._();
  static final NonPosted _instance = NonPosted._();
  factory NonPosted() => _instance;

  List<Item> get nonPostedItemsList => nonpostedItems();

  // Filter Getters
  List<Item> get missingItems {
    List<Item> missing = [];
    for (var e in nonpostedItems()) {
      if (e.nonPosted < 0) {
        missing.add(e);
      }
    }
    return missing;
  }

  List<Item> get intactItems {
    List<Item> intact = [];
    for (var e in nonpostedItems()) {
      if (e.nonPosted == 0) {
        intact.add(e);
      }
    }
    return intact;
  }

  List<Item> get excessItems {
    List<Item> excess = [];
    for (var e in nonpostedItems()) {
      if (e.nonPosted > 0) {
        excess.add(e);
      }
    }
    return excess;
  }

// return total non posted items
  double totalNonPosted(List<Item> nonPost) {
    double total = 0;
    List<LocalProduct> stock = GetMeFromHive.getAllLocalProducts;
    for (var e in nonPost) {
      for (var element in stock) {
        if (element.documentId == e.id) {
          double t = element.buyingPrice * e.nonPosted;
          total += t;
        }
      }
    }
    return total;
  }

  // return a list of items with expected stock count
  // last stock - sales + purchases
  List<Item> nonpostedItems() {
    List<LocalProduct> stock = GetMeFromHive.getAllLocalProducts;
    List<Item> nonPostItems = [];

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
      Item i = Item(
        id,
        name,
        expectedCount,
        recentCount,
      );

      nonPostItems.add(i);
    }
    nonPostItems.sort((a, b) => a.name.compareTo(b.name));
    return nonPostItems;
  }

  int expectedStock(LocalProduct e) {
    int expectedCount = 0;
    List<LocalProduct> temp = GetMeFromHive.getAllTempProducts;
    final LocalProduct p =
        temp.firstWhere((element) => element.documentId == e.documentId);
    expectedCount = p.stockCount;

    return expectedCount;
  }

// get final count model by product id from hive
  int finalCountModel(String id) {
    int recentCount = 0;
    List<FinalCountModel> finalCount = GetMeFromHive.getAllFinalCounts;

    final FinalCountModel f =
        finalCount.firstWhere((element) => element.productId == id);

    recentCount = f.count;

    return recentCount;
  }
}
