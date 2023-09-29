import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smarsh/services/hive/service/hive_service.dart';

import '../../constants/hive_constants.dart';
import '../../services/cloud/cloud_product.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services/hive/models/local_product/local_product_model.dart';
import '../../utils/snackbar.dart';

class ImportedProducts extends StatelessWidget {
  final Function onImport;
  const ImportedProducts({super.key, required this.onImport});

  @override
  Widget build(BuildContext context) {
    List<CloudProduct> newProducts = [];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Imported Products'),
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
            actions: [
              IconButton(
                icon: const Icon(Icons.sync),
                onPressed: () {
                  // loadAsset();
                },
              ),
              IconButton(
                onPressed: () => _confirmClear(context),
                icon: const Icon(Icons.clear_all),
              ),
            ],
            bottom: PreferredSize(
              preferredSize:
                  const Size.fromHeight(55.0), // Set your desired height
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Import new items from your device or sync with cloud',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
            sliver: ValueListenableBuilder(
              valueListenable: HiveBoxes.getLocalProductBox.listenable(),
              builder: (context, Box<LocalProduct> box, child) {
                List imported = box.values.toList().cast<LocalProduct>();

                return box.isEmpty
                    ? FutureBuilder(
                        future: FirebaseCloudStorage().getAllStock(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              List<CloudProduct> cloudStock =
                                  snapshot.data as List<CloudProduct>;

                              newProducts = cloudStock;

                              return const SliverFillRemaining(
                                child: Center(
                                  child: Text(
                                    'Your product list is empty',
                                  ),
                                ),
                              );
                            } else {
                              return const SliverToBoxAdapter(
                                child: Center(
                                  child: Text(
                                    'Your cloud stock list is empty',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }
                          } else {
                            return const SliverFillRemaining(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        })
                    : SliverList.builder(
                        itemCount: imported.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(imported[index].productName),
                            subtitle:
                                Text(imported[index].stockCount.toString()),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                // delete product
                                await imported[index].delete();
                              },
                            ),
                          ),
                        ),
                      );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (HiveBoxes.getLocalProductBox.isEmpty) {
            onImport(newProducts);
          } else {
            _pleaseClear(context);
          }
        },
        label: const Text('Import products'),
        icon: const Icon(Icons.download),
        //child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear Imported Sales'),
          content: const Text(
              'Are you sure you want to clear all imported products?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                HiveLocalProductService().deleteAllProducts();
                Navigator.of(context).pop();
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  // snack bar
  void _pleaseClear(BuildContext context) {
    ErrorUtil.showSnackBar(
      context: context,
      message:
          'Please clear all imported products before importing new products',
    );
  }
}

/** // NOTE - Load csv and upload contents

 * Future<void> loadAsset() async {
    try {
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
        listOne.removeLast();

        List listTwo = [];
        for (var element in listOne) {
          listTwo.add(element.split(','));
        }

        print('List Two -------------------> ${listTwo.last}');

        for (int i = 0; i < listTwo.length; i++) {
          print('entered loop');
          final row = listTwo[i];
          print(row);
          final String productCode = Shared.generateProductCode(10);
          print(productCode);
          final String productName = row[0].toString().trim();
          print(productName);
          final double buyingPrice = double.parse(row[1]);
          print(buyingPrice.toString());
          final double sellingPrice = double.parse(row[2]);
          print(sellingPrice.toString());
          final int stockCount = int.parse(row[3]);
          print(stockCount.toString());

          // save product to hive
          final product = ProductModel(
            productId: productCode,
            productName: productName,
            buyingPrice: buyingPrice,
            sellingPrice: sellingPrice,
            stockCount: stockCount,
          );

          final CloudProduct fetchedFile = await _cloudStorage.createProduct(
            documentId: productCode,
            productName: productName,
            buyingPrice: buyingPrice,
            sellingPrice: sellingPrice,
            stockCount: stockCount,
          );

          print(
              '\n ====> \n =========> \n =================> ${fetchedFile.productName}');

          //break;
        }
      }
    } catch (e) {
      print('Error loading asset: $e');
    }
  }
 */