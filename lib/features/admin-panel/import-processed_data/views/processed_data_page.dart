import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../services/hive/models/processed_stock_model/processed_stock.dart';
import '../../../../services/hive/service/hive_constants.dart';
import '../../../../services/cloud/cloud_product.dart';
import '../../../../services/cloud/firebase_cloud_storage.dart';
import '../services/processed_data_mixin.dart';
import '../widgets/prosessed_import_progress.dart';

class ProcessedDataPage extends StatelessWidget with ProcessedDataMixin {
  const ProcessedDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<CloudProduct> newProducts = [];
    // List<ProcessedData> cloudStock = [];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Processed Data'),
            centerTitle: true,
            titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                onPressed: () => confirmClearProcessed(context),
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
                  'Import processed stock from your device or sync with cloud',
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
              valueListenable: HiveBoxes.getProcessedDataBox.listenable(),
              builder: (context, Box<ProcessedData> box, child) {
                List<ProcessedData> imported =
                    box.values.toList().cast<ProcessedData>();

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
                        itemBuilder: (context, index) {
                          imported.sort((a, b) => a.productName
                              .toLowerCase()
                              .compareTo(b.productName.toLowerCase()));
                          // cloudStock = imported;
                          //
                          return Card(
                            elevation:
                                isNew(imported[index].documentId) ? 0 : 1,
                            color: isNew(imported[index].documentId)
                                ? Theme.of(context).colorScheme.error
                                : null,
                            child: ListTile(
                              title: Text(
                                imported[index].productName,
                                style: TextStyle(
                                  color: isNew(imported[index].documentId)
                                      ? Colors.white
                                      : null,
                                ),
                              ),
                              subtitle: Text(
                                imported[index].stockCount.toString(),
                                style: TextStyle(
                                  color: isNew(imported[index].documentId)
                                      ? Colors.white
                                      : null,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: isNew(imported[index].documentId)
                                      ? Colors.white
                                      : null,
                                ),
                                onPressed: () async {
                                  // delete product
                                  await imported[index].delete();
                                },
                              ),
                            ),
                          );
                        });
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (HiveBoxes.getProcessedDataBox.isEmpty) {
            showDialog(
              barrierColor: Colors.black38,
              context: context,
              barrierDismissible: false,
              builder: (_) => ProcessedImportProgress(products: newProducts),
            );
          } else {
            pleaseClear(context);
          }
        },
        label: const Text('Import products'),
        icon: const Icon(Icons.download),
        //child: const Icon(Icons.add),
      ),
    );
  }
}
