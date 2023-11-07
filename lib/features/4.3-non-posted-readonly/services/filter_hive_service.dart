import 'package:hive_flutter/hive_flutter.dart';

import '../../../services/hive/models/filter_model/filter_model.dart';
import '../../../services/hive/service/hive_constants.dart';

class FilterService {
  FilterService._privateConstructor(this._itemCountBox);
  static final FilterService _instance =
      FilterService._privateConstructor(HiveBoxes.getFilterBox());
  factory FilterService() => _instance;

  final Box<FilterModel> _itemCountBox;
  //HiveItemCountService(this._itemCountBox);

  Future<List<FilterModel>> getAllProducts() async {
    return _itemCountBox.values.toList();
  }

  Future<void> addProduct(FilterModel product) async {
    await _itemCountBox.add(product);
  }

  Future<void> updateProduct(FilterModel product) async {
    await _itemCountBox.put(product.key, product);
  }

  Future<void> deleteProduct(FilterModel product) async {
    await _itemCountBox.delete(product.key);
  }

  Future<void> deleteAllProducts() async {
    await _itemCountBox.clear();
  }
}
