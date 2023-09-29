import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../constants/hive_constants.dart';
import '../../services/cloud/cloud_product.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services/hive/models/purchases_item/purchases_item_model.dart';
import '../../services/hive/service/hive_service.dart';
import '../../utils/snackbar.dart';

class ImportedPurchases extends StatelessWidget {
  final Function onImport;
  const ImportedPurchases({super.key, required this.onImport});

  @override
  Widget build(BuildContext context) {
    List<PurchasesModel> newPurchases = [];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Imported Purchases'),
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
              // clear all imported sales
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
                  'Import new purchases data from a file, and fill in new purchases',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            sliver: ValueListenableBuilder(
                valueListenable: HiveBoxes.getPurchasesBox().listenable(),
                builder: (context, Box<PurchasesModel> box, child) {
                  List<PurchasesModel> generatedSales = box.values.toList();
                  generatedSales
                      .sort((a, b) => a.productName.compareTo(b.productName));

                  return box.isEmpty
                      ? FutureBuilder(
                          future: FirebaseCloudStorage().getAllStock(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                List<CloudProduct> cloudStock =
                                    snapshot.data as List<CloudProduct>;

                                List<PurchasesModel> localSales =
                                    generatePurchasesList(cloudStock);

                                newPurchases = localSales;
                                localSales.sort((a, b) =>
                                    a.productName.compareTo(b.productName));

                                return const SliverFillRemaining(
                                  child: Center(
                                    child: Text(
                                      'Your purchase list is empty',
                                    ),
                                  ),
                                );

                                /*return SliverList.builder(
                                  itemCount: localSales.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: ListTile(
                                        title:
                                            Text(localSales[index].productName),
                                        trailing: Text(localSales[index]
                                            .totalQuantity
                                            .toString()),
                                      ),
                                    );
                                  },
                                ); */
                              } else {
                                return const SliverToBoxAdapter(
                                  child: Center(
                                    child: Text(
                                      'Your stock list is empty',
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
                          },
                        )
                      : SliverList.builder(
                          itemCount: generatedSales.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(generatedSales[index].productName),
                                trailing: Text(generatedSales[index]
                                    .totalQuantity
                                    .toString()),
                              ),
                            );
                          },
                        );
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (HiveBoxes.getPurchasesBox().isEmpty) {
            onImport(newPurchases);
          } else {
            _pleaseClear(context);
          }
        },
        label: const Text(
          'Import Purchases',
        ),
        icon: const Icon(Icons.file_download),
      ),
    );
  }

  List<PurchasesModel> generatePurchasesList(List<CloudProduct> cloudStock) {
    List<PurchasesModel> localSales = [];
    for (var element in cloudStock) {
      localSales.add(
        PurchasesModel(
          documentId: element.documentId,
          productName: element.productName,
          totalQuantity: 0,
        ),
      );
    }
    return localSales;
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear Imported Purchases'),
          content: const Text(
              'Are you sure you want to clear all imported purchases?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                PurchasesModelService().deleteAllPurchases();
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
      message: 'Please clear all imported purchases before importing new sales',
    );
  }
}
