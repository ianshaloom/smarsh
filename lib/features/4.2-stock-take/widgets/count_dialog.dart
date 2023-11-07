import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../services/cloud/cloud_product.dart';
import '../../../services/cloud/firebase_cloud_storage.dart';
import '../services/stock_taking_mixin.dart';

// SECTION: Add Count Dialog
/* -------------------------------------------------------------------------- */
class CountingDialog extends StatefulWidget {
  final CloudProduct product;
  const CountingDialog({super.key, required this.product});

  @override
  State<CountingDialog> createState() => _CountingDialogState();
}

class _CountingDialogState extends State<CountingDialog> with StockTakingMixin {
  final TextEditingController _countContoller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return StreamBuilder(
      stream: FirebaseCloudStorage()
          .singleProductStream(documentId: widget.product.documentId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: SizedBox(
              height: 75,
              width: 75,
              child: CircularProgressIndicator(),
            ),
          );
        }

        //if (snapshot.hasData) {
        final CloudProduct cloudCountedProduct = snapshot.data as CloudProduct;
        final List<int> cloudCounts =
            cloudCountedProduct.count.cast<int>().toList();
        //counts.addAll(cloudCounts);
        return Dialog(
          insetPadding:
              const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 30),
          child: SizedBox(
            // height: 400,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product Name',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: color.primary),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                widget.product.productName,
                                //textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Count',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: color.primary),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _getCount(cloudCounts).toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Recent Counts',
                  style: textTheme.titleMedium,
                ),
                Flexible(
                  flex: 1,
                  child: cloudCounts.isEmpty
                      ? const SizedBox(
                          height: 150,
                          child: Center(child: Text('No counts recorded yet')),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: cloudCounts.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: CircleAvatar(
                                        radius: 45,
                                        child: Center(
                                          child: Text(
                                            cloudCounts[index].toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )),
                                  ),
                                  Positioned(
                                    top: -10,
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(
                                        CupertinoIcons.clear_circled_solid,
                                        color: color.primary,
                                      ),
                                      onPressed: () {
                                        _removeCount(
                                            cloudCountedProduct, index);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                // row with total count and add button
                Container(
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 0, top: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                            readOnly: true,
                            autocorrect: false,
                            controller: _countContoller,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                child: const Icon(Icons.backspace),
                                onTap: () {
                                  if (_countContoller.text.isNotEmpty) {
                                    _countContoller.text = _countContoller.text
                                        .substring(
                                            0, _countContoller.text.length - 1);
                                  }
                                },
                                onLongPress: () {
                                  _countContoller.clear();
                                },
                              ),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter count';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: _numberKeypad(cloudCountedProduct),
                ),
              ],
            ),
          ),
        );
        //} else {
        //  return const Center(child: Text('No data found'));
        //}
      },
    );
  }

  Widget _numberKeypad(CloudProduct product) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            _numberButton('1'),
            _numberButton('2'),
            _numberButton('3'),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _numberButton('4'),
            _numberButton('5'),
            _numberButton('6'),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _numberButton('7'),
            _numberButton('8'),
            _numberButton('9'),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: Container()),
            _numberButton('0'),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded(
            //   child: TextButton(
            //     onPressed: () {
            //       _addCount(product, context);
            //     },
            //     child: const Text(
            //       'Add Count',
            //       style: TextStyle(fontSize: 15),
            //     ),
            //   ),
            // ),
            /*Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: FilledButton(
                  onPressed: () => _addCount(product, context),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size.fromHeight(60),
                  ),
                  child: const Text(
                    'Add Count',
                  ),
                ),
              ),
            ),*/
            const SizedBox(height: 30),
            FloatingActionButton(
              // mini: true,
              onPressed: () => _addCount(product, context),
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }

  Widget _numberButton(String number) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          _countContoller.text += number;
        },
        child: Text(
          number,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  void _addCount(CloudProduct product, BuildContext cxt) async {
    FocusScope.of(context).unfocus();
    final form = _formKey.currentState!;
    List<dynamic> count = product.count;

    if (form.validate()) {
      final String productCode = product.documentId;
      final int itemCount = int.parse(_countContoller.text.trim());
      count.add(itemCount);
      _clearControllers();
      addCount(count, productCode, cxt);
    }
  }

  // remove count from list of counts
  void _removeCount(CloudProduct product, int index) async {
    List<dynamic> count = product.count;
    count.removeAt(index);

    // update cloud counted product with new list of counts
    await FirebaseCloudStorage().updateCountListProduct(
      documentId: product.documentId,
      count: product.count,
    );
  }

  // clear controllers and exit page
  void _clearControllers() {
    _countContoller.clear();
    // Navigator.pop(context);
  }

  // return a ProductCountModel from a ProductModel
  // CloudProduct _productToCount(CloudProduct product) {
  //   return GetMeFromHive.getAllItemCounts.firstWhere(
  //     (element) => element.productId == product.documentId,
  //     orElse: () => ItemCountModel(
  //       productId: product.documentId,
  //       productName: product.productName,
  //       count: [],
  //     ),
  //   );
  // }

  // return the current count of a product from a list of counts
  int _getCount(List<int> counts) {
    // add all integers in the list
    int count =
        counts.fold(0, (previousValue, element) => previousValue + element);
    return count;
  }
}

/* -------------------------------------------------------------------------- */
// !SECTION: Add Count Dialog
