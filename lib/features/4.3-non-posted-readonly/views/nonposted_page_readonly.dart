import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../entities/cloud_nonposted.dart';
import '../services/non_posted_mixin.dart';
import '../services/non_posted_service_rd.dart';
import '../widgets/filter_bottomsheet_rd.dart';
import '../widgets/nonpost_tile_rd.dart';

class NonPostedListPage extends StatefulWidget {
  const NonPostedListPage({super.key});

  @override
  State<NonPostedListPage> createState() => _NonPostedListPageState();
}

class _NonPostedListPageState extends State<NonPostedListPage>
    with NonPostedMixin {
  final NonPostRemoteDataSrcRd n = NonPostRemoteDataSrcRd();
  late final Stream<List<CloudNonPosted>> missing;
  late final Stream<List<CloudNonPosted>> excess;
  late final Stream<List<CloudNonPosted>> intact;
  late Stream<List<CloudNonPosted>> nonpostedItems;

  @override
  void initState() {
    nonpostedItems = n.nonpostStream();
    missing = n.missingStream();
    excess = n.excessStream();
    intact = n.intactStream();
    createFilter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<CloudNonPosted> non = [];
    return Scaffold(
      body: StreamBuilder(
        stream: nonpostedItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final nonPost = snapshot.data as List<CloudNonPosted>;
              non = nonPost;

              if (nonPost.isEmpty) {
                return _emptySkeleton(context);
              }

              return CustomScrollView(
                slivers: [
                  SliverAppBar.medium(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    title: const Text('Non Posted Sales'),
                    centerTitle: true,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    titleTextStyle:
                        Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.cloud_download_outlined),
                        onPressed: () {
                          exportToCsv(context, nonPost);
                        },
                      ),
                    ],
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(50),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'TOTAL',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Kshs.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  NumberFormat('#,##0.00')
                                      .format(totalForAllItems(non)),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                    sliver: SliverList.builder(
                      itemCount: nonPost.length,
                      itemBuilder: (context, index) {
                        nonPost.sort((a, b) => a.name.compareTo(b.name));
                        return NonpostTile(nonPost: nonPost[index]);
                      },
                    ),
                  ),
                ],
              );
            } else {
              return _emptySkeleton(context);
            }
          } else {
            return CustomScrollView(
              slivers: [
                SliverAppBar.medium(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  title: const Text('Non Posted Sales'),
                  centerTitle: true,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  titleTextStyle:
                      Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 75,
                        width: 75,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Fetching data...',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => non.isEmpty ? null : filterBottomSheet(context),
        child: const Icon(Icons.filter_alt_outlined),
      ),
    );
  }

  Future filterBottomSheet(BuildContext cxt) async {
    showModalBottomSheet(
      showDragHandle: true,
      context: cxt,
      builder: (context) {
        return FilterRd(onFilter: filterItems);
      },
    );
  }

  void filterItems(String filterId) {
    switch (filterId) {
      case 'all':
        setState(() {
          nonpostedItems = n.nonpostStream();
        });
        break;
      case 'missing':
        setState(() {
          nonpostedItems = missing;
        });
        break;
      case 'excess':
        setState(() {
          nonpostedItems = excess;
        });
        break;
      case 'intact':
        setState(() {
          nonpostedItems = intact;
        });
        break;
    }
  }

  Widget _emptySkeleton(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Non Posted Sales'),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
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
        const SliverFillRemaining(
          child: Center(
            child: Text('Non posted sales list is empty'),
          ),
        ),
      ],
    );
  }
}
