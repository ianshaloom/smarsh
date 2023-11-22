import 'package:flutter/material.dart';

import '../entities/cloud_nonposted.dart';

class NonpostTile extends StatelessWidget {
  final CloudNonPost nonPost;
  const NonpostTile({super.key, required this.nonPost});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      borderOnForeground: true,
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
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
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
                        'Expected Stock: ${nonPost.expectedCount}',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),
                      ),
                      const SizedBox(height: 15),
                      /*Text(
                        'Last Stock: ${nonPost.lastCount}',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),
                      ),
                      const SizedBox(height: 15),*/
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
                      /*Text(
                        'Total Purchases: ${nonPost.purchases}',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                      ),*/
                      const SizedBox(height: 15),
                      Text(
                        'Total: ${nonPost.totalNonPosted}',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),
                      ),
                      const SizedBox(height: 15),
                      _buildButton(nonPost, context),
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
    );
  }

  Widget _buildButton(CloudNonPost i, BuildContext context) {
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
            ),
      ),
    );
  }
}
