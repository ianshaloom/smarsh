// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../../services/cloud/cloud_product.dart';
import '../services/manage_user_mixin.dart';
import 'role_segmented_button.dart';

class ManageStockTile extends StatelessWidget with ManageUserMixin {
  final CloudUser user;
  final Function onTap;

  const ManageStockTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image(
                    image: NetworkImage(
                      user.url,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 19),
                      ),
                      Text(
                        user.email,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                      ),
                      Text(
                        'Assigned Color || ${user.color}',
                        softWrap: true,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Flexible(child: SelectRole(user: user)),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: () async {
                      await confirmDelection(user.userId, context);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // confirm delete user
  Future<void> confirmDelection(String userId, BuildContext context) async {
    final bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this user?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirm) {
      deleteUser(userId: userId, context: context);
    }
  }
}
