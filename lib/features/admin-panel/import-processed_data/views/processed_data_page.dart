import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../global/helpers/snacks.dart';
import '../../../../services/hive/models/local_product_model/local_product_model.dart';
import '../../../../services/hive/models/processed_stock_model/processed_stock.dart';
import '../../../../services/hive/service/hive_constants.dart';
import '../services/processed_data_mixin.dart';
import '../widgets/processed_data_bs.dart';

class ProcessedDataPage extends StatelessWidget with ProcessedDataMixin {
  const ProcessedDataPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => _moreBottomSheet(
                  true,
                  GetMeFromHive.getAllLocalProducts,
                  context,
                ),
                icon: const Icon(CupertinoIcons.ellipsis_vertical),
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
                    ? const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 200),
                          child: Center(
                            child: Text(
                              'Imported products will appear here',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )
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
          if (HiveBoxes.getProcessedDataBox.isNotEmpty) {
            Snack().showSnackBar(
              context: context,
              message: 'Clear processed data before importing',
            );
          } else {
            importPr(context);
          }
        },
        label: const Text('Import products'),
        icon: const Icon(Icons.download),
        //child: const Icon(Icons.add),
      ),
    );
  }

  void _moreBottomSheet(
      bool isAdmin, List<LocalProduct> cloudStock, BuildContext cxt) {
    showModalBottomSheet(
      context: cxt,
      builder: (context) => ProcessedMoreBs(
        cloudStock: cloudStock,
      ),
    );
  }
}
