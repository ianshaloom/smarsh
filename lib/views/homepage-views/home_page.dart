import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smarsh/constants/hive_constants.dart';

import '../../services/hive/models/user_model/user_model.dart';
import '../managestore-views/manage_store.dart';
import '../profile-views/profile_page.dart';
import 'stock_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.of(context).size;

    return ValueListenableBuilder(
      valueListenable: HiveBoxes.getHiveUserBox().listenable(),
      builder: (context, Box<HiveUser> box, _) {
        //GoogleService.google().logOut();
        if (box.values.isEmpty) {
          return const Scaffold(
            body: Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          final user = box.getAt(0)!;

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar.medium(
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  stretch: false,
                  centerTitle: true,
                  //expandedHeight: 80,
                  collapsedHeight: 150,
                  flexibleSpace: Container(
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(user.url!, scale: 0.1),
                              radius: 25,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              user.name!,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () async {
                            // final provider = Provider.of<GoogleAuthProvide>(context,
                            //     listen: false);
                            // provider.signOut();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          },
                          // onPressed: () {
                          //   HiveUser userFromHive = GetMeFromHive.getHiveUser!;
                          //   print(userFromHive.name!);
                          // },
                          icon: Icon(
                            Icons.menu,
                            color: color.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/images/count_product.svg',
                                      height: screenSize.width * 0.3,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  'Get to work with numbers',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  //width: MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    'Launch the stock take page to count your store\'s stock,'
                                    'and get final detailed item count',
                                    textAlign: TextAlign.justify,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: FilledButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              //builder: (context) => const StockTakePage(),
                                              builder: (context) =>
                                                  const Placeholder(),
                                            ),
                                          );
                                        },
                                        style: FilledButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          minimumSize:
                                              const Size.fromHeight(60),
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .copyWith(
                                                fontSize: 17,
                                              ),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Start Stock Take',
                                            ),
                                            SizedBox(width: 20),
                                            Icon(Icons.arrow_forward_ios)
                                          ],
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/images/manage_store.svg',
                                      height: screenSize.width * 0.3,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  'Organize your store',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  //width: MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    'Manage product items,'
                                    'view your store\'s reports'
                                    'export and import your store\'s data',
                                    textAlign: TextAlign.justify,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: FilledButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ManageStorePAge(),
                                            ),
                                          );
                                        },
                                        style: FilledButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          minimumSize:
                                              const Size.fromHeight(60),
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .copyWith(
                                                fontSize: 17,
                                              ),
                                        ),
                                        child: const Text(
                                          'Manage Store',
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 2,
              //mini: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StockListPage(),
                    //builder: (context) => const Placeholder(),
                  ),
                );
              },
              child: const Icon(
                Icons.view_list_outlined,
                size: 35,
              ),
            ),
          );
        }
      },
    );
  }
}
