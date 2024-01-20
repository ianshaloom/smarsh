import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../global/providers/smarsh_providers.dart';
import '../../../services/cloud/cloud_entities.dart';
import '../../../services/cloud/cloud_storage_services.dart';
import '../services/stock_taking_mixin.dart';
import '../widgets/count_dialog.dart';
import '../widgets/export_final_progress.dart';
import '../widgets/fetch_processed_progressed.dart';
import 'search_page.dart';

class StockTakePage extends StatelessWidget with StockTakingMixin {
  StockTakePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cloudStock = FirestoreProducts().allProducts();
    bool isAdmin = context.read<AppProviders>().isAdmin;

    return Scaffold(
      body: StreamBuilder(
        stream: cloudStock,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CloudProduct> cloudStock = snapshot.data as List<CloudProduct>;
            cloudStock.sort((a, b) => a.productName.compareTo(b.productName));

            return CustomScrollView(
              slivers: [
                SliverAppBar.medium(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  title: const Text('Stock Take'),
                  centerTitle: true,
                  titleTextStyle:
                      Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                  leading: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      if (cloudStock.isEmpty) {
                        null;
                      } else {
                        Navigator.push(
                          context,
                          SearchPageRoute(
                              builder: (context) =>
                                  SearchPage(products: cloudStock)),
                        );
                      }
                    },
                  ),
                  actions: [
                    IconButton(
                      onPressed: () async {
                        await showDialog(
                          barrierColor: Colors.black38,
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const FetchProcessedSrc(),
                        );
                      },
                      icon: const Icon(CupertinoIcons.cloud_download),
                    ),
                    isAdmin
                        ? IconButton(
                            onPressed: () =>
                                _moreBottomSheet(context, isAdmin, cloudStock),
                            icon: const Icon(Icons.more_vert_outlined),
                          )
                        : const Center(),
                    // exit button
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(CupertinoIcons.xmark),
                    ),
                  ],
                ),
                cloudStock.isEmpty
                    ? const SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        sliver: SliverFillRemaining(
                          child: Center(
                              child: Text('Your cloud stocklist is empty')),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        sliver: SliverList.builder(
                          itemCount: cloudStock.length,
                          itemBuilder: (context, index) {
                            return _CloudProductTile(
                              product: cloudStock[index],
                              onTap: _toCountDialog,
                            );
                          },
                        ),
                      ),
              ],
            );
          } else {
            return const Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  void _toCountDialog(BuildContext cxt, CloudProduct product) {
    showDialog(
      useSafeArea: false,
      context: cxt,
      builder: (context) => CountingDialog(product: product),
    );
  }

  void _moreBottomSheet(
      BuildContext cxt, bool isAdmin, List<CloudProduct> cloudStock) {
    showModalBottomSheet(
      context: cxt,
      builder: (context) => Container(
        height: 140,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(CupertinoIcons.archivebox),
              title: const Text('Export to CSV'),
              onTap: () {
                if (isAdmin) {
                  Navigator.pop(context);
                  _confirmExportCSV(context, cloudStock);
                } else {
                  null;
                }
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.archivebox),
              title: const Text('Export to Final Count'),
              onTap: () {
                if (isAdmin) {
                  Navigator.pop(context);
                  _confirmFinalExport(context, cloudStock);
                } else {
                  null;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmExportCSV(
      BuildContext cxt, List<CloudProduct> cloudStock) async {
    showDialog(
      context: cxt,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Export'),
        content: const Text(
          'You are about to export your stock take data to CSV file '
          ' and saved to your device. Do you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await exportToCsv(context, cloudStock);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _confirmFinalExport(BuildContext cxt, List<CloudProduct> cloudStock) {
    showDialog(
      context: cxt,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Export'),
        content: const Text(
          'You are about to export your stock take data to '
          ' final stock count which will be used for computation '
          ' on next stock take. Data will be  saved to your device. Do you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              // exportingFinal(context, cloudStock);
              Navigator.pop(context);
              cloudStock.isEmpty
                  ? null
                  : showDialog(
                      barrierColor: Colors.black38,
                      context: context,
                      barrierDismissible: false,
                      builder: (_) =>
                          FinalExportProgress(cloudStock: cloudStock),
                    );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}


class _CloudProductTile extends StatelessWidget {
  final CloudProduct product;
  final Function onTap;
  const _CloudProductTile({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onTap(context, product),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        leading: CircleAvatar(
          radius: 30,
          //backgroundColor: Colors.transparent,
          child: Center(
              child: Text(
            product.productName[0].toUpperCase(),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
          )),
        ),
        title: Text(
          product.productName,
          //style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(
            product.totalCount.toString(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
          ),
        ),
      ),
    );
  }

  int get totalCount {
    if (product.count.isEmpty) {
      return 0;
    } else {
      return product.count.reduce((value, element) => value + element);
    }
  }
}
