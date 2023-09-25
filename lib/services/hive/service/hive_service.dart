import 'package:hive/hive.dart';
import 'package:smarsh/constants/hive_constants.dart';

import '../models/final_count/final_count_model.dart';
import '../models/hive_object/hive_object_model.dart';
import '../models/item_count/item_count_model.dart';
import '../models/local_product/local_product_model.dart';

// NOTE: Hive Service of LocalProduct

class HiveLocalProductService {
  HiveLocalProductService._privateConstructor(this._productBox);
  static final HiveLocalProductService _instance =
      HiveLocalProductService._privateConstructor(HiveBoxes.getLocalProductBox);
  factory HiveLocalProductService() => _instance;

  final Box<LocalProduct> _productBox;
  //HiveLocalProductService(this._productBox);

  Future<List<LocalProduct>> getAllProducts() async {
    return _productBox.values.toList();
  }

  Future<void> addProduct(LocalProduct product) async {
    await _productBox.add(product);
  }

  Future<void> updateProduct(LocalProduct product) async {
    await _productBox.put(product.key, product);
  }

  Future<void> deleteProduct(LocalProduct product) async {
    await _productBox.delete(product.key);
  }

  Future<void> deleteAllProducts() async {
    await _productBox.clear();
  }
}

// NOTE: This is the same as the above class, but of ItemCountModel

class HiveItemCountService {
  HiveItemCountService._privateConstructor(this._itemCountBox);
  static final HiveItemCountService _instance =
      HiveItemCountService._privateConstructor(HiveBoxes.getItemCountBox());
  factory HiveItemCountService() => _instance;

  final Box<ItemCountModel> _itemCountBox;
  //HiveItemCountService(this._itemCountBox);

  Future<List<ItemCountModel>> getAllProducts() async {
    return _itemCountBox.values.toList();
  }

  Future<void> addProduct(ItemCountModel product) async {
    await _itemCountBox.add(product);
  }

  Future<void> updateProduct(ItemCountModel product) async {
    await _itemCountBox.put(product.key, product);
  }

  Future<void> deleteProduct(ItemCountModel product) async {
    await _itemCountBox.delete(product.key);
  }

  Future<void> deleteAllProducts() async {
    await _itemCountBox.clear();
  }
}


// NOTE: This is the same as the above class, but of finalCountModel

class HiveFinalCountService {
  HiveFinalCountService._privateConstructor(this._finalCountBox);
  static final HiveFinalCountService _instance =
      HiveFinalCountService._privateConstructor(HiveBoxes.getFinalCountBox());
  factory HiveFinalCountService() => _instance;

  final Box<FinalCountModel> _finalCountBox;
  //HiveFinalCountService(this._finalCountBox);

  Future<List<FinalCountModel>> getAllProducts() async {
    return _finalCountBox.values.toList();
  }

  Future<void> addProduct(FinalCountModel product) async {
    await _finalCountBox.add(product);
  }

  Future<void> updateProduct(FinalCountModel product) async {
    await _finalCountBox.put(product.key, product);
  }

  Future<void> deleteProduct(FinalCountModel product) async {
    await _finalCountBox.delete(product.key);
  }

  Future<void> deleteAllProducts() async {
    await _finalCountBox.clear();
  }
}


// NOTE: This is the same as the above class, but of HiveObjectModel

class HiveObjectService {
  HiveObjectService._privateConstructor(this._hiveObjBox);
  static final HiveObjectService _instance =
      HiveObjectService._privateConstructor(HiveBoxes.getHiveObjBox());
  factory HiveObjectService() => _instance;

  final Box<HiveObjectModel> _hiveObjBox;
  //HiveObjectService(this._hiveObjBox);

  Future<List<HiveObjectModel>> getAllProducts() async {
    return _hiveObjBox.values.toList();
  }

  Future<void> addProduct(HiveObjectModel product) async {
    await _hiveObjBox.add(product);
  }

  Future<void> updateProduct(HiveObjectModel product) async {
    await _hiveObjBox.put(product.key, product);
  }

  Future<void> deleteProduct(HiveObjectModel product) async {
    await _hiveObjBox.delete(product.key);
  }

  Future<void> deleteAllProducts() async {
    await _hiveObjBox.clear();
  }
}
