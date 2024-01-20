import 'package:flutter/material.dart';

import '../../4.2-stock-take/views/stock_take_page.dart';
import '../../4.3-non-posted-readonly/views/nonposted_page_readonly.dart';
import '../../admin-panel/admin_panel.dart';
import '../../4.1-stock-list/views/stock_list_page.dart';

class HomeMixin {
  // factory constructor
  HomeMixin._privateConstructor();
  static final HomeMixin _instance = HomeMixin._privateConstructor();
  factory HomeMixin() => _instance;

  // Navigations
  void navigateToStockTake(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => StockTakePage()));
  }

  void navigateToStockList(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const StockListPage()));
  }

  void navigateToAdminPanel(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AdminPanel()));
  }

  void navigateToNonPosted(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const NonPostedListPage()));
  }

  final passController = TextEditingController();
  void switchToAdmin(BuildContext cxt) {
    Navigator.push(
        cxt, MaterialPageRoute(builder: (context) => const AdminPanel()));
  }
}
