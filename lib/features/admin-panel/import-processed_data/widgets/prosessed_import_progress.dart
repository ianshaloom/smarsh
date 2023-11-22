import 'package:flutter/material.dart';

import '../../../../global/helpers/snacks.dart';
import '../../../../services/cloud/cloud_product.dart';
import '../services/processed_data_mixin.dart';

class ProcessedImportProgress extends StatefulWidget {
  final List<CloudProduct> products;
  const ProcessedImportProgress({super.key, required this.products});

  @override
  State<ProcessedImportProgress> createState() =>
      _ProcessedImportProgressState();
}

class _ProcessedImportProgressState extends State<ProcessedImportProgress>
    with ProcessedDataMixin {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: importingPr(widget.products, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            int progress = snapshot.data!;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 75,
                  width: 75,
                  child: CircularProgressIndicator(
                    value: progress / 100,
                    color: Theme.of(context).colorScheme.primary,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Uploading...',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            Snack().showSnackBar(
                context: context, message: 'Error importing processed data');
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 75,
                  width: 75,
                  child: Icon(
                    Icons.error,
                    size: 65,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text(
                    'Cancel Process',
                  ),
                ),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 75,
                  width: 75,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Fetching Data...',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                ),
              ],
            );
          }
        } else if (snapshot.connectionState == ConnectionState.done) {
          Navigator.pop(context);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 75,
                width: 75,
                child: CircularProgressIndicator(
                  value: 1,
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Done',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
              ),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 75,
                width: 75,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Fetching Data...',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
              ),
            ],
          );
        }
      },
    );
  }

  Stream<int> get stream => Stream.periodic(
        const Duration(milliseconds: 100),
        (i) => i,
      ).take(100);
}
