// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../../global/helpers/snacks.dart';
import '../../../../services/cloud/cloud_product.dart';
import '../../../../services/cloud/cloud_storage_exceptions.dart';
import '../../../../services/cloud/firebase_cloud_storage.dart';
import '../widgets/clear_cloud_product_progress.dart';

mixin ManageUserMixin {
  Stream<int> clearingPr(BuildContext context) async* {
    List<CloudProduct> products = await FirebaseCloudStorage().getAllStock();
    try {
      for (int i = 0; i < products.length; i++) {
        final CloudProduct product = products[i];
        await FirebaseCloudStorage()
            .deleteProduct(documentId: product.documentId);

        // pop context on last iteration
        yield ((i / products.length) * 100).round();
      }
    } on CouldNotDeleteException {
      Snack().showSnackBar(
          context: context, message: 'Could not delete from cloud');
    }
  }

  // confirm Clear dialog
  Future<void> confirmClearDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cloud Products'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Are you sure you want to clear all products from the cloud?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Clear'),
              onPressed: () async {
                Navigator.of(context).pop();
                await showDialog(
                    barrierColor: Colors.black38,
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const ClearCloudProductProgress());
              },
            ),
          ],
        );
      },
    );
  }

  // Update User preivileges
  Future<void> updateUserPrivileges(
      {required BuildContext context,
      required String userId,
      required String role}) async {
    try {
      await FirebaseCloudUsers()
          .updateUserPrivileges(userId: userId, role: role);
      Snack().showSnackBar(
          context: context, message: 'User privileges updated successfully');
    } on CouldNotUpdateException {
      Snack().showSnackBar(
          context: context, message: 'Could not update user privileges');
    }
  }

  // delete user
  Future<void> deleteUser(
      {required BuildContext context, required String userId}) async {
    try {
      // await FirebaseCloudUsers().deleteUser(documentId: userId);
      Snack()
          .showSnackBar(context: context, message: 'User deleted successfully');
    } on CouldNotDeleteException {
      Snack().showSnackBar(context: context, message: 'Could not delete user');
    }
  }
}
