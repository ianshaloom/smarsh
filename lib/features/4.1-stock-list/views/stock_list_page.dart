import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../services/hive/models/local_product_model/local_product_model.dart';
import '../../../services/hive/service/hive_constants.dart';
import '../services/stock_list_mixin.dart';
import '../widgets/item_details_bottomsheet.dart';
import '../widgets/refresh_local_products_sl.dart';
import '../widgets/stock_list_tile.dart';

// SECTION: Stock List Page
/* -------------------------------------------------------------------------- */

class StockListPage extends StatefulWidget {
  const StockListPage({super.key});

  @override
  State<StockListPage> createState() => _StockListPageState();
}

class _StockListPageState extends State<StockListPage> with StockListMixin {
  final _searchController = TextEditingController();
  final List<LocalProduct> products = GetMeFromHive.getAllLocalProducts;
  List _searched = [];

  void _searchProduct(String query) {
    List<LocalProduct> pr = [];

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
    _searched = products;
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock List'),
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              exportToCsv(context, products);
            },
            icon: const Icon(Icons.cloud_download_rounded),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0), // Set your desired height
          child: Container(
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                SearchBar(
                  elevation: MaterialStateProperty.all(1),
                  controller: _searchController,
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
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
                          : const Icon(Icons.clear, color: Colors.transparent),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Tap on a item list tile to view product details',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        child: RefreshIndicator(
          onRefresh: () async {
            await showDialog(
              barrierColor: Colors.black38,
              context: context,
              barrierDismissible: false,
              builder: (_) => const RefreshLocalSrc(),
            ).then((value) => setState(() {}));
          },
          child: ListView.builder(
            itemCount: _searched.length,
            itemBuilder: (context, index) {
              _searched.sort((a, b) => a.productName.compareTo(b.productName));
              return StockListTile(
                product: _searched[index],
                onTap: _drawProductDetailBottomSheet,
              );
            },
          ),
        ),
      ),
    );
  }

  Future _drawProductDetailBottomSheet(
    BuildContext cxt,
    LocalProduct product,
  ) async {
    showModalBottomSheet(
      showDragHandle: true,
      context: cxt,
      builder: (context) => ItemDetails(product: product),
    );
  }
}

/* -------------------------------------------------------------------------- */
