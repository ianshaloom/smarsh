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
    // showModalBottomSheet(
    //     context: cxt,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     builder: (context) => Container(
    //           padding: EdgeInsets.only(
    //             bottom: MediaQuery.of(context).viewInsets.bottom,
    //             left: 10,
    //           ),
    //           //height: 100,
    //           child: Padding(
    //             padding: const EdgeInsets.only(top: 5, bottom: 15.0, right: 4),
    //             child: Row(
    //               children: [
    //                 Flexible(
    //                     fit: FlexFit.tight,
    //                     child: TextField(
    //                       controller: passController,
    //                       decoration: InputDecoration(
    //                         hintText: 'Enter Password',
    //                         border: OutlineInputBorder(
    //                           borderRadius: BorderRadius.circular(10),
    //                         ),
    //                       ),
    //                     )),
    //                 IconButton(
    //                   icon: const Icon(Icons.check),
    //                   onPressed: () {
    //                     if (passController.text == 'admin') {
    //                       passController.clear();
    //                       Navigator.pop(context);
    //                       Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                               builder: (context) => const AdminPanel()));
    //                     }
    //                   },
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ));
  }
}
