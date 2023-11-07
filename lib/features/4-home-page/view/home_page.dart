import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smarsh/features/2-Authentification/constants.dart';

import '../../../constants/svg_constants.dart';
import '../../../global/providers/smarsh_providers.dart';
import '../../2-Authentification/2-authentification/services/auth_service.dart';
import '../../../services/cloud/cloud_product.dart';
import '../../../services/cloud/firebase_cloud_storage.dart';
import '../../profile-page/views/profile_page.dart';
import '../service/home_mixin.dart';
import '../service/home_service.dart';
import '../widget/homepage_tile.dart';
import '../../4.2-stock-take/views/stock_take_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.of(context).size;
    final String uid = AppService.firebase().currentUser!.id;
    context.read<AppProviders>().toggleAdmin();
    _localData.getProducts(context);
    final CloudUser cloudUser = CloudUser(
        userId: 'userId',
        username: 'Username',
        email: 'info@nedak.com',
        role: 'user',
        url: authUserProfilePicture,
        signInProvider: 'google');

    return Scaffold(
      body: StreamBuilder(
        initialData: cloudUser,
        stream: FirebaseCloudUsers().singleUserStream(documentId: uid),
        builder: (context, snapshot) {
          //
          if (snapshot.connectionState == ConnectionState.active) {
            //
            if (snapshot.hasData) {
              //
              final CloudUser cloudUser = snapshot.data as CloudUser;

              return CustomScrollView(
                slivers: [
                  SliverAppBar.medium(
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    stretch: false,
                    centerTitle: true,
                    //expandedHeight: 80,
                    collapsedHeight: 120,
                    flexibleSpace: Container(
                      margin: const EdgeInsets.only(left: 10, top: 10),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  cloudUser.url,
                                ),
                                radius: 25,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                cloudUser.username,
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
                                  builder: (context) =>
                                      ProfilePage(cloudUser: cloudUser),
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
                    padding: const EdgeInsets.symmetric(horizontal: 6),
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
                                        height: screenSize.height * 0.2,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Get to work with numbers',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    //width: MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      'Launch the stock take page to count your store\'s stock,'
                                      'and get final detailed item count',
                                      textAlign: TextAlign.justify,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: FilledButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    StockTakePage(),
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
                                            // textStyle: Theme.of(context)
                                            //     .textTheme
                                            //     .labelLarge!
                                            //     .copyWith(
                                            //       fontSize: 17,
                                            //     ),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Start Stock Take',
                                              ),
                                              SizedBox(width: 40),
                                              Icon(Icons.arrow_forward_ios)
                                            ],
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: HomePageTile(
                                    onTap: _home.navigateToNonPosted,
                                    title: 'Non-Posted',
                                    svg: noteSvg,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: HomePageTile(
                                    onTap: _home.switchToAdmin,
                                    title: 'Admin Panel',
                                    svg: adminSvg,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: SizedBox(
                  height: 75,
                  width: 75,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
            }
          } else {
            return Center(
              child: SizedBox(
                height: 75,
                width: 75,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        //mini: true,
        onPressed: () => _home.navigateToStockList(context),
        // onPressed: () async {
        //   CloudProduct created = await FirebaseCloudStorage().createProduct(
        //     documentId: 'C7L0JYO9R9',
        //     productName: 'CARIBEAN GIN 250ML',
        //     buyingPrice: 208,
        //     sellingPrice: 255,
        //     stockCount: 16,
        //   );
        // },
        child: const Icon(
          Icons.view_list_outlined,
          size: 35,
        ),
      ),
    );
  }
}

final HomeMixin _home = HomeMixin();
final NonPostLocalDataSrcRd _localData = NonPostLocalDataSrcRd();
