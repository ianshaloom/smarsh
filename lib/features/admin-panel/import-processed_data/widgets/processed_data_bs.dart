import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../services/hive/models/local_product_model/local_product_model.dart';
import '../services/processed_data_mixin.dart';

class ProcessedMoreBs extends StatelessWidget with ProcessedDataMixin {
  final List<LocalProduct> cloudStock;
  const ProcessedMoreBs({
    super.key,
    required this.cloudStock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.clear_all_rounded),
            title: const Text('Clear above list'),
            onTap: () {
              Navigator.pop(context);
              clearProcessed(context);
            },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.cloud_upload),
            title: const Text('Upload to cloud'),
            onTap: () async {
              // Navigator.pop(context);
              confirmUpload(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.clear_all_rounded),
            title: const Text('Clear cloud processed data'),
            onTap: () {
              // Navigator.pop(context);
              confirmClear(context);
            },
          ),
        ],
      ),
    );
  }
}
