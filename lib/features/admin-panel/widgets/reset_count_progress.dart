import 'package:flutter/material.dart';

import '../service/admin_mixin.dart';

class ResetProgress extends StatefulWidget {
  const ResetProgress({super.key});

  @override
  State<ResetProgress> createState() => _ResetProgressState();
}

class _ResetProgressState extends State<ResetProgress> with AdminMixin {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: resetingC(),
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
                  'Reseting counts...',
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
