import 'package:hive/hive.dart';

import '../models/filter_model/filter_model.dart';
import '../models/final_count_model/final_count_model.dart';
import '../models/local_product_model/local_product_model.dart';
import '../models/processed_stock_model/processed_stock.dart';
import '../models/show_home_model/show_home.dart';
import 'hive_constants.dart';


class HiveService {
  // register all adapters here
  static Future<void> registerAdapters() async {
    Hive.registerAdapter(LocalProductAdapter());
    Hive.registerAdapter(FinalCountModelAdapter());
    Hive.registerAdapter(ShowOnboardAdapter());
    Hive.registerAdapter(FilterModelAdapter());
    Hive.registerAdapter(ProcessedDataAdapter());

  }

  static Future<void> initFlutter([String? subDir]) async {
    Hive.init(subDir);

    await Hive.openBox<LocalProduct>(localProduct, path: subDir);
    await Hive.openBox<LocalProduct>(tempProduct, path: subDir);

    // final stock count
    await Hive.openBox<FinalCountModel>(finalCount, path: subDir);
    // filters non posted
    await Hive.openBox<FilterModel>(filter, path: subDir);
    // show home
    await Hive.openBox<ShowOnboard>(showOnboard, path: subDir);
    // processed data
    await Hive.openBox<ProcessedData>(processedData, path: subDir);
  }
}
// NOTE: Hive Service of LocalProduct

class HiveLocalProduct {
  HiveLocalProduct._privateConstructor(this._productBox);
  static final HiveLocalProduct _instance =
      HiveLocalProduct._privateConstructor(HiveBoxes.getLocalProductBox);
  factory HiveLocalProduct() => _instance;

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

// NOTE: Hive Service of LocalProduct

class HiveTempProduct {
  HiveTempProduct._privateConstructor(this._productBox);
  static final HiveTempProduct _instance =
      HiveTempProduct._privateConstructor(HiveBoxes.getTempProductBox);
  factory HiveTempProduct() => _instance;

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

// NOTE: This is the same as the above class, but of finalCountModel

class HiveFinalCount {
  HiveFinalCount._privateConstructor(this._finalCountBox);
  static final HiveFinalCount _instance =
      HiveFinalCount._privateConstructor(HiveBoxes.getFinalCountBox());
  factory HiveFinalCount() => _instance;

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

// NOTE: This is the same as the above class, but of ShowHome

class HiveShowHome {
  HiveShowHome._(this._showHomeBox);
  static final HiveShowHome _instance =
      HiveShowHome._(HiveBoxes.getShowOnboardBox);
  factory HiveShowHome() => _instance;

  final Box<ShowOnboard> _showHomeBox;

  // add show home
  Future<void> addShowHome(ShowOnboard showHome) async {
    await _showHomeBox.add(showHome);
  }

  Future<bool> getShowHome() async {
    final showHome = _showHomeBox.values.toList();
    if (showHome.isEmpty) {
      return true;
    } else {
      return false;
    }
  } 
}

// NOTE: This is the same as the above class, but of ProcessedData

class HiveProcessedData{
  HiveProcessedData._(this._processedDataBox);
  static final HiveProcessedData _instance =
      HiveProcessedData._(HiveBoxes.getProcessedDataBox);
  factory HiveProcessedData() => _instance;

  final Box<ProcessedData> _processedDataBox;

  // add processed data
  Future<void> addProcessedData(ProcessedData processedData) async {
    await _processedDataBox.add(processedData);
  }

  // delete all processed data
  Future<void> deleteAllProcessedData() async {
    await _processedDataBox.clear();
  }

}