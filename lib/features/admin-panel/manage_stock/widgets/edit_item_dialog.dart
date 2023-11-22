import 'package:flutter/material.dart';

import '../../../../services/cloud/cloud_product.dart';
import 'edit_item_textfield.dart';

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
                      } else {}
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
