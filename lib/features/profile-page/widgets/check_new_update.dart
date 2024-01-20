import 'package:flutter/material.dart';

class UpdateWidgetDialog extends StatelessWidget {
  const UpdateWidgetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      child: Container(
        height: 200,
        // width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: FutureBuilder<bool>(
            future: _check,
            initialData: true,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  final bool isThereNewUpdate = snapshot.data!;

                  if (isThereNewUpdate) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ),
                        Text(
                          'New Update Available',
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Download'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Realase Notes'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Text(
                            'You are running the latest version',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    );
                  }
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Sorry, we are having trouble checking for updates. Please try again later.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  );
                }
              } else {
                return Center(
                  child: SizedBox(
                    height: 75,
                    width: 75,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }

  Future<bool> get _check async {
    await Future.delayed(const Duration(seconds: 2), () {
      return true;
    });
    return true;
  }
}
