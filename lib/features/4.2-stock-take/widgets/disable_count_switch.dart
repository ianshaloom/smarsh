import 'package:flutter/material.dart';

import '../services/stock_take_cloud_service.dart';

class DisableStockTake extends StatefulWidget {
  const DisableStockTake({super.key});

  @override
  State<DisableStockTake> createState() => _DisableStockTakeState();
}

class _DisableStockTakeState extends State<DisableStockTake> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        initialData: false,
        future: FirebaseCloudApp().isStockTakeDisabled('stock-take'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final bool isDisabled = snapshot.data as bool;

              //return switch
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Disable Counting',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Switch(
                      value: isDisabled,
                      onChanged: (value) {
                        setState(() {
                          _toggleSwitch(value);
                        });
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text(
                  'An Error Occured',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              );
            }
          } else {
            return Center(
              child: Text(
                'More Actions',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            );
          }
        });
  }

  Future<void> _toggleSwitch(bool value) async {
    if (value) {
      await FirebaseCloudApp().disableStockTake('stock-take');
    } else {
      await FirebaseCloudApp().enableStockTake('stock-take');
    }
  }
}
