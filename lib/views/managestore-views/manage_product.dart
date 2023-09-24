import 'package:flutter/material.dart';
import 'package:smarsh/services/cloud/cloud_product.dart';
import 'package:smarsh/utils/snackbar.dart';

import '../../services/cloud/cloud_storage_exceptions.dart';
import '../../services/cloud/firebase_cloud_storage.dart';

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
                      cloudStock.sort(
                          (a, b) => a.productName.compareTo(b.productName));

                      return SliverList.builder(
                        itemCount: cloudStock.length,
                        itemBuilder: (context, index) {
                          return _ProductTile(
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
      throw CouldNotDeleteProductException;
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
      final updated = await _cloudStorage.updateProduct(
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

      print({
        updated.productName,
        updated.buyingPrice,
        updated.sellingPrice,
        updated.stockCount
      });
    } catch (e) {
      throw CouldNotUpdateProductException;
    }
  }

  void _navigateBack(bool isDeleting) {
    if (isDeleting) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      CustomSnackBar.showSnackBar(
          context: context, message: 'Product deleted successfully');
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      CustomSnackBar.showSnackBar(
          context: context, message: 'Product updated successfully');
    }
  }
}

// SECTION: Widgets

// NOTE: This is the product tile

class _ProductTile extends StatelessWidget {
  final CloudProduct product;
  final Function onTap;

  const _ProductTile({required this.product, required this.onTap});

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
        trailing: Text(
          '${product.stockCount}',
          //style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

// NOTE: This is the edit dialog

class EditDialog extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final productNameController = TextEditingController();
  final buyingPriceController = TextEditingController();
  final sellingPriceController = TextEditingController();
  final stockCountController = TextEditingController();
  final Function onEdit;
  final CloudProduct model;

  EditDialog({super.key, required this.model, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    productNameController.text = model.productName;
    buyingPriceController.text = model.buyingPrice.toString();
    sellingPriceController.text = model.sellingPrice.toString();
    stockCountController.text = model.stockCount.toString();

    return Card(
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Product',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
              ),
              const SizedBox(height: 20),
              EditTextFormField(
                  controller: productNameController, labelText: 'Product Name'),
              const SizedBox(height: 20),
              EditTextFormField(
                  controller: buyingPriceController, labelText: 'Buying Price'),
              const SizedBox(height: 20),
              EditTextFormField(
                  controller: sellingPriceController,
                  labelText: 'Selling Price'),
              const SizedBox(height: 20),
              EditTextFormField(
                  controller: stockCountController, labelText: 'Stock Count'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final form = formKey.currentState!;

                      if (form.validate()) {
                        final String productName =
                            productNameController.text.trim();
                        final double buyingPrice =
                            double.parse(buyingPriceController.text.trim());
                        final double sellingPrice =
                            double.parse(sellingPriceController.text.trim());
                        final int stockCount =
                            int.parse(stockCountController.text.trim());

                        final CloudProduct newModel = CloudProduct(
                          documentId: model.documentId,
                          productName: productName,
                          buyingPrice: buyingPrice,
                          sellingPrice: sellingPrice,
                          stockCount: stockCount,
                        );

                        await onEdit(newModel);
                        print('valid');
                      } else {
                        print('invalid');
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// NOTE : This is the edit text form field

class EditTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  const EditTextFormField(
      {super.key, required this.controller, required this.labelText});

  @override
  State<EditTextFormField> createState() => _EditTextFormFieldState();
}

class _EditTextFormFieldState extends State<EditTextFormField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
      ),
      validator: (value) => value!.isEmpty ? 'Required !' : null,
    );
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
