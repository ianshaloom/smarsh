import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../entities/non_post_item.dart';
import '../services/non_posted.dart';
import '../services/non_posted_mixin.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/nonpost_tile.dart';
import '../widgets/refresh_local_products.dart';
import '../widgets/upload_nonposted_progress.dart';

class AdminNonPostedListPage extends StatefulWidget {
  const AdminNonPostedListPage({super.key});

  @override
  State<AdminNonPostedListPage> createState() => _AdminNonPostedListPageState();
}

class _AdminNonPostedListPageState extends State<AdminNonPostedListPage>
    with NonPostedMixin {
  final NonPosted n = NonPosted();
  List<Item> nonPost = [];

  @override
  void initState() {
    nonPost = n.nonPostedItemsList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Generated Non Posted'),
            // centerTitle: true,
            // elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              // refresh button
              IconButton(
                onPressed: () {
                  refreshLocalSrc();
                },
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                onPressed: () {
                  uploadNonPosted(nonPost);
                },
                icon: const Icon(Icons.cloud_upload),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
            sliver: SliverList.builder(
              itemCount: nonPost.length,
              itemBuilder: (context, index) {
                return NonpostTile(nonPost: nonPost[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => filterBottomSheet(context),
        child: const Icon(Icons.filter_alt_outlined),
      ),
      bottomSheet: Container(
        height: 50,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TOTAL',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(width: 15),
            Text(
              'Kshs.',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(width: 15),
            Text(
              NumberFormat('#,##0.00').format(n.totalNonPosted(nonPost)),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future refreshLocalSrc() async {
    await showDialog(
      barrierColor: Colors.black38,
      context: context,
      barrierDismissible: false,
      builder: (_) => const RefreshLocalSrc(),
    );

    setState(() {
      nonPost = n.nonPostedItemsList;
    });
  }

  Future uploadNonPosted(List<Item> items) async {
    await showDialog(
      barrierColor: Colors.black38,
      context: context,
      barrierDismissible: false,
      builder: (_) => NonPostedUploadProgress(locals: items),
    );
  }

  Future filterBottomSheet(BuildContext cxt) async {
    showModalBottomSheet(
      context: cxt,
      builder: (context) {
        return FilterBottomSheet(onFilter: filterItems);
      },
    );
  }

  void filterItems(String filterId) {
    switch (filterId) {
      case 'all':
        setState(() {
          nonPost = n.nonPostedItemsList;
        });
        break;
      case 'missing':
        setState(() {
          nonPost = n.missingItems;
        });
        break;
      case 'excess':
        setState(() {
          nonPost = n.excessItems;
        });
        break;
      case 'intact':
        setState(() {
          nonPost = n.intactItems;
        });
        break;
    }
  }
}






// Card(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 5,
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 15),
//                         Text(
//                           nonPost[index].name,
//                           style:
//                               Theme.of(context).textTheme.titleMedium!.copyWith(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 16,
//                                   ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 3,
//                             vertical: 12,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Expected Stock: ${nonPost[index].expectedCount}',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleMedium!
//                                         .copyWith(
//                                           fontWeight: FontWeight.w400,
//                                           fontSize: 13,
//                                         ),
//                                   ),
//                                   const SizedBox(height: 15),
//                                   Text(
//                                     'Last Stock: ${nonPost[index].lastCount}',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleMedium!
//                                         .copyWith(
//                                           fontWeight: FontWeight.w400,
//                                           fontSize: 13,
//                                         ),
//                                   ),
//                                   const SizedBox(height: 15),
//                                   Text(
//                                     "Today's Stock: ${nonPost[index].recentCount}",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleMedium!
//                                         .copyWith(
//                                           fontWeight: FontWeight.w400,
//                                           fontSize: 13,
//                                         ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(width: 15),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Total Purchases: ${nonPost[index].purchases}',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleMedium!
//                                         .copyWith(
//                                           fontWeight: FontWeight.w400,
//                                           fontSize: 12,
//                                         ),
//                                   ),
//                                   const SizedBox(height: 15),
//                                   Text(
//                                     'Total Sales: ${nonPost[index].sales}',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleMedium!
//                                         .copyWith(
//                                           fontWeight: FontWeight.w400,
//                                           fontSize: 13,
//                                         ),
//                                   ),
//                                   const SizedBox(height: 15),
//                                   _buildButton(nonPost[index]),
//                                 ],
//                               ),
//                               const SizedBox(height: 5),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                       ],
//                     ),
//                   ),
//                 )