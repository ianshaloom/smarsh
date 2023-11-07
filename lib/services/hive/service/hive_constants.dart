import 'package:hive_flutter/hive_flutter.dart';

import '../models/filter_model/filter_model.dart';
import '../models/final_count_model/final_count_model.dart';
import '../models/local_product_model/local_product_model.dart';
import '../models/processed_stock_model/processed_stock.dart';
import '../models/show_home_model/show_home.dart';

const String localProduct = 'local-product-box';
const String tempProduct = 'temp-product-box';
/* -------------------------------------------------------------------------- */
const String finalCount = 'final-count-box';
const String processedData = 'processed-data-box';
const String userBox = 'user-box';
/* -------------------------------------------------------------------------- */
const String showOnboard = 'show-onboard-box';
const String filter = 'filter-non-posted';

// Hive Boxes

class HiveBoxes {
  static Box<LocalProduct> get getLocalProductBox =>
      Hive.box<LocalProduct>(localProduct);
  static Box<LocalProduct> get getTempProductBox =>
      Hive.box<LocalProduct>(tempProduct);
  static Box<ProcessedData> get getProcessedDataBox =>
      Hive.box<ProcessedData>(processedData);

  static Box<FilterModel> getFilterBox() => Hive.box<FilterModel>(filter);
  static Box<ShowOnboard> get getShowOnboardBox =>
      Hive.box<ShowOnboard>(showOnboard);
  //
  static Box<FinalCountModel> getFinalCountBox() =>
      Hive.box<FinalCountModel>(finalCount);
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

  static List<ProcessedData> get getAllProcessedData =>
      HiveBoxes.getProcessedDataBox.values.toList();

  static ShowOnboard get getShowOnboard =>
      HiveBoxes.getShowOnboardBox.values.toList().first;

  static List<FilterModel> get getAllItemCounts =>
      HiveBoxes.getFilterBox().values.toList();
  static List<FinalCountModel> get getAllFinalCounts =>
      HiveBoxes.getFinalCountBox().values.toList();
}

const String profilePhotoUrl =
    'https://ianshaloom.github.io/assets/img/male-avatar.png';
