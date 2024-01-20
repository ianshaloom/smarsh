import 'package:flutter/material.dart';

import '../../../../services/cloud/cloud_entities.dart';

class ManageStockTile extends StatelessWidget {
  final CloudProduct product;
  final Function onTap;

  const ManageStockTile({super.key, required this.product, required this.onTap});

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
