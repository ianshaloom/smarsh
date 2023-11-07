import 'package:flutter/material.dart';
import 'package:smarsh/features/2-Authentification/2-authentification/services/auth_service.dart';
import 'package:smarsh/services/cloud/firebase_cloud_storage.dart';

class AppProviders with ChangeNotifier {
  bool _isDarkMode = false;
  bool _isAdmin = false;

  bool get isDarkMode => _isDarkMode;
  bool get isAdmin => _isAdmin;


  void toggleAdmin() async{
    final user = await FirebaseCloudUsers().singleUser(documentId: AppService.firebase().currentUser!.id);
    user!.role == 'admin' ? _isAdmin = true : _isAdmin = false;
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}