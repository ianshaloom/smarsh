import 'package:flutter/material.dart';

import '../../../../global/helpers/snacks.dart';
import '../../../../global/utils/shared_classes.dart';
import '../../../../global/helpers/custom_widgets.dart';
import '../../../../services/cloud/cloud_entities.dart';
import '../services/new_product_mixin.dart';

// SECTION Add New Product Page
/* -------------------------------------------------------------------------- */

class AddNewProductPage extends StatelessWidget with NewProductMixin {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController buyingPriceController = TextEditingController();
  final TextEditingController sellingPriceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AddNewProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Add New Product'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    NormalTextFormField(
                      controller: productNameController,
                      isNumber: false,
                      labelText: 'Product Name',
                      hintText: 'Enter Product Name',
                      errorText: 'Please enter product name',
                      prefixIcon: const Icon(Icons.shopping_bag_outlined),
                    ),
                    const SizedBox(height: 20),
                    NormalTextFormField(
                      controller: buyingPriceController,
                      isNumber: true,
                      labelText: 'Buying Price',
                      hintText: 'Enter Buying Price',
                      errorText: 'Please enter buying price',
                      prefixIcon: const Icon(Icons.money),
                    ),
                    const SizedBox(height: 20),
                    NormalTextFormField(
                      controller: sellingPriceController,
                      isNumber: true,
                      labelText: 'Selling Price',
                      hintText: 'Enter Selling Price',
                      errorText: 'Please enter selling price',
                      prefixIcon: const Icon(Icons.money),
                    ),
                    const SizedBox(height: 20),
                    NormalTextFormField(
                      controller: stockController,
                      isNumber: true,
                      labelText: 'Stock',
                      hintText: 'Enter Stock',
                      errorText: 'Please enter stock',
                      prefixIcon: const Icon(Icons.shopping_bag_outlined),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () => _onPressed(context),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size.fromHeight(60),
                      ),
                      child: const Text(
                        'Add Product',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onPressed(BuildContext context) {
    FocusScope.of(context).unfocus();
    final form = formKey.currentState!;
    if (form.validate()) {
      final String productCode = Processors.generateCode(10);
      final productName = productNameController.text.trim();
      final buyingPrice = double.parse(buyingPriceController.text.trim());
      final sellingPrice = double.parse(sellingPriceController.text.trim());
      final stockCount = int.parse(stockController.text.trim());

      final CloudProduct product = CloudProduct(
        documentId: productCode,
        productName: productName,
        buyingPrice: buyingPrice,
        sellingPrice: sellingPrice,
        stockCount: stockCount,
      );

      createProduct(product, context).then((value) {
        _clearControllers();
        Snack().cloudSuccess(0, context);
      }).catchError((error) {
        _clearControllers();
        Snack().cloudError(0, context);
      });
    }
    _clearControllers();
  }

  void _clearControllers() {
    productNameController.clear();
    buyingPriceController.clear();
    sellingPriceController.clear();
    stockController.clear();
  }
}

/* -------------------------------------------------------------------------- */
//!SECTION Add New Product Page
