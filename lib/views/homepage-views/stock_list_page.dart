import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smarsh/services/cloud/cloud_product.dart';

import '../../services/cloud/firebase_cloud_storage.dart';

// SECTION: Stock List Page
/* -------------------------------------------------------------------------- */

class StockListPage extends StatefulWidget {
  const StockListPage({super.key});

  @override
  State<StockListPage> createState() => _StockListPageState();
}

class _StockListPageState extends State<StockListPage> {
  final _searchController = TextEditingController();
  final _cloudStock = FirebaseCloudStorage().getAllStock();

  List<CloudProduct> products = [];
  List _searched = [];

  void _searchProduct(String query) {
    List<CloudProduct> pr = [];

    if (query.isEmpty) {
      pr = products;
    } else {
      pr = products
          .where((element) =>
              element.productName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    setState(() {
      _searched = pr;
    });
  }

  bool _textFieldCleared() {
    if (_searchController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: FutureBuilder(
          future: _cloudStock,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<CloudProduct> cloudStock =
                    snapshot.data as List<CloudProduct>;
                cloudStock
                    .sort((a, b) => a.productName.compareTo(b.productName));

                if (products.isEmpty && _searched.isEmpty) {
                  products = cloudStock;
                  print(products.length);
                  _searched = products;
                  print(_searched.length);
                }

                return CustomScrollView(
                  slivers: [
                    SliverAppBar.medium(
                      collapsedHeight: 220,
                      scrolledUnderElevation: 0,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      centerTitle: true,
                      titleTextStyle:
                          Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 28,
                              ),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(
                            55.0), // Set your desired height
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 16,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tap on a item list tile to view product details',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                          ),
                        ),
                      ),
                      flexibleSpace: Container(
                        margin: const EdgeInsets.only(
                          top: 60,
                          bottom: 30,
                          left: 16,
                          right: 16,
                        ),
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Stock List',
                              style: textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SearchBar(
                              elevation: MaterialStateProperty.all(1),
                              controller: _searchController,
                              padding:
                                  const MaterialStatePropertyAll<EdgeInsets>(
                                      EdgeInsets.symmetric(horizontal: 20.0)),
                              hintText: 'Search for a product',
                              onChanged: (value) => _searchProduct(value),
                              leading: const Icon(CupertinoIcons.search),
                              trailing: [
                                IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searched = products;
                                    });
                                  },
                                  icon: _textFieldCleared()
                                      ? const Icon(Icons.clear)
                                      : const Icon(Icons.clear,
                                          color: Colors.transparent),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      sliver: SliverList.builder(
                        itemCount: _searched.length,
                        itemBuilder: (context, index) {
                          return _ProductListTile(
                            product: _searched[index],
                            onTap: _drawProductDetailBottomSheet,
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar.medium(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      title: const Text('Stock List'),
                      centerTitle: true,
                      titleTextStyle:
                          Theme.of(context).textTheme.titleLarge!.copyWith(
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
                        preferredSize: const Size.fromHeight(
                            55.0), // Set your desired height
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 16,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Please make effort to add products to your store',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverToBoxAdapter(
                          child: Center(
                            child: Text(
                              'No products found',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ))
                  ],
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future _drawProductDetailBottomSheet(
      BuildContext cxt, CloudProduct product) async {
    final color = Theme.of(cxt).colorScheme;
    showModalBottomSheet(
      showDragHandle: true,
      context: cxt,
      builder: (context) => SizedBox(
        height: 220,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              child: Text(
                product.productName,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              margin: const EdgeInsets.only(top: 10, bottom: 5),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                color: color.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              //
              //
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ' ${product.stockCount}',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Current Stock',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: color.primary,
                            ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '00',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Last Stock Count',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: color.primary,
                            ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              margin: const EdgeInsets.only(top: 10, bottom: 5),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                color: color.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              //
              //
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        NumberFormat('#,##0.00').format(product.buyingPrice),
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Buying Price',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: color.primary,
                            ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        NumberFormat('#,##0.00').format(product.sellingPrice),
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Selling Price',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: color.primary,
                            ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
// !SECTION: Stock List Page

// Component: Product Tile

class _ProductListTile extends StatelessWidget {
  final CloudProduct product;
  final Function onTap;
  const _ProductListTile({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onTap(context, product),
        contentPadding: const EdgeInsets.all(8),
        leading: CircleAvatar(
          radius: 30,
          //backgroundColor: Colors.transparent,
          child: Center(
              child: Text(
            product.productName[0].toUpperCase(),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                ),
          )),
        ),
        title: Text(
          product.productName,
          //style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: Text(
          'Selling: ${product.sellingPrice} •  Buying: ${product.buyingPrice}',
          //style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(
            '${product.stockCount}',
          ),
        ),
      ),
    );
  }
}
