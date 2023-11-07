// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'add-new-product/views/add_product_page.dart';
import 'import-processed_data/views/processed_data_page.dart';
import 'manage_stock/views/manage_product.dart';
import 'import-products/views/imported_products_page.dart';
import 'generated-non-posted/views/nonposted_page.dart';
import 'widgets/reset_count_progress.dart';
import 'widgets/stock_update_progress.dart';

// SECTION: Manage Product Page
/* -------------------------------------------------------------------------- */
class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List iconList;
    List titleList;

    iconList = [
      const Icon(Icons.file_present_rounded),
      const Icon(Icons.add_rounded),
      const Icon(Icons.supervisor_account_outlined),
      const Icon(Icons.inventory),
      const Icon(Icons.wifi_protected_setup_sharp),
      const Icon(Icons.file_present_rounded),
      const Icon(Icons.cloud_sync_rounded),
      const Icon(Icons.cloud_upload_rounded),
    ];

    titleList = [
      'Import Stock',
      'Add New Product',
      'Manage Users',
      'Manage Stock',
      'Generate Non-Posted',
      'Import Processed Data',
      'Reset Stock-Take',
      'Update Cloud Stock-List',
    ];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Admin Panel'),
            centerTitle: true,
            titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            // sliver grid view builder
            sliver: SliverList.builder(
              itemCount: titleList.length,
              itemBuilder: (context, index) {
                return _buildManageStoreTile(
                    context, index, titleList[index], iconList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManageStoreTile(
    BuildContext context,
    int index,
    String title,
    Widget icon,
  ) {
    return ListTile(
      onTap: () => onTap(index),
      leading: CircleAvatar(
        radius: 35,
        child: Center(
          child: icon,
        ),
      ),
      title: Text(
        title,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
    );
  }

  void onTap(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ImportedProducts(),
          ),
        );

        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddNewProductPage(),
          ),
        );

        break;
      case 2:
        showDialog(
          barrierColor: Colors.black38,
          context: context,
          barrierDismissible: true,
          builder: (_) => const Center(
            child: Text('Users Privileges'),
          ),
        );

        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ManageProductPage(),
          ),
        );

        break;
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AdminNonPostedListPage(),
          ),
        );

        break;
      case 5:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ProcessedDataPage(),
          ),
        );
        break;
      case 6:
        _confirmReset(context);
        break;
      case 7:
        _confirmUpdate(context);
        break;
    }
  }

  void _confirmReset(BuildContext cxt) async {
    final bool confirm = await showDialog(
      context: cxt,
      builder: (context) => AlertDialog(
        title: const Text('Reset Stock-Take'),
        content: const Text('Are you sure you want to reset the stock-take?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirm) {
      // reset stock-take
      showDialog(
        barrierColor: Colors.black38,
        context: cxt,
        barrierDismissible: false,
        builder: (_) => const ResetProgress(),
        // builder: (_) => const Center(),
      );
    }
  }

  void _confirmUpdate(BuildContext cxt) async {
    final bool confirm = await showDialog(
      context: cxt,
      builder: (context) => AlertDialog(
        title: const Text('Update Stock-List'),
        content:
            const Text('Are you sure you want to update the cloud stock-list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Update'),
          ),
        ],
      ),
    );

    if (confirm) {
      // reset stock-take
      showDialog(
        barrierColor: Colors.black38,
        context: cxt,
        barrierDismissible: false,
        builder: (_) => const StockUpdateProgress(),
        // builder: (_) => const Center(),
      );
    }
  }
}
