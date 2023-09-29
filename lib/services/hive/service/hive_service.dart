import 'package:hive/hive.dart';

import '../../../constants/hive_constants.dart';
import '../models/final_count/final_count_model.dart';
import '../models/hive_object/hive_object_model.dart';
import '../models/item_count/item_count_model.dart';
import '../models/local_product/local_product_model.dart';
import '../models/purchases_item/purchases_item_model.dart';
import '../models/sales_item/sales_item_model.dart';
import '../models/user_model/user_model.dart';

class HiveService {
  // register all adapters here
  static Future<void> registerAdapters() async {
    Hive.registerAdapter(LocalProductAdapter());
    Hive.registerAdapter(ItemCountModelAdapter());
    Hive.registerAdapter(FinalCountModelAdapter());
    Hive.registerAdapter(SalesModelAdapter());
    Hive.registerAdapter(PurchasesModelAdapter());
    Hive.registerAdapter(HiveObjectModelAdapter());
    Hive.registerAdapter(HiveUserAdapter());
  }

  static Future<void> initFlutter([String? subDir]) async {
    Hive.init(subDir);

    await Hive.openBox<LocalProduct>(localProduct, path: subDir);
    await Hive.openBox<ItemCountModel>(itemCount, path: subDir);
    await Hive.openBox<FinalCountModel>(finalCount, path: subDir);
    await Hive.openBox<SalesModel>(sales, path: subDir);
    await Hive.openBox<PurchasesModel>(purchases, path: subDir);
    await Hive.openBox<HiveObjectModel>(hiveObj, path: subDir);
    await Hive.openBox<HiveUser>(userBox, path: subDir);
  }
}
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

// NOTE: This is the same as the above class, but of HiveUser

class HiveUserService {
  HiveUserService._privateConstructor(this._hiveUserBox);
  static final HiveUserService _instance =
      HiveUserService._privateConstructor(HiveBoxes.getHiveUserBox());
  factory HiveUserService() => _instance;

  final Box<HiveUser> _hiveUserBox;

  Future<HiveUser> getUser(String id) async {
    return _hiveUserBox.values
        .where((element) => element.uid == id)
        .toList()
        .first;
  }

  Future<void> addUser(HiveUser user) async {
    await _hiveUserBox.add(user);
  }

  Future<void> updateUser(HiveUser user) async {
    if (_hiveUserBox.containsKey(user.key)) {
      await _hiveUserBox.put(user.key, user);
    } else {
      print('User not found in the box.');
    }
  }

  Future<void> deleteUser(HiveUser user) async {
    await _hiveUserBox.delete(user.key);
  }

  Future<void> deleteAllUsers() async {
    await _hiveUserBox.clear();
  }
}

// NOTE: This is the same as the above class, but of SalesModel

class SalesModelService {
  SalesModelService._privateConstructor(this._salesModelBox);
  static final SalesModelService _instance =
      SalesModelService._privateConstructor(HiveBoxes.getSalesBox());
  factory SalesModelService() => _instance;

  final Box<SalesModel> _salesModelBox;

  Future<List<SalesModel>> getAllSales() async {
    return _salesModelBox.values.toList();
  }

  Future<void> addSale(SalesModel sale) async {
    await _salesModelBox.add(sale);
  }

  Future<void> updateSale(SalesModel sale) async {
    await _salesModelBox.put(sale.key, sale);
  }

  Future<void> deleteSale(SalesModel sale) async {
    await _salesModelBox.delete(sale.key);
  }

  Future<void> deleteAllSales() async {
    await _salesModelBox.clear();
  }
}

// NOTE: This is the same as the above class, but of PurchasesModel

class PurchasesModelService {
  PurchasesModelService._privateConstructor(this._purchasesModelBox);
  static final PurchasesModelService _instance =
      PurchasesModelService._privateConstructor(HiveBoxes.getPurchasesBox());
  factory PurchasesModelService() => _instance;

  final Box<PurchasesModel> _purchasesModelBox;

  Future<List<PurchasesModel>> getAllPurchases() async {
    return _purchasesModelBox.values.toList();
  }

  Future<void> addPurchase(PurchasesModel purchase) async {
    await _purchasesModelBox.add(purchase);
  }

  Future<void> updatePurchase(PurchasesModel purchase) async {
    await _purchasesModelBox.put(purchase.key, purchase);
  }

  Future<void> deletePurchase(PurchasesModel purchase) async {
    await _purchasesModelBox.delete(purchase.key);
  }

  Future<void> deleteAllPurchases() async {
    await _purchasesModelBox.clear();
  }
}