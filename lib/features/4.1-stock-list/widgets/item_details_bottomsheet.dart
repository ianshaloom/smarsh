import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../services/hive/models/local_product_model/local_product_model.dart';


class ItemDetails extends StatelessWidget {
  final LocalProduct product;
  const ItemDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SizedBox(
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
                        'Not Available',
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
      );
  }
}