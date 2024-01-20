import 'package:flutter/cupertino.dart';

import '../../../services/cloud/cloud_entities.dart';

class HomePageProvida with ChangeNotifier {

  CloudUser _user = CloudUser.empty;

  // getters
  CloudUser get getUser => _user;

  //setters
  set setUser(CloudUser user) {
    _user = user;
  }

}