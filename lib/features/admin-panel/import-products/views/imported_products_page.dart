import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../services/hive/models/local_product_model/local_product_model.dart';
import '../../../../services/hive/service/hive_constants.dart';
import '../../../../services/cloud/cloud_product.dart';
import '../../../../services/cloud/firebase_cloud_storage.dart';
import '../services/import_product_mixin.dart';
import '../widgets/upload_product_progress.dart';

class ImportedProducts extends StatelessWidget with ImportPrMixin {
  const ImportedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    List<CloudProduct> newProducts = [];
    List<LocalProduct> cloudStock = [];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Imported Products'),
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
                  icon: const Icon(Icons.sync),
                  onPressed: () => cloudStock.isEmpty
                      ? null
                      : showDialog(
                          barrierColor: Colors.black38,
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              ProductUploadProgress(locals: cloudStock),
                        )),
              IconButton(
                onPressed: () => confirmClear(context),
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
              valueListenable: HiveBoxes.getTempProductBox.listenable(),
              builder: (context, Box<LocalProduct> box, child) {
                List<LocalProduct> imported =
                    box.values.toList().cast<LocalProduct>();

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
                          cloudStock = imported;
                          //
                          return Card(
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
                          );
                        });
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (HiveBoxes.getTempProductBox.isEmpty) {
            importProducts(newProducts, context);
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
