
import 'package:hive_flutter/hive_flutter.dart';

import '../services/hive/models/final_count/final_count_model.dart';
import '../services/hive/models/hive_object/hive_object_model.dart';
import '../services/hive/models/item_count/item_count_model.dart';
import '../services/hive/models/local_product/local_product_model.dart';

const String localProduct = 'local-product-box';
const String itemCount = 'item-count-box';
const String finalCount = 'final-count-box';
const String hiveObj = 'hive-obj-box';


// Hive Boxes

class HiveBoxes {
  static Box<LocalProduct> get getLocalProductBox => Hive.box<LocalProduct>(localProduct);
  static Box<ItemCountModel> getItemCountBox() => Hive.box<ItemCountModel>(itemCount);
  static Box<FinalCountModel> getFinalCountBox() => Hive.box<FinalCountModel>(finalCount);
  static Box<HiveObjectModel> getHiveObjBox() => Hive.box<HiveObjectModel>(hiveObj);
}

class GetMeFromHive {
  static List<LocalProduct> get getAllLocalProducts => HiveBoxes.getLocalProductBox.values.toList();
  static List<ItemCountModel> get getAllItemCounts => HiveBoxes.getItemCountBox().values.toList();
  static List<FinalCountModel> get getAllFinalCounts => HiveBoxes.getFinalCountBox().values.toList();
  static List<HiveObjectModel> get getAllHiveObjects => HiveBoxes.getHiveObjBox().values.toList();
}
