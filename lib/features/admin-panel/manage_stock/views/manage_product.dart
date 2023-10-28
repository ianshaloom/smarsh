// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../../global/helpers/snacks.dart';
import '../../../../services/cloud/cloud_product.dart';
import '../../../../services/cloud/cloud_storage_exceptions.dart';
import '../../../../services/cloud/firebase_cloud_storage.dart';
import '../widgets/edit_item_dialog.dart';
import '../widgets/manage_stock_tile.dart';

class ManageProductPage extends StatefulWidget {
  const ManageProductPage({super.key});

  @override
  State<ManageProductPage> createState() => _ManageProductPageState();
}

class _ManageProductPageState extends State<ManageProductPage> {
  Future<List<CloudProduct>> _cloudStock = FirebaseCloudStorage().getAllStock();
  late final FirebaseCloudStorage _cloudStorage;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<CloudProduct> prs = [];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Manage Product'),
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
                icon: const Icon(Icons.clear_all),
                onPressed: () => prs.isEmpty ? null : _clearAllProducts(prs),
                // onPressed: () => print(prs.first),
              ),
            ],
            bottom: PreferredSize(
              preferredSize:
                  const Size.fromHeight(25.0), // Set your desired height
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tap on a product to edit and delete',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            sliver: FutureBuilder(
                future: _cloudStock,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<CloudProduct> cloudStock =
                          snapshot.data as List<CloudProduct>;
                      prs = cloudStock;
                      cloudStock.sort(
                          (a, b) => a.productName.compareTo(b.productName));

                      return SliverList.builder(
                        itemCount: cloudStock.length,
                        itemBuilder: (context, index) {
                          return ManageStockTile(
                            product: CloudProduct(
                              documentId: cloudStock[index].documentId,
                              productName: cloudStock[index].productName,
                              buyingPrice: cloudStock[index].buyingPrice,
                              sellingPrice: cloudStock[index].sellingPrice,
                              stockCount: cloudStock[index].stockCount,
                            ),
                            onTap: _onTap,
                          );
                        },
                      );
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
                }),
          ),
        ],
      ),
    );
  }

  // clear all products in cloud storage
  void _clearAllProducts(List<CloudProduct> prs) async {
    showDialog(
      barrierColor: Colors.black38,
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: SizedBox(
          height: 75,
          width: 75,
          child: CircularProgressIndicator(
            color: Colors.white,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );

    try {
      for (var pr in prs) {
        await _cloudStorage.deleteProduct(documentId: pr.documentId);
      }

      final bool isClear = await _cloudStorage.isCollectionEmpty();

      if (isClear) {
        Navigator.of(context).pop();
      }
    } on CouldNotDeleteException {
      Snack().showSnackBar(context: context, message: 'Failed To Clear Stock');
    }
  }

  void _onTap(BuildContext cxt, CloudProduct product) {
    showModalBottomSheet(
      context: cxt,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(top: 20, left: 20),
          height: 130,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.of(context).pop();
                  _editDialog(context, product);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  _deleteProduct(product);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteProduct(CloudProduct model) async {
    // delete product
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
                  Text('Deleting Product...'),
                ],
              ),
            ),
          ),
        ),
      );

      await _cloudStorage.deleteProduct(documentId: model.documentId);

      setState(() {
        _cloudStock = _cloudStorage.getAllStock();
      });
      _navigateBack(true);
    } catch (e) {
      throw CouldNotDeleteException;
    }
  }

  // NOTE: Edit Dialog Members

  void _editDialog(
    BuildContext cxt,
    CloudProduct model,
  ) {
    showDialog(
      context: cxt,
      builder: (context) => EditDialog(model: model, onEdit: _editProduct),
    );
  }

  void _editProduct(CloudProduct model) async {
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
                Text('Updating Product...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      await _cloudStorage.updateProduct(
        documentId: model.documentId,
        productName: model.productName,
        buyingPrice: model.buyingPrice,
        sellingPrice: model.sellingPrice,
        stockCount: model.stockCount,
      );

      setState(() {
        _cloudStock = _cloudStorage.getAllStock();
      });
      _navigateBack(false);
    } catch (e) {
      throw CouldNotUpdateException;
    }
  }

  void _navigateBack(bool isDeleting) {
    if (isDeleting) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Snack().showSnackBar(
          context: context, message: 'Product deleted successfully');
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Snack().showSnackBar(
          context: context, message: 'Product updated successfully');
    }
  }
}


class ProductModel {
  String productId;

  String productName;

  double buyingPrice;

  double sellingPrice;

  int stockCount;

  // required constructor
  ProductModel({
    required this.productId,
    required this.productName,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.stockCount,
  });
}
