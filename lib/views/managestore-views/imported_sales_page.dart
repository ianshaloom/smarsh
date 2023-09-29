import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../constants/hive_constants.dart';
import '../../services/cloud/cloud_product.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services/hive/models/sales_item/sales_item_model.dart';
import '../../services/hive/service/hive_service.dart';
import '../../utils/snackbar.dart';

class ImportedSales extends StatelessWidget {
  final Function onImport;

  const ImportedSales({super.key, required this.onImport});

  @override
  Widget build(BuildContext context) {
    List<SalesModel> newSales = [];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Imported Sales'),
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
                  'Fill in new sales by importing new sales data from a file',
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
                valueListenable: HiveBoxes.getSalesBox().listenable(),
                builder: (context, Box<SalesModel> box, child) {
                  List<SalesModel> generatedSales = box.values.toList();

                  return box.isEmpty
                      ? FutureBuilder(
                          future: FirebaseCloudStorage().getAllStock(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                List<CloudProduct> cloudStock =
                                    snapshot.data as List<CloudProduct>;

                                List<SalesModel> localSales =
                                    generateSalesList(cloudStock);
                                newSales = localSales;
                                localSales.sort((a, b) =>
                                    a.productName.compareTo(b.productName));

                                return const SliverFillRemaining(
                                  child: Center(
                                    child: Text(
                                      'Your sales list is empty',
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
                                        subtitle: Text(
                                            'Total Sales: ${localSales[index].totalSales}'),
                                        trailing: Text(localSales[index]
                                            .totalQuantity
                                            .toString()),
                                      ),
                                    );
                                  },
                                );*/
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
                                subtitle: Text(
                                    'Total Sales: ${generatedSales[index].totalSales}'),
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
          if (HiveBoxes.getSalesBox().isEmpty) {
            onImport(newSales);
          } else {
            _pleaseClear(context);
          }
        },
        label: const Text('Import Sales'),
        icon: const Icon(Icons.download_rounded),
      ),
    );
  }

  List<SalesModel> generateSalesList(List<CloudProduct> cloudStock) {
    List<SalesModel> localSales = [];
    for (var element in cloudStock) {
      localSales.add(SalesModel(
        documentId: element.documentId,
        productName: element.productName,
        totalSales: 0,
        totalQuantity: 0,
      ));
    }
    return localSales;
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear Imported Sales'),
          content:
              const Text('Are you sure you want to clear all imported sales?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                SalesModelService().deleteAllSales();
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
      message: 'Please clear all imported sales before importing new sales',
    );
  }
}
