import 'package:flutter/material.dart';

import '../../../services/hive/models/local_product_model/local_product_model.dart';

class StockListTile extends StatelessWidget {
  final LocalProduct product;
  final Function onTap;
  const StockListTile({
    super.key,
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
          'WholeSale: ${product.wholesale} •  Retail: ${product.retail}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(
            '${product.lastCount}',
          ),
        ),
      ),
    );
  }
}
