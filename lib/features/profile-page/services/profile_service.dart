import 'package:flutter/material.dart';

import '../../../services/cloud/cloud_entities.dart';
import '../../../services/cloud/cloud_storage_services.dart';
import '../../2-Authentification/2-authentification/services/auth_service.dart';

class ProfileProvida with ChangeNotifier {
  String _avatar = '';
  String _color = '';
  CloudUser _cloudUser = CloudUser.empty;

  String get avatar => _avatar;
  String get color => _color;
  CloudUser get cloudUser => _cloudUser;

  set avatar(String avatar) {
    _avatar = avatar;
    notifyListeners();
  }

  set color(String color) {
    _color = color;
    notifyListeners();
  }

  set cloudUser(CloudUser cloudUser) {
    _cloudUser = cloudUser;
    notifyListeners();
  }

  // update firebase user avatar
  void updateAvatar(String url, String userId) async {
    final avatar =
        await FirestoreUsers().updateUserAvatarUrl(userId: userId, url: url);

    _avatar = avatar;
    notifyListeners();
  }

  // update firebase user color
  void updateColor(String color, String userId) async {
    final colorUpdate =
        await FirestoreUsers().updateUserColor(userId: userId, color: color);

    _color = colorUpdate;
    _getCloudUser();
    notifyListeners();
  }

  // get cloud user with userId
  void _getCloudUser() async {
    final user = await FirestoreUsers()
        .singleUser(documentId: AppService.firebase().currentUser!.id);

    final cloudUser =
        await FirestoreUsers().singleUser(documentId: user.userId);

    _cloudUser = cloudUser;
    notifyListeners();
  }

  /* ProfileProvida() {
    FirestoreUsers().singleUser(documentId: documentId).then((value) {
      _avatar = value;
      notifyListeners();
    });
  } */
}
