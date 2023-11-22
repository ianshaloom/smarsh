// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../global/helpers/snacks.dart';
import '../../../services/cloud/cloud_storage_exceptions.dart';
import '../entities/cloud_nonposted.dart';
import '../services/non_posted_service_rd.dart';
import '../widgets/edit_textfield.dart';

class EditNonpostItem extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final expectedController = TextEditingController();
  final currentController = TextEditingController();
  final CloudNonPosted model;

  EditNonpostItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    expectedController.text = model.expectedCount.toString();
    currentController.text = model.recentCount.toString();

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 350,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                model.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        EditTextFormField(
                            controller: expectedController,
                            labelText: 'Expected Count'),
                        const SizedBox(height: 20),
                        EditTextFormField(
                            controller: currentController,
                            labelText: 'Current Count'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final form = formKey.currentState!;

                            if (form.validate()) {
                              final int expectedCount =
                                  int.parse(expectedController.text.trim());
                              final int recentCount =
                                  int.parse(currentController.text.trim());

                              await updateNonpostItem(
                                expectedCount: expectedCount,
                                recentCount: recentCount,
                                context: context,
                              );
                            } else {}
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateNonpostItem(
      {required int expectedCount,
      required int recentCount,
      required BuildContext context}) async {
    try {
      await NonPostRemoteDataSrcRd().updateNonPosted(
        id: model.id,
        expectedCount: expectedCount,
        recentCount: recentCount,
      );

      Snack().cloudSuccess(1, context);
    } on CouldNotUpdateException {
      Snack().cloudError(2, context);
    }
  }
}
