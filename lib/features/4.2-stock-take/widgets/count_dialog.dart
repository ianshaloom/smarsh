import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/cloud/cloud_entities.dart';
import '../../../services/cloud/cloud_storage_services.dart';
import '../../4-home-page/provider/homepage_provider.dart';
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
    CloudUser user = context.read<HomePageProvida>().getUser;

    return StreamBuilder(
      stream: FirestoreProducts()
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
        final List<ItemCount> countedItems = cloudCountedProduct.itemsCount;

        //counts.addAll(cloudCounts);
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          insetPadding:
              const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    height: 130,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
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
                              cloudCountedProduct.productName,
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
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Expected Count',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: color.primary),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  getExpectedCount(
                                          cloudCountedProduct.documentId)
                                      .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Counted',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: color.primary),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  cloudCountedProduct.totalCount.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Recent Counts',
                    style: textTheme.titleMedium,
                  ),
                  SizedBox(
                    height: 130,
                    child: countedItems.isEmpty
                        ? const SizedBox(
                            height: 150,
                            child:
                                Center(child: Text('No counts recorded yet')),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            scrollDirection: Axis.horizontal,
                            itemCount: countedItems.length,
                            itemBuilder: (context, index) {
                              return Container(
                                alignment: Alignment.center,
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 15,
                                      ),
                                      child: CircleAvatar(
                                          radius: 45,
                                          // backgroundColor:
                                          //     countedItems[index].colorValue,
                                          child: Center(
                                            child: Text(
                                              countedItems[index]
                                                  .count
                                                  .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: countedItems[index]
                                                    .colorValue,
                                              ),
                                            ),
                                          )),
                                    ),
                                    Positioned(
                                      top: -3,
                                      right: 0,
                                      child: IconButton(
                                        icon: Icon(
                                          CupertinoIcons.clear_circled_solid,
                                          color: countedItems[index].colorValue,
                                        ),
                                        onPressed: () {
                                          if (user.role == 'admin') {
                                            _removeCount(
                                                cloudCountedProduct, index);
                                          } else {
                                            (user.color !=
                                                    countedItems[index].color)
                                                ? null
                                                : _removeCount(
                                                    cloudCountedProduct, index);
                                          }
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
                    height: 40,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
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
                                      _countContoller.text =
                                          _countContoller.text.substring(0,
                                              _countContoller.text.length - 1);
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
                  _numberKeypad(cloudCountedProduct),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: FilledButton(
                  onPressed: () =>
                      _addCount(cloudCountedProduct, context, user.color),
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
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _numberKeypad(CloudProduct product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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

  void _addCount(CloudProduct product, BuildContext cxt, String color) async {
    FocusScope.of(context).unfocus();
    final form = _formKey.currentState!;
    List<dynamic> count = product.count;

    if (form.validate()) {
      final String productCode = product.documentId;
      final int itemCount = int.parse(_countContoller.text.trim());
      final Map<String, dynamic> countMap = {
        'color': color,
        'count': itemCount,
      };
      count.add(countMap);
      _clearControllers();
      addCount(count, productCode, cxt);
    }
  }

  // remove count from list of counts
  void _removeCount(CloudProduct product, int index) async {
    List<dynamic> count = product.count;
    count.removeAt(index);

    // update cloud counted product with new list of counts
    removeCount(count, product.documentId);
  }

  // clear controllers and exit page
  void _clearControllers() {
    _countContoller.clear();
    // Navigator.pop(context);
  }
}

/* -------------------------------------------------------------------------- */
// !SECTION: Add Count Dialog
