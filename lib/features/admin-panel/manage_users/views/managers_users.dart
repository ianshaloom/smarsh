// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../../services/cloud/cloud_entities.dart';
import '../../../../services/cloud/cloud_storage_exceptions.dart';
import '../../../../services/cloud/cloud_storage_services.dart';
import '../services/manage_users_mixin.dart';
import '../widgets/manage_user_tile.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage>
    with ManageUsersMixin {
  late final FirestoreUsers _cloudUsers;

  @override
  void initState() {
    _cloudUsers = FirestoreUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Manage Users'),
            centerTitle: true,
            titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            sliver: FutureBuilder(
                future: _cloudUsers.getAllUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<CloudUser> users = snapshot.data as List<CloudUser>;
                      users.sort((a, b) => a.username.compareTo(b.username));

                      return SliverList.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return ManageUsersTile(
                            user: users[index],
                            onTap: _onTap,
                          );
                        },
                      );
                    } else {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            'Your users list is empty',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }
                  } else {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  void _onTap(BuildContext cxt, CloudProduct product) {
    showModalBottomSheet(
      context: cxt,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(top: 20, left: 20),
          height: 130,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.of(context).pop();
                  // _editDialog(context, product);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  _deleteProduct(product);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteProduct(CloudProduct model) async {
    // delete product
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: Dialog(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: const Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16.0),
                  Text('Deleting Product...'),
                ],
              ),
            ),
          ),
        ),
      );

      await _cloudUsers.deleteUser(documentId: model.documentId);
    } catch (e) {
      throw CouldNotDeleteException;
    }
  }
}

class ProductModel {
  String productId;

  String productName;

  double buyingPrice;

  double sellingPrice;

  int stockCount;

  // required constructor
  ProductModel({
    required this.productId,
    required this.productName,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.stockCount,
  });
}
