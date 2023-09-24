// SECTION: Manage Product Page
/* -------------------------------------------------------------------------- */
import 'package:flutter/material.dart';

import '../../services/cloud/cloud_product.dart';
import '../../services/cloud/cloud_storage_exceptions.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
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
        _importProducts();
      case 4:
        _importSales();
        break;
      case 5:
        _importPurchases();
        break;
      default:
    }
  }

  void _importSales() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ImportedSales(),
      ),
    );
  }

  void _importPurchases() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ImportedPurchases(),
      ),
    );
  }

  Future _importProducts() async {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) => WillPopScope(
    //     onWillPop: () async => false,
    //     child: Dialog(
    //       child: Container(
    //         padding: const EdgeInsets.all(16.0),
    //         child: const Row(
    //           children: [
    //             CircularProgressIndicator(),
    //             SizedBox(width: 10),
    //             Text('Importing data...'),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    // try {
    //   // clear product box
    //   await Boxes.productBox().clear();

    //   // pick file from device
    //   final FilePickerResult? result = await FilePicker.platform.pickFiles(
    //     type: FileType.custom,
    //     allowedExtensions: ['csv'],
    //   );

    //   // work with file
    //   if (result != null) {
    //     print('entered');
    //     final File file = File(result.files.single.path!);
    //     final String csv = file.readAsStringSync();

    //     final listOne = csv.split('\n');
    //     listOne.removeLast();

    //     List listTwo = [];
    //     for (var element in listOne) {
    //       listTwo.add(element.split(','));
    //     }

    //     print('List Two -------------------> ${listTwo.last}');

    //     for (int i = 0; i < listTwo.length; i++) {
    //       print('entered loop');
    //       final row = listTwo[i];
    //       print(row);
    //       final String productCode = Shared.generateProductCode(10);
    //       print(productCode);
    //       final String productName = row[0].toString().trim();
    //       print(productName);
    //       final double buyingPrice = double.parse(row[1]);
    //       print(buyingPrice.toString());
    //       final double sellingPrice = double.parse(row[2]);
    //       print(sellingPrice.toString());
    //       final int stockCount = int.parse(row[3]);
    //       print(stockCount.toString());

    //       // save product to hive
    //       final product = ProductModel(
    //         productId: productCode,
    //         productName: productName,
    //         buyingPrice: buyingPrice,
    //         sellingPrice: sellingPrice,
    //         stockCount: stockCount,
    //       );

    //       print(product.productName);
    //       await Boxes.productBox().add(product);
    //       //break;
    //     }
    //   }

    //   _navigateToHomePage();
    // } catch (e) {
    //   print(e);
    //   Navigator.of(context).pop();
    //   return;
    // }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ImportedProducts(),
      ),
    );
  }

  void _navigateToHomePage() {
    Navigator.of(context).pop();
  }

  //
  //

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
      CustomSnackBar.showSnackBar(
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

