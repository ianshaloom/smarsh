import 'package:hive_flutter/hive_flutter.dart';

import '../services/hive/models/final_count/final_count_model.dart';
import '../services/hive/models/hive_object/hive_object_model.dart';
import '../services/hive/models/item_count/filter_model.dart';
import '../services/hive/models/local_product/local_product_model.dart';
import '../services/hive/models/purchases_item/purchases_item_model.dart';
import '../services/hive/models/sales_item/sales_item_model.dart';
import '../services/hive/models/user_model/user_model.dart';

const String localProduct = 'local-product-box';
const String tempProduct = 'temp-product-box';
const String filter = 'filter-non-posted';
const String finalCount = 'final-count-box';
const String sales = 'sales-box';
const String purchases = 'purchases-box';
const String hiveObj = 'hive-obj-box';
const String userBox = 'user-box';

// Hive Boxes

class HiveBoxes {
  static Box<LocalProduct> get getLocalProductBox =>
      Hive.box<LocalProduct>(localProduct);
  static Box<LocalProduct> get getTempProductBox =>
      Hive.box<LocalProduct>(tempProduct);

  static Box<FilterModel> getFilterBox() => Hive.box<FilterModel>(filter);
  static Box<FinalCountModel> getFinalCountBox() =>
      Hive.box<FinalCountModel>(finalCount);
  static Box<HiveObjectModel> getHiveObjBox() =>
      Hive.box<HiveObjectModel>(hiveObj);
  static Box<SalesModel> getSalesBox() => Hive.box<SalesModel>(sales);
  static Box<PurchasesModel> getPurchasesBox() =>
      Hive.box<PurchasesModel>(purchases);
  static Box<HiveUser> getHiveUserBox() => Hive.box<HiveUser>(userBox);
}

class GetMeFromHive {
  static List<LocalProduct> get getAllLocalProducts {
    // return empty list if box is empty
    if (HiveBoxes.getLocalProductBox.isEmpty) {
      return [];
    } else {
      return HiveBoxes.getLocalProductBox.values.toList();
    }
  }

  static List<LocalProduct> get getAllTempProducts =>
      HiveBoxes.getTempProductBox.values.toList();

  static List<FilterModel> get getAllItemCounts =>
      HiveBoxes.getFilterBox().values.toList();
  static List<FinalCountModel> get getAllFinalCounts =>
      HiveBoxes.getFinalCountBox().values.toList();
  static List<HiveObjectModel> get getAllHiveObjects =>
      HiveBoxes.getHiveObjBox().values.toList();
  static List<SalesModel> get getAllSales =>
      HiveBoxes.getSalesBox().values.toList();
  static List<PurchasesModel> get getAllPurchases =>
      HiveBoxes.getPurchasesBox().values.toList();

  static HiveUser? get getHiveUser => HiveBoxes.getHiveUserBox().getAt(0);
}

//SECTION - Hive Object Model Constants

const String updateLocalStock =
    'if true, fetch data from cloud and update local data';
const String profilePhotoUrl =
    'https://ianshaloom.github.io/assets/img/male-avatar.png';
// !SECTION - Hive Object Model Constants