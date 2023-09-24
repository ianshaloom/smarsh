import 'package:flutter/material.dart';

class ImportedSales extends StatelessWidget {
  const ImportedSales({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.medium(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Imported Sales'),
          centerTitle: true,
          titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 28,
              ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          bottom: PreferredSize(
            preferredSize:
                const Size.fromHeight(55.0), // Set your desired height
            child: Container(
              margin: const EdgeInsets.only(
                left: 16,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                'Adding new products, managing products, importing and exporting data',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
              ),
            ),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16),
        )
      ],
    );
  }
}
