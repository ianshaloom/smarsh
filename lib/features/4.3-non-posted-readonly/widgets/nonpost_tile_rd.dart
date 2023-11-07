import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../global/providers/smarsh_providers.dart';
import '../entities/cloud_nonposted.dart';
import '../services/non_posted_mixin.dart';
import '../views/edit_nonposted_iem.dart';

class NonpostTile extends StatelessWidget with NonPostedMixin {
  final CloudNonPosted nonPost;
  NonpostTile({super.key, required this.nonPost});

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = context.read<AppProviders>().isAdmin;

    return GestureDetector(
      onTap: isAdmin ? () => _showEditDialog(context) : null,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Text(
                nonPost.name,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      // fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 3,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Stock: ${lastStockTake(nonPost.id)}',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Expected Stock: ${nonPost.expectedCount}',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Today's Stock: ${nonPost.recentCount}",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        _buildButton(nonPost, context),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              'Kshs.',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              NumberFormat('#,##0.00')
                                  .format(nonPost.totalNonPosted),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(CloudNonPosted i, BuildContext context) {
    final int total = i.recentCount - i.expectedCount;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: total == 0
            ? Colors.grey
            : total > 0
                ? Colors.green
                : Colors.red,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        'Non-Posted: $total',
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: Theme.of(context).colorScheme.surface,
            ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
  ) {
    showDialog(
        context: context, builder: (_) => EditNonpostItem(model: nonPost));
  }
}
