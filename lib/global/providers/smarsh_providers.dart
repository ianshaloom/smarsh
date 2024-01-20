import 'package:flutter/material.dart';

import '../../features/2-Authentification/2-authentification/services/auth_service.dart';
import '../../features/2-Authentification/constants.dart';
import '../../services/cloud/cloud_entities.dart';
import '../../services/cloud/cloud_storage_services.dart';

class AppProviders with ChangeNotifier {
  bool _isAdmin = false;
  CloudUser? _userr;

  bool get isAdmin => _isAdmin;
  CloudUser? get user {
    if (_userr == null) {
      return CloudUser(
        userId: 'userId',
        username: 'Username',
        email: 'info@smarsh.com',
        role: 'user',
        url: authUserProfilePicture,
        signInProvider: 'google',
        color: 'green',
      );
    }
    return _userr;
  }

  Future toggleAdmin() async {
    final user = await FirestoreUsers()
        .singleUser(documentId: AppService.firebase().currentUser!.id);

    if (user == CloudUser.empty ) {
      _isAdmin = false;
    } else {
      _userr = user;
      user.role == 'admin' ? _isAdmin = true : _isAdmin = false;
    }
  }
}
