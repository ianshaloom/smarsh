import 'package:flutter/material.dart';
import 'package:smarsh/services/cloud/cloud_product.dart';

import '../../utils/shared_classes.dart';
import '../shared_views_widgets.dart';

// SECTION Add New Product Page
/* -------------------------------------------------------------------------- */

class AddNewProductPage extends StatelessWidget {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController buyingPriceController = TextEditingController();
  final TextEditingController sellingPriceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Function onAddProduct;

  AddNewProductPage({
    super.key,
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Add New Product'),
            centerTitle: true,
            titleTextStyle: textTheme.titleLarge!.copyWith(
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
              preferredSize:
                  const Size.fromHeight(35.0), // Set your desired height
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Add a new product to your store',
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
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
                        textStyle: textTheme.labelLarge!.copyWith(
                          fontSize: 17,
                        ),
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

      print(product.productName);
      onAddProduct(product);
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
