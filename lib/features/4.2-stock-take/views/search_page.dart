import 'package:flutter/material.dart';

import '../../../services/cloud/cloud_product.dart';
import '../services/stock_taking_mixin.dart';
import '../widgets/count_dialog.dart';

// SECTION: Search Page // NOTE - SearchPage is a StatefulWidget
/* -------------------------------------------------------------------------- */
class SearchPage extends StatefulWidget {
  final List<CloudProduct> products;

  const SearchPage({super.key, required this.products});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _queryTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          autofocus: true,
          controller: _queryTextController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search for a product',
          ),
          onChanged: (value) => _searchProduct(value),
        ),
        actions: [
          // clear search text
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _queryTextController.clear();
              setState(() {
                _searchResult = products;
              });
            },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: ListView.builder(
          itemCount: _searchResult.length,
          itemBuilder: (context, index) {
            return _CloudProductTile(
              product: _searchResult[index],
              onTap: _toCountDialog,
            );
          },
        ),
      ),
    );
  }

  final _searchController = TextEditingController();
  List<CloudProduct> products = [];

  List<CloudProduct> _searchResult = [];

  void _searchProduct(String query) {
    List<CloudProduct> pr = [];

    if (query.isEmpty) {
      pr = products;
    } else {
      pr = products
          .where((element) =>
              element.productName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    setState(() {
      _searchResult = pr;
    });
  }

  @override
  void initState() {
    products = widget.products;
    _searchResult = products;
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toCountDialog(BuildContext cxt, CloudProduct product) {
    showDialog(
      context: cxt,
      builder: (context) => CountingDialog(product: product),
    );
  }
}

// Search Page Route
class SearchPageRoute extends PageRoute<void> {
  final Widget Function(BuildContext) builder;

  SearchPageRoute({
    required this.builder,
    RouteSettings? settings,
  }) : super(settings: settings);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => false;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  Animation<double> createAnimation() {
    final Animation<double> animation = super.createAnimation();
    _proxyAnimation.parent = animation;
    return animation;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  final ProxyAnimation _proxyAnimation =
      ProxyAnimation(kAlwaysDismissedAnimation);
}

/* -------------------------------------------------------------------------- */
// !SECTION: Search Page

class _CloudProductTile extends StatelessWidget with StockTakingMixin {
  final CloudProduct product;
  final Function onTap;
  _CloudProductTile({
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
        trailing: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(
            getCount(product.count.cast<int>().toList()).toString(),
          ),
        ),
      ),
    );
  }
}
