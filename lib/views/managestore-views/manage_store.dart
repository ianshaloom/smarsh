// SECTION: Manage Product Page
/* -------------------------------------------------------------------------- */
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smarsh/services/hive/models/local_product/local_product_model.dart';
import 'package:smarsh/services/hive/service/hive_service.dart';
import 'package:smarsh/utils/shared_classes.dart';

import '../../services/cloud/cloud_product.dart';
import '../../services/cloud/cloud_storage_exceptions.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services/hive/models/purchases_item/purchases_item_model.dart';
import '../../services/hive/models/sales_item/sales_item_model.dart';
import '../../utils/snackbar.dart';
import 'add_product_page.dart';
import 'imported_products_page.dart';
import 'imported_purchases_page.dart';
import 'imported_sales_page.dart';
import 'manage_product.dart';
import 'view_nonposted.dart';

class ManageStorePAge extends StatefulWidget {
  const ManageStorePAge({super.key});

  @override
  State<ManageStorePAge> createState() => _ManageStorePAgeState();
}

class _ManageStorePAgeState extends State<ManageStorePAge> {
  //ANCHOR - init state
  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Manage Store'),
            centerTitle: true,
            titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            bottom: PreferredSize(
              preferredSize:
                  const Size.fromHeight(55.0), // Set your desired height
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Adding new products, managing products, importing and exporting data',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            // sliver grid view builder
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 5,
                childAspectRatio: 1.2,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                List iconList = [
                  const Icon(Icons.add),
                  const Icon(Icons.edit_outlined),
                  const Icon(Icons.notes),
                  const Icon(Icons.download),
                  const Icon(Icons.download),
                  const Icon(Icons.download),
                ];

                List titleList = [
                  'Add New Product',
                  'Manage Product',
                  'View Non-Posted',
                  'Import Products',
                  'Import Sales',
                  'Import Purchases',
                ];

                return _buildManageStoreTile(
                    context, index, titleList[index], iconList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManageStoreTile(
      BuildContext context, int index, String title, Widget icon) {
    return GestureDetector(
      onTap: () => _onTap(context, index),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: SizedBox(
          //height: 115,
          //width: 110,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 1,
                shape: const CircleBorder(),
                child: CircleAvatar(
                  radius: 35,
                  child: Center(
                    child: icon,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext cxt, int index) {
    // switch case
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddNewProductPage(
              onAddProduct: _createProduct,
            ),
          ),
        );
        break;
      case 1:
        Navigator.push(
          cxt,
          MaterialPageRoute(
            builder: (context) => const ManageProductPage(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          cxt,
          MaterialPageRoute(
            builder: (context) => const NonPostedListPage(),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImportedProducts(onImport: _importProducts),
          ),
        );
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImportedSales(onImport: _importSales),
          ),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImportedPurchases(onImport: _importPurchases),
          ),
        );
        break;
      default:
    }
  }

  // NOTE: Import Products Page Members
  Future _importProducts(List<CloudProduct> products) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: const Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 10),
                Text('Importing data...'),
              ],
            ),
          ),
        ),
      ),
    );
    try {
      // clear product box
      await HiveLocalProductService().deleteAllProducts();

      // pick file from device
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      // work with file
      if (result != null) {
        final File file = File(result.files.single.path!);
        final String csv = file.readAsStringSync();

        final listOne = csv.split('\n');
        listOne.removeLast();

        List listTwo = [];
        for (var element in listOne) {
          listTwo.add(element.split(','));
        }

        for (int i = 0; i < listTwo.length; i++) {
          final row = listTwo[i];

          final String productName = row[0].toString().trim();
          final double buyingPrice = double.parse(row[1].toString().trim());
          final double sellingPrice = double.parse(row[2].toString().trim());
          final int stockCount = int.parse(row[3].toString().trim());

          final localProduct = LocalProduct(
            documentId: _getProductId(products, productName),
            productName: productName,
            buyingPrice: buyingPrice,
            sellingPrice: sellingPrice,
            stockCount: stockCount,
          );

          await HiveLocalProductService().addProduct(localProduct);

          if (i == listTwo.length - 1) {
            _pop();
          }
        }
      } else {
        _pop();
      }
    } catch (e) {
      _pop();
      _error();
      return;
    }
  }

  String _getProductId(List<CloudProduct> sales, String productName) {
    for (var element in sales) {
      if (element.productName == productName) {
        return element.documentId;
      }
    }
    print('Id not found $productName');
    return Processors.generateCode(10);
  }

// NOTE: Import Sales Page Members
  Future _importSales(List<SalesModel> sales) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: const Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 10),
                Text('Importing data...'),
              ],
            ),
          ),
        ),
      ),
    );
    try {
      // clear product box
      await SalesModelService().deleteAllSales();

      // pick file from device
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      // work with file
      if (result != null) {
        print('entered');
        final File file = File(result.files.single.path!);
        final String csv = file.readAsStringSync();

        final listOne = csv.split('\n');
        // print(listOne.last);
        listOne.removeLast();
        print(listOne.last);

        List listTwo = [];
        for (var element in listOne) {
          listTwo.add(element.split(','));
        }

        print('List Two -------------------> ${listTwo.last}');

        Map<String, SalesModel> salesData = {};

        for (int i = 0; i < listTwo.length; i++) {
          final row = listTwo[i];

          String productName = row[0].toString().trim();
          int quantity = int.parse(row[1].toString().trim());
          double price = double.parse(row[2].toString().trim()) * quantity;

          if (salesData.containsKey(productName)) {
            salesData[productName]!.totalQuantity =
                salesData[productName]!.totalQuantity! + quantity;
            salesData[productName]!.totalSales =
                salesData[productName]!.totalSales! + price;
          } else {
            salesData[productName] = SalesModel(
              documentId: _getSaleId(sales, productName),
              productName: productName,
              totalQuantity: quantity,
              totalSales: price,
            );
          }
        }

        // save all salesData to hive
        for (var element in salesData.values) {
          await SalesModelService().addSale(element);
        }
        _pop();
      } else {
        _pop();
      }
    } catch (e) {
      print(e);
      _pop();
      _error();
      return;
    }
  }

  String _getSaleId(List<SalesModel> sales, String productName) {
    for (var element in sales) {
      if (element.productName == productName) {
        return element.documentId;
      }
    }
    print('Id not found $productName');
    return Processors.generateCode(10);
  }

  // NOTE: Import Purchases Page Members
  Future _importPurchases(List<PurchasesModel> purchases) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: const Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 10),
                Text('Importing data...'),
              ],
            ),
          ),
        ),
      ),
    );
    try {
      // clear product box
      await PurchasesModelService().deleteAllPurchases();

      // pick file from device
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      // work with file
      if (result != null) {
        final File file = File(result.files.single.path!);
        final String csv = file.readAsStringSync();

        final listOne = csv.split('\n');
        // print(listOne.last);
        listOne.removeLast();
        // print(listOne.last);

        List listTwo = [];
        for (var element in listOne) {
          listTwo.add(element.split(','));
        }
        Map<String, PurchasesModel> salesData = {};

        for (int i = 0; i < listTwo.length; i++) {
          final row = listTwo[i];

          String productName = row[0].toString().trim();
          int quantity = int.parse(row[1].toString().trim());

          if (salesData.containsKey(productName)) {
            salesData[productName]!.totalQuantity =
                salesData[productName]!.totalQuantity! + quantity;
          } else {
            salesData[productName] = PurchasesModel(
              documentId: _getPurchaseId(purchases, productName),
              productName: productName,
              totalQuantity: quantity,
            );
          }
        }
        // save all salesData to hive
        for (var element in salesData.values) {
          await PurchasesModelService().addPurchase(element);
        }
        _pop();
      } else {
        _pop();
      }
    } catch (e) {
      print(e);
      _pop();
      _error();
      return;
    }
  }

  String _getPurchaseId(List<PurchasesModel> sales, String productName) {
    for (var element in sales) {
      if (element.productName == productName) {
        return element.documentId;
      }
    }
    print('Id not found $productName');
    return Processors.generateCode(10);
  }

// Handle Dialogs
  void _pop() {
    Navigator.of(context).pop();
  }

  void _error() {
    ErrorUtil.showSnackBar(
      context: context,
      message: 'Something went wrong, import failed',
    );
  }

  // NOTE: Add New Product Page Members
  /* -------------------------------------------------------------------------- */
  late final FirebaseCloudStorage _cloudStorage;
  void _createProduct(CloudProduct product) async {
    // save product to cloud
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: const Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16.0),
                  Text('Uploading data...'),
                ],
              ),
            ),
          ),
        ),
      );

      await _cloudStorage.createProduct(
        documentId: product.documentId,
        productName: product.productName,
        buyingPrice: product.buyingPrice,
        sellingPrice: product.sellingPrice,
        stockCount: product.stockCount,
      );
      _popContext();
    } catch (e) {
      throw CouldNotCreateProductException();
    }
  }

  void _popContext() async {
    Navigator.of(context).pop();

    await Future.delayed(const Duration(milliseconds: 500), () {
      ErrorUtil.showSnackBar(
          context: context, message: 'Product Added Successfully');
    });
  }

  /* -------------------------------------------------------------------------- */
}


/* -------------------------------------------------------------------------- */
// !SECTION: Manage Product Page

// SECTION: Page Components
/* -------------------------------------------------------------------------- */

/* -------------------------------------------------------------------------- */
// !SECTION: Page Components

