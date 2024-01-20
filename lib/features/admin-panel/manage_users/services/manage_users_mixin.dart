// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../../global/helpers/snacks.dart';
import '../../../../services/cloud/cloud_storage_exceptions.dart';
import '../../../../services/cloud/cloud_storage_services.dart';

mixin ManageUsersMixin {
  // Update User preivileges
  Future<void> updateUserPrivileges(
      {required BuildContext context,
      required String userId,
      required String role}) async {
    try {
      await FirestoreUsers().updateUserPrivileges(userId: userId, role: role);
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
