import 'package:flutter/material.dart';

import '../entities/non_post_item.dart';
import '../services/non_posted_mixin.dart';

class NonPostedUploadProgress extends StatefulWidget {
  final List<Item> locals;
  const NonPostedUploadProgress({super.key, required this.locals});

  @override
  State<NonPostedUploadProgress> createState() =>
      _NonPostedUploadProgressState();
}

class _NonPostedUploadProgressState extends State<NonPostedUploadProgress>
    with NonPostedMixin {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: uploadingNp(widget.locals),
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
            // indicate error
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'An error occured while uploading data',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                ),
                SizedBox(
                  height: 75,
                  width: 75,
                  child: Icon(
                    Icons.error,
                    size: 50,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () {
                    // pop the dialog
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  label: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
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
